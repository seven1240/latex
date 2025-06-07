-- support PDF color box
-- Usage:
-- ```{redbox, caption="This is a red box"}
-- This is some text inside a red box.
-- ```
-- or
-- ```.greenbox
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
				-- quick and dirty implementation fox docx
				-- todo: make a custom styled Div
				return pandoc.BlockQuote(parsed.blocks)
			end
		end
	end
	return nil
end
