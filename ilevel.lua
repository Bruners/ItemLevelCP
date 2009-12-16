
local SLOTIDS, FONTSIZE = {}, 12
local R,G,B = 1,1,1
for _,slot in pairs({"Head", "Neck", "Shoulder", "Back", "Chest", "Wrist", "Hands", "Waist", "Legs", "Feet", "Finger0", "Finger1", "Trinket0", "Trinket1", "MainHand", "SecondaryHand", "Ranged"}) do SLOTIDS[slot] = GetInventorySlotInfo(slot .. "Slot") end
local frame = CreateFrame("Frame", nil, CharacterFrame)

local fontstrings = setmetatable({}, {
	__index = function(t,i)
		local gslot = _G["Character"..i.."Slot"]
		assert(gslot, "Character"..i.."Slot does not exist")
		
		local fstr = gslot:CreateFontString(nil, "OVERLAY")
		local font, _, flags = NumberFontNormal:GetFont()
		fstr:SetFont(font, FONTSIZE, flags)
		fstr:SetPoint("TOP", gslot, "TOP", 0, -5)
		t[i] = fstr
		return fstr
	end,
})

function frame:OnEvent(event, arg1)
	if event == "ADDON_LOADED" and arg1:lower() ~= "itemlevelcp" then
		for i,fstr in pairs(fontstrings) do
			-- Re-apply the font, so that we catch any changes to NumberFontNormal by addons like ClearFont
			local font, _, flags = NumberFontNormal:GetFont()
			fstr:SetFont(font, FONTSIZE, flags)
		end
		return
	end

	for slot,id in pairs(SLOTIDS) do
		local link = GetInventoryItemLink("player", id)
		
		if link then
			local _,_,_,ilevel,_,_,_,_,_,_ = GetItemInfo(link)
			if ilevel then
				local str = fontstrings[slot]
				str:SetTextColor(R,G,B)
				str:SetText(string.format("%s", ilevel))
			end
		else
			local str = rawget(fontstrings, slot)
			if str then str:SetText(nil) end
		end
	end
end


frame:SetScript("OnEvent", frame.OnEvent)
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("UNIT_INVENTORY_CHANGED")
