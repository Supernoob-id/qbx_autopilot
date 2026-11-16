# qbx_autopilot

A FiveM / GTA V client-side waypoint autopilot resource with an on-screen driving mode selector for selecting how the vehicle should navigate to the destination.

Created by: Supernoob Indonesia

## Features

- Arrow Up opens the autopilot selector while driving
- W / S moves through the available driving modes
- Enter starts autopilot or switches to the selected mode
- Backspace cancels the selector
- W or S while autopilot is active forces a stop
- Drives to the active waypoint using the chosen driving style and speed
- Smooth braking and arrival handling when the destination is reached
- No item or server-side script required
- Uses ox_lib for notifications

## Controls

- Arrow Up: Open the selector
- W / S: Move between modes
- Enter: Start or switch mode
- Backspace: Cancel selector
- W or S while autopilot is running: Stop autopilot

## Requirements

- FiveM server
- ox_lib

## Installation

1. Place the `qbx_autopilot` folder in your server `resources` directory.
2. Make sure `ox_lib` is installed and started before this resource.
3. Add `ensure qbx_autopilot` to your `server.cfg`.

## Creator

This resource was created by Supernoob Indonesia.
