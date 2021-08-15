local Draw = {}
Draw.ImageCache = {}

if not Drawing then 
    warn('Drawing API is not compatible!') 
    return
end


function Draw:HandleImageCache(url)
    if Draw.ImageCache[url] then
        return Draw.ImageCache[url]
    end
    local data = game:HttpGet(url)
    Draw.ImageCache[url] = data

    return data
end

function Draw:Text(text, position, center)
    local text = Drawing.new('Text')
    text.Visible = true
    text.Text = text
    text.Size = 13
    text.Position = position or Vector2.new()
    text.Font = Drawing.Fonts.Plex
    text.Center = center
    text.Outline = true
    text.OutlineColor = Color3.new(0, 0, 0)
    text.Color = Color3.new(1, 1, 1)

    return text
end

function Draw:Square(position, size, color, visible)
    local square = Drawing.new('Square')
    square.Visible = visible or true
    square.Thickness = 1
    square.Filled = true
    square.Size = size
    square.Position = position or Vector2.new()
    square.Color = color or Color3.new(0, 0, 0)

    return square
end

function Draw:SquareOutline(position, size, color, thickness, visible)
    local square = Drawing.new('Square')
    square.Visible = visible or true
    square.Thickness = 1
    square.Filled = false
    square.Size = size
    square.Position = position or Vector2.new()
    square.Color = color or Color3.new(0, 0, 0)

    return square
end

function Draw:Image(position, size, data, visible)
    local image = Drawing.new('Image')
    image.Visible = visible or true
    image.Size = size
    image.Position = position
    image.Data = Draw:HandleImageCache(data)

    return image
end


function Draw:UpdatePosition(drawing, position)
    drawing.Position = position
end

function Draw:UpdateSize(drawing, size)
    drawing.Size = size
end

function Draw:UpdateVisibility(drawing, visible)
    drawing.Visible = visible
end

return Draw;
