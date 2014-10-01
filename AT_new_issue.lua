#! /usr/bin/env texlua

kpse.set_program_name('luatex')

require "alt_getopt"

-- Source (adapted): http://kracekumar.com/post/53685731325/cp-command-implementation-and-benchmark-in-python-go
function cp(source, dest)
   local f = io.open(source, "rb")
   local content = f:read("*all")
   f:close()
   local w = io.open(dest, "wb")
   -- print(dest, w, f)
   w:write(content)
   w:close() 
end

function clone_dir(source, dest)
    -- body
   lfs.mkdir(dest)
   for filename in lfs.dir(source) do
      if filename ~= '.' and filename ~= '..' then
	 local source_path = source .. '/' .. filename
	 local attr = lfs.attributes(source_path)
	 -- print(attr.mode, path)
	 if type(attr) == "table" and attr.mode == "directory" then 
	    local dest_path = dest .. "/" .. filename
	    -- print(dest_path)
	    lfs.mkdir(dest_path)
	    -- print(lfs.mkdir(dest_path))
	    clone_dir(source_path, dest_path)
	 else
	    cp(source_path, dest .. '/' .. filename)
	 end
      end
   end
end

local long_opts = {
   year = "y",
   issue = "i",
}

local short_opts = "y:i:"

local anno_uscita, mese_uscita, numero_uscita

local texmf = "texmf-ars"

optarg,optind = alt_getopt.get_opts (arg, short_opts, long_opts)
for k,v in pairs (optarg) do
   if k == "y" then
      anno_uscita = v
   end
   if k == "i" then
      numero_uscita = v
   end
end

if tonumber(numero_uscita) % 2 == 0 then
   mese_uscita = "Ottobre"
else
   mese_uscita = "Aprile"
end

local nuova_uscita = "Numero_" .. numero_uscita
local config_file = nuova_uscita .. "/arstexnica.cfg" 

local issn_online = 18282369
local issn_stampa = 18282350

local function genera_ean(issn)
   local s1 = string.sub(issn, 1, -2) .. "00"
   local s2 = string.sub(anno_uscita, -1) .. string.format("%04d", numero_uscita)
   local ean = "977" .. s1 .. " " .. s2
   return ean
end

lfs.mkdir(nuova_uscita)
lfs.mkdir(nuova_uscita .. "/articoli")
lfs.mkdir(nuova_uscita .. "/suppl")
lfs.mkdir(nuova_uscita .. "/suppl/copertina")
lfs.mkdir(nuova_uscita .. "/output")
lfs.mkdir(nuova_uscita .. "/output/pdf")
lfs.mkdir(nuova_uscita .. "/output/bib")
lfs.mkdir(nuova_uscita .. "/output/abstracts")
clone_dir("repo/" .. texmf, nuova_uscita .. "/" .. texmf)
clone_dir("repo/scripts", nuova_uscita)
cp("repo/templates/arstexnica.tex", nuova_uscita .. "/" .. "arstexnica.tex")
cp("repo/templates/prima.tex", nuova_uscita .. "/suppl/copertina/prima.tex")
cp("repo/templates/seconda.tex", nuova_uscita .. "/suppl/copertina/seconda.tex")
cp("repo/templates/terza.tex", nuova_uscita .. "/suppl/copertina/terza.tex")
cp("repo/templates/quarta.tex", nuova_uscita .. "/suppl/copertina/quarta.tex")
cp("repo/templates/colophon.tex", nuova_uscita .. "/suppl/copertina/colophon.tex")
cp("repo/templates/GuITTeX.jpg", nuova_uscita .. "/suppl/copertina/GuITTeX.jpg")
cp("repo/templates/GuITlogo_big.jpg", nuova_uscita .. "/suppl/copertina/GuITlogo_big.jpg")
cp("repo/templates/GuIT_logo_small.jpg", nuova_uscita .. "/suppl/copertina/GuIT_logo_small.jpg")
cp("repo/templates/logotondoGuIT.pdf", nuova_uscita .. "/suppl/copertina/logotondoGuIT.pdf")
local cfg = io.open(config_file, 'w')
cfg:write([[\ATsetup{]] .. "\n")
cfg:write("  year = " .. anno_uscita .. ",\n")
cfg:write("  month = " .. mese_uscita .. ",\n")
cfg:write("  number = " .. numero_uscita .. ",\n")
cfg:write("  mode = online,\n")
cfg:write([[}]])
cfg:close()

print("EAN online: " .. genera_ean(issn_online))
print("EAN stampa: " .. genera_ean(issn_stampa))

os.execute("barcode -E -e ean -u cm -g 4x1.5 -b '" .. genera_ean(issn_online) .. "' -o " ..nuova_uscita .. "/issn_online.eps")
os.execute("barcode -E -e ean -u cm -g 4x1.5 -b '" .. genera_ean(issn_stampa) .. "' -o " ..nuova_uscita .. "/issn_print.eps")


