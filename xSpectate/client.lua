-- base
local open_menu_key = 288
-- menu
local nplayers = 0
local player_ids = {}
local player_names = {}
Citizen.CreateThread(function()
	CreateWarMenu('xspectate', 'xSpectate', 'Spectate Menu', {0.7, 0.2}, 1.0)
	while true do 
		Citizen.Wait(0)
		if IsControlJustReleased(0, open_menu_key) then
			if WarMenu.IsMenuOpened('xspectate') then
				WarMenu.CloseMenu()
			else
				TriggerServerEvent('xSpectateMenu')
			end
		end
		if WarMenu.IsMenuOpened('xspectate') then
			if WarMenu.Button('~o~Name','~o~ID') then
				
			end
			for i = nplayers, 1, -1 do
				if WarMenu.Button(player_names[i],player_ids[i]) then
					TriggerServerEvent('xSpectate', player_ids[i])
				end
			end
			WarMenu.Display()
		end
	end
end)
RegisterNetEvent('xSpectate:menu')
AddEventHandler('xSpectate:menu', function(get_nplayers, get_player_ids, get_player_names)
	nplayers = get_nplayers
	player_ids = get_player_ids
	player_names = get_player_names
	WarMenu.OpenMenu('xspectate')
end)
function CreateWarMenu(id, title, subtitle, pos, width)
	local x,y = table.unpack(pos)
	WarMenu.CreateMenu(id, title)
	WarMenu.SetSubTitle(id, subtitle)
	WarMenu.SetMenuX(id, x)
	WarMenu.SetMenuY(id, y)
	WarMenu.SetMenuWidth(id, width)
	WarMenu.SetTitleColor(id, 255, 255, 255, a)
end
-- spectate
local cdspectate = false
local spectate = false
local lastcoords = nil
local positionped = nil
local spectateped = nil
RegisterNetEvent('xSpectate:main')
AddEventHandler('xSpectate:main', function(coords, playerId)
	if not cdspectate then
		cdspectate = true
		if spectate then
			spectate = false
			Wait(300)
			RequestCollisionAtCoord(positionped)
			NetworkSetInSpectatorMode(false, spectateped)
			FreezeEntityPosition(PlayerPedId(), false)
			SetEntityCoords(PlayerPedId(), lastcoords)
			SetEntityVisible(PlayerPedId(), true)
			lastcoords = nil
			positionped = nil
			spectateped = nil
			cdspectate = false
		else
			spectate = true
			local foundplayer = false
			lastcoords = GetEntityCoords(PlayerPedId())
			SetEntityVisible(PlayerPedId(), false)
			SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z + 10.0)
			FreezeEntityPosition(PlayerPedId(), true)
			Wait(1500)
			SetEntityCoords(PlayerPedId(), coords.x, coords.y, coords.z - 10.0)
			for _, i in ipairs(GetActivePlayers()) do
				if NetworkIsPlayerActive(i) and tonumber(GetPlayerServerId(i)) == tonumber(playerId) then
					foundplayer = true
					local ped = GetPlayerPed(i)
					positionped = GetEntityCoords(ped)
					spectateped = ped
					RequestCollisionAtCoord(positionped)
					NetworkSetInSpectatorMode(true, spectateped)
					cdspectate = false
					while spectate do
						Wait(100)
						local cped = GetEntityCoords(spectateped)
						if cped.x == 0 and cped.y == 0 and cped.z == 0 then
							spectate = false
							Wait(300)
							RequestCollisionAtCoord(positionped)
							NetworkSetInSpectatorMode(false, spectateped)
							FreezeEntityPosition(PlayerPedId(), false)
							SetEntityCoords(PlayerPedId(), lastcoords)
							SetEntityVisible(PlayerPedId(), true)
							lastcoords = nil
							positionped = nil
							spectateped = nil
							cdspectate = false
						else
							SetEntityCoords(PlayerPedId(), cped.x, cped.y, cped.z - 10.0)
						end
					end
					break
				end
			end
			if not foundplayer then
				FreezeEntityPosition(PlayerPedId(), false)
				SetEntityCoords(PlayerPedId(), lastcoords)
				SetEntityVisible(PlayerPedId(), true)
				lastcoords = nil
				spectate = false
				cdspectate = false
			end
		end
	end
end)
