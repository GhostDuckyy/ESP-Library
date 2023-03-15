# Documentation
### Waypoints
[**Loadstring**](https://github.com/GhostDuckyy/ESP-Library/blob/main/Customizable%20ESP%20Library/Docs.md#loadstring), [**Settings**](https://github.com/GhostDuckyy/ESP-Library/blob/main/Customizable%20ESP%20Library/Docs.md#settings), [**Functions**](https://github.com/GhostDuckyy/ESP-Library/blob/main/Customizable%20ESP%20Library/Docs.md#functions), [**Object**](https://github.com/GhostDuckyy/ESP-Library/blob/main/Customizable%20ESP%20Library/Docs.md#object), [**Example**](https://github.com/GhostDuckyy/ESP-Library/blob/main/Customizable%20ESP%20Library/Docs.md#example)
## Loadstring
```lua
local ESP = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ESP-Library-9570", true))("there are cats in your walls let them out let them out let them out")
```
## Settings
```css
ESP.Enabled : boolean -- Determines whether ESP should be rendered
ESP.Settings : table -- Holds the settings for every ESP component
ESP.Objects : table -- Holds every current ESP object
```

```css
RemoveOnDeath : boolean -- Determines whether ESP should unload after the player dies
MaxDistance : number -- Determines how far a player needs to be from camera (in meters) for ESP to not load for them
MaxBoxSize : Vector3 -- Determines the max size for a player's ESP box in case some goofy issue happens and the player model is so big that it is annoying
DestroyOnRemove : boolean -- Determines whether ESP objects should destroy themselves if the model gets moved to nil
TeamColors : boolean -- Determines whether ESP colors should be based on player teams
TeamBased : boolean -- Determines whether ESP should only load on Hostiles
BoxTopOffset : Vector3 -- Determines how far above the player the top of the box should be, this effects where nametags are drawn
```
#### Boxes
```css
Boxes : {
	Enabled : boolean, -- Determines whether boxes should be drawn
	Color : Color3, -- Determines the color for the boxes
	Thickness : number  -- Determines the thickness of the box lines
}
```
#### Names
```css
Names : {
	Distance : boolean, -- Determines whether distance should be shown in nametags
	Health : boolean, -- Determines whether health should be shown in nametags
	Enabled : boolean, -- Determines whether nametags should be drawn
	Resize : boolean, -- Determines whether names should resize based on the distance from the camera so names don't have a static size
	ResizeWeight :  number, -- Determines how quickly names should be resized based on the distance from the camera
	Color : Color3, -- Determines the color of the name
	Size : number, -- Determines the size of the name
	Font : Drawing.Font | number, -- Determines the font of the text (0-3)
	Center : boolean, -- Determines whether text should be centered
	Outline : boolean, -- Determines whether text should be outlined
}
```

#### Tracers
```css
Tracers : {
	Enabled : boolean, -- Determines whether tracers should be drawn
	Thickness : number, -- Determines the thickness of tracers
	Color : Color3, -- Determines the color of tracers
}
```
## Functions
#### AddListener
**Creates** a **new instance listener** on the Model, because this is so **overcomplicated**.
```lua
function ESP:AddListener(Model : Instance, Validator : function?, Settings : table?)

Settings : {
	Descendants : boolean, -- Determines whether descendants should also be checked, this is super laggy so I don't recommend it unless it's nescessary
	Type : string?, -- What the IsA check is going to look for (superclasses and classnames included)
	ClassName : string?, -- The classname the Listener will look for
	ExpectedName : string?, -- If this is set, it'll only add esp to objects with this name
	Custom : table?, -- Allows you to set the ESP settings of individual objects that passed through the validator checks. Example: Custom = {Name --[[Custom name for the model]] = "the cats are still in your wall, why haven't you let them out?", Settings = {Boxes = {Color = Color3.new(0, 1, 0}}}
}
```
#### GetScreenPosition
The **same** thing as [**Camera:WorldToViewportPoint**](https://create.roblox.com/docs/reference/engine/classes/Camera#WorldToViewportPoint), but it **doesn't** have the **depth value** and **returns** a **Vector2 of X and Y of the ViewportPoint's position**.
```lua
function ESP:GetScreenPosition(Position : Vector3)
```
#### GetDistance
```lua
function ESP:GetDistance(Position : Vector3)  -- Returns a number that represents the distance from the camera to that position in meters.
```
#### GetHealth
**Returns** the **health**, **maxhealth**, and **percentage of health** of any **humanoid** in the given model, if the model doesn't have a **humanoid**, this **returns** `100`, `100`, and `100`.
```lua
function ESP:GetHealth(Model : Instance)
```
#### GetPlayerFromCharacter
**Same** thing as [**Players:GetPlayerFromCharacter**](https://create.roblox.com/docs/reference/engine/classes/Players#GetPlayerFromCharacter).
```lua
function ESP:GetPlayerFromCharacter(Model : Instance)
```
#### GetPlayerTeam
Tries to find a **team** for the **player**, this won't work in some games and will have to be edited to allow for **custom teams**.
```lua
function ESP:GetPlayerTeam(Player : Player)
```
#### IsHostile
Checks if the **LocalPlayer**'s team is the **same as the target's team**, returns **true** if so.
```lua
function ESP:IsHostile(Model : Instance)
```
#### GetTeamColor
**Grabs** the player's team based on their **character** or **player instance**, this relies on **GetTeam** which will need to be **overridden** if the game has **custom teams** or **characters**.
```lua
function ESP:GetTeamColor(Model: Instance | Player)
```
#### GetOffset
If the **player** has a **humanoid** and their rig is **R6**, the Y offset for all ESP objects is `-1.75` to fix a bug where stuff would render higher than it should on **R6** rigs. Defaults to Y = `0`.
```lua
function ESP:GetOffset(Model : Instance)
```
#### CharacterAdded
**Returns** the event for when **players characters are added**, some games have **custom CharacterAdded signals** so this may need to be **overridden**.
```lua
function ESP:CharacterAdded(Player : Player)
```
#### GetCharacter
**Returns** the **character** model for a player, again, **custom characters** may break this and it ay need to be **overridden**.
```lua
function ESP:GetCharacter(Player : Player)
```
## Object
All [**Drawing functions**](https://docs.synapse.to/docs/reference/drawing_lib.html) in **object** are **based off** of the **settings** given to them. **Editing** the **settings table** changes the **settings** for **every object**, but if you change the **settings** for an **individual object**, it only changes the **settings** for that one. All **colors** are individual unless the **TeamColors** value is set to **true**.
### Settings
```css
Object.RenderSettings : table -- Stores every given setting for the current object, change this to individually change the settings of each object
Object.Model : Instance -- The given model for the ESP object
Object.Name : string -- The given name for the object, defaults to the model name
Object.Objects : table -- Holds every drawing object for the current object
Object.Connections : table -- Holds every current connection for the object
```
### Functions
#### New
**Returns** a **new ESP object** for the **player** and **handles all of the connections**, if you put **custom values** into the **ExtraInfo table**, it will change the **ESP settings** for this **individual object**. This could be **useful** if you want to **customize esp** for **specific players**.
```lua
function Object:New(Model : Model, ExtraInfo : table?)
```
#### GetQuad
If the **target** is **on-screen**, this **returns** a **quad containing Vector2s of certain positions** in the given object that **includes** `BoxBottom`, `Pivot`, `BoxTop`, `TopRight`, `TopLeft`, `BottomLeft`, `BottomRight`; Otherwise, this **returns false**.
```lua
function Object:GetQuad()
```
#### DrawBox
**Draws** a **box** around the given **quad** based on `TopRight`, `TopLeft`, `BottomLeft`, and `BottomRight`.
```lua
function Object:DrawBox(Quad : table)
```
#### DrawName
**Draws** the **name** given to the **object**; if **Distance** is **enabled**, this also **draws** the **distance** to the **player** in **meters**; and if **Health** is **enabled**, this also **draws** the **player**'s **health** as **CurrentHealth** / **MaxHealth** (**Health Percentage**%).
```lua
function Object:DrawName(Quad : table)
```
#### DrawTracer
**Draws** a **tracer** from the **middle** of the screen on the **X axis** and the **bottom** of the screen on the **Y axis** to the `BoxTop` **value** in the **Quad**.
```lua
function Object:DrawTracer(Quad : table)
```
#### Destroy
**Destroys** the **ESP object**, all of its **connected events**, all of its **drawings**, and the **Object** in the `ESP.Objects` holder.

```lua
function Object:Destroy()
```
#### ClearDrawings
Makes every **drawing** in the **object invisible**.
```lua
function Object:ClearDrawings()
```
#### Refresh
**Refreshes** the **values** of every **drawing** in the **object** based on the **settings** and **current state** of the **target model**.
```lua
function Object:Refresh()
```
# Example
### Basic ESP
Overrides, GetCharacter, CharacterAdded, and Object:New
```lua
local Players = game:GetService("Players")
local ESP = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ESP-Library-9570", true))("there are cats in your walls let them out let them out let them out")

--[[
"How do we add overrides like in kiriot's esp?"

function ESP:GetTeamColor()
   return Color3.new(0, 0, 1)
end
]]

for i, Player in next, Players:GetPlayers() do
   ESP.Object:New(ESP:GetCharacter(Player))
   ESP:CharacterAdded(Player):Connect(function(Character)
       ESP.Object:New(Character)
   end)
end

Players.PlayerAdded:Connect(function(Player)
   ESP.Object:New(ESP:GetCharacter(Player))
   ESP:CharacterAdded(Player):Connect(function(Character)
       ESP.Object:New(Character)
   end)
end)
```
### Bad Business ESP with Listeners
```lua
local ESP = loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-ESP-Library-9570", true))("there are cats in your walls let them out let them out let them out")

local Players = game:GetService("Players")

ESP.Settings.TeamBased = false
ESP.Settings.TeamColors = false

local TS = require(game:GetService("ReplicatedStorage").TS)

local function IsHostile(Character)
    local Player = TS.Characters:GetPlayerFromCharacter(Character)
    
    if not Player then return false end
    
    local TeamPlayer = game.Teams:FindFirstChild(Player.Name, true)
    
    return TeamPlayer and TeamPlayer.Parent ~= game.Teams:FindFirstChild(game.Players.LocalPlayer.Name, true).Parent or false
end

ESP:AddListener(workspace.Characters, function(Child) task.wait(1) return IsHostile(Child) end, {
    Descendants = false, 
    Type = "Model",
    Custom = {
        Name = "Enemy",
        Settings = {
            Boxes = {
                Color = Color3.new(1, 0, 0)
            },
            Tracers = {
                Color = Color3.new(1, 0, 0)
            }
        }
    }
})
```
