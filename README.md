# qbx_autopilot

A FiveM / GTA V autopilot resource designed for waypoint driving with a quick on-screen mode selector.

Created by: Supernoob Indonesia

## Features

- Double-tap W to open the autopilot selector
- Move through modes with W / S
- Confirm with Enter
- Cancel with Backspace
- Drive to the active waypoint using selected behavior
- Built-in arrival and slow-down logic
- Works without an ox_lib menu, only using ox_lib notifications

## Controls

- Double-tap W: Open selector
- W / S: Move selection
- Enter: Confirm mode
- Backspace: Cancel selector
- Tap W while active: Stop autopilot

## Requirements

- FiveM server
- ox_lib
- QBCore / QBox compatible environment

## Installation

1. Place the resource folder in your `resources` directory.
2. Ensure `ox_lib` is installed and started.
3. Add the resource to your `server.cfg`.
4. Start the server and use the autopilot item or trigger the client event as needed.

## Notes

This project was created and maintained by Supernoob Indonesia.

## Example item config

```lua
['autopilot_chip'] = {
    label = 'Autopilot',
    weight = 2500,
    stack = false,
    close = true,
    client = {
        image = 'mechtablet.png',
    },
    description = 'Autopilot Controller'
}
```
