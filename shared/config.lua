Config = {}

-- DEBUG -- 
Config.Debug = true

Config.Exchange = {
    RebootInfo = {
        state = false,
        percentage = 0
    }
}

Config.Chance = 5 -- Number % Chance of Failure on Success

Config.Hack = 'ps-ui'

Config.Crypto = {
    Renewed = true, -- Set true for using Renewed-Phone
    QBCore = false -- Set true for using QBCore Base Crypto
}

Config.Inventory = {
    QB = false,
    Ox = true
}

Config.Target = {
    QB = false,
    Ox = true
}

Config.Location = {
    Ox = {
        coords = vec3(1276.21, -1709.88, 54.57),
        radius = 0.45 -- Radius of Sphere Zone
    },
    QB = {
        coords = vector3(1276.21, -1709.88, 54.57),
        radius = 0.45 -- Radius of Circle Zone
    }
}