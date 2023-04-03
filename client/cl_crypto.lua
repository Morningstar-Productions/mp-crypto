local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function ExchangeSuccess()
	TriggerServerEvent('ob-crypto:server:ExchangeSuccess', math.random(1, 10))
end

local function ExchangeFail()
	local Odd = 5
	local RemoveChance = math.random(1, Odd)
	local LosingNumber = math.random(1, Odd)
	if RemoveChance == LosingNumber then
		TriggerServerEvent('ob-crypto:server:ExchangeFail')
		TriggerServerEvent('ob-crypto:server:SyncReboot')
	end
end

local function SystemCrashCooldown()
	CreateThread(function()
		while Config.Exchange.RebootInfo.state do
			if (Config.Exchange.RebootInfo.percentage + 1) <= 100 then
				Config.Exchange.RebootInfo.percentage = Config.Exchange.RebootInfo.percentage + 1
				TriggerServerEvent('ob-crypto:server:Rebooting', true, Config.Exchange.RebootInfo.percentage)
			else
				Config.Exchange.RebootInfo.percentage = 0
				Config.Exchange.RebootInfo.state = false
				TriggerServerEvent('ob-crypto:server:Rebooting', false, 0)
			end
			Wait(1200)
		end
	end)
end

-- Events

RegisterNetEvent("ob-crypto:ConnectUSB", function()
    if QBCore.Functions.HasItem('cryptostick', 1) then
        if lib.progressCircle({
            duration = 5000,
            label = "Plugging In USB..",
            position = 'bottom',
            useWhileDead = false,
            canCancel = true,
            disable = {
                move = true,
                car = true,
                combat = true,
            },
            anim = {
                dict = 'mp_prison_break',
                clip = 'hack_loop',
                flag = 16,
            }
        }) then
            if lib.progressCircle({
                duration = 5000,
                label = 'Booting Up CryptoMiner.exe',
                position = 'bottom',
                useWhileDead = false,
                canCancel = true,
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                },
                anim = {
                    dict = 'mp_prison_break',
                    clip = 'hack_loop',
                    flag = 16,
                }
            }) then
                local success = exports['boostinghack']:StartHack()
                if success then
                    ExchangeSuccess()
                else
                    ExchangeFail()
                end
            else
                QBCore.Functions.Notify('Cancelled', 'error', 7500)
                ClearPedTasks(PlayerPedId())
            end
        else
            QBCore.Functions.Notify('Cancelled', 'error', 7500)
            ClearPedTasks(PlayerPedId())
        end
    else
        QBCore.Functions.Notify("You don't have anything worth trading..", "error", 7500)
    end
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	TriggerServerEvent('ob-crypto:server:GetRebootState')
end)

RegisterNetEvent('ob-crypto:client:GetRebootState', function(RebootInfo)
	if RebootInfo.state then
		Config.Exchange.RebootInfo.state = RebootInfo.state
		Config.Exchange.RebootInfo.percentage = RebootInfo.percentage
		SystemCrashCooldown()
	end
end)

-- Target Thread

CreateThread(function()
    exports['qb-target']:AddBoxZone("Crypto-Exchange", vector3(1276.21, -1709.88, 54.57), 1.0, 1.0, {
        name = "Crypto-Exchange",
        debugPoly = Config.Debug,
        minZ = 53.57,
        maxZ = 55.57,
    }, {
        options = {
            {
                label = "Connect GNE Stick",
                icon = "fas fa-laptop",
                type = "client",
                event = "ob-crypto:ConnectUSB",
            },
        },
        distance = 1.0
    })
end)