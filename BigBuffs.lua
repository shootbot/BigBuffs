local addon, ns = ... 
local BigBuffsCooldowns = ns.BigBuffsCooldowns 

local gsub = string.gsub
local band = bit.band

----Config----
local iconSize = 28
local iconsOffsetX = 0
local iconsOffsetY = 30
local defaultFont = "Interface\\AddOns\\Vial\\tahoma.ttf"
---------------

local cooldownsToReset = {
	[11958] = {"Ice Block", "Frost Nova", "Cone of Cold"},
	[14185] = {"Sprint", "Vanish", "Cloak of Shadows", "Evasion", "Dismantle"},
	--[23989] = {"Deterrence", "Silencing Shot", "Scatter Shot", "Rapid Fire", "Kill Shot", "Lynx Rush", "Dire Beast", "Binding Shot", "Fervor", "Wyvern Sting", "Master's Call", "Bestial Wrath"}, (Rediness no longer existe as of Patch 5.4)
}

local db = {}
local spellStartTime = {}
local purgeFrame = CreateFrame("Frame")
local nameplateFrame = CreateFrame("Frame")
nameplateFrame.timeSinceLastUpdate = 0
nameplateFrame.updateInterval = 0.33
local totalIcons = 0
local width, Sfont, size

local interrupts = {"Mind Freeze", "Skull Bash", "Silencing Shot", "Counter Shot", "Counterspell", "Rebuke", "Silence", "Kick", "Wind Shear", "Pummel", "Disrupting Shout", "Shield Bash", "Spell Lock", "Strangulate", "Spear Hand Strike",}


local BigBuffs_OnEvent(self, event, ...) then
	if event == "COMBAT_LOG_EVENT_UNFILTERED"
		local _, event, _, _, sourceName, sourceFlags, _, _, _, _, _, spellID, spellName = ...
		if BigBuffsCooldowns.cooldowns[spellID] and band(sourceFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
			sourceName = strmatch(sourceName, "[%P]+")
			if event == "SPELL_CAST_SUCCESS" or event == "SPELL_AURA_APPLIED" or event == "SPELL_MISSED" or event == "SPELL_SUMMON" then
				if not spellStartTime[sourceName] then spellStartTime[sourceName] = {} end
				if not spellStartTime[sourceName][spellName] or GetTime() >= spellStartTime[sourceName][spellName] + 1 then
					totalIcons = totalIcons + 1
					sourcetable(sourceName, spellID, spellName)
					spellStartTime[sourceName][spellName] = GetTime()
				end
				if not nameplateFrame:GetScript("OnUpdate") then
					nameplateFrame:SetScript("OnUpdate", nameplateFrame_OnUpdate)
					purgeFrame:SetScript("OnUpdate", purgeFrame_OnUpdate)
				end
			end
		end
	else if event == "PLAYER_ENTERING_WORLD" then
		db = {}
		spellStartTime = {}
		totalIcons = 0
	end
end

local BigBuffs = CreateFrame("Frame")
BigBuffs:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
BigBuffs:RegisterEvent("PLAYER_ENTERING_WORLD")
BigBuffs:SetScript("OnEvent", BigBuffs_OnEvent)

local addicons = function(name, f)
	local num = #db[name]
	if not width then width = f:GetWidth() end
	if num * iconsize + (num * 2 - 2) > width then
		size = (width - (num * 2 - 2)) / num
		Sfont = ceil(size - size / 2)
	else 
		size = iconsize
		Sfont = ceil(size - size / 2)
	end
	for i = 1, #db[name] do
		db[name][i]:ClearAllPoints()
		db[name][i]:SetWidth(size)
		db[name][i]:SetHeight(size)
		db[name][i].cooldown:SedefaultFont(defaultFont ,Sfont, "OUTLINE")
		if i == 1 then
			db[name][i]:SetPoint("TOPLEFT", f, iconsOffsetX, iconsOffsetY)
		else
			db[name][i]:SetPoint("TOPLEFT", db[name][i-1], size + 2, 0)
		end
	end
end

local hideicons = function(name, f)
	f.Vial = 0
	for i = 1, #db[name] do
		db[name][i]:Hide()
		db[name][i]:SetParent(nil)
	end
	f:SetScript("OnHide", nil)
end

local icontimer = function(icon)
	local itimer = ceil(icon.endtime - GetTime())
	if not Sfont then Sfont = ceil(iconsize - iconsize / 2) end
	if itimer >= 60 then
		icon.cooldown:SedefaultFont(defaultFont ,Sfont, "OUTLINE")
		icon.cooldown:SetText(ceil(itimer/60).."m")
	elseif itimer < 60 and itimer >= 1 then
		icon.cooldown:SedefaultFont(defaultFont ,Sfont, "OUTLINE")
		icon.cooldown:SetText(itimer)
	else
		icon.cooldown:SedefaultFont(defaultFont ,Sfont, "OUTLINE")
		icon.cooldown:SetText(" ")
		icon:SetScript("OnUpdate", nil)
	end	
end

		
local sourcetable = function(sourceName, spellID, spellName)
	if not db[sourceName] then db[sourceName] = {} end
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
	if spellID == 14185 or spellID == 11958 then --if preparation or cold snap
		for k, v in ipairs(cooldownsToReset[spellID]) do		
			for i = 1, #db[sourceName] do
				if db[sourceName][i] then
					if db[sourceName][i].name == v then
						if db[sourceName][i]:IsVisible() then
							local f = db[sourceName][i]:GetParent()
							if f.Vial and f.Vial ~= 0 then
								f.Vial = 0
							end
						end
						db[sourceName][i]:Hide()
						db[sourceName][i]:SetParent(nil)
						tremove(db[sourceName], i)
						totalIcons = totalIcons - 1
					end
				end
			end
		end
	else
		for i = 1, #db[sourceName] do
			if db[sourceName][i] then
				if db[sourceName][i].name == spellName then
					if db[sourceName][i]:IsVisible() then
						local f = db[sourceName][i]:GetParent()
						if f.Vial then
							f.Vial = 0
						end
					end
					db[sourceName][i]:Hide()
					db[sourceName][i]:SetParent(nil)
					tremove(db[sourceName], i)
					totalIcons = totalIcons - 1
				end
			end
		end
	end
	tinsert(db[sourceName], icon)
	icon:SetScript("OnUpdate", function()
		icontimer(icon)
	end)
end
		
local onpurge = 0
local purgeFrame_OnUpdate = function(self, elapsed)
	onpurge = onpurge + elapsed
	if onpurge >= .33 then
		onpurge = 0
		if totalIcons == 0 then
			nameplateFrame:SetScript("OnUpdate", nil)
			purgeFrame:SetScript("OnUpdate", nil)
		end
		for k, v in pairs(db) do
			for i, c in ipairs(v) do
				if c.endtime < GetTime() then
					if c:IsVisible() then
						local f = c:GetParent()
						if f.Vial then
							f.Vial = 0
						end
					end
					c:Hide()
					c:SetParent(nil)
					tremove(db[k], i)
					totalIcons = totalIcons - 1
				end
			end
		end
	end
end
		


local nameplateFrame_OnUpdate = function(self, elapsed)
	self.timeSinceLastUpdate = self.timeSinceLastUpdate + elapsed
	if self.timeSinceLastUpdate > self.updateInterval then
		self.timeSinceLastUpdate = 0
		local worldFrameChildren = WorldFrame:GetChildren()
		for i = 1, #worldFrameChildren do
			local child = worldFrameChildren[i]
			local childName = child:GetName()
			if not childName then
				continue
			end				
			if childName:find("NamePlate") then
				if not child.Vial then child.Vial = 0 end
				if child:IsVisible() then
					local _
					_, child.nameFrame = child:GetChildren()
					local eman = child.nameFrame:GetRegions()
					local name = gsub(eman:GetText(), '%s%(%*%)','')
					if db[name] ~= nil then
						if child.Vial ~= db[name] then
							child.Vial = #db[name]
							for i = 1, #db[name] do
								db[name][i]:SetParent(f)
								db[name][i]:Show()
							end
							addicons(name, f)
							child:HookScript("OnHide", function()
								hideicons(name, f)
							end)
						end
					end
				end
			end
		end
	end
end
	