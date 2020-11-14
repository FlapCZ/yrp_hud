ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

function getAccounts(data, xPlayer)
	local result = {}
	for i=1, #data do
		if(data[i] ~= 'money') then
			if(data[i] == 'black_money') then
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

RegisterServerEvent('yrp_esx_flap_hud:HUDdata')
AddEventHandler('yrp_esx_flap_hud:HUDdata', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer ~= nil then
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
	  TriggerClientEvent('yrp_esx_flap_hud:HUDdata', source, {cash = money, bank = bank, black_money = black_money, society = society, charactername = charactername, frakcnikasa = frakcnikasa, datumnarozeni = datumnarozeni})
	end
end)

RegisterServerEvent('yrp_hud:SendDiscordWebhook')
AddEventHandler('yrp_hud:SendDiscordWebhook', function()
	local xPlayer = ESX.GetPlayerFromId(source)
	local character = xPlayer.getName()
	local money,bank = table.unpack(getAccounts({'money', 'bank'}, xPlayer))
	local job = xPlayer.job.name
	local job_grade = xPlayer.job.grade_name
	local yrp_hud_version = '0.2'
	local webhook = Config.Webhooks.hudload

		  local connect = {
			{
				["color"] = "16107018",
				["title"] = "🎮 Development for FiveM community 🎮",
				["description"] = "🍀 Hráč - **" ..GetPlayerName(source).. "**\n🍀 charakter - **" ..character.. "**\n🍀 Práce - **" ..job.. "**\n🍀 Pozice - **" ..job_grade.. "**\n🍀 Peníze v kapse - **" ..money.. "**$\n🍀 Peníze v bance - **" ..bank.. "**$\n\n yrp_hud version - " ..yrp_hud_version,
				["footer"] = {
				["text"] = os.date('%H:%M - %d. %m. %Y', os.time()),
				["icon_url"] = "https://emojipedia-us.s3.dualstack.us-west-1.amazonaws.com/thumbs/120/joypixels/257/hourglass-not-done_23f3.png",
				},
			}
		}

PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = "yrp_hud - načtení hud", embeds = connect}), { ['Content-Type'] = 'application/json' }) 
end)