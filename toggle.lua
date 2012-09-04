local ON = 'Click2Go: |cff00ff00ON|r'
local OFF = 'Click2Go: |cffff0000OFF|r'

local dataobj = LibStub('LibDataBroker-1.1'):NewDataObject('Click2GoToggle', {
	type = 'data sourse',
	text = 'Click2Go: ...',
	icon = 'Interface\\Icons\\inv_staff_88',
})

dataobj.OnClick = function()
	if GetCVar('autointeract') == '1' then
		SetCVar('autointeract', '0')
		dataobj.text = OFF
	else
		SetCVar('autointeract', '1')
		dataobj.text = ON
	end
end

local addon = CreateFrame'frame'
addon:SetScript('OnEvent', function(self,event) self[event]() end)

local c2g = false

function addon:PLAYER_LOGIN()
    addon.PLAYER_LOGIN = nil
    if( GetCVar'autointeract' == '1' ) then
        c2g = true
    end
end

-- in combat, turn off
function addon:PLAYER_REGEN_DISABLED()
    c2g = false
    if( GetCVar'autointeract' == '1' ) then
        c2g = true
        SetCVar('autointeract', '0')
        dataobj.text = OFF
    end
end

-- out of combat, restore
function addon:PLAYER_REGEN_ENABLED()
    if( c2g ) then
        SetCVar('autointeract', '1')
        dataobj.text = ON
    end
end

addon:RegisterEvent'PLAYER_LOGIN'
addon:RegisterEvent'PLAYER_REGEN_DISABLED'
addon:RegisterEvent'PLAYER_REGEN_ENABLED'
