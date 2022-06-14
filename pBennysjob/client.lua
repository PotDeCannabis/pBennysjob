ESX = nil

Citizen.CreateThread(function()
  while ESX == nil do
    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
    Citizen.Wait(0)
  end

  while ESX.GetPlayerData().job == nil do
    Citizen.Wait(10)
  end

  ESX.PlayerData = ESX.GetPlayerData()
end)

-- Vérification

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    ESX.PlayerData = xPlayer
    PlayerLoaded = true
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

-- Blips

local pos = vector3(Config.Position.Blips.x, Config.Position.Blips.y,Config.Position.Blips.z)
Citizen.CreateThread(function()
  local blip = AddBlipForCoord(pos)

  SetBlipSprite (blip, 446)
  SetBlipDisplay(blip, 4)
  SetBlipScale  (blip, 0.7)
  SetBlipColour (blip, 5)
  SetBlipAsShortRange(blip, true)

  BeginTextCommandSetBlipName('STRING')
  AddTextComponentSubstringPlayerName('Benny\'s')
  EndTextCommandSetBlipName(blip)
end)

-- Patron

local open = false 
local mainMenu = RageUI.CreateMenu('Patron', 'Actions Patron')
mainMenu.Display.Header = true 
mainMenu.Closed = function()
    open = false
end

function MenuBoss()
  if open then 
    open = false
    RageUI.Visible(mainMenu, false)
    return
  else
    open = true 
    RageUI.Visible(mainMenu, true)
    CreateThread(function()
    RefreshMoney()
    while open do 
       RageUI.IsVisible(mainMenu,function() 
            
            if societyems ~= nil then
                RageUI.Button('Argent société:', nil, {RightLabel = "~g~"..societyems.."$"}, true, {onSelected = function()end});   
            end

            RageUI.Button('Déposer de l\'argent.', nil, {RightLabel = "→"}, true, {onSelected = function()
                local money = KeyboardInput('Combien voulez vous déposer ?', '', 10)
                TriggerServerEvent("pBennysjob:depositMoney","society_bennys" ,money)
                RefreshMoney()
                RefreshMoney()
            end});  

            RageUI.Button('Retirer de l\'argent.', nil, {RightLabel = "→"}, true, {onSelected = function()
                local money = KeyboardInput('Combien voulez vous retirer ?', '', 10)
                TriggerServerEvent("pBennysjob:withdrawMoney","society_bennys" ,money)
                RefreshMoney()
                RefreshMoney()
            end});   

       end)
     Wait(0)
    end
   end)
  end
end

function RefreshMoney()
    if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
        ESX.TriggerServerCallback('pBennysjob:getSocietyMoney', function(money)
            societyems = money
        end, "society_bennys")
    end
end

function Updatessocietyambulancemoney(money)
    societyambulance = ESX.Math.GroupDigits(money)
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLength)
  AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
  DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
  blockinput = true

  while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
    Citizen.Wait(0)
  end

  if UpdateOnscreenKeyboard() ~= 2 then
    local result = GetOnscreenKeyboardResult()
    Citizen.Wait(500)
    blockinput = false
    return result
  else
    Citizen.Wait(500)
    blockinput = false
    return nil
  end
end

Citizen.CreateThread(function()
    while true do
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'concess' then
            if ESX.PlayerData.job ~= nil and ESX.PlayerData.job.grade_name == 'boss' then
                for k in pairs(Config.Position.Boss) do
                    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                    local pos = Config.Position.Boss
                    local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                    if dist <= 5.0 then
                        wait = 0
                        DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
                    end

                    if dist <= 2.0 then
                        wait = 0
                        Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour pour accèder au ~y~actions patron ~s~!", 1)
                        if IsControlJustPressed(1,51) then
                            MenuBoss()
                        end
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

-- Coffre

local mainMenu = RageUI.CreateMenu("Coffre", "Coffre entreprise")
local PutMenu = RageUI.CreateSubMenu(mainMenu,"Coffre", "Coffre entreprise")
local GetMenu = RageUI.CreateSubMenu(mainMenu,"Coffre", "Coffre entreprise")

local open = false

mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    open = false
end

all_items = {}

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end 
         
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

    
function MenuCoffre()
    if open then 
        open = false
        RageUI.Visible(mainMenu, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(mainMenu, function()

                    RageUI.Button("Déposer un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                        getInventory()
                    end},PutMenu);

                    RageUI.Button("Prendre un objet", nil, {RightLabel = "→"}, true, {onSelected = function()
                        getStock()
                    end},GetMenu);

                end)

                RageUI.IsVisible(GetMenu, function()
                    for k,v in pairs(all_items) do
                        RageUI.Button(v.label, nil, {RightLabel = "~g~x"..v.nb}, true, {onSelected = function()
                            local count = KeyboardInput("Combien voulez vous en prendre ?",nil,4)
                            count = tonumber(count)
                            if count <= v.nb then
                                TriggerServerEvent("pBennysjob:takeStockItems",v.item, count)
                            else
                                ESX.ShowNotification("~r~Vous n'avez pas cette quantité.")
                            end
                            getStock()
                        end});
                    end
                end)

                RageUI.IsVisible(PutMenu, function()
                    for k,v in pairs(all_items) do
                        RageUI.Button(v.label, nil, {RightLabel = "~g~x"..v.nb}, true, {onSelected = function()
                            local count = KeyboardInput("Combien voulez vous en déposer ?",nil,4)
                            count = tonumber(count)
                            TriggerServerEvent("pBennysjob:putStockItems",v.item, count)
                            getInventory()
                        end});
                    end
               end)
                Wait(0)
            end
        end)
    end
end

function getInventory()
    ESX.TriggerServerCallback('pBennysjob:playerinventory', function(inventory)                    
        all_items = inventory
    end)
end

function getStock()
    ESX.TriggerServerCallback('pBennysjob:getStockItems', function(inventory)                    
        all_items = inventory
    end)
end

Citizen.CreateThread(function()
    while true do
    local wait = 750
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bennys' then
        for k in pairs(Config.Position.Coffre) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local pos = Config.Position.Coffre
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

            if dist <= 5.0 then
              wait = 0
              DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
            end

            if dist <= 2.0 then
                wait = 0
                Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour accèder au ~y~coffre ~s~!", 1)
                if IsControlJustPressed(1,51) then
                    MenuCoffre()
                end
            end
        end
    end
    Citizen.Wait(wait)
    end
end)

-- Fournisseur

local open = false 
local mainMenu = RageUI.CreateMenu('Fournisseur', 'Fournisseur entreprise') 
mainMenu.Display.Header = true 
mainMenu.Closed = function()
    open = false
end

function MenuFournisseur() 
    if open then 
        open = false
        RageUI.Visible(mainMenu, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenu, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(mainMenu, function()
                    for k, v in pairs(Config.Fournisseur) do

                        RageUI.Button(v.Nom, nil, {RightLabel = "(x1)"}, true, {
                        onSelected = function()
                            TriggerServerEvent('pBennysjob:giveItem', v.Nom, v.Item)
                        end})

                    end
                end)      
            Wait(0)
            end
        end)
    end
end


Citizen.CreateThread(function()
    while true do
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bennys' then
            for k in pairs(Config.Position.Fournisseur) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.Position.Fournisseur
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 5.0 then
                    wait = 0
                    DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
                 end

                if dist <= 2.0 then
                    wait = 0
                    Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour accèder au ~y~fournisseur ~s~!", 1)
                    if IsControlJustPressed(1,51) then
                        MenuFournisseur()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

-- Vestiaire

function applySkinSpecific(infos)
    TriggerEvent('skinchanger:getSkin', function(skin)
        local uniformObject

        if skin.sex == 0 then
            uniformObject = infos.variations.male
        else
            uniformObject = infos.variations.female
        end

        if uniformObject then
          TriggerEvent('skinchanger:loadClothes', skin, uniformObject)
        end

        infos.onEquip()
    end)
end

local open = false 
local mainMenu6 = RageUI.CreateMenu('Vestiaire', 'Votre vestiaire')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
    open = false
end

function MenuVestiaire()
    if open then 
        open = false
        RageUI.Visible(mainMenu6, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenu6, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(mainMenu6,function() 

                    RageUI.Separator("↓ ~y~Vos Tenues ~s~↓")
                    for index,infos in pairs(Vestiaire.clothes.grades) do
                        RageUI.Button(infos.label, nil, {RightLabel = ">"}, ESX.PlayerData.job.grade >= infos.minimum_grade, {
                        onSelected = function()
                            applySkinSpecific(infos)
                        end})
                    end
                end)
            Wait(0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do
    local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bennys' then
            for k in pairs(Config.Position.Vestaire) do
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.Position.Vestaire
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 5.0  then
                    wait = 0
                    DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
                end

                if dist <= 2.0 then
                    wait = 0
                    Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour pour accèder au ~y~vestaire ~s~!", 1)
                    if IsControlJustPressed(1,51) then
                        MenuVestiaire()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

-- Garage

local open = false 
local mainMenu6 = RageUI.CreateMenu('Garage', 'Garage entreprise')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
    open = false
end

function MenuGarage()
    if open then 
        open = false
        RageUI.Visible(mainMenu6, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenu6, true)
        CreateThread(function()
            while open do 
                RageUI.IsVisible(mainMenu6,function() 

                    RageUI.Button("Ranger votre véhicule", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            local veh,dist4 = ESX.Game.GetClosestVehicle(playerCoords)
                            if dist4 < 4 then
                                DeleteEntity(veh)
                                RageUI.CloseAll()
                            end
                        end
                    })

                    RageUI.Separator("↓ ~y~Véhicules du Benny's ~s~↓")

                    for k,v in pairs(Config.Garage) do
                        RageUI.Button(v.buttoname, nil, {RightLabel = "→"}, true , {
                            onSelected = function()
                                if not ESX.Game.IsSpawnPointClear(vector3(v.spawnzone.x, v.spawnzone.y, v.spawnzone.z), 10.0) then
                                ESX.ShowNotification("La sortie du garage est bloquer.")
                                else
                                local model = GetHashKey(v.spawnname)
                                RequestModel(model)
                                while not HasModelLoaded(model) do Wait(10) end
                                local bennysbeh = CreateVehicle(model, v.spawnzone.x, v.spawnzone.y, v.spawnzone.z, v.headingspawn, true, false)
                                SetVehicleNumberPlateText(bennysbeh, "bennys"..math.random(50, 999))
                                SetVehicleFixed(bennysbeh)
                                TaskWarpPedIntoVehicle(PlayerPedId(),  bennysbeh,  -1)
                                SetVehRadioStation(bennysbeh, 0)
                                RageUI.CloseAll()
                                end
                            end
                        })
                    end
                end)
            Wait(0)
            end
        end)
    end
end

Citizen.CreateThread(function()
    while true do 
        local wait = 750
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bennys' then
            for k in pairs(Config.Position.Garage) do 
                local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
                local pos = Config.Position.Garage
                local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

                if dist <= 5.0 then 
                    wait = 0
                    DrawMarker(6, pos[k].x, pos[k].y, pos[k].z-0.99, nil, nil, nil, -90, nil, nil, 1.0, 1.0, 1.0, 230, 230, 0 , 120)
                end

                if dist <= 2.0 then 
                    wait = 0
                    Visual.Subtitle("Appuyez sur ~y~[E] ~s~pour accèder au ~y~garage ~s~!", 1)
                    if IsControlJustPressed(1,51) then
                        MenuGarage()
                    end
                end
            end
        end
    Citizen.Wait(wait)
    end
end)

-- Menu Benny's

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

local open = false 
local mainMenu8 = RageUI.CreateMenu('Benny\'s', 'Interaction')
mainMenu8.Display.Header = true 
mainMenu8.Closed = function()
    open = false
end

function MenuBennys()
    if open then 
        open = false
        RageUI.Visible(mainMenu8, false)
        return
    else
        open = true 
        RageUI.Visible(mainMenu8, true)
        CreateThread(function()
            while open do
                RageUI.IsVisible(mainMenu8,function()

                    RageUI.Separator("~y~↓ Interaction Mécaniciens ↓")

                    RageUI.Button("Faire une Facture", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            amount = KeyboardInput("Quel est le montant de la facture ?",nil,5)
                            amount = tonumber(amount)
                            local player, distance = ESX.Game.GetClosestPlayer()
            
                            if player ~= -1 and distance <= 3.0 then
                                if amount == nil then
                                    ESX.ShowNotification("~r~Montant invalide")
                                else
                                    local playerPed = GetPlayerPed(-1)
                                    Citizen.Wait(5000)
                                    TriggerServerEvent('esx_billing:sendBill', GetPlayerServerId(player), 'society_bennys', ('Bennys'), amount)
                                    Citizen.Wait(100)
                                    ESX.ShowNotification("~g~Vous avez bien envoyer la facture")
                                end
                            else
                                ESX.ShowNotification("~r~Aucune personne à proximitée")
                            end
                        end
                    });

                    RageUI.Button("Réparer le véhicule", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            ESX.TriggerServerCallback('pBennysjob:getItemAmount', function(quantity)
                                if quantity > 0 then
                                    local playerPed = PlayerPedId()
                                    local vehicle   = ESX.Game.GetVehicleInDirection()
                                    local coords    = GetEntityCoords(playerPed)
                        
                                    if IsPedSittingInAnyVehicle(playerPed) then
                                        ESX.ShowNotification('Vous devez ~y~déscendre ~s~du ~y~véhicule~s~.')
                                        return
                                    end
                        
                                    if DoesEntityExist(vehicle) then
                                        isBusy = true
                                        TaskStartScenarioInPlace(playerPed, 'PROP_HUMAN_BUM_BIN', 0, true)
                                        Citizen.CreateThread(function()
                                            Citizen.Wait(20000)
                        
                                            SetVehicleFixed(vehicle)
                                            SetVehicleDeformationFixed(vehicle)
                                            SetVehicleUndriveable(vehicle, false)
                                            SetVehicleEngineOn(vehicle, true, true)
                                            ClearPedTasksImmediately(playerPed)
                        
                                            ESX.ShowNotification('Le ~y~véhicule ~s~a été ~y~réparer ~s~!')
                                            TriggerServerEvent('pBennysjob:removeItem', 'kitreparation')
                                            isBusy = false
                                        end)
                                    else
                                        ESX.ShowNotification('~r~Aucun véhicule à proximité.')
                                    end
                                else
                                    ESX.ShowNotification('~r~Vous n\'avez pas de Kit de Réparation.')
                                end
                            end, "kitreparation")
                        end
                    })

                    RageUI.Button("Nettoyer le véhicule", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            ESX.TriggerServerCallback('pBennysjob:getItemAmount', function(quantity)
                                if quantity > 0 then
                                    local playerPed = PlayerPedId()
                                    local vehicle   = ESX.Game.GetVehicleInDirection()
                                    local coords    = GetEntityCoords(playerPed)
                        
                                    if IsPedSittingInAnyVehicle(playerPed) then
                                        ESX.ShowNotification('~r~Vous devez déscendre du véhicule.')
                                        return
                                    end
                        
                                    if DoesEntityExist(vehicle) then
                                        isBusy = true
                                        TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_MAID_CLEAN', 0, true)
                                        Citizen.CreateThread(function()
                                            Citizen.Wait(10000)
                        
                                            SetVehicleDirtLevel(vehicle, 0)
                                            ClearPedTasksImmediately(playerPed)
                        
                                            ESX.ShowNotification('Le ~y~véhicule ~s~a été ~y~néttoyer ~s~!')
                                            TriggerServerEvent('pBennysjob:removeItem', 'kitnettoyage')
                                            isBusy = false
                                        end)
                                    else
                                        ESX.ShowNotification('~r~Aucun véhicule à proximité.')
                                    end
                                else
                                    ESX.ShowNotification('~r~Vous n\'avez pas de Kit de Nettoyage.')
                                end
                            end, "kitnettoyage")
                        end
                    })

                    RageUI.Button("Mettre le véhicule en fourrière", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            local playerPed = PlayerPedId()

                            if IsPedSittingInAnyVehicle(playerPed) then
                                ESX.ShowNotification('~r~Vous devez déscendre du véhicule.')
                                return
                            else
                                local vehicle = ESX.Game.GetVehicleInDirection()
                
                                if DoesEntityExist(vehicle) then
                                    TaskStartScenarioInPlace(playerPed, 'CODE_HUMAN_MEDIC_KNEEL', 0, true)
                                    Citizen.CreateThread(function()
                                        Citizen.Wait(3500)

                                        ESX.ShowNotification('Le ~y~véhicule ~s~a été placer en ~y~fourrière ~s~!')
                                        ESX.Game.DeleteVehicle(vehicle)

                                        ClearPedTasksImmediately(playerPed)
                                    end)
                                else
                                    ESX.ShowNotification('~r~Aucun véhicule à proximité.')
                                end
                            end
                        end
                    })

                    RageUI.Button("Crocheter le véhicule", nil, {RightLabel = "→"}, true , {
                        onSelected = function()
                            local playerPed = PlayerPedId()
                            local vehicle = ESX.Game.GetVehicleInDirection()
                            local coords = GetEntityCoords(playerPed)
                
                            if IsPedSittingInAnyVehicle(playerPed) then
                                ESX.ShowNotification('~r~Vous devez déscendre du véhicule.')
                                return
                            end
                
                            if DoesEntityExist(vehicle) then
                                isBusy = true
                                TaskStartScenarioInPlace(playerPed, 'WORLD_HUMAN_WELDING', 0, true)
                                Citizen.CreateThread(function()
                                    Citizen.Wait(10000)
                
                                    SetVehicleDoorsLocked(vehicle, 1)
                                    SetVehicleDoorsLockedForAllPlayers(vehicle, false)
                                    ClearPedTasksImmediately(playerPed)
                
                                    ESX.ShowNotification('Le ~y~véhicule ~s~a été ~y~dévérouiller ~s~!')
                                    isBusy = false
                                end)
                            else
                                ESX.ShowNotification('~r~Aucun véhicule à proximité.')
                            end
                        end
                    })

                end)
            Wait(0)
            end
        end)  
    end
end

Keys.Register('F6', 'Benn\'s', 'Ouvrir le menu bennys', function()
    if ESX.PlayerData.job and ESX.PlayerData.job.name == 'bennys' then
        MenuBennys()
    end
end)
