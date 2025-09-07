local Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57, 
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177, 
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70, 
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}



ESX = exports['es_extended']:getSharedObject()
local jingjokName = GetCurrentResourceName()
local PlayerData = nil
Citizen.CreateThread(function()
	Citizen.Wait(1)
	PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	PlayerData.job = job
end)

local Allow = false

Citizen.CreateThread(function()
  while true do
	Citizen.Wait(1000)
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		
		if Allow == false then
			local playerPed  = GetPlayerPed(-1)
			local vehicle =	GetVehiclePedIsIn(playerPed, false)
			local vehicleProps  = ESX.Game.GetVehicleProperties(vehicle)
			NameCar = GetDisplayNameFromVehicleModel(vehicleProps.model)
			for item,info in pairs(Config.Check) do
				for _,v in pairs(info) do
					if v == NameCar then
						local chec = checkHasItem(item)
						if chec == true then
							Allow = true
						else
							local myc = GetEntityCoords(PlayerPedId())
							SetEntityCoords(PlayerPedId(), myc.x, myc.y, myc.z)
							TriggerEvent("pNotify:SendNotification", {
								text = '<span class="red-text"> ห้ามขึ้นรถหน่วยงานนะจ๊ะ',
								type = "error",
								timeout = 5500,
							})
							
						end
						break
					end
				end
			end
		end
	else
		Allow = false
	end
   end
end)

function checkHasItem(item_name)
	local inventory = ESX.GetPlayerData().inventory
	for i = 1, #inventory do
		local item = inventory[i]
		if item_name == item.name and item.count > 0 then
			return true
		end
	end
	return false
end





