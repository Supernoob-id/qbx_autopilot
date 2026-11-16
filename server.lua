local QBCore = exports['qb-core']:GetCoreObject()

-- Event when the player uses the item
QBCore.Functions.CreateUseableItem('autopilot_chip', function(source, item)
    TriggerClientEvent('ox_autopilot:client:bukaMenu', source)
end)
