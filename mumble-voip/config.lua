--Redesigned By TS#3462
voiceData = {}
radioData = {}
callData = {}
mumbleConfig = {
	debug = false, 
	voiceModes = {
		{2.5, "Susurrar"}, 
		{7.0, "Normal"}, 
		{15.0, "Gritar"}, 
	},
	speakerRange = 1.5, 
	callSpeakerEnabled = true, 
	radioEnabled = true, 
	micClicks = true, 
	micClickOn = true, 
	micClickOff = true, 
	micClickVolume = 0.1, 
	radioClickMaxChannel = 9, 
	controls = { 
		proximity = {
			key = 243, 
		}, 
		radio = {
			pressed = false, 
			key = 19, 
		}, 
		speaker = {
			key = 20, 
			secondary = 21, 
		} 
	},
	radioChannelNames = { 
		[1] = "PRIVATE.",
	},
	callChannelNames = { 

	},
	use3dAudio = true, 
	useSendingRangeOnly = true, 
	useNativeAudio = false, 
	useExternalServer = false, 
	externalAddress = "127.0.0.1",
	externalPort = 30120,
	use2dAudioInVehicles = true, 
	showRadioList = false, 
}
resourceName = GetCurrentResourceName()
phoneticAlphabet = {
	"Alpha",
	"Bravo",
	"Charlie",
	"Delta",
	"Echo",
	"Foxtrot",
	"Golf",
	"Hotel",
	"India",
	"Juliet",
	"Kilo",
	"Lima",
	"Mike",
	"November",
	"Oscar",
	"Papa",
	"Quebec",
	"Romeo",
	"Sierra",
	"Tango",
	"Uniform",
	"Victor",
	"Whisky",
	"XRay",
	"Yankee",
	"Zulu",
}

if IsDuplicityVersion() then
	function DebugMsg(msg)
		if mumbleConfig.debug then
			print("\x1b[32m[" .. resourceName .. "]\x1b[0m ".. msg)
		end
	end
else
	function DebugMsg(msg)
		if mumbleConfig.debug then
			print("[" .. resourceName .. "] ".. msg)
		end
	end

	function SetMumbleProperty(key, value)
		if mumbleConfig[key] ~= nil and mumbleConfig[key] ~= "controls" and mumbleConfig[key] ~= "radioChannelNames" then
			mumbleConfig[key] = value

			if key == "callSpeakerEnabled" then
				SendNUIMessage({ speakerOption = mumbleConfig.callSpeakerEnabled })
			end
		end
	end

	function SetRadioChannelName(channel, name)
		local channel = tonumber(channel)

		if channel ~= nil and name ~= nil and name ~= "" then
			if not mumbleConfig.radioChannelNames[channel] then
				mumbleConfig.radioChannelNames[channel] = tostring(name)
			end
		end
	end

	function SetCallChannelName(channel, name)
		local channel = tonumber(channel)

		if channel ~= nil and name ~= nil and name ~= "" then
			if not mumbleConfig.callChannelNames[channel] then
				mumbleConfig.callChannelNames[channel] = tostring(name) --Redesigned By TS#3462
			end
		end
	end

	exports("SetMumbleProperty", SetMumbleProperty)
	exports("SetTokoProperty", SetMumbleProperty)
	exports("SetRadioChannelName", SetRadioChannelName)
	exports("SetCallChannelName", SetCallChannelName)
end

function GetRandomPhoneticLetter()
	math.randomseed(GetGameTimer())

	return phoneticAlphabet[math.random(1, #phoneticAlphabet)]
end

function GetPlayersInRadioChannel(channel)
	local channel = tonumber(channel)
	local players = false

	if channel ~= nil then
		if radioData[channel] ~= nil then
			players = radioData[channel]
		end
	end

	return players
end

function GetPlayersInRadioChannels(...)
	local channels = { ... }
	local players = {}

	for i = 1, #channels do
		local channel = tonumber(channels[i])

		if channel ~= nil then
			if radioData[channel] ~= nil then
				players[#players + 1] = radioData[channel]
			end
		end
	end

	return players
end

function GetPlayersInAllRadioChannels()
	return radioData
end

function GetPlayersInPlayerRadioChannel(serverId)
	local players = false

	if serverId ~= nil then
		if voiceData[serverId] ~= nil then
			local channel = voiceData[serverId].radio
			if channel > 0 then
				if radioData[channel] ~= nil then
					players = radioData[channel]
				end
			end
		end
	end

	return players
end

function GetPlayerRadioChannel(serverId)
	if serverId ~= nil then
		if voiceData[serverId] ~= nil then
			return voiceData[serverId].radio
		end
	end
end

function GetPlayerCallChannel(serverId)
	if serverId ~= nil then
		if voiceData[serverId] ~= nil then
			return voiceData[serverId].call
		end
	end
end

exports("GetPlayersInRadioChannel", GetPlayersInRadioChannel)
exports("GetPlayersInRadioChannels", GetPlayersInRadioChannels)
exports("GetPlayersInAllRadioChannels", GetPlayersInAllRadioChannels)
exports("GetPlayersInPlayerRadioChannel", GetPlayersInPlayerRadioChannel)
exports("GetPlayerRadioChannel", GetPlayerRadioChannel)
exports("GetPlayerCallChannel", GetPlayerCallChannel)

--Redesigned By TS#3462