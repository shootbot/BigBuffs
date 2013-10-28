local addon, ns = ... 
local BigBuffsCooldowns = ns.BigBuffsCooldowns

----Config--------------------
local ICON_SIZE = 28
local ICONS_OFFSET_X = 0
local ICONS_OFFSET_Y = 30
local FONT = "Interface\\AddOns\\Vial\\tahoma.ttf"
------------------------------

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
}

activeIcons = {}
local updateInterval = 0.5
local timeSinceLastUpdate = 0
local spellStartTime = {}
local totalIcons = 0
local fontHeight = ceil(ICON_SIZE / 2)
local width
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

local function getPlayerNameByNameplate(nameplate)
	local _, nameFrame = nameplate:GetChildren()
	local nameText = nameFrame:GetRegions()
	local playerName = gsub(nameText:GetText(), '%s%(%*%)', '')
	return playerName
end

local function makeIcon(spellID, spellName)
	local _, _, texture = GetSpellInfo(spellID)
	local cd = BigBuffsCooldowns.cooldown[spellID]
	local icon = acquireFrame(UIParent)
	icon.texture = icon:CreateTexture(nil, "OVERLAY")
	icon.texture:SetAllPoints(icon)
	icon.texture:SetTexture(texture)
	icon.endTime = GetTime() + cd
	icon.timeLeft = icon:CreateFontString(nil, "OVERLAY")
	icon.timeLeft:SetTextColor(0.7, 1, 0)
	icon.timeLeft:SetAllPoints(icon)
	icon.spellName = spellName
	--[[ i dont want to highlight interrupts for now
	for i, spell in ipairs(interrupts) do
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
		for i, icon in ipairs(activeIcons[playerName]) do
			if icon then --?
				if icon.endTime < GetTime() then
					if icon:IsVisible() then
						local nameplate = icon:GetParent()
						nameplate.BigBuffs.iconsNum = nameplate.BigBuffs.iconsNum - 1
					end
					releaseFrame(icon)
					tremove(activeIcons[playerName], i)
					totalIcons = totalIcons - 1
				end
			end
		end
	end
end

local function releaseOldIcon(playerName, spellName)
	for i, icon in ipairs(activeIcons[playerName]) do
		if icon.spellName == spellName then
			if icon:IsVisible() then
				local nameplate = icon:GetParent()
				if nameplate and nameplate.BigBuffs then
					nameplate.BigBuffs.iconsNum = nameplate.BigBuffs.iconsNum - 1
				end
			end
			releaseFrame(icon)
			tremove(activeIcons[playerName], i)
			totalIcons = totalIcons - 1
		end
	end
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
		activeIcons[playerName][i]:SetSize(iconSize, iconSize)
		activeIcons[playerName][i].timeLeft:SetFont(FONT, fontHeight, "OVERLAY")
		if i == 1 then
			activeIcons[playerName][i]:SetPoint("TOPLEFT", nameplate, ICONS_OFFSET_X, ICONS_OFFSET_Y)
		else
			activeIcons[playerName][i]:SetPoint("TOPLEFT", activeIcons[playerName][i - 1], iconSize + 2, 0)
		end
	end
end

local function setAndShowIcons(playerName, nameplate)
	setIconsProperties(playerName, nameplate)
	for i = 1, #activeIcons[playerName] do
		activeIcons[playerName][i]:SetParent(nameplate)
		activeIcons[playerName][i]:Show()
	end
end

local function hideIcons(nameplate)
	local playerName = getPlayerNameByNameplate(nameplate)
	if activeIcons[playerName] then 
		for i = 1, #activeIcons[playerName] do
			activeIcons[playerName][i]:Hide()
			activeIcons[playerName][i]:SetParent(nil) -- nameplate will popup attached to a new player and we dont want old player's icons to be displayed
		end
	end
end

local function showIcons(nameplate)
	local playerName = getPlayerNameByNameplate(nameplate)
	if nameplate.BigBuffs.playerName ~= playerName then
		if activeIcons[playerName] then
			nameplate.BigBuffs.playerName = playerName
			nameplate.BigBuffs.iconsNum = #activeIcons[playerName]
			setAndShowIcons(playerName, nameplate)
		end
	elseif nameplate.BigBuffs.iconsNum ~= #activeIcons[playerName] then
		nameplate.BigBuffs.iconsNum = #activeIcons[playerName]
		setAndShowIcons(playerName, nameplate)
	end
end

local function releaseUnusedIcons()
	for playerName, playerActiveIcons in pairs(activeIcons) do
		for i, icon in ipairs(playerActiveIcons) do
			if icon.endTime < GetTime() then
				if icon:IsVisible() then
					local nameplate = icon:GetParent()
					if nameplate and nameplate.BigBuffs then
						nameplate.BigBuffs.iconsNum = nameplate.BigBuffs.iconsNum - 1
					end
				end
				releaseFrame(icon)
				tremove(activeIcons[playerName], i)
				totalIcons = totalIcons - 1
				setAndShowIcons(playerName, nameplate)
			end
		end
	end
end	

local function syncVisibleNameplates()
	for i = 1, WorldFrame:GetNumChildren() do
		local nameplate = select(i, WorldFrame:GetChildren())
		local nameplateName = nameplate:GetName()
		if nameplateName and find(nameplateName, "NamePlate") then
			if nameplate:IsVisible() then
				local playerName = getPlayerNameByNameplate(nameplate)
				if activeIcons[playerName] then
					if nameplate.BigBuffs then
						if nameplate.BigBuffs.playerName ~= playerName then
							nameplate.BigBuffs.playerName = playerName
							nameplate.BigBuffs.iconsNum = #activeIcons[playerName]
							setAndShowIcons(playerName, nameplate)
						elseif nameplate.BigBuffs.iconsNum ~= #activeIcons[playerName] then
							nameplate.BigBuffs.iconsNum = #activeIcons[playerName]
							setAndShowIcons(playerName, nameplate)
						end
					else 
						nameplate.BigBuffs = {
							playerName = playerName,
							iconsNum = activeIcons[playerName]
						}
						setAndShowIcons(playerName, nameplate)
						nameplate:HookScript("OnHide", hideIcons)
						nameplate:HookScript("OnShow", showIcons)
					end
				end
			end
		end
	end
end

local function updateIconsText()
	for playerName, playerActiveIcons in pairs(activeIcons) do
		for i, icon in ipairs(playerActiveIcons) do
			local timeLeft = ceil(icon.endTime - GetTime())
			icon.timeLeft:SetFont(FONT, fontHeight, "OVERLAY")
			if timeLeft >= 60 then
				icon.timeLeft:SetText(ceil(timeLeft / 60).."m")
			elseif timeLeft < 60 and timeLeft >= 1 then
				icon.timeLeft:SetText(timeLeft)
			else
				icon.timeLeft:SetText(" ")
			end
		end
	end	
end

local function BigBuffs_OnUpdate(self, elapsed)
	if totalIcons ~= 0 then
		timeSinceLastUpdate = timeSinceLastUpdate + elapsed
		if timeSinceLastUpdate > updateInterval then
			timeSinceLastUpdate = 0
			releaseUnusedIcons()
			syncVisibleNameplates()
			updateIconsText()
		end
	end
end

local function addCooldownSpell(playerName, spellID, spellName)
	print("addSpell " .. playerName .. " " .. spellName) 
	if not activeIcons[playerName] then activeIcons[playerName] = {} end
	--[[if spellID == 14185 or spellID == 11958 then -- if preparation or cold snap
		releaseResetedIcons(playerName, spellID)
	end]]
	releaseOldIcon(playerName, spellName)
	local icon = makeIcon(spellID, spellName)
	tinsert(activeIcons[playerName], icon)
end

local function BigBuffs_OnCOMBAT_LOG_EVENT_UNFILTERED(self, event, ...)
	local _, event, _, _, playerName, sourceFlags, _, _, _, _, _, spellID, spellName = ...
	if BigBuffsCooldowns.cooldown[spellID] and band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
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

