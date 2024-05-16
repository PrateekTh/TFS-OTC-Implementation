-- APPROACH 1 - SEPERATE COMBAT STRUCTURES

-- Setup required areas and empty combat tables
local combats = {}
local areas = {
    {
        { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 1, 1, 0, 0, 0, 0, 0, 0 },
        { 1, 1, 0, 0, 2, 0, 1, 1, 0 },
        { 0, 1, 1, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 0, 0, 1, 0, 0, 0 },
        { 0, 0, 0, 1, 1, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    },

    {
        { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 1, 1, 0, 1, 1, 0, 0 },
        { 0, 1, 1, 0, 0, 0, 1, 1, 0 },
        { 1, 1, 1, 1, 2, 1, 1, 1, 1 },
        { 0, 0, 1, 1, 1, 1, 1, 1, 0 },
        { 0, 0, 0, 1, 1, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 0, 1, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    },

    {
        { 0, 0, 0, 0, 0, 0, 0, 0, 0 },
        { 0, 0, 0, 1, 1, 1, 0, 0, 0 },
        { 0, 0, 1, 1, 1, 1, 1, 0, 0 },
        { 0, 1, 1, 0, 1, 0, 1, 1, 0 },
        { 1, 1, 1, 0, 2, 0, 1, 1, 1 },
        { 0, 1, 1, 0, 0, 0, 1, 1, 0 },
        { 0, 0, 1, 1, 0, 1, 1, 0, 0 },
        { 0, 0, 0, 1, 0, 1, 0, 0, 0 },
        { 0, 0, 0, 0, 0, 0, 0, 0, 0 }
    },
}

for i = 1, #areas do
    table.insert(combats, Combat())
    combats[i]:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
    combats[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICETORNADO)
    combats[i]:setArea(createCombatArea(areas[i]))

    -- set up Formula values to set level based damage factors, along with callbacks
    function onGetFormulaValues(player, level, magicLevel)
        local min = (level / 5) + (magicLevel * 8) + 10
        local max = (level / 5) + (magicLevel * 12) + 40
        return -min, -max
    end

    combats[i]:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
end

-- Function to cast the spell, altered to handle multiple areas/combats using the combatIndex
local function spellCallback(creatureId, variant, i)
    combats[i]:execute(creature, variant) -- Execute the current area's combat
end



function onCastSpell(creature, variant)
    -- Create a control loop to set the animation and time delays
    local timeline = 0       -- Controls the timestamps to be passed for each event
    for j = 1, 4 do          -- Loop to repeat the entire area animation sequence
        for i = 1, #areas do -- Iterate through each table in the areas table
            addEvent(spellCallback, timeline, creature.uid, variant, i)
            timeline = timeline + 350
        end
    end
    creature:say("froste", TALKTYPE_ORANGE_1)
end
