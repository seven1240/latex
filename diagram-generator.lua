--[[
diagram-generator – create images and figures from code blocks.

This Lua filter is used to create images with or without captions
from code blocks. Currently PlantUML, GraphViz, Tikz, and Python
can be processed. For further details, see README.md.

Copyright: © 2018-2020 John MacFarlane <jgm@berkeley.edu>,
             2018 Florian Schätzig <florian@schaetzig.de>,
             2019 Thorsten Sommer <contact@sommer-engineering.com>,
             2019-2020 Albert Krewinkel <albert+pandoc@zeitkraut.de>
License:   MIT – see LICENSE file for details
]]
-- Module pandoc.system is required and was added in version 2.7.3
PANDOC_VERSION:must_be_at_least '2.7.3'

local system = require 'pandoc.system'
local utils = require 'pandoc.utils'
local stringify = function (s)
  return type(s) == 'string' and s or utils.stringify(s)
end
local with_temporary_directory = system.with_temporary_directory
local with_working_directory = system.with_working_directory

-- The PlantUML path. If set, uses the environment variable PLANTUML or the
-- value "plantuml.jar" (local PlantUML version). In order to define a
-- PlantUML version per pandoc document, use the meta data to define the key
-- "plantumlPath".
local plantumlPath = os.getenv("PLANTUML") or "plantuml.jar"

-- The Inkscape path. In order to define an Inkscape version per pandoc
-- document, use the meta data to define the key "inkscapePath".
local inkscapePath = os.getenv("INKSCAPE") or "inkscape"

-- The Python path. In order to define a Python version per pandoc document,
-- use the meta data to define the key "pythonPath".
local pythonPath = os.getenv("PYTHON")

-- The Python environment's activate script. Can be set on a per document
-- basis by using the meta data key "activatePythonPath".
local pythonActivatePath = os.getenv("PYTHON_ACTIVATE")

-- The Java path. In order to define a Java version per pandoc document,
-- use the meta data to define the key "javaPath".
local javaPath = os.getenv("JAVA_HOME")
if javaPath then
    javaPath = javaPath .. package.config:sub(1,1) .. "bin"
        .. package.config:sub(1,1) .. "java"
else
    javaPath = "java"
end

-- The dot (Graphviz) path. In order to define a dot version per pandoc
-- document, use the meta data to define the key "dotPath".
local dotPath = os.getenv("DOT") or "dot"
local twopiPath = os.getenv("TWOPI") or "twopi"
local mscgenPath = os.getenv("MSCGEN") or "mscgen"
local mmdcPath = os.getenv("MMDC") or "mmdc" -- mermaid

-- The pdflatex path. In order to define a pdflatex version per pandoc
-- document, use the meta data to define the key "pdflatexPath".
local pdflatexPath = os.getenv("PDFLATEX") or "pdflatex"

-- The default format is SVG i.e. vector graphics:
local filetype = "svg"
local mimetype = "image/svg+xml"

-- Check for output formats that potentially cannot use SVG
-- vector graphics. In these cases, we use a different format
-- such as PNG:
if FORMAT == "docx" then
    filetype = "png"
    mimetype = "image/png"
elseif FORMAT == "pptx" then
    filetype = "png"
    mimetype = "image/png"
elseif FORMAT == "rtf" then
    filetype = "png"
    mimetype = "image/png"
elseif FORMAT == "latex" then
    filetype = "png"
    mimetype = "image/png"
elseif FORMAT == "html" then
    filetype = "png"
    mimetype = "image/png"
end

-- Execute the meta data table to determine the paths. This function
-- must be called first to get the desired path. If one of these
-- meta options was set, it gets used instead of the corresponding
-- environment variable:
function Meta(meta)
    plantumlPath = meta.plantumlPath or plantumlPath
    inkscapePath = meta.inkscapePath or inkscapePath
    pythonPath = meta.pythonPath or pythonPath
    pythonActivatePath = meta.activatePythonPath or pythonActivatePath
    javaPath = meta.javaPath or javaPath
    dotPath = meta.dotPath or dotPath
    mscgenPath = meta.mscgenPath or mscgenPath
    pdflatexPath = meta.pdflatexPath or pdflatexPath
end

-- Call plantuml.jar with some parameters (cf. PlantUML help):
local function plantuml(puml, filetype)
    local final = pandoc.pipe(javaPath, {"-jar", plantumlPath, "-t" .. filetype, "-pipe", "-charset", "UTF8"}, puml)
    return final
end

-- Call dot (GraphViz) in order to generate the image
-- (thanks @muxueqz for this code):
local function graphviz(code, filetype)
    local dpi = ""
    if FORMAT == "chunkedhtml" then
        dpi = "-Gdpi=72"
    else
        dpi = "-Gdpi=300"
    end
    local final = pandoc.pipe(dotPath, {"-T" .. filetype, dpi}, code)
    return final
end

local function twopi(code, filetype)
  local dpi = ""
  if FORMAT == "chunkedhtml" then
      dpi = "-Gdpi=72"
  else
      dpi = "-Gdpi=300"
  end
  local final = pandoc.pipe(twopiPath, {"-T" .. filetype, dpi}, code)
  return final
end

local function mscgen(code, filetype)
    local outfile = string.format('%s.%s', os.tmpname(), filetype)
    local os_name = io.popen('uname -s','r'):read('*l')
    local arch_name = io.popen('uname -m','r'):read('*l')
    local font = 'Noto Sans CJK KR DemiLight'
    if os_name == 'Darwin' then
      font = "STFangSong"
    end
    local final = pandoc.pipe(mscgenPath, {"-T", filetype, "-F", font, "-o", outfile}, code)

    -- Try to open the written image:
    local r = io.open(outfile, 'rb')
    local imgData = nil

    -- When the image exist, read it:
    if r then
        final = r:read("*all")
        r:close()
    else
        io.stderr:write(string.format("File '%s' could not be opened", outfile))
        error 'Could not create image from mscgen code.'
    end

    -- Delete the tmp files:
    os.remove(outfile)

    return final
end

-- Call mmdc (Mermaid) in order to generate the image
local function mermaid(code, filetype)
  local outfile = string.format('%s.%s', os.tmpname(), filetype)
  local infile = string.format('%s.mmd', os.tmpname())

  local f = io.open(infile, 'w')
  if f then
      f:write(code)
      f:close()
  end

  local final = pandoc.pipe(mmdcPath, {"-o", outfile, "-i", infile}, code)

  -- Try to open the written image:
  local r = io.open(outfile, 'rb')
  local imgData = nil

  -- When the image exist, read it:
  if r then
      final = r:read("*all")
      r:close()
  else
      io.stderr:write(string.format("File '%s' could not be opened", outfile))
      error 'Could not create image from mscgen code.'
  end

  -- Delete the tmp files:
  os.remove(outfile)
  os.remove(infile)

  return final
end

--
-- TikZ
--

--- LaTeX template used to compile TikZ images. Takes additional
--- packages as the first, and the actual TikZ code as the second
--- argument.
local tikz_template = [[
\documentclass{standalone}
\usepackage{tikz}
%% begin: additional packages
%s
%% end: additional packages
\begin{document}
%s
\end{document}
]]

--- Returns a function which takes the filename of a PDF and a
-- target filename, and writes the input as the given format.
-- Returns `nil` if conversion into the target format is not
-- possible.
local function convert_from_pdf(filetype)
  -- Build the basic Inkscape command for the conversion
  local inkscape_output_args
  if filetype == 'png' then
    inkscape_output_args = '--export-png="%s" --export-dpi=300'
  elseif filetype == 'svg' then
    inkscape_output_args = '--export-plain-svg="%s"'
  else
    return nil
  end
  return function (pdf_file, outfile)
    local inkscape_command = string.format(
      '"%s" --without-gui --file="%s" ' .. inkscape_output_args,
      inkscapePath,
      pdf_file,
      outfile
    )
    io.stderr:write(inkscape_command .. '\n')
    local command_output = io.popen(inkscape_command)
    -- TODO: print output when debugging.
    command_output:close()
  end
end

--- Compile LaTeX with Tikz code to an image
local function tikz2image(src, filetype, additional_packages)
  local convert = convert_from_pdf(filetype)
  -- Bail if there is now known way from PDF to the target format.
  if not convert then
    error(string.format("Don't know how to convert pdf to %s.", filetype))
  end
  return with_temporary_directory("tikz2image", function (tmpdir)
    return with_working_directory(tmpdir, function ()
      -- Define file names:
      local file_template = "%s/tikz-image.%s"
      local tikz_file = file_template:format(tmpdir, "tex")
      local pdf_file = file_template:format(tmpdir, "pdf")
      local outfile = file_template:format(tmpdir, filetype)

      -- Build and write the LaTeX document:
      local f = io.open(tikz_file, 'w')
      f:write(tikz_template:format(additional_packages or '', src))
      f:close()

      -- Execute the LaTeX compiler:
      pandoc.pipe(pdflatexPath, {'-output-directory', tmpdir, tikz_file}, '')

      convert(pdf_file, outfile)

      -- Try to open and read the image:
      local img_data
      local r = io.open(outfile, 'rb')
      if r then
        img_data = r:read("*all")
        r:close()
      else
        -- TODO: print warning
      end

      return img_data
    end)
  end)
end

-- Run Python to generate an image:
local function py2image(code, filetype)

    -- Define the temp files:
    local outfile = string.format('%s.%s', os.tmpname(), filetype)
    local pyfile = os.tmpname()

    -- Replace the desired destination's file type in the Python code:
    local extendedCode = string.gsub(code, "%$FORMAT%$", filetype)

    -- Replace the desired destination's path in the Python code:
    extendedCode = string.gsub(extendedCode, "%$DESTINATION%$", outfile)

    -- Write the Python code:
    local f = io.open(pyfile, 'w')
    f:write(extendedCode)
    f:close()

    -- Execute Python in the desired environment:
    local pycmd = pythonPath .. ' ' .. pyfile
    local command = pythonActivatePath
      and pythonActivatePath .. ' && ' .. pycmd
      or pycmd
    os.execute(command)

    -- Try to open the written image:
    local r = io.open(outfile, 'rb')
    local imgData = nil

    -- When the image exist, read it:
    if r then
        imgData = r:read("*all")
        r:close()
    else
        io.stderr:write(string.format("File '%s' could not be opened", outfile))
        error 'Could not create image from python code.'
    end

    -- Delete the tmp files:
    os.remove(pyfile)
    os.remove(outfile)

    return imgData
end

function serialize(o)
	local s = ""

	if type(o) == "number" then
		s = s .. o
	elseif type(o) == "string" then
		s = s .. string.format("%q", o)
	elseif type(o) == "table" then
		s = s .. "{\n"
		for k, v in pairs(o) do
			s = s .. '  ' .. k .. ' = '
			s = s .. serialize(v)
			s = s .. ",\n"
		end
		s = s .. "}"
	elseif type(o) == "boolean" then
		if o then
			s = s .. "true"
		else
			s = s .. "false"
		end
	else
		s = s .. " [" .. type(o) .. "]"
	end

	return s
end

function block_identifier(blk)
  return blk.attr.identifier:gsub("-", "_")
end

function block_content(blk)
  local s = ""
  for i,c in ipairs(blk.content) do
    s = s .. (c.text or ' ')
  end
  return s
end

-- Executes each document's code block to find matching code blocks:
function CodeBlock(block)
  -- Using a table with all known generators i.e. converters:
  local converters = {
    plantuml = plantuml,
    graphviz = graphviz,
    twopi = twopi,
    tikz = tikz2image,
    py2image = py2image,
    asymptote = asymptote,
    msc = mscgen,
  }

  -- Check if a converter exists for this block. If not, return the block
  -- unchanged.
  local img_converter = converters[block.classes[1]]
  if not img_converter then
    return nil
  end

  -- Call the correct converter which belongs to the used class:
  local success, img = pcall(img_converter, block.text,
      filetype, block.attributes["additionalPackages"] or nil)

  -- Bail if an error occured; img contains the error message when that
  -- happens.
  if not (success and img) then
    io.stderr:write(tostring(img or "no image data has been returned."))
    io.stderr:write('\n')
    error 'Image conversion failed. Aborting.'
  end

  -- If we got here, then the transformation went ok and `img` contains
  -- the image data.

  -- Create figure name by hashing the image content
  local fname = pandoc.sha1(img) .. "." .. filetype

  -- Store the data in the media bag:
  pandoc.mediabag.insert(fname, mimetype, img)

  local enable_caption = nil

  -- If the user defines a caption, read it as Markdown.
  local caption = block.attributes.caption
    and pandoc.read(block.attributes.caption).blocks
    or pandoc.Blocks{}
  local alt = pandoc.utils.blocks_to_inlines(caption)

  if PANDOC_VERSION < 3 then
    -- A non-empty caption means that this image is a figure. We have to
    -- set the image title to "fig:" for pandoc to treat it as such.
    local title = #caption > 0 and "fig:" or ""

    -- Transfer identifier and other relevant attributes from the code
    -- block to the image. The `name` is kept as an attribute.
    -- This allows a figure block starting with:
    --
    --     ```{#fig:example .plantuml caption="Image created by **PlantUML**."}
    --
    -- to be referenced as @fig:example outside of the figure when used
    -- with `pandoc-crossref`.
    local img_attr = {
      id = block.identifier,
      name = block.attributes.name,
      width = block.attributes.width,
      height = block.attributes.height
    }

    -- Create a new image for the document's structure. Attach the user's
    -- caption. Also use a hack (fig:) to enforce pandoc to create a
    -- figure i.e. attach a caption to the image.
    local img_obj = pandoc.Image(alt, fname, title, img_attr)

    -- Finally, put the image inside an empty paragraph. By returning the
    -- resulting paragraph object, the source code block gets replaced by
    -- the image:
    return pandoc.Para{ img_obj }
  else
    local fig_attr = {
      id = block.identifier,
      name = block.attributes.name,
    }
    local img_attr = {
      width = block.attributes.width,
      height = block.attributes.height,
    }
    local img_obj = pandoc.Image(alt, fname, "", img_attr)

    -- Create a figure that contains just this image.
    return pandoc.Figure(pandoc.Plain{img_obj}, caption, fig_attr)
  end
end

local function Math(math)
  if FORMAT ~= "latex" then
    return math
  end

  local t = math.mathtype or 'NOTYPE'
  if t ~= 'DisplayMath' then
    return math
  end

  print("math:" .. t .. " " .. stringify(math) .. "\n")

  local s = stringify(math)
  local b = pandoc.RawBlock('tex', "\\begin{equation}")
  local e = pandoc.RawBlock('tex', "\\end{equation}")

  return {
    pandoc.RawInline('latex', '\\begin{equation}'),
    pandoc.RawInline('latex', s),
    pandoc.RawInline('latex', '\\end{equation}')
  }
end

-- Normally, pandoc will run the function in the built-in order Inlines ->
-- Blocks -> Meta -> Pandoc. We instead want Meta -> Blocks. Thus, we must
-- define our custom order:
return {
    {Meta = Meta},
    {CodeBlock = CodeBlock},
    {Math = Math},
}
