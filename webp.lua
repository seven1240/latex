-- 在PDF中将WebP图片替换为文字

function string:endswith(ending)
    return ending == "" or self:sub(-#ending) == ending
end

function Image(img)
    if FORMAT ~= "latex" then return end

    if img.src:endswith(".webp") then
        return pandoc.Str("!PDF版不支持该类型的图片[webp image]！")
    end
end
