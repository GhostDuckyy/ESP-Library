--[[------------------------------------------------
|
|    Library Made for IonHub (discord.gg/seU6gab)
|    Developed by tatar0071#0627 and tested#0021
|    IF YOU USE THIS, PLEASE CREDIT DEVELOPER(S)!
|
--]]------------------------------------------------

-- Services
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Framework
local Framework = {}; Framework.__index = Framework; do
    function Framework:Round_V2(V2)
        return Vector2.new(math.floor(V2.X + 0.5), math.floor(V2.Y + 0.5))
    end
    function Framework:V3_To_V2(V3)
        return Vector2.new(V3.X, V3.Y)
    end
    function Framework:Draw(Object, Properties)
        Object = Drawing.new(Object)
        for Property, Value in pairs(Properties) do
            Object[Property] = Value
        end
        return Object
    end
    function Framework:Instance(Object, Properties)
        Object = Instance.new(Object)
        for Property, Value in pairs(Properties) do
            Object[Property] = Value
        end
        return Object
    end
    function Framework:Get_Bounding_Vectors(Part)
        local Part_CFrame, Part_Size = Part.CFrame, Part.Size 
        local X, Y, Z = Part_Size.X, Part_Size.Y, Part_Size.Z
        return {
            TBRC = Part_CFrame * CFrame.new(X, Y * 1.3, Z),
            TBLC = Part_CFrame * CFrame.new(-X, Y * 1.3, Z),
            TFRC = Part_CFrame * CFrame.new(X, Y * 1.3, -Z),
            TFLC = Part_CFrame * CFrame.new(-X, Y * 1.3, -Z),
            BBRC = Part_CFrame * CFrame.new(X, -Y * 1.6, Z),
            BBLC = Part_CFrame * CFrame.new(-X, -Y * 1.6, Z),
            BFRC = Part_CFrame * CFrame.new(X, -Y * 1.6, -Z),
            BFLC = Part_CFrame * CFrame.new(-X, -Y * 1.6, -Z),
        };
    end
    function Framework:Drawing_Transparency(Transparency)
        return 1 - Transparency
    end
end

-- Main
if not isfolder("ESP") then makefolder("ESP") end
if not isfolder("ESP/assets") then makefolder("ESP/assets") end
if not isfile("ESP/assets/taxi.oh") then
    writefile("ESP/assets/taxi.oh", game:HttpGet("https://raw.githubusercontent.com/tatar0071/IonHub/main/Assets/taxi.png"))
end
if not isfile("ESP/assets/gorilla.oh") then
    writefile("ESP/assets/gorilla.oh", game:HttpGet("https://raw.githubusercontent.com/tatar0071/IonHub/main/Assets/gorilla.png"))
end
if not isfile("ESP/assets/saul_goodman.oh") then
    writefile("ESP/assets/saul_goodman.oh", game:HttpGet("https://raw.githubusercontent.com/tatar0071/IonHub/main/Assets/saul_goodman.png"))
end
if not isfile("ESP/assets/peter_griffin.oh") then
    writefile("ESP/assets/peter_griffin.oh", game:HttpGet("https://raw.githubusercontent.com/tatar0071/IonHub/main/Assets/peter_griffin.png"))
end
if not isfile("ESP/assets/john_herbert.oh") then
    writefile("ESP/assets/john_herbert.oh", game:HttpGet("https://raw.githubusercontent.com/tatar0071/IonHub/main/Assets/john_herbert.png"))
end
if not isfile("ESP/assets/fortnite.oh") then
    writefile("ESP/assets/fortnite.oh", game:HttpGet("https://raw.githubusercontent.com/tatar0071/IonHub/main/Assets/fortnite.png"))
end
local Images = {
    Taxi = readfile("ESP/assets/taxi.oh"),
    Gorilla = readfile("ESP/assets/gorilla.oh"),
    ["Saul Goodman"] = readfile("ESP/assets/saul_goodman.oh"),
    ["Peter Griffin"] = readfile("ESP/assets/peter_griffin.oh"),
    ["John Herbert"] = readfile("ESP/assets/john_herbert.oh"),
    ["Fortnite"] = readfile("ESP/assets/fortnite.oh")
}

local ESP; ESP = {
    Settings = {
        Enabled = false,
        Bold_Text = false,
        Objects_Enabled = false,
        Team_Check = false,
        Improved_Visible_Check = false,
        Maximal_Distance = 1000,
        Object_Maximal_Distance = 1000,
        Highlight = {Enabled = false, Color = Color3.new(1, 0, 0), Target = ""},
        Box = {Enabled = false, Color = Color3.new(1, 1, 1), Transparency = 0},
        Box_Outline = {Enabled = false, Color = Color3.new(0, 0, 0), Transparency = 0, Outline_Size = 1},
        Healthbar = {Enabled = false, Position = "Left", Color = Color3.new(1, 1, 1), Color_Lerp = Color3.fromRGB(40, 252, 3)},
        Name = {Enabled = false, Position = "Top", Color = Color3.new(1, 1, 1), Transparency = 0, OutlineColor = Color3.new(0, 0, 0)},
        Distance = {Enabled = false, Position = "Bottom", Color = Color3.new(1, 1, 1), Transparency = 0, OutlineColor = Color3.new(0, 0, 0)},
        Tool = {Enabled = false, Position = "Right", Color = Color3.new(1, 1, 1), Transparency = 0, OutlineColor = Color3.new(0, 0, 0)},
        Health = {Enabled = false, Position = "Right", Transparency = 0, OutlineColor = Color3.new(0, 0, 0)},
        Chams = {Enabled = false, Color = Color3.new(1, 1, 1), Mode = "Visible", OutlineColor = Color3.new(0, 0, 0), Transparency = 0.5, OutlineTransparency = 0},
        Image = {Enabled = false, Image = "Taxi", Raw = Images.Taxi},
        China_Hat = {Enabled = false, Color = Color3.new(1, 1, 1), Transparency = 0.5, Height = 0.5, Radius = 1, Offset = 1}
    },
    Objects = {},
    Overrides = {},
    China_Hat = {}
}
ESP.__index = ESP

function ESP:UpdateImages()
    self.Settings.Image.Raw = Images[self.Settings.Image.Image]
    for _, Object in pairs(self.Objects) do
        for Index, Drawing in pairs(Object.Components) do
            if Index == "Image" then
                Drawing.Data = self.Settings.Image.Raw
            end
        end
    end
end

function ESP:GetObject(Object)
    return self.Objects[Object]
end

function ESP:Toggle(State)
    self.Settings.Enabled = State
end

function ESP:Get_Team(Player)
    if self.Overrides.Get_Team ~= nil then
        return self.Overrides.Get_Team(Player)
    end
    return Player.Team
end

function ESP:Get_Character(Player)
    if ESP.Overrides.Get_Character ~= nil then
        return ESP.Overrides.Get_Character(Player)
    end
    return Player.Character
end

function ESP:Get_Tool(Player)
    if self.Overrides.Get_Tool ~= nil then
        return self.Overrides.Get_Tool(Player)
    end
    local Character = self:Get_Character(Player)
    if Character then
        local Tool = Character:FindFirstChildOfClass("Tool")
        if Tool then
            return Tool.Name
        end
    end
    return "Hands"
end

function ESP:Get_Health(Player)
    if self.Overrides.Get_Character ~= nil then
        return self.Overrides.Get_Health(Player)
    end
    local Character = self:Get_Character(Player)
    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")
        if Humanoid then
            return Humanoid.Health
        end
    end
    return 100
end

local Passed = false
local function Pass_Through(From, Target, RaycastParams_, Ignore_Table)
    RaycastParams_.FilterDescendantsInstances = Ignore_Table
    local Result = Workspace:Raycast(From, (Target.Position - From).unit * 10000, RaycastParams_)
    if Result then
        local Instance_ = Result.Instance
        if Instance_:IsDescendantOf(Target.Parent) then
            Passed = true
            return true
        elseif Instance_.CanCollide == false or Instance_.Transparency == 1 then
            if Instance_.Name ~= "Head" and Instance_.Name ~= "HumanoidRootPart" then
                table.insert(Ignore_Table, Instance_)
                Pass_Through(Result.Position, Target, RaycastParams_, Ignore_Table)
            end
        end
    end
end

function ESP:Check_Visible(Target, FromHead)
    if self.Overrides.Check_Visible ~= nil then
        return self.Overrides.Check_Visible(Player)
    end
    local Character = LocalPlayer.Character
    if not Character then return false end
    local Head = Character:FindFirstChild("Head")
    if not Head then return false end
    local RaycastParams_ = RaycastParams.new();
    RaycastParams_.FilterType = Enum.RaycastFilterType.Blacklist;
    local Ignore_Table = {Camera, LocalPlayer.Character}
    RaycastParams_.FilterDescendantsInstances = Ignore_Table;
    RaycastParams_.IgnoreWater = true;
    local From = FromHead and Head.Position or Camera.CFrame.p
    local Result = Workspace:Raycast(From, (Target.Position - From).unit * 10000, RaycastParams_)
    Passed = false
    if Result then
        local Instance_ = Result.Instance
        if Instance_:IsDescendantOf(Target.Parent) then
            return true
        elseif ESP.Settings.Improved_Visible_Check and Instance_.CanCollide == false or Instance_.Transparency == 1 then
            if Instance_.Name ~= "Head" and Instance_.Name ~= "HumanoidRootPart" then
                table.insert(Ignore_Table, Instance_)
                Pass_Through(Result.Position, Target, RaycastParams_, Ignore_Table)
            end
        end
    end
    return Passed
end

local Player_Metatable = {}
do -- Player Metatable
    Player_Metatable.__index = Player_Metatable
    function Player_Metatable:Destroy()
        for Index, Component in pairs(self.Components) do
            if tostring(Index) == "Chams" then
                if _G.chamsEnabled == true then
                    Component:Destroy()
                end
                self.Components[Index] = nil
                continue
            end
            Component.Visible = false
            Component:Remove()
            self.Components[Index] = nil
        end
        ESP.Objects[self.Player] = nil
    end
    function Player_Metatable:Update()
        local Box, Box_Outline = self.Components.Box, self.Components.Box_Outline
        local Healthbar, Healthbar_Outline = self.Components.Healthbar, self.Components.Healthbar_Outline
        local Name, NameBold = self.Components.Name, self.Components.NameBold
        local Distance, DistanceBold = self.Components.Distance, self.Components.DistanceBold
        local Tool, ToolBold = self.Components.Tool, self.Components.ToolBold
        local Health, HealthBold = self.Components.Health, self.Components.HealthBold
        local Chams = _G.chamsEnabled == true and self.Components.Chams or true
        local Image = self.Components.Image
        if Box == nil or Box_Outline == nil or Healthbar == nil or Healthbar_Outline == nil or Name == nil or NameBold == nil or Distance == nil or DistanceBold == nil or Tool == nil or ToolBold == nil or Health == nil or HealthBold == nil or Chams == nil then
            self:Destroy()
        end
        local Character = ESP:Get_Character(self.Player)
        if Character ~= nil then
            local Head, HumanoidRootPart, Humanoid = Character:FindFirstChild("Head"), Character:FindFirstChild("HumanoidRootPart"), Character:FindFirstChildOfClass("Humanoid")
            if not Humanoid then
                Box.Visible = false
                Box_Outline.Visible = false
                Healthbar.Visible = false
                Healthbar_Outline.Visible = false
                Name.Visible = false
                NameBold.Visible = false
                Distance.Visible = false
                DistanceBold.Visible = false
                Tool.Visible = false
                ToolBold.Visible = false
                Health.Visible = false
                HealthBold.Visible = false
                if _G.chamsEnabled == true then
                    Chams.Enabled = false
                end
                Image.Visible = false
                return
            end
            local Current_Health, Health_Maximum = ESP:Get_Health(self.Player), Humanoid.MaxHealth
            if Head and HumanoidRootPart and Current_Health > 0 then
                local Dimensions = Framework:Get_Bounding_Vectors(HumanoidRootPart)
                local HRP_Position, On_Screen = Camera:WorldToViewportPoint(HumanoidRootPart.Position)
                local Stud_Distance, Meter_Distance = math.floor(HRP_Position.Z + 0.5), math.floor(HRP_Position.Z / 3.5714285714 + 0.5)

                local Y_Minimal, Y_Maximal = Camera.ViewportSize.X, 0
                local X_Minimal, X_Maximal = Camera.ViewportSize.X, 0

                for _, CF in pairs(Dimensions) do
                    local Vector = Camera:WorldToViewportPoint(CF.Position)
                    local X, Y = Vector.X, Vector.Y
                    if X < X_Minimal then 
                        X_Minimal = X
                    end
                    if X > X_Maximal then 
                        X_Maximal = X
                    end
                    if Y < Y_Minimal then 
                        Y_Minimal = Y
                    end
                    if Y > Y_Maximal then
                        Y_Maximal = Y
                    end
                end

                local Box_Size = Framework:Round_V2(Vector2.new(X_Minimal - X_Maximal, Y_Minimal - Y_Maximal))
                local Box_Position = Framework:Round_V2(Vector2.new(X_Maximal + Box_Size.X / X_Minimal, Y_Maximal + Box_Size.Y / Y_Minimal))
                local Good = false

                if ESP.Settings.Team_Check then
                    if ESP:Get_Team(self.Player) ~= ESP:Get_Team(LocalPlayer) then
                        Good = true
                    end
                else
                    Good = true
                end

                if ESP.Settings.Enabled and On_Screen and Meter_Distance < ESP.Settings.Maximal_Distance and Good then
                    local Highlight_Settings = ESP.Settings.Highlight
                    local Is_Highlighted = Highlight_Settings.Enabled and Highlight_Settings.Target == Character or false
                    local Highlight_Color = Highlight_Settings.Color

                    -- Offsets
                    local Top_Offset = 3
                    local Bottom_Offset = Y_Maximal + 1
                    local Left_Offset = 0
                    local Right_Offset = 0

                    -- Box
                    local Box_Settings = ESP.Settings.Box
                    Box.Size = Box_Size
                    Box.Position = Box_Position
                    Box.Color = Is_Highlighted and Highlight_Color or Box_Settings.Color
                    Box.Transparency = Framework:Drawing_Transparency(Box_Settings.Transparency)
                    Box.Visible = Box_Settings.Enabled

                    local Box_Outline_Settings = ESP.Settings.Box_Outline
                    Box_Outline.Size = Box_Size
                    Box_Outline.Position = Box_Position
                    Box_Outline.Color = Box_Outline_Settings.Color
                    Box_Outline.Thickness = Box_Outline_Settings.Outline_Size + 2
                    Box_Outline.Transparency = Framework:Drawing_Transparency(Box_Outline_Settings.Transparency)
                    Box_Outline.Visible = Box_Settings.Enabled and Box_Outline_Settings.Enabled or false

                    local Image_Settings = ESP.Settings.Image
                    local Image_Enabled = Image_Settings.Enabled
                    if Image_Enabled then
                        Image.Size = -Box_Size
                        Image.Position = Box_Position + Box_Size
                    end
                    Image.Visible = Image_Enabled

                    -- Healthbar
                    local Health_Top_Size_Outline = Vector2.new(Box_Size.X - 4, 3)
                    local Health_Top_Pos_Outline = Box_Position + Vector2.new(2, Box_Size.Y - 6)
                    local Health_Top_Size_Fill = Vector2.new((Current_Health * Health_Top_Size_Outline.X / Health_Maximum) + 2, 1)
                    local Health_Top_Pos_Fill = Health_Top_Pos_Outline + Vector2.new(1 + -(Health_Top_Size_Fill.X - Health_Top_Size_Outline.X),1);

                    local Health_Left_Size_Outline = Vector2.new(3, Box_Size.Y - 4)
                    local Health_Left_Pos_Outline = Vector2.new(X_Maximal + Box_Size.X - 6, Box_Position.Y + 2)
                    local Health_Left_Size_Fill = Vector2.new(1, (Current_Health * Health_Left_Size_Outline.Y / Health_Maximum) + 2)
                    local Health_Left_Pos_Fill = Health_Left_Pos_Outline + Vector2.new(1,-1 + -(Health_Left_Size_Fill.Y - Health_Left_Size_Fill.Y));

                    local Healthbar_Settings = ESP.Settings.Healthbar
                    local Healthbar_Enabled = Healthbar_Settings.Enabled
                    local Healthbar_Position = Healthbar_Settings.Position
                    local Health_Lerp_Color = Healthbar_Settings.Color:Lerp(Healthbar_Settings.Color_Lerp, Current_Health / Health_Maximum)
                    if Healthbar_Enabled then
                        if Healthbar_Position == "Left" then
                            Healthbar.Size = Health_Left_Size_Fill;
                            Healthbar.Position = Health_Left_Pos_Fill;
                            Healthbar_Outline.Size = Health_Left_Size_Outline;
                            Healthbar_Outline.Position = Health_Left_Pos_Outline;
                        elseif Healthbar_Position == "Right" then
                            Healthbar.Size = Health_Left_Size_Fill;
                            Healthbar.Position = Vector2.new(X_Maximal + Box_Size.X + 4, Box_Position.Y + 1) - Vector2.new(Box_Size.X, 0)
                            Healthbar_Outline.Size = Health_Left_Size_Outline
                            Healthbar_Outline.Position = Vector2.new(X_Maximal + Box_Size.X + 3, Box_Position.Y + 2) - Vector2.new(Box_Size.X, 0)
                        elseif Healthbar_Position == "Top" then
                            Healthbar.Size = Health_Top_Size_Fill;
                            Healthbar.Position = Health_Top_Pos_Fill;
                            Healthbar_Outline.Size = Health_Top_Size_Outline;
                            Healthbar_Outline.Position = Health_Top_Pos_Outline;
                            Top_Offset = Top_Offset + 6
                        elseif Healthbar_Position == "Bottom" then
                            Healthbar.Size = Health_Top_Size_Fill
                            Healthbar.Position = Health_Top_Pos_Fill - Vector2.new(0, Box_Size.Y - 9)
                            Healthbar_Outline.Size = Health_Top_Size_Outline;
                            Healthbar_Outline.Position = Health_Top_Pos_Outline - Vector2.new(0, Box_Size.Y - 9)
                            Bottom_Offset = Bottom_Offset + 6
                        end
                        Healthbar.Color = Health_Lerp_Color
                    end
                    Healthbar.Visible = Healthbar_Enabled
                    Healthbar_Outline.Visible = Healthbar_Enabled

                    -- Name
                    local Name_Settings = ESP.Settings.Name
                    local Name_Position = Name_Settings.Position
                    if Name_Position == "Top" then 
                        Name.Position = Vector2.new(X_Maximal + Box_Size.X / 2, Box_Position.Y) - Vector2.new(0, Name.TextBounds.Y - Box_Size.Y + Top_Offset) 
                        Top_Offset = Top_Offset + 10
                    elseif Name_Position == "Bottom" then
                        Name.Position = Vector2.new(Box_Size.X / 2 + Box_Position.X, Bottom_Offset) 
                        Bottom_Offset = Bottom_Offset + 10
                    elseif Name_Position == "Left" then
                        if Healthbar_Position == "Left" then
                            Name.Position = Health_Left_Pos_Outline - Vector2.new(Name.TextBounds.X/2 - 2 + 4, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                        else
                            Name.Position = Health_Left_Pos_Outline - Vector2.new(Name.TextBounds.X/2 - 2, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                        end
                        Left_Offset = Left_Offset + 10
                    elseif Name_Position == "Right" then
                        if Healthbar_Position == "Right" then
                            Name.Position = Vector2.new(X_Maximal + Box_Size.X + 4 + 4 + Name.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                        else
                            Name.Position = Vector2.new(X_Maximal + Box_Size.X + 3 + Name.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                        end
                        Right_Offset = Right_Offset + 10
                    end
                    Name.Color = Is_Highlighted and Highlight_Color or Name_Settings.Color
                    Name.OutlineColor = Name_Settings.OutlineColor
                    Name.Transparency = Framework:Drawing_Transparency(Name_Settings.Transparency)
                    Name.Visible = Name_Settings.Enabled
                    NameBold.Color = Is_Highlighted and Highlight_Color or Name_Settings.Color
                    NameBold.OutlineColor = Name_Settings.OutlineColor
                    NameBold.Transparency = Framework:Drawing_Transparency(Name_Settings.Transparency)
                    NameBold.Position = Name.Position + Vector2.new(1, 0)
                    NameBold.Visible = Name.Visible and ESP.Settings.Bold_Text

                    -- Distance
                    local Distance_Settings = ESP.Settings.Distance
                    local Distance_Position = Distance_Settings.Position
                    if Distance_Position == "Top" then 
                        Distance.Position = Vector2.new(X_Maximal + Box_Size.X / 2, Box_Position.Y) - Vector2.new(0, Distance.TextBounds.Y - Box_Size.Y + Top_Offset) 
                        Top_Offset = Top_Offset + 10
                    elseif Distance_Position == "Bottom" then
                        Distance.Position = Vector2.new(Box_Size.X / 2 + Box_Position.X, Bottom_Offset) 
                        Bottom_Offset = Bottom_Offset + 10
                    elseif Distance_Position == "Left" then
                        if Healthbar_Position == "Left" then
                            Distance.Position = Health_Left_Pos_Outline - Vector2.new(Distance.TextBounds.X/2 - 2 + 4, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                        else
                            Distance.Position = Health_Left_Pos_Outline - Vector2.new(Distance.TextBounds.X/2 - 2, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                        end
                        Left_Offset = Left_Offset + 10
                    elseif Distance_Position == "Right" then
                        if Healthbar_Position == "Right" then
                            Distance.Position = Vector2.new(X_Maximal + Box_Size.X + 4 + 4 + Distance.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                        else
                            Distance.Position = Vector2.new(X_Maximal + Box_Size.X + 3 + Distance.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                        end
                        Right_Offset = Right_Offset + 10
                    end
                    Distance.Text = Meter_Distance.."m"
                    Distance.Color = Is_Highlighted and Highlight_Color or Distance_Settings.Color
                    Distance.OutlineColor = Distance_Settings.OutlineColor
                    Distance.Transparency = Framework:Drawing_Transparency(Distance_Settings.Transparency)
                    Distance.Visible = Distance_Settings.Enabled
                    DistanceBold.Text = Meter_Distance.."m"
                    DistanceBold.Color = Is_Highlighted and Highlight_Color or Distance_Settings.Color
                    DistanceBold.OutlineColor = Distance_Settings.OutlineColor
                    DistanceBold.Transparency = Framework:Drawing_Transparency(Distance_Settings.Transparency)
                    DistanceBold.Position = Distance.Position + Vector2.new(1, 0)
                    DistanceBold.Visible = Distance.Visible and ESP.Settings.Bold_Text

                    -- Tool
                    local Tool_Settings = ESP.Settings.Tool
                    local Tool_Position = Tool_Settings.Position
                    if Tool_Position == "Top" then 
                        Tool.Position = Vector2.new(X_Maximal + Box_Size.X / 2, Box_Position.Y) - Vector2.new(0, Tool.TextBounds.Y - Box_Size.Y + Top_Offset) 
                        Top_Offset = Top_Offset + 10
                    elseif Tool_Position == "Bottom" then
                        Tool.Position = Vector2.new(Box_Size.X / 2 + Box_Position.X, Bottom_Offset) 
                        Bottom_Offset = Bottom_Offset + 10
                    elseif Tool_Position == "Left" then
                        if Healthbar_Position == "Left" then
                            Tool.Position = Health_Left_Pos_Outline - Vector2.new(Tool.TextBounds.X/2 - 2 + 4, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                        else
                            Tool.Position = Health_Left_Pos_Outline - Vector2.new(Tool.TextBounds.X/2 - 2, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                        end
                        Left_Offset = Left_Offset + 10
                    elseif Tool_Position == "Right" then
                        if Healthbar_Position == "Right" then
                            Tool.Position = Vector2.new(X_Maximal + Box_Size.X + 4 + 4 + Tool.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                        else
                            Tool.Position = Vector2.new(X_Maximal + Box_Size.X + 3 + Tool.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                        end
                        Right_Offset = Right_Offset + 10
                    end
                    Tool.Text = ESP:Get_Tool(self.Player)
                    Tool.Color = Is_Highlighted and Highlight_Color or Tool_Settings.Color
                    Tool.OutlineColor = Tool_Settings.OutlineColor
                    Tool.Transparency = Framework:Drawing_Transparency(Tool_Settings.Transparency)
                    Tool.Visible = Tool_Settings.Enabled
                    ToolBold.Text = ESP:Get_Tool(self.Player)
                    ToolBold.Color = Is_Highlighted and Highlight_Color or Tool_Settings.Color
                    ToolBold.OutlineColor = Tool_Settings.OutlineColor
                    ToolBold.Transparency = Framework:Drawing_Transparency(Tool_Settings.Transparency)
                    ToolBold.Position = Tool.Position + Vector2.new(1, 0)
                    ToolBold.Visible = Tool.Visible and ESP.Settings.Bold_Text

                    -- Health
                    local Health_Settings = ESP.Settings.Health
                    local Health_Position = Health_Settings.Position
                    if Health_Position == "Top" then 
                        Health.Position = Vector2.new(X_Maximal + Box_Size.X / 2, Box_Position.Y) - Vector2.new(0, Health.TextBounds.Y - Box_Size.Y + Top_Offset) 
                        Top_Offset = Top_Offset + 10
                    elseif Health_Position == "Bottom" then
                        Health.Position = Vector2.new(Box_Size.X / 2 + Box_Position.X, Bottom_Offset) 
                        Bottom_Offset = Bottom_Offset + 10
                    elseif Health_Position == "Left" then
                        if Healthbar_Position == "Left" then
                            Health.Position = Health_Left_Pos_Outline - Vector2.new(Health.TextBounds.X/2 - 2 + 4, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                        else
                            Health.Position = Health_Left_Pos_Outline - Vector2.new(Health.TextBounds.X/2 - 2, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Left_Offset)
                        end
                        Left_Offset = Left_Offset + 10
                    elseif Health_Position == "Right" then
                        if Healthbar_Position == "Right" then
                            Health.Position = Vector2.new(X_Maximal + Box_Size.X + 4 + 4 + Health.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                        else
                            Health.Position = Vector2.new(X_Maximal + Box_Size.X + 3 + Health.TextBounds.X / 2, Box_Position.Y + 2) - Vector2.new(Box_Size.X, -(100 * Health_Left_Size_Outline.Y / 100) + 2 - Right_Offset)
                        end
                        Right_Offset = Right_Offset + 10
                    end
                    Health.Text = tostring(math.floor(Current_Health + 0.5))
                    Health.Color = Health_Lerp_Color
                    Health.OutlineColor = Health_Settings.OutlineColor
                    Health.Transparency = Framework:Drawing_Transparency(Health_Settings.Transparency)
                    Health.Visible = Health_Settings.Enabled
                    HealthBold.Text = tostring(math.floor(Current_Health + 0.5))
                    HealthBold.Color = Health_Lerp_Color
                    HealthBold.OutlineColor = Health_Settings.OutlineColor
                    HealthBold.Transparency = Framework:Drawing_Transparency(Health_Settings.Transparency)
                    HealthBold.Position = Health.Position + Vector2.new(1, 0)
                    HealthBold.Visible = Health.Visible and ESP.Settings.Bold_Text

                    -- Chams
                    if _G.chamsEnabled == true then
                        local Chams_Settings = ESP.Settings.Chams
                        local Is_Visible = false
                        if ESP:Check_Visible(Head) or ESP:Check_Visible(HumanoidRootPart) then
                            Is_Visible = true
                        end
                        local Chams_Enabled = Chams_Settings.Enabled
                        Chams.Enabled = Chams_Enabled
                        Chams.Adornee = Chams_Enabled and Character or nil
                        if Chams_Enabled then
                            Chams.FillColor = Chams_Settings.Mode == "Visible" and Is_Visible and Color3.new(0, 1, 0) or Chams_Settings.Color
                            Chams.OutlineColor = Chams_Settings.OutlineColor
                            Chams.FillTransparency = Chams_Settings.Transparency
                            Chams.OutlineTransparency = Chams_Settings.OutlineTransparency
                        end
                    end
                else
                    Box.Visible = false
                    Box_Outline.Visible = false
                    Healthbar.Visible = false
                    Healthbar_Outline.Visible = false
                    Name.Visible = false
                    NameBold.Visible = false
                    Distance.Visible = false
                    DistanceBold.Visible = false
                    Tool.Visible = false
                    ToolBold.Visible = false
                    Health.Visible = false
                    HealthBold.Visible = false
                    if _G.chamsEnabled == true then
                        Chams.Enabled = false
                    end
                    Image.Visible = false
                    return
                end
            else
                Box.Visible = false
                Box_Outline.Visible = false
                Healthbar.Visible = false
                Healthbar_Outline.Visible = false
                Name.Visible = false
                NameBold.Visible = false
                Distance.Visible = false
                DistanceBold.Visible = false
                Tool.Visible = false
                ToolBold.Visible = false
                Health.Visible = false
                HealthBold.Visible = false
                if _G.chamsEnabled == true then
                    Chams.Enabled = false
                end
                Image.Visible = false
                return
            end
        else
            Box.Visible = false
            Box_Outline.Visible = false
            Healthbar.Visible = false
            Healthbar_Outline.Visible = false
            Name.Visible = false
            NameBold.Visible = false
            Distance.Visible = false
            DistanceBold.Visible = false
            Tool.Visible = false
            ToolBold.Visible = false
            Health.Visible = false
            HealthBold.Visible = false
            if _G.chamsEnabled == true then
                Chams.Enabled = false
            end
            Image.Visible = false
            return
        end
    end
end
local Object_Metatable = {}
do  -- Object Metatable
    Object_Metatable.__index = Object_Metatable
    function Object_Metatable:Destroy()
        for Index, Component in pairs(self.Components) do
            Component.Visible = false
            Component:Remove()
            self.Components[Index] = nil
        end
        ESP.Objects[self.Object] = nil
    end
    function Object_Metatable:Update()
        local Name = self.Components.Name
        local Addition = self.Components.Addition

        if not ESP.Settings.Objects_Enabled then
            Name.Visible = false
            Addition.Visible = false
            return
        end

        local Vector, On_Screen = Camera:WorldToViewportPoint(self.PrimaryPart.Position + Vector3.new(0, 1, 0))

        local Meter_Distance = math.floor(Vector.Z / 3.5714285714 + 0.5)

        if On_Screen and Meter_Distance < ESP.Settings.Object_Maximal_Distance then
            -- Name
            Name.Text = self.Name .. " [" .. math.floor(Vector.Z / 3.5714285714 + 0.5) .. "m]"
            Name.Position = Framework:V3_To_V2(Vector)
            Name.Visible = true

            -- Addition
            if self.Addition.Text ~= "" then
                Addition.Position = Name.Position + Vector2.new(0, Name.TextBounds.Y)
                Addition.Visible = true
            else
                Addition.Visible = false
            end
        else
            Name.Visible = false
            Addition.Visible = false
            return
        end
    end
end
do -- ESP Functions
    function ESP:Player(Instance, Data)
        if Instance == nil then
            return warn("error: function ESP.Player argument #1 expected Player, got nil")
        end
        if Data == nil or type(Data) ~= "table" then
            Data = {
                Player = Instance
            }
        end
        local Object = setmetatable({
            Player = Data.Player or Data.player or Data.Plr or Data.plr or Data.Ply or Data.ply or Instance,
            Components = {},
            Type = "Player"
        }, Player_Metatable)
        if self:GetObject(Instance) then
            self:GetObject(Instance):Destroy()
        end
        local Components = Object.Components
        Components.Box = Framework:Draw("Square", {Thickness = 1, ZIndex = 2})
        Components.Box_Outline = Framework:Draw("Square", {Thickness = 3, ZIndex = 1})
        Components.Healthbar = Framework:Draw("Square", {Thickness = 1, ZIndex = 2, Filled = true})
        Components.Healthbar_Outline = Framework:Draw("Square", {Thickness = 3, ZIndex = 1, Filled = true})
        Components.Name = Framework:Draw("Text", {Text = Instance.Name, Font = 2, Size = 13, Outline = true, Center = true})
        Components.NameBold = Framework:Draw("Text", {Text = Instance.Name, Font = 2, Size = 13, Center = true})
        Components.Distance = Framework:Draw("Text", {Font = 2, Size = 13, Outline = true, Center = true})
        Components.DistanceBold = Framework:Draw("Text", {Font = 2, Size = 13, Center = true})
        Components.Tool = Framework:Draw("Text", {Font = 2, Size = 13, Outline = true, Center = true})
        Components.ToolBold = Framework:Draw("Text", {Font = 2, Size = 13, Center = true})
        Components.Health = Framework:Draw("Text", {Font = 2, Size = 13, Outline = true, Center = true})
        Components.HealthBold = Framework:Draw("Text", {Font = 2, Size = 13, Center = true})
        Components.Chams = _G.chamsEnabled == true and Framework:Instance("Highlight", {Parent = CoreGui, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop}) or true
        Components.Image = Framework:Draw("Image", {Data = self.Settings.Image.Raw})
        self.Objects[Instance] = Object
        return Object
    end
    function ESP:Object(Instance, Data)
        if Data == nil or type(Data) ~= "table" then
            return warn("error: function ESP.Object argument #2 expected table, got nil")
        end
        local Addition = Data.Addition or Data.addition or Data.add or Data.Add or {}
        if Addition.Text == nil then
            Addition.Text = Addition.text or ""
        end
        if Addition.Color == nil then
            Addition.Color = Addition.Color or Addition.color or Addition.col or Addition.Col or Color3.new(1, 1, 1)
        end
        local obj = Data.Object or Data.object or Data.Obj or Data.obj or Instance
        local col = Data.Color or Data.color or Data.col or Data.Col or Color3.new(1, 1, 1)
        local out = Data.outline or Data.Outline or false
        local trans = Data.trans or Data.Trans or Data.Transparency or Data.transparency or Data.Alpha or Data.alpha or 1
        local Object = setmetatable({
            Object = obj,
            PrimaryPart = Data.PrimaryPart or Data.primarypart or Data.pp or Data.PP or Data.primpart or Data.PrimPart or Data.PPart or Data.ppart or Data.pPart or Data.Ppart or obj:IsA("Model") and obj.PrimaryPart or obj:FindFirstChildOfClass("BasePart") or obj:IsA("BasePart") and obj or nil,
            Addition = Addition,
            Components = {},
            Type = Data.Type,
            Name = (Data.Name ~= nil and Data.Name) or Instance.Name
        }, Object_Metatable)
        if Object.PrimaryPart == nil then
            return
        end
        if self:GetObject(Instance) then
            self:GetObject(Instance):Destroy()
        end
        local Components = Object.Components
        Components.Name = Framework:Draw("Text", {Text = Object.Name, Color = col, Font = 2, Size = 13, Outline = out, Center = true, Transparency = trans})
        Components.Addition = Framework:Draw("Text", {Text = Object.Addition.Text, Color = Object.Addition.Color, Font = 2, Size = 13, Outline = out, Center = true, Transparency = trans})
        self.Objects[Instance] = Object
        return Object
    end
end

-- China Hat
for i = 1, 30 do
    ESP.China_Hat[i] = {Framework:Draw('Line', {Visible = false}), Framework:Draw('Triangle', {Visible = false})}
    ESP.China_Hat[i][1].ZIndex = 2;
    ESP.China_Hat[i][1].Thickness = 2;
    ESP.China_Hat[i][2].ZIndex = 1;
    ESP.China_Hat[i][2].Filled = true;
end

-- Render Connection
local Connection = RunService.RenderStepped:Connect(function()
    -- Object Updating
    for i, Object in pairs(ESP.Objects) do
        Object:Update()
    end

    -- China Hat
    local China_Hat_Settings = ESP.Settings.China_Hat
    if ESP.Settings.China_Hat.Enabled then
        local China_Hat = ESP.China_Hat
        for i = 1, #ESP.China_Hat do
            local Line, Triangle = China_Hat[i][1], China_Hat[i][2];
            if LocalPlayer.Character ~= nil and LocalPlayer.Character:FindFirstChild('Head') and LocalPlayer.Character.Humanoid.Health > 0 then
                local Position = LocalPlayer.Character.Head.Position + Vector3.new(0, China_Hat_Settings.Offset, 0);
                local Last, Next = (i / 30) * math.pi*2, ((i + 1) / 30) * math.pi*2;
                local lastScreen, onScreenLast = Camera:WorldToViewportPoint(Position + (Vector3.new(math.cos(Last), 0, math.sin(Last)) * China_Hat_Settings.Radius));
                local nextScreen, onScreenNext = Camera:WorldToViewportPoint(Position + (Vector3.new(math.cos(Next), 0, math.sin(Next)) * China_Hat_Settings.Radius));
                local topScreen, onScreenTop = Camera:WorldToViewportPoint(Position + Vector3.new(0, China_Hat_Settings.Height, 0));
                if not onScreenLast or not onScreenNext or not onScreenTop then
                    Line.Transparency = 0
                    Triangle.Transparency = 0
                    continue
                end
                Line.From = Vector2.new(lastScreen.X, lastScreen.Y);
                Line.To = Vector2.new(nextScreen.X, nextScreen.Y);
                Line.Color = China_Hat_Settings.Color
                Line.Transparency = Framework:Drawing_Transparency(China_Hat_Settings.Transparency)
                Triangle.PointA = Vector2.new(topScreen.X, topScreen.Y);
                Triangle.PointB = Line.From;
                Triangle.PointC = Line.To;
                Triangle.Color = China_Hat_Settings.Color
                Triangle.Transparency = Framework:Drawing_Transparency(China_Hat_Settings.Transparency)
            end
        end
    end
end)

return ESP, Connection, Framework
