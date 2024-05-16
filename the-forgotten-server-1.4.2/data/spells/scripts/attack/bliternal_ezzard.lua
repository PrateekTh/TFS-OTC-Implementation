-- Set up local combat and area variables
local combat = Combat()
combat:setArea(createCombatArea(AREA_CIRCLE5X5))

-- Set the attack effect(s)
local effects = { CONST_ME_ENERGYAREA, CONST_ME_HITBYFIRE, CONST_ME_BIGCLOUDS }
local pos
-- Setup the areas
local areas = {
    {
        { 0, 0, 1, 1, 1 },
        { 0, 0, 1, 1, 1 },
        { 0, 1, 0, 1, 0 },
        { 0, 1, 1, 0, 0 },
        { 0, 0, 0, 0, 0 },
    },

    {
        { 1, 1, 0, 0, 0 },
        { 1, 1, 1, 0, 0 },
        { 1, 1, 0, 1, 0 },
        { 0, 0, 1, 1, 0 },
        { 0, 0, 0, 0, 0 },
    },

    {
        { 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 0 },
        { 0, 1, 0, 1, 0 },
        { 1, 1, 1, 0, 0 },
        { 1, 1, 1, 0, 0 },
    },

    {
        { 0, 0, 0, 0, 0 },
        { 0, 1, 1, 0, 0 },
        { 0, 1, 0, 1, 1 },
        { 0, 0, 1, 1, 1 },
        { 0, 0, 0, 1, 1 },
    }
}

-- Set Area Offset (if any)
local area_offset = {
    x = 0,
    y = 0,
    z = 0,
}

-- Custom function to render each position (or attack)
function renderCustomEffect(cid, area)
    -- Get player's position coordinates
    local player = Player(cid)
    local playerPos = player:getPosition()

    local charIndex = math.ceil(#area / 2); -- Center coordinates of area

    -- Local positions = {} -- store and return positions if required
    local curr_position = {}
    for i = 1, #area do
        for j = 1, #area do
            if (area[i][j] == 1) then
                -- Calculate current attack position
                curr_position = {
                    x = playerPos.x + i - charIndex + area_offset.x,
                    y = playerPos.y + j - charIndex + area_offset.y,
                    z = playerPos.z + area_offset.z
                }
                pos = Position(curr_position)
                -- Set Area Combat and effects
                doAreaCombatHealth(cid, type, pos, 0, 50, 60, effects[(i * j * 2) % #effects + 1])
                --addEvent(doAreaCombatHealth, 20 * (i - charIndex) * (i - charIndex) * (j - charIndex) * (j - charIndex), cid, type, pos, 0, 4, 5, effect)
            end
        end
    end
    -- return positions;
end

-- Main Spell Callback, to manage the loops
function spellCallback(cid, position, loops, duration)
    local timeline = 0                                                       -- Controls the timestamps to be passed for each event
    for i = 1, loops do                                                      -- Loop to repeat the entire area animation sequence
        for j = 1, #areas do                                                 -- Iterate through each table in the areas table
            addEvent(renderCustomEffect, timeline + duration, cid, areas[j]) -- Add Event for rendering current area, and call the effect to render on per position basis
            timeline = timeline + duration                                   -- Update timeline
        end
    end
end

-- Callback function from main combat
function onTargetTile(creature, position)
    local loops = 5                                            -- Total Loops for entire animation sequence
    local duration = 300                                       -- Duration between each area effect
    spellCallback(creature:getId(), position, loops, duration) -- Main Loop function
end

combat:setCallback(CALLBACK_PARAM_TARGETTILE, "onTargetTile")

function onCastSpell(creature, variant, isHotkey)
    return combat:execute(creature, variant)
end
