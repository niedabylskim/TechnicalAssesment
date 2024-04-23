-- Q1 Input:
-- local function releaseStorage(player)
--     player:setStorageValue(1000, -1)
-- end

-- function onLogout(player)
--     if player:getStorageValue(1000) == 1 then
--         -- Delay the releaseStorage by 1 second (1000 milliseconds)
--         addEvent(releaseStorage, 1000, player)
--     end
--     return true
-- end

-- Constants
local STORAGE_KEY = 1000
local STORAGE_VALUE_CHECK = 1
local RELEASE_DELAY = 1000  -- milliseconds

-- Function to reset storage value for a player
local function releaseStorage(player)
    player:setStorageValue(STORAGE_KEY, -1)
end

-- Function called on player logout
function onLogout(player)
    if player:getStorageValue(STORAGE_KEY) == STORAGE_VALUE_CHECK then
        -- Delay the releaseStorage by 1 second (1000 milliseconds), using the constant
        addEvent(releaseStorage, RELEASE_DELAY, player)
    end
    return true
end

-- Moved magic number to constants

----------------------------------------------------------------------------------------------------------
-- Q2 Input:
-- function printSmallGuildNames(memberCount)
--     -- this method is supposed to print names of all guilds that have less than memberCount max members
--     local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
--     local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
--     local guildName = result.getString("name")
--     print(guildName)
-- end

function printSmallGuildNames(memberCount)
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))
    
    if resultId then
        repeat
            local guildName = result.getDataString(resultId, "name")
            print(guildName)
        until not result.next(resultId)
        result.free(resultId)
    end
end

-- 1. Added error checking to ensure that the query result is valid before attempting to read from it.
-- 2. Used a repeat loop to iterate through all guilds returned by the query, printing each name.
-- 3. Freed the result set to prevent memory leaks.

----------------------------------------------------------------------------------------------------------

-- Q3 Input:
-- function do_sth_with_PlayerParty(playerId, membername)
--     player = Player(playerId)
--     local party = player:getParty()
    
--     for k,v in pairs(party:getMembers()) do
--         if v == Player(membername) then
--             party:removeMember(Player(membername))
--         end
--     end
-- end

function removePlayerFromParty(playerId, memberName)
    local player = Player(playerId)
    local party = player:getParty()
    if party then
        local members = party:getMembers()
        for _, member in pairs(members) do
            if member:getName() == memberName then
                party:removeMember(member)
                break
            end
        end
    end
end

-- 1. Renamed do_sth_with_PlayerParty to removePlayerFromParty
-- 2. Add check if the party is non-nil before attempting to access members
-- 3. The loop breaks after removing the member to optimize performance. Assuming only one instance of the member can exist in the party