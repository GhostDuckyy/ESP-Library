# ReadMe
Made by [**EduardoSalamanca**](https://v3rmillion.net/member.php?action=profile&uid=2791063) | [V3rmillion Thread](https://v3rmillion.net/showthread.php?pid=8366597#pid8366597)

### Loadstring
```lua
_G.chamsEnabled = true -- VALUES: true | false  ;  If true then enables chams. Chams may be unstable in some games, set to false if crashing. (this was before highlights were released lol)
local esp, esp_renderstep, framework = loadstring(game:HttpGet("http://ionhub.nomercy.rip/modules/esp_library.txt"))();
```

### Preview
![a](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.imgur.com%2FcGqdKie.png)
![b](https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fi.imgur.com%2Fza9JECQ.png)

### Example
```lua
Samples on how to use (Does not show everything but good quick tutorial):
-- Library
_G.chamsEnabled = true -- VALUES: true | false  ;  If true then enables chams. Chams may be unstable in some games, set to false if crashing. (this was before highlights were released lol)
local esp, esp_renderstep, framework = loadstring(game:HttpGet("http://ionhub.nomercy.rip/modules/esp_library.txt"))();

-- Player connections
local players = game.Players;
for _, player in pairs(players:GetPlayers()) do
    if player == players.LocalPlayer then continue; end;
    esp:Player(player);
end;
players.PlayerAdded:Connect(function(player)
    esp:Player(player);
end);
players.PlayerAdded:Connect(function(player)
    local obj = esp:GetObject(player)
    if obj then
        obj:Destroy();
    end;
end);

-- Some basic settings
esp.Settings.Enabled = true;
esp.Settings.Maximal_Distance = 500;
esp.Settings.Object_Maximal_Distance = 500;

esp.Settings.Box.Enabled = true;
esp.Settings.Box_Outline.Enabled = true;

esp.Settings.Name.Enabled = true;
esp.Settings.Name.Position = "Bottom";

--[[
    -- [ ADDING OBJECTS ]
    Exmaple of adding "exits" to the esp : Game Project Delta

    local ExitLocations = NoCollision:FindFirstChild("ExitLocations")
    if ExitLocations then
        Utility:Connection(ExitLocations.ChildAdded, function(Child)
            if Child:IsA("BasePart") then
                if Flags.objectsEnabled and Flags.objectsExits then
                    ESP:Object(Child, {
                        Type = "Exit",
                        Color = Flags.objectsExitsColor,
                        Transparency = Framework:Drawing_Transparency(Options.objectsExitsColor.trans),
                        Outline = Flags.objectOutline
                    })
                end
            end
        end)
       
        -- [ ENABLING OBJECTS]
        for _, Item in pairs(ExitLocations:GetChildren()) do
            if Item:IsA("BasePart") then
                ESP:Object(Item, {
                    Type = "Exit",
                    Color = Flags.objectsExitsColor,
                    Transparency = Framework:Drawing_Transparency(Options.objectsExitsColor.trans),
                    Outline = Flags.objectOutline
                })
            end
        end

        -- [ REMOVING OBJECTS ]
        Utility:Connection(ExitLocations.ChildRemoved, function(Child)
        if Child:IsA("BasePart") then
                local Object = ESP:GetObject(Child)
                if Object then
                    Object:Destroy()
                end
            end
        end)

        for _, Object in pairs(ESP.Objects) do
            if Object.Type == "Exit" then
                Object:Destroy()
            end
        end
    end;
]]
```
