------------------------------------------------------------------------------------------------------------------------

--define
SmartGuard = {}

local last_messages_a1 = {}
local last_messages_a2 = {}
local last_messages_b1 = {}
local last_messages_b2 = {}
local last_messages_b3 = {}

------------------------------------------------------------------------------------------------------------------------


--function that removes duplicated characters
local function remove_duplicates(s)
    local result = ""
    for i = 1, #s do
        if s:sub(i, i) ~= s:sub(i + 1, i + 1) then
            result = result .. s:sub(i, i)
        end
    end
    return result
end

--function that removes spaces
local function remove_spaces(s)
    local no_space = ""
    no_space = s:gsub("%s+", "")
    return no_space
end

--function that only keeps letters
local function remove_all(s)
    local all_removed = ""
    all_removed = s:gsub("[%W%d]", "")
    return all_removed
end

--function that only keeps letters and spaces
local function remove_parts(s)
    local parts_removed = ""
    parts_removed = s:gsub("[^%a%s]", "")
    return parts_removed
end

--function that replaces special character with spaces
local function replace_parts(s)
    local parts_removed = ""
    parts_removed = s:gsub("[%W%d_]", " ")
    return parts_removed
end


------------------------------------------------------------------------------------------------------------------------


--removes all special characters, spaces so it is just pure plain text
--first if tests with duplicates, second if without
function SmartGuard.check_a1(message, name, blacklist)

    if not last_messages_a1[name] then
        last_messages_a1[name] = {}
    end

    message = remove_all(string.lower(message))
    table.insert(last_messages_a1[name], message)

    if #last_messages_a1[name] > 20 then
        table.remove(last_messages_a1[name], 1)
    end

    local last_messages_str_a1 = table.concat(last_messages_a1[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_a1, word) then
            last_messages_a1[name] = {}
            return true
        elseif string.find(remove_duplicates(last_messages_str_a1), word) then
            last_messages_a1[name] = {}
            return true
        end
    end
end

--removes all spaces but keep special characters
--first if tests with duplicates, second if without
function SmartGuard.check_a2(message, name, blacklist)

    if not last_messages_a2[name] then
        last_messages_a2[name] = {}
    end

    message = remove_spaces(string.lower(message))
    table.insert(last_messages_a2[name], message)

    if #last_messages_a2[name] > 20 then
        table.remove(last_messages_a2[name], 1)
    end

    local last_messages_str_a2 = table.concat(last_messages_a2[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_a2, word) then
            last_messages_a2[name] = {}
            return true
        elseif string.find(remove_duplicates(last_messages_str_a2), word) then
            last_messages_a2[name] = {}
            return true
        end
    end
end

--removes all special characters but keep spaces
--a space is added at the end of each message in the table
--first if tests with duplicates, second if without
function SmartGuard.check_b1(message, name, blacklist)

    if not last_messages_b1[name] then
        last_messages_b1[name] = {}
    end

    message = remove_parts(string.lower(message)) .. " "
    table.insert(last_messages_b1[name], message)

    if #last_messages_b1[name] > 20 then
        table.remove(last_messages_b1[name], 1)
    end

    local last_messages_str_b1 = table.concat(last_messages_b1[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_b1, word) then
            last_messages_b1[name] = {}
            return true
        elseif string.find(remove_duplicates(last_messages_str_b1), word) then
            last_messages_b1[name] = {}
            return true
        end
    end
end

--replace all special characters with spaces
--a space is added at the end of each message in the table
--first if tests with duplicates, second if without
function SmartGuard.check_b2(message, name, blacklist)

    if not last_messages_b2[name] then
        last_messages_b2[name] = {}
    end

    message = replace_parts(string.lower(message)) .. " "
    table.insert(last_messages_b2[name], message)

    if #last_messages_b2[name] > 20 then
        table.remove(last_messages_b2[name], 1)
    end

    local last_messages_str_b2 = table.concat(last_messages_b2[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_b2, word) then
            last_messages_b2[name] = {}
            return true
        elseif string.find(remove_duplicates(last_messages_str_b2), word) then
            last_messages_b2[name] = {}
            return true
        end
    end
end

--keep special characters and spaces but remove duplicates
--a space is added at the end of each message in the table
function SmartGuard.check_b3(message, name, blacklist)

    if not last_messages_b3[name] then
        last_messages_b3[name] = {}
    end

    message = remove_duplicates(string.lower(message)) .. " "
    table.insert(last_messages_b3[name], message)

    if #last_messages_b3[name] > 20 then
        table.remove(last_messages_b3[name], 1)
    end

    local last_messages_str_b3 = table.concat(last_messages_b3[name])
    for _, word in ipairs(blacklist) do
        if string.find(last_messages_str_b3, word) then
            last_messages_b3[name] = {}
            return true
        end
    end
end


------------------------------------------------------------------------------------------------------------------------


function SmartGuard.whitelist(message, name, whitelist, blacklist1, blacklist2)

    message = string.lower(message)

    for _, word in ipairs(whitelist) do
        if string.find(message, word) then
            message = string.gsub(message, word, "")
            if SmartGuard.check_a1(message, name, blacklist1) then
                return false
            elseif SmartGuard.check_a2(message, name, blacklist1) then
                return false
            elseif SmartGuard.check_b1(message, name, blacklist2) then
                return false
            elseif SmartGuard.check_b2(message, name, blacklist2) then
                return false
            elseif SmartGuard.check_b3(message, name, blacklist2) then
                return false
            else
                return true
            end
        end
    end
end


------------------------------------------------------------------------------------------------------------------------

return SmartGuard

------------------------------------------------------------------------------------------------------------------------
