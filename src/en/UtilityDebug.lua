-- {"id":334,"ver":"1.0.0","libVer":"1.0.0","author":"Dunbock","dep":["Utility>=1.0.0"]}

local convertToText = Require("Utility").convertToText

local baseURL = "dummyBaseURL"

--- @param page number | nil The page number that is requested.
--- @param searchParameter string | nil The search parameter that should be used.
--- @return Novel[]

--- @param chapterURL string The link to the chapter, which contains the chapter content.
--- @return string The chapter text without the headline as plain text.
local function getPassage(chapterURL)
    return UtilityLib.convertToText(chapterURL, true)
end

--	based on ReadLightNovel.lua
--- @param novelURL string The URL to the landing page of the novel, which information is returned.
--- @param loadChapters boolean Determines whether the chapter list also gets loaded.
--- @return NovelInfo The information about the novel of the novelURL.
local function parseNovel(novelURL, loadChapters)

    local info = NovelInfo {
        title = "dummy",
        link = "dummyParseNovelURL",
        imageURL = "https://via.placeholder.com/150.png",
        description = convertToText("dummy element", true),
        authors = { "Author dummy" },
        genres = { "Genre1", "Genre2" },
        tags = { "Tag1", "Tag2" },
        status = NovelStatus.COMPLETED
    }

    -- Parse the novel chapter information if desired
    if loadChapters then

        local chaptersList = { NovelChapter {
            title = "Chapter 1",
            link = "Chapter1.Link",
            release = os.time{year=2020, month=1, day=15}
        } }

        info:setChapters(chaptersList)
    end

    return info
end

--- @param data table @of applied filter values [QUERY] is the search query, may be empty.
--- @return Novel[] An array of novels with basic information.
local function search(data)
    --- @param text string The text that should go into the URL.
    --- @return string The text converted to the standard desired by the website.
    local function parseToURL(text)
        return text:gsub(" ", "+")
    end
    -- Create Search String
    local searchParameter = "/f"

    -- Novel title must contain
    if data[QUERY] ~= ""  then
        searchParameter = searchParameter .. "/l.title" .. parseToURL(data[QUERY])
    end

    -- Get search result.
    --return parseNovelsOverview(data[PAGE], searchParameter)
    return { Novel {
        title = searchParameter,
        link = "dummy",
        imageURL = "https://via.placeholder.com/150.png"
    } }
end

return {
    id = 334,
    name = "UtilityDebug",
    baseURL = baseURL,

    -- Optional values to change
    imageURL = "https://github.com/Dunbock/extensions/raw/impl-ranobes.net/icons/Ranobes.png",
    hasCloudFlare = false,

    -- Must have at least one value
    listings = {
        Listing("Novels", true, function(data)
            return { Novel {
                    title = "Listing.page=" .. data[PAGE],
                    link = "dummyListingURL",
                    imageURL = "https://via.placeholder.com/150.png"
                } }
            end
        )
    },

    -- Default functions that have to be set
    getPassage = getPassage,
    parseNovel = parseNovel,
    search = search,
    updateSetting = function(id, value)
        settings[id] = value
    end
}