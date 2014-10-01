#! /usr/bin/env texlua

dofile( "arstexnica.data" )

-- local file_list = {}

local complete_bib = io.open("output/bib/arstexnica_numero_" .. metadata["number"] .. ".bib", "w")

for k, v in pairs(metadata["articles"]) do
   local bib = io.open("output/bib/" .. k .. ".bib", "w")
   local authors = table.concat(v["authors"], " and ")
   local pos = string.find(v["authors"][1], " ")
   local abbr_fauthor = string.sub(v["authors"][1], pos+1, pos+8)
   local key = "at:" .. metadata["year"] .. "-" .. metadata["number"] .. "-" .. string.format("%03d", v["startpage"]) .. "-" .. abbr_fauthor
   bib:write("@Article{" .. key .. ",", "\n")
   bib:write("  author = {" .. authors .. "},", "\n")
   bib:write("  title = {" .. v["title"] .. "},", "\n")
   bib:write("  journal = {Ars \\TeX nica},", "\n")
   bib:write("  year = {" .. metadata["year"] .. "},", "\n")
   bib:write("  number = {" .. metadata["number"] .. "},", "\n")
   bib:write("  pages = {" .. v["startpage"] .. "-" .. v["endpage"] .. "},", "\n")
   bib:write("  month = {" .. metadata["month"] .. "},", "\n")
   bib:write("  language = {italian},", "\n")
   bib:write("  issn = {" .. metadata["issn-print"] .. "},", "\n")
   bib:write("}")
   bib:close()
   complete_bib:write("@Article{" .. key .. ",", "\n")
   complete_bib:write("  author = {" .. authors .. "},", "\n")
   complete_bib:write("  title = {" .. v["title"] .. "},", "\n")
   complete_bib:write("  journal = {Ars \\TeX nica},", "\n")
   complete_bib:write("  year = {" .. metadata["year"] .. "},", "\n")
   complete_bib:write("  number = {" .. metadata["number"] .. "},", "\n")
   complete_bib:write("  pages = {" .. v["startpage"] .. "-" .. v["endpage"] .. "},", "\n")
   complete_bib:write("  month = {" .. metadata["month"] .. "},", "\n")
   complete_bib:write("  language = {italian},", "\n")
   complete_bib:write("  issn = {" .. metadata["issn-print"] .. "},", "\n")
   complete_bib:write("}", "\n")
--   table.insert(file_list, "output/bib/" .. k .. ".bib")
end

complete_bib:close()
-- for k, v in pairs(file_list) do
--    local bib
-- end
