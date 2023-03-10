-- This was my first time ever using the drawing library, there's probably 200 issues I haven't found yet. Please tell me if there are any problems.


local Players = game:GetService("Players")

local ESP = {
    Enabled = true,
    Settings = {
        RemoveOnDeath = true,
        MaxDistance = 300, -- Max Distance for esp to render (IN METERS).
        MaxBoxSize = Vector3.new(15, 15, 0), -- Max size for ESP boxes.
        DestroyOnRemove = true, -- Whether the ESP objects should be deleted when the character is parented to nil, change this if you want.
        TeamColors = false, -- Whether or not the ESP color is based on team colors.
        TeamBased = false, -- Whether or not the ESP should render ESP on teammates. 
        BoxTopOffset = Vector3.new(0, 1, 0), -- Offset for where the top of the box should be
        
        Boxes = {
            Enabled = true,
            Color = Color3.new(1, 0, 1),
            Thickness = 1,
        },
        Names = {
            Distance = true,
            Health = true, -- Adds health values to the nametag.
            Enabled = true,
            Resize = true, -- Resizes the text based on the distance from the camera to the player so text doesn't get ridiculously large the further you are from the target.
            ResizeWeight = 0.05, -- How quickly names are resized based on the distance from the camera.
            Color = Color3.new(1, 1, 1),
            Size = 18,
            Font = 1,
            Center = true,
            Outline = true,
        },
        Tracers = {
            Enabled = true,
            Thickness = 0,
            Color = Color3.new(1, 0, 1),
        }
    },
    Objects = {} -- Table of ESP objects that you can read and do fun stuff with, however, editing settings changes the settings for every object at the same time so this is only needed if you want to set settings for individual targets.
}





-- Initial functions for the lib that are used in functions like GetQuad, DrawQuad, Etc.

local function Draw(Type, Properties) -- Manually writing every property and Drawing.new() is extremely painful, making it a table is bazed. I definitely didn't steal this idea from ic3w0lf.
    local Object = Drawing.new(Type)
    
    for Property, Value in next, Properties or {} do -- Prevents errors
        Object[Property] = Value
    end
    
    return Object
end

function ESP:GetScreenPosition(Position) -- Gets the screen position of a vector3 / cframe.
    local Position = typeof(Position) ~= "CFrame" and Position or Position.Position -- I'm probably going to forget to use .Position like a proper dumbfuck.
    local ScreenPos, IsOnScreen = workspace.CurrentCamera:WorldToViewportPoint(Position)
    
    return Vector2.new(ScreenPos.X, ScreenPos.Y), IsOnScreen -- fuck the depth value i dont want it :<
end

function ESP:GetDistance(Position) -- Gets the distance (IN METERS) from the camera position to a target position.
    local Magnitude = (workspace.CurrentCamera.CFrame.Position - Position).Magnitude
    local Metric = Magnitude * 0.28 -- Converts studs to meters
    
    return math.round(Metric)
end

function ESP:GetHealth(Model) -- Tries to find a humanoid and grab its health, this needs to be overwritten in games that have custom health paths.
    local Humanoid = Model:FindFirstChildOfClass("Humanoid")
    
    if Humanoid then
        return Humanoid.Health, Humanoid.MaxHealth, (Humanoid.Health / Humanoid.MaxHealth) * 100
    end
    
    return 100, 100, 100
end

function ESP:GetPlayerFromCharacter(Model) -- Tries to get a player from their character, if the character doesn't have a player linked to it (thanks custom character games like bad business), it returns nil.
    return Players:GetPlayerFromCharacter(Model)
end

function ESP:GetTeam(Model) -- Tries to get a player's team from their character model, if there is no player linked, this returns nil.
    local Player = ESP:GetPlayerFromCharacter(Model)
    
    return Player and Player.Team or nil
end

function ESP:GetPlayerTeam(Player) -- Tries to get a player's team, this won't work in games that have custom modules to get player teams and needs to be overwritten.
    return Player and Player.Team
end

function ESP:IsHostile(Model) -- Tries to check if a player is hostile based on their team, this, again, won't work with custom characters.
    local Player = ESP:GetPlayerFromCharacter(Model)
    local MyTeam, TheirTeam = ESP:GetPlayerTeam(Players.LocalPlayer), ESP:GetPlayerTeam(Player)
    
    return (MyTeam ~= TheirTeam)
end

function ESP:GetTeamColor(Model) -- Tries to get a player's teamcolor from their character model or from their player directly.
    local Team = Model:IsA("Model") and ESP:GetTeam(Model) or Model:IsA("Player") and ESP:GetPlayerTeam(Model) 
    
    return Team and Team.TeamColor.Color or Color3.new(1, 0, 0)
end

function ESP:GetOffset(Model)
    local Humanoid = Model:FindFirstChild("Humanoid")
    
    if Humanoid and Humanoid.RigType == Enum.HumanoidRigType.R6 then
        return CFrame.new(0, -1.75, 0)
    end
    
    return CFrame.new(0, 0, 0)
end

function ESP:CharacterAdded(Player) -- Some games have custom characteradded signals, edit this if you want to change it for compatibility.
    return Player.CharacterAdded
end

function ESP:GetCharacter(Player) -- Some games have custom characters and leave player.Character nil, edit this if you need it.
    return Player.Character
end

local function Validate(Child, Type, ClassName, ExpectedName)
    return not (Type or ClassName or ExpectedName) or (not ExpectedName or (ExpectedName and Child.Name == ExpectedName)) and (not ClassName or (ClassName and Child.ClassName == ClassName)) and (not Type or (Type and Child:IsA(Type))) -- I hate my life.
end

function ESP:AddListener(Model, Validator, Settings)
    local Descendants = Settings.Descendants
    local Type, ClassName, ExpectedName = Settings.Type, Settings.ClassName, Settings.ExpectedName
    local ExtraSettings = Settings.Custom or {}
    
    local function ValidCheck(Child)
        if typeof(Validator) == "function" and Validator(Child) or not Validator then
            if Validate(Child, Type, ClassName, ExpectedName) then
                ESP.Object:New(Child, ExtraSettings)
            end
        end
    end
    
    local Connection = Descendants and Model.DescendantAdded or Model.ChildAdded
    local ObjectsToCheck = Descendants and Model.GetDescendants or Model.GetChildren
    
    Connection:Connect(function(Child)
        task.spawn(ValidCheck, Child)
    end)
    
    for i, Child in next, ObjectsToCheck(Model) do
        task.spawn(ValidCheck, Child)
    end
end


-- Actual drawing functions for making boxes and stuff weee.

local Object = {}
Object.__index = Object

ESP.Object = Object

local function Clone(Table) -- es not mine i stole it from roblox docs
    local Ret = {}
    
    for i,v in next, Table do
        if typeof(v) == "table" then
            v = Clone(v)
        end
        
        Ret[i] = v
    end
    
    return Ret
end

local function GetValue(Local, Global, Name) -- Blame the bird. Easy way to check if a setting is enabled on either the object settings or global settings.
    local GlobalVal = Global[Name]
    local LocalVal = Local[Name]
    
    return LocalVal or ((LocalVal == nil or typeof(LocalVal) ~= "boolean") and GlobalVal)
end

function Object:New(Model, ExtraInfo) -- Object:New(Target, {Name = "Custom Name", Settings = {Box = {Color = Color3.new(0, 1, 0)}}})
    if not Model then
        return
    end
    
    local Settings = ESP.Settings
    
    local NewObject = {
        Connections = {},
        RenderSettings = {
            Boxes = {},
            Tracers = {},
            Names = {},
        },
        GlobalSettings = Settings,
        Model = Model,
        Name = Model.Name,
        
        Objects = {
            Box = {
                Color = Settings.Boxes.Color,
                Thickness = Settings.Boxes.Thickness,
            },
        
            Name = {
                Color = Settings.Names.Color,
                Outline = Settings.Names.Outline,
                Text = Model.Name,
                Size = Settings.Names.Size,
                Font = Settings.Names.Font,
                Center = Settings.Names.Center,
            },
            
            Tracer = {
                Thickness = Settings.Tracers.Thickness,
                Color = Settings.Tracers.Color,
            }
        },
    }
    
    for Property, Value in next, ExtraInfo or {} do -- Honestly, I did this at 2am and I can't remember why I did it, probably because I had to filter variables so the stupid drawing objects wouldn't get ESP settings tangled up in the variabled like Enabled, causing an error.
        
        if Property ~= "Settings" then
            NewObject[Property] = Value
        else
            for Name, Table in next, Value do
                for Property, Value in next, Table do
                    NewObject.RenderSettings[Name][Property] = Value
                end
            end
        end
    end
    
    NewObject = setmetatable(NewObject, Object)
    ESP.Objects[Model] = NewObject

    NewObject.Objects.Box = Draw("Quad", NewObject.Objects.Box)
    NewObject.Objects.Name = Draw("Text", NewObject.Objects.Name)
    NewObject.Objects.Tracer = Draw("Line", NewObject.Objects.Tracer)
    
    NewObject.Connections.Destroying = Model.Destroying:Connect(function() -- We don't want the ESP to try to render an object that doesn't exist anymore.
        NewObject:Destroy()
    end)
    
    NewObject.Connections.AncestryChanged = Model.AncestryChanged:Connect(function(Old, New) -- Ditto on the Destroying connection, but some games might try to parent characters to nil to prevent esp so this could cause problems and can be toggled.
        if not Model:IsDescendantOf(workspace) and NewObject.RenderSettings.DestroyOnRemove or NewObject.GlobalSettings.DestroyOnRemove then
            NewObject:Destroy()
        end
    end)

    local Humanoid = Model:FindFirstChildOfClass("Humanoid")
    
    if Humanoid then
        NewObject.Connections.Died = Humanoid.Died:Connect(function()
            if Settings.RemoveOnDeath then
                NewObject:Destroy()
            end
        end)
    end
    
    NewObject.Connections.Removing = Model.AncestryChanged:Connect(function()
        if NewObject.RenderSettings.DestroyOnRemove or NewObject.GlobalSettings.DestroyOnRemove then
            NewObject:Destroy()
        end
    end)
    
    return NewObject
end

function Object:GetQuad() -- Gets a table of positions for use in pretty much every ESP function. This also returns if the player is onscreen and will not return anything in the case that they aren't.
    local RenderSettings = self.RenderSettings
    local GlobalSettings = self.GlobalSettings
    
    local MaxSize = GetValue(RenderSettings, GlobalSettings, "MaxBoxSize")
    local BoxTopOffset = GetValue(RenderSettings, GlobalSettings, "BoxTopOffset")
    
    local Model = self.Model
    local Pivot = Model:GetPivot()
    local BoxPosition, Size = Model:GetBoundingBox()
    
    Pivot = Pivot * ESP:GetOffset(Model)
    
    Size = Size * Vector3.new(1, 1, 0) -- Thanks synapse editor for not supporting compound operators very cool (also fuck the depth).

    local X, Y = math.clamp(Size.X, 1, MaxSize.X) / 2, math.clamp(Size.Y, 1, MaxSize.Y) / 2
    
    -- Hey check out this amazing epic readable math and very simple easy-to-type variable names.
    -- There's some leftover code here from when I was using Vector3s instead of CFrames. If you want boxes to be locked on one axis, you can add this back. You're a sociopath if you do, though.
    local PivotVector, PivotOnScreen = (ESP:GetScreenPosition(Pivot.Position))
    local BoxTop = ESP:GetScreenPosition((Pivot * CFrame.new(0, Y, 0)).Position + (BoxTopOffset)) --[[+ (Size * Vector3.new(0, 1, 0) / 2) + Vector3.new(0, 1, 0)]]
    local BoxBottom = ESP:GetScreenPosition((Pivot * CFrame.new(0, -Y, 0)).Position)
    local TopRight, TopRightOnScreen = ESP:GetScreenPosition((Pivot * CFrame.new(-X, Y, 0)).Position) --[[+ ((Size * Vector3.new(-1, 1, 0)) / 2)]]
    local TopLeft, TopLeftOnScreen = ESP:GetScreenPosition((Pivot * CFrame.new(X, Y, 0)).Position)--[[Pivot + (Size / 2))]]
    local BottomLeft, BottomLeftOnScreen = ESP:GetScreenPosition((Pivot * CFrame.new(X, -Y, 0)).Position) --[[+ ((Size * Vector3.new(1, -1, 0)) / 2))]]
    local BottomRight, BottomRightOnScreen = ESP:GetScreenPosition((Pivot * CFrame.new(-X, -Y, 0)).Position)--[[ - (Size / 2))]]
    
    if TopRightOnScreen or TopLeftOnScreen or BottomLeftOnScreen or BottomRightOnScreen then -- Boxes don't cause weird drawing issues if any part of the character is on-screen (only checks the bounding box, a player's arm can be slightly poking out and the box won't draw).
        local Positions = {
            BoxBottom = BoxBottom, -- For tracers :3.
            Pivot = PivotVector, -- The model base because maybe I'll use it? I have no idea stop asking me these questions.
            BoxTop = BoxTop, -- Just above the top of the model because funny nametag esp.
            TopRight = TopRight,    -- Top Right
            TopLeft = TopLeft,     -- Top Left
            BottomLeft = BottomLeft,  -- Bottom Left
            BottomRight = BottomRight, -- Bottom Right
        }
    
        return Positions, true -- The player is on the screen, so the box can be drawn.
    end
    
    return false -- The player is offscreen and drawing this box is going to do crazy shit, stop.
end

function Object:DrawBox(Quad) -- Draws a box around the player based on a given quad.
    local RenderSettings = self.RenderSettings
    local GlobalSettings = self.GlobalSettings
    
    local RenderBoxes = RenderSettings.Boxes
    local GlobalBoxes = GlobalSettings.Boxes
    
    local TeamColors = GetValue(RenderSettings, GlobalSettings, "TeamColors")
    local Thickness = GetValue(RenderBoxes, GlobalBoxes, "Thickness")
    local Color = GetValue(RenderBoxes, GlobalBoxes, "Color")

    local Properties = {
        Visible = true,
        Color = TeamColors and ESP:GetTeamColor(self.Model) or Color,
        Thickness = Thickness,
        PointA = Quad.TopRight,
        PointB = Quad.TopLeft,
        PointC = Quad.BottomLeft,
        PointD = Quad.BottomRight,
    }
    
    for Property, Value in next, Properties do
        self.Objects.Box[Property] = Value
    end
end

function Object:DrawName(Quad)
    local RenderSettings = self.RenderSettings
    local GlobalSettings = self.GlobalSettings
    
    local RenderNames = RenderSettings.Names
    local GlobalNames = GlobalSettings.Names
    
    
    local Settings = RenderSettings.Names or GlobalNames
    
    local ShowDistance = GetValue(RenderNames, GlobalNames, "Distance")
    local Size = GetValue(RenderNames, GlobalNames, "Size")
    local Resize = GetValue(RenderNames, GlobalNames, "Resize")
    local ResizeWeight = GetValue(RenderNames, GlobalNames, "ResizeWeight")
    local ShowHealth = GetValue(RenderNames, GlobalNames, "Health")
    local Font = GetValue(RenderNames, GlobalNames, "Font")
    local Center = GetValue(RenderNames, GlobalNames, "Center")
    local TeamColors = GetValue(RenderNames, GlobalNames, "TeamColors")
    local Color = GetValue(RenderNames, GlobalNames, "Color")
    local Outline = GetValue(RenderNames, GlobalNames, "Outline")
    
    local Distance = self.Model:GetPivot().Position
    
    local Properties = {
        Visible = true,
        Color = TeamColors and ESP:GetTeamColor(self.Model) or Color,
        Outline = Outline,
        Text = not (Size or ShowHealth) and self.Name or ("%s [%sm]%s"):format(self.Name, ShowDistance and tostring(ESP:GetDistance(Distance)) or "", ShowHealth and ("\n%d/%d (%d%%)"):format(ESP:GetHealth(self.Model)) or ""), -- My god this is an ugly string.format
        Size = not Resize and Size or Size - math.clamp((ESP:GetDistance(Distance) * ResizeWeight), 1, Size * 0.75),
        Font = Font,
        Center = Center,
        Position = Quad.BoxTop,
    }

    for Property, Value in next, Properties do
        self.Objects.Name[Property] = Value
    end
end

function Object:DrawTracer(Quad)
    local RenderSettings = self.RenderSettings
    local GlobalSettings = self.GlobalSettings
    
    local RenderTracers = RenderSettings.Tracers
    local GlobalTracers = GlobalSettings.Tracers
    
    local TeamColors = GetValue(RenderTracers, GlobalTracers, "TeamColors")
    local Color = GetValue(RenderTracers, GlobalTracers, "Color")
    local Thickness = GetValue(RenderTracers, GlobalTracers, "Thickness")
    
    local Properties = {
        Visible = true,
        Color = TeamColors and ESP:GetTeamColor(self.Model) or Color,
        Thickness = Thickness,
        From = workspace.CurrentCamera.ViewportSize * Vector2.new(.5, 1),
        To = Quad.BoxBottom,
    }
    
    for Property, Value in next, Properties do
        self.Objects.Tracer[Property] = Value
    end
end

function Object:Destroy()
    ESP.Objects[self.Model] = nil
    self:ClearDrawings()
    
    for i,v in next, self.Objects do
        v:Remove()
    end
    
    for i,v in next, self.Connections do -- I could use a module like maid but I'm lazy.
        v:Disconnect()
    end
    
    table.clear(self.Objects)
end

function Object:ClearDrawings()
    for i,v in next, self.Objects do
        v.Visible = false
    end
end

function Object:Refresh()
    local Model = self.Model
    local Quad = self:GetQuad()
    local RenderSettings = self.RenderSettings
    local GlobalSettings = self.GlobalSettings
    
    local TeamBased = GetValue(RenderSettings, GlobalSettings, "TeamBased")
    local MaxDistance = GetValue(RenderSettings, GlobalSettings, "MaxDistance")
    local Boxes = GetValue(RenderSettings.Boxes, GlobalSettings.Boxes, "Enabled")
    local Names = GetValue(RenderSettings.Names, GlobalSettings.Names, "Enabled")
    local Tracers = GetValue(RenderSettings.Tracers, GlobalSettings.Tracers, "Enabled")
    
    if not ESP.Enabled then
        return self:ClearDrawings() -- This is obvious and doesn't need a comment, but I am adding a comment here because it's funny.
    end
    
    if not Model.Parent or not Model:IsDescendantOf(workspace) then
        return self:ClearDrawings() -- I don't want stuff to render in nil, edit this if you don't like it pls.
    end
    
    if not Quad then 
        return self:ClearDrawings() -- Player isn't on-screen
    end
    
    if TeamBased and not ESP:IsHostile(Model) then
        return self:ClearDrawings()
    end
    
    if ESP:GetDistance(Model:GetPivot().Position) > MaxDistance then
        return self:ClearDrawings()
    end
    
    if Boxes then
        self:DrawBox(Quad)
    else
        self.Objects.Box.Visible = false
    end
    
    if Names then
        self:DrawName(Quad)
    else
        self.Objects.Name.Visible = false
    end
    
    if Tracers then
        self:DrawTracer(Quad)
    else
        self.Objects.Tracer.Visible = false
    end
end

game.RunService.Stepped:Connect(function()
    for i, Object in next, ESP.Objects do
        Object:Refresh()
    end
end)

return ESP
