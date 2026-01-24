# SimpleTimer

A simple World of Warcraft addon that provides a countdown timer with start/pause/reset functionality.

## Features

- **Duration Input**: Enter timer duration in minutes
- **Start/Pause/Resume**: Single button that changes function based on timer state
- **Reset**: Reset the timer back to zero
- **Visual Display**: Large MM:SS countdown display
- **Chat Command**: Use `/timer` or `/simpletimer` to toggle the timer window
- **Movable Window**: Drag the window anywhere on screen

## Installation

1. Copy the `SimpleTimer` folder to your World of Warcraft addons directory:
   - Retail: `World of Warcraft/_retail_/Interface/AddOns/`

2. Reload your UI with `/reload`

## Usage

1. Type `/timer` in chat to show/hide the timer window
2. Enter the desired duration in minutes (default is 10)
3. Click "Start" to begin the countdown
4. Click "Pause" to pause the timer (becomes "Resume" button)
5. Click "Reset" to stop and reset the timer
6. When the timer reaches 00:00, you'll hear a notification sound

## Commands

- `/timer` - Toggle the timer window
- `/simpletimer` - Alternative command to toggle the window

## Notes

- The timer window is movable - click and drag the title bar
- Timer continues counting down even when the window is hidden
- A sound notification plays when the timer finishes