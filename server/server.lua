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

TriggerEvent(Config.general_config_settings.ESX, function(obj)
	ESX = obj
end)

function getAccounts(data, xPlayer)
	local result = {}
	for i=1, #data do
		if(data[i] ~= 'money') then
			if(data[i] == 'black_money') and not Config.general_server_settings.showBlackMoney then
				result[i] = nil
			else
				result[i] = xPlayer.getAccount(data[i])['money']
			end

		else
			result[i] = xPlayer.getMoney()
		end
	end
	return result
end

function tableIncludes(table, data)
	for _,v in pairs(table) do
		if v == data then
			return true
		end
	end
	return false
end

local allowedGrades = {
	'boss',
	'underboss'
}

RegisterServerEvent('yrp_hud:retrieveData')
AddEventHandler('yrp_hud:retrieveData', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
		local xPlayer = ESX.GetPlayerFromId(source)
		local money,bank,black_money = table.unpack(getAccounts({'money', 'bank', 'black_money'}, xPlayer))
		local charactername = xPlayer.getName()
		local society = nil
		local frakcnikasa = nil
		if tableIncludes(allowedGrades, xPlayer.job.grade_name) then
			frakcnikasa = 'Frakční kasa'
			TriggerEvent('esx_society:getSociety', xPlayer.job.name, function(data)
				if data ~= nil then
					TriggerEvent('esx_addonaccount:getSharedAccount', data.account, function(account)
							society = account['money']
					end)
				end
			end)
		end
	  TriggerClientEvent('yrp_hud:retrieveData', source, {cash = money, bank = bank, black_money = black_money, society = society, charactername = charactername, frakcnikasa = frakcnikasa, datumnarozeni = datumnarozeni})
	end
end)

RegisterServerEvent('yrp_hud:SendDiscordWebhook')
AddEventHandler('yrp_hud:SendDiscordWebhook', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local character = xPlayer.getName()
	local money,bank,black_money = table.unpack(getAccounts({'money', 'bank', 'black_money'}, xPlayer))
	local job = xPlayer.job.name
	local job_grade = xPlayer.job.grade_name
	local yrp_hud_version = '1.0'
	local webhook = Config.general_server_settings.discord_webhook
	local author = 'Author - Flap™ | 💻#8593'

		  local connect = {
			{
				["color"] = "16107018",
				["title"] = "🎮 Development for FiveM community 🎮",
				["description"] = "🍀 Player - **" ..GetPlayerName(source).. "**\n🍀 Character - **" ..character.. "**\n🍀 Job - **" ..job.. "**\n🍀 Job grade - **" ..job_grade.. "**\n🍀 Money - **" ..money.. "**$\n🍀 Bank - **" ..bank.. "**$\n🍀 Black money - **" ..black_money.. "**$\n\n yrp_hud version - " ..yrp_hud_version.. "\n" ..author,
				["footer"] = {
				["text"] = os.date('%H:%M - %d. %m. %Y', os.time()),
				["icon_url"] = "https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/joypixels/257/hourglass-not-done_23f3.png",
				},
			}
		}

PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "yrp_hud - hud loaded", embeds = connect}), { ['Content-Type'] = 'application/json' }) 
end)