------------------------------------------------------------------------------------------------------------------------

-- PLEASE SET THE DIRECTORY OF THIS SCRIPT
local script_dir = ""
local log_channel = "##smartguard"

------------------------------------------------------------------------------------------------------------------------

hexchat.register("SmartGuard", "2.0 Beta", "Aids moderation by narrowing messages down to suspicious messages")

--execute the files
package.path = package.path .. ";" .. script_dir .. "/?.lua"
require("functions")

------------------------------------------------------------------------------------------------------------------------


local function log_message(pname, pmessage)

    local log = 'Player ' .. pname .. ' said "' .. pmessage .. '"'

    hexchat.command("msg " .. log_channel .. " " .. log)

    -- HexChat doesn't support notifications so DM is sent to yourself
    local my_nick = hexchat.get_info("nick")
    -- Please comment out the following line if you would like it to stop
    hexchat.command("msg " .. my_nick .. " " .. log)

end


------------------------------------------------------------------------------------------------------------------------


--[[
    remember that Lua’s string matching functions like string.find use patterns
    similar to regular expressions, which means certain characters like ., %, *, -, etc.
    have special meanings. If your blacklist contains any of these characters
    and you want to match them literally, you’ll need to escape them using the % character.
]]

dofile(script_dir .. "/blacklist.lua")
local blacklist1 = blacklist1
local blacklist2 = blacklist2

dofile(script_dir .. "/whitelist.lua")
local whitelist1 = whitelist1


------------------------------------------------------------------------------------------------------------------------


hexchat.hook_print("Channel Message", function(word, _)

    local message_org = word[2]
    local message_auth, message_cont = message_org:match("([^%s]+)%s*(.*)")

    if SmartGuard.check_a1(message_cont, message_auth, blacklist1)
        and not SmartGuard.whitelist(message_cont, message_auth, whitelist1, blacklist1, blacklist2)
    then
        log_message(message_auth, message_cont)
    elseif SmartGuard.check_a2(message_cont, message_auth, blacklist1)
        and not SmartGuard.whitelist(message_cont, message_auth, whitelist1, blacklist1, blacklist2)
    then
        log_message(message_auth, message_cont)
    elseif SmartGuard.check_b1(message_cont, message_auth, blacklist2)
        and not SmartGuard.whitelist(message_cont, message_auth, whitelist1, blacklist1, blacklist2)
    then
        log_message(message_auth, message_cont)
    elseif SmartGuard.check_b2(message_cont, message_auth, blacklist2)
        and not SmartGuard.whitelist(message_cont, message_auth, whitelist1, blacklist1, blacklist2)
    then
        log_message(message_auth, message_cont)
    elseif SmartGuard.check_b3(message_cont, message_auth, blacklist2)
        and not SmartGuard.whitelist(message_cont, message_auth, whitelist1, blacklist1, blacklist2)
    then
        log_message(message_auth, message_cont)
    end

    return hexchat.EAT_NONE
end)


------------------------------------------------------------------------------------------------------------------------
