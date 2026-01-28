# SimpleTimer

A lightweight World of Warcraft addon providing a countdown timer, a stopwatch, and a daily reminder (alarm) through a clean, tabbed interface.

## Features

### ⏳ Timer Tab
- **Duration Input**: Enter timer duration in minutes.
- **Countdown**: High-precision countdown from the set time.
- **Notification**: Plays a sound and prints a message when the timer finishes.

### ⏱️ SimpleWatch Tab
- **Stopwatch**: A count-up timer to track elapsed time.
- **Independent**: Runs independently of the countdown timer and reminders.

### 🔔 Reminder Tab
- **Daily Alarm**: Set a specific time (HH:MM) to receive a notification.
- **Format**: Uses standard 24-hour format (e.g., 14:30 for 2:30 PM).
- **Persistent**: Keeps track of the set time until cleared.

### Common Features
- **Start/Pause/Resume**: Full control over all timing functions.
- **Reset**: Quickly reset counters to zero.
- **Chat Command**: Use `/timer` or `/simpletimer` to toggle the window.
- **Movable Window**: Drag the window anywhere on your screen.
- **Persistent Operation**: All features continue running even when the window is hidden or you switch tabs.

## Installation

1. Copy the `SimpleTimer` folder to your World of Warcraft addons directory:
   - Retail: `World of Warcraft/_retail_/Interface/AddOns/`
   - Classic: `World of Warcraft/_classic_/Interface/AddOns/`

2. Reload your UI with `/reload` or restart the game.

## Usage

1. Type `/timer` or `/simpletimer` in chat to show/hide the main window.
2. Use the **Tabs** at the top to switch between "Timer", "SimpleWatch", and "Reminder".

### Using the Timer
1. Select the **Timer** tab.
2. Enter the desired duration in minutes (default is 10).
3. Click **Start** to begin.

### Using the Stopwatch
1. Select the **SimpleWatch** tab.
2. Click **Start** to begin counting up.

### Using the Reminder
1. Select the **Reminder** tab.
2. Enter the time in **HH:MM** format (e.g., `17:00`).
3. Click **Set** to activate the alarm.
4. Click **Clear** to remove the set reminder.

## Notes

- The window position is movable - click and drag the title bar.
- All states (timer, stopwatch, and reminder) are maintained when switching tabs or closing the window.
- Smooth updates (10 times per second) ensure the display remains accurate and responsive.