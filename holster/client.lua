local weapons = {
	'WEAPON_KNIFE',
	'WEAPON_NIGHTSTICK',
	'WEAPON_HAMMER',
	'WEAPON_BAT',
	'WEAPON_GOLFCLUB',
	'WEAPON_CROWBAR',
	'WEAPON_BOTTLE',
	'WEAPON_DAGGER',
	'WEAPON_HATCHET',
	'WEAPON_MACHETE',
	'WEAPON_SWITCHBLADE',
	'WEAPON_BATTLEAXE',
	'WEAPON_POOLCUE',
	'WEAPON_WRENCH',
	'WEAPON_PISTOL',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_REVOLVER',
	'WEAPON_SNSPISTOL',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MICROSMG',
	'WEAPON_SMG',
	'WEAPON_ASSAULTSMG',
	'WEAPON_MINISMG',
	'WEAPON_MACHINEPISTOL',
	'WEAPON_COMBATPDW',
	'WEAPON_PUMPSHOTGUN',
	'WEAPON_SAWNOFFSHOTGUN',
	'WEAPON_ASSAULTSHOTGUN',
	'WEAPON_BULLPUPSHOTGUN',
	'WEAPON_HEAVYSHOTGUN',
	'WEAPON_ASSAULTRIFLE',
	'WEAPON_CARBINERIFLE',
	'WEAPON_ADVANCEDRIFLE',
	'WEAPON_SPECIALCARBINE',
	'WEAPON_BULLPUPRIFLE',
	'WEAPON_COMPACTRIFLE',
	'WEAPON_MG',
	'WEAPON_COMBATMG',
	'WEAPON_GUSENBERG',
	'WEAPON_SNIPERRIFLE',
	'WEAPON_HEAVYSNIPER',
	'WEAPON_MARKSMANRIFLE',
	'WEAPON_GRENADELAUNCHER',
	'WEAPON_RPG',
	'WEAPON_STINGER',
	'WEAPON_MINIGUN',
	'WEAPON_GRENADE',
	'WEAPON_STICKYBOMB',
	'WEAPON_SMOKEGRENADE',
	'WEAPON_BZGAS',
	'WEAPON_MOLOTOV',
	'WEAPON_DIGISCANNER',
	'WEAPON_FIREWORK',
	'WEAPON_MUSKET',
	'WEAPON_STUNGUN',
	'WEAPON_HOMINGLAUNCHER',
	'WEAPON_PROXMINE',
	'WEAPON_FLAREGUN',
	'WEAPON_MARKSMANPISTOL',
	'WEAPON_RAILGUN',
	'WEAPON_DBSHOTGUN',
	'WEAPON_AUTOSHOTGUN',
	'WEAPON_COMPACTLAUNCHER',
	'WEAPON_PIPEBOMB',
	'WEAPON_DOUBLEACTION',
	'WEAPON_CARBINERIFLE_MK2',
}

local holstered = true
local canfire = true
local currWeapon = nil
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if DoesEntityExist( GetPlayerPed(-1) ) and not IsEntityDead( GetPlayerPed(-1) ) and not IsPedInAnyVehicle(PlayerPedId(-1), true) then
			if currWeapon ~= GetSelectedPedWeapon(GetPlayerPed(-1)) then
				pos = GetEntityCoords(GetPlayerPed(-1), true)
				rot = GetEntityHeading(GetPlayerPed(-1))
				local newWeap = GetSelectedPedWeapon(GetPlayerPed(-1))
				SetCurrentPedWeapon(GetPlayerPed(-1), currWeapon, true)
				loadAnimDict( "reaction@intimidation@1h" )
				if CheckWeapon(newWeap) then
					if holstered then
						canFire = false
						TaskPlayAnimAdvanced(GetPlayerPed(-1), "reaction@intimidation@1h", "intro", GetEntityCoords(GetPlayerPed(-1), true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						Citizen.Wait(1000)
						ClearPedTasks(GetPlayerPed(-1))
						holstered = false
						canFire = true
						currWeapon = newWeap
					elseif newWeap ~= currWeapon then
						canFire = false
						TaskPlayAnimAdvanced(GetPlayerPed(-1), "reaction@intimidation@1h", "outro", GetEntityCoords(GetPlayerPed(-1), true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
						Citizen.Wait(900)
						ClearPedTasks(GetPlayerPed(-1))
						TaskPlayAnimAdvanced(GetPlayerPed(-1), "reaction@intimidation@1h", "intro", GetEntityCoords(GetPlayerPed(-1), true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						Citizen.Wait(1000)
						ClearPedTasks(GetPlayerPed(-1))
						holstered = false
						canFire = true
						currWeapon = newWeap
					end
				else
					if not holstered then
						canFire = false
						TaskPlayAnimAdvanced(GetPlayerPed(-1), "reaction@intimidation@1h", "outro", GetEntityCoords(GetPlayerPed(-1), true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
						Citizen.Wait(900)
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						ClearPedTasks(GetPlayerPed(-1))
						holstered = true
						canFire = true
						currWeapon = newWeap
					else
						canFire = false
						TaskPlayAnimAdvanced(GetPlayerPed(-1), "reaction@intimidation@1h", "intro", GetEntityCoords(GetPlayerPed(-1), true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
						SetCurrentPedWeapon(GetPlayerPed(-1), newWeap, true)
						Citizen.Wait(1000)
						ClearPedTasks(GetPlayerPed(-1))
						holstered = false
						canFire = true
						currWeapon = newWeap
					end
				end
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
		if not canFire then
			DisableControlAction(0, 25, true)
			DisablePlayerFiring(GetPlayerPed(-1), true)
		end
	end
end)

function CheckWeapon(newWeap)
	for i = 1, #weapons do
		if GetHashKey(weapons[i]) == newWeap then
			return true
		end
	end
	return false
end

function loadAnimDict(dict)
	while (not HasAnimDictLoaded(dict)) do
		RequestAnimDict(dict)
		Citizen.Wait(5)
	end
end