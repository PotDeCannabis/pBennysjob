ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Benny's

ESX.RegisterServerCallback('pBennysjob:getItemAmount', function(source, cb, item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local quantity = xPlayer.getInventoryItem(item).count

	cb(quantity)
end)

ESX.RegisterServerCallback('pBennysjob:ifhaveitem', function(source,cb,itemname)
	local xPlayer = ESX.GetPlayerFromId(source)
  
  	if xPlayer.getInventoryItem(itemname).count >= 1 then
    	xPlayer.removeInventoryItem(itemname,1)
		cb(true)
    else
      	cb(false)
    end
end)

RegisterServerEvent('pBennysjob:removeItem')
AddEventHandler('pBennysjob:removeItem', function(item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)

	xPlayer.removeInventoryItem(item, 1)
end)

-- Coffre

ESX.RegisterServerCallback('pBennysjob:playerinventory', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	local items   = xPlayer.inventory
	local all_items = {}
	
	for k,v in pairs(items) do
		if v.count > 0 then
			table.insert(all_items, {label = v.label, item = v.name,nb = v.count})
		end
	end
	cb(all_items)
end)

ESX.RegisterServerCallback('pBennysjob:getStockItems', function(source, cb)
	local all_items = {}
	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ems', function(inventory)
		for k,v in pairs(inventory.items) do
			if v.count > 0 then
				table.insert(all_items, {label = v.label,item = v.name, nb = v.count})
			end
		end
	end)
	cb(all_items)
end)

RegisterServerEvent('pBennysjob:putStockItems')
AddEventHandler('pBennysjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local item_in_inventory = xPlayer.getInventoryItem(itemName).count

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ems', function(inventory)
		if item_in_inventory >= count and count > 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez déposer ~y~"..itemName.."~s~ au nombre de ~y~"..count.."~s~.")
		else
			TriggerClientEvent('esx:showNotification', xPlayer.source, "~r~Vous n'avez pas cette quantité.")
		end
	end)
end)

RegisterServerEvent('pBennysjob:takeStockItems')
AddEventHandler('pBennysjob:takeStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_ems', function(inventory)
			xPlayer.addInventoryItem(itemName, count)
			inventory.removeItem(itemName, count)
			TriggerClientEvent('esx:showNotification', xPlayer.source, "Vous avez retirer ~y~"..itemName.."~s~ au nombre de ~y~"..count.."~s~.")
	end)
end)

-- Fournisseur

RegisterServerEvent('pBennysjob:giveItem')
AddEventHandler('pBennysjob:giveItem', function(Nom, Item)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local qtty = xPlayer.getInventoryItem(Item).count

		if qtty < 10 then
			xPlayer.addInventoryItem(Item, 1)
			TriggerClientEvent('esx:showNotification', _source, 'Tu as recu un ~y~' ..Nom.. '~s~ !')
		else
			TriggerClientEvent('esx:showNotification', _source, "~r~Vous avez atteints la limite !")
		end
	end)

-- Boss

RegisterServerEvent('pBennysjob:withdrawMoney')
AddEventHandler('pBennysjob:withdrawMoney', function(society, amount, money_soc)
	local xPlayer = ESX.GetPlayerFromId(source)
	local src = source
  
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
	  if account.money >= tonumber(amount) then
		  xPlayer.addMoney(amount)
		  account.removeMoney(amount)
		  TriggerClientEvent("esx:showNotification", src, "Vous avez retirer~g~ "..amount.."$")
	  else
		  TriggerClientEvent("esx:showNotification", src, "~rL'entreprise n'as pas asser d'argent.")
	  end
	end)
	  
  end)

RegisterServerEvent('pBennysjob:depositMoney')
AddEventHandler('pBennysjob:depositMoney', function(society, amount)

	local xPlayer = ESX.GetPlayerFromId(source)
	local money = xPlayer.getMoney()
	local src = source
  
	TriggerEvent('esx_addonaccount:getSharedAccount', society, function(account)
	  if money >= tonumber(amount) then
		  xPlayer.removeMoney(amount)
		  account.addMoney(amount)
		  TriggerClientEvent("esx:showNotification", src, "Vous avez déposer~r~ "..amount.."$")
	  else
		  TriggerClientEvent("esx:showNotification", src, "~rVous n'avez pas asser d'argent.")
	  end
	end)
	
end)

ESX.RegisterServerCallback('pBennysjob:getSocietyMoney', function(source, cb, soc)
	local money = nil
		MySQL.Async.fetchAll('SELECT * FROM addon_account_data WHERE account_name = @society ', {
			['@society'] = soc,
		}, function(data)
			for _,v in pairs(data) do
				money = v.money
			end
			cb(money)
		end)
end)