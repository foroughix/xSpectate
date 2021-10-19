-- menu
RegisterServerEvent('xSpectateMenu')
AddEventHandler('xSpectateMenu', function()
	if IsPlayerAceAllowed(source,'xspectate.main') then
		local nplayers = 0
		local player_ids = {}
		local player_names = {}
		for _, playerId in ipairs(GetPlayers()) do
			nplayers = nplayers + 1
			player_ids[nplayers] = playerId
			player_names[nplayers] = GetPlayerName(playerId)
		end
		TriggerClientEvent('xSpectate:menu', source, nplayers, player_ids, player_names)
	end
end)
-- spectate
RegisterServerEvent('xSpectate')
AddEventHandler('xSpectate', function(playerId)
	if IsPlayerAceAllowed(source,'xspectate.main') and playerId then
		if GetPlayerName(playerId) then
			local coords = GetEntityCoords(GetPlayerPed(playerId))
			if coords.x ~= 0 and coords.y ~= 0 and coords.z ~= 0 then
				TriggerClientEvent('xSpectate:main', source, coords, playerId)
			end
		end
	end
end)
-- resource name
Citizen.CreateThread(function()
	while true do
		if GetCurrentResourceName() ~= 'xSpectate' then
			print('Change resource ' .. GetCurrentResourceName() .. ' name to xSpectate')
		end
		Citizen.Wait(60000)
	end
end)