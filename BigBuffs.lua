local addon, ns = ... 
local BigBuffsCooldowns = ns.BigBuffsCooldowns

----Config----
local ICON_SIZE = 28
local ICONS_OFFSET_X = 0
local ICONS_OFFSET_Y = 30
local FONT = "Interface\\AddOns\\Vial\\tahoma.ttf"
local showDurationsInsteadOfCooldowns = true;
---------------

local find = string.find
local gsub = string.gsub
local band = bit.band
local ceil = ceil
local print = print
local GetTime = GetTime
local pairs = pairs
local ipairs = ipairs
local select = select

local cooldownsToReset = {
	[11958] = {"Ice Block", "Frost Nova", "Cone of Cold"},
	[14185] = {"Sprint", "Vanish", "Cloak of Shadows", "Evasion", "Dismantle"},
	--[23989] = {"Deterrence", "Silencing Shot", "Scatter Shot", "Rapid Fire", "Kill Shot", "Lynx Rush", "Dire Beast", "Binding Shot", "Fervor", "Wyvern Sting", "Master's Call", "Bestial Wrath"}, (Rediness no longer existe as of Patch 5.4)
}

local interrupts = {"Mind Freeze", "Skull Bash", "Silencing Shot", "Counter Shot", "Counterspell", "Rebuke", "Silence", "Kick", "Wind Shear", "Pummel", "Disrupting Shout", "Shield Bash", "Spell Lock", "Strangulate", "Spear Hand Strike"}

local updateInterval = 0.5
local timeSinceLastUpdate = 0
local activeIcons = {}
local spellStartTime = {}
local totalIcons = 0
local width
local fontHeight = ceil(ICON_SIZE / 2)

local frameCache = {}

local function acquireFrame(parent)
	local frame = tremove(frameCache) or CreateFrame("Frame")
	frame:SetParent(parent)
	return frame
end

local function releaseFrame(frame)
	frame:Hide()
	frame:SetParent(nil)
	frame:ClearAllPoints()
	tinsert(frameCache, frame)
end

local function setIconsProperties(playerName, nameplate)
	--print("setIconsProperties")
	local num = #activeIcons[playerName]
	if not width then 
		width = nameplate:GetWidth() 
	end
	local iconSize
	if num * ICON_SIZE + (num * 2 - 2) > width then
		iconSize = (width - (num * 2 - 2)) / num
	else 
		iconSize = ICON_SIZE
	end
	fontHeight = ceil(iconSize / 2)
	for i = 1, #activeIcons[playerName] do
		activeIcons[playerName][i]:ClearAllPoints()
		activeIcons[playerName][i]:SetWidth(iconSize)
		activeIcons[playerName][i]:SetHeight(iconSize)
		activeIcons[playerName][i].timeLeft:SetFont(FONT, fontHeight, "OUTLINE")
		if i == 1 then
			activeIcons[playerName][i]:SetPoint("TOPLEFT", nameplate, ICONS_OFFSET_X, ICONS_OFFSET_Y)
		else
			activeIcons[playerName][i]:SetPoint("TOPLEFT", activeIcons[playerName][i - 1], iconSize + 2, 0)
		end
	end
end

local function hideIcons(playerName, nameplate)
	--print("hideIcons")
	nameplate.Vial = 0
	for i = 1, #activeIcons[playerName] do
		activeIcons[playerName][i]:Hide()
		--activeIcons[playerName][i]:SetParent(nil) -- just set parent when you show()
	end
	--nameplate:SetScript("OnHide", nil) -- ??
end

local function icon_OnUpdate(self, elapsed)
	self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed
	if self.timeSinceLastUpdate < updateInterval then
		return
	end
	self.timeSinceLastUpdate = 0
	local timeLeft = ceil(self.endTime - GetTime())
	self.timeLeft:SetFont(FONT, fontHeight, "OUTLINE")
	if timeLeft >= 60 then
		self.timeLeft:SetText(ceil(timeLeft / 60).."m")
	elseif timeLeft < 60 and timeLeft >= 1 then
		self.timeLeft:SetText(timeLeft)
	else
		self.timeLeft:SetText(" ")
		self:SetScript("OnUpdate", nil)
	end	
end


local function makeIcon(spellID)
	local _, _, texture = GetSpellInfo(spellID)
	local cd = BigBuffsCooldowns.duration[spellID]
	local icon = acquireFrame(UIParent)
	icon.texture = icon:CreateTexture(nil, "BORDER")
	icon.texture:SetAllPoints(icon)
	icon.texture:SetTexture(texture)
	icon.endTime = GetTime() + cd
	icon.timeLeft = icon:CreateFontString(nil, "OVERLAY")
	icon.timeLeft:SetTextColor(0.7, 1, 0)
	icon.timeLeft:SetAllPoints(icon)
	icon.spellName = spellName
	icon.timeSinceLastUpdate = 0
	--[[for i, spell in ipairs(interrupts) do
		if spell == spellName then
			local iconBorder = icon:CreateTexture(nil, "OVERLAY")
			iconBorder:SetTexture("Interface\\AddOns\\Vial\\Border.tga")
			iconBorder:SetVertexColor(1, 0.35, 0)
			iconBorder:SetAllPoints(icon)
		end
	end]]
	return icon
end

local function releaseResetedIcons(playerName, spellID)
	for k, spell in ipairs(cooldownsToReset[spellID]) do
		for i = 1, #activeIcons[playerName] do
			if activeIcons[playerName][i] then -- remove?
				if activeIcons[playerName][i].spellName == spell then
					-- get rid of this?
					if activeIcons[playerName][i]:IsVisible() then
						local f = activeIcons[playerName][i]:GetParent()
						if f.Vial and f.Vial ~= 0 then
							f.Vial = 0
						end
					end
					--
					releaseFrame(activeIcons[playerName][i])
					tremove(activeIcons[playerName], i)
					totalIcons = totalIcons - 1
				end
			end
		end
	end
end

local function releaseOldIcon(playerName, spellID)
	for i = 1, #activeIcons[playerName] do
		if activeIcons[playerName][i] then
			if activeIcons[playerName][i].spellName == spellName then
				-- and this
				if activeIcons[playerName][i]:IsVisible() then
					local f = activeIcons[playerName][i]:GetParent()
					if f.Vial then
						f.Vial = 0
					end
				end
				--
				releaseFrame(activeIcons[playerName][i])
				tremove(activeIcons[playerName], i)
				totalIcons = totalIcons - 1
			end
		end
	end
end

local function addCooldownSpell(playerName, spellID, spellName)
	print("addCooldownSpell") 
	if not activeIcons[playerName] then activeIcons[playerName] = {} end
	if spellID == 14185 or spellID == 11958 then -- if preparation or cold snap
		releaseResetedIcons(playerName, spellID)
	end
	releaseOldIcon(playerName, spellName)
	local icon = makeIcon(spellID)
	tinsert(activeIcons[playerName], icon)
	icon:SetScript("OnUpdate", icon_OnUpdate)
end

local function releaseUnusedIcons()
	for playerName, playerActiveIcons in pairs(activeIcons) do
		for i, icon in ipairs(playerActiveIcons) do
			if icon.endTime < GetTime() then
				if icon:IsVisible() then
					local f = icon:GetParent()
					if f.Vial then
						f.Vial = 0
					end
				end
				releaseFrame(icon)
				tremove(activeIcons[playerName], i)
				totalIcons = totalIcons - 1
			end
		end
	end
end

local function checkVisibleNameplates()
	for i = 1, WorldFrame:GetNumChildren() do
		local nameplate = select(i, WorldFrame:GetChildren())
		local nameplateName = nameplate:GetName()
		if nameplateName and find(nameplateName, "NamePlate") then
			if not nameplate.Vial then nameplate.Vial = 0 end -- all this nameplate.Vial shit is bad
			if nameplate:IsVisible() then
				local _, nameFrame = nameplate:GetChildren() -- ??
				local nameText = nameFrame:GetRegions() -- Returns a list of non-Frame child regions belonging to the frame 
				local playerName = gsub(nameText:GetText(), '%s%(%*%)', '')
				if activeIcons[playerName] then
					if nameplate.Vial ~= activeIcons[playerName] then
						nameplate.Vial = #activeIcons[playerName]
						for i = 1, #activeIcons[playerName] do
							activeIcons[playerName][i]:SetParent(nameplate)
							activeIcons[playerName][i]:Show()
						end
						setIconsProperties(playerName, nameplate)
						nameplate:HookScript("OnHide", function()
							hideIcons(playerName, nameplate)
						end)
					end
				end
			end
		end
	end
end

local function BigBuffs_OnUpdate(self, elapsed)
	if totalIcons ~= 0 then
		timeSinceLastUpdate = timeSinceLastUpdate + elapsed
		if timeSinceLastUpdate > updateInterval then
			--print("OnUpdate")
			timeSinceLastUpdate = 0
			checkVisibleNameplates()
			releaseUnusedIcons()
		end
	end
end

local function BigBuffs_OnCOMBAT_LOG_EVENT_UNFILTERED(self, event, ...)
	local _, event, _, _, playerName, sourceFlags, _, _, _, _, _, spellID, spellName = ...
	if BigBuffsCooldowns.duration[spellID] and band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
		playerName = strmatch(playerName, "[%P]+")
		if event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED" or event == "SPELL_MISSED" or event == "SPELL_SUMMON" then
			if not spellStartTime[playerName] then spellStartTime[playerName] = {} end
			if not spellStartTime[playerName][spellName] or GetTime() >= spellStartTime[playerName][spellName] + 1 then
				totalIcons = totalIcons + 1
				addCooldownSpell(playerName, spellID, spellName)
				spellStartTime[playerName][spellName] = GetTime()
			end
		end
	end
end

local function BigBuffs_OnPLAYER_ENTERING_WORLD(self, event, ...) 
	activeIcons = {}
	spellStartTime = {}
	totalIcons = 0
end

local function BigBuffs_OnEvent(self, event, ...)
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		BigBuffs_OnCOMBAT_LOG_EVENT_UNFILTERED(self, event, ...)
	elseif event == "PLAYER_ENTERING_WORLD" then
		BigBuffs_OnPLAYER_ENTERING_WORLD(self, event, ...)
	end
end

local BigBuffs = CreateFrame("Frame")
BigBuffs:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
BigBuffs:RegisterEvent("PLAYER_ENTERING_WORLD")
BigBuffs:SetScript("OnEvent", BigBuffs_OnEvent)
BigBuffs:SetScript("OnUpdate", BigBuffs_OnUpdate)
