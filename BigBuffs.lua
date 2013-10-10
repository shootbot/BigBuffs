local addon, ns = ... 
local VialCds = ns.VialCds 
local VialCcs = ns.VialCcs
local VialSpec = ns.VialSpec
local gsub = string.gsub
local EventFrame = CreateFrame("Frame")
EventFrame:RegisterEvent("PLAYER_LOGIN")
EventFrame:SetScript("OnEvent", function(self,event,...) 
	if not mySavedVar then  --  I know it doesn't exist. so set it's default
		mySavedVar = {}
		mySavedVar[UnitName("Player")] = 1
		ChatFrame1:AddMessage('|cff00C78CVialCooldowns 1.5.3 for patch 5.4 has been successfully loaded, '.. UnitName("Player").."!\n Because 1.5.2 broke ~ Ezzpify!|r")
	end
end)

----Config----
local iconsize = 28
local xoff = 0
local yoff = 30
local tfont = "Interface\\AddOns\\Vial\\tahoma.ttf"
---------------

local VialReset = {
	[11958] = {"Ice Block", "Frost Nova", "Cone of Cold"},
	[14185] = {"Sprint", "Vanish", "Cloak of Shadows", "Evasion", "Dismantle"},
	--[23989] = {"Deterrence", "Silencing Shot", "Scatter Shot", "Rapid Fire", "Kill Shot", "Lynx Rush", "Dire Beast", "Binding Shot", "Fervor", "Wyvern Sting", "Master's Call", "Bestial Wrath"}, (Rediness no longer existe as of Patch 5.4)
}

local db = {}
local eventcheck = {}
local purgeframe = CreateFrame("frame")
local plateframe = CreateFrame("frame")
local TrinketTex = "Interface\Icons\INV_Jewelry_TrinketPVP_01"
local count = 0
local width, Sfont, size

local VialInterrupts = {"Mind Freeze", "Skull Bash", "Silencing Shot", "Counter Shot", "Counterspell", "Rebuke", "Silence", "Kick", "Wind Shear", "Pummel", "Disrupting Shout", "Shield Bash", "Spell Lock", "Strangulate", "Spear Hand Strike",}

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
		db[name][i].cooldown:SetFont(tfont ,Sfont, "OUTLINE")
		if i == 1 then
			db[name][i]:SetPoint("TOPLEFT", f, xoff, yoff)
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
		icon.cooldown:SetFont(tfont ,Sfont, "OUTLINE")
		icon.cooldown:SetText(ceil(itimer/60).."m")
	elseif itimer < 60 and itimer >= 1 then
		icon.cooldown:SetFont(tfont ,Sfont, "OUTLINE")
		icon.cooldown:SetText(itimer)
	else
		icon.cooldown:SetFont(tfont ,Sfont, "OUTLINE")
		icon.cooldown:SetText(" ")
		icon:SetScript("OnUpdate", nil)
	end	
end

		
local sourcetable = function(Name, spellID, spellName)
	if not db[Name] then db[Name] = {} end
	local _, _, texture = GetSpellInfo(spellID)
	local duration = VialCds.VialCds[spellID]
	local icon = CreateFrame("frame", nil, UIParent)
	icon.texture = icon:CreateTexture(nil, "BORDER")
	icon.texture:SetAllPoints(icon)
	icon.texture:SetTexture(texture)
	icon.endtime = GetTime() + duration
	icon.cooldown = icon:CreateFontString(nil, "OVERLAY")
	icon.cooldown:SetTextColor(0.7, 1, 0)
	icon.cooldown:SetAllPoints(icon)
	icon.name = spellName
	for k, v in ipairs(VialInterrupts) do
		if v == spellName then
			local iconBorder = icon:CreateTexture(nil, "OVERLAY")
			iconBorder:SetTexture("Interface\\AddOns\\Vial\\Border.tga")
			iconBorder:SetVertexColor(1, 0.35, 0)
			iconBorder:SetAllPoints(icon)
		end
	end
	if spellID == 14185 or spellID == 23989 or spellID == 11958 then
		for k, v in ipairs(VialReset[spellID]) do			
			for i = 1, #db[Name] do
				if db[Name][i] then
					if db[Name][i].name == v then
						if db[Name][i]:IsVisible() then
							local f = db[Name][i]:GetParent()
							if f.Vial and f.Vial ~= 0 then
								f.Vial = 0
							end
						end
						db[Name][i]:Hide()
						db[Name][i]:SetParent(nil)
						tremove(db[Name], i)
						count = count - 1
					end
				end
			end
		end
	else
		for i = 1, #db[Name] do
			if db[Name][i] then
				if db[Name][i].name == spellName then
					if db[Name][i]:IsVisible() then
						local f = db[Name][i]:GetParent()
						if f.Vial then
							f.Vial = 0
						end
					end
					db[Name][i]:Hide()
					db[Name][i]:SetParent(nil)
					tremove(db[Name], i)
					count = count - 1
				end
			end
		end
	end
	tinsert(db[Name], icon)
	icon:SetScript("OnUpdate", function()
		icontimer(icon)
	end)
end
		
local onpurge = 0
local uppurge = function(self, elapsed)
	onpurge = onpurge + elapsed
	if onpurge >= .33 then
		onpurge = 0
		if count == 0 then
			plateframe:SetScript("OnUpdate", nil)
			purgeframe:SetScript("OnUpdate", nil)
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
					count = count - 1
				end
			end
		end
	end
end
		
local onplate = 0
local getplate = function(frame, elapsed)
	onplate = onplate + elapsed
	if onplate > .33 then
		onplate = 0
		local num = WorldFrame:GetNumChildren()
		for i = 1, num do
			local f = select(i, WorldFrame:GetChildren())
			if f:GetName() then
				local a = f:GetName()
				if a:find("NamePlate") then
					if not f.Vial then f.Vial = 0 end
					if f:IsVisible() then
						local _
						_, f.nameFrame = f:GetChildren()
						local eman = f.nameFrame:GetRegions()
						local name = gsub(eman:GetText(), '%s%(%*%)','')
						if db[name] ~= nil then
							if f.Vial ~= db[name] then
								f.Vial = #db[name]
								for i = 1, #db[name] do
									db[name][i]:SetParent(f)
									db[name][i]:Show()
								end
								addicons(name, f)
								f:HookScript("OnHide", function()
									hideicons(name, f)
								end)
							end
						end
					end
				end
			end
		end
	end
end

local VialEvent = {}
function VialEvent.COMBAT_LOG_EVENT_UNFILTERED(event, ...)
	local _, eventType, _, _, sourceName, srcFlags, _, _, _, _, _, spellID, spellName = ...
	if VialCds.VialCds[spellID] and bit.band(srcFlags, COMBATLOG_OBJECT_REACTION_HOSTILE) ~= 0 then
		local Name = strmatch(sourceName, "[%P]+")
		if eventType == "SPELL_CAST_SUCCESS" or eventType == "SPELL_AURA_APPLIED" or eventType == "SPELL_MISSED" or eventType == "SPELL_SUMMON" then
			if not eventcheck[Name] then eventcheck[Name] = {} end
			if not eventcheck[Name][spellName] or GetTime() >= eventcheck[Name][spellName] + 1 then
				count = count + 1
				sourcetable(Name, spellID, spellName)
				eventcheck[Name][spellName] = GetTime()
			end
			if not plateframe:GetScript("OnUpdate") then
				plateframe:SetScript("OnUpdate", getplate)
				purgeframe:SetScript("OnUpdate", uppurge)
			end
		end
	end
end

function VialEvent.PLAYER_ENTERING_WORLD(event, ...)
	wipe(db)
	wipe(eventcheck)
	count = 0
end

local Vial = CreateFrame("frame")
Vial:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")
Vial:RegisterEvent("PLAYER_ENTERING_WORLD")
Vial:SetScript("OnEvent", function(frame, event, ...)
	VialEvent[event](VialEvent, ...)
end)
	