------------------------------------------------------------
------------------------- yrp_hud --------------------------
------------------------------------------------------------
--------------------- Created by Flap ----------------------
------------------------------------------------------------
----------------- YourRolePlay Development -----------------
--------------- Thank you for using this hud ---------------
----- Regular updates and lots of interesting scripts ------
--------- discord -> https://discord.gg/hqZEXc8FSE ---------
------------------------------------------------------------

ESX = nil
local lastJob = nil
local PlayerData = nil
local CanSendWebhook = true

Citizen.CreateThread(function()
  while ESX == nil do	
	TriggerEvent(Config.general_config_settings.ESX, function(obj)
		ESX = obj
	end)

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

    if CanSendWebhook then
	    TriggerServerEvent('yrp_hud:SendDiscordWebhook') 
	    CanSendWebhook = false
    end
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
  PlayerData.job = job
end)

RegisterNetEvent('yrp_hud:retrieveData')
AddEventHandler('yrp_hud:retrieveData', function(data)
	local jobName = PlayerData.job.label
	local gradeName = PlayerData.job.grade_label

	SendNUIMessage({
		action = 'YRPmoney',
		cash = data.cash,
		bank = data.bank,
		black_money = data.black_money,
		society = data.society,
		frakcnikasa = data.frakcnikasa,
		datumnarozeni = data.datumnarozeni
	})
	SendNUIMessage({
		action = 'YRPcharacterName',
		charactername = data.charactername
	})
	SendNUIMessage({
		action = 'YRPjob',
		data = jobName
	})
	SendNUIMessage({
		action = 'YRPjobGrade',
		data = gradeName
	})
end)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(5000)
		TriggerServerEvent('yrp_hud:retrieveData')
	end
end)

local armor
local health
local HunVal = 0
local ThiVal = 0

Citizen.CreateThread(function()
	while(true) do
		Citizen.Wait(1000)
		armor = GetPedArmour(GetPlayerPed(-1))
		health = (GetEntityHealth(GetPlayerPed(-1))-100)

		TriggerEvent('esx_status:getStatus', 'hunger', function(status)
			HunVal = status.val/1000000*100
		end)
		TriggerEvent('esx_status:getStatus', 'thirst', function(status)
			ThiVal = status.val/1000000*100
		end)
    end
end)


Citizen.CreateThread(function()
 while true do
		Citizen.Wait(200)
		
		SendNUIMessage({
			action = 'YRPstatus',
			health = health,
			armor = armor,
			hunger =  HunVal,
			thirst =  ThiVal,
		})
	end
end)

local isMenuPaused = false

function menuPaused()
	SendNUIMessage({
		action = 'YRPpausemenu',
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
		if IsControlJustPressed(1, Config.general_config_settings.SlideHUD) then
			SendNUIMessage({
				action = 'YRPslide'
			})
		end
	end
end)