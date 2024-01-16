# SmartGuard
A HexChat addon that aids moderation by reading messages received real-time in channels and narrowing them down into suspicious messages that may contain potential swears. With this tool you don't have to read every single message in the chat you're moderating; this addon narrows everything down to a _way_ smaller collection.

### Credits
Credit goes to @src4026 for writing the whitelist code and contributing to the blacklist and README.

## Ability
Most cases of swear filter bypass are caught.
- Blending with other words: `hellofvck3you`
- Repetition or distortion: `sSsHhh54%*IITtt!`
- Multiline:
    ```
    <player> f
    <player> u
    <player> you
    ```
- Usage of ignorable characters: `s_h_! t`
- Swear word variants: `phuq`

## Installation and Setup
- Navigate to your HexChat addons folder and run the following command:
    ```
    git clone https://gitlab.com/OrangeBlob/SmartGuard.git
    ```
- Next, open the cloned folder and open `main.lua` with an editor. Edit the value `script_dir` to specify the directory of your script. For example:
    ```lua
    local script_dir = "C:/Users/John/AppData/Roaming/HexChat/addons/SmartGuard"
    ```
- To load the addon, open HexChat, and under the `HexChat` dropdown menu, click `Load Plugin or Script`. Open the "SmartGuard" folder, select `main.lua`, and click `OK`.

### Important information
- By default, the addon uses your IRC account to send all flagged messages to the ##smartguard channel on IRC. You can edit the channel the flagged messages are sent to by editing the `log_channel` value below `script_dir`.
- The [blacklists](blacklist.lua) and [whitelist](whitelist.lua) are left empty for you to enter your own words. We maintain a [ctf-moderation branch](https://gitlab.com/OrangeBlob/SmartGuard/-/tree/ctf-moderation?ref_type=heads) of this repository that includes our blacklists and a whitelist suited precisely for the [Minetest Capture the Flag game server by rubenwardy](https://ctf.rubenwardy.com/).
- You can also copy the lists from the [ctf-moderation branch](https://gitlab.com/OrangeBlob/SmartGuard/-/tree/ctf-moderation?ref_type=heads) and tailor them to your needs.

---

> **NOTE:** Always use ***lowercase*** for Latin alphabet (Standard English Alphabet) characters for words in the blacklists and whitelists.

### Adding words to the blacklists in [`blacklist.lua`](blacklist.lua)
```lua
blacklist2 = {}
```

- `blacklist2` focuses on words that are space sensitive. 
- Always remember to **add a space** after the word so that SmartGuard only matches it with standalone occurrences of it and not when it is a part of a larger word.
- You can use this for words you want to blacklist but could be part of another word that you don't want to blacklist (like how "fu" is part of "fun"). For example:

```lua
blacklist2 = {
    "fu ",
    "f u ",
    "shi ",
}
```

---

```lua
blacklist1 = {}
```

- `blacklist1` is for words that don't belong in `blacklist2`. `blacklist1` ignores all spaces, so for words that could be part of another word, please use `blacklist2`.
- Any word in `blacklist1` that contains spaces will not work, so for phrases, please remove the spaces (e.g. `dumb dog` -> `dumbdog`).
- Special characters (such as `.`, `%`, `*`, `-`) have special meaning in Lua. To match them literally, escape them by adding `%` before the special character. For example:

```lua
blacklist1 = {
    "f%*%*k",
    "sh%*t",
}
```

---

### Adding words to the whitelist in [`whitelist.lua`](whitelist.lua)
- The whitelist are words that SmartGuard will omit to reduce false positives. An example of `whitelist1` with words is:

```lua
whitelist1 = {
    "cook",
    "medic",
}
```

## Auto-load Addon on Startup
- To load the addon automatically every time you open HexChat, first, open the `HexChat` dropdown menu and click `Network List`.
- Click `Edit` beside your chosen network to open up the network settings, and click the `Connect commands` tab.
- Click `Add` to add the following connect command:
    ```
    load SmartGuard/main.lua
    ```
- Click `Close` and you're good to go.
