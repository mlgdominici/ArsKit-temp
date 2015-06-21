#! /usr/bin/env texlua

kpse.set_program_name('luatex')

local loader_file = "luatexbase.loader.lua"
local loader_path = assert(kpse.find_file(loader_file, "lua"),
                           "File '"..loader_file.."' not found")
require(loader_path)
require "alt_getopt"

local long_opts = {
   mode = "m",
}

local short_opts = "m:"

local mode = "online"

optarg,optind = alt_getopt.get_opts (arg, short_opts, long_opts)
for k,v in pairs (optarg) do
   if k == "m" then
      mode = v
   end
end

lfs.mkdir("tmp")

dofile( "arstexnica.data" )

os.execute("pdfannotextractor arstexnica.pdf")

local dest = "output/pdf/"

for k, v in pairs(metadata["articles"]) do
   local master = io.open("tmp/" .. k .. ".tex", "w")
   local startpage = v["startpage"]
   local endpage = v["endpage"]
   local title = v["title"]
   local authors = table.concat(v["authors"], ", ")
   master:write("\\documentclass{article}", "\n\n")
   master:write("\\usepackage{xcolor}", "\n")
   master:write("\\usepackage{pdfpages}", "\n")
   master:write("\\usepackage{pax}", "\n")
   master:write("\\usepackage{hyperref}", "\n\n")
   master:write("\\colorlet{ATLinkColor}{blue!30!black}", "\n\n")
   master:write("\\let\\cs\\relax", "\n")
   master:write("\\let\\envname\\relax", "\n")
   master:write("\\let\\clsname\\relax", "\n\n")
   master:write("\\hypersetup{", "\n")
   master:write("pdfauthor={" .. authors .. "},", "\n")
   master:write("pdftitle={" .. title .. " (Arstexnica, Numero " .. metadata["number"] .. ", " .. metadata["year"] .. ")},", "\n")
   master:write("pdfkeywords = {TeX, LaTeX, ConTeXt, XeLaTeX, tipografia digitale},", "\n")
   master:write("colorlinks = true, citecolor = ATLinkColor, linkcolor = ATLinkColor, urlcolor = ATLinkColor,", "\n")
   master:write("}", "\n\n")
   master:write("\\begin{document}", "\n\n")
   master:write("\\includepdf[pages=" .. startpage .. "-" .. endpage .. "]{../arstexnica.pdf}", "\n\n")
   master:write("\\end{document}", "\n")
   master:close()
   os.execute("cd tmp && pdflatex " .. k .. " && pdflatex " .. k .. " && cp " .. k .. ".pdf ../" .. dest)
end

if mode == "online" then
   os.execute("cp arstexnica.pdf " .. dest .. "/online_version_arstexnica" .. metadata["number"] .. ".pdf")
else
   os.execute("cp arstexnica.pdf " .. dest .. "/print_version_arstexnica" .. metadata["number"] .. ".pdf")
   local master = io.open("tmp/AT" .. metadata["number"] .. "cover.tex", "w")
   master:write("\\documentclass{article}", "\n\n")
   master:write("\\usepackage{pdfpages}", "\n")
   master:write("\\begin{document}", "\n\n")
   master:write("\\includepdf[pages={1-2," .. metadata["lastpage"]-1 .. "-" .. metadata["lastpage"] .. "}]{../arstexnica.pdf}", "\n\n")
   master:write("\\end{document}", "\n")
   master:close()
   os.execute("cd tmp && pdflatex AT" .. metadata["number"] .. "cover && cp AT" .. metadata["number"] .. "cover.pdf ../" .. dest)
   local master = io.open("tmp/AT" .. metadata["number"] .. "pages.tex", "w")
   master:write("\\documentclass{article}", "\n\n")
   master:write("\\usepackage{pdfpages}", "\n")
   master:write("\\begin{document}", "\n\n")
   master:write("\\includepdf[pages=3-" .. metadata["lastpage"]-2 .. "]{../arstexnica.pdf}", "\n\n")
   master:write("\\end{document}", "\n")
   master:close()
   os.execute("cd tmp && pdflatex AT" .. metadata["number"] .. "pages && cp AT" .. metadata["number"] .. "pages.pdf ../" .. dest)
end
