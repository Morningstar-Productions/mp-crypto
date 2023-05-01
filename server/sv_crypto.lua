local QBCore = exports['qb-core']:GetCoreObject()

-- Events

RegisterServerEvent('mp-crypto:ExchangeFail', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    if Config.Inventory.QB then
        if Player.Functions.GetItemByName("cryptostick") then
            Player.Functions.RemoveItem("cryptostick", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["cryptostick"], "remove")
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cryptostick_malfunctioned'), 'error')
        end
    elseif Config.Inventory.Ox then
        local cryptostick = exports.ox_inventory:GetItem(src, 'cryptostick', nil, false)
        if cryptostick then
            exports.ox_inventory:RemoveItem(src, 'cryptostick', 1)
            TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cryptostick_malfunctioned'), 'error')
        end
    end
end)

RegisterServerEvent('mp-crypto:Rebooting', function(state, percentage)
    Config.Exchange.RebootInfo.state = state
    Config.Exchange.RebootInfo.percentage = percentage
end)

RegisterServerEvent('mp-crypto:GetRebootState', function()
    local src = source
    TriggerClientEvent('mp-crypto:GetRebootState', src, Config.Exchange.RebootInfo)
end)

RegisterServerEvent('mp-crypto:ExchangeSuccess', function(LuckChance)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local amount = math.random(1, 25)

    if not Player then return end

    if Config.Inventory.QB then
        if Player.Functions.GetItemByName("cryptostick") then
            Player.Functions.RemoveItem("cryptostick", 1)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["cryptostick"], "remove")
        end
    elseif Config.Inventory.Ox then
        local cryptostick = exports.ox_inventory:GetItem(src, 'cryptostick', nil, false)
        if cryptostick then
            exports.ox_inventory:RemoveItem(src, 'cryptostick', 1)
        end
    end

    if Config.Crypto.Renewed then
        exports['qb-phone']:AddCrypto(src, "gne", amount)
        TriggerClientEvent('qb-phone:client:CustomNotification', src,
            "CRYPTOMINER",
            Lang:t('success.you_have_exchanged_your_cryptostick_for',{amount = amount}),
            "fas fa-coins",
            "#FFFFFF",
            7500
        )
    elseif Config.Crypto.QBCore then
        Player.Functions.AddMoney('crypto', amount, 'crypto-exchange')
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.you_have_exchanged_your_cryptostick_for',{amount = amount}), "success", 3500)
    end
end)
