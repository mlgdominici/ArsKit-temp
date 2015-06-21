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

dofile( "arstexnica.data" )

local dest = "output/abstracts/"

for k, v in pairs(metadata["articles"]) do
   local file = io.open(dest .. k .. ".abs", "w")
   local title = v["title"]
   local authors = table.concat(v["authors"], ", ")
   file:write(title, "\n\n")
   file:write("(" .. authors ..")", "\n\n")
   if v["abstracts"] ~= nil then
      local it_abs = v["abstracts"]["italian"]
      local en_abs = v["abstracts"]["english"]
      file:write("Sommario", "\n\n")
      file:write(it_abs, "\n\n")
      file:write("Abstract", "\n\n")
      file:write(en_abs, "\n\n")
   end
   file:close()
end

