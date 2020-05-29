local addon = {
	name = "QuietMounts",
	title = "Quiet Mounts",
	defaults =
	{
		defaultFootstepsVolume = 70,
		mountedFootstepsVolume = 45,
	},
}

local function OnMountedStateChanged(eventCode, isMounted)
	if isMounted then
		SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_FOOTSTEPS_VOLUME, addon.settings.mountedFootstepsVolume)
	else
		SetFlashWaitTime(10000)
		SetSetting(SETTING_TYPE_AUDIO, AUDIO_SETTING_FOOTSTEPS_VOLUME, addon.settings.defaultFootstepsVolume)
	end
end
EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_MOUNTED_STATE_CHANGED, OnMountedStateChanged)



function addon:SetupSettings()
	local LAM2 = LibAddonMenu2 or LibStub("LibAddonMenu-2.0")
	if not LAM2 then return end

	local panelData = {
		type = "panel",
		name = addon.title,
		displayName = addon.title,
		author = "Exceen",
		version = "1.0",
		registerForDefaults = true,
		-- website = "http://www.esoui.com/downloads/xyz.html",
	}
	LAM2:RegisterAddonPanel(addon.name, panelData)

	local optionsTable = {
	    {
	      type = "slider",
	      name = "Default Volume",
	      tooltip = "Footsteps Volume when Unmounted",
	      min = 0, max = 100, step = 1,
	      getFunc = function() return addon.settings.defaultFootstepsVolume end,
	      setFunc = function(value) addon.settings.defaultFootstepsVolume=value end,
	      width = "full",
	      default = self.defaults.defaultFootstepsVolume,
	    },
	    {
	      type = "slider",
	      name = "Mounted Volume",
	      tooltip = "Footsteps Volume when Mounted",
	      min = 0, max = 100, step = 1,
	      getFunc = function() return addon.settings.mountedFootstepsVolume end,
	      setFunc = function(value) addon.settings.mountedFootstepsVolume=value end,
	      width = "full",
	      default = self.defaults.mountedFootstepsVolume,
	    },
	}
	LAM2:RegisterOptionControls(addon.name, optionsTable)
end



local function OnAddonLoaded(event, name)
	if name ~= addon.name then return end
	EVENT_MANAGER:UnregisterForEvent(addon.name, EVENT_ADD_ON_LOADED)

	addon.settings = ZO_SavedVars:NewAccountWide("QuietMounts_Data", 1, nil, addon.defaults)

	addon:SetupSettings()
end
EVENT_MANAGER:RegisterForEvent(addon.name, EVENT_ADD_ON_LOADED, OnAddonLoaded)



QUIETER_MOUNTS = addon
