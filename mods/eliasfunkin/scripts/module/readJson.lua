addHaxeLibrary('TJSON', 'tjson')

local json = {}
function json.parse(path)
    return runHaxeCode('TJSON.parse(text);', {text = getTextFromFile(path)})
end

return json