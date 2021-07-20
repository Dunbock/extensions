-- {"id":333,"ver":"1.0.1","libVer":"1.0.0","author":"Dunbock"}

local baseURL = "https://www.ranobes.net"
local settings = {}

local text = function(v) return v:text() end

--- @param chapterURL string
--- @return string
local function getPassage(chapterURL)
	return table.concat(mapNotNil(GETDocument(chapterURL):select("div.story"):select("p"), text), "\n")
end

--	based on ReadLightNovel.lua
--- @param novelURL string, complete url
--- @param loadChapters boolean, if true then also load the chapter list, otherwise not
--- @return NovelInfo
local function parseNovel(novelURL, loadChapters)
	local doc = GETDocument(novelURL)
	local wrap = doc:selectFirst("div.structure.str_fullview")
	local novel = wrap:selectFirst("div.str_left")

	local info = NovelInfo {
		title = novel:selectFirst("span[itemprop=\"name\"]"):text(),
		imageUrl = novel:selectFirst("a[href].highslide"):attr("href"),
		description = novel:selectFirst("div[itemprop=\"description\"]"):text(), -- TODO mehrzeilig machen
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
					link = titleElement:attr("href"),
					release = titleElement:selectFirst("small"):text()
				}
			end)
		end

		-- Table of content pages are found at <baseURL>/up/<toc URL extension>/page/<page number>/
		local tocURLextension = wrap:selectFirst("a[href][title=\"Go to table of contents\"]"):attr("href")

		-- Get chapters of first table of content page
		local toc_page_one = GETDocument(baseURL .. tocURLextension):selectFirst("div #dle-content")
		local chapters = { parseChapters(toc_page_one) }

		-- There can be more chapters in other pages
		local navBox = toc_page_one:selectFirst("div.block.navigation.ignore-select")
		if navBox then
			local maxPage = tonumber(navBox:selectFirst("div.pages > a:last-child"):text())

			for page = 2, maxPage do
				local chaptersDocument = GETDocument(baseURL .. tocURLextension .. "/page/" .. page .. "/"):selectFirst("div #dle-content")
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
			return map(GETDocument(baseURL .. "/novels/page/" .. data[PAGE] .. "/")
					:selectFirst("div#dle-content")
					:select("article.block"), function(e)
				return Novel {
					title = e:selectFirst("h2.title > a"):text(),
					link = e:selectFirst("h2.title > a"):attr("href"),
					imageURL = e:selectFirst("figure.cover"):attr("style"):sub(23, -3)
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
