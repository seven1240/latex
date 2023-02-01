-- get logging.lua for debug
-- https://github.com/wlupton/pandoc-lua-logging
-- local logging = require 'logging'

if not logging then
	logging = {
		temp = function(tag, obj)
			print(tag)
			print(pandoc.utils.stringify(obj))
		end
	}
end

local chapter = 0
local count = 0
local tcount = 0

function xHeader(el)
	-- logging.temp('el', el.level)
	if el.level == 1 then
		chapter = chapter + 1
		count = 0
		tcount = 0
	end
end

function xFigure(fg)
	-- logging.temp('figure', fg)
	count = count + 1
	if fg.caption and fg.caption.long then
		local blocks = fg.caption.long
		if blocks and #blocks == 1 then
			local block = blocks[1]
			if #block.content > 0 then
				block.content:insert(1, pandoc.Str(" "))
				block.content:insert(1, pandoc.Str('图' .. chapter .. '-' .. count .. ':'))
			end
		end
	end

	return fg
end

function xTable(tbl)
	-- logging.temp('table', tbl)
	tcount = tcount + 1
	if tbl.caption and tbl.caption.long then
		local blocks = tbl.caption.long
		if blocks and #blocks == 1 then
			local block = blocks[1]
			if #block.content > 0 then
				block.content:insert(1, pandoc.Str(" "))
				block.content:insert(1, pandoc.Str('表' .. chapter .. '-' .. tcount .. ':'))
			end
		end
	end
	return tbl
end

function Pandoc(doc)
	for i,el in pairs(doc.blocks) do
        if el.t == "Header" then
			xHeader(el)
		elseif el.t == "Figure" then
			xFigure(el)
		elseif el.t == "Table" then
			xTable(el)
		end
	end

	return doc
end

-- return {
-- 	{ Header = Header },
-- 	{ Figure = Figure },
-- 	{ Table = Table },
-- }
