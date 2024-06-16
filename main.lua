------------------------------------------------------------------------------------------------------------------------

-- PLEASE SET THE DIRECTORY OF THIS SCRIPT
local script_dir = ""
local mod_channels = {}
local log_channel = ""

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

function is_in(str, tbl)
    for _, value in pairs(tbl) do
        if value == str then
            return true
        end
    end
    return false
end


------------------------------------------------------------------------------------------------------------------------


hexchat.hook_print("Channel Message", function(word, _)

    if is_in(hexchat.get_info("channel"), mod_channels) then

        local message_cont = word[2]
        local message_auth = word[1]

        if smartguard.moderate(message_cont, message_auth,
                blacklist.blacklist1,
                blacklist.blacklist2,
                whitelist.whitelist1)
        then
            log_message(message_auth, message_cont)
        end

    end

    return hexchat.EAT_NONE

end)


------------------------------------------------------------------------------------------------------------------------
