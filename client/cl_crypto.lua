local QBCore = exports['qb-core']:GetCoreObject()

-- Functions

local function ExchangeSuccess()
	TriggerServerEvent('mp-crypto:ExchangeSuccess', math.random(1, 10))
end

local function ExchangeFail()
	local Odd = Config.Chance
	local RemoveChance = math.random(1, Odd)
	local LosingNumber = math.random(1, Odd)
	if RemoveChance == LosingNumber then
		TriggerServerEvent('mp-crypto:ExchangeFail')
		TriggerServerEvent('mp-crypto:SyncReboot')
	end
end

local function SystemCrashCooldown()
	CreateThread(function()
		while Config.Exchange.RebootInfo.state do
			if (Config.Exchange.RebootInfo.percentage + 1) <= 100 then
				Config.Exchange.RebootInfo.percentage = Config.Exchange.RebootInfo.percentage + 1
				TriggerServerEvent('mp-crypto:Rebooting', true, Config.Exchange.RebootInfo.percentage)
			else
				Config.Exchange.RebootInfo.percentage = 0
				Config.Exchange.RebootInfo.state = false
				TriggerServerEvent('mp-crypto:Rebooting', false, 0)
			end
			Wait(1200)
		end
	end)
end

local function ConnectUSB()
    if QBCore.Functions.HasItem('cryptostick', 1) then
        QBCore.Functions.Progressbar('connecting-usb', 'Connecting Crypto Stick', 5000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
            animDict = 'mp_prison_break',
            anim = 'hack_loop',
            flags = 16,
        }, {}, {}, function() -- Play When Done
            QBCore.Functions.Progressbar('connecting-usb', 'Booting Up CryptoMiner.exe', 5000, false, true, { -- Name | Label | Time | useWhileDead | canCancel
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {
                animDict = 'mp_prison_break',
                anim = 'hack_loop',
                flags = 16,
            }, {}, {}, function() -- Play When Done
                if Config.Hack == 'boostinghack' then
                    local success = exports['boostinghack']:StartHack()
                    if success then
                        ExchangeSuccess()
                    else
                        ExchangeFail()
                    end
                elseif Config.Hack == 'ps-ui' then
                    exports['ps-ui']:Scrambler(function(success)
                        if success then
                            ExchangeSuccess()
                        else
                            ExchangeFail()
                        end
                    end, "numeric", 30, 0) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
                end
            end, function()
                QBCore.Functions.Notify('Cancelled', 'error', 7500)
                ClearPedTasks(PlayerPedId())
            end)
        end, function()
            QBCore.Functions.Notify('Cancelled', 'error', 7500)
            ClearPedTasks(PlayerPedId())
        end)
    else
        QBCore.Functions.Notify("You don't have anything worth trading..", "error", 7500)
    end
end

-- Events

RegisterNetEvent('mp-crypto:SyncReboot', function()
	Config.Exchange.RebootInfo.state = true
	SystemCrashCooldown()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
	TriggerServerEvent('mp-crypto:GetRebootState')
end)

RegisterNetEvent('mp-crypto:GetRebootState', function(RebootInfo)
	if RebootInfo.state then
		Config.Exchange.RebootInfo.state = RebootInfo.state
		Config.Exchange.RebootInfo.percentage = RebootInfo.percentage
		SystemCrashCooldown()
	end
end)

-- Target Thread
CreateThread(function()
    if Config.Target.QB then
        exports['qb-target']:AddCircleZone("Crypto-Exchange", Config.Location.QB.coords, Config.Locations.QB.radius, {
            name = "Crypto-Exchange",
            debugPoly = Config.Debug,
            useZ = true,
        }, {
            options = {
                {
                    label = "Connect GNE Stick",
                    icon = "fas fa-laptop",
                    type = "client",
                    action = function()
                        ConnectUSB()
                    end
                },
            },
            distance = 1.0
        })
    elseif Config.Target.Ox then
        exports.ox_target:addSphereZone({
            coords = Config.Location.Ox.coords,
            radius = Config.Location.Ox.radius,
            debug = Config.Debug,
            drawSprite = true,
            options = {
                {
                    name = 'connect_usbstick',
                    label = "Connect Crypto Stick",
                    icon = "fas fa-laptop",
                    onSelect = function()
                        ConnectUSB()
                    end,
                    distance = 1.0
                },
            }
        })
    end
end)
