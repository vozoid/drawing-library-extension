if getgenv().drawingextension then return end
getgenv().drawingextension = true

local Signal = loadstring(game:HttpGet("https://raw.githubusercontent.com/vozoid/signal-library/main/main.lua"))()

local inputService = game:GetService("UserInputService")
local runService = game:GetService("RunService")

function mouse_over(obj)
    if obj.__OBJECT_EXISTS then
        local posX = obj.Position.X
        local posY = obj.Position.Y
        local sizeX = posX + obj.Size.X
        local sizeY = posY + obj.Size.Y
        
        if inputService:GetMouseLocation().X >= posX and inputService:GetMouseLocation().Y >= posY and inputService:GetMouseLocation().X <= sizeX and inputService:GetMouseLocation().Y <= sizeY then
            return true
        end

        return false
    else
        return false
    end
end

local events = {
    MouseButton1Click = Signal.new(),
    MouseButton2Click = Signal.new(),
    MouseButton1Down = Signal.new(),
    MouseButton1Up = Signal.new(),
    MouseButton2Down = Signal.new(),
    MouseButton2Up = Signal.new(),
    MouseEnter = Signal.new(),
    MouseLeave = Signal.new(),
    MouseMoved = Signal.new(),
    InputBegan = Signal.new(),
    InputEnded = Signal.new(),
    InputChanged = Signal.new()
}

local draw = Drawing.new

Drawing.new = function(shape)
    local obj = draw(shape)

    for event, signal in next, events do
        rawset(obj, event, signal)
    end

    local mouseEntered = false

    inputService.InputBegan:connect(function(input)
        -- InputBegan
        if mouse_over(obj) then
            obj.InputBegan:Fire(input)
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            --MouseButton1Click and MouseButton1Down and InputBegan
            if mouse_over(obj) then
                obj.MouseButton1Click:Fire()
                obj.MouseButton1Down:Fire()
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            --MouseButton2Click and MouseButton2Down
            if mouse_over(obj) then
                obj.MouseButton2Click:Fire()
                obj.MouseButton2Down:Fire()
            end
        end
    end)

    inputService.InputEnded:connect(function(input)
        -- InputEnded
        if mouse_over(obj) then
            obj.InputEnded:Fire(input)
        end

        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            --MouseButton1Up
            if mouse_over(obj) then
                obj.MouseButton1Up:Fire()
            end
        elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
            -- MouseButton2Up
            if mouse_over(obj) then
                obj.MouseButton2Up:Fire()
            end
        end
    end)

    inputService.InputChanged:connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard and input.UserInputType ~= Enum.UserInputType.TextInput then
            if mouse_over(obj) then
                obj.InputChanged:Fire(input)
            end
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if mouse_over(obj) then
                -- MouseMoved
                obj.MouseMoved:Fire()

                -- MouseEnter
                if not mouseEntered then
                    obj.MouseEnter:Fire()
                    mouseEntered = true
                end
            else
                -- MouseLeave
                if mouseEntered then
                    obj.MouseLeave:Fire()
                    obj.InputEnded:Fire(input)
                    mouseEntered = false
                end
            end
        end
    end)

    return obj
end
