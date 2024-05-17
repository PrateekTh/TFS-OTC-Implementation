# Implementation Based Questions

Here, I have attempted to solve the questions provided by the Lead Developers at Tavernlight Games. I also added a few extra observations (which may not be directly relevant, but still might prove to be useful in some situations) on some questions, which I came across as answers to some questions that occured to me while solving.

### Q1. Fix or improve the implementation of the below methods

```
local function releaseStorage(player)
    player:setStorageValue(1000, -1)
end

function onLogout(player)
    if player:getStorageValue(1000) == 1 then
        addEvent(releaseStorage, 1000, player)
    end
    return true
end
```

The solution, as far as I could see involves the `addEvent` function. The objective here seems that we wish to release storage, once the player logs out. (Default value of `-1` refers to empty storage)

- Seems like the `1000` second delay (as added in `addEvent`) is not necessary, since we want to clear the storage when player logs out. Still, there is a possibility that it may be required.
- The value of `1` seems to be associated to a particular condition here (on which to empty storage), since as per the source code and other examples, storage value can be any integer value.

```
function onLogout(player)
    -- Release storage
    if player:getStorageValue(1000) == 1 then
        player:setStorageValue(1000, -1)
    end
    return true
end
```

As it can be seen, since an `addEvent` is not required, we do not require creating a separate function here.

An interesting observation that I came across in TFS source code was that the OldValue is also stored in the storage map data structure, by first _getting_ the storage value.

<img src="https://github.com/PrateekTh/TFS-OTC-Implementation/assets/57175545/c61c92eb-f0e4-499a-8216-8f25952614b6" width="800" title="storagefunction">

Also, the `setStorageValue` function contains the set value as an **optional parameter**. In such cases, the key (for eg 1000) will be removed completely from the map. This could be relevant for saving space in certain situations, where the said value won't be required again, unless it is set again in the next session.

### Q2. Fix or improve the implementation of the below method

```
function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    local guildName = result.getString("name")
    print(guildName)
end
```

From what I can see, the variables here seem to be inconsistent in terms of names, and there can be a few security problems on writing queries in the above format.

- The `resultID` and `result` variable names are inconsistent, and hence must be fixed.
- The query `selectGuildQuery` can be saved in a better way.

```
function printSmallGuildNames(memberCount)
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < " .. memberCount ..";"
    local result = db.storeQuery(selectGuildQuery) -- rename resultId to result
    print(result.getString("name"))
end
```

As we can see, the `string.format` function can be ommitted, since memberCount is an integer. If there are concerns about recieving a non integral vaue, a math function such as `ceil` can be easily added. Also, this removes risks of any SQL Injections as well.
Also, the `resultId` variable a has been renamed to `result`, and thus it will be consistent. I also removed the local `guildname`, since we don't require it here, and the function name is enough to sustain readability.

I came across an observation when I was trying to learn more about the database based functions here, and thus came across the formats that the getString() function returns.

```
local str = results.GetString(format, n, coldel, rowdel, nullexpr)
```

- coldel: If format is set to adClipString it is a column delimiter. Otherwise it is the tab character.
- rowdel: If format is set to adClipString it is a row delimiter. Otherwise it is the carriage return character.

Since we are selecting only one column, I _think_ we wouldn't need to `getString`, but I have not tested it yet, and would not place too many bets on my database proficiency just yet.

### Q3. Fix or improve the name and the implementation of the below method

```
function do_sth_with_PlayerParty(playerId, membername)
    player = Player(playerId)
    local party = player:getParty()

    for k, v in pairs(party:getMembers()) do
        if v == Player(membername) then
            party:removeMember(Player(membername))
        end
    end
end
```

Here, the name of the function based on its _function_ can be deciphered easily. Also, the scope of the `player` variable should be brought into focus.

```
-- Remove a member from party
function removeMemberfromPlayerParty(playerId, membername)
    local player = Player(playerId)                     -- make local
    local partyMembers = player:getParty():getMembers() -- assign getmembers here

    for i = 1, #partyMembers, 1 do
        if partyMembers[i] == Player(membername) then
            party:removeMember(Player(membername))
        end
    end
end
```

In the above solution, the following adjustments have been made:

- Rename the function to `removeMemberfromPlayerParty`.
- Set the `player` variable as a local, since otherwise it could end up modifying a global variable, or creating a new global variable, both of which can be quite undesirable, unless in certain niche situations.
- Get the members in the given party directly, since we do not have need of any other functionality of the `Party` table/object for the current function.
- Iterate over the length of the `partyMembers` table, instead of the `pairs` function. This is not very necessary, and I go over the reason in the observation.

The interesting observation here was on `Lua`, and the efficiency of for loops. Please refer to [this link](https://springrts.com/wiki/Lua_Performance#TEST_9:_for-loops) for the comparision of the prominent approaches. 

<img src="https://github.com/PrateekTh/TFS-OTC-Implementation/assets/57175545/57985d3d-696c-46b2-862a-c4b924353c33" width="800" title="Results">


It can be seen, that since the `pairs` & `ipairs` functions first generate key value pairs, it is generally a better choice to not use them in cases where it is not necessary.

### Q4. Assume all method calls work fine. Fix the memory leak issue in below method

```
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId){

    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }
}
```

The above function has quite a few problems, and memory leaks are definitely something that we must stay vary of while writing code at all times. I went over the function on a case by case basis, and found quite a few situations of memory leaks:

- The core source of the memory leak can be attributed to the creation of the `new` player, whenever the player is offline.
- If the player does not exist in login data, the dynamically allocated memory using new needs to be cleared using the delete keyword.
- Additionally, when the function ends we need to delete the memory as well.

```
void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId){

    Player* player = g_game.getPlayerByName(recipient);
    if (!player) {
        player = new Player(nullptr);
        if (!IOLoginData::loadPlayerByName(player, recipient)) {
            delete player;  // Delete the player pointer memory
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (player->isOffline()) {
        IOLoginData::savePlayer(player);
    }

    delete player; // Delete memory allocated to player pointer
}
```

In the above solution, all instances of exiting the function, now contain provisions to delete the allocated memory. If we do not do that, this memory would stay on the heap, even after the pointer variable is destroyed on going out of scope (on function end, in this case), thus causing a memory leak.

I also wanted to check the item pointer, and thus, a very fruitful investigation around the `CreateItem` function, and the OTC source code led me to the implementation of `referenceCounters`. These members contain the amount of references to a given dynamically created object, and get `incremented` or `decremented` using dedicated functions. This management helps to elegantly prevent memory leaks, and I will definitely keep the approach in mind, for the future.

# Conclusions

I acknowledge, there may be several ways to approach optimisation in any given project, and hence am open to learning better ways, I there were some things I couldn't quite catch in my implementation.

For now, I believe the current solutions should suffice.
