-- {"ver":"1.0.0","author":"Dunbock"}

-- Avoid HTTPException: 403
local MTYPE = MediaType("application/x-www-form-urlencoded; charset=UTF-8")
local USERAGENT = "Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:90.0) Gecko/20100101 Firefox/90.0"
local HEADERS = HeadersBuilder():add("User-Agent", USERAGENT):build()

local function getWebpageBody(url)
    return RequestBody(GET(url, HEADERS))
end

--- @param textElement Element HTML-element, which contains the text (using <p> or <br>) that should be converted.
--- @return string textElement without the default HTML-elements of this function.
local function removeUnwantedElements(htmlElement)
    htmlElement:select("div.category"):remove() -- Link to the novel under h1 and after the text
    htmlElement:select("meta"):remove() --
    htmlElement:select("link[itemprop=\"image\"]"):remove()
    htmlElement:select("div.free-support"):remove() -- Ads in div.arrticle
    htmlElement:select("div.story_tools"):remove()
    return htmlElement
end
--- @param textElement Element HTML-element, which contains the text (using <p> or <br>) that should be converted.
--- @param removeDefaultElements boolean Whether the default HTML-element removal shall take place.
--- @return string The chapter text without the headline as plain text.
local function convertToText(htmlElement, removeDefaultElements)
    return "Utility used with .. " .. htmlElement
    -- Remove unwanted html elements.
    if removeDefaultElements == true then
        removeUnwantedElements(htmlElement)
    end

    -- Get the actual chapter content and remove the html. Due to the HTML format no need to add line breaks.
    local content = htmlElement:html()
    content = content:gsub("&nbsp;", " ")
    content = content:gsub("<p>", "")
    content = content:gsub("</p>", "")
    content = content:gsub("<br>", "")
    content = content:gsub("<hr>", "-------------------")

    return content
end

--- @param textElement string HTML-element, which contains the text (using <p> or <br>) that should be converted.
--- @param removeDefaultElements boolean Whether the default HTML-element removal shall take place.
--- @return string The chapter text cleaned and converted full HTML page.
local function convertToHTML(htmlElement, removeDefaultElements)
    -- Remove unwanted html elements.
    if removeDefaultElements == true then
        removeUnwantedElements(htmlElement)
    end

    --temp = GETDocument(expandURL(chapterURL)):select("div.story")
    print("Content: " .. htmlElement:toString())
    print("PageOfElem: " .. pageOfElem(htmlElement:toString(), false))
    return htmlElement:toString()
end

local function parseToURL(text)
    return text:gsub(" ", "+")
end

--- @param data table @of applied filter values.
--- @param key number The key of the filter that should be handled.
--- @param prefix string The prefix that should be put before the text of key.
--- @param suffix string The suffix that should be put after the text of key.
--- @return string If the key is in the data then prefix text of filter suffix, otherwise the empty string.
local function searchParameter(data, key, prefix, suffix)
    if data[key] ~= "" then
        return prefix .. parseToURL(data[key]) .. suffix
    end
    return ""
end

--- @param data table @of applied filter values.
--- @param keys table @of number The keys of the filter that should be handled.
--- @param prefix string The prefix that should be put before the text of key.
--- @param suffix string The suffix that should be put after the text of key.
--- @return string If the key is in the data then prefix text of filter suffix, otherwise the empty string.
local function searchParameters(data, keys, prefix, suffix)
    local s = ""
    for _, k in pairs(keys) do
        s = s .. searchParameter(data, k, prefix, suffix)
    end
    return s
end

--- @param data table @of applied filter values.
--- @param key number The key of the filter that should be handled.
--- @param prefix string The prefix that should be put before the text of key.
--- @param suffix string The suffix that should be put after the text of key.
--- @param tbl table @of string The resulting translation of the data value of the filter to text.
--- @return string If the key is in the data then prefix tbl[text] of filter suffix, otherwise the empty string.
local function searchParameterTable(data, key, prefix, suffix, tbl)
    -- Sort results
    if data[key] ~= "" then
        return prefix .. tbl[data[key]] .. suffix
    end
    return ""
end

--- @param tbl table
--- @return string The table tbl as a string.
local function dumpTable(tbl)
    if type(tbl) == 'table' then
        local s = '{ '
        for k, v in pairs(tbl) do
            if type(k) ~= 'number' then
                k = '"'..k..'"'
            end
            s = s .. '['..k..'] = ' .. dumpTable(v) .. ','
        end
        return s .. '}'
    else
        return tostring(tbl)
    end
end

return {
    getWebpageBody = getWebpageBody,
    convertToText = convertToText,
    convertToHTML = convertToHTML,
    searchParameter = searchParameter,
    searchParameters = searchParameters,
    searchParameterTable = searchParameterTable,
    dumpTable = dumpTable,
}