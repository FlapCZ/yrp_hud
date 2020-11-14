ESX = nil
local PlayerData = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(10)
  end
  Citizen.Wait(3000)
  if PlayerData == nil or PlayerData.job == nil then
	  	PlayerData = ESX.GetPlayerData()
	end
end)


RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('yrp_esx_flap_hud:HUDdata')
AddEventHandler('yrp_esx_flap_hud:HUDdata', function(data)
	local jobName = PlayerData.job.label
	local gradeName = PlayerData.job.grade_label

	SendNUIMessage({
		action = 'YRPhudMoney',
		cash = data.cash,
		bank = data.bank,
		black_money = data.black_money,
		society = data.society,
		frakcnikasa = data.frakcnikasa,
		datumnarozeni = data.datumnarozeni
	})
	SendNUIMessage({
		action = 'YRPhudChar',
		charactername = data.charactername
	})
	SendNUIMessage({
		action = 'YRPhudJob',
		data = jobName
	})
	SendNUIMessage({
		action = 'YRPhudGrade',
		data = gradeName
	})
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		TriggerServerEvent('yrp_esx_flap_hud:HUDdata')
	end
end)

local isMenuPaused = false

function menuPaused()
	SendNUIMessage({
		action = 'disableHud',
		data = isMenuPaused
	})
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		if IsPauseMenuActive() then
			if not isMenuPaused then
				isMenuPaused = true
				menuPaused()
			end
		elseif isMenuPaused then
			isMenuPaused = false
			menuPaused()
		end
		if IsControlJustPressed(1, 170) then
			SendNUIMessage({
				action = 'YRPhudSlide'
			})
		end
	end
end)

function SetWeaponDrops()
	local ready = false 
    local handle, ped = FindFirstPed()

    repeat 
        if not IsEntityDead(ped) then
            SetPedDropsWeaponsWhenDead(ped, false) 
        end
        ready, ped = FindNextPed(handle)
    until not ready

    EndFindPed(handle)
end

Citizen.CreateThread(function()
    while true do
        SetWeaponDrops()
        Citizen.Wait(500)
    end
end)
