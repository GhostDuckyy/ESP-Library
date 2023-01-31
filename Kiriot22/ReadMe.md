# ReadMe
Made by [Real Panda](https://v3rmillion.net/member.php?action=profile&uid=46812)

## Docs
#### Loadstring
```lua
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/ESP-Library/main/Kiriot22/source.lua"))()
```
**Usage:**

`ESP:Toggle(<Boolean>)` - enables/disables the ESP, it boxes players by default so you don't have to set up a PlayerAdded of your own
`ESP:Add(<Instance>, options)` - add an object to the ESP manually, options can be empty but must be a table


Full list of options and their explanation:

> Name - the name displayed in the ESP

> Color - custom Color3, defaults to ESP.Color

> Size - custom size

> Player - should be set if the object is a character of a player

> PrimaryPart - for objects with custom parts

> IsEnabled - string which is checked in the ESP table to determine whether the object should be displayed, ex. set to "NPCs" and then set ESP.NPCs = true to enable
if necessary, you can pass a function too, in which case it will just call it passing the box as an argument, and expect a true/false return

> Temporary - whether the object should be removed when the ESP is toggled

> ColorDynamic - a function which returns the color the box should have, use if you really need the color to change depending on conditions

> RenderInNil - whether the ESP should show the object when it's parented to nil, good for showing stuff in nil which you can't reparent


**Toggling individual components:**
```html
ESP.Tracers = <Boolean>
ESP.Names = <Boolean>
ESP.Boxes = <Boolean>
```

**Misc options:**
```html
ESP.TeamColor = <Boolean> - whether to use team color
ESP.Players = <Boolean> - show/hide players
ESP.FaceCamera = <Boolean> - whether the boxes should face the direction the player is looking or always face your camera
ESP.AutoRemove = <Boolean> - whether the boxes should be removed when the object is parented to nil (defaults to true)
```

**Overrides:**

The ESP supports overriding certain functions, specifically for games with custom teams/characters system. Overriding them works by doing `ESP.Overrides.FunctionName = customFunc`
For example Bad Business has custom characters which don't use players.Character, so normally the ESP wouldn't work, however you can easily fix it by doing something like this:

**Example**
```lua
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()

local Modules
for i,v in pairs(getgc()) do
    if type(v) == "function" and islclosure(v) and not is_synapse_function(v) then
        local up = getupvalues(v)
        for i,v in pairs(up) do
            if type(v) == "table" and rawget(v, "Kitty") then
                local f = getrawmetatable(v).__index
                Modules = getupvalue(f, 1)
                break
            end
        end
    end
end

ESP.Overrides.GetTeam = function(p)
    return game.Teams:FindFirstChild(Modules.Teams:GetPlayerTeam(p))
end

ESP.Overrides.GetPlrFromChar = function(char)
    return Modules.Characters:GetPlayerFromCharacter(char)
end

ESP.Overrides.GetColor = function(char)
    local p = ESP:GetPlrFromChar(char)
    if p then
        local team = ESP:GetTeam(p)
        if team then
            return team.Color.Value
        end
    end
    return nil
end

local function CharAdded(char)
    local p = game.Players:FindFirstChild(char.Name) or ESP:GetPlrFromChar(char)
    if not p or p == game.Players.LocalPlayer then
        return
    end

    ESP:Add(char, {
        Name = p.Name,
        Player = p,
        PrimaryPart = char.PrimaryPart or char:WaitForChild("Root")
    })
end
workspace.Characters.ChildAdded:Connect(CharAdded)
for i,v in pairs(workspace.Characters:GetChildren()) do
    coroutine.wrap(CharAdded)(v)
end

--you should put the code below into individual toggles when making an actual script--
ESP:Toggle(true)
ESP.TeamColor = true
ESP.Tracers = true
```
