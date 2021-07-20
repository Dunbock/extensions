-- {"id":333,"ver":"1.0.5","libVer":"1.0.0","author":"Dunbock"}

local baseURL = "https://www.ranobes.net"
local settings = {}

-- Used in map for genres, tags and authors
local text = function(v) return v:text() end

--- @param url string The path which should extend the baseURL
--- @return string The baseURL extended by path
local function expandURL(url)
	if url:find("ranobes.net") ~= nil then
		return url
	else
		print("Needed to be expanded: " .. url)
		return baseURL .. url
	end
end

--- @param textElement, HTML element, which contains the text that should be converted (so either contains <p> or <br>)
--- @return string formatted text with manual line breaks (\n)
local function convertText(textElement)
	-- Remove unwanted html elements
	textElement:select("div.free-support"):remove() -- Chapter Ads
	textElement:select("style"):remove() -- Description Style

	-- Filter text
	local content = textElement:html()
	content = content:gsub("&nbsp;", " ")
	content = content:gsub("<p>", "")
	content = content:gsub("</p>", "")
	content = content:gsub("<br>", "")
	content = content:gsub("<hr>", "-------------------")

	return content
end

--- @param chapterURL string
--- @return string
local function getPassage(chapterURL)
	return convertText(GETDocument(expandURL(chapterURL)):select("div.story > div#arrticle"))
	--return table.concat(mapNotNil(GETDocument(chapterURL):select("div.story"):select("p"), text), "\n")
end

--	based on ReadLightNovel.lua
--- @param novelURL string, complete url
--- @param loadChapters boolean, if true then also load the chapter list, otherwise not
--- @return NovelInfo
local function parseNovel(novelURL, loadChapters)
	local novel = GETDocument(expandURL(novelURL)):selectFirst("div.structure.str_fullview > div.str_left")

	local info = NovelInfo {
		title = novel:selectFirst("[itemprop=\"name\"]"):text(), -- is a span when there is no alternative title, otherwise a h1
		imageURL = expandURL(novel:selectFirst("a[href].highslide"):attr("href")),
		--description = novel:selectFirst("div[itemprop=\"description\"]"):text(), -- has no line breaks
		description = convertText(novel:selectFirst("div[itemprop=\"description\"]")),
		genres = map(novel:selectFirst("div[itemprop=\"genre\"]"):select("a"), text),
		tags = map(novel:selectFirst("div[itemprop=\"keywords\"]"):select("a"), text),
		authors = map(novel:selectFirst("span[itemprop=\"author\"]"):select("a"), text),
		status = ({
			Ongoing = NovelStatus("PUBLISHING"),
			Completed = NovelStatus("COMPLETED")
		})[novel:selectFirst("li[title=\"Original status in: Chinese, Japanese, English, etc.\"] > span > a"):text()]
	}

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

		-- Table of content pages are found at <baseURL>/up/<novel name path>/page/<page number>/
		local toc_path = novel:selectFirst("a[href][title=\"Go to table of contents\"]"):attr("href")

		-- Get chapters of first table of content page
		local chaptersDocument = GETDocument(expandURL(toc_path)):selectFirst("div #dle-content")
		local chapters = { parseChapters(chaptersDocument) }

		-- There can be more chapters in other pages
		local navBox = chaptersDocument:selectFirst("div.block.navigation.ignore-select")
		if navBox then
			local maxPage = tonumber(navBox:selectFirst("div.pages > a:last-child"):text())

			for page = 2, maxPage do
				chaptersDocument = GETDocument(expandURL(toc_path) .. "page/" .. page .. "/"):selectFirst("div #dle-content")
				chapters[page] = parseChapters(chaptersDocument)
			end
		end

		local chaptersList = AsList(flatten(chapters))
		Reverse(chaptersList)
		info:setChapters(chaptersList)
	end

	return info
end

--- @param filters table @of applied filter values [QUERY] is the search query, may be empty
--- @param reporter fun(v : string | any)
--- @return Novel[]
local function search(filters, reporter)
	return {}
end

return {
	id = 333,
	name = "Ranobes",
	baseURL = baseURL,

	-- Optional values to change
	imageURL = "https://github.com/Dunbock/extensions/raw/impl-ranobes.net/icons/Ranobes.png",
	hasCloudFlare = false,
	hasSearch = false,


	-- Must have at least one value
	listings = {
		Listing("Novels", true, function(data)
			return map(GETDocument(expandURL("/novels/page/" .. data[PAGE] .. "/"))
					:selectFirst("div#dle-content")
					:select("article.block.story"), function(e)
				return Novel {
					title = e:selectFirst("h2.title > a"):text(),
					link = expandURL(e:selectFirst("h2.title > a"):attr("href")),
					imageURL = expandURL(e:selectFirst("figure.cover"):attr("style"):sub(23, -3))
				}
			end)
		end),
		Listing("Latest Updates", true, function(data)
			return map(GETDocument(expandURL("/updates/page/" .. data[PAGE] .. "/"))
					:selectFirst("div#mainside > div.str_left")
					:select("div.block.story_line"), function(e)
				return Novel {
					title = e:selectFirst("a > div > h3.title"):text(),
					link = expandURL(GETDocument(expandURL(e:selectFirst("a"):attr("href")))
							:selectFirst("h1[itemprop=\"headline\"] > div.category > a"):attr("href")),
					imageURL = expandURL(e:selectFirst("a > i.image.cover"):attr("style"):sub(22, -2))
				}
			end)
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
