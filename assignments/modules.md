# Creating Modules for OTC

The final assignment involved creating a custom module for OTC, which contained the following functionality:

I have implemented this as a module, named as `game_minigame`. Since it is an OTC module, it contains the following three files:

- `minigame.lua`:[Link](https://github.com/PrateekTh/TFS-OTC-Implementation/blob/main/otclient/modules/game_minigame/minigame.lua) - File containing the functionality of the module
- `minigame.otmod`:[Link](https://github.com/PrateekTh/TFS-OTC-Implementation/blob/main/otclient/modules/game_minigame/minigame.otmod) - File for registering the module to the module manager
- `minigame.otui`:[Link](https://github.com/PrateekTh/TFS-OTC-Implementation/blob/main/otclient/modules/game_minigame/minigame.otui) - File to build the UI of the module

The lua file contains the explanation to all of the functionality associated with the minigame module. Here I will cover the main components of my implementation in brief.

## Components

### Minigame Window

This is the main UI window, in which the button keeps moving. It is controlled by a `toggle` function that can be triggered via a keyboard shortcut, and a toggle button.

### Jump Button

This is the moving Jump button, created in the `minigame.otui` and assigned to a local in the local file. This button is moved using some simple conditions, in the `moveButton` function:

- While the Minigame Window is visible, we increase the button's right margin after a given time interval, using the addEvent function.
- If the margin reaches a certain value (a bit less than the width of the Minigame Window) or if the button is clicked, we call a reset function.
- The reset function sets the right margin back to zero, and assigns a random height in the provided range.

### Toggle Button

<img src="https://github.com/PrateekTh/TFS-OTC-Implementation/assets/57175545/e3a3956f-060c-438a-aab8-db194ace6538" width="500" title="toggle-btn">

The toggle button has been added to the top left array of buttons, and can be used to hide/show the minigame window. Additionally, a keyboard shortcut - `Ctrl + J` has been assigned the same function.

The implementation can be seen below:


https://github.com/PrateekTh/TFS-OTC-Implementation/assets/57175545/ce90b6c8-7136-442d-bdbd-32a6db002b40


## Conclusion

The module system of OTC did take a bit getting used to at first, but once I got the hang of it, it was pretty smooth and powerful enough to create pretty much any widget. A lot of the merit goes to Lua as well, which has proved itself has worthy of being one of my go-to languages, during the course of this project.
