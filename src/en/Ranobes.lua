-- {"id":333,"ver":"1.0.24","libVer":"1.0.0","author":"Dunbock"}

local baseURL = "https://www.ranobes.net"

-- Used in map for genres, tags and authors
local text = function(v) return v:text() end

--- @param url string The URL that should be shrunk to the path
--- @return string An URL path
local function shrinkURL(url)
	return url:gsub(".-ranobes%.net", "")
end

--- @param url string The path which should extend the baseURL
--- @return string The baseURL extended by path
local function expandURL(url)
	if url:find("ranobes.net") ~= nil then
		return url
	else
		return baseURL .. url
	end
end

--- @param page number | nil The page number that is requested.
--- @param searchParameter string | nil The search parameter that should be used.
--- @return Novel[]
local function parseNovelsOverview(page, searchParameter)
	-- Build the URL
	local url = "/novels"

	if searchParameter ~= nil then
		url = url .. searchParameter
	end
	if page ~= nil and page ~= 1 then
		url = url .. "/page/" .. page
	end

	-- Check if there is a search result or a page with that page number and if so parse it, otherwise return no novels.
	local doc = GETDocument(expandURL(url)):selectFirst("div.str_left")
	if doc:selectFirst("div.alert") then
		-- Either no search results or the page number is to high
		return { }
	else
		return map(doc:selectFirst("div#dle-content"):select("article.block.story"), function(e)
			return Novel {
				title = e:selectFirst("h2.title > a"):text(),
				link = expandURL(e:selectFirst("h2.title > a"):attr("href")),
				imageURL = expandURL(e:selectFirst("figure.cover"):attr("style"):sub(23, -3))
			}
		end)
	end
end

--- @param textElement string HTML-element, which contains the text (using <p> or <br>) that should be converted.
--- @return string The chapter text without the headline as plain text.
local function convertToText(htmlElement)
	-- Remove unwanted html elements.
	htmlElement:select("div.free-support"):remove() -- Chapter Ads
	htmlElement:select("style"):remove() -- Description Style

	-- Get the actual chapter content and remove the html. Due to the HTML format no need to add line breaks.
	local content = htmlElement:html()
	content = content:gsub("&nbsp;", " ")
	content = content:gsub("<p>", "")
	content = content:gsub("</p>", "")
	content = content:gsub("<br>", "")

	return content
end

--- @param chapterURL string The link to the chapter, which contains the chapter content.
--- @return string The chapter text without the headline as plain text.
local function getPassage(chapterURL)

	Log("URL", chapterURL)

	local htmlElement = GETDocument(expandURL(chapterURL))

	Log("DOKUMENT", htmlElement:toString())

	htmlElement = htmlElement:selectFirst("div.story")

	Log("DIVSTORY", htmlElement:toString())

	-- Remove/modify unwanted HTML elements to get a clean webpage.
	htmlElement:select("meta"):remove()
	htmlElement:select("link[itemprop=\"image\"]"):remove()
	htmlElement:select("div.icon.iccon-cat"):remove()
	htmlElement:select("div.story_tools"):remove()
	htmlElement:select("div.free-support"):remove() -- Chapter Ads

	Log("CLEANED", htmlElement:toString())

	Log("OUTPUT", pageOfElem(htmlElement))
	return pageOfElem(htmlElement)
end

--	based on ReadLightNovel.lua
--- @param novelURL string The URL to the landing page of the novel, which information is returned.
--- @param loadChapters boolean Determines whether the chapter list also gets loaded.
--- @return NovelInfo The information about the novel of the novelURL.
local function parseNovel(novelURL, loadChapters)
	-- Get novel webpage and parse novel information from it.
	local novel = GETDocument(expandURL(novelURL)):selectFirst("div.structure.str_fullview > div.str_left")

	-- Status is if it is a translation then the translation status otherwise the COO status.
	local status = novel:selectFirst("li[title=\"English translation status\"] > span > a")
	if status then
		status = ({
			Active = NovelStatus.PUBLISHING,
			Completed = NovelStatus.COMPLETED,
			Unknown = NovelStatus.UNKNOWN,
			Break = NovelStatus.PAUSED
		})[status:text()]
	else
		status = novel:selectFirst("li[title=\"Original status in: Chinese, Japanese, English, etc.\"] > span > a")
		status = ({
			Ongoing = NovelStatus.PUBLISHING,
			Completed = NovelStatus.COMPLETED,
			Dropped = NovelStatus.UNKNOWN,
			Hiatus = NovelStatus.PAUSED
		})[status:text()]
	end

	local info = NovelInfo {
		title = novel:selectFirst("[itemprop=\"name\"]"):text(),
		-- title is a span when there is no alternative title, otherwise a h1. Therefore leave element name out.
		imageURL = expandURL(novel:selectFirst("a[href].highslide"):attr("href")),
		description = convertToText(novel:selectFirst("div[itemprop=\"description\"]")),
		genres = map(novel:selectFirst("div[itemprop=\"genre\"]"):select("a"), text),
		tags = map(novel:selectFirst("div[itemprop=\"keywords\"]"):select("a"), text),
		authors = map(novel:selectFirst("span[itemprop=\"creator\"]"):select("a"), text),
		status = status
	}

	-- Parse the novel chapter information if desired
	if loadChapters then
		--- @param chaptersDocument Document
		--- @return NovelChapter
		local function parseChapters(chaptersDocument)
			return map(chaptersDocument:select("div.cat_line"), function(article)
				local titleElement = article:selectFirst("a")
				return NovelChapter {
					title = titleElement:selectFirst("h6"):text(),
					link = expandURL(titleElement:attr("href")),
					release = titleElement:selectFirst("small"):text()
				}
			end)
		end

		-- There may be multiple table of content pages for chapters, get the link to the first one:
		local toc_path = novel:selectFirst("a[href][title=\"Go to table of contents\"]"):attr("href")
		-- Expected result: <baseURL>/up/<novel name>/
		-- Further pages can be reached by appending the following: page/<page number>/

		-- Get chapters of first table of content page.
		local chaptersDocument = GETDocument(expandURL(toc_path)):selectFirst("div #dle-content")
		local chapters = { parseChapters(chaptersDocument) }

		-- Check if there are further pages to get chapters from and do so if applicable.
		local navBox = chaptersDocument:selectFirst("div.block.navigation.ignore-select")
		if navBox then
			local maxPage = tonumber(navBox:selectFirst("div.pages > a:last-child"):text())

			for page = 2, maxPage do
				chaptersDocument = GETDocument(expandURL(toc_path) .. "page/" .. page .. "/"):selectFirst("div #dle-content")
				chapters[page] = parseChapters(chaptersDocument)
			end
		end

		-- Chapter list started with the newest first, so flatten and reverse.
		local chaptersList = AsList(flatten(chapters))
		Reverse(chaptersList)
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
		searchParameter = searchParameter .. "/l.title=" .. parseToURL(data[QUERY])
	end

	-- Get search result.
	return parseNovelsOverview(data[PAGE], searchParameter)
end

return {
	id = 333,
	name = "Ranobes",
	baseURL = baseURL,

	-- Optional values to change
	imageURL = "https://github.com/Dunbock/extensions/raw/impl-ranobes.net/icons/Ranobes.png",
	hasCloudFlare = true,
	hasSearch = true,
	isSearchIncrementing = true,
	chapterType = ChapterType.HTML,

	shrinkURL = shrinkURL,
	expandURL = expandURL,

	-- Must have at least one value
	listings = {
		Listing("Novels", true, function(data)
			return parseNovelsOverview(data[PAGE], nil)
		end)
	},

	-- Optional if usable
	searchFilters = {
	},
	settings = {
	},

	-- Default functions that have to be set
	getPassage = getPassage,
	parseNovel = parseNovel,
	search = search,
	updateSetting = function(id, value)
		settings[id] = value
	end
}