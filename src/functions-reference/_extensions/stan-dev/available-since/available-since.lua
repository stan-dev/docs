function since(args)
  local version = pandoc.utils.stringify(args[1])
  local text = "Available since "..version
  if quarto.doc.is_format("pdf") then
    return {pandoc.SoftBreak(), pandoc.RawBlock('tex', "{\\mbox{\\small\\emph{"..text.."}}}")}
  elseif quarto.doc.is_format("html") then
    return {pandoc.SoftBreak(), pandoc.RawBlock('html', "<small><i>"..text.."</i></small>")}
  else
    return {pandoc.SoftBreak(), pandoc.Span(text)}
  end
end
