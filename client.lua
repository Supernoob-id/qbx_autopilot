-- Autopilot with on-screen mode selector (no item, no ox_lib menu)
--   Double-tap W         = open selector
--   W / S                = move up / down
--   Enter                = confirm mode
--   Backspace            = cancel selector
--   Tap W while active   = stop autopilot

local Config = {
    TapWindow  = 400,  -- ms allowed between the two W taps
    MaxTapHold = 250,  -- ms; longer presses count as normal driving
    ArriveDist = 20.0, -- meters; stop at destination
    SlowDist   = 30.0, -- meters; start braking
}

local Modes = {
    { name = 'Normal',   desc = 'Obeys traffic (~60 km/h)',    style = 267,        speed = 16.0 },
    { name = 'Fast',     desc = 'Quick but careful (~100 km/h)', style = 1074266123, speed = 28.0 },
    { name = 'Reckless', desc = 'Ignores all rules (~160 km/h)', style = 2883621,    speed = 45.0 },
}

local KEY_W, KEY_S       = 71, 72   -- INPUT_VEH_ACCELERATE / INPUT_VEH_BRAKE
local KEY_ENTER          = 191      -- INPUT_FRONTEND_RDOWN
local KEY_BACK           = 194      -- INPUT_FRONTEND_RRIGHT (Backspace)

local autopilotActive = false
local selectorOpen    = false
local selectedIndex   = 1

local function notify(desc, typ)
    lib.notify({ title = 'Autopilot', description = desc, type = typ or 'inform' })
end

local function drawText(x, y, text, scale, r, g, b, a, center)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextOutline()
    SetTextCentre(center or false)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayText(x, y)
end

local function drawSelector()
    local x, y, w = 0.85, 0.35, 0.22
    local rowH = 0.045
    local h = 0.06 + #Modes * rowH + 0.035

    DrawRect(x, y + h / 2, w, h, 10, 10, 10, 190)
    drawText(x, y + 0.008, 'AUTOPILOT', 0.55, 255, 255, 255, 255, true)

    for i, mode in ipairs(Modes) do
        local rowY = y + 0.06 + (i - 1) * rowH
        local active = i == selectedIndex
        if active then
            DrawRect(x, rowY + rowH / 2, w - 0.01, rowH - 0.004, 40, 140, 255, 200)
        end
        drawText(x - w / 2 + 0.012, rowY + 0.002, mode.name, 0.42, 255, 255, 255, 255)
        drawText(x - w / 2 + 0.012, rowY + 0.022, mode.desc, 0.30, 200, 200, 200, active and 255 or 170)
    end

    drawText(x, y + h - 0.03, '~b~W/S~s~ Select  ~g~Enter~s~ Confirm  ~r~Back~s~ Cancel', 0.30, 255, 255, 255, 255, true)
end

local function StopAutopilot(reason, typ)
    if not autopilotActive then return end
    autopilotActive = false
    ClearPedTasks(PlayerPedId())
    notify(reason or 'Autopilot disabled.', typ or 'error')
end

local function StartAutopilot(mode)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)
    if veh == 0 or GetPedInVehicleSeat(veh, -1) ~= ped then return end

    local blip = GetFirstBlipInfoId(8)
    if not DoesBlipExist(blip) then
        notify('Set a waypoint on the map first!', 'warning')
        return
    end

    local coords = GetBlipInfoIdCoord(blip)
    autopilotActive = true
    notify(('Autopilot active - %s mode.'):format(mode.name), 'success')

    SetDriverAbility(ped, 1.0)
    SetDriverAggressiveness(ped, mode.name == 'Reckless' and 1.0 or 0.0)
    TaskVehicleDriveToCoordLongrange(ped, veh, coords.x, coords.y, coords.z, mode.speed, mode.style, 5.0)

    CreateThread(function()
        while autopilotActive do
            Wait(500)
            if GetVehiclePedIsIn(ped, false) ~= veh then
                StopAutopilot('You left the vehicle. Autopilot disabled.')
                break
            end

            local dist = #(GetEntityCoords(ped) - coords)
            if dist < Config.SlowDist then
                BringVehicleToHalt(veh, 5.0, 1, false)
            end
            if dist < Config.ArriveDist then
                SetVehicleHandbrake(veh, true)
                Wait(1000)
                SetVehicleHandbrake(veh, false)
                StopAutopilot('You have arrived. Autopilot disabled.', 'success')
                break
            end
        end
    end)
end

local function handleSelector()
    DisableControlAction(0, KEY_W, true)
    DisableControlAction(0, KEY_S, true)
    DisableControlAction(0, KEY_BACK, true)
    DisableControlAction(0, 200, true) -- pause menu (ESC)

    drawSelector()

    if IsDisabledControlJustPressed(0, KEY_W) then
        selectedIndex = selectedIndex > 1 and selectedIndex - 1 or #Modes
    elseif IsDisabledControlJustPressed(0, KEY_S) then
        selectedIndex = selectedIndex < #Modes and selectedIndex + 1 or 1
    elseif IsControlJustPressed(0, KEY_ENTER) then
        selectorOpen = false
        StartAutopilot(Modes[selectedIndex])
    elseif IsDisabledControlJustPressed(0, KEY_BACK) or IsDisabledControlJustPressed(0, 200) then
        selectorOpen = false
    end
end

CreateThread(function()
    local tapCount, lastTap, pressStart = 0, 0, 0

    while true do
        local ped = PlayerPedId()
        local veh = GetVehiclePedIsIn(ped, false)

        if veh ~= 0 and GetPedInVehicleSeat(veh, -1) == ped then
            Wait(0)
            local now = GetGameTimer()

            if selectorOpen then
                handleSelector()

            elseif autopilotActive then
                if IsControlJustPressed(0, KEY_W) then
                    StopAutopilot()
                end

            else
                if IsControlJustPressed(0, KEY_W) then
                    pressStart = now
                end

                if IsControlJustReleased(0, KEY_W) and pressStart > 0 then
                    if now - pressStart <= Config.MaxTapHold then
                        tapCount = (now - lastTap <= Config.TapWindow) and tapCount + 1 or 1
                        lastTap = now
                        if tapCount >= 2 then
                            selectorOpen, selectedIndex, tapCount = true, 1, 0
                        end
                    else
                        tapCount = 0
                    end
                    pressStart = 0
                end

                if tapCount > 0 and now - lastTap > Config.TapWindow then
                    tapCount = 0
                end
            end
        else
            if autopilotActive then StopAutopilot() end
            selectorOpen, tapCount, pressStart = false, 0, 0
            Wait(500)
        end
    end
end)
