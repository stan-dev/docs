-- Adds a unique link to each index entry in the HTML output
-- based on those special comments we have for functions

-- This is combined with the output of the gen_index.py script
-- to create a clickable index of all the functions in the documentation

function extractIndexEntry(elementText)
  if elementText:find(";-->$") ~= nil then
    return "index-entry-" .. tostring(pandoc.sha1(elementText))
  end
  return nil
end

if FORMAT == "latex" then
  return {} -- latex uses mkindex, not this
else
  return {
    RawBlock = function(el)
      if el.format == "html" then
        local indexEntry = extractIndexEntry(el.text)
        if indexEntry ~= nil then
          return pandoc.RawInline("html", "<a id=\"" .. indexEntry .. "\" class=\"index-entry\"></a> " .. el.text)
        end
      end
      return nil -- no change
    end
  }
end
