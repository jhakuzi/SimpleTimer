# SimpleTimer & SimpleWatch

A simple World of Warcraft addon that provides a countdown timer and a stopwatch with a clean, tabbed interface.

## Features

### Timer Tab
- **Duration Input**: Enter timer duration in minutes
- **Countdown**: Counts down from the set time
- **Notification**: Plays a sound when the timer finishes

### SimpleWatch Tab (New!)
- **Stopwatch**: A count-up timer to track elapsed time
- **Independent**: Runs independently of the countdown timer

### Common Features
- **Start/Pause/Resume**: Controls for both timer and stopwatch
- **Reset**: Reset to zero
- **Chat Command**: Use `/timer` or `/simpletimer` to toggle the window
- **Movable Window**: Drag the window anywhere on screen
- **Persistent Operation**: Timer and Stopwatch continue running even if you switch tabs or hide the window

## Installation

1. Copy the `SimpleTimer` folder to your World of Warcraft addons directory:
   - Retail: `World of Warcraft/_retail_/Interface/AddOns/`

2. Reload your UI with `/reload`

## Usage

1. Type `/timer` in chat to show/hide the window.
2. Use the **Tabs** at the top to switch between "Timer" and "SimpleWatch".

### Using the Timer
1. Select the **Timer** tab.
2. Enter the desired duration in minutes (default is 10).
3. Click "Start" to begin.

### Using the Stopwatch
1. Select the **SimpleWatch** tab.
2. Click "Start" to begin counting up.

## Commands

- `/timer` - Toggle the timer window
- `/simpletimer` - Alternative command to toggle the window

## Notes

- The timer window is movable - click and drag the title bar.
- Timer and Stopwatch state is maintained when switching tabs.
- A sound notification plays when the countdown timer finishes.