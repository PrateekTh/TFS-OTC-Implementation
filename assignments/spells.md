# Creating Custom Spells for TFS

The provided spell effect is as follows:

In order to reproduce the effect, I went over it closely, and made the following observation:

- The spell contains the `ICE TORNADO` effect, which does not map on 1x1 tiles.
- The pattern consists of a few different areas, which seem to be repeating all over again a few times.
- As can be seen in the end, the order in which the tornadoes disappear make clear the presence of distinct areas, and it is because of these areas that the smaller tornadoes seem to be flickering, as they appear for a lesser duration.

Thus, my overall conclusion was to create a spell that _iterates over multiple combat areas_, and eventually, I ended up creating **two spells**. I also realised that the mapping of the tornado effect needs to be considered, since instead of the player (or center of the screen) being at the center of the sprite, the given clip contains the player between two big tornadoes.

## Spell 1: Eternal Blizzard - "froste"

[Link to Code]()

This spell closely replicates the given video. Please find the code in the `eternal_blizzard.lua` file in the above link, with the explanation in the comments. I will go over the process here as well, briefly:

- This process makes use of the existing `combat` classes. A combat class, as can be observed from other spells as examples, contains several parameters, and is the go-to method to execute any given attack pattern.
- Thus, I created an table of `combats`, each of which contains a different area, from a custom table `areas`in the spell.
- I set up a loop in the `onCastSpell` function, which is called when a creature casts the spell. This loop then iterates over each member of the initialy created combat array, using `addEvent` and a `timeline` variable to animate the instances.
- Eventually, I customised the areas, and the given effect was pretty much complete.
- One last step was the mapping of the Ice Tornadoes, though it was all working, the pattern was **always** centered at the player, and caused problems in the exact replication. Also, I did not like how it look either. The solution to this was achieved by using the **Object Builder** to edit the tornado sprite. I saw that the sprite contained a 2x2 area, and thus would not render similar to other 1x1 effects. I added an **X offset** in the settings, and thus the desired effect was achieved.

The spell can be seen in action below:

## Spell 2: Bliternal Ezzard - "defroste"

[Link to Code]()

The need for this spell came up as I was trying to fix the last step in the previous effect. Though I had replicated the required spell, I felt that there wasn't enough control.

- _What if I wanted a spell that had a very specific pattern?_
- _What if I wanted to animate each position and have multiple magic effects?_
- _Lastly, what if I wanted to add more of a time based factor, so that the animation could be customized completely too?_

So I came to the conclusion that instead of letting these big and little tornadoes push me around, I'll try and write a completely custom script, so that the combat is less of black box.

The approach is rather simple, and the main components include working with position coordinates and the `Postion` class, and associated timelines and arrays. Again, while the code file itself contains most of the explanation, here is the approach in brief:

- Set up a single `combat` and its area (to conveniently recieve player information in the first callback)
- Set up different areas and effects in the `areas` and `effects` tables, respectively. I also added an `area offset` table, in case it is needed.
- The `onCastSpell`, which is the entry point, executes the combat we specified, which in turn contains a callback that gives us the postion of the player, and then assigns some customisable variables, and passes the control to the main `spellCallback` function.
- This `spellCallback` function contains the main area based loop - which runs for each index in the `areas` array, and animates it with the help of an `addEvent` function.
- In order to render each area, the `addEvent` contains the `renderCustomEffect` function, which basically takes the given area, and iterates through each position where the current effect's position is calculated with respect to the player.
- Finally the `doAreaCombatHealth` function is used to render the effect, and deal damage, while iterating over the `effects` table, based on the provided conditions.

This is certainly quite a lot of things happening for a spell, but I believe it can serve as a great template, and is built to be easily customized, which can then be optimised after the desired effect has been achieved.

Here is the version of the spell that I saved, as the result:

## Conclusion

I feel that making these spells, especially the Bliternal Ezzard, has equipped me to execute (almost) any specified effect. It was really great for establishing control over Lua as well, which I find really amazing.

Nonetheless, I hope the names that I gave to the spells aren't too bad.
