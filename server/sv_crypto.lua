local QBCore = exports['qb-core']:GetCoreObject()

-- Events

RegisterServerEvent('mp-crypto:server:ExchangeFail', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ItemData = Player.Functions.GetItemByName("cryptostick")

    if ItemData ~= nil then
        Player.Functions.RemoveItem("cryptostick", 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["cryptostick"], "remove")
        TriggerClientEvent('QBCore:Notify', src, Lang:t('error.cryptostick_malfunctioned'), 'error')
    end
end)

RegisterServerEvent('mp-crypto:server:Rebooting', function(state, percentage)
    Config.Exchange.RebootInfo.state = state
    Config.Exchange.RebootInfo.percentage = percentage
end)

RegisterServerEvent('mp-crypto:server:GetRebootState', function()
    local src = source
    TriggerClientEvent('mp-crypto:client:GetRebootState', src, Config.Exchange.RebootInfo)
end)

RegisterServerEvent('mp-crypto:server:SyncReboot', function()
    TriggerClientEvent('mp-crypto:client:SyncReboot', -1)
end)

RegisterServerEvent('mp-crypto:server:ExchangeSuccess', function(LuckChance)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local ItemData = Player.Functions.GetItemByName("cryptostick")

    if ItemData ~= nil then
        local Amount = math.random(1, 25)
        Player.Functions.RemoveItem("cryptostick", 1)
        exports['qb-phone']:AddCrypto(src, "gne", Amount)
        TriggerClientEvent('QBCore:Notify', src, Lang:t('success.you_have_exchanged_your_cryptostick_for',{amount = Amount}), "success", 3500)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["cryptostick"], "remove")
    end
end)
