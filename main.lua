------------------------------------------------------------------------------------------------------------------------

-- PLEASE SET THE DIRECTORY OF THIS SCRIPT
local script_dir = "C:\\Users\\Ryan\\AppData\\Roaming\\HexChat\\addons\\SmartGuard"
local log_channel = "##smartguard"

------------------------------------------------------------------------------------------------------------------------

hexchat.register("SmartGuard", "2.0 Beta", "Aids moderation by narrowing messages down to suspicious ones")


-- Require
package.path = package.path .. ";" .. script_dir .. "/?.lua"

require("smartguard")

require("blacklist")
require("whitelist")

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


hexchat.hook_print("Channel Message", function(word, _)

    local message_org = word[2]
    local message_auth, message_cont = message_org:match("([^%s]+)%s*(.*)")

    if smartguard.check_a1(message_cont, message_auth, blacklist.blacklist1)
        and not smartguard.whitelist(message_cont, message_auth, whitelist.whitelist1, blacklist.blacklist1, blacklist.blacklist2)
    then
        log_message(message_auth, message_cont)
    elseif smartguard.check_a2(message_cont, message_auth, blacklist.blacklist1)
        and not smartguard.whitelist(message_cont, message_auth, whitelist.whitelist1, blacklist.blacklist1, blacklist.blacklist2)
    then
        log_message(message_auth, message_cont)
    elseif smartguard.check_b1(message_cont, message_auth, blacklist.blacklist2)
        and not smartguard.whitelist(message_cont, message_auth, whitelist.whitelist1, blacklist.blacklist1, blacklist.blacklist2)
    then
        log_message(message_auth, message_cont)
    elseif smartguard.check_b2(message_cont, message_auth, blacklist.blacklist2)
        and not smartguard.whitelist(message_cont, message_auth, whitelist.whitelist1, blacklist.blacklist1, blacklist.blacklist2)
    then
        log_message(message_auth, message_cont)
    elseif smartguard.check_b3(message_cont, message_auth, blacklist.blacklist2)
        and not smartguard.whitelist(message_cont, message_auth, whitelist.whitelist1, blacklist.blacklist1, blacklist.blacklist2)
    then
        log_message(message_auth, message_cont)
    end

    return hexchat.EAT_NONE
end)


------------------------------------------------------------------------------------------------------------------------
