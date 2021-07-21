-- {"id":333,"ver":"1.0.8","libVer":"1.0.0","author":"Dunbock"}

local baseURL = "https://www.ranobes.net"
local settings = {}

local key_spacing = 100 -- The genres and tags key starts at key_spacing
local GENRES_EXT = { "Action", "Adult", "Adventure", "Comedy", "Drama", "Ecchi", "Fantasy", "Game", "Gender Bender", "Harem", "Josei", "Historical", "Horror", "Martial Arts", "Mature", "Mecha", "Mystery", "Psychological", "Romance", "School Life", "Sci-fi", "Seinen", "Shoujo", "Shounen", "Slice of Life", "Shounen Ai", "Sports", "Supernatural", "Smut", "Tragedy", "Xianxia", "Xuanhuan", "Wuxia", "Yaoi" }
local genres_map = {}
local TAGS_EXT = { "Abandoned Children", "Ability Steal", "Absent Parents", "Abusive Characters", "Academy", "Accelerated Growth", "Acting", "Action", "Adapted to Anime", "Adapted to Drama", "Adapted to Drama CD", "Adapted to Game", "Adapted to Manga", "Adapted to Manhua", "Adapted to Manhwa", "Adapted to Movie", "Adapted to Visual Novel", "Adopted Children", "Adopted Protagonist", "Adultery", "Adventure", "Adventurers", "Affair", "Against the Gods", "Age Progression", "Age Regression", "Aggressive Characters", "Alchemist", "Alchemy", "Aliens", "All-Girls School", "Alternate World", "Amnesia", "Amusement Park", "An*l", "Ancient China", "Ancient Times", "Androgynous Characters", "Androids", "Angels", "Angst", "Animal Characteristics", "Animal Rearing", "Anti-Magic", "Anti-social Protagonist", "Antihero", "Antihero Protagonist", "Antique Shop", "Apartment Life", "Apathetic Protagonist", "Apocalypse", "Appearance Changes", "Appearance Different from Actual Age", "Archery", "Aristocracy", "Arms Dealers", "Army", "Army Building", "Arranged Marriage", "Arrogant Characters", "Artifact Crafting", "Artifacts", "Artificial Intelligence", "Artists", "Asexual Protagonist", "Assassins", "Astrologers", "Autism", "Automatons", "Average-looking Protagonist", "Award-winning Work", "Awkward Protagonist", "Bands", "Baseball", "Based on a Movie", "Based on a Video Game", "Based on an Anime", "Basketball", "Battle Academy", "Battle Competition", "BDSM", "Beast Companions", "Beastkin", "Beasts", "Beautiful Couple", "Beautiful Female Lead", "Bestiality", "Betrayal", "Bickering Couple", "Biochip", "Bisexual Protagonist", "Black Belly", "Blackmail", "Blacksmith", "Blind Protagonist", "Blood Manipulation", "Bloodlines", "Body Swap", "Body Tempering", "Body-double", "Bodyguards", "Books", "Bookworm", "Boss-Subordinate Relationship", "bottommc", "Brainwashing", "Breast Fetish", "Broken Engagement", "Brother Complex", "Brotherhood", "Buddhism", "Bullying", "Business Management", "Businessmen", "Butlers", "C*nnilingus", "Calm Protagonist", "Cannibalism", "Card Games", "Carefree Protagonist", "Caring Protagonist", "Cautious Protagonist", "Celebrities", "CEO", "Chapters Reviews", "Character Growth", "Charismatic Protagonist", "Charming Protagonist", "Chat Rooms", "Chatgroup", "Cheats", "Chefs", "Child Abuse", "Child Protagonist", "Childcare", "Childhood Friends", "Childhood Love", "Childhood Promise", "Childish Protagonist", "Chuunibyou", "Clan Building", "Clever Protagonist", "Cliche", "Clingy Lover", "Clones", "Clubs", "Clumsy Love Interests", "Co-Workers", "Cohabitation", "Cold Love Interests", "Cold Male Protagonist", "Cold Protagonist", "College or University", "College/University", "Coma", "Comedic Undertone", "Comedy", "Coming of Age", "Complex Family Relationships", "Conditional Power", "Confident Protagonist", "Confinement", "Conflicting Loyalties", "Conspiracies", "Contracts", "Cooking", "Corruption", "Cosmic Wars", "Couple Growth", "Court Official", "Cousins", "Cowardly Protagonist", "Crafting", "Crime", "Criminals", "Cross-dressing", "Crossover", "Cruel Characters", "Cryostasis", "Cultivation", "Cunning Protagonist", "Curious Protagonist", "Curses", "Cute Children", "Cute Protagonist", "Cute Story", "Dancers", "Dao Companion", "Dao Comprehension", "Daoism", "Dark", "Dead Protagonist", "Death", "Death of Loved Ones", "Debts", "Delinquents", "Delusions", "Demi-Humans", "Demon Lord", "Demonic Cultivation Technique", "Demons", "Dense Protagonist", "Depictions of Cruelty", "Depression", "Destiny", "Detectives", "Determined Protagonist", "Devils", "Devoted Love Interests", "Different Social Status", "Disabilities", "Discrimination", "Disfigurement", "Dishonest Protagonist", "Distrustful Protagonist", "Divination", "Divination Enlightenment", "Divine Protection", "Divorce", "Doctors", "Dolls or Puppets", "Domestic Affairs", "doppelganger", "Doting Love Interests", "Doting Older Siblings", "Doting Parents", "Dragon", "Dragon Riders", "Dragon Slayers", "Dragons", "Drama", "Dreams", "Drugs", "Druids", "Dungeon Master", "Dungeons", "Dwarfs", "Dystopia", "e-Sports", "Early Romance", "Earth Invasion", "Eastern Setting", "Easy Going Life", "Economics", "Eidetic Memory", "Elderly Protagonist", "Elemental Magic", "Elementalists", "Elves", "Emotionally Weak Protagonist", "Empires", "Enemies", "Enemies Become Allies", "Enemies Become Lovers", "Engagement", "Engineer", "Enlightenment", "Episodic", "Eunuch", "European Ambience", "Evil Gods", "Evil Organizations", "Evil Protagonist", "Evil Religions", "Evolution", "Exhibitionism", "Exorcism", "Eye Powers", "F*llatio", "faceslapping", "Fairies", "Fairy Tail", "Fallen Angels", "Fallen Nobility", "Familial Love", "Familiars", "Family", "Family Business", "Family Conflict", "Famous Parents", "Famous Protagonist", "Fanaticism", "Fanfiction", "Fantasy", "Fantasy Creatures", "Fantasy World", "Farming", "Fast Cultivation", "Fast Learner", "Fat Protagonist", "Fat to Fit", "Fated Lovers", "Fearless Protagonist", "Female Lead", "Female Master", "Female Protagonist", "Female to Male", "femalelead", "Feng Shui", "Firearms", "First Love", "First-time Interc**rse", "Flashbacks", "Fleet Battles", "Folklore", "Food Shopkeeper", "Forced into a Relationship", "Forced Living Arrangements", "Forced Marriage", "Former Hero", "Fox Spirits", "Friends Become Enemies", "Friendship", "Futanari", "Futuristic Setting", "Galge", "Gambling", "Game Elements", "Game Ranking System", "Gamers", "Gangs", "Gate to Another World", "Gender Bender", "Genderless Protagonist", "Generals", "Genetic Modifications", "Genius Protagonist", "Ghosts", "Gladiators", "Glasses-wearing Protagonist", "Goblins", "God Protagonist", "God-human Relationship", "Goddesses", "Godly Powers", "Gods", "Golems", "Gore", "Gothic", "Grave Keepers", "Grinding", "Guardian Relationship", "Guilds", "Gunfighters", "H*ndjob", "Hackers", "Half-human Protagonist", "Handjob", "Handsome Male Lead", "Hard-Working Protagonist", "Harem", "Harem-seeking Protagonist", "Harsh Training", "Hated Protagonist", "Healers", "Heartwarming", "Heaven", "Heavenly Tribulation", "Hell", "Helpful Protagonist", "Hentai", "Herbalist", "Heroes", "Heterochromia", "Hidden Abilities", "Hidden Gem", "Hiding True Abilities", "Hiding True Identity", "Hikikomori", "Homunculus", "Honest Protagonist", "Hospital", "Hot-blooded Protagonist", "Human Experimentation", "Human Weapon", "Human-Nonhuman Relationship", "Humanoid Protagonist", "Hunters", "Hypnotism", "Identity Crisis", "Imaginary Friend", "Immortals", "Imperial Harem", "Incest", "Incubus", "Indecisive Protagonist", "Industrialization", "Inferiority Complex", "Inheritance", "Inscriptions", "Insects", "intensefluff", "Interconnected Storylines", "Interdimensional Travel", "Introverted Protagonist", "Investigations", "Invisibility", "Jack of All Trades", "Jealousy", "Jiangshi", "Jobless Class", "Karma", "Kendo", "Kidnappings", "Kind Love Interests", "Kingdom Building", "Kingdoms", "Knights", "Kuudere", "Lack of Common Sense", "Language Barrier", "Late Romance", "Lawyers", "Lazy Protagonist", "Leadership", "Legends", "leonine", "Level System", "LGBTQA", "Library", "Limited Lifespan", "LitRPG", "Little Romance", "Living Alone", "Loli", "Lolicon", "Loneliness", "Loner Protagonist", "Long Separations", "Lost Civilizations", "Lottery", "Love at First Sight", "Love Interest Falls in Love First", "Love Rivals", "Love Triangles", "Lovers Reunited", "Low-key Protagonist", "Loyal Subordinates", "Lucky Protagonist", "M*sturbation", "Mage", "Magic", "Magic Academy", "Magic Beasts", "Magic Formations", "Magic Realism", "Magical Girls", "Magical Space", "Magical Technology", "Maids", "Male", "Male Protagonist", "Male to Female", "Male Yandere", "Management", "Manipulative Characters", "Manly Gay Couple", "Marriage", "Marriage of Convenience", "Martial arts", "Martial Spirits", "Marvel", "Masochistic Characters", "Massacre", "Master-Disciple Relationship", "Master-Servant Relationship", "Masturbation", "Matriarchy", "Mature", "Mature Protagonist", "Mecha", "Medical Knowledge", "Medieval", "Mercenaries", "Merchants", "Military", "Mind Break", "Mind Control", "Misunderstandings", "MMORPG", "Mob Protagonist", "Models", "Modern Day", "Modern Fantasy", "Modern Knowledge", "Modern World", "Money Grubber", "Monster Girls", "Monster Society", "Monster Tamer", "Monsters", "Movies", "Mpreg", "Multiple Identities", "Multiple Personalities", "Multiple POV", "Multiple Protagonists", "Multiple Realms", "Multiple Reincarnated Individuals", "Multiple Timelines", "Multiple Transported Individuals", "Multiverse", "Murders", "Music", "Mutated Creatures", "Mutations", "Mute Character", "Mysterious Family Background", "Mysterious Illness", "Mysterious Past", "Mystery Solving", "Mythical Beasts", "Mythology", "Naive Protagonist", "Narcissistic Protagonist", "Naruto", "Nationalism", "Near-Death Experience", "Necromancer", "Neet", "Netorare", "Netori", "Nightmares", "Ninjas", "No Romance", "Nobles", "nokillingmc", "Non-human Protagonist", "Non-humanoid Protagonist", "Non-linear Storytelling", "Not Harem", "Not Netorare", "Not Yaoi", "Nudity", "Nurses", "Obsessive Love", "Office Romance", "Older Love Interests", "Omegaverse", "Online Romance", "Onmyouji", "Or*y", "Orcs", "Organized Crime", "Orphans", "Otaku", "Otome Game", "Outcasts", "Outdoor Interc**rse", "Outer Space", "Overpowered Protagonist", "Overprotective Siblings", "Paizuri", "Parallel Worlds", "Parasites", "Parent Complex", "Parody", "Part-Time Job", "Past Plays a Big Role", "Past Trauma", "Persistent Love Interests", "Personality Changes", "Perverted Protagonist", "Pets", "Pharmacist", "Philosophical", "Phoenixes", "Photography", "Pill Based Cultivation", "Pill Concocting", "Pilots", "Pirates", "Planets", "Playboys", "Playful Protagonist", "Poetry", "Poisons", "Police", "Polite Protagonist", "Politics", "Polyandry", "Polygamy", "PolygamyGore", "Poor Protagonist", "Poor to Rich", "Popular Love Interests", "Possession", "Possessive Characters", "Post-apocalyptic", "Power Couple", "Power Struggle", "Pragmatic Protagonist", "Precognition", "Pregnancy", "Pretend Lovers", "Previous Life", "Previous Life Talent", "Priestesses", "Priests", "Prison", "Proactive Protagonist", "Programmer", "Prophecies", "Prostit**es", "Prostitutes", "Protagonist Falls in Love First", "Protagonist NPC", "Protagonist Strong from the Start", "Protagonist with Multiple Bodies", "Psychic Powers", "Psychopaths", "Puppeteers", "Quiet Characters", "Quirky Characters", "R-15", "R-18", "R*pe", "R*pe Victim Becomes Lover", "Race Change", "Racism", "Raids", "Rank System", "Rape", "Rape Victim Becomes Lover", "RealRPG", "Rebellion", "Rebirth", "Reincarnated as a Monster", "Reincarnated as an Object", "Reincarnated in a Game World", "Reincarnated in Another World", "Reincarnated into a Game World", "Reincarnated into Another World", "Reincarnation", "Religions", "Reporters", "Resolute Protagonist", "Restaurant", "Resurrection", "Returning from Another World", "Revenge", "Reverse Harem", "Reverse R*pe", "Reverse Rape", "Reversible Couple", "Rich to Poor", "Righteous Protagonist", "Rivalry", "Romance", "Romantic Subplot", "Roommates", "Royalty", "Ruthless Protagonist", "S*ave Harem", "S*ave Protagonist", "S*aves", "S*x Friends", "S*x S*aves", "S*xual Abuse", "Sadistic Characters", "Saints", "Samurai", "Saving the World", "Schemes And Conspiracies", "Sci-Fantasy", "Sci-fi", "Scientists", "Sculptors", "Se", "Sealed Power", "Second Chance", "Secret Crush", "Secret Identity", "Secret Organizations", "Secret Relationship", "Secretive Protagonist", "Secrets", "Sect Development", "Sects", "Seduction", "Seeing Things Other Humans Can't", "Selfish Protagonist", "Selfless Protagonist", "Seme Protagonist", "Senpai-Kouhai Relationship", "Sentient Objects", "Sentimental Protagonist", "Serial Killers", "Servants", "Seven Deadly Sins", "Seven Virtues", "Sex Friends", "Sexual Abuse", "Sexual Cultivation Technique", "Shameless Protagonist", "Shapeshifters", "Sharing A Body", "Sharp-tongued Characters", "Shield User", "Shikigami", "Shota", "Shotacon", "Shoujo-Ai Subplot", "Shounen-Ai Subplot", "Showbiz", "Shy Characters", "Sibling Rivalry", "Siblings", "Siblings Not Related by Blood", "Sickly Characters", "Sign Language", "Singers", "Single Parent", "Sister Complex", "Skill Assimilation", "Skill Books", "Skill Creation", "Skyrim", "Slave Harem", "Slaves", "Sleeping", "Slice of Life", "Slow Cultivation", "Slow Growth at Start", "Slow Romance", "slow-romance", "Smart Couple", "Smart GG", "Smut", "Social Outcasts", "Soldiers", "Soul Power", "Souls", "Sound Magic", "Spaceship", "Spatial Manipulation", "Spear Wielder", "Spec", "Special Abilities", "Spies", "Spirit Advisor", "Spirit Users", "Spirits", "Sports", "Sports Basketball", "sportsbasketball", "Stalkers", "Stockholm Syndrome", "Stoic Characters", "Store Owner", "Straight Uke", "Strategic Battles", "Strategist", "Strength-based Social Hierarchy", "Strong Love Interests", "Strong to Stronger", "Stubborn Protagonist", "Student Council", "Student-Teacher Relationship", "Sub", "Succubus", "Sudden Strength Gain", "Sudden Wealth", "Suicides", "Summoned Hero", "Summoning Magic", "supernatural", "Survival", "Survival Game", "Sword And Magic", "Sword Wielder", "System", "System Administrator", "Talent", "Teachers", "Teamwork", "Technological Gap", "Tentacles", "Terminal Illness", "Terrorists", "Thieves", "Threesome", "Thriller", "Time Loop", "Time Manipulation", "Time Paradox", "Time Skip", "Time Travel", "Timid Protagonist", "Tomboyish Female Lead", "Torture", "Toys", "Tragic Past", "Transformation Ability", "Transmigration", "Transplanted Memories", "Transported into a Game World", "Transported Modern Structure", "Transported to Another World", "Trap", "Travel Between Worlds", "Tribal Society", "Trickster", "true love", "Tsundere", "Twins", "Twisted Personality", "Ugly Protagonist", "Ugly to Beautiful", "Unconditional Love", "Underestimated Protagonist", "Unique Cultivation Technique", "Unique Weapon User", "Unique Weapons", "Unlucky Protagonist", "Unreliable Narrator", "Unrequited Love", "Urban", "Valkyries", "Vampire", "Vampires", "Villainess Noble Girls", "Virtual Reality", "Voice Actors", "Voyeurism", "War Records", "Wars", "Weak Protagonist", "Weak to Strong", "Wealthy Characters", "Week to Strong", "Werebeasts", "Wishes", "Witches", "Wizards", "World Hopping", "World Travel", "World Tree", "Writers", "Wuxia", "Xianxia", "Yandere", "Youkai", "Younger Brothers", "Younger Love Interests", "Younger Sisters", "Yuri", "Zombie", "Zombies" }
local tags_map = {}
local ORIGIN_LANGUAGE_EXT = { "Chinese", "Korean", "English", "Japanese" }
local origin_language_map = {}
local origin_language_exclude_map = {}

local SORT_BY_KEY = 2
local SORT_BY_EXT = { "Default", "Title", "New novels", "Old novels", "More comments", "More Views", "More Chapters", "New modified" }
local RELEASE_YEAR_FROM_KEY = 3
local RELEASE_YEAR_UP_TO_KEY = 4
local TRANSLATION_STATUS_KEY = 5
local TRANSLATION_STATUS_EXT = { "Any", "Active", "Completed", "Unknown", "Break" }
local STATUS_COO_KEY = 6
local STATUS_COO_EXT = { "Any", "Ongoing", "Completed", "Hiatus", "Dropped" }
local MINIMUM_CHAPTERS_KEY = 7
local MAXIMUM_CHAPTERS_KEY = 8

-- Used in map for genres, tags and authors
local text = function(v) return v:text() end

local function dump(o)
	if type(o) == 'table' then
		local s = '{ '
		for k,v in pairs(o) do
			if type(k) ~= 'number' then k = '"'..k..'"' end
			s = s .. '['..k..'] = ' .. dump(v) .. ','
		end
		return s .. '} '
	else
		return tostring(o)
	end
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
	if page ~= nil then
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
	content = content:gsub("<hr>", "-------------------")

	return content
end

--- @param chapterURL string The link to the chapter, which contains the chapter content.
--- @return string The chapter text without the headline as plain text.
local function getPassage(chapterURL)
	return convertToText(GETDocument(expandURL(chapterURL)):select("div.story > div#arrticle"))
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
		authors = map(novel:selectFirst("span[itemprop=\"author\"]"):select("a"), text),
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
	local runner = ""

	-- Novel title must contain
	if data[RELEASE_YEAR_FROM_KEY] ~= ""  then
		searchParameter = searchParameter .. "/l.title" .. parseToURL(data[QUERY])
	end

	-- Sort results
	if data[SORT_BY_KEY] ~= "" then
		searchParameter = searchParameter .. "/sort=" .. ({
			[0] = "date;desc", -- Default
			[1] = "title;asc", -- Title
			[2] = "date;desc", -- New novels
			[3] = "date;asc", -- Old novels
			[4] = "comm_num;desc", -- More comments
			[5] = "news_read;desc", -- More Views
			[6] = "d.chap-num;desc", -- More Chapters
			[7] = "editdate;desc/" -- New modified
		})[data[SORT_BY_KEY]]
	end

	-- Year of release from and up to
	if data[RELEASE_YEAR_FROM_KEY] ~= ""  then
		searchParameter = searchParameter .. "/f.year=" .. parseToURL(data[RELEASE_YEAR_FROM_KEY])
	end
	if data[RELEASE_YEAR_UP_TO_KEY] ~= "" then
		searchParameter = searchParameter .. "/t.year=" .. parseToURL(data[RELEASE_YEAR_UP_TO_KEY])
	end

	-- Translation status
	if data[TRANSLATION_STATUS_KEY] ~= "" and data[TRANSLATION_STATUS_KEY] ~= 0 then
		searchParameter = searchParameter .. "/status-trs=" .. ({
			--[0] = "Any", -- Any is default therefore skip
			[1] = "Active", -- Active
			[2] = "Completed", -- Completed
			[3] = "Unknown", -- Unknown
			[4] = "Break" -- Break
		})[data[TRANSLATION_STATUS_KEY]]
	end

	-- Status COO
	if data[STATUS_COO_KEY] ~= "" and data[STATUS_COO_KEY] ~= 0 then
		searchParameter = searchParameter .. "/status-end=" .. ({
			--[0] = "Any", -- Any is default therefore skip
			[1] = "Ongoing", -- Ongoing
			[2] = "Completed", -- Completed
			[3] = "Hiatus", -- Hiatus
			[4] = "Dropped" -- Dropped
		})[data[STATUS_COO_KEY]]
	end

	-- Minimum and maximum chapters
	if data[MINIMUM_CHAPTERS_KEY] ~= "" then
		searchParameter = searchParameter .. "/f.chap-num=" .. parseToURL(data[MINIMUM_CHAPTERS_KEY])
	end
	if data[MAXIMUM_CHAPTERS_KEY] ~= "" then
		searchParameter = searchParameter .. "/t.chap-num=" .. parseToURL(data[MAXIMUM_CHAPTERS_KEY])
	end

	-- Original language
	runner = ""
	for key, value in pairs(origin_language_map) do
		if data[key] then
			runner = runner .. "," .. value
		end
	end
	if runner ~= "" then
		searchParameter = searchParameter .. "/b.languages=" .. parseToURL(runner:sub(2))
	end

	-- Original language exclusion
	runner = ""
	for key, value in pairs(origin_language_exclude_map) do
		if data[key] then
			runner = runner .. "," .. value
		end
	end
	if runner ~= "" then
		searchParameter = searchParameter .. "/v.languages=" .. parseToURL(runner:sub(2))
	end

	-- Genres
	runner = ""
	for key, value in pairs(genres_map) do
		if data[key] then
			runner = runner .. "," .. value
		end
	end
	if runner ~= "" then
		searchParameter = searchParameter .. "/n.genre=" .. parseToURL(runner:sub(2))
	end

	-- Tags
	runner = ""
	for key, value in pairs(tags_map) do
		if data[key] then
			runner = runner .. "," .. value
		end
	end
	if runner ~= "" then
		searchParameter = searchParameter .. "/n.events=" .. parseToURL(runner:sub(2))
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
	hasCloudFlare = false,
	hasSearch = true,
	isSearchIncrementing = true,

	-- Must have at least one value
	listings = {
		Listing("Novels", true, function(data)
			return parseNovelsOverview(data[PAGE], nil)
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
		DropdownFilter(SORT_BY_KEY, "Order by", SORT_BY_EXT),
		TextFilter(RELEASE_YEAR_FROM_KEY, "Year of release from"),
		TextFilter(RELEASE_YEAR_UP_TO_KEY, "Year of release up to"),
		DropdownFilter(TRANSLATION_STATUS_KEY, "Translation status", TRANSLATION_STATUS_EXT),
		DropdownFilter(STATUS_COO_KEY, "Status in COO (country of origin)", STATUS_COO_EXT),
		TextFilter(MINIMUM_CHAPTERS_KEY, "Minimum chapters"),
		TextFilter(MAXIMUM_CHAPTERS_KEY, "Maximum chapters"),
		FilterGroup("Only include original language", map(ORIGIN_LANGUAGE_EXT, function(v, k)
			key_spacing = key_spacing + 1
			origin_language_map[key_spacing] = k
			return  SwitchFilter(key_spacing, v)
		end)),
		FilterGroup("Exclude original language", map(ORIGIN_LANGUAGE_EXT, function(v, k)
			key_spacing = key_spacing + 1
			origin_language_exclude_map[key_spacing] = k
			return  SwitchFilter(key_spacing, v)
		end)),
		FilterGroup("Genres", map(GENRES_EXT, function(v, k)
			key_spacing = key_spacing + 1
			genres_map[key_spacing] = k
			return CheckboxFilter(key_spacing, v)
		end)),
		FilterGroup("Tags (Events)", map(TAGS_EXT, function(v, k)
			key_spacing = key_spacing + 1
			tags_map[key_spacing] = k
			return CheckboxFilter(key_spacing, v)
		end))
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