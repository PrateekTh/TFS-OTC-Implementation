---------Declarations---------
minigameToggleBtn = nil      -- variable to store toggle button
minigameWindow = nil         -- variable to store the main minigame window

local targetBtn              -- variable to store the target moving button
local opened = false         -- variable to store the state of the window (to animate the button only when the window is visible)
local currentMarginRight = 0 -- variable to store the current margin (for animation)

local speed = 4              -- variable to store the speed (change as per preference)
--------- Control Functions ---------
-- On module load
function init()
    -- Assign & Build the UI for the minigame
    minigameWindow = g_ui.displayUI('minigame')
    -- Hide the built game window (on Startup)
    minigameWindow:hide()

    -- Bind the releaseMembers function to the Global g_game, such that it is called when the game ends
    connect(g_game, {
        onGameEnd = releaseMembers
    })

    -- Create a toggle button so that the minigame is easier to access, and the experience is seamless
    minigameToggleBtn = modules.client_topmenu.addLeftButton('minigameToggleBtn', tr('Jump minigame') .. ' (None)',
        '/images/topbuttons/particles', toggle)

    -- Bind a keyboard shortcut to the toggle function as well
    g_keyboard.bindKeyDown('Ctrl+J', toggle)

    -- Assign the 'JumpButton' from the UI to the targetBtn variable, so that it can be animated
    targetBtn = minigameWindow:getChildById('JumpButton')
end

-- On module unload (often when client's game session ends)
function terminate()
    --Unbind functions & keyboard shortcuts
    disconnect(g_game, {
        onGameEnd = releaseMembers
    })
    g_keyboard.unbindKeyDown('Ctrl+J')


    releaseMembers() -- might be redundant
    opened = false
end

-- Release all members at the end of the session
function releaseMembers()
    minigameToggleBtn:destroy()
    minigameWindow:destroy()
end

-- On pressing the top menu toggle button or keyboard shortcut
function toggle()
    if minigameWindow:isVisible() then
        opened = false
        minigameWindow:hide()
    else
        minigameWindow:show()
        opened = true
        moveButton()
    end
end

--------- Animation Functions ---------
-- Reset the position of the targetBtn
function resetMargins()
    targetBtn:setMarginRight(0)                    -- (might be redundant)
    currentMarginRight = 0                         -- Reset Margins back to starting point
    targetBtn:setMarginBottom(math.random(0, 220)) -- Set height (Margin from bottom) to a random value between the desired range
end

-- Move the target button
function moveButton()
    if (opened) then                        -- Check for visibility of window
        if (currentMarginRight >= 250) then -- Check if box is on edge of window or not
            resetMargins()                  -- Reset Margins
        end

        scheduleEvent(                                          -- Schedule an Event with the desired delay (can use AddEvent here as well)
            function()
                currentMarginRight = currentMarginRight + speed -- Increment the current margin
                targetBtn:setMarginRight(currentMarginRight)    -- Set the current margin
                moveButton()                                    -- Call the moveButton function again, and continue the recursive loop
            end, 100
        )
    end
end
