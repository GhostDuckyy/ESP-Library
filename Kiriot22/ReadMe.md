# ReadMe
Made by [Real Panda](https://v3rmillion.net/member.php?action=profile&uid=46812)

## Documentation
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

**Full list of overrides and their explanation below:**
> GetTeam(player) - should return the team object the player is on (can return a table or some other identifier, since it's only used for determining team mates)

> IsTeamMate(player) - should return true if "player" is a team mate of the local player

> GetColor(object) - only used for objects which don't have Color or ColorDynamic specified, should return a Color3 (or nil, in which case it uses ESP.Color)

> GetPlrFromChar(char) - should return the player whose character is char

> UpdateAllow(box) - return false if the box should be hidden, otherwise return true, usually used to hide players in lobby areas

**Custom Objects**
The ESP has a built-in support for easily implementing custom objects, such as chests or cars or whatever by using **`ESP:AddObjectListener(parent, options)`**
It will connect ChildAdded/DescendantAdded (depending on options) to the parent, and match the added instances for specified options, and if a match is found, add them to the ESP.
It also works retroactively, meaning it will add instances which were created before the script was ran.

Example 1, Murder Mystery 2 dropped gun ESP:
```lua
ESP:AddObjectListener(workspace, {
    Name = "GunDrop",
    CustomName = "Gun",
    Color = Color3.fromRGB(0,124,0),
    IsEnabled = "DroppedGun"
})
--some toggle:
ESP.DroppedGun = true
```

Example 2, R2DA Zombies ESP:
```lua
ESP:AddObjectListener(workspace.Characters.Zombies, {
    Color =  Color3.new(1,1,0),
    Type = "Model",
    PrimaryPart = function(obj)
        local hrp = obj:FindFirstChildWhichIsA("BasePart")
        while not hrp do
            wait()
            hrp = obj:FindFirstChildWhichIsA("BasePart")
        end
        return hrp
    end,
    Validator = function(obj)
        return not game.Players:GetPlayerFromCharacter(obj)
    end,
    CustomName = function(obj)
        return obj:FindFirstChild("Zombie") and obj.Zombie.Value or obj.Name
    end,
    IsEnabled = "NPCs",
})
--some toggle:
ESP.NPCs = true
```

Full list of options and their explanation below:

> Recursive - true/false, whether to use DescendantAdded instead of ChildAdded or not

> Type - the expected ClassName/base class of the object, ex. Model, Part, BasePart, etc.

> Name - the expected Name of the object

> Validator(obj) - function, should return true if the object should be added to the ESP

> PrimaryPart - the name of the part under the object that the ESP should treat as the primary part, can also be a function which should return the part

> Color - either a Color3 or a function which returns a Color3 (will only be called once)

> ColorDynamic - explained earlier

> Name - a string or a function which returns one

> IsEnabled - explained earlier

> RenderInNil - explained earlier

> OnAdded(box) - function, will get called after an object has been added to the ESP by the listener

**Integrating custom drawing objects with the ESP**

If you have something like a FOV circle which uses the drawing api and you don't want to make a separate RenderStepped loop just to update it, you can integrate it with the ESP's update loop. It will get updated **even if the ESP is toggled off**. All you have to do is make a table with an Update function, and then insert it into ESP.Objects table

FOV circle example:
```lua
local mouse = game.Players.LocalPlayer:GetMouse()

local FOVCircle = Drawing.new("Circle")
FOVCircle.Radius = 50
FOVCircle.Color = Color3.fromRGB(255, 170, 0)
FOVCircle.Thickness = 3
FOVCircle.Filled = false

local CircleTbl = {
    Update = function()
        FOVCircle.Position = Vector2.new(mouse.X, mouse.Y+36)
    end
}
table.insert(ESP.Objects, CircleTbl)
```

The reason it's going to update it even if ESP is toggled off is because in the RenderStepped loop it uses "pairs" when ESP is enabled, and "ipairs" when it's disabled. In other words, it only loops through the numerical indexes when ESP is disabled, and regular objects use dictionary keys, so it will only iterate values inserted with table.insert or such raysCool


You're free to use/modify it however you want, just don't claim it as your own. Credits would be cool but you don't have to.
Enjoy!
