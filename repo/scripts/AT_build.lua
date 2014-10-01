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
local prev_mode = ""

local cfg = io.open("arstexnica.cfg", "r")
local lines = {}
for line in cfg:lines() do
   if(string.find(line, "mode")) then
      if (string.find(line, "online")) then
	 prev_mode = "online"
      else
	 prev_mode = "print"
      end
      break
   end
end

local mode = prev_mode

optarg,optind = alt_getopt.get_opts (arg, short_opts, long_opts)
for k,v in pairs (optarg) do
   if k == "m" then
      mode = v
   end
end

print("mode = " .. mode .. ", prev_mode = " .. prev_mode)

if prev_mode ~= mode then
   print("È diverso: " .. mode .. " ≠ " .. prev_mode)
   local cfg = io.open("arstexnica.cfg", "r")
   local lines = {}
   local restOfFile
   for line in cfg:lines() do
      if(string.find(line, prev_mode)) then --Is this the line to modify?
	 lines[#lines + 1] = string.gsub(line, prev_mode, mode) --Change old line into new line.
	 restOfFile = cfg:read("*a")
	 break
      else
	 lines[#lines + 1] = line
      end
   end
   cfg:close()

   local cfg = io.open("arstexnica.cfg", "w") -- write the file.
   for i, line in ipairs(lines) do
      cfg:write(line, "\n")
   end
   cfg:write(restOfFile)
   cfg:close()
end


os.execute("export TEXMFHOME=`pwd`/texmf-ars:`kpsewhich -var-value=TEXMFHOME`" .. 
	      " && echo $TEXMFHOME && " .. 
	      "pdflatex -shell-escape arstexnica.tex")
