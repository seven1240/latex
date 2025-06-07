-- support PDF color box
-- Usage:
-- ```{.redbox, caption="This is a red box"}
-- This is some text inside a red box.
-- ```
-- or
-- ```greenbox
-- This is some text inside a green box. No caption.
-- ```

local supported_boxes = {
	redbox = 'redbox',
	greenbox = 'greenbox',
	bluebox = 'bluebox'
}

function CodeBlock(block)
	for class, env in pairs(supported_boxes) do
		if block.classes:includes(class) then
			local parsed = pandoc.read(block.text, 'markdown')
			if FORMAT == "latex" then
				local latex_content = pandoc.write(parsed, 'latex')
				local caption = '{}'
				if block.attributes.caption then
					caption = '{' .. block.attributes.caption .. '}'
				end
				local latex_start = '\\begin{' .. class .. '}' .. caption .. '\n'
				local latex_end = '\n\\end{' .. class .. '}'
				local content = latex_start .. latex_content .. latex_end
				return pandoc.RawBlock('latex', content)
			elseif FORMAT == "docx" then
				if block.attributes.caption then
					local caption = pandoc.Strong(block.attributes.caption .. '：')
					table.insert(parsed.blocks[1].content, 1, caption)
				end
				local div = pandoc.Div(parsed.blocks)
				div.attr.attributes['custom-style'] = class
				return div
			elseif FORMAT == "html" or FORMAT == "chunkedhtml" then
				if block.attributes.caption then
					local caption = pandoc.Strong(block.attributes.caption .. '：')
					table.insert(parsed.blocks[1].content, 1, caption)
				end
				local div = pandoc.Div(parsed.blocks)
				div.classes:insert(class)
				return div
			end
		end
	end
	return nil
end
