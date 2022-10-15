--[[
    Made by Ghost-Ducky#7698
]]

local Render = {AutoRemove = true,CheckIfOnScreen = true}

local CurrentCamera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

function Render:RenderObject(t, p)
    local Drawing_type = tostring(t):lower()
    local property

    if typeof(p) ~= "table" then
        property = {p}
    else
        property = p
    end

    if Drawing_type == "label" or Drawing_type == "text" then
        local ObjectName = property.Name
        local ClassName = property.ClassName
        local FilterObject = property.Filter or property.FilterObject or false

        local Options = property.Options or {
            Visible = true,
            Transparency = 1,
            Font = 0,
            Text = "Example",
            Size = 16,
            AutoScale = false,
            Center = true,
            Outline = true,
            OutlineColor = Color3.new(0,0,0),
            Color = Color3.new(1,1,1)
        }
        local Folder = {}

        function AddLabel(instance)
            if tostring(instance.Name):lower() == tostring(ObjectName):lower() and instance:IsA(tostring(ClassName)) or tostring(instance.ClassName):lower() == tostring(ClassName):lower() then
                if FilterObject ~= false then
                    for index,Table in next, FilterObject do
                        if Table.Name and Table.ClassName then
                            for i,v in ipairs(instance:GetDescendants()) do
                                if tostring(v.ClassName):lower() == tostring(Table.ClassName):lower() and tostring(v.Name):lower() == tostring(Table.Name):lower() then
                                    local UwU = {Label = Drawing.new("Text"), Object = instance}
                                    table.insert(Folder, UwU)
                                end
                            end
                        elseif Table.ClassName then
                            for i,v in ipairs(instance:GetDescendants()) do
                                if tostring(v.ClassName):lower() == tostring(Table.ClassName):lower() then
                                    local UwU = {Label = Drawing.new("Text"), Object = instance}
                                    table.insert(Folder, UwU)
                                end
                            end
                        elseif Table.Name then
                            for i,v in ipairs(instance:GetDescendants()) do
                                if tostring(v.Name):lower() == tostring(Table.Name):lower() then
                                    local UwU = {Label = Drawing.new("Text"), Object = instance}
                                    table.insert(Folder, UwU)
                                end
                            end
                        else
                            local UwU = {Label = Drawing.new("Text"), Object = instance}
                            table.insert(Folder, UwU)
                        end
                    end
                else
                    local UwU = {Label = Drawing.new("Text"), Object = instance}
                    table.insert(Folder, UwU)
                end
            end
        end

        for i,v in ipairs(workspace:GetDescendants()) do
            AddLabel(v)
        end

        local DescendantAdded = workspace.DescendantAdded:Connect(function(v)
            task.wait(.1)
            AddLabel(v)
        end)
        local RenderStepped = RunService.RenderStepped:Connect(function()
            for i,v in next, Folder do
                if Render.AutoRemove then
                    if v.Object == nil then
                        v.Label.Visible = false
                        v.Label:Remove()
                        table.remove(Folder,i)
                    end
                end

                if v.Object and not property.Position then
                    local Vector, Screen = CurrentCamera:WorldToViewportPoint(v.Object.Position)
                    if Render.CheckIfOnScreen then
                        if Screen then
                            v.Label.Position = Vector2.new(Vector.X, Vector.Y)

                            if property.AutoScale then
                                for x,y in next, Options do
                                    if tostring(x):lower() ~= "size" then v.Label[x] = y end
                                end

                                local Distance = (Vector3.new(CurrentCamera.CFrame.X, CurrentCamera.CFrame.Y, CurrentCamera.Z) - v.Object.Position).magnitude
                                local TextSize = math.clamp(1/Distance*1000, 5, property.Size) -- <math> <min> <max>
                                v.Label.Size = TextSize
                            else
                                for x,y in next, Options do
                                    v.Label[x] = y
                                end
                            end
                        else
                            v.Label.Visible = false
                        end
                    else
                        v.Label.Position = Vector2.new(Vector.X, Vector.Y)

                        if property.AutoScale then
                            for x,y in next, Options do
                                if tostring(x):lower() ~= "size" then v.Label[x] = y end
                            end

                            local Distance = (Vector3.new(CurrentCamera.CFrame.X, CurrentCamera.CFrame.Y, CurrentCamera.Z) - v.Object.Position).magnitude
                            local TextSize = math.clamp(1/Distance*1000, 2, property.Size) -- <math> <min> <max>
                            v.Label.Size = TextSize
                        else
                            for x,y in next, Options do
                                v.Label[x] = y
                            end
                        end
                    end
                elseif v.Object and property.Position then
                    for x,y in next, Options do
                        v.Label[x] = y
                    end
                end
            end
        end)

        local func = {
            DestoryRender = function()
                DescendantAdded:Disconnect()
                RenderStepped:Disconnect()

                for i,v in next, Folder do
                    v.Label.Visible = false
                    v.Label:Remove()
                end

                task.wait(.5)
                table.clear(Folder)
            end,
            SetOptions = function(prop, value)
                for index,v in next, Options do
                    if tostring(index):lower() == tostring(prop):lower() then
                        Options[index] = value
                    end
                end
            end,
            AddFilter = function(arg)
                if not FilterObject then
                    FilterObject = {}

                    if typeof(arg) == "table" then
                        if arg.Name and arg.ClassName then
                            table.insert(FilterObject, arg)
                        elseif arg.ClassName then
                            table.insert(FilterObject, arg)
                        elseif arg.Name then
                            table.insert(FilterObject, arg)
                        end
                    else
                        if arg.Name and arg.ClassName then
                            table.insert(FilterObject, {arg})
                        elseif arg.ClassName then
                            table.insert(FilterObject, {arg})
                        elseif arg.Name then
                            table.insert(FilterObject, {arg})
                        end
                    end
                else
                    if typeof(arg) == "table" then
                        if arg.Name and arg.ClassName then
                            table.insert(FilterObject, arg)
                        elseif arg.ClassName then
                            table.insert(FilterObject, arg)
                        elseif arg.Name then
                            table.insert(FilterObject, arg)
                        end
                    else
                        if arg.Name and arg.ClassName then
                            table.insert(FilterObject, {arg})
                        elseif arg.ClassName then
                            table.insert(FilterObject, {arg})
                        elseif arg.Name then
                            table.insert(FilterObject, {arg})
                        end
                    end
                end
            end,
            RemoveFilter = function(arg)
                if FilterObject ~= false then
                    for i,v in next, FilterObject do
                        if arg.Name and arg.ClassName then
                            if tostring(v.ClassName):lower() == tostring(arg.ClassName):lower() and tostring(v.Name):lower() == tostring(arg.Name):lower() then
                                table.remove(FilterObject,i)
                            end
                        elseif arg.ClassName then
                            if tostring(v.ClassName):lower() == tostring(arg.ClassName):lower() then
                                table.remove(FilterObject,i)
                            end
                        elseif arg.Name then
                            if tostring(v.Name):lower() == tostring(arg.Name):lower() then
                                table.remove(FilterObject,i)
                            end
                        end
                    end
                end
            end,
            ClearFilter = function()
                table.clear(FilterObject)
                FilterObject = {}
            end,
        }

        return func

    elseif Drawing_type == "line" or Drawing_type:find("trace") then
        local ObjectName = property.Name
        local ClassName = property.ClassName
        local LineForm = tostring(property.Form) or tostring(property.LineForm) or "mouse"
        local FilterObject = property.Filter or property.FilterObject or false

        local Options = property.Options or {
            Visible = true,
            Transparency = 1,
            Color = Color3.new(1,1,1),
            Thickness = 1,
        }
        local Folder = {}

        function addLine(instance)
            if tostring(instance.Name):lower() == tostring(ObjectName):lower() and instance:IsA(tostring(ClassName)) or tostring(instance.ClassName):lower() == tostring(ClassName):lower() then
                if FilterObject ~= false then
                    for index,Table in next, FilterObject do
                        if Table.Name and Table.ClassName then
                            for i,v in ipairs(instance:GetDescendants()) do
                                if tostring(v.ClassName):lower() == tostring(Table.ClassName):lower() and tostring(v.Name):lower() == tostring(Table.Name):lower() then
                                    local UwU = {Line = Drawing.new("Line"), Object = instance}
                                    table.insert(Folder, UwU)
                                end
                            end
                        elseif Table.ClassName then
                            for i,v in ipairs(instance:GetDescendants()) do
                                if tostring(v.ClassName):lower() == tostring(Table.ClassName):lower() then
                                    local UwU = {Line = Drawing.new("Line"), Object = instance}
                                    table.insert(Folder, UwU)
                                end
                            end
                        elseif Table.Name then
                            for i,v in ipairs(instance:GetDescendants()) do
                                if tostring(v.Name):lower() == tostring(Table.Name):lower() then
                                    local UwU = {Line = Drawing.new("Line"), Object = instance}
                                    table.insert(Folder, UwU)
                                end
                            end
                        else
                            local UwU = {Line = Drawing.new("Line"), Object = instance}
                            table.insert(Folder, UwU)
                        end
                    end
                else
                    local UwU = {Line = Drawing.new("Line"), Object = instance}
                    table.insert(Folder, UwU)
                end
            end
        end

        for i,v in ipairs(workspace:GetDescendants()) do
            addLine(v)
        end

        local DescendantAdded = workspace.DescendantAdded:Connect(function(v)
            task.wait(.1)
            addLine(v)
        end)
        local RenderStepped = RunService.RenderStepped:Connect(function()
            for i,v in next, Folder do
                if Render.AutoRemove then
                    if v.Object == nil then
                        v.Line.Visible = false
                        v.Line:Remove()
                        table.remove(Folder,i)
                    end
                end

                if v.Object and not property.To then
                    local Vector, Screen = CurrentCamera:WorldToViewportPoint(v.Object.Position)
                    if Render.CheckIfOnScreen then
                        if Screen then
                            v.Line.To = Vector2.new(Vector.X, Vector.Y)

                            if LineForm:lower() == "mouse" then
                                v.Line.Form = Vector2.new(Mouse.X, Mouse.Y)
                            elseif LineForm:lower() == "top" then
                                
                            elseif LineForm:lower() == "center" then
                                
                            elseif LineForm:lower() == "bottom" then
                                
                            end

                            for x,y in next, Options do
                                v.Line[x] = y
                            end
                        else
                            v.Line.Visible = false
                        end
                    else
                        v.Line.To = Vector2.new(Vector.X, Vector.Y)

                        if LineForm:lower() == "mouse" then
                            v.Line.Form = Vector2.new(Mouse.X, Mouse.Y)
                        elseif LineForm:lower() == "top" then
                            
                        elseif LineForm:lower() == "center" then
                            
                        elseif LineForm:lower() == "bottom" then
                            
                        end

                        for x,y in next, Options do
                            v.Line[x] = y
                        end
                    end
                end
            end
        end)

        local func = {
            DestoryRender = function()
                DescendantAdded:Disconnect()
                RenderStepped:Disconnect()

                for i,v in next, Folder do
                    v.Label.Visible = false
                    v.Label:Remove()
                end

                task.wait(.5)
                table.clear(Folder)
            end,
            SetOptions = function(prop, value)
                for index,v in next, Options do
                    if tostring(index):lower() == tostring(prop):lower() then
                        Options[index] = value
                    end
                end
            end,
            AddFilter = function(arg)
                if not FilterObject then
                    FilterObject = {}

                    if typeof(arg) == "table" then
                        if arg.Name and arg.ClassName then
                            table.insert(FilterObject, arg)
                        elseif arg.ClassName then
                            table.insert(FilterObject, arg)
                        elseif arg.Name then
                            table.insert(FilterObject, arg)
                        end
                    else
                        if arg.Name and arg.ClassName then
                            table.insert(FilterObject, {arg})
                        elseif arg.ClassName then
                            table.insert(FilterObject, {arg})
                        elseif arg.Name then
                            table.insert(FilterObject, {arg})
                        end
                    end
                else
                    if typeof(arg) == "table" then
                        if arg.Name and arg.ClassName then
                            table.insert(FilterObject, arg)
                        elseif arg.ClassName then
                            table.insert(FilterObject, arg)
                        elseif arg.Name then
                            table.insert(FilterObject, arg)
                        end
                    else
                        if arg.Name and arg.ClassName then
                            table.insert(FilterObject, {arg})
                        elseif arg.ClassName then
                            table.insert(FilterObject, {arg})
                        elseif arg.Name then
                            table.insert(FilterObject, {arg})
                        end
                    end
                end
            end,
            RemoveFilter = function(arg)
                if FilterObject ~= false then
                    for i,v in next, FilterObject do
                        if arg.Name and arg.ClassName then
                            if tostring(v.ClassName):lower() == tostring(arg.ClassName):lower() and tostring(v.Name):lower() == tostring(arg.Name):lower() then
                                table.remove(FilterObject,i)
                            end
                        elseif arg.ClassName then
                            if tostring(v.ClassName):lower() == tostring(arg.ClassName):lower() then
                                table.remove(FilterObject,i)
                            end
                        elseif arg.Name then
                            if tostring(v.Name):lower() == tostring(arg.Name):lower() then
                                table.remove(FilterObject,i)
                            end
                        end
                    end
                end
            end,
            ClearFilter = function()
                table.clear(FilterObject)
                FilterObject = {}
            end,
        }

        return func

    elseif Drawing_type == "image" then

    elseif Drawing_type == "circle" then

    elseif Drawing_type == "square" then

    elseif Drawing_type == "quad" then

    elseif Drawing_type == "triangle" then

    end
end

return Render
