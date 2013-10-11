local addon, ns = ... 
local BigBuffsCooldowns = ns.BigBuffsCooldowns 

local gsub = string.gsub
local band = bit.band
local ceil = ceil
local print = print
local find = find

----Config----
local ICON_SIZE = 28
local ICONS_OFFSET_X = 0
local ICONS_OFFSET_Y = 30
local FONT = "tahoma.ttf"
---------------

local cooldownsToReset = {
	[11958] = {"Ice Block", "Frost Nova", "Cone of Cold"},
	[14185] = {"Sprint", "Vanish", "Cloak of Shadows", "Evasion", "Dismantle"},
	--[23989] = {"Deterrence", "Silencing Shot", "Scatter Shot", "Rapid Fire", "Kill Shot", "Lynx Rush", "Dire Beast", "Binding Shot", "Fervor", "Wyvern Sting", "Master's Call", "Bestial Wrath"}, (Rediness no longer existe as of Patch 5.4)
}

local purgeFrame = CreateFrame("Frame")
purgeFrame.timeSinceLastUpdate = 0
local nameplateFrame = CreateFrame("Frame")
nameplateFrame.timeSinceLastUpdate = 0

local activeIcons = {}
local spellStartTime = {}
local updateInterval = 0.33
local totalIcons = 0
local width, fontHeight

local interrupts = {"Mind Freeze", "Skull Bash", "Silencing Shot", "Counter Shot", "Counterspell", "Rebuke", "Silence", "Kick", "Wind Shear", "Pummel", "Disrupting Shout", "Shield Bash", "Spell Lock", "Strangulate", "Spear Hand Strike",}

local frame_cache = {}

local function acquireFrame(parent)
	local frame = tremove(frame_cache) or CreateFrame("Frame")
	frame:SetParent(parent)
	return frame
end

local function releaseFrame(frame)
	frame:Hide()
	frame:SetParent(nil)
	frame:ClearAllPoints()
	tinsert(frame_cache, frame)
end

local function addIcons(playerName, nameplate)
	print("addIcons")
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
		activeIcons[playerName][i].cooldown:SetFont(FONT, fontHeight, "OUTLINE")
		if i == 1 then
			activeIcons[playerName][i]:SetPoint("TOPLEFT", nameplate, ICONS_OFFSET_X, ICONS_OFFSET_Y)
		else
			activeIcons[playerName][i]:SetPoint("TOPLEFT", activeIcons[playerName][i - 1], iconSize + 2, 0)
		end
	end
end

local function hideIcons(playerName, f)
	print("hideIcons")
	f.Vial = 0
	for i = 1, #activeIcons[playerName] do
		activeIcons[playerName][i]:Hide()
		activeIcons[playerName][i]:SetParent(nil)
	end
	f:SetScript("OnHide", nil)--??
end

local function icon_OnUpdate(self)
	--print("icon_OnUpdate")
	local timeLeft = ceil(self.endtime - GetTime())
	if not fontHeight then 
		fontHeight = ceil(ICON_SIZE / 2)
	end
	self.cooldown:SetFont(FONT, fontHeight, "OUTLINE")
	if timeLeft >= 60 then
		self.cooldown:SetText(ceil(timeLeft / 60).."m")
	elseif timeLeft < 60 and timeLeft >= 1 then
		self.cooldown:SetText(timeLeft)
	else
		self.cooldown:SetText(" ")
		self:SetScript("OnUpdate", nil)
	end	
end

		
local function saveSpell(playerName, spellID, spellName)
	print("saveSpell") 
	if not activeIcons[playerName] then activeIcons[playerName] = {} end
	local _, _, texture = GetSpellInfo(spellID)
	local cd = BigBuffsCooldowns.cooldowns[spellID]
	local icon = CreateFrame("Frame", nil, UIParent)
	icon.texture = icon:CreateTexture(nil, "BORDER")
	icon.texture:SetAllPoints(icon)
	icon.texture:SetTexture(texture)
	icon.endtime = GetTime() + cd
	icon.cooldown = icon:CreateFontString(nil, "OVERLAY")
	icon.cooldown:SetTextColor(0.7, 1, 0)
	icon.cooldown:SetAllPoints(icon)
	icon.name = spellName
	for k, v in ipairs(interrupts) do
		if v == spellName then
			local iconBorder = icon:CreateTexture(nil, "OVERLAY")
			iconBorder:SetTexture("Interface\\AddOns\\Vial\\Border.tga")
			iconBorder:SetVertexColor(1, 0.35, 0)
			iconBorder:SetAllPoints(icon)
		end
	end
	if spellID == 14185 or spellID == 11958 then -- if preparation or cold snap
		for k, v in ipairs(cooldownsToReset[spellID]) do		
			for i = 1, #activeIcons[playerName] do
				if activeIcons[playerName][i] then
					if activeIcons[playerName][i].name == v then
						if activeIcons[playerName][i]:IsVisible() then
							local f = activeIcons[playerName][i]:GetParent()
							if f.Vial and f.Vial ~= 0 then
								f.Vial = 0
							end
						end
						activeIcons[playerName][i]:Hide()
						activeIcons[playerName][i]:SetParent(nil)
						tremove(activeIcons[playerName], i)
						totalIcons = totalIcons - 1
					end
				end
			end
		end
	else
		for i = 1, #activeIcons[playerName] do
			if activeIcons[playerName][i] then
				if activeIcons[playerName][i].name == spellName then
					if activeIcons[playerName][i]:IsVisible() then
						local f = activeIcons[playerName][i]:GetParent()
						if f.Vial then
							f.Vial = 0
						end
					end
					activeIcons[playerName][i]:Hide()
					activeIcons[playerName][i]:SetParent(nil)
					tremove(activeIcons[playerName], i)
					totalIcons = totalIcons - 1
				end
			end
		end
	end
	tinsert(activeIcons[playerName], icon)
	--[[icon:SetScript("OnUpdate", function()
		icon_OnUpdate(icon)
	end)]]
	icon:SetScript("OnUpdate", icon_OnUpdate)
end
		

local function purgeFrame_OnUpdate(self, elapsed)
	--print("purgeFrame_OnUpdate")
	self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed
	if self.timeSinceLastUpdate >= updateInterval then
		self.timeSinceLastUpdate = 0
		if totalIcons == 0 then
			nameplateFrame:SetScript("OnUpdate", nil)
			purgeFrame:SetScript("OnUpdate", nil)
		end
		for playerName, playerActiveIcons in pairs(activeIcons) do
			for i, icon in ipairs(playerActiveIcons) do
				if icon.endtime < GetTime() then
					if icon:IsVisible() then
						local f = icon:GetParent()-- isnt it UIParent?
						if f.Vial then
							f.Vial = 0
						end
					end
					icon:Hide()
					icon:SetParent(nil)
					tremove(activeIcons[playerName], i)
					totalIcons = totalIcons - 1
				end
			end
		end
	end
end
		


local function nameplateFrame_OnUpdate(self, elapsed)
	self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed
	if self.timeSinceLastUpdate > updateInterval then
		print("nameplateFrame_OnUpdate")
		self.timeSinceLastUpdate = 0
		local worldFrameChildren = WorldFrame:GetChildren()
		for i = 1, #worldFrameChildren do
			local nameplate = worldFrameChildren[i]
			local childName = nameplate:GetName()
			if childName then
							
				if childName:find("NamePlate") then
					if not nameplate.Vial then nameplate.Vial = 0 end
					if nameplate:IsVisible() then
						local _
						_, nameplate.nameFrame = nameplate:GetChildren()-- second nameplate?
						local eman = nameplate.nameFrame:GetRegions()
						local playerName = gsub(eman:GetText(), '%s%(%*%)','')
						if activeIcons[playerName] then
							if nameplate.Vial ~= activeIcons[playerName] then
								nameplate.Vial = #activeIcons[playerName]
								for i = 1, #activeIcons[playerName] do
									activeIcons[playerName][i]:SetParent(nameplate)
									activeIcons[playerName][i]:Show()
								end
								addIcons(playerName, nameplate)
								nameplate:HookScript("OnHide", function()
									hideIcons(playerName, nameplate)
								end)
							end
						end
					end
				end
			end
		end
	end
end

local function BigBuffs_OnCOMBAT_LOG_EVENT_UNFILTERED(self, event, ...)
	local _, event, _, _, playerName, sourceFlags, _, _, _, _, _, spellID, spellName = ...
	if BigBuffsCooldowns.cooldowns[spellID] and band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
		playerName = strmatch(playerName, "[%P]+")
		if event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED" or event == "SPELL_MISSED" or event == "SPELL_SUMMON" then
			if not spellStartTime[playerName] then spellStartTime[playerName] = {} end
			if not spellStartTime[playerName][spellName] or GetTime() >= spellStartTime[playerName][spellName] + 1 then
				totalIcons = totalIcons + 1
				saveSpell(playerName, spellID, spellName)
				spellStartTime[playerName][spellName] = GetTime()
			end
			if not nameplateFrame:GetScript("OnUpdate") then
				nameplateFrame:SetScript("OnUpdate", nameplateFrame_OnUpdate)
				purgeFrame:SetScript("OnUpdate", purgeFrame_OnUpdate)
			end
		end
	end
end

local function BigBuffs_OnPLAYER_ENTERING_WORLD(self, event, ...) 
	activeIcons = {}
	spellStartTime = {}
	totalIcons = 0
end

local BigBuffs = CreateFrame("Frame")
BigBuffs:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
BigBuffs:RegisterEvent("PLAYER_ENTERING_WORLD")
BigBuffs:SetScript("OnEvent", function(self, event, ...) 
	if event == "COMBAT_LOG_EVENT_UNFILTERED" then
		BigBuffs_OnCOMBAT_LOG_EVENT_UNFILTERED(self, event, ...)
	elseif event == "PLAYER_ENTERING_WORLD" then
		BigBuffs_OnPLAYER_ENTERING_WORLD(self, event, ...)
	end
end)
