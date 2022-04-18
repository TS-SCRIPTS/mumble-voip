--Redesigned By TS#3462
AddEventHandler("onResourceStart", function(resName) 
	if GetCurrentResourceName() ~= resName then
		return
	end

	SetConvarReplicated("voice_useNativeAudio", mumbleConfig.useNativeAudio and "true" or "false")
	SetConvarReplicated("voice_use2dAudio", mumbleConfig.use3dAudio and "false" or "true")
	SetConvarReplicated("voice_use3dAudio", mumbleConfig.use3dAudio and "true" or "false")	
	SetConvarReplicated("voice_useSendingRangeOnly", mumbleConfig.useSendingRangeOnly and "true" or "false")	

	local maxChannel = GetMaxChunkId() << 1 

	for i = 1, maxChannel do
		MumbleCreateChannel(i)
	end

	DebugMsg("Initialised Script, " .. maxChannel .. " channels created")
end)

RegisterNetEvent("mumble:Initialise")
AddEventHandler("mumble:Initialise", function()
	DebugMsg("Initialised player: " .. source)

	if not voiceData[source] then
		voiceData[source] = {
			mode = 2,
			radio = 0,
			radioActive = false,
			call = 0,
			callSpeaker = false,
			speakerTargets = {},
			radioName = GetRandomPhoneticLetter() .. "-" .. source,
		}
	end

	TriggerClientEvent("mumble:SyncVoiceData", -1, voiceData, radioData, callData)
end)

RegisterNetEvent("mumble:SetVoiceData")
AddEventHandler("mumble:SetVoiceData", function(key, value, target)
	if not voiceData[source] then
		voiceData[source] = {
			mode = 2,
			radio = 0,
			radioActive = false,
			call = 0,
			callSpeaker = false,
			speakerTargets = {},
			radioName = GetRandomPhoneticLetter() .. "-" .. source,
		}
	end

	local radioChannel = voiceData[source]["radio"]
	local callChannel = voiceData[source]["call"]
	local radioActive = voiceData[source]["radioActive"]

	if key == "radio" and radioChannel ~= value then 
		if radioChannel > 0 then 
			if radioData[radioChannel] then  
				if radioData[radioChannel][source] then
					DebugMsg("Player " .. source .. " was removed from radio channel " .. radioChannel)
					radioData[radioChannel][source] = nil
				end
			end
		end

		if value > 0 then
			if not radioData[value] then 
				DebugMsg("Player " .. source .. " is creating channel: " .. value)
				radioData[value] = {}
			end
			
			DebugMsg("Player " .. source .. " was added to channel: " .. value)
			radioData[value][source] = true 
		end
	elseif key == "call" and callChannel ~= value then
		if callChannel > 0 then 
			if callData[callChannel] then  
				if callData[callChannel][source] then
					DebugMsg("Player " .. source .. " was removed from call channel " .. callChannel)
					callData[callChannel][source] = nil
				end
			end
		end

		if value > 0 then
			if not callData[value] then 
				DebugMsg("Player " .. source .. " is creating call: " .. value)
				callData[value] = {}
			end
			
			DebugMsg("Player " .. source .. " was added to call: " .. value)
			callData[value][source] = true 
		end
	end

	voiceData[source][key] = value

	DebugMsg("Player " .. source .. " changed " .. key .. " to: " .. tostring(value)) --Redesigned By TS#3462
	
	if key == "speakerTargets" then
		TriggerClientEvent("mumble:SetVoiceData", -1, target, key, value)
	else
		TriggerClientEvent("mumble:SetVoiceData", -1, source, key, value)
	end
end)

RegisterCommand("mumbleRadioChannels", function(src, args, raw)
	for id, players in pairs(radioData) do
		for player, _ in pairs(players) do
			RconPrint("\x1b[32m[" .. resourceName .. "]\x1b[0m Channel " .. id .. "-> id: " .. player .. ", name: " .. GetPlayerName(player) .. "\n")
		end
	end
end, true)

RegisterCommand("mumbleCallChannels", function(src, args, raw)
	for id, players in pairs(callData) do
		for player, _ in pairs(players) do
			RconPrint("\x1b[32m[" .. resourceName .. "]\x1b[0m Call " .. id .. "-> id: " .. player .. ", name: " .. GetPlayerName(player) .. "\n")
		end
	end
end, true)

AddEventHandler("playerDropped", function()
	if voiceData[source] then
		if voiceData[source].radio > 0 then
			if radioData[voiceData[source].radio] ~= nil then
				radioData[voiceData[source].radio][source] = nil
			end
		end

		if voiceData[source].call > 0 then
			if callData[voiceData[source].call] ~= nil then
				callData[voiceData[source].call][source] = nil
			end
		end

		voiceData[source] = nil
		
		TriggerClientEvent("mumble:RemoveVoiceData", -1, source)
	end
end)

function SetPlayerRadioName(serverId, name)
	if voiceData[serverId] then
		local value = name or (GetRandomPhoneticLetter() .. "-" .. serverId)
		voiceData[serverId].radioName = value
		TriggerClientEvent("mumble:SetVoiceData", -1, serverId, "radioName", value)
	end
end

exports("SetPlayerRadioName", SetPlayerRadioName)
--Redesigned By TS#3462
