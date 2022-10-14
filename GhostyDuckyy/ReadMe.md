# Credit
Made by `Ghost-Ducky#7698`

## Loadstring
```lua
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GhostDuckyy/ESP-Library/main/GhostyDuckyy/source.lua"))()
```

## Documentation
Documentation for Drawing-Library (ESP)

### RenderObject
```lua
RenderObject(type <string>, property <table>)
```
### Label
#### Example

```lua
local Label = Library:RenderObject("Label", {
  Name = "insert_name_here", -- <string>
  ClassName = "insert_classname_here", -- <string>
  --// Fitler
  Fitler = {
    {ClassName = "insert_classname_here", Name = "insert_name_here"} -- <string>, <string>
  },
  --// Setting of label / text
  Options = {
      Visible = true, -- <boolean>
      Transparency = 1, -- <number>
      Font = 0, -- <number>
      Text = "Example", -- <string>
      Size = 16, -- <number>
      AutoScale = false, -- <string> | Auto scale size
      Center = true, -- <boolean> | Set text center
      Outline = true, -- <boolean>
      OutlineColor = Color3.new(0,0,0), -- <Color3>
      Color = Color3.new(1,1,1), -- <Color3>
    },
})
```

#### Function

```lua
  Label:DestoryRender() -- Stop render
  Label:SetOptions("Visible", false) -- <string>, <value>
  Label:AddFilter({
    ClassName = "Part", -- <string>
    Name = "Grass", -- <string>
  })
  Label:RemoveFilter({
    ClassName = "Part", -- <string>
    Name = "Grass", -- <string>
  })
  Label:ClearFilter() -- Clear fitler
```
Note: How to change [**Font**](https://docs.synapse.to/docs/reference/drawing_lib.html#fonts)
