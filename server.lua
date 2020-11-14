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