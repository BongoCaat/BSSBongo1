repeat task.wait(1) until game:IsLoaded()

getgenv().Star = "⭐"
getgenv().Danger = "⚠️"
getgenv().ExploitSpecific = "📜"
getgenv().Beesmas = "🎄"

-- API CALLS

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/library.lua"))()
getgenv().api = loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/api.lua"))()
local bssapi = loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/bssapi.lua"))()
-- local kickdetector = loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/kickdetector.lua"))()
local httpreq = (syn and syn.request) or http_request or (http and http.request) or request

if not isfolder("bongkoc") then makefolder("bongkoc") end
if not isfolder("bongkoc/premium") then makefolder("bongkoc/premium") end
if not isfolder("bongkoc/plantercache") then makefolder("bongkoc/plantercache") end

-- Script temporary variables
local tweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local playerstatsevent = game:GetService("ReplicatedStorage").Events.RetrievePlayerStats
local playeractivescommand = game:GetService("ReplicatedStorage").Events.PlayerActivesCommand
local statstable = playerstatsevent:InvokeServer()
local monsterspawners = game.Workspace.MonsterSpawners
local NectarBlacklist = {}
local rarename

function rtsg()
    return playerstatsevent:InvokeServer()
end

function maskequip(mask)
    if rtsg()["EquippedAccessories"]["Hat"] == mask then return end
    game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer("Equip", {
        Mute = false,
        Type = mask,
        Category = "Accessory"
    })
end

function equiptool(tool)
    if rtsg()["EquippedCollector"] == tool then return end
    game.ReplicatedStorage.Events.ItemPackageEvent:InvokeServer("Equip", {
        Mute = true,
        Type = tool,
        Category = "Collector"
    })
end

local lasttouched = nil
local lastfieldpos = nil
local hi = false
local Items = require(game:GetService("ReplicatedStorage").EggTypes).GetTypes()
local v1 = require(game.ReplicatedStorage.ClientStatCache):Get()
local LocalPlayer=game.Players.LocalPlayer
local LChar=LocalPlayer.Character
local Humanoid=LChar:FindFirstChild("Humanoid")
local HRP = LChar:FindFirstChild("HumanoidRootPart")

repeat task.wait(0.7) until player.PlayerGui.ScreenGui:FindFirstChild("Menus")

local hives = game.Workspace.Honeycombs:GetChildren()
for i = #hives, 1, -1 do
    local hive = game.Workspace.Honeycombs:GetChildren()[i]
    if hive.Owner.Value == nil then
        game.ReplicatedStorage.Events.ClaimHive:FireServer(1)
    end
end

-- Script tables
for _, v in pairs(game:GetService("CoreGui"):GetDescendants()) do
    if v:IsA("TextLabel") and v.Text:find("Bongkoc v") then
        v.Parent.Parent:Destroy()
    end
end

getgenv().temptable = {
    version = "69",
    blackfield = "Ant Field",
    LastFieldColor = "White",
    --boostedfield = "",
    --sbready = false,
    redfields = {},
    bluefields = {},
    whitefields = {},
    shouldiconvertballoonnow = false,
    balloondetected = false,
    puffshroomdetected = false,
    magnitude = 62,
    blacklist = {"Onett"},
    running = false,
    configname = "",
    tokenpath = game.Workspace.Collectibles,
    started = {
        --fieldboost = false,
        vicious = false,
        mondo = false,
        windy = false,
	    --stickbug = false,
        ant = false,
        monsters = false,
        crab = false,
        commando = false,
    },
    detected = {vicious = false, windy = false},
    tokensfarm = false,
    converting = false,
    consideringautoconverting = false,
    honeystart = 0,
    grib = nil,
    gribpos = CFrame.new(0, 0, 0),
    honeycurrent = statstable.Totals.Honey,
    dead = false,
    float = false,
    sakatNoclip = false,
    pepsigodmode = false,
    pepsiautodig = false,
    alpha = false,
    beta = false,
    myhiveis = false,
    invis = false,
    windy = nil,
    collecting = {
        --tickets = false,
        collecthoneytoken = false
        --snowflake = false
    },
    sprouts = {detected = false, coords},
    cache = {
        autofarm = false,
        killmondo = false,
        vicious = false,
        windy = false,
        commando = false
	--killstickbug = false
    },
    allplanters = {},
    planters = {
        planter = {},
        cframe = {},
        activeplanters = {type = {}, id = {}}
    },
    monstertypes = {
        "Ladybug", "Rhino", "Spider", "Scorpion", "Mantis", "Werewolf"
    },
    ["stopapypa"] = function(path, part)
        local Closest
        for i, v in next, path:GetChildren() do
            if v.Name ~= "PlanterBulb" then
                if Closest == nil then
                    Closest = v.Soil
                else
                    if (part.Position - v.Soil.Position).magnitude <
                        (Closest.Position - part.Position).magnitude then
                        Closest = v.Soil
                    end
                end
            end
        end
        return Closest
    end,
    coconuts = {},
    glitcheds = {},
    crosshairs = {},
    bubbles = {},
    crosshair = false,
    coconut = false,
    glitched = false,
    act = 0,
    act2 = 0,
    ["touchedfunction"] = function(v)
        if lasttouched ~= v then
            if v.Parent.Name == "FlowerZones" then
                if v:FindFirstChild("ColorGroup") then
                    if tostring(v.ColorGroup.Value) == "Red" then
                        maskequip("Demon Mask")
                    elseif tostring(v.ColorGroup.Value) == "Blue" then
                        maskequip("Diamond Mask")
                    end
                else
                    maskequip("Gummy Mask")
                end
                lasttouched = v
            end
        end
    end,
    runningfor = 0,
    oldtool = rtsg()["EquippedCollector"],
    ["gacf"] = function(part, st)
        coordd = CFrame.new(part.Position.X, part.Position.Y + st, part.Position.Z)
        return coordd
    end,
    ["feed"] = function(x, y, type, amount)
        if not amount then
            amount = 1
        end
        local bo = tonumber(x)
        local ba = tonumber(y)
        local be = type
        local br = tonumber(amount)

        game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg:InvokeServer(bo, ba, be, br)
    end,
    lookat = nil,
    currtool = rtsg()["EquippedCollector"],
    starttime = tick(),
    planting = false,
    crosshaircounter = 0,
    doingbubbles = false,
    doingcrosshairs = false,
    pollenpercentage = 0,
    lastmobkill = 0,
    usegumdropsforquest = false,
    lastgumdropuse = tick(),
    autox4glitter = isfile("bongkoc/plantercache/x4.file") and tonumber(readfile("bongkoc/plantercache/x4.file")) or 1
}
local planterst = {plantername = {}, planterid = {}}

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == "table" then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

for i, v in next, temptable.blacklist do
    if v == api.nickname then
        player:Kick("You're blacklisted!")
    end
end
if temptable.honeystart == 0 then temptable.honeystart = statstable.Totals.Honey end

for i, v in next, monsterspawners:GetDescendants() do
    if v.Name == "TimerAttachment" then v.Name = "Attachment" end
end
for i, v in next, monsterspawners:GetChildren() do
    if v.Name == "RoseBush" then
        v.Name = "ScorpionBush"
    elseif v.Name == "RoseBush2" then
        v.Name = "ScorpionBush2"
    end
end
for i, v in next, game.Workspace.FlowerZones:GetChildren() do
    if v:FindFirstChild("ColorGroup") then
        if v:FindFirstChild("ColorGroup").Value == "Red" then
            table.insert(temptable.redfields, v.Name)
        elseif v:FindFirstChild("ColorGroup").Value == "Blue" then
            table.insert(temptable.bluefields, v.Name)
        end
    else
        table.insert(temptable.whitefields, v.Name)
    end
end
local flowertable = {}
for _, z in next, game.Workspace.Flowers:GetChildren() do
    table.insert(flowertable, z.Position)
end
local masktable = {}
for _, v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do
    if string.match(v.Name, "Mask") then table.insert(masktable, v.Name) end
end
local collectorstable = {}
for _, v in next, getupvalues(
                require(game:GetService("ReplicatedStorage").Collectors).Exists) do
    for e, r in next, v do table.insert(collectorstable, e) end
end
local beestable = {}
for _, v in next, game:GetService("ReplicatedStorage").BeeModels:GetChildren() do
    table.insert(beestable, v.Name)
end
--[[local mutatable = {}
for _, v in next, game:GetService("ReplicatedStorage").BeeStats.BeeMutations:GetChildren() do
    table.insert(mutatable, v.Name)
end]]
local fieldstable = {}
for _, v in next, game.Workspace.FlowerZones:GetChildren() do
    table.insert(fieldstable, v.Name)
end
local toystable = {}
for _, v in next, game.Workspace.Toys:GetChildren() do
    table.insert(toystable, v.Name)
end
local spawnerstable = {}
for _, v in next, monsterspawners:GetChildren() do
    table.insert(spawnerstable, v.Name)
end
local accesoriestable = {}
for _, v in next, game:GetService("ReplicatedStorage").Accessories:GetChildren() do
    if v.Name ~= "UpdateMeter" then table.insert(accesoriestable, v.Name) end
end
for i, v in pairs(getupvalues(require(game:GetService("ReplicatedStorage").PlanterTypes).GetTypes)) do
    for e, z in pairs(v) do 
        table.insert(temptable.allplanters, e)
    end
end
local donatableItemsTable = {}
local treatsTable = {}
for i, v in pairs(Items) do
    if v.DonatableToWindShrine == true then
        table.insert(donatableItemsTable, i)
    end
end
for i, v in pairs(Items) do if v.TreatValue then table.insert(treatsTable, i) end end
local buffTable = {
    ["Blue Extract"] = {b = false, DecalID = "2495936060"},
    ["Red Extract"] = {b = false, DecalID = "2495935291"},
    ["Oil"] = {b = false, DecalID = "2545746569"},
    ["Enzymes"] = {b = false, DecalID = "2584584968"},
    ["Glue"] = {b = false, DecalID = "2504978518"},
    ["Glitter"] = {b = false, DecalID = "2542899798"},
    ["Tropical Drink"] = {b = false, DecalID = "3835877932"},
    ["Purple Potion"] = {b = false, DecalID = "4935580111"},
    ["Snowflake"] = {b = false, DecalID = "6087969886"},
    ["Jelly Beans"] = {b = false, DecalID = "3080740120"}
}

--[[local fieldboostTable = {
	["Mushroom Field"] = {b = false, DecalID = "2908769124"};
	["Pineapple Patch"] = {b = false, DecalID = "2908769153"};
	["Blue Flower Field"] = {b = false, DecalID = "2908768899"};
	["Sunflower Field"] = {b = false, DecalID = "2908769405"};
	["Bamboo Field"] = {b = false, DecalID = "2908768829"};
	["Spider Field"] = {b = false, DecalID = "2908769301"};
	["Stump Field"] = {b = false, DecalID = "2908769372"};
	["Mountain Top Field"] = {b = false, DecalID = "2908769086"};
	["Pine Tree Forest"] = {b = false, DecalID = "2908769190"};
	["Rose Field"] = {b = false, DecalID = "2908818982"};
	["Pepper Patch"] = {b = false, DecalID = "3835712489"};
	["Cactus Field"] = {b = false, DecalID = "2908768937"};
	["Coconut Field"] = {b = false, DecalID = "2908769010"};
	["Clover Field"] = {b = false, DecalID = "2908768973"};
	["Strawberry Field"] = {b = false, DecalID = "2908769330"};
	["Pumpkin Patcht"] = {b = false, DecalID = "2908769220"};
}]]

npctable = {
	["Black Bear"] = CFrame.new(-258.1, 5, 299.7),
	["Brown Bear"] = CFrame.new(282, 46, 236),
	["Bucko Bee"] = CFrame.new(302, 62, 105),
	["Honey Bee"] = CFrame.new(-455.6, 103.8, -224.2),
	["Panda Bear"] = CFrame.new(106.3, 35, 50.1),
	["Polar Bear"] = CFrame.new(-106, 119, -77),
	["Riley Bee"] = CFrame.new(-361, 74, 212),
	["Science Bear"] = CFrame.new(267, 103, 20),
	["Mother Bear"] = CFrame.new(-183.8, 4.6, 87.5),
	["Sun Bear"] = CFrame.new(23.25, 14, 360.26),
	["Spirit Bear"] = CFrame.new(-365, 99, 479),
	["Stick Bug"] = CFrame.new(-128, 51, 147),
	["Onett"] = CFrame.new(-8.4, 234, -517.9),
	["Gummy Lair"] = CFrame.new(273, 25261, -745),
	["Bubble Bee Man"] = CFrame.new(89, 312, -278),
	["Meteor Shower"] = CFrame.new(160, 127, -160),
	["Demon Mask"] = CFrame.new(300, 13, 272),
	["Diamond Mask"] = CFrame.new(-336, 132, -385)
}

local AccessoryTypes = require(game:GetService("ReplicatedStorage").Accessories).GetTypes()
local MasksTable = {}
for i, v in pairs(AccessoryTypes) do
    if tostring(i):find("Mask") then
        if i ~= "Honey Mask" then table.insert(MasksTable, i) end
    end
end

local DropdownMutationTable = {
    "Convert Amount",
    "Gather Amount",
    "Ability Rate",
    "Attack",
    "Energy"
}

local DropdownTreatsTable = {
    "Treat",
    "SunflowerSeed",
    "Blueberry",
    "Strawberry",
    "Bitterberry",
    "Pineapple",
    "GingerbreadBear"
}

local DropdownPlanterTable = {
    "Paper Planter",
    "Ticket Planter",
    "Plastic Planter",
    "Candy Planter",
    "Red Clay Planter",
    "Blue Clay Planter",
    "Tacky Planter",
    "Hydroponic Planter",
    "Heat-Treated Planter",
    "Pesticide Planter",
    "Petal Planter",
    "Festive Planter",
    "The Planter Of Plenty",
    "None"
}
local DropdownFieldsTable = deepcopy(fieldstable)
for i,v in pairs(DropdownFieldsTable) do
    if v == "Ant Field" then
        table.remove(DropdownFieldsTable, i)
    end
end
table.insert(DropdownFieldsTable, "None")

table.sort(fieldstable)
table.sort(accesoriestable)
table.sort(toystable)
table.sort(spawnerstable)
table.sort(masktable)
table.sort(temptable.allplanters)
table.sort(collectorstable)
table.sort(beestable)
--table.sort(mutatable)
table.sort(treatsTable)
table.sort(donatableItemsTable)
table.sort(buffTable)
table.sort(MasksTable)

task.spawn(function()
    while task.wait() do
        if getgenv().temptable.sakatNoclip then
            Humanoid:ChangeState(11);
        end
    end
end)

-- float pad

local floatpad = Instance.new("Part", game.Workspace)
floatpad.CanCollide = false
floatpad.Anchored = true
floatpad.Transparency = 1
floatpad.Name = "FloatPad"

-- cococrab

local cocopad = Instance.new("Part", game.Workspace)
cocopad.Name = "Coconut Part"
cocopad.Anchored = true
cocopad.Transparency = 1
cocopad.Size = Vector3.new(135, 1, 100)
cocopad.CanCollide = false
cocopad.Position = Vector3.new(-265.52117919922, 105.91863250732, 480.86791992188)

-- cocowall

local cocowall = Instance.new("Part", game.Workspace)
cocowall.Name = "Coconut Wall"
cocowall.Anchored = true
cocowall.Transparency = 1
cocowall.Size = Vector3.new(153, 14, 1)
cocowall.Position = Vector3.new(-270, 69, 424)

-- commandopad

local commandopad = Instance.new("Part", game.Workspace)
commandopad.Name = "Commando Part"
commandopad.Anchored = true
commandopad.Transparency = 1
commandopad.Size = Vector3.new(90,1,90)
commandopad.Position = Vector3.new(520.768, 57.47, 161.651)

-- cactuswall

local cactuswall = Instance.new("Part", game.Workspace)
cactuswall.Name = "Cactus Wall"
cactuswall.Anchored = true
cactuswall.Transparency = 1
cactuswall.Size = Vector3.new(15, 14, 1)
cactuswall.Position = Vector3.new(-262, 68, -65)

local cactuswall1 = Instance.new("Part", game.Workspace)
cactuswall1.Name = "Cactus Wall 1"
cactuswall1.Anchored = true
cactuswall1.Transparency = 1
cactuswall1.Size = Vector3.new(110, 14, 1)
cactuswall1.Position = Vector3.new(-170, 67, -64)

-- mountainwall

local mountainwall = Instance.new("Part", game.Workspace)
mountainwall.Name = "Mountain Wall"
mountainwall.Anchored = true
mountainwall.Transparency = 1
mountainwall.Size = Vector3.new(1, 14, 118)
mountainwall.Position = Vector3.new(127, 174, -156)

-- pop
local popfolder = Instance.new("Folder", game:GetService("Workspace").Particles)
popfolder.Name = "PopStars"

-- antfarm

local antpart = Instance.new("Part", workspace)
antpart.Name = "Ant Autofarm Part"
antpart.Position = Vector3.new(96, 47, 553)
antpart.Anchored = true
antpart.Size = Vector3.new(128, 1, 50)
antpart.Transparency = 1
antpart.CanCollide = false

-- config

--[[stickbug_time = time()
sbfirstcheck = false
chk5min_tiime = time()]]

getgenv().bongkoc = {
    rares = {},
    priority = {},
    bestfields = {
        red = "Pepper Patch",
        white = "Coconut Field",
        blue = "Stump Field"
    },
    blacklistedfields = {},
    killerbongkoc = {},
    bltokens = {},
    toggles = {
        autofarm = false,
        farmclosestleaf = false,
        farmfireflies = false,
        farmleaves = false,
        farmsparkles = false,
        farmbubbles = false,
        autodig = false,
        farmrares = false,
	    farmtickets = false,
        --rgbui = false,
        farmflower = false,
        farmfuzzy = false,
        farmcoco = false,
        farmflame = false,
        farmclouds = false,
        killmondo = false,
        killvicious = false,
        loopspeed = false,
        loopjump = false,
        autoquest = false,
        autoboosters = false,
        autodispense = false,
        clock = false,
        freeantpass = false,
        freerobopass = false,
        honeystorm = false,
        meteorshower = false,
        summonfreestickbug = false,
        autospawnsprout = false,
        autodoquest = false,
        --disableseperators = false,
        npctoggle = false,
        loopfarmspeed = false,
        mobquests = false,
        traincrab = false,
        traincommando = false,
        avoidmobs = false,
        farmsprouts = false,
        enabletokenblacklisting = false,
        farmunderballoons = false,
        farmsnowflakes = false,
        collectgingerbreads = false,
        collectcrosshairs = false,
        farmpuffshrooms = false,
        tptonpc = false,
        donotfarmtokens = false,
        convertballoons = false,
        autostockings = false,
        autosnowmachine = false,
        autosamovar = false,
        autoonettart = false,
        autocandles = false,
        autofeast = false,
        autohoneywreath = false,
        autoplanters = false,
        autokillmobs = false,
        autoant = false,
        autousestinger = false,
        killwindy = false,
        godmode = false,
        disableconversion = false,
	    disablerender = false,
        visualnight = false,
        bloatfarm = false,
        farmglitchedtokens = false,
        autodonate = false,
	    --instantconverters = false,
        autouseconvertors = false,
        honeymaskconv = false,
        --farmboostedfield = false,
	    --killstickbug = false,
        resetbeenergy = false,
        enablestatuspanel = false,
        autoequipmask = false,
        followplayer = false,
        buckobeequests = false,
        brownbearquests = false,
        rileybeequests = false,
        polarbearquests = false,
        blackbearquests = false,
        allquests = false,
        blacklistinvigorating = false,
        blacklistcomforting = false,
        blacklistmotivating = false,
        blacklistrefreshing = false,
        blacklistsatisfying = false,
        paperplanter = false,
        ticketplanter = false,
        plasticplanter = false,
        candyplanter = false,
        redclayplanter = false,
        blueclayplanter = false,
        tackyplanter = false,
        hydroponicplanter = false,
        heattreatedplanter = false,
        pesticideplanter = false,
        petalplanter = false,
        festiveplanter = false,
        shutdownkick = false,
        webhookupdates = false,
        webhookping = false,
        autoquesthoneybee = false,
        buyantpass = false,
        --tweenteleport = false,
        docustomplanters = false,
        fastcrosshairs = false,
        smartmobkill = false,
        ["autouseBlue Extract"] = false,
        ["autouseRed Extract"] = false,
        ["autouseOil"] = false,
        ["autouseEnzymes"] = false,
        ["autouseGlue"] = false,
        ["autouseGlitter"] = false,
        ["autousePurple Potion"] = false,
        ["autouseSnowflake"] = false,
        ["autouseJelly Beans"] = false,
        usegumdropsforquest = false,
        autox4 = false,
        newtokencollection = false,
        usbtoggle = false,
        ugb = false,
        af = false,
        umb = false
    },
    vars = {
        field = "Stump Field",
        convertat = 100,
        farmspeed = 60,
        prefer = "Tokens",
        walkspeed = 70,
        jumppower = 70,
        npcprefer = "All Quests",
        --farmtype = "Walk",
        monstertimer = 3,
        autodigmode = "Normal",
        donoItem = "Coconut",
        donoAmount = 1,
        selectedTreat = "Treat",
        selectedTreatAmount = 1,
        autouseMode = "Just Tickets",
        autoconvertWaitTime = 10,
        defmask = "Bubble",
        deftool = "Petal Wand",
        resettimer = 3,
        questcolorprefer = "Any NPC",
        playertofollow = "",
        usb = "",
        --foodtype = "Treat",
        mutation = "Ability Rate",
        convertballoonpercent = 50,
        planterharvestamount = 75,
        webhookurl = "",
        discordid = 0,
        webhooktimer = 60,
        customplanter11 = "",
        customplanter12 = "",
        customplanter13 = "",
        customplanter14 = "",
        customplanter15 = "",
        customplanter21 = "",
        customplanter22 = "",
        customplanter23 = "",
        customplanter24 = "",
        customplanter25 = "",
        customplanter31 = "",
        customplanter32 = "",
        customplanter33 = "",
        customplanter34 = "",
        customplanter35 = "",
        customplanterfield11 = "",
        customplanterfield12 = "",
        customplanterfield13 = "",
        customplanterfield14 = "",
        customplanterfield15 = "",
        customplanterfield21 = "",
        customplanterfield22 = "",
        customplanterfield23 = "",
        customplanterfield24 = "",
        customplanterfield25 = "",
        customplanterfield31 = "",
        customplanterfield32 = "",
        customplanterfield33 = "",
        customplanterfield34 = "",
        customplanterfield35 = "",
        customplanterdelay11 = 75,
        customplanterdelay12 = 75,
        customplanterdelay13 = 75,
        customplanterdelay14 = 75,
        customplanterdelay21 = 75,
        customplanterdelay22 = 75,
        customplanterdelay23 = 75,
        customplanterdelay24 = 75,
        customplanterdelay25 = 75,
        customplanterdelay31 = 75,
        customplanterdelay32 = 75,
        customplanterdelay33 = 75,
        customplanterdelay34 = 75,
        customplanterdelay35 = 75
    },
    beessettings = {
        general = {
            x = 1,
            y = 1,
            amount = 3
        },
    },
    dispensesettings = {
        blub = false,
        straw = false,
        treat = false,
        coconut = false,
        glue = false,
        rj = false,
        white = false,
        red = false,
        blue = false
    }
}

local defaultbongkoc = bongkoc

-- functions

local function addcommas(num)
    local str = tostring(num):reverse():gsub("(%d%d%d)", "%1,"):reverse()
    if str:sub(1,1) == "," then
        str = str:sub(2)
    end
    return str
end

local function truncatetime(sec)
    local second = tostring(sec%60)
    local minute = tostring(math.floor(sec / 60 - math.floor(sec / 3600) * 60))
    local hour = tostring(math.floor(sec / 3600))
    
    return (#hour == 1 and "0"..hour or hour)..":"..(#minute == 1 and "0"..minute or minute)..":"..(#second == 1 and "0"..second or second)
end

local function truncate(num)
    num = tonumber(math.round(num))
    if num <= 0 then
        return 0
    end
    local savenum = ""
    local i = 0
    local suff = ""
    local suffixes = {"k","M","B","T","qd","Qn","sx","Sp","O","N"}
    local length = math.floor(math.log10(num)+1)
    while num > 999 do
        i = i + 1
        suff = suffixes[i] or "???"
        num = num/1000
        savenum = (math.floor(num*100)/100)..suff
    end
    if i == 0 then
        return num
    end
    return savenum
end

local function disconnected(hook, discordid, reason)
    if not discordid then discordid = "0" end

    local timepassed = math.round(tick() - temptable.starttime)
    local honeygained = temptable.honeycurrent - temptable.honeystart

    local totalhoneystring = addcommas(temptable.honeycurrent).." ("..truncate(temptable.honeycurrent)..")"
    local honeygainedstring = addcommas(honeygained).." ("..truncate(honeygained)..")"
    local honeyperhourstring = addcommas(math.floor(honeygained / timepassed) * 3600).." ("..truncate(math.floor(honeygained / timepassed) * 3600)..") Honey"
    local uptimestring = truncatetime(timepassed)
    local data = {
        ["username"] = player.Name,
        ["avatar_url"] = "https://www.roblox.com/HeadShot-thumbnail/image?userId="..tostring(player.UserId).."&width=420&height=420&format=png",
        ["content"] = "<@"..tostring(discordid).."> "..(reason == "Server Timeout (Game Freeze)" and "Freeze" or "Kick"),
        ["embeds"] = {{
            ["title"] = "**Disconnect Detected**",
            --["description"] = "description",
            ["type"] = "rich",
            ["color"] = tonumber(0xfff802),
            ["fields"] = {
                {
                    ["name"] = "Reason:",
                    ["value"] = reason,
                    ["inline"] =  false
                },
                {
                    ["name"] = "Total Honey:",
                    ["value"] = totalhoneystring,
                    ["inline"] =  false
                },
                {
                    ["name"] = "Session Honey:",
                    ["value"] = honeygainedstring,
                    ["inline"] =  true
                },
                {
                    ["name"] = "Session Uptime:",
                    ["value"] = uptimestring,
                    ["inline"] =  true
                },
                {
                    ["name"] = "Session Honey Per Hour:",
                    ["value"] = honeyperhourstring,
                    ["inline"] =  true
                },
            },
            ["footer"] = {
                ["text"] = os.date("%x").." • "..os.date("%I")..":"..os.date("%M")..":"..os.date("%S").." "..os.date("%p")
            }
        }}
    }
    local headers = {
        ["content-Type"] = "application/json"
    }
    httpreq({Url = hook, Body = game:GetService("HttpService"):JSONEncode(data), Method = "POST", Headers = headers})
end

local function hourly(ping, hook, discordid)
    if not discordid then discordid = "0" end

    local timepassed = math.round(tick() - temptable.starttime)
    local honeygained = temptable.honeycurrent - temptable.honeystart

    local totalhoneystring = addcommas(temptable.honeycurrent).." ("..truncate(temptable.honeycurrent)..")"
    local honeygainedstring = addcommas(honeygained).." ("..truncate(honeygained)..")"
    local honeyperhourstring = addcommas(math.floor(honeygained / timepassed) * 3600).." ("..truncate(math.floor(honeygained / timepassed) * 3600)..") Honey"
    local uptimestring = truncatetime(timepassed)
    
    local data = {
        ["username"] = player.Name,
        ["avatar_url"] = "https://www.roblox.com/HeadShot-thumbnail/image?userId="..tostring(player.UserId).."&width=420&height=420&format=png",
        ["content"] = ping and "<@"..tostring(discordid).."> ".."Honey Update" or "Honey Update",
        ["embeds"] = {{
            ["title"] = "**Honey Update**",
            ["type"] = "rich",
            ["color"] = tonumber(0xfff802),
            ["fields"] = {
                {
                    ["name"] = "Total Honey:",
                    ["value"] = totalhoneystring,
                    ["inline"] =  false
                },
                {
                    ["name"] = "Session Honey:",
                    ["value"] = honeygainedstring,
                    ["inline"] =  true
                },
                {
                    ["name"] = "Session Uptime:",
                    ["value"] = uptimestring,
                    ["inline"] =  true
                },
                {
                    ["name"] = "Session Honey Per Hour:",
                    ["value"] = honeyperhourstring,
                    ["inline"] =  true
                },
            },
            ["footer"] = {
                ["text"] = os.date("%x").." • "..os.date("%I")..":"..os.date("%M")..":"..os.date("%S").." "..os.date("%p")
            }
        }}
    }
    local headers = {
        ["content-Type"] = "application/json"
    }
    httpreq({Url = hook, Body = game:GetService("HttpService"):JSONEncode(data), Method = "POST", Headers = headers})
end

function findFieldWithRay(pos, dir)
    local ray = Ray.new(pos, dir)
    local part, position = workspace:FindPartOnRayWithWhitelist(ray, {game:GetService("Workspace").FlowerZones})
    if part then
        return part
    end
end

local function findField(position)
    if not position then return nil end
    
    for _,v in pairs(game.Workspace.FlowerZones:GetChildren()) do
        local fieldPos = v.CFrame.p
        local fieldSize = v.Size + Vector3.new(0, 30, 0)
        if position.X > fieldPos.X - fieldSize.X/2 and position.X < fieldPos.X + fieldSize.X/2 then
            if position.Z > fieldPos.Z - fieldSize.Z/2 and position.Z < fieldPos.Z + fieldSize.Z/2 then
                if position.Y > fieldPos.Y - fieldSize.Y/2 and position.Y < fieldPos.Y + fieldSize.Y/2 then
                    return v
                end
            end
        end
    end
    
    return nil
end

function statsget()
    local StatCache = require(game.ReplicatedStorage.ClientStatCache)
    local stats = StatCache:Get()
    return stats
end

function farm(trying, important)
    if not IsToken(trying) then return end
    if important and bongkoc.toggles.bloatfarm and temptable.foundpopstar then temptable.float = false api.teleport(CFrame.new(trying.CFrame.Position) * CFrame.Angles(0, math.rad(180), 0)) end
    if bongkoc.toggles.loopfarmspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = bongkoc.vars.farmspeed end
        api.humanoid():MoveTo(trying.Position)
    repeat task.wait() until (trying.Position - api.humanoidrootpart().Position).magnitude <= 4 or not IsToken(trying) or not temptable.running
end

function farmold(trying, important)
    if bongkoc.toggles.loopfarmspeed then game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = bongkoc.vars.farmspeed end
        api.humanoid():MoveTo(trying.Position)
    repeat task.wait() until (trying.Position - api.humanoidrootpart().Position).magnitude <= 4 or not IsToken(trying) or not temptable.running
end

function disableall()
    if bongkoc.toggles.autofarm and not temptable.converting then
        temptable.cache.autofarm = true
        bongkoc.toggles.autofarm = false
    end
    if bongkoc.toggles.killmondo and not temptable.started.mondo then
        bongkoc.toggles.killmondo = false
        temptable.cache.killmondo = true
    end
    if bongkoc.toggles.killvicious and not temptable.started.vicious then
        bongkoc.toggles.killvicious = false
        temptable.cache.vicious = true
    end
    if bongkoc.toggles.killwindy and not temptable.started.windy then
        bongkoc.toggles.killwindy = false
        temptable.cache.windy = true
    end
    if bongkoc.toggles.traincommando and not temptable.started.commando then
        bongkoc.toggles.traincommando = false
        temptable.cache.commando = true
    end
    --[[if bongkoc.toggles.killstickbug and not temptable.started.stickbug then 
	    bongkoc.toggles.killstickbug = false 
	    temptable.cache.killstickbug = true 
    end]]
end

function enableall()
    if temptable.cache.autofarm then
        bongkoc.toggles.autofarm = true
        temptable.cache.autofarm = false
    end
    if temptable.cache.killmondo then
        bongkoc.toggles.killmondo = true
        temptable.cache.killmondo = false
    end
    if temptable.cache.vicious then
        bongkoc.toggles.killvicious = true
        temptable.cache.vicious = false
    end
    if temptable.cache.windy then
        bongkoc.toggles.killwindy = true
        temptable.cache.windy = false
    end
    if temptable.cache.commando then
        bongkoc.toggles.traincommando = true
        temptable.cache.commando = false
    end
    --[[if temptable.cache.killstickbug then 
	    bongkoc.toggles.killstickbug = true 
	    temptable.cache.killstickbug = false
    end]]
end

function gettoken(v3, farmclosest)
    if bongkoc.toggles.bloatfarm and temptable.foundpopstar or temptable.doingcrosshairs then return end
    if not v3 then v3 = fieldposition end
    task.wait()
    if farmclosest then
        for i=0,10 do
            local closesttoken = {}
            for e, r in next, game.Workspace.Collectibles:GetChildren() do
                if r:FindFirstChild("farmed") then continue end
                itb = false
                if r:FindFirstChildOfClass("Decal") and bongkoc.toggles.enabletokenblacklisting then
                    if api.findvalue(bongkoc.bltokens, string.split(r:FindFirstChildOfClass("Decal").Texture, "rbxassetid://")[2]) then
                        itb = true
                    end
                end
                if not itb and findField(r.Position) == findField(api.humanoidrootpart().Position) then
                    if closesttoken.Distance then
                        if (r.Position - api.humanoidrootpart().Position).magnitude < closesttoken.Distance then
                            closesttoken = {Token = r, Distance = (r.Position - api.humanoidrootpart().Position).magnitude}
                        end
                    else
                        closesttoken = {Token = r, Distance = (r.Position - api.humanoidrootpart().Position).magnitude}
                    end
                end
            end
            if closesttoken.Token then
                farm(closesttoken.Token)
                local farmed = Instance.new("BoolValue", closesttoken.Token)
                farmed.Name = "farmed"
                task.spawn(function()
                    task.wait(0.95)
                    if closesttoken.Token and closesttoken.Token.Parent then
                        farmed.Parent = nil
                    end
                end)
            end
        end
    else
        for e, r in next, game.Workspace.Collectibles:GetChildren() do
            itb = false
            if r:FindFirstChildOfClass("Decal") and bongkoc.toggles.enabletokenblacklisting then
                if api.findvalue(bongkoc.bltokens, string.split(r:FindFirstChildOfClass("Decal").Texture, "rbxassetid://")[2]) then
                    itb = true
                end
            end
            if tonumber((r.Position - api.humanoidrootpart().Position).magnitude) <= temptable.magnitude / 1.4 and not itb and (v3 - r.Position).magnitude <= temptable.magnitude then
                farm(r)
            end
        end
    end
end

function makesprinklers(position, onlyonesprinkler)
    local sprinkler = rtsg().EquippedSprinkler
    local sprinklercount = 1
    local sprinklermodel = game.Workspace.Gadgets:FindFirstChild(sprinkler)

    if sprinkler == "The Supreme Saturator" then
        if sprinklermodel then
            if (sprinklermodel.Base.CFrame.p - position).magnitude > 32 then
                playeractivescommand:FireServer({["Name"] = "Sprinkler Builder"})
            end
        else
            playeractivescommand:FireServer({["Name"] = "Sprinkler Builder"})
        end
        return
    end
    
    if sprinkler == "Basic Sprinkler" or onlyonesprinkler then
        sprinklercount = 1
    elseif sprinkler == "Silver Soakers" then
        sprinklercount = 2
    elseif sprinkler == "Golden Gushers" then
        sprinklercount = 3
    elseif sprinkler == "Diamond Drenchers" then
        sprinklercount = 4
    end

    for i = 1, sprinklercount do
        if api.humanoid() then
            local k = api.humanoid().JumpPower
            if sprinklercount ~= 1 then
                api.humanoid().JumpPower = 70
                api.humanoid().Jump = true
                task.wait(.2)
            end
            playeractivescommand:FireServer({["Name"] = "Sprinkler Builder"})
            if sprinklercount ~= 1 then
                api.humanoid().JumpPower = k
                task.wait(1)
            end
        end
    end
end

function domob(place)
    if place:FindFirstChild("Territory") then
        local timestamp = tick()
        local secondstamp = tick()
        local monsterpart = place.Territory.Value

        if place.Name:match("Werewolf") then
            monsterpart = game:GetService("Workspace").Territories.WerewolfPlateau.w
        elseif place.Name:match("Mushroom") then
            monsterpart = game:GetService("Workspace").Territories.MushroomZone.Part
        end

        local point = Vector3.new((place.CFrame.p.X + monsterpart.CFrame.p.X) / 2, monsterpart.CFrame.p.Y, (place.CFrame.p.Z + monsterpart.CFrame.p.Z) / 2)

        if place:FindFirstChild("TimerLabel", true).Visible then
            return false
        end

        while not place:FindFirstChild("TimerLabel", true).Visible and tick() - timestamp < 25 do
            if tick() - secondstamp > 2 then
                api.humanoidrootpart().CFrame = CFrame.new(point + Vector3.new(0, 30, 0))
                api.humanoidrootpart().Velocity = Vector3.new(0, 0, 0)
                task.wait(1)
                secondstamp = tick()
            end
            task.wait()
            api.humanoidrootpart().CFrame = CFrame.new(point)
            api.humanoidrootpart().Velocity = Vector3.new(0, 0, 0)
        end

        if tick() - timestamp > 25 then
            return false
        end

        task.wait(1)
        for i = 1, 2 do
            gettoken(place.CFrame.p)
        end

        return true
    end
end

function killmobs()
    if bongkoc.toggles.smartmobkill then
        local monsternames = {
            "Mantis",
            "Scorpion",
            "Spider",
            "Werewolf",
            "Rhino",
            "Ladybug"
        }
        
        local totalmonsters = {}

        for i, v in next, player.PlayerGui.ScreenGui.Menus.Children.Quests:GetDescendants() do
            if v.Name == "Description" and v.Parent and v.Parent.Parent then
                local text = v.Text
                for _,monstername in pairs(monsternames) do
                    local monsterindex = text:find(monstername)
                    if monsterindex and not text:find("Field") and text:find("/") then
                        local totalmonstercount = text:sub(text:find("/") + 1, #text)
                        local defeatedmonstercount = text:sub(text:find(""), text:find("/") - 1)
                        totalmonsters[monstername] = totalmonsters[monstername] and totalmonsters[monstername] + totalmonstercount - defeatedmonstercount or totalmonstercount - defeatedmonstercount
                    end
                end
            end
        end

        if totalmonsters["Rhino"] and totalmonsters["Rhino"] > 0 then
            if domob(monsterspawners:FindFirstChild("Rhino Bush")) then
                totalmonsters["Rhino"] = totalmonsters["Rhino"] - 1
            end
        end
        if totalmonsters["Ladybug"] and totalmonsters["Ladybug"] > 0 then
            if domob(monsterspawners:FindFirstChild("Ladybug Bush")) then
                totalmonsters["Ladybug"] = totalmonsters["Ladybug"] - 1
            end
        end
        if totalmonsters["Rhino"] and totalmonsters["Rhino"] > 0 then
            if domob(monsterspawners:FindFirstChild("Rhino Cave 1")) then
                totalmonsters["Rhino"] = totalmonsters["Rhino"] - 1
            end
        end
        if totalmonsters["Rhino"] and totalmonsters["Rhino"] > 0 then
            if domob(monsterspawners:FindFirstChild("Rhino Cave 2")) then
                totalmonsters["Rhino"] = totalmonsters["Rhino"] - 1
            end
        end
        if totalmonsters["Rhino"] and totalmonsters["Rhino"] > 0 then
            if domob(monsterspawners:FindFirstChild("Rhino Cave 3")) then
                totalmonsters["Rhino"] = totalmonsters["Rhino"] - 1
            end
        end
        if totalmonsters["Rhino"] and totalmonsters["Rhino"] > 0 then
            if domob(monsterspawners:FindFirstChild("PineappleBeetle")) then
                totalmonsters["Rhino"] = totalmonsters["Rhino"] - 1
            end
        end
        if totalmonsters["Mantis"] and totalmonsters["Mantis"] > 0 then
            if domob(monsterspawners:FindFirstChild("PineappleMantis1")) then
                totalmonsters["Mantis"] = totalmonsters["Mantis"] - 1
            end
        end
        if totalmonsters["Spider"] and totalmonsters["Spider"] > 0 then
            domob(monsterspawners:FindFirstChild("Spider Cave"))
        end
        if totalmonsters["Ladybug"] and totalmonsters["Ladybug"] > 0 then
            if domob(monsterspawners:FindFirstChild("MushroomBush")) then
                totalmonsters["Ladybug"] = totalmonsters["Ladybug"] - 1
            end
        end
        if totalmonsters["Ladybug"] and totalmonsters["Ladybug"] > 0 then
            domob(monsterspawners:FindFirstChild("Ladybug Bush 2"))
            domob(monsterspawners:FindFirstChild("Ladybug Bush 3"))
        end
        if totalmonsters["Scorpion"] and totalmonsters["Scorpion"] > 0 then
            domob(monsterspawners:FindFirstChild("ScorpionBush")) 
            domob(monsterspawners:FindFirstChild("ScorpionBush2"))
        end
        if totalmonsters["Werewolf"] and totalmonsters["Werewolf"] > 0 then
            domob(monsterspawners:FindFirstChild("WerewolfCave"))
        end
        if totalmonsters["Mantis"] and totalmonsters["Mantis"] > 0 then
            domob(monsterspawners:FindFirstChild("ForestMantis1"))
            domob(monsterspawners:FindFirstChild("ForestMantis2"))
        end
    else
        domob(monsterspawners:FindFirstChild("Rhino Bush")) -- Clover Field
        domob(monsterspawners:FindFirstChild("Ladybug Bush")) -- Clover Field
        domob(monsterspawners:FindFirstChild("Rhino Cave 1")) -- Blue Flower Field
        domob(monsterspawners:FindFirstChild("Rhino Cave 2")) -- Bamboo Field
        domob(monsterspawners:FindFirstChild("Rhino Cave 3")) -- Bamboo Field
        domob(monsterspawners:FindFirstChild("PineappleMantis1")) -- Pineapple Field
        domob(monsterspawners:FindFirstChild("PineappleBeetle")) -- Pineapple Field
        domob(monsterspawners:FindFirstChild("Spider Cave")) -- Spider Field
        domob(monsterspawners:FindFirstChild("MushroomBush")) -- Mushroom Field
        domob(monsterspawners:FindFirstChild("Ladybug Bush 2")) -- Strawberry Field
        domob(monsterspawners:FindFirstChild("Ladybug Bush 3")) -- Strawberry Field
        domob(monsterspawners:FindFirstChild("ScorpionBush")) -- Rose Field
        domob(monsterspawners:FindFirstChild("ScorpionBush2")) -- Rose Field
        domob(monsterspawners:FindFirstChild("WerewolfCave")) -- Werewolf
        domob(monsterspawners:FindFirstChild("ForestMantis1")) -- Pine Tree Field
        domob(monsterspawners:FindFirstChild("ForestMantis2")) -- Pine Tree Field
    end
end

function IsToken(token)
    if not token then return false end
    if not token.Parent then return false end
    if token then
        if bongkoc.toggles.farmunderballoons and findclosestballoon() then
            if (findclosestballoon().BalloonRoot.Position - api.humanoidrootpart().Position).magnitude >= 30 then return false end
        end
        if token.Orientation.Z ~= 0 then return false end
        if token:FindFirstChild("FrontDecal") then
        else
            return false
        end
        if not token.Name == "C" then return false end
        if not token:IsA("Part") then return false end
        return true
    else
        return false
    end
end

function check(ok)
    if not ok then return false end
    if not ok.Parent then return false end
    return true
end

function getplanters()
    table.clear(planterst.plantername)
    table.clear(planterst.planterid)
    for i, v in pairs(debug.getupvalues(require(game:GetService("ReplicatedStorage").LocalPlanters).LoadPlanter)[4]) do
        if v.GrowthPercent == 1 and v.IsMine then
            table.insert(planterst.plantername, v.Type)
            table.insert(planterst.planterid, v.ActorID)
        end
    end
end

function getBuffTime(decalID)
    if not decalID then return 0 end
    
    for i,v in pairs(player.PlayerGui.ScreenGui:GetChildren()) do
        if v.Name == "TileGrid" then
            for j,k in pairs(v:GetChildren()) do
                if k:FindFirstChild("BG") and k.BG:FindFirstChild("Icon") then
                    if string.find(tostring(k.BG.Icon.Image), decalID) then
                        return k.BG.Bar.Size.Y.Scale
                    end
                end
            end
        end
    end

    return 0
end

function getBuffStack(decalID)
    if not decalID then return 0 end
    
    for i,v in pairs(player.PlayerGui.ScreenGui:GetChildren()) do
        if v.Name == "TileGrid" then
            for j,k in pairs(v:GetChildren()) do
                if k:FindFirstChild("BG") and k.BG:FindFirstChild("Icon") then
                    if string.find(tostring(k.BG.Icon.Image), decalID) then
                        local placeholder = k.BG.Text.Text:gsub("x", "")
                        return tonumber(placeholder) or 1
                    end
                end
            end
        end
    end

    return 0
end

function findclosestballoon()
    local root = game:GetService("Players").LocalPlayer.Character.HumanoidRootPart
    if root == nil then return end
    local studs = math.huge
    local part;
    for _, obj in next, game:GetService("Workspace").Balloons.FieldBalloons:GetChildren() do
        if obj:FindFirstChild("BalloonRoot") and obj:FindFirstChild("PlayerName") then
            if obj:FindFirstChild("PlayerName").Value == game.Players.LocalPlayer.Name then
                local distance = (root.Position - obj.BalloonRoot.Position).Magnitude
                if distance < studs then
                    studs = distance
                    part = obj
                end
            end
        end
    end
    return part
end

function farmant()
    antpart.CanCollide = true
    temptable.started.ant = true
    local anttable = {left = true, right = false}
    temptable.oldtool = rtsg()["EquippedCollector"]
    if temptable.oldtool ~= "Tide Popper" then
        equiptool("Spark Staff")
    end
    local oldmask = rtsg()["EquippedAccessories"]["Hat"]
    maskequip("Demon Mask")
    game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge")
    bongkoc.toggles.autodig = true
    local acl = CFrame.new(Vector3.new(127, 48, 547), Vector3.new(94, 51.8, 550))
    local acr = CFrame.new(Vector3.new(65, 48, 534), Vector3.new(94, 51.8, 550))
    task.wait(1)
    playeractivescommand:FireServer({
        ["Name"] = "Sprinkler Builder"
    })
    api.humanoidrootpart().CFrame = api.humanoidrootpart().CFrame + Vector3.new(0, 15, 0)
    local anttokendb = false
    task.wait(3)
    repeat
        task.wait()
        task.spawn(function()
            if not anttokendb then
                anttokendb = true
                local smallest = math.huge
                for _,token in pairs(workspace.Collectibles:GetChildren()) do
                    local decal = token:FindFirstChildOfClass("Decal")
                    if decal and decal.Texture then
                        if decal.Texture == "rbxassetid://1629547638" then
                            for _,monster in pairs(game.Workspace.Monsters:GetChildren()) do
                                if monster.Name:find("Ant") and monster:FindFirstChild("Head") then
                                    local dist = (monster.Head.CFrame.p - token.CFrame.p).magnitude
                                    if dist < smallest then
                                        smallest = dist
                                    end
                                end
                            end
                            
                            if player.Character:FindFirstChild("Humanoid") and smallest > 20 and smallest < 100 then
                                local save = api.humanoidrootpart().CFrame
                                api.humanoidrootpart().CFrame = CFrame.new(token.CFrame.p)
                                task.wait(0.5)
                                api.humanoidrootpart().CFrame = save
                                break
                            end
                        end
                    end
                end
                task.wait(1)
                anttokendb = false
            end
        end)
        for i, v in next, game.Workspace.Toys["Ant Challenge"].Obstacles:GetChildren() do
            if v:FindFirstChild("Root") then
                if (v.Root.Position - api.humanoidrootpart().Position).magnitude <= 40 and anttable.left then
                    api.humanoidrootpart().CFrame = acr
                    anttable.left = false
                    anttable.right = true
                    task.wait(0.5)
                elseif (v.Root.Position - api.humanoidrootpart().Position).magnitude <= 40 and anttable.right then
                    api.humanoidrootpart().CFrame = acl
                    anttable.left = true
                    anttable.right = false
                    task.wait(0.5)
                end
            end
        end
    until game.Workspace.Toys["Ant Challenge"].Busy.Value == false
    task.wait(1)
    if temptable.oldtool ~= "Tide Popper" then
        equiptool(temptable.oldtool)
    end
    maskequip(oldmask)
    temptable.started.ant = false
    antpart.CanCollide = false
end

function collectplanters()
    getplanters()
    for i, v in pairs(planterst.plantername) do
        if api.partwithnamepart(v, game.Workspace.Planters) and api.partwithnamepart(v, game.Workspace.Planters):FindFirstChild("Soil") then
            local soil = api.partwithnamepart(v, game.Workspace.Planters).Soil
            api.humanoidrootpart().CFrame = soil.CFrame
            game:GetService("ReplicatedStorage").Events.PlanterModelCollect:FireServer(planterst.planterid[i])
            task.wait(1)
            playeractivescommand:FireServer({["Name"] = v .. " Planter"})
            for i = 1, 5 do
                gettoken(soil.Position)
            end
            task.wait(3)
        end
    end
end

function getprioritytokens()
    task.wait()
    if temptable.running == false then
        for e, r in next, game.Workspace.Collectibles:GetChildren() do
            if r:FindFirstChildOfClass("Decal") then
                local aaaaaaaa = string.split(r:FindFirstChildOfClass("Decal").Texture, "rbxassetid://")[2]
                if aaaaaaaa ~= nil and api.findvalue(bongkoc.priority, aaaaaaaa) then
                    if r.Name == player.Name and
                        not r:FindFirstChild("got it") or tonumber((r.Position - api.humanoidrootpart().Position).magnitude) <= temptable.magnitude / 1.4 and
                        not r:FindFirstChild("got it") then
                        farm(r)
                        local val = Instance.new("IntValue", r)
                        val.Name = "got it"
                        break
                    end
                end
            end
        end
    end
end

function gethiveballoon()
    for _,balloon in pairs(game.Workspace.Balloons.HiveBalloons:GetChildren()) do
        if balloon:FindFirstChild("BalloonRoot") then
            if balloon.BalloonRoot.CFrame.p.X == player.SpawnPos.Value.p.X then
                return true
            end
        end
    end
    return false
end

local function getfurthestballoon()
    local biggest = 0
    local saveloon = nil
    local balloons = game.Workspace:FindFirstChild("Balloons")
    local root = player.Character:FindFirstChild("HumanoidRootPart")
    if balloons and root then
        for _,balloon in pairs(balloons.FieldBalloons:GetChildren()) do
            local owner = balloon:FindFirstChild("PlayerName")
            if owner then
                if owner.Value == player.Name then
                    local text = balloon.BalloonBody.GuiAttach.Gui.Bar.TextLabel.Text
                    local bar = balloon.BalloonBody.GuiAttach.Gui.Bar.FillBar
                    if bar.Parent.BackgroundTransparency == 0 and fieldposition then
                        local dist = (root.CFrame.p - balloon.BalloonBody.Position).magnitude
                        if dist > biggest and dist < 100 then
                            biggest = dist
                            saveloon = balloon
                        end
                    end
                end
            end
        end
    end
    if saveloon and fieldposition then
        return Vector3.new(saveloon.BalloonBody.Position.X, fieldposition.Y, saveloon.BalloonBody.Position.Z)
    end
    return nil
end

function converthoney()
    task.wait(0)
    if temptable.converting and not temptable.planting then
        if player.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and player.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (player.SpawnPos.Value.Position - api.humanoidrootpart().Position).magnitude > 13 then
            api.tween(2, player.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 3))
            task.wait(0.9)
            if player.PlayerGui.ScreenGui.ActivateButton.TextBox.Text ~= "Stop Making Honey" and player.PlayerGui.ScreenGui.ActivateButton.BackgroundColor3 ~= Color3.new(201, 39, 28) or (player.SpawnPos.Value.Position - api.humanoidrootpart().Position).magnitude > 13 then
                game:GetService("ReplicatedStorage").Events.PlayerHiveCommand:FireServer("ToggleHoneyMaking")
            end
            task.wait(0.1)
        end
    end
end

function closestleaf()
    for i, v in next, game.Workspace.Flowers:GetDescendants() do
        if v.Name == "Leaf Burst" and v.Parent:IsA("Part") and v.Parent then
            if temptable.running == false and tonumber((v.Position - player.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude / 1.4 then
                farm(v.Parent)
                break
            end
        else
            continue
        end
    end
end

function getfireflies()
    for i,v in pairs(workspace.NPCBees:GetChildren()) do
        if v.Name == "Firefly" and v.Velocity.Magnitude < 1.5 then
            api.humanoidrootpart().CFrame = CFrame.new(v.Position + Vector3.new(0, 2, 0))
            wait(0.15)
        end
    end
end

function getsparkles()
    for _, Object in pairs(workspace.Flowers:GetDescendants()) do
        if Object.Name == "Sparkles" and Object.Parent then
            api.humanoidrootpart().CFrame = CFrame.new(Object.Parent.Position + Vector3.new(0, 2, 0))                
            for _ = 1, 5 do
                for _, Object in pairs(api.humanoidrootpart():GetDescendants()) do
                    if Object.Name == "ClickEvent" then
                        Object:FireServer()
                    end
                end
            end
        end
    end
end

function getbubble()
    for i,v in next, game.workspace.Particles:GetChildren() do
        if string.find(v.Name, "Bubble") and temptable.running == false and tonumber((v.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude) < temptable.magnitude/1.4 then
            if temptable.foundpopstar and bongkoc.toggles.bloatfarm then
                farm(v, true)
            else
                farm(v)
            end
            break
        end
    end
end

function getballoons()
    if temptable.doingbubbles or temptable.doingcrosshairs then return end
    for i, v in next, game.Workspace.Balloons.FieldBalloons:GetChildren() do
        if v:FindFirstChild("BalloonRoot") and v:FindFirstChild("PlayerName") then
            if v:FindFirstChild("PlayerName").Value == player.Name then
                if tonumber((v.BalloonRoot.Position - api.humanoidrootpart().Position).magnitude) < temptable.magnitude / 1.4 then
                    api.walkTo(v.BalloonRoot.Position)
                end
            end
        end
    end
end

function getpuff()
    local smallest = math.huge
    local closestPuffStem
    for _,puffshroom in pairs(game.Workspace.Happenings.Puffshrooms:GetChildren()) do
        local stem = puffshroom:FindFirstChild("Puffball Stem")
        if stem and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (api.humanoidrootpart().CFrame.p - stem.CFrame.p).magnitude
            if dist < smallest then
                smallest = dist
                closestPuffStem = stem
            end
        end
    end

    if closestPuffStem then
        api.walkTo(closestPuffStem.CFrame.p)
    end
end

function doautox4()
    if temptable.autox4glitter == 1 then
        writefile("bongkoc/plantercache/x4.file", "0")
    else
        writefile("bongkoc/plantercache/x4.file", "1")
    end
end

function getflower()
    flowerrrr = flowertable[math.random(#flowertable)]
    if tonumber((flowerrrr - api.humanoidrootpart().Position).magnitude) <= temptable.magnitude / 1.4 and
        tonumber((flowerrrr - fieldposition).magnitude) <= temptable.magnitude / 1.4 then
        if temptable.running == false then
            if bongkoc.toggles.loopfarmspeed then
                player.Character.Humanoid.WalkSpeed = bongkoc.vars.farmspeed
            end
            api.walkTo(flowerrrr)
        end
    end
end

function getcloud()
    if temptable.doingbubbles or temptable.doingcrosshairs then return end
    for i, v in next, game.Workspace.Clouds:GetChildren() do
        e = v:FindFirstChild("Plane")
        if e and tonumber((e.Position - api.humanoidrootpart().Position).magnitude) < temptable.magnitude / 1.4 then
            api.walkTo(e.Position)
        end
    end
end

--[[function getglitchtoken()
    pcall(function()
        for i,v in next, game.Workspace.Camera.DupedTokens:GetChildren() do
            if v.Name == "C" and v:FindFirstChild("FrontDecal") and string.find(v.FrontDecal.Texture,"5877939956") then
                local hashed = math.random(1, 42345252)
                v.Name = tostring(hashed)
                repeat task.wait(0.1)
                api.walkTo(v.Position)
                --api.humanoidrootpart().Velocity = Vector3.new(0, 0, 0)
                --api.humanoidrootpart().CFrame = CFrame.new(v.CFrame.X, v.CFrame.Y - 14, v.CFrame.Z)
                until not game.Workspace.Camera.DupedTokens:FindFirstChild(hashed)
            end
        end
    end)
end]]

function getglitchtoken(v)
    if temptable.glitched then repeat task.wait() until not temptable.glitched end
    temptable.glitched = true
    pcall(function()
        if not temptable.converting and not temptable.started.monsters and not temptable.started.vicious and not temptable.started.windy and not bongkoc.toggles.trainsnail and not temptable.planting then
            for i,v in next, game.Workspace.Camera.DupedTokens:GetChildren() do
                if v.Name == "C" and v:FindFirstChild("FrontDecal") and string.find(v.FrontDecal.Texture,"5877939956") and not temptable.converting and not temptable.started.monsters and not temptable.started.vicious and not temptable.started.windy and not bongkoc.toggles.trainsnail then
                    local hashed = math.random(1, 42345252)
                    v.Name = tostring(hashed)
                    repeat task.wait()
                    api.walkTo(v.Position)
                    until not game.Workspace.Camera.DupedTokens:FindFirstChild(hashed)
                end
            end
        end
        task.wait()
        temptable.glitched = false
        table.remove(temptable.glitcheds, table.find(temptable.glitcheds, v))
    end)
end

function getcoco(v)
    if temptable.coconut then repeat task.wait() until not temptable.coconut end
    temptable.coconut = true
    api.tween(0.1, v.CFrame)
    repeat task.wait() api.walkTo(v.Position) until not v.Parent
    task.wait(0.06)
    --[[repeat
        task.wait()
        if setfflag then
            temptable.float = true
        end
        api.tweenNoDelay(0.1, v.CFrame)
    until not v.Parent
    if setfflag and temptable.float then temptable.float = false end]]
    temptable.coconut = false
    table.remove(temptable.coconuts, table.find(temptable.coconuts, v))
end

function getfuzzy()
    pcall(function()
        for i, v in next, game.workspace.Particles:GetChildren() do
            if v.Name == "DustBunnyInstance" and temptable.running == false and
                tonumber((v.Plane.Position - api.humanoidrootpart().Position).magnitude) < temptable.magnitude /1.4 then
                if v:FindFirstChild("Plane") then
                    farm(v:FindFirstChild("Plane"))
                    break
                end
            end
        end
    end)
end

function getflame()
    for _,v in pairs(game.Workspace.PlayerFlames:GetChildren()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and v.PF.Color.Keypoints[1].Value.G == 0 and findField(v.Position) == findField(api.humanoidrootpart().Position) then
            api.humanoid():MoveTo(v.Position)
            repeat
                task.wait()
            until (v.Position - api.humanoidrootpart().Position).magnitude <= 4 or not v or not v.Parent or not temptable.running
            return
        end
    end
end

function avoidmob()
    for i, v in next, game.Workspace.Monsters:GetChildren() do
        if v:FindFirstChild("Head") then
            if (v.Head.Position - api.humanoidrootpart().Position).magnitude < 30 and api.humanoid():GetState() ~= Enum.HumanoidStateType.Freefall then
                player.Character.Humanoid.Jump = true
            end
        end
    end
end

function getcrosshairs(v)
    if v.BrickColor ~= BrickColor.new("Lime green") and v.BrickColor ~= BrickColor.new("Flint") then
    if temptable.crosshair then repeat task.wait() until not temptable.crosshair end
    temptable.crosshair = true
    --api.walkTo(v.Position)
    repeat
        task.wait(0.085)
        api.walkTo(v.Position)
    until not v.Parent or v.BrickColor == BrickColor.new("Forest green") or v.BrickColor == BrickColor.new("Royal purple")
    task.wait(0.07)
    temptable.crosshair = false
    table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    else
        table.remove(temptable.crosshairs, table.find(temptable.crosshairs, v))
    end
end

--[[function check5minstasks()
	if not temptable.started.vicious and not temptable.started.windy and not temptable.started.stickbug then
		checksbcooldown()
		if bongkoc.toggles.autoquest and not temptable.started.stickbug then
			makequests()
		end
		if bongkoc.toggles.autoplanters and not temptable.started.stickbug then
			collectplanters()
		end
		if bongkoc.toggles.honeystorm and not temptable.started.stickbug then
			game.ReplicatedStorage.Events.ToyEvent:FireServer("Honeystorm")
		end
	end
end]]

function dobubbles()
    if bongkoc.toggles.farmpuffshrooms and game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") then return end
    if temptable.started.ant or temptable.started.vicious or temptable.converting or temptable.planting then return end

    temptable.doingbubbles = true
    local savespeed = bongkoc.vars.walkspeed
    bongkoc.vars.walkspeed = bongkoc.vars.walkspeed * 1.75

    for _,v in pairs(game.Workspace.Particles:GetChildren()) do
        if string.find(v.Name, "Bubble") and v.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and getBuffTime("5101328809") > 0.2 and (v.Position - api.humanoidrootpart().Position).magnitude < temptable.magnitude * 0.9 then
            api.humanoid():MoveTo(v.Position)
            repeat
                task.wait()
            until (v.Position - api.humanoidrootpart().Position).magnitude <= 4 or not v or not v.Parent or not temptable.running
        end
    end

    temptable.doingbubbles = false
    bongkoc.vars.walkspeed = savespeed
end

function docrosshairs()
    if bongkoc.toggles.farmpuffshrooms and game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") then return end
    if temptable.started.ant or temptable.started.vicious or temptable.converting or temptable.planting or temptable.started.monsters then return end

    local savespeed = bongkoc.vars.walkspeed

    for _,v in pairs(game.Workspace.Particles:GetChildren()) do
        if string.find(v.Name, "Crosshair") and v.Parent and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and v.BrickColor ~= BrickColor.new("Flint") then
            if bongkoc.toggles.fastcrosshairs then
                if (v.Position - api.humanoidrootpart().Position).magnitude > 200 then continue end
                if getBuffTime("8172818074") > 0.5 and getBuffStack("8172818074") > 9 and getBuffTime("5101329167") == 0 then
                    if v.BrickColor == BrickColor.new("Alder") then
                        task.wait(0.5)
                        local save_height = v.Position.y
                        repeat
                            task.wait()
                            api.humanoidrootpart().CFrame = CFrame.new(v.Position)
                        until not v or not v.Parent or v.Position.y ~= save_height
                    end
                else
                    if v.BrickColor == BrickColor.new("Red flip/flop") or v.BrickColor == BrickColor.new("Alder") then
                        repeat
                            api.humanoid():MoveTo(v.Position)
                            task.wait()
                        until (v.Position - api.humanoidrootpart().Position).magnitude <= 5 or not v or not v.Parent or v.BrickColor == BrickColor.new("Forest green") or v.BrickColor == BrickColor.new("Royal purple")
                    end
                end
            else
                if (v.Position - api.humanoidrootpart().Position).magnitude < temptable.magnitude * 0.9 then
                    temptable.doingcrosshairs = true
                    bongkoc.vars.walkspeed = savespeed * 1.75
                    api.humanoid():MoveTo(v.Position)
                    repeat
                        task.wait()
                    until (v.Position - api.humanoidrootpart().Position).magnitude <= 4 or not v or not v.Parent or v.BrickColor == BrickColor.new("Forest green") or v.BrickColor == BrickColor.new("Royal purple") or not temptable.running
                    bongkoc.vars.walkspeed = savespeed
                    temptable.doingcrosshairs = false
                end
            end
        end
    end
end

function makequests()
    for i, v in next, game.Workspace.NPCs:GetChildren() do
        if v.Name ~= "Ant Challenge Info" and v.Name ~= "Bubble Bee Man 2" and v.Name ~= "Wind Shrine" --[[and v.Name ~= "Stick Bug"]] and v.Name ~= "Gummy Bear" and v.Name ~= "Honey Bee" then
            if v:FindFirstChild("Platform") then
                if v.Platform:FindFirstChild("AlertPos") then
                    if v.Platform.AlertPos:FindFirstChild("AlertGui") then
                        if v.Platform.AlertPos.AlertGui:FindFirstChild("ImageLabel") then
                            image = v.Platform.AlertPos.AlertGui.ImageLabel
                            button = player.PlayerGui.ScreenGui.ActivateButton.MouseButton1Click
                            if image.ImageTransparency == 0 then
                                if bongkoc.toggles.tptonpc then
                                    api.humanoidrootpart().CFrame = CFrame.new(
                                        v.Platform.Position.X,
                                        v.Platform.Position.Y + 3,
                                        v.Platform.Position.Z
                                    )
                                    task.wait(1)
                                else
                                    api.tween(2, CFrame.new(
                                        v.Platform.Position.X,
                                        v.Platform.Position.Y + 3,
                                        v.Platform.Position.Z
                                    ))
                                    task.wait(3)
                                end
                                for b, z in next, getconnections(button) do
                                    z.Function()
                                end
                                task.wait(8)
                                if image.ImageTransparency == 0 then
                                    for b, z in next, getconnections(button) do
                                        z.Function()
                                    end
                                end
                                task.wait(2)
                            end
                        end
                    end
                end
            end
        end
    end
end

getgenv().Tvk1 = {true, "💖"}

local function donateToShrine(item, qnt)
    print(qnt)
    local s, e = pcall(function()
        game:GetService("ReplicatedStorage").Events.WindShrineDonation:InvokeServer(item, qnt)
        task.wait(0.5)
        game.ReplicatedStorage.Events.WindShrineTrigger:FireServer()

        local UsePlatform = game.Workspace.NPCs["Wind Shrine"].Stage
        api.humanoidrootpart().CFrame = UsePlatform.CFrame + Vector3.new(0, 5, 0)

        for i = 1, 120 do
            task.wait(0.05)
            for i, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position - UsePlatform.Position).magnitude < 60 and
                    v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
    end)
    if not s then print(e) end
end

local function isWindshrineOnCooldown()
    local isOnCooldown = false
    local cooldown = 3600 - (require(game.ReplicatedStorage.OsTime)() - (require(game.ReplicatedStorage.StatTools).GetLastCooldownTime(v1, "WindShrine")))
    if cooldown > 0 then isOnCooldown = true end
    return isOnCooldown
end

local function getTimeSinceToyActivation(name)
    return require(game.ReplicatedStorage.OsTime)() - require(game.ReplicatedStorage.ClientStatCache):Get("ToyTimes")[name]
end

local function getTimeUntilToyAvailable(n)
    return workspace.Toys[n].Cooldown.Value - getTimeSinceToyActivation(n)
end

local function canToyBeUsed(toy)
    local timeleft = tostring(getTimeUntilToyAvailable(toy))
    local canbeUsed = false
    if string.find(timeleft, "-") then canbeUsed = true end
    return canbeUsed
end

function GetItemListWithValue()
    local StatCache = require(game.ReplicatedStorage.ClientStatCache)
    local data = StatCache.Get()
    return data.Eggs
end

local function useConvertors()
    local conv = {
        "Instant Converter", "Instant Converter B", "Instant Converter C"
    }

    local lastWithoutCooldown = nil

    for i, v in pairs(conv) do
        if canToyBeUsed(v) == true then lastWithoutCooldown = v end
    end
    local converted = false
    if lastWithoutCooldown ~= nil and
        string.find(bongkoc.vars.autouseMode, "Ticket") or
        string.find(bongkoc.vars.autouseMode, "All") then
        if converted == false then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer(
                lastWithoutCooldown)
            converted = true
        end
    end
    if GetItemListWithValue()["Micro-Converter"] > 0 and 
        string.find(bongkoc.vars.autouseMode, "Micro") or 
        string.find(bongkoc.vars.autouseMode, "All") then
		playeractivescommand:FireServer({["Name"] = "Micro-Converter"})
		pollenpercentage = 0
    end
    if GetItemListWithValue()["Snowflake"] > 0 and
        string.find(bongkoc.vars.autouseMode, "Snowflake") or
        string.find(bongkoc.vars.autouseMode, "All") then
        playeractivescommand:FireServer({["Name"] = "Snowflake"})
    end
    if GetItemListWithValue()["Coconut"] > 0 and
        string.find(bongkoc.vars.autouseMode, "Coconut") or
        string.find(bongkoc.vars.autouseMode, "All") then
        playeractivescommand:FireServer({["Name"] = "Coconut"})
    end
end

--[[function fetchfieldboostTable(stats)
	local stTab = {}
	for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:GetChildren()) do
		if v.Name == "TileGrid" then
			for p,l in pairs(v:GetChildren()) do
				if l:FindFirstChild("BG") then
					if l:FindFirstChild("BG"):FindFirstChild("Icon") then
						local ic = l:FindFirstChild("BG"):FindFirstChild("Icon")
						for field,fdata in pairs(stats) do
							if fdata["DecalID"] ~= nil then
								if string.find(ic.Image,fdata["DecalID"]) then
									if ic.Parent:FindFirstChild("Text") then
										if ic.Parent:FindFirstChild("Text").Text == "" then
											stTab[field] = 1
										else
											local thing = ""
											thing = string.gsub(ic.Parent:FindFirstChild("Text").Text,"x","")
											stTab[field] = tonumber(thing)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
	return stTab
end]]

--[[function farmboostedfield()
	local boostedfields = fetchfieldboostTable(fieldboostTable)
	if next(boostedfields) == nil then
		if temptable.started.fieldboost then
			temptable.started.fieldboost = false
			fielddropdown:SetOption(temptable.boostedfield)
			bongkoc.toggles.autouseconvertors = false
		    autouseconvertors:SetState(false)
		end
	else
		if not temptable.started.fieldboost then
			temptable.started.fieldboost = true
			temptable.boostedfield = bongkoc.vars.field
			for field,lvl in pairs(boostedfields) do
				if bongkoc.vars.defmask == "Gummy Mask" then
					if api.tablefind(temptable.whitefields, fieldstable) then
						CreateDropdown:SetOption(fieldstable)
					end
				elseif bongkoc.vars.defmask == "Demon Mask" then
					if api.tablefind(temptable.redfields, fieldstable) then
						CreateDropdown:SetOption(fieldstable)
					end
				elseif bongkoc.vars.defmask == "Diamond Mask" then
					if api.tablefind(temptable.bluefields, fieldstable) then
                        CreateDropdown:SetOption(fieldstable)--fielddropdown:SetOption(fieldstable[1])
					end
				end
			end
		end
	end
	if temptable.started.fieldboost then
		if not bongkoc.toggles.autouseconvertors then
            bongkoc.toggles.autouseconvertors = true
			bongkoc.toggles.autouseconvertors:SetState(true)
		end
	end
end]]

local function fetchBuffTable(stats)
    local stTab = {}
    if player then
        if player.PlayerGui then
            if player.PlayerGui.ScreenGui then
                for i, v in pairs(player.PlayerGui.ScreenGui:GetChildren()) do
                    if v.Name == "TileGrid" then
                        for p, l in pairs(v:GetChildren()) do
                            if l:FindFirstChild("BG") then
                                if l:FindFirstChild("BG"):FindFirstChild("Icon") then
                                    local ic = l:FindFirstChild("BG"):FindFirstChild("Icon")
                                    for field, fdata in pairs(stats) do
                                        if fdata["DecalID"] ~= nil then
                                            if string.find(ic.Image, fdata["DecalID"]) then
                                                if ic.Parent:FindFirstChild("Text") then
                                                    if ic.Parent:FindFirstChild("Text").Text == "" then
                                                        stTab[field] = 1
                                                    else
                                                        local thing = ""
                                                        thing = string.gsub(ic.Parent:FindFirstChild("Text").Text, "x", "")
                                                        stTab[field] = tonumber(thing)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return stTab
end

local fullPlanterData = {
    ["Red Clay"] = {
        NectarTypes = {Invigorating = 1.2, Satisfying = 1.2},
        GrowthFields = {
            ["Pepper Patch"] = 1.25,
            ["Rose Field"] = 1.25,
            ["Strawberry Field"] = 1.25,
            ["Mushroom Field"] = 1.25
        }
    },
    ["Plenty"] = {
        NectarTypes = {
            Satisfying = 1.5,
            Comforting = 1.5,
            Invigorating = 1.5,
            Refreshing = 1.5,
            Motivating = 1.5
        },
        GrowthFields = {
            ["Mountain Top Field"] = 1.5,
            ["Coconut Field"] = 1.5,
            ["Pepper Patch"] = 1.5,
            ["Stump Field"] = 1.5
        }
    },
    ["Festive"] = {
        NectarTypes = {
            Satisfying = 3,
            Comforting = 3,
            Invigorating = 3,
            Refreshing = 3,
            Motivating = 3
        },
        GrowthFields = { }
    },
    ["Paper"] = {
        NectarTypes = {
            Satisfying = 0.75,
            Comforting = 0.75,
            Invigorating = 0.75,
            Refreshing = 0.75,
            Motivating = 0.75
        },
        GrowthFields = {}
    },
    ["Tacky"] = {
        NectarTypes = {Satisfying = 1.25, Comforting = 1.25},
        GrowthFields = {
            ["Sunflower Field"] = 1.25,
            ["Mushroom Field"] = 1.25,
            ["Dandelion Field"] = 1.25,
            ["Clover Field"] = 1.25,
            ["Blue Flower Field"] = 1.25
        }
    },
    ["Candy"] = {
        NectarTypes = {Motivating = 1.2},
        GrowthFields = {
            ["Coconut Field"] = 1.25,
            ["Strawberry Field"] = 1.25,
            ["Pineapple Patch"] = 1.25
        }
    },
    ["Hydroponic"] = {
        NectarTypes = {Refreshing = 1.4, Comforting = 1.4},
        GrowthFields = {
            ["Blue Flower Field"] = 1.5,
            ["Pine Tree Forest"] = 1.5,
            ["Stump Field"] = 1.5,
            ["Bamboo Field"] = 1.5
        }
    },
    ["Plastic"] = {
        NectarTypes = {
            Refreshing = 1,
            Invigorating = 1,
            Comforting = 1,
            Satisfying = 1,
            Motivating = 1
        },
        GrowthFields = {}
    },
    ["Ticket"] = {
        NectarTypes = {
            Refreshing = 1,
            Invigorating = 1,
            Comforting = 1,
            Satisfying = 1,
            Motivating = 1
        },
        GrowthFields = {}
    },
    ["Petal"] = {
        NectarTypes = {Satisfying = 1.5, Comforting = 1.5},
        GrowthFields = {
            ["Sunflower Field"] = 1.5,
            ["Dandelion Field"] = 1.5,
            ["Spider Field"] = 1.5,
            ["Pineapple Patch"] = 1.5,
            ["Coconut Field"] = 1.5
        }
    },
    ["Heat-Treated"] = {
        NectarTypes = {Invigorating = 1.4, Motivating = 1.4},
        GrowthFields = {
            ["Pepper Patch"] = 1.5,
            ["Rose Field"] = 1.5,
            ["Strawberry Field"] = 1.5,
            ["Mushroom Field"] = 1.5
        }
    },
    ["Blue Clay"] = {
        NectarTypes = {Refreshing = 1.2, Comforting = 1.2},
        GrowthFields = {
            ["Blue Flower Field"] = 1.25,
            ["Pine Tree Forest"] = 1.25,
            ["Stump Field"] = 1.25,
            ["Bamboo Field"] = 1.25
        }
    },
    ["Pesticide"] = {
        NectarTypes = {Motivating = 1.3, Satisfying = 1.3},
        GrowthFields = {
            ["Strawberry Field"] = 1.3,
            ["Spider Field"] = 1.3,
            ["Bamboo Field"] = 1.3
        }
    }
}

local planterData = deepcopy(fullPlanterData)

local nectarData = {
    Refreshing = {"Blue Flower Field", "Strawberry Field", "Coconut Field"},
    Invigorating = {"Clover Field", "Cactus Field", "Mountain Top Field", "Pepper Patch"},
    Comforting = {"Dandelion Field", "Bamboo Field", "Pine Tree Forest"},
    Motivating = {"Mushroom Field", "Spider Field", "Stump Field", "Rose Field"},
    Satisfying = {"Sunflower Field", "Pineapple Patch", "Pumpkin Patch"}
}

function GetPlanterData(name)
    local concaccon = require(game:GetService("ReplicatedStorage").LocalPlanters)
    local concacbo = concaccon.LoadPlanter
    local PlanterTable = debug.getupvalues(concacbo)[4]
    local tttttt = nil
    for k, v in pairs(PlanterTable) do
        if v.PotModel and v.IsMine == true and string.find(v.PotModel.Name, name) then 
            tttttt = v
        end
    end
    return tttttt
end

local fullnectardata = require(game:GetService("ReplicatedStorage").NectarTypes).GetTypes()

function fetchNectarsData()

    local ndata = {
        Refreshing = "none",
        Invigorating = "none",
        Comforting = "none",
        Motivating = "none",
        Satisfying = "none"
    }

    if game:GetService("Players").LocalPlayer then
        if game:GetService("Players").LocalPlayer.PlayerGui then
            if game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui then
                for i, v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui:GetChildren()) do
                    if v.Name == "TileGrid" then
                        for p, l in pairs(v:GetChildren()) do
                            for k, e in pairs(fullnectardata) do
                                if l:FindFirstChild("BG") then
                                    if l:FindFirstChild("BG"):FindFirstChild("Icon") then
                                        if l:FindFirstChild("BG"):FindFirstChild("Icon").ImageColor3 == e.Color then
                                            local Xsize = l:FindFirstChild("BG").Bar.AbsoluteSize.X
                                            local Ysize = l:FindFirstChild("BG").Bar.AbsoluteSize.Y
                                            local percentage = (Ysize / Xsize) * 100
                                            ndata[k] = percentage
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    return ndata
end

function isBlacklisted(nectartype, blacklist)
    local bl = false
    for i, v in pairs(blacklist) do
        if v == nectartype then
            bl = true
        end
    end
    for i, v in pairs(NectarBlacklist) do
        if v == nectartype then
            bl = true
        end
    end
    return bl
end

function calculateLeastNectar(blacklist)
    local leastNectar = nil
    local tempLeastValue = 999

    local nectarData = fetchNectarsData()
    for i, v in pairs(nectarData) do
        if not isBlacklisted(i, blacklist) then
            if v == "none" or v == nil then
                leastNectar = i
                tempLeastValue = 0
            else
                if v <= tempLeastValue then
                    tempLeastValue = v
                    leastNectar = i
                end
            end
        end
    end
    return leastNectar
end

function GetItemListWithValue()
    local StatCache = require(game.ReplicatedStorage.ClientStatCache)
    local data = StatCache.Get()
    return data.Eggs
end

function fetchBestMatch(nectartype, field)
    local bestPlanter = nil
    local bestNectarMult = 0
    local bestFieldGrowthRate = 0
    for i, v in pairs(planterData) do
        if GetItemListWithValue()[i .. "Planter"] then
            if GetItemListWithValue()[i .. "Planter"] >= 1 then
                if v.GrowthFields[field] ~= nil then
                    if v.GrowthFields[field] > bestFieldGrowthRate then
                        bestFieldGrowthRate = v.GrowthFields[field]
                        bestPlanter = i
                    end
                end
            end
        end
    end
    for i, v in pairs(planterData) do
        if GetItemListWithValue()[i .. "Planter"] then
            if GetItemListWithValue()[i .. "Planter"] >= 1 then
                if v.NectarTypes[nectartype] ~= nil then
                    if v.NectarTypes[nectartype] > bestNectarMult then
                        local totalNectarFieldGrowthMult = 0
                        if v["GrowthFields"][field] ~= nil then
                            totalNectarFieldGrowthMult = totalNectarFieldGrowthMult + (v["GrowthFields"][field])
                        end
                        bestNectarMult = (v.NectarTypes[nectartype] + totalNectarFieldGrowthMult)
                        bestPlanter = i
                    end
                end
            end
        end
    end
    return bestPlanter
end

function getPlanterLocation(plnt)
    local resultingField = "None"
    local lowestMag = math.huge
    for i, v in pairs(game:GetService("Workspace").FlowerZones:GetChildren()) do
        if (v.Position - plnt.Position).magnitude < lowestMag then
            lowestMag = (v.Position - plnt.Position).magnitude
            resultingField = v.Name
        end
    end
    return resultingField
end

function isFieldOccupied(field)
    local isOccupied = false
    local concaccon = require(game:GetService("ReplicatedStorage").LocalPlanters)
    local concacbo = concaccon.LoadPlanter
    local PlanterTable = debug.getupvalues(concacbo)[4]

    for k, v in pairs(PlanterTable) do
        if v.PotModel and v.PotModel.Parent and v.PotModel.PrimaryPart then
            if getPlanterLocation(v.PotModel.PrimaryPart) == field then
                isOccupied = true
            end
        end
    end
    return isOccupied
end

function fetchAllPlanters()
    local p = {}
    local concaccon = require(game:GetService("ReplicatedStorage").LocalPlanters)
    local concacbo = concaccon.LoadPlanter
    local PlanterTable = debug.getupvalues(concacbo)[4]

    for k, v in pairs(PlanterTable) do
        if v.PotModel and v.PotModel.Parent and v.IsMine == true then
            p[k] = v
        end
    end
    return p
end

function isNectarPending(nectartype)
    local planterz = fetchAllPlanters()
    local isPending = false
    for i, v in pairs(planterz) do
        local location = getPlanterLocation(v.PotModel.PrimaryPart)
        if location then
            local conftype = getNectarFromField(location)
            if conftype then
                if conftype == nectartype then
                    isPending = true
                end
            end
        end
    end
    return isPending
end

function fetchBestFieldWithNectar(nectar)
    local bestField = "None"
    local nectarFields = nectarData[nectar]
    local fieldPlaceholderValue = ""

    repeat
        task.wait(0.03)
        local randomField = nectarFields[math.random(1, #nectarFields)]
        if randomField then
            fieldPlaceholderValue = randomField
        end
    until not isFieldOccupied(fieldPlaceholderValue)

    bestField = fieldPlaceholderValue

    return bestField
end

function checkIfPlanterExists(pNum)
    local exists = false
    local stuffs = fetchAllPlanters()
    if stuffs ~= {} then
        for i, v in pairs(stuffs) do
            if v["ActorID"] == pNum then
                exists = true
            end
        end
    end
    return exists
end

function collectSpecificPlanter(prt, id)
    if prt then
        if player.Character then
            if player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character:FindFirstChild("HumanoidRootPart").CFrame = prt.CFrame
                task.wait(0.1)
                game:GetService("ReplicatedStorage").Events.PlanterModelCollect:FireServer(id)
            end
        end
    end
end

function RequestCollectPlanter(planter)
    if planter.PotModel and planter.PotModel.Parent and planter.ActorID then
        repeat
            task.wait(0.1)
            collectSpecificPlanter(planter.PotModel.PrimaryPart, planter.ActorID)
        until not checkIfPlanterExists(planter.ActorID)
    end
end

function RequestCollectPlanters(planterTable)
    task.spawn(function()
        local plantersToCollect = {}
        if planterTable then
            for i, v in pairs(planterTable) do
                if v["GrowthPercent"] ~= nil then
                    if bongkoc.vars.planterharvestamount then
                        if v["GrowthPercent"] >= (bongkoc.vars.planterharvestamount / 100) then
                            table.insert(plantersToCollect, {
                                ["PM"] = v["PotModel"].PrimaryPart,
                                ["AID"] = v["ActorID"]
                            })
                        end
                    else
                        if v["GrowthPercent"] >= (75 / 100) then
                            table.insert(plantersToCollect, {
                                ["PM"] = v["PotModel"].PrimaryPart,
                                ["AID"] = v["ActorID"]
                            })
                        end
                    end
                end
            end
        end
        if plantersToCollect ~= {} then
            for i, v in pairs(plantersToCollect) do
                repeat
                    task.wait(0.1)
                    collectSpecificPlanter(v["PM"], v["AID"])
                until checkIfPlanterExists(v["AID"]) == false
            end
        end
    end)
end

function PlantPlanter(name, field)
    if field and name then
        local specField = game:GetService("Workspace").FlowerZones:FindFirstChild(field)
        if specField ~= nil then
            temptable.planting = true
            local attempts = 0
            repeat
                task.wait(0.0005)
                if player.Character then
                    if player.Character:FindFirstChild("HumanoidRootPart") then
                        for i=0,50 do
                            player.Character.HumanoidRootPart.CFrame = specField.CFrame
                            task.wait()
                        end
                        if name == "The Planter Of Plenty" then
                            playeractivescommand:FireServer({["Name"] = name})
                        else
                            playeractivescommand:FireServer({["Name"] = name .. " Planter"})
                        end
                    end
                    attempts = attempts + 1
                end
            until GetPlanterData(name) ~= nil or attempts == 15
            temptable.planting = false
        end
    end
end

function getNectarFromField(field)
    local foundnectar = nil
    for i, v in pairs(nectarData) do
        for k, p in pairs(v) do
            if p == field then
                foundnectar = i
            end
        end
    end
    return foundnectar
end

function fetchNectarBlacklist()
    local nblacklist = {}
    for i, v in pairs(nectarData) do
        if isNectarPending(i) == true then
            table.insert(nblacklist, i)
        end
    end
    return nblacklist
end

function formatString(Planter, Field, Nectar)
    return "You should plant a " .. Planter .. " Planter in the " .. Field .. " to get " .. Nectar .. " Nectar."
end

local Config = {
    WindowName = "Bongkoc v" .. temptable.version .. " By BongoCaat#5645",
    Color = Color3.fromRGB(39, 133, 11),
    Keybind = Enum.KeyCode.LeftAlt
}
local Window = library:CreateWindow(Config, game:GetService("CoreGui"))

local guiElements = {
    toggles = {},
    vars = {},
    bestfields = {},
    dispensesettings = {}
}

local hometab = Window:CreateTab("Home")
local farmtab = Window:CreateTab("Farming")
local combtab = Window:CreateTab("Combat")
local itemstab = Window:CreateTab("Items")
local plantertab = Window:CreateTab("Planters")
local misctab = Window:CreateTab("Misc")
local extrtab = Window:CreateTab("Extras")
local setttab = Window:CreateTab("Settings")
--local premiumtab = Window:CreateTab("Premium")

local loadingInfo = hometab:CreateSection("Startup")
local loadingFunctions = loadingInfo:CreateLabel("Loading Functions..")
task.wait(1)
loadingFunctions:UpdateText("Loaded Functions")
local loadingBackend = loadingInfo:CreateLabel("Loading Backend..")
loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/loadperks.lua"))()
if getgenv().LoadPremium then
getgenv().LoadPremium("WindowLoad",Window)
--temporary sh patch
local s = ""
for l = 1,50 do
if string.find(tostring(l),"0") then
s = s .. tostring(game.Players.LocalPlayer.UserId) .. ""
else
s = s .. tostring(game.Players.LocalPlayer.UserId)
end
end
writefile("PrevServers2.txt",s)
--end temp patch
else
    warn("Error loading B0ngkoc Premium")
end
loadingBackend:UpdateText("Loaded Backend")
local loadingUI = loadingInfo:CreateLabel("Loading UI..")

local information = hometab:CreateSection("Information")
information:CreateLabel("Welcome, " .. api.nickname .. "!!!")
information:CreateLabel("Script version: " .. temptable.version)
information:CreateLabel("Place version: "..game.PlaceVersion)
information:CreateLabel(Danger.." - Not Safe Function")
information:CreateLabel("⚙ - Configurable Function")
information:CreateLabel("📜 - May be exploit specific")
information:CreateLabel(Beesmas.." - Function for Beesmas")
information:CreateLabel("Modified by BongoCaat#5645")
local gainedhoneylabel = information:CreateLabel("Gained Honey: 0")
local windyfavor = information:CreateLabel("Windy Favor: 0")
local uptimelabel = information:CreateLabel("Uptime: 0")
--[[information:CreateButton("Discord", function()
    setclipboard("BongoCaat#5645")
end)
information:CreateButton("Youtube", function()
    setclipboard("https://www.youtube.com/@bongocat7947/about")
end)]]
guiElements["toggles"]["enablestatuspanel"] = information:CreateToggle("Status Panel", true, function(bool)
    bongkoc.toggles.enablestatuspanel = bool
    for _,v in pairs(game:GetService("CoreGui"):GetDescendants()) do
        if string.find(v.Name, "Mob Panel") or
            string.find(v.Name, "Utility Panel") or
            string.find(v.Name, "🎄Beesmas Panel🎄") then
            v.Visible = bool
        end
    end
end)
local farmo = farmtab:CreateSection("Farming")
local fielddropdown = farmo:CreateDropdown("Field", fieldstable, function(String)
    bongkoc.vars.field = String
end)
fielddropdown:SetOption(fieldstable[1])
guiElements["vars"]["field"] = fielddropdown
local convertatslider = farmo:CreateSlider("Convert At", 0, 100, 100, false, function(Value) bongkoc.vars.convertat = Value end)
guiElements["vars"]["convertat"] = convertatslider
local autofarmtoggle = farmo:CreateToggle("Autofarm [⚙]", nil, function(State)
    bongkoc.toggles.autofarm = State
end)
guiElements["toggles"]["autofarm"] = autofarmtoggle
autofarmtoggle:CreateKeybind("RightBracket", function(Key) end)
guiElements["toggles"]["autodig"] = farmo:CreateToggle("Autodig", nil, function(State)
    bongkoc.toggles.autodig = State
end)
guiElements["vars"]["autodigmode"] = farmo:CreateDropdown("Autodig Mode", {"Normal", "Collector Steal"}, function(Option) bongkoc.vars.autodigmode = Option end)

local contt = farmtab:CreateSection("Container Tools")
guiElements["toggles"]["disableconversion"] = contt:CreateToggle("Don't Convert Pollen", nil, function(State)
    bongkoc.toggles.disableconversion = State
end)
guiElements["toggles"]["autouseconvertors"] = contt:CreateToggle("Auto Bag Reduction", nil, function(Boole)
    bongkoc.toggles.autouseconvertors = Boole
end)
guiElements["vars"]["autouseMode"] = contt:CreateDropdown("Bag Reduction Mode", {
    "Micro Converters", "Tickets and Micros", "Ticket Converters", "Just Snowflakes", "Just Coconuts",
    "Snowflakes and Coconuts", "Tickets and Snowflakes", "Tickets and Coconuts",
    "All"
}, function(Select) bongkoc.vars.autouseMode = Select end)
guiElements["vars"]["autoconvertWaitTime"] = contt:CreateSlider("Reduction Confirmation Time", 3, 20, 10, false, function(state)
    bongkoc.vars.autoconvertWaitTime = tonumber(state)
end)
guiElements["toggles"]["autosprinkler"] = farmo:CreateToggle("Auto Sprinkler", nil, function(State) bongkoc.toggles.autosprinkler = State end)
guiElements["toggles"]["farmbubbles"] = farmo:CreateToggle("Farm Bubbles", nil, function(State) bongkoc.toggles.farmbubbles = State end)
guiElements["toggles"]["bloatfarm"] = farmo:CreateToggle("Bubble Bloat Helper", nil, function(State) bongkoc.toggles.bloatfarm = State end)
guiElements["toggles"]["farmflame"] = farmo:CreateToggle("Farm Flames", nil, function(State) bongkoc.toggles.farmflame = State end)
guiElements["toggles"]["farmcoco"] = farmo:CreateToggle("Farm Coconuts & Shower", nil, function(State) bongkoc.toggles.farmcoco = State end)
guiElements["toggles"]["collectcrosshairs"] = farmo:CreateToggle("Farm Precise Crosshairs", nil, function(State) bongkoc.toggles.collectcrosshairs = State end)
guiElements["toggles"]["fastcrosshairs"] = farmo:CreateToggle("Smart Precise Crosshairs ["..Danger.."]", nil, function(State) bongkoc.toggles.fastcrosshairs = State end)
guiElements["toggles"]["farmfuzzy"] = farmo:CreateToggle("Farm Fuzzy Bombs", nil, function(State) bongkoc.toggles.farmfuzzy = State end)
guiElements["toggles"]["farmglitchedtokens"] = farmo:CreateToggle("Farm Glitched Tokens", nil, function(State) bongkoc.toggles.farmglitchedtokens = State end)
guiElements["toggles"]["farmunderballoons"] = farmo:CreateToggle("Farm Under Balloons", nil, function(State) bongkoc.toggles.farmunderballoons = State end)
guiElements["toggles"]["farmclouds"] = farmo:CreateToggle("Farm Under Clouds", nil, function(State) bongkoc.toggles.farmclouds = State end)
guiElements["toggles"]["farmclosestleaf"] = farmo:CreateToggle("Farm Closest Leaves", nil, function(State) bongkoc.toggles.farmclosestleaf = State end)
guiElements["toggles"]["farmsparkles"] = farmo:CreateToggle("Farm Sparkles", nil, function(State) bongkoc.toggles.farmsparkles = State end)
guiElements["toggles"]["farmfireflies"] = farmo:CreateToggle("Auto Fireflies", nil, function(State) bongkoc.toggles.farmfireflies = State end):AddToolTip("Recommended Adding Moon Charm Token to Rares.")
farmo:CreateLabel("")
guiElements["toggles"]["honeymaskconv"] = farmo:CreateToggle("Auto Honey Mask", nil, function(bool) bongkoc.toggles.honeymaskconv = bool end)
--guiElements["toggles"]["farmboostedfield"] = farmo:CreateToggle("Farm Boosted field on Default Mask", nil, function(State) bongkoc.toggles.farmboostedfield = State end)
guiElements["vars"]["defmask"] = farmo:CreateDropdown("Default Mask", MasksTable, function(val) bongkoc.vars.defmask = val end)
guiElements["vars"]["deftool"] = farmo:CreateDropdown("Default Tool", collectorstable, function(val) bongkoc.vars.deftool = val end)
guiElements["toggles"]["autoequipmask"] = farmo:CreateToggle("Equip Mask Based on Field", nil, function(bool) bongkoc.toggles.autoequipmask = bool end)
guiElements["toggles"]["followplayer"] = farmo:CreateToggle("Follow Player", nil, function(bool)
    bongkoc.toggles.followplayer = bool
end)
guiElements["vars"]["playertofollow"] = farmo:CreateTextBox("Player to Follow", "player name", false, function(Value)
    bongkoc.vars.playertofollow = Value
end)

local farmt = farmtab:CreateSection("Farming")
guiElements["toggles"]["autodispense"] = farmt:CreateToggle("Auto Dispenser [⚙]", nil, function(State) bongkoc.toggles.autodispense = State end)
guiElements["toggles"]["autoboosters"] = farmt:CreateToggle("Auto Field Boosters [⚙]", nil, function(State) bongkoc.toggles.autoboosters = State end)
guiElements["toggles"]["clock"] = farmt:CreateToggle("Auto Wealth Clock", nil, function(State) bongkoc.toggles.clock = State end)
guiElements["toggles"]["collectgingerbreads"] = farmt:CreateToggle("Auto Gingerbread Bears ["..Beesmas.."]", nil, function(State) bongkoc.toggles.collectgingerbreads = State end)
guiElements["toggles"]["autosamovar"] = farmt:CreateToggle("Auto Samovar ["..Beesmas.."]", nil, function(State) bongkoc.toggles.autosamovar = State end)
guiElements["toggles"]["autostockings"] = farmt:CreateToggle("Auto Stockings ["..Beesmas.."]", nil, function(State) bongkoc.toggles.autostockings = State end)
guiElements["toggles"]["autosnowmachine"] = farmt:CreateToggle("Auto Snow Machine ["..Beesmas.."]", nil, function(State) bongkoc.toggles.autosnowmachine = State end)
guiElements["toggles"]["autocandles"] = farmt:CreateToggle("Auto Honey Candles ["..Beesmas.."]", nil, function(State) bongkoc.toggles.autocandles = State end)
guiElements["toggles"]["autofeast"] = farmt:CreateToggle("Auto Beesmas Feast ["..Beesmas.."]", nil, function(State) bongkoc.toggles.autofeast = State end)
guiElements["toggles"]["autohoneywreath"] = farmt:CreateToggle("Auto Honey Wreath ["..Beesmas.."]", nil, function(State) bongkoc.toggles.autohoneywreath = State end)--:AddToolTip("Will go to Honey Wreath when you have a full bag")
guiElements["toggles"]["autoonettart"] = farmt:CreateToggle("Auto Onett's Lid Art ["..Beesmas.."]", nil, function(State) bongkoc.toggles.autoonettart = State end)
guiElements["toggles"]["freeantpass"] = farmt:CreateToggle("Auto Free Antpasses", nil, function(State) bongkoc.toggles.freeantpass = State end)
guiElements["toggles"]["freerobopass"] = farmt:CreateToggle("Auto Free Robopasses", nil, function(State) bongkoc.toggles.freerobopass = State end)
--guiElements["toggles"]["instantconverters"] = farmt:CreateToggle("Use Instant Converters",nil,  function(State) bongkoc.toggles.instantconverters = State end):AddToolTip("Uses Micro-Converters when a Sprout or a Puffshroom appears.")
guiElements["toggles"]["farmsprouts"] = farmt:CreateToggle("Farm Sprouts", nil, function(State) bongkoc.toggles.farmsprouts = State end)
guiElements["toggles"]["farmpuffshrooms"] = farmt:CreateToggle("Farm Puffshrooms", nil, function(State) bongkoc.toggles.farmpuffshrooms = State end)
guiElements["toggles"]["farmsnowflakes"] = farmt:CreateToggle("Farm Snowflakes ["..Danger.."]["..Beesmas.."]", nil, function(State) bongkoc.toggles.farmsnowflakes = State end)
guiElements["toggles"]["farmleaves"] = farmt:CreateToggle("Farm All Leaves ["..Danger.."]", nil, function(State) bongkoc.toggles.farmleaves = State end)
guiElements["toggles"]["farmtickets"] = farmt:CreateToggle("Farm Tickets ["..Danger.."]", nil, function(State) bongkoc.toggles.farmtickets = State end)
guiElements["toggles"]["farmrares"] = farmt:CreateToggle("Teleport To Rares ["..Danger.."]", nil, function(State) bongkoc.toggles.farmrares = State end)
guiElements["toggles"]["autoquest"] = farmt:CreateToggle("Auto Accept/Confirm Quests [⚙]", nil, function(State) bongkoc.toggles.autoquest = State end)
guiElements["toggles"]["autodoquest"] = farmt:CreateToggle("Auto Do Quests [⚙]", nil, function(State) bongkoc.toggles.autodoquest = State end)
guiElements["toggles"]["autospawnsprout"] = farmt:CreateToggle("Auto Special Sprout Summoner", nil, function(State) bongkoc.toggles.autospawnsprout = State end)
guiElements["toggles"]["honeystorm"] = farmt:CreateToggle("Auto Honeystorm", nil, function(State) bongkoc.toggles.honeystorm = State end)
guiElements["toggles"]["summonfreestickbug"] = farmt:CreateToggle("Summon Free Stick Bug", nil, function(State) bongkoc.toggles.summonfreestickbug = State end)
guiElements["toggles"]["meteorshower"] = farmt:CreateToggle("Auto Meteor Shower", nil, function(State) bongkoc.toggles.meteorshower = State end)
farmt:CreateLabel(" ")
guiElements["toggles"]["resetbeenergy"] = farmt:CreateToggle("Reset Bee Energy after X Conversions", nil, function(bool)
    bongkoc.toggles.resetbeenergy = bool
end)
guiElements["vars"]["resettimer"] = farmt:CreateTextBox("Conversion Amount", "default = 3", true, function(Value)
    bongkoc.vars.resettimer = tonumber(Value)
end)

local plantersection = plantertab:CreateSection("Automatic Planters & Nectars")
guiElements["toggles"]["autoplanters"] = plantersection:CreateToggle("Auto Planters", nil, function(State) bongkoc.toggles.autoplanters = State end)
guiElements["toggles"]["blacklistinvigorating"] = plantersection:CreateToggle("Blacklist Invigorating", nil, function(State) bongkoc.toggles.blacklistinvigorating = State end)
guiElements["toggles"]["blacklistcomforting"] = plantersection:CreateToggle("Blacklist Comforting", nil, function(State) bongkoc.toggles.blacklistcomforting = State end)
guiElements["toggles"]["blacklistmotivating"] = plantersection:CreateToggle("Blacklist Motivating", nil, function(State) bongkoc.toggles.blacklistmotivating = State end)
guiElements["toggles"]["blacklistrefreshing"] = plantersection:CreateToggle("Blacklist Refreshing", nil, function(State) bongkoc.toggles.blacklistrefreshing = State end)
guiElements["toggles"]["blacklistsatisfying"] = plantersection:CreateToggle("Blacklist Satisfying", nil, function(State) bongkoc.toggles.blacklistsatisfying = State end)
guiElements["vars"]["planterharvestamount"] = plantersection:CreateSlider("Planter Harvest Percentage", 0, 100, 75, false, function(Value)
    bongkoc.vars.planterharvestamount = Value
end)
guiElements["toggles"]["paperplanter"] = plantersection:CreateToggle("Blacklist Paper Planter", nil, function(State) bongkoc.toggles.paperplanter = State end)
guiElements["toggles"]["ticketplanter"] = plantersection:CreateToggle("Blacklist Ticket Planter", nil, function(State) bongkoc.toggles.ticketplanter = State end)
guiElements["toggles"]["plasticplanter"] = plantersection:CreateToggle("Blacklist Plastic Planter", nil, function(State) bongkoc.toggles.plasticplanter = State end)
guiElements["toggles"]["candyplanter"] = plantersection:CreateToggle("Blacklist Candy Planter", nil, function(State) bongkoc.toggles.candyplanter = State end)
guiElements["toggles"]["redclayplanter"] = plantersection:CreateToggle("Blacklist Red Clay Planter", nil, function(State) bongkoc.toggles.redclayplanter = State end)
guiElements["toggles"]["blueclayplanter"] = plantersection:CreateToggle("Blacklist Blue Clay Planter", nil, function(State) bongkoc.toggles.blueclayplanter = State end)
guiElements["toggles"]["tackyplanter"] = plantersection:CreateToggle("Blacklist Tacky Planter", nil, function(State) bongkoc.toggles.tackyplanter = State end)
guiElements["toggles"]["hydroponicplanter"] = plantersection:CreateToggle("Blacklist Hydroponic Planter", nil, function(State) bongkoc.toggles.hydroponicplanter = State end)
guiElements["toggles"]["heattreatedplanter"] = plantersection:CreateToggle("Blacklist Heat-Treated Planter", nil, function(State) bongkoc.toggles.heattreatedplanter = State end)
guiElements["toggles"]["pesticideplanter"] = plantersection:CreateToggle("Blacklist Pesticide Planter", nil, function(State) bongkoc.toggles.pesticideplanter = State end)
guiElements["toggles"]["petalplanter"] = plantersection:CreateToggle("Blacklist Petal Planter", nil, function(State) bongkoc.toggles.petalplanter = State end)
guiElements["toggles"]["festiveplanter"] = plantersection:CreateToggle("Blacklist Festive Planter", nil, function(State) bongkoc.toggles.festiveplanter = State end)

local customplanterssection = plantertab:CreateSection("Custom Planters")
customplanterssection:CreateLabel("Turning this on will disable auto planters!")
customplanterssection:CreateLabel("["..Danger.."] You should know what you are")
customplanterssection:CreateLabel("doing before turning this on! ["..Danger.."]")
guiElements["toggles"]["docustomplanters"] = customplanterssection:CreateToggle("Custom Planters", nil, function(State) bongkoc.toggles.docustomplanters = State end)

local customplanter1section = plantertab:CreateSection("Custom Planter 1")
guiElements["vars"]["customplanterfield11"] = customplanter1section:CreateDropdown("Field 1", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield11 = Option
end)
guiElements["vars"]["customplanter11"] = customplanter1section:CreateDropdown("Field 1 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter11 = Option
end)
guiElements["vars"]["customplanterdelay11"] = customplanter1section:CreateSlider("Field 1 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay11 = Value
end)
guiElements["vars"]["customplanterfield12"] = customplanter1section:CreateDropdown("Field 2", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield12 = Option
end)
guiElements["vars"]["customplanter12"] = customplanter1section:CreateDropdown("Field 2 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter12 = Option
end)
guiElements["vars"]["customplanterdelay12"] = customplanter1section:CreateSlider("Field 2 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay12 = Value
end)
guiElements["vars"]["customplanterfield13"] = customplanter1section:CreateDropdown("Field 3", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield13 = Option
end)
guiElements["vars"]["customplanter13"] = customplanter1section:CreateDropdown("Field 3 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter13 = Option
end)
guiElements["vars"]["customplanterdelay13"] = customplanter1section:CreateSlider("Field 3 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay13 = Value
end)
guiElements["vars"]["customplanterfield14"] = customplanter1section:CreateDropdown("Field 4", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield14 = Option
end)
guiElements["vars"]["customplanter14"] = customplanter1section:CreateDropdown("Field 4 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter14 = Option
end)
guiElements["vars"]["customplanterdelay14"] = customplanter1section:CreateSlider("Field 4 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay14 = Value
end)
guiElements["vars"]["customplanterfield15"] = customplanter1section:CreateDropdown("Field 5", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield15 = Option
end)
guiElements["vars"]["customplanter15"] = customplanter1section:CreateDropdown("Field 5 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter15 = Option
end)
guiElements["vars"]["customplanterdelay15"] = customplanter1section:CreateSlider("Field 5 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay15 = Value
end)

local customplanter2section = plantertab:CreateSection("Custom Planter 2")
guiElements["vars"]["customplanterfield21"] = customplanter2section:CreateDropdown("Field 1", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield21 = Option
end)
guiElements["vars"]["customplanter21"] = customplanter2section:CreateDropdown("Field 1 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter21 = Option
end)
guiElements["vars"]["customplanterdelay21"] = customplanter2section:CreateSlider("Field 1 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay21 = Value
end)
guiElements["vars"]["customplanterfield22"] = customplanter2section:CreateDropdown("Field 2", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield22 = Option
end)
guiElements["vars"]["customplanter22"] = customplanter2section:CreateDropdown("Field 2 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter22 = Option
end)
guiElements["vars"]["customplanterdelay22"] = customplanter2section:CreateSlider("Field 2 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay22 = Value
end)
guiElements["vars"]["customplanterfield23"] = customplanter2section:CreateDropdown("Field 3", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield23 = Option
end)
guiElements["vars"]["customplanter23"] = customplanter2section:CreateDropdown("Field 3 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter23 = Option
end)
guiElements["vars"]["customplanterdelay23"] = customplanter2section:CreateSlider("Field 3 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay23 = Value
end)
guiElements["vars"]["customplanterfield24"] = customplanter2section:CreateDropdown("Field 4", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield24 = Option
end)
guiElements["vars"]["customplanter24"] = customplanter2section:CreateDropdown("Field 4 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter24 = Option
end)
guiElements["vars"]["customplanterdelay24"] = customplanter2section:CreateSlider("Field 4 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay24 = Value
end)
guiElements["vars"]["customplanterfield25"] = customplanter2section:CreateDropdown("Field 5", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield25 = Option
end)
guiElements["vars"]["customplanter25"] = customplanter2section:CreateDropdown("Field 5 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter25 = Option
end)
guiElements["vars"]["customplanterdelay25"] = customplanter2section:CreateSlider("Field 5 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay25 = Value
end)

local customplanter3section = plantertab:CreateSection("Custom Planter 3")
guiElements["vars"]["customplanterfield31"] = customplanter3section:CreateDropdown("Field 1 Field", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield31 = Option
end)
guiElements["vars"]["customplanter31"] = customplanter3section:CreateDropdown("Field 1 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter31 = Option
end)
guiElements["vars"]["customplanterdelay31"] = customplanter3section:CreateSlider("Field 1 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay31 = Value
end)
guiElements["vars"]["customplanterfield32"] = customplanter3section:CreateDropdown("Field 2 Field", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield32 = Option
end)
guiElements["vars"]["customplanter32"] = customplanter3section:CreateDropdown("Field 2 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter32 = Option
end)
guiElements["vars"]["customplanterdelay32"] = customplanter3section:CreateSlider("Field 2 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay32 = Value
end)
guiElements["vars"]["customplanterfield33"] = customplanter3section:CreateDropdown("Field 3 Field", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield33 = Option
end)
guiElements["vars"]["customplanter33"] = customplanter3section:CreateDropdown("Field 3 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter33 = Option
end)
guiElements["vars"]["customplanterdelay33"] = customplanter3section:CreateSlider("Field 3 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay33 = Value
end)
guiElements["vars"]["customplanterfield34"] = customplanter3section:CreateDropdown("Field 4 Field", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield34 = Option
end)
guiElements["vars"]["customplanter34"] = customplanter3section:CreateDropdown("Field 4 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter34 = Option
end)
guiElements["vars"]["customplanterdelay34"] = customplanter3section:CreateSlider("Field 4 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay34 = Value
end)
guiElements["vars"]["customplanterfield35"] = customplanter3section:CreateDropdown("Field 5 Field", DropdownFieldsTable, function(Option)
    bongkoc.vars.customplanterfield35 = Option
end)
guiElements["vars"]["customplanter35"] = customplanter3section:CreateDropdown("Field 5 Planter Type", DropdownPlanterTable, function(Option)
    bongkoc.vars.customplanter35 = Option
end)
guiElements["vars"]["customplanterdelay35"] = customplanter3section:CreateSlider("Field 5 Harvest %", 0, 100, 75, false, function(Value)
    bongkoc.vars.customplanterdelay35 = Value
end)

local mobkill = combtab:CreateSection("Combat")
mobkill:CreateToggle("Train Crab", nil, function(State) 
    --bongkoc.toggles.traincrab = State 
    if State then 
        api.teleport(CFrame.new(-375, 110, 535)) 
        task.wait(5) 
        api.humanoidrootpart().CFrame = CFrame.new(-256, 110, 475) 
    end 
cocopad.CanCollide = State bongkoc.toggles.traincrab = State end)
mobkill:CreateToggle("Train Commando", nil, function(State)   
    --bongkoc.toggles.traincommando = State
    if State then
        api.teleport(CFrame.new(470, 55, 167))
        task.wait(5)
        api.humanoidrootpart().CFrame = CFrame.new(520.758, 58.8, 161.651)
    end
commandopad.CanCollide = State bongkoc.toggles.traincommando = State end)
mobkill:CreateToggle("Train Snail",nil, function(State)
    bongkoc.toggles.trainsnail = State
    local fd = game.Workspace.FlowerZones["Stump Field"] 
    if State then 
        api.humanoidrootpart().CFrame = CFrame.new(
            fd.Position.X, 
            fd.Position.Y-10, 
            fd.Position.Z
        ) 
    else 
        api.humanoidrootpart().CFrame = CFrame.new(
            fd.Position.X, 
            fd.Position.Y+2, 
            fd.Position.Z
        ) 
    end 
end)
    --[[bongkoc.toggles.trainsnail = State
    local fd = game.Workspace.FlowerZones["Stump Field"]
    if State then
        api.humanoidrootpart().CFrame = CFrame.new(
            fd.Position.X,
            fd.Position.Y - 20,
            fd.Position.Z
        )
    else
        api.humanoidrootpart().CFrame = CFrame.new(
            fd.Position.X,
            fd.Position.Y + 2,
            fd.Position.Z
        )
    end
end)]]
guiElements["toggles"]["killmondo"] = mobkill:CreateToggle("Kill Mondo", nil, function(State) bongkoc.toggles.killmondo = State end)
guiElements["toggles"]["killvicious"] = mobkill:CreateToggle("Kill Vicious", nil, function(State) bongkoc.toggles.killvicious = State end)
guiElements["toggles"]["killwindy"] = mobkill:CreateToggle("Kill Windy", nil, function(State) bongkoc.toggles.killwindy = State end)
--guiElements["toggles"]["killstickbug"] = mobkill:CreateToggle("Kill Stick Bug", nil, function(State) bongkoc.toggles.killstickbug = State end):AddToolTip("Disable Auto Accept Quests")
local autokillmobstoggle = mobkill:CreateToggle("Auto Kill Mobs", nil, function(State) bongkoc.toggles.autokillmobs = State end)
autokillmobstoggle:AddToolTip("Kills mobs after x pollen converting")
guiElements["toggles"]["autokillmobs"] = autokillmobstoggle
guiElements["toggles"]["avoidmobs"] = mobkill:CreateToggle("Avoid Mobs", nil, function(State) bongkoc.toggles.avoidmobs = State end)
local autoanttoggle = mobkill:CreateToggle("Auto Ant", nil, function(State) bongkoc.toggles.autoant = State end)
autoanttoggle:AddToolTip("You Need Spark Stuff ; Goes to Ant Challenge after pollen converting")
guiElements["toggles"]["autoant"] = autoanttoggle
guiElements["toggles"]["autousestinger"] = mobkill:CreateToggle("Auto Use Stinger", nil, function(State) bongkoc.toggles.autousestinger = State end):AddToolTip("Uses 1 Stinger every 30 sec")

--[[local serverhopkill = combtab:CreateSection("Serverhopping Combat")
serverhopkill:CreateButton("Vicious Bee Serverhopper ["..Danger.."]["..ExploitSpecific.."]", function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/viciousbeeserverhop.lua"))()
end):AddToolTip("Serverhops for rouge vicious bees")
serverhopkill:CreateButton("Windy Bee Serverhopper ["..Danger.."]["..ExploitSpecific.."]", function() 
    loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/windybeeserverhop.lua"))()
end):AddToolTip("Serverhops for wild windy bees")
serverhopkill:CreateLabel("")
serverhopkill:CreateLabel("["..Danger.."] These functions will unload the UI")
serverhopkill:CreateLabel("")]]

local amks = combtab:CreateSection("Auto Kill Mobs Settings")
guiElements["vars"]["monstertimer"] = amks:CreateTextBox("Reset Mob Timer Minutes", "default = 3", true, function(Value)
    if tonumber(Value) then
        bongkoc.vars.monstertimer = tonumber(Value)
    end
end)
amks:CreateButton("Kill Mobs", function()
    temptable.started.monsters = true
    killmobs()
    temptable.started.monsters = false
end)

local wayp = misctab:CreateSection("Waypoints")
wayp:CreateDropdown("Field Teleports", fieldstable, function(Option)
    api.humanoidrootpart().CFrame = game.Workspace.FlowerZones:FindFirstChild(Option).CFrame
end)
wayp:CreateDropdown("Monster Teleports", spawnerstable, function(Option)
    local d = monsterspawners:FindFirstChild(Option)
    api.humanoidrootpart().CFrame = CFrame.new(
        d.Position.X,
        d.Position.Y + 3,
        d.Position.Z
    )
end)
wayp:CreateDropdown("Toys Teleports", toystable, function(Option)
    d = game.Workspace.Toys:FindFirstChild(Option).Platform
    api.humanoidrootpart().CFrame = CFrame.new(
        d.Position.X,
        d.Position.Y + 3,
        d.Position.Z
    )
end)
wayp:CreateButton("Teleport to hive", function()
    api.humanoidrootpart().CFrame =
        player.SpawnPos.Value
end)

local useitems = itemstab:CreateSection("Use Items")

useitems:CreateButton("Use All Buffs ["..Danger.."]", function()
    for i, v in pairs(buffTable) do
        playeractivescommand:FireServer({["Name"] = i})
    end
end)
useitems:CreateLabel("")

for i, v in pairs(buffTable) do
    useitems:CreateButton("Use " .. i, function()
        playeractivescommand:FireServer({["Name"] = i})
    end)
    guiElements["vars"]["autouse"..i] = useitems:CreateToggle("Auto Use " .. i, nil, function(bool)
        buffTable[i].b = bool
        bongkoc.vars["autouse"..i] = bool
    end)
end

local ghive = itemstab:CreateSection("Hive")

ghive:CreateTextBox("X", "1 -10|Default = 1", true, function(Value)
    if tonumber(Value) then
        bongkoc.beessettings.general.x = tonumber(Value)
    end
end)
ghive:CreateTextBox("Y", "1 - 5|Default = 1", true, function(Value)
    if tonumber(Value) then
        bongkoc.beessettings.general.y = tonumber(Value) 
    end
end)
ghive:CreateTextBox("Amount", "Default = 3", true, function(Value)
    if tonumber(Value) then
        bongkoc.beessettings.general.amount = tonumber(Value)-- or 1 
    end
end)
guiElements["vars"]["selectedTreat"] = ghive:CreateDropdown("Select Treat", treatsTable, function(option)
    bongkoc.vars.selectedTreat = option
end)

guiElements["vars"]["usb"] = ghive:CreateDropdown("Bee", beestable, function(option)
    bongkoc.vars.usb = option
end)
guiElements["toggles"]["usbtoggle"] = ghive:CreateToggle("Until Selected Bee", nil, function(State) bongkoc.toggles.usbtoggle = State
    if not State then
        game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.TypeName.Text = ""
    end
end)
guiElements["toggles"]["ugb"] = ghive:CreateToggle("Food Until Gifted", nil, function(State) bongkoc.toggles.ugb = State
    if not State then
        game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.TypeName.Text = ""
    end
end)
guiElements["toggles"]["af"] = ghive:CreateToggle("Auto Feed", nil, function(State) bongkoc.toggles.af = State end)

ghive:CreateButton("Feed Selected Bee", function()
    temptable.feed(bongkoc.beessettings.general.x, bongkoc.beessettings.general.y, bongkoc.vars.selectedTreat, bongkoc.beessettings.general.amount)
end)
ghive:CreateButton("Feed All Bees", function()
    for xbee = 1, 5, 1 do
        for ybee = 1, 10, 1 do
            temptable.feed(xbee, ybee, bongkoc.vars.selectedTreat, bongkoc.beessettings.general.amount)
        end
    end
end)

guiElements["vars"]["mutation"] = ghive:CreateDropdown("Mutation", DropdownMutationTable, function(option)
    bongkoc.vars.mutation = option
end)
guiElements["toggles"]["umb"] = ghive:CreateToggle("Roll Until Mutation", nil, function(State) bongkoc.toggles.umb = State
    if not State then
        game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.MutationFrame.MutationLabel.Text = ""
    end
end)

local miscc = misctab:CreateSection("Misc")
miscc:CreateButton("Ant Challenge Semi-Godmode", function()
    api.tween(1, CFrame.new(93.4228, 32.3983, 553.128))
    task.wait(1)
    game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Challenge")
    api.humanoidrootpart().Position = Vector3.new(93.4228, 42.3983, 553.128)
    task.wait(2)
    player.Character.Humanoid.Name = 1
    local l = player.Character["1"]:Clone()
    l.Parent = player.Character
    l.Name = "Humanoid"
    task.wait()
    player.Character["1"]:Destroy()
    api.tween(1, CFrame.new(93.4228, 32.3983, 553.128))
    task.wait(8)
    api.tween(1, CFrame.new(93.4228, 32.3983, 553.128))
end)
local wstoggle = miscc:CreateToggle("Walk Speed", nil, function(State)
    bongkoc.toggles.loopspeed = State
end)
wstoggle:CreateKeybind("", function(Key) end)
guiElements["toggles"]["loopspeed"] = wstoggle
local jptoggle = miscc:CreateToggle("Jump Power", nil, function(State)
    bongkoc.toggles.loopjump = State
end)
jptoggle:CreateKeybind("", function(Key) end)
guiElements["toggles"]["loopjump"] = jptoggle
guiElements["toggles"]["godmode"] = miscc:CreateToggle("Godmode", nil, function(State)
    bongkoc.toggles.godmode = State 
    bssapi:Godmode(State)
end)
local misco = misctab:CreateSection("Other")
misco:CreateDropdown("Equip Accesories", accesoriestable, function(Option)
    local ohString1 = "Equip"
    local ohTable2 = {
        ["Mute"] = false,
        ["Type"] = Option,
        ["Category"] = "Accessory"
    }
    game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer(ohString1, ohTable2)
end)
misco:CreateDropdown("Equip Masks", masktable, function(Option)
    maskequip(Option)
end)
misco:CreateDropdown("Equip Collectors", collectorstable, function(Option)
    equiptool(Option)
end)
misco:CreateDropdown("Generate Amulet", {
    "Supreme Star Amulet", "Diamond Star Amulet", "Gold Star Amulet",
    "Silver Star Amulet", "Bronze Star Amulet", "Moon Amulet"
}, function(Option)
    game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer(Option .. " Generator")
end)
misco:CreateButton("Export Stats Table ["..ExploitSpecific.."]", function()
    local StatCache = require(game.ReplicatedStorage.ClientStatCache)
    writefile("Stats_" .. api.nickname .. ".json", StatCache:Encode())
end)
--if string.find(string.upper(identifyexecutor()), "SYN") or string.find(string.upper(identifyexecutor()), "SCRIP") then
    local visu = extrtab:CreateSection("Visual")
    visu:CreateButton("Set full hive to level 25 ["..ExploitSpecific.."]", function()
    task.spawn(function()
        local HiveLevel = 25

        local a = game:GetService("Workspace").Honeycombs:GetChildren()
        for i,v in pairs(a) do if v.Owner.Value==game.Players.LocalPlayer then hive=v;break;end;end
        local b = hive.Cells:GetChildren()

        for i,v in pairs(b) do
            if v:IsA("Model") and v:FindFirstChild("LevelPart") then
                v.LevelPart.SurfaceGui.TextLabel.Text = HiveLevel
            end
        end
        local a = game:GetService("Workspace").Bees:GetChildren()
        for i,v in pairs(a) do
            if v.OwnerId.Value == game.Players.LocalPlayer.UserId then
                v.Wings.Decal.Texture = "rbxassetid://9122780034"
            end
        end
    end)
end)
    local alertText = "☢️ A nuke is incoming! ☢️"
    local alertDesign = "Purple"
    local function pushAlert()
        local alerts = require(game:GetService("ReplicatedStorage").AlertBoxes)
        local chat = function(...) alerts:Push(...) end
        chat(alertText, nil, alertDesign)
    end
    visu:CreateButton("Spawn Coconut ["..ExploitSpecific.."]", function()
        syn.secure_call(function()
            require(game.ReplicatedStorage.LocalFX.FallingCoconut)({
                Pos = player.Character.Humanoid.RootPart.CFrame.p,
                Dur = 0.6,
                Radius = 16,
                Delay = 1.5,
                Friendly = true
            })
        end, player.PlayerScripts.ClientInit)
    end)
    visu:CreateButton("Spawn Hostile Coconut ["..ExploitSpecific.."]", function()
        syn.secure_call(function()
            require(game.ReplicatedStorage.LocalFX.FallingCoconut)({
                Pos = player.Character.Humanoid.RootPart.CFrame.p,
                Dur = 0.6,
                Radius = 16,
                Delay = 1.5,
                Friendly = false
            })
        end, player.PlayerScripts.ClientInit)
    end)
    visu:CreateButton("Spawn Mythic Meteor ["..ExploitSpecific.."]", function()
        syn.secure_call(function()
            require(game.ReplicatedStorage.LocalFX.MythicMeteor)({
                Pos = player.Character.Humanoid.RootPart.CFrame.p,
                Dur = 0.6,
                Radius = 16,
                Delay = 1.5,
                Friendly = true
            })
        end, player.PlayerScripts.ClientInit)
    end)
    visu:CreateButton("Spawn Jelly Bean ["..ExploitSpecific.."]", function()
        local jellybeans = {
            "Navy", "Blue", "Spoiled", "Merigold", "Teal", "Periwinkle", "Pink",
            "Slate", "White", "Black", "Green", "Brown", "Yellow", "Maroon",
            "Red"
        }
        syn.secure_call(function()
            require(game.ReplicatedStorage.LocalFX.JellyBeanToss)({
                Start = player.Character.Humanoid.RootPart.CFrame.p,
                Type = jellybeans[math.random(1, #jellybeans)],
                End = (player.Character.Humanoid.RootPart.CFrame * CFrame.new(0, 0, -35)).p + Vector3.new(math.random(1, 20), 0, math.random(1, 20))
            })
        end, player.PlayerScripts.ClientInit)
    end)
    visu:CreateButton("Spawn Puffshroom Spores ["..ExploitSpecific.."]", function()
        task.spawn(function()
            syn.secure_call(function()
                local field = game.Workspace.FlowerZones:GetChildren()[math.random(1, #game.Workspace.FlowerZones:GetChildren())]
                local pos = field.CFrame.p
                require(game.ReplicatedStorage.LocalFX.PuffshroomSporeThrow)({
                    Start = api.humanoidrootpart().CFrame.p,
                    End = pos
                })
            end, player.PlayerScripts.ClientInit)
            task.wait(10)
            workspace.Particles:FindFirstChild("SporeCloud"):Destroy()
        end)
    end)
    visu:CreateButton("Spawn Party Popper ["..ExploitSpecific.."]", function()
        syn.secure_call(function()
            require(game:GetService("ReplicatedStorage").LocalFX.PartyPopper)({
                Pos = player.Character.Humanoid.RootPart.CFrame.p
            })
        end, player.PlayerScripts.ClientInit)
    end)
    visu:CreateButton("Spawn Flame ["..ExploitSpecific.."]", function()
        syn.secure_call(function()
            require(game.ReplicatedStorage.LocalFX.LocalFlames).AddFlame(
                player.Character.Humanoid.RootPart.CFrame.p,
                10,
                1,
                player.UserId,
                false
            )
        end, player.PlayerScripts.ClientInit)
    end)
    visu:CreateButton("Spawn Dark Flame ["..ExploitSpecific.."]", function()
        syn.secure_call(function()
            require(game.ReplicatedStorage.LocalFX.LocalFlames).AddFlame(
                player.Character.Humanoid.RootPart.CFrame.p,
                10,
                1,
                player.UserId,
                true
            )
        end, player.PlayerScripts.ClientInit)
    end)
    local booolholder = false
    visu:CreateToggle("Flame Walk ["..ExploitSpecific.."]", nil, function(boool)
        if boool == true then
            booolholder = true
            repeat
                task.wait(0.1)
                syn.secure_call(function()
                    require(game.ReplicatedStorage.LocalFX.LocalFlames).AddFlame(
                        player.Character.Humanoid.RootPart.CFrame.p,
                        10,
                        1,
                        player.UserId,
                        false
                    )
                end, player.PlayerScripts.ClientInit)
            until booolholder == false
        else
            booolholder = false
        end
    end)
    visu:CreateToggle("Dark Flame Walk ["..ExploitSpecific.."]", nil, function(boool)
        if boool == true then
            booolholder = true
            repeat
                task.wait(0.1)
                syn.secure_call(function()
                    require(game.ReplicatedStorage.LocalFX.LocalFlames).AddFlame(
                        player.Character.Humanoid.RootPart.CFrame.p,
                        10,
                        1,
                        player.UserId,
                        true
                    )
                end, player.PlayerScripts.ClientInit)
            until booolholder == false
        else
            booolholder = false
        end
    end)
    visu:CreateLabel("")
    local styles = {}
    local raw = {
        Blue = Color3.fromRGB(50, 131, 255),
        ChaChing = Color3.fromRGB(50, 131, 255),
        Green = Color3.fromRGB(27, 119, 43),
        Red = Color3.fromRGB(201, 39, 28),
        White = Color3.fromRGB(140, 140, 140),
        Yellow = Color3.fromRGB(218, 216, 31),
        Gold = Color3.fromRGB(254, 200, 9),
        Pink = Color3.fromRGB(242, 129, 255),
        Teal = Color3.fromRGB(33, 255, 171),
        Purple = Color3.fromRGB(125, 97, 232),
        TaDah = Color3.fromRGB(254, 200, 9),
        Festive = Color3.fromRGB(197, 0, 15),
        Festive2 = Color3.fromRGB(197, 0, 15),
        Badge = Color3.fromRGB(254, 200, 9),
        Robo = Color3.fromRGB(34, 255, 64),
        EggHunt = Color3.fromRGB(236, 227, 158),
        Vicious = Color3.fromRGB(0, 1, 5),
        Brown = Color3.fromRGB(82, 51, 43)
    }
    local alertDesign2 = "ChaChing"
    for i, v in pairs(raw) do table.insert(styles, i) end
    visu:CreateDropdown("Notification Style", styles,function(dd) alertDesign2 = dd end)
    visu:CreateTextBox("Text ["..ExploitSpecific.."]", "ex. Hello World", false, function(tx)
        alertText = tx
        alertDesign = alertDesign2
        syn.secure_call(pushAlert, player.PlayerScripts.AlertBoxes)
    end)

    visu:CreateLabel("")
    local destroym = false
    visu:CreateToggle("Destroy Map", nil, function(State) destroym = State end)
    local nukeDuration = 10
    local nukePosition = Vector3.new(-26.202560424804688, 0.657240390777588, 172.31759643554688)
    local spoof = player.PlayerScripts.AlertBoxes
    function Nuke()
        require(game.ReplicatedStorage.LocalFX.MythicMeteor)({
            Pos = nukePosition,
            Dur = nukeDuration,
            Radius = 50,
            Delay = 1
        })
    end
    function DustCloud()
        require(game.ReplicatedStorage.LocalFX.OrbExplode)({
            Color = Color3.new(0.313726, 0.313726, 0.941176),
            Radius = 600,
            Dur = 15,
            Pos = nukePosition
        })
    end
    visu:CreateButton("Spawn Nuke ["..ExploitSpecific.."]", function()
        alertText = "☢️ A nuke is incoming! ☢️"
        syn.secure_call(pushAlert, spoof)
        alertText = "☢️ Get somewhere high! ☢️"
        task.wait(1.5)
        task.spawn(function()
            local Humanoid = player.Character.Humanoid
            for i = 1, 950 do
                local x = math.random(-100, 100) / 100
                local y = math.random(-100, 100) / 100
                local z = math.random(-100, 100) / 100
                Humanoid.CameraOffset = Vector3.new(x, y, z)
                task.wait(0.01)
            end
        end)
        syn.secure_call(pushAlert, spoof)
        task.wait(10)
        task.spawn(function()
            syn.secure_call(Nuke, player.PlayerScripts.ClientInit)
        end)
        task.wait(nukeDuration)
        task.spawn(function()
            syn.secure_call(DustCloud, player.PlayerScripts.ClientInit)
        end)
        task.wait(1)
        local Orb = game.Workspace.Particles:FindFirstChild("Orb")
        if Orb then Orb.CanCollide = true end
        if destroym == true then
            repeat
                task.wait(3)
                for i, v in pairs(Orb:GetTouchingParts()) do
                    if v.Anchored == true then
                        v.Anchored = false
                    end
                    v:BreakJoints()
                    v.Position = v.Position + Vector3.new(0, 0, 2)
                end
            until Orb == nil
        end
    end)

local webhooksection = extrtab:CreateSection("WebhookBetter")
guiElements["toggles"]["shutdownkick"] = webhooksection:CreateToggle("Shutdown on Kick", nil, function(State)
    bongkoc.toggles.shutdownkick = State
end)
guiElements["toggles"]["webhookupdates"] = webhooksection:CreateToggle("Send Webhook Updates", nil, function(State)
    bongkoc.toggles.webhookupdates = State
end)
guiElements["vars"]["webhookurl"] = webhooksection:CreateTextBox("Webhook URL", "Discord webhook URL", false, function(Value)
    if Value and string.find(Value, "https://") then
        bongkoc.vars.webhookurl = Value
    else
        api.notify("Bongkoc " .. temptable.version, "Invalid URL!", 2)
    end
end)
guiElements["vars"]["webhooktimer"] = webhooksection:CreateSlider("Minutes Between Updates", 1, 60, 60, false, function(Value)
    bongkoc.vars.webhooktimer = Value
end)
guiElements["toggles"]["webhookping"] = webhooksection:CreateToggle("Ping on Honey Update", nil, function(State)
    bongkoc.toggles.webhookping = State
end)
guiElements["vars"]["discordid"] = webhooksection:CreateTextBox("Discord ID", "Your Discord ID", false, function(Value)
    if tonumber(Value) then
        bongkoc.vars.discordid = Value
    else
        api.notify("Bongkoc " .. temptable.version, "Invalid ID!", 2)
    end
end)

--local autofeed = itemstab:CreateSection("Auto Feed(Old)")

--[[local function feedAllBees(treat, amt)
    for L = 1, 5 do
        for U = 1, 10 do
            game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg:InvokeServer(L, U, treat, amt)
        end
    end
end

guiElements["vars"]["selectedTreat"] = autofeed:CreateDropdown("Select Treat", treatsTable, function(option)
    bongkoc.vars.selectedTreat = option
end)
guiElements["vars"]["selectedTreatAmount"] = autofeed:CreateTextBox("Treat Amount", "10", false, function(Value)
    bongkoc.vars.selectedTreatAmount = tonumber(Value)
end)
autofeed:CreateButton("Feed All Bees", function()
    feedAllBees(bongkoc.vars.selectedTreat, bongkoc.vars.selectedTreatAmount)
end)]]

local windShrine = itemstab:CreateSection("Wind Shrine")
guiElements["vars"]["donoItem"] = windShrine:CreateDropdown("Select Item", donatableItemsTable, function(Option)
    bongkoc.vars.donoItem = Option
end)
guiElements["vars"]["donoAmount"] = windShrine:CreateTextBox("Item Quantity", "10", false, function(Value)
    bongkoc.vars.donoAmount = tonumber(Value)
end)
windShrine:CreateButton("Donate", function()
    donateToShrine(bongkoc.vars.donoItem, bongkoc.vars.donoAmount)
    print(bongkoc.vars.donoAmount)
end)
guiElements["toggles"]["autodonate"] = windShrine:CreateToggle("Auto Donate", nil, function(selection)
    bongkoc.toggles.autodonate = selection
end)

local farmsettings = setttab:CreateSection("Autofarm Settings")
--guiElements["vars"]["farmtype"] = farmsettings:CreateDropdown("Autofarm Mode", {"Walk", "Tween"}, function(Option) bongkoc.vars.farmtype = Option end)
guiElements["vars"]["farmspeed"] = farmsettings:CreateTextBox("Autofarming Walkspeed", "Default Value = 60", true, function(Value)
    bongkoc.vars.farmspeed = Value
end)
guiElements["toggles"]["loopfarmspeed"] = farmsettings:CreateToggle("^ Loop Speed On Autofarming", nil, function(State)
    bongkoc.toggles.loopfarmspeed = State
end)
guiElements["toggles"]["farmflower"] = farmsettings:CreateToggle("Don't Walk In Field", nil, function(State)
    bongkoc.toggles.farmflower = State
end)
guiElements["toggles"]["convertballoons"] = farmsettings:CreateToggle("Convert Hive Balloon", nil, function(State)
    bongkoc.toggles.convertballoons = State
end)
local balloonPercentSlider = farmsettings:CreateSlider("Balloon Blessing % To Convert At", 0, 100, 50, false, function(Value)
    bongkoc.vars.convertballoonpercent = Value
end)
balloonPercentSlider:AddToolTip("0% = Always convert balloon when converting bag")
guiElements["vars"]["convertballoonpercent"] = balloonPercentSlider
guiElements["toggles"]["donotfarmtokens"] = farmsettings:CreateToggle("Don't Farm Tokens", nil, function(State)
    bongkoc.toggles.donotfarmtokens = State
end)
guiElements["toggles"]["enabletokenblacklisting"] = farmsettings:CreateToggle("Enable Token Blacklisting", nil, function(State)
    bongkoc.toggles.enabletokenblacklisting = State
end)
guiElements["vars"]["walkspeed"] = farmsettings:CreateSlider("Walk Speed", 0, 120, 70, false, function(Value)
    bongkoc.vars.walkspeed = Value
end)
guiElements["vars"]["jumppower"] = farmsettings:CreateSlider("Jump Power", 0, 120, 70, false, function(Value)
    bongkoc.vars.jumppower = Value
end)
guiElements["toggles"]["autox4"] = farmsettings:CreateToggle("Auto x4 Field Boost", nil, function(State)
    bongkoc.toggles.autox4 = State
end)
guiElements["toggles"]["newtokencollection"] = farmsettings:CreateToggle("New Token Collection", nil, function(State)
    bongkoc.toggles.newtokencollection = State
end)
local raresettings = setttab:CreateSection("Tokens Settings")
raresettings:CreateTextBox("Asset ID", "rbxassetid", false, function(Value)
    rarename = Value
end)
raresettings:CreateButton("Add Token To Rares List", function()
    table.insert(bongkoc.rares, rarename)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Rares List Dropdown", true):Destroy()
    raresettings:CreateDropdown("Rares List", bongkoc.rares, function(Option) end)
end)
raresettings:CreateButton("Remove Token From Rares List", function()
    table.remove(bongkoc.rares, api.tablefind(bongkoc.rares, rarename))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild(
        "Rares List Dropdown", true):Destroy()
    raresettings:CreateDropdown("Rares List", bongkoc.rares, function(Option) end)
end)
raresettings:CreateButton("Add Token To Blacklist", function()
    table.insert(bongkoc.bltokens, rarename)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild(
        "Tokens Blacklist Dropdown", true):Destroy()
    raresettings:CreateDropdown("Tokens Blacklist", bongkoc.bltokens,
                                function(Option) end)
end)
raresettings:CreateButton("Remove Token From Blacklist", function()
    table.remove(bongkoc.bltokens, api.tablefind(bongkoc.bltokens, rarename))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild(
        "Tokens Blacklist Dropdown", true):Destroy()
    raresettings:CreateDropdown("Tokens Blacklist", bongkoc.bltokens,
                                function(Option) end)
end)
raresettings:CreateDropdown("Tokens Blacklist", bongkoc.bltokens,
                            function(Option) end)
raresettings:CreateDropdown("Rares List", bongkoc.rares, function(Option) end)
raresettings:CreateButton("Copy Token List Link", function()
    api.notify("Bongkoc " .. temptable.version, "Copied link to clipboard!", 2)
    setclipboard("https://pastebin.com/raw/wtHBD3ij")
end)
raresettings:CreateButton("Copy Token List Link(Updated)", function()
    api.notify("Bongkoc " .. temptable.version, "Copied link to clipboard!", 2)
    setclipboard("https://pastebin.com/raw/CpHMJ5Eh")
end)
local dispsettings = setttab:CreateSection("Auto Dispenser & Auto Boosters Settings")
guiElements["dispensesettings"]["rj"] = dispsettings:CreateToggle("Royal Jelly Dispenser", nil, function(State)
    bongkoc.dispensesettings.rj = not bongkoc.dispensesettings.rj
end)
guiElements["dispensesettings"]["blub"] = dispsettings:CreateToggle("Blueberry Dispenser", nil, function(State)
    bongkoc.dispensesettings.blub = not bongkoc.dispensesettings.blub
end)
guiElements["dispensesettings"]["straw"] = dispsettings:CreateToggle("Strawberry Dispenser", nil, function(State)
    bongkoc.dispensesettings.straw = not bongkoc.dispensesettings.straw
end)
guiElements["dispensesettings"]["treat"] = dispsettings:CreateToggle("Treat Dispenser", nil, function(State)
    bongkoc.dispensesettings.treat = not bongkoc.dispensesettings.treat
end)
guiElements["dispensesettings"]["coconut"] = dispsettings:CreateToggle("Coconut Dispenser", nil, function(State)
    bongkoc.dispensesettings.coconut = not bongkoc.dispensesettings.coconut
end)
guiElements["dispensesettings"]["glue"] = dispsettings:CreateToggle("Glue Dispenser", nil, function(State)
    bongkoc.dispensesettings.glue = not bongkoc.dispensesettings.glue
end)
guiElements["dispensesettings"]["white"] = dispsettings:CreateToggle("Mountain Top Booster", nil, function(State)
    bongkoc.dispensesettings.white = not bongkoc.dispensesettings.white
end)
guiElements["dispensesettings"]["blue"] = dispsettings:CreateToggle("Blue Field Booster", nil, function(State)
    bongkoc.dispensesettings.blue = not bongkoc.dispensesettings.blue
end)
guiElements["dispensesettings"]["red"] = dispsettings:CreateToggle("Red Field Booster", nil, function(State)
    bongkoc.dispensesettings.red = not bongkoc.dispensesettings.red
end)
local guisettings = setttab:CreateSection("GUI Settings")
local uitoggle = guisettings:CreateToggle("UI Toggle", nil, function(State)
    Window:Toggle(State)
end)
uitoggle:CreateKeybind(tostring(Config.Keybind):gsub("Enum.KeyCode.", ""),
                       function(Key) Config.Keybind = Enum.KeyCode[Key] end)
uitoggle:SetState(true)
local UIColorPicker = guisettings:CreateColorpicker("UI Color", function(Color) Window:ChangeColor(Color) end)
repeat 
    task.wait()
until UIColorPicker:GetObject() and UIColorPicker:GetObject():FindFirstChild("Color")
UIColorPicker:GetObject().Color.BackgroundColor3 = Config.Color
local themes = guisettings:CreateDropdown("Image", {
    "Default", "Hearts", "Abstract", "Hexagon", "Circles", "Lace With Flowers", "Floral"
}, function(Name)
    if Name == "Default" then
        Window:SetBackground("2151741365")
    elseif Name == "Hearts" then
        Window:SetBackground("6073763717")
    elseif Name == "Abstract" then
        Window:SetBackground("6073743871")
    elseif Name == "Hexagon" then
        Window:SetBackground("6073628839")
    elseif Name == "Circles" then
        Window:SetBackground("6071579801")
    elseif Name == "Lace With Flowers" then
        Window:SetBackground("6071575925")
    elseif Name == "Floral" then
        Window:SetBackground("5553946656")
    end
end)
themes:SetOption("Hexagon")
local bongkocs = setttab:CreateSection("Configs")
bongkocs:CreateTextBox("Config Name", "ex: stumpconfig", false, function(Value) temptable.configname = Value end)
bongkocs:CreateButton("Load Config", function()
    if not isfile("bongkoc/BSS_" .. temptable.configname .. ".json") then
        api.notify("Bongkoc " .. temptable.version, "No such config file!", 2)
    else
        bongkoc = game:service("HttpService"):JSONDecode(readfile("bongkoc/BSS_" .. temptable.configname .. ".json"))
        for i,v in pairs(guiElements) do
            for j,k in pairs(v) do
                local obj = k:GetObject()
                local lastCharacters = obj.Name:reverse():sub(0, obj.Name:reverse():find(" ")):reverse()
                if bongkoc[i][j] then
                    if lastCharacters == " Dropdown" then
                        obj.Container.Value.Text = bongkoc[i][j]
                    elseif lastCharacters == " Slider" then
                        task.spawn(function()
                            local Tween = game:GetService("TweenService"):Create(
                                obj.Slider.Bar,
                                TweenInfo.new(1),
                                {Size = UDim2.new((tonumber(bongkoc[i][j]) - k:GetMin()) / (k:GetMax() - k:GetMin()), 0, 1, 0)}
                            )
                            Tween:Play()
                            local startStamp = tick()
                            local startValue = tonumber(obj.Value.PlaceholderText)
                            while tick() - startStamp < 1 do
                                task.wait()
                                local partial = tick() - startStamp
                                local value = (startValue + ((tonumber(bongkoc[i][j]) - startValue) * partial))
                                obj.Value.PlaceholderText = math.round(value * 100) / 100
                            end
                            obj.Value.PlaceholderText = tonumber(bongkoc[i][j])
                        end)
                    elseif lastCharacters == " Toggle" then
                        obj.Toggle.BackgroundColor3 = bongkoc[i][j] and Config.Color or Color3.fromRGB(50,50,50)
                    elseif lastCharacters == " TextBox" then
                        obj.Background.Input.Text = bongkoc[i][j]
                    end
                end
            end
        end
    end
end)
bongkocs:CreateButton("Save Config", function()
    writefile("bongkoc/BSS_" .. temptable.configname .. ".json", game:service("HttpService"):JSONEncode(bongkoc))
end)
bongkocs:CreateButton("Reset Config", function() bongkoc = defaultbongkoc end)
local fieldsettings = setttab:CreateSection("Fields Settings")
guiElements["bestfields"]["white"] = fieldsettings:CreateDropdown("Best White Field", temptable.whitefields, function(Option)
    bongkoc.bestfields.white = Option
end)
guiElements["bestfields"]["red"] = fieldsettings:CreateDropdown("Best Red Field", temptable.redfields, function(Option)
    bongkoc.bestfields.red = Option
end)
guiElements["bestfields"]["blue"] = fieldsettings:CreateDropdown("Best Blue Field", temptable.bluefields, function(Option)
    bongkoc.bestfields.blue = Option
end)
fieldsettings:CreateDropdown("Field", fieldstable, function(Option) temptable.blackfield = Option end)
fieldsettings:CreateButton("Add Field To Blacklist", function()
    table.insert(bongkoc.blacklistedfields, temptable.blackfield)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Blacklisted Fields Dropdown", true):Destroy()
    fieldsettings:CreateDropdown("Blacklisted Fields", bongkoc.blacklistedfields, function(Option) end)
end)
fieldsettings:CreateButton("Remove Field From Blacklist", function()
    table.remove(bongkoc.blacklistedfields, api.tablefind(bongkoc.blacklistedfields, temptable.blackfield))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Blacklisted Fields Dropdown", true):Destroy()
    fieldsettings:CreateDropdown("Blacklisted Fields", bongkoc.blacklistedfields, function(Option) end)
end)
fieldsettings:CreateDropdown("Blacklisted Fields", bongkoc.blacklistedfields, function(Option) end)
local aqs = setttab:CreateSection("Auto Quest Settings")

guiElements["toggles"]["allquests"] = aqs:CreateToggle("Non-Repeatable Quests", nil, function(State) bongkoc.toggles.allquests = State end)
guiElements["toggles"]["buckobeequests"] = aqs:CreateToggle("Bucko Bee Quests", nil, function(State) bongkoc.toggles.buckobeequests = State end)
guiElements["toggles"]["rileybeequests"] = aqs:CreateToggle("Riley Bee Quests", nil, function(State) bongkoc.toggles.rileybeequests = State end)
guiElements["toggles"]["blackbearquests"] = aqs:CreateToggle("Black Bear Quests", nil, function(State) bongkoc.toggles.blackbearquests = State end)
guiElements["toggles"]["brownbearquests"] = aqs:CreateToggle("Brown Bear Quests", nil, function(State) bongkoc.toggles.brownbearquests = State end)
guiElements["toggles"]["polarbearquests"] = aqs:CreateToggle("Polar Bear Quests", nil, function(State) bongkoc.toggles.polarbearquests = State end)

guiElements["vars"]["questcolorprefer"] = aqs:CreateDropdown("Only Farm Ants From NPC", {
    "Any NPC", "Bucko Bee", "Riley Bee"
}, function(Option) 
    bongkoc.vars.questcolorprefer = Option
end)
guiElements["toggles"]["tptonpc"] = aqs:CreateToggle("Teleport To NPC", nil, function(State) bongkoc.toggles.tptonpc = State end)
guiElements["toggles"]["autoquesthoneybee"] = aqs:CreateToggle("Include Honey Bee Quests", nil, function(State) bongkoc.toggles.autoquesthoneybee = State end)
guiElements["toggles"]["buyantpass"] = aqs:CreateToggle("Buy Ant Pass When Needed", nil, function(State) bongkoc.toggles.buyantpass = State end)
guiElements["toggles"]["smartmobkill"] = aqs:CreateToggle("Modify Mob Kill To Match Quests", nil, function(State) bongkoc.toggles.smartmobkill = State end)
guiElements["toggles"]["usegumdropsforquest"] = aqs:CreateToggle("Use Gumdrops For Goo Quests", nil, function(State) bongkoc.toggles.usegumdropsforquest = State end)


local pts = setttab:CreateSection("Autofarm Priority Tokens")
pts:CreateTextBox("Asset ID", "rbxassetid", false, function(Value) rarename = Value end)
pts:CreateButton("Add Token To Priority List", function()
    table.insert(bongkoc.priority, rarename)
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Priority List Dropdown", true):Destroy()
    pts:CreateDropdown("Priority List", bongkoc.priority, function(Option) end)
end)
pts:CreateButton("Remove Token From Priority List", function()
    table.remove(bongkoc.priority, api.tablefind(bongkoc.priority, rarename))
    game:GetService("CoreGui"):FindFirstChild(_G.windowname).Main:FindFirstChild("Priority List Dropdown", true):Destroy()
    pts:CreateDropdown("Priority List", bongkoc.priority, function(Option) end)
end)
pts:CreateDropdown("Priority List", bongkoc.priority, function(Option) end)

local optimize = extrtab:CreateSection("Optimization")
optimize:CreateButton("Hide nickname(Use In Public Servers)", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/nicknamespoofer.lua"))()end, {text = ""})
optimize:CreateButton("Boost FPS", function()loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/fpsboost.lua"))()end, {text = ""})
optimize:CreateButton("Destroy Decals(Not Recommended)", function()loadstring(game:HttpGet("https://raw.githubusercontent.com/BongoCaat/BSSBongo1/main/destroydecals.lua"))()end, {text = ""})
guiElements["toggles"]["visualnight"] = optimize:CreateToggle("Loops Visual Night", nil, function(State) bongkoc.toggles.visualnight = State end)
guiElements["toggles"]["disablerender"] = optimize:CreateToggle("Disable 3D Render On Unfocus", nil, function(State) bongkoc.toggles.disablerender = State end)
optimize:CreateToggle("Disable 3D Render", nil, function(State) game:GetService("RunService"):Set3dRenderingEnabled(not State) end)
optimize:CreateTextBox("Ping Spoofer", "Add ms to ping", true, function(Option) settings():GetService("NetworkSettings").IncomingReplicationLag = tonumber(Option)/1000 or 0 end)

-- Rendering game

game:GetService("UserInputService").WindowFocused:Connect(function()
	if bongkoc.toggles.disablerender then
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
end)

game:GetService("UserInputService").WindowFocusReleased:Connect(function()
	if bongkoc.toggles.disablerender then
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end
end)

--[[local buysection = premiumtab:CreateSection("Buy")
buysection:CreateLabel("Support the developer of bongkoc v3!")
buysection:CreateButton("Copy Shirt Link", function()
    api.notify("bongkoc " .. temptable.version, "Copied link to clipboard!", 2)
    setclipboard("https://www.roblox.com/catalog/8958348861/bongkoc-Honey-Bee-Design")
end)
buysection:CreateLabel("Without them this project")
buysection:CreateLabel("wouldn"t be possible")

local miscsection = premiumtab:CreateSection("Misc")
miscsection:CreateLabel("bongkoc Premium includes:")
miscsection:CreateLabel("Glider Speed Modifier [" .. getgenv().Star .. "]")
miscsection:CreateLabel("Glider Float Exploit [" .. getgenv().Star .. "]")

local autofarmingsection = premiumtab:CreateSection("Auto Farming")
autofarmingsection:CreateLabel("bongkoc Premium includes:")
autofarmingsection:CreateLabel("Windy Bee Server Hopper [" .. getgenv().Star .. "]")
autofarmingsection:CreateLabel("Smart Bubble Bloat [" .. getgenv().Star .. "]")

local autojellysection = premiumtab:CreateSection("Auto Jelly")
autojellysection:CreateLabel("bongkoc Premium includes:")
autojellysection:CreateLabel("Auto Jelly [" .. getgenv().Star .. "]")
autojellysection:CreateLabel("Incredibly intricate yet simple to use")
autojellysection:CreateLabel("to get you the perfect hive!")

local autonectarsection = premiumtab:CreateSection("Auto Nectar")
autonectarsection:CreateLabel("bongkoc Premium includes:")
autonectarsection:CreateLabel("Auto Nectar [" .. getgenv().Star .. "]")

local webhooksection = premiumtab:CreateSection("Webhook")
webhooksection:CreateLabel("bongkoc Premium includes:")
webhooksection:CreateLabel("Enable Webhook [" .. getgenv().Star .. "]")
webhooksection:CreateLabel("The perfect way to track your exact")
webhooksection:CreateLabel("progress even from your mobile device!")
]]
loadingUI:UpdateText("Loaded UI")
local loadingLoops = loadingInfo:CreateLabel("Loading Loops..")

task.spawn(function() while task.wait() do
	pcall(function()
		game.Players.LocalPlayer.CameraMinZoomDistance, game.Players.LocalPlayer.CameraMaxZoomDistance = 0x0, 0x400 end)
end end)

local demontoggleouyfyt = false
task.spawn(function()
	while wait(1) do
		if temptable.started.mondo or temptable.started.monsters or temptable.started.vicious or temptable.started.windy or bongkoc.toggles.traincrab or bongkoc.toggles.traincommando or bongkoc.toggles.trainsnail then
			if demontoggleouyfyt == false then
				demontoggleouyfyt = true
				game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer("Equip", {Mute=false;Type="Demon Mask";Category="Accessory"})
			end
		else
			if demontoggleouyfyt == true then
				demontoggleouyfyt = false
				game:GetService("ReplicatedStorage").Events.ItemPackageEvent:InvokeServer("Equip", {Mute=false;Type=bongkoc.vars.defmask;Category="Accessory"})
            end
		end
	end
end)


local honeytoggleouyfyt = false
task.spawn(function()
    while task.wait(0.5) do
        if bongkoc.toggles.honeymaskconv then
            if temptable.converting or temptable.collecting.collecthoneytoken then
                if not honeytoggleouyfyt then
                    honeytoggleouyfyt = true
                    wait(1.5)
                    maskequip("Honey Mask")
                end
            else
                if honeytoggleouyfyt then
                    honeytoggleouyfyt = false
                    wait(1)
                    maskequip(bongkoc.vars.defmask)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(5) do
        local buffs = fetchBuffTable(buffTable)
        for i, v in pairs(buffTable) do
            buffTable[i].b = bongkoc.vars["autouse"..i]
            if v["b"] then
                local inuse = false
                for k, p in pairs(buffs) do
                    if k == i then inuse = true end
                end
                if not inuse then
                    playeractivescommand:FireServer({["Name"] = i})
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        --if temptable.collecting.tickets then continue end
        if bongkoc.toggles.autofarm then
            if bongkoc.toggles.farmbubbles then 
                dobubbles()
            end
            --[[if bongkoc.toggles.farmcoco then
                getcoco()
            end
            if bongkoc.toggles.collectcrosshairs then 
                docrosshairs()
            end]]
            if bongkoc.toggles.farmfuzzy then
                getfuzzy()
            end
            if bongkoc.toggles.farmglitchedtokens then
                getglitchtoken()
            end
            if bongkoc.toggles.farmflame then
                getflame()
            end
        end
    end
end)

game.Workspace.Camera.DupedTokens.ChildAdded:Connect(function(v)
    if not temptable.started.vicious and not temptable.started.windy and not temptable.started.ant and not temptable.planting and not temptable.converting and not temptable.started.monsters then
        if v.Name == "C" and v:FindFirstChild("FrontDecal") and string.find(v.FrontDecal.Texture,"5877939956") and not temptable.started.vicious and not temptable.started.monsters and bongkoc.toggles.autofarm and not temptable.started.ant and bongkoc.toggles.farmglitchedtokens and (v.Position - api.humanoidrootpart().Position).magnitude < temptable.magnitude and not temptable.converting then
            table.insert(temptable.glitcheds, v)
            getglitchtoken(v)
            gettoken()
        end
    end
end)

game.Workspace.Particles.ChildAdded:Connect(function(v)
    if not temptable.started.vicious and not temptable.started.windy and not temptable.started.ant then
        if v.Name == "WarningDisk" and not temptable.started.vicious and bongkoc.toggles.autofarm and not temptable.started.ant and bongkoc.toggles.farmcoco and (v.Position - api.humanoidrootpart().Position).magnitude < temptable.magnitude and not temptable.converting then
            table.insert(temptable.coconuts, v)
            getcoco(v)
            gettoken()
        elseif v.Name == "Crosshair" and v ~= nil and v.BrickColor ~= BrickColor.new("Forest green") and not temptable.started.ant and v.BrickColor ~= BrickColor.new("Flint") and (v.Position - api.humanoidrootpart().Position).magnitude < temptable.magnitude and bongkoc.toggles.autofarm and bongkoc.toggles.collectcrosshairs and not temptable.converting then
            if #temptable.crosshairs <= 3 then
                table.insert(temptable.crosshairs, v)
                getcrosshairs(v)
                gettoken()
    --[[if (v:IsA("Part") or v:IsA("MeshPart")) and not temptable.started.ant and not temptable.started.vicious and bongkoc.toggles.autofarm and not temptable.converting and not temptable.planting then
        if v.Name == "WarningDisk" and bongkoc.toggles.farmcoco and (v.Position - api.humanoidrootpart().Position).magnitude < temptable.magnitude then
            table.insert(temptable.coconuts, v)
            getcoco(v)
            gettoken()
            task.wait(0.05)
            if v.BrickColor == BrickColor.new("Lime green") then
                task.wait(0.5)
                if (v.Position - api.humanoidrootpart().Position).magnitude > 100 then return end
                if temptable.lookat then
                    api.humanoidrootpart().Velocity = Vector3.new(0, 0, 0)
                    api.humanoidrootpart().CFrame = CFrame.new(v.CFrame.p, temptable.lookat)
                    task.wait()
                    api.humanoidrootpart().CFrame = CFrame.new(v.CFrame.p, temptable.lookat)
                else
                    api.humanoidrootpart().Velocity = Vector3.new(0, 0, 0)
                    api.humanoidrootpart().CFrame = CFrame.new(v.CFrame.p)
                    task.wait()
                    api.humanoidrootpart().CFrame = CFrame.new(v.CFrame.p)
                end
            end
        elseif v.Name == "Crosshair" and bongkoc.toggles.collectcrosshairs then
            task.wait(0.1)
            if v ~= nil and v.BrickColor ~= BrickColor.new("Forest green") and not temptable.started.ant and v.BrickColor ~= BrickColor.new("Flint") and (v.Position-api.humanoidrootpart().Position).magnitude < temptable.magnitude and bongkoc.toggles.autofarm and bongkoc.toggles.collectcrosshairs and not temptable.converting then
                if #temptable.crosshairs <= 3 then
                    table.insert(temptable.crosshairs, v)
                    getcrosshairs(v)
                    gettoken()
                end
            end
            local timestamp = Instance.new("NumberValue", v)
            timestamp.Name = "timestamp"
            timestamp.Value = tick()
        elseif string.find(v.Name, "Bubble") and getBuffTime("5101328809") > 0.2 and bongkoc.toggles.farmbubbles then
            if not bongkoc.toggles.farmpuffshrooms or (bongkoc.toggles.farmpuffshrooms and not game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model")) then
                if (v.Position - api.humanoidrootpart().Position).magnitude > 100 then return end
                table.insert(temptable.bubbles, v)]]
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        temptable.magnitude = 50
        if player.Character:FindFirstChild("ProgressLabel", true) then
            local pollenprglbl = player.Character:FindFirstChild("ProgressLabel", true)
            local maxpollen = tonumber(pollenprglbl.Text:match("%d+$"))
            local pollencount = player.CoreStats.Pollen.Value
            temptable.pollenpercentage = pollencount / maxpollen * 100
            fieldselected = game.Workspace.FlowerZones[bongkoc.vars.field]

            if bongkoc.toggles.autouseconvertors then
                if tonumber(temptable.pollenpercentage) >= (bongkoc.vars.convertat - (bongkoc.vars.autoconvertWaitTime)) then
                    if not temptable.consideringautoconverting then
                        temptable.consideringautoconverting = true
                        task.spawn(function()
                            task.wait(bongkoc.vars.autoconvertWaitTime)
                            if tonumber(temptable.pollenpercentage) >= (bongkoc.vars.convertat - (bongkoc.vars.autoconvertWaitTime)) then
                                useConvertors()
                            end
                            temptable.consideringautoconverting = false
                        end)
                    end
                end
            end

            --[[if bongkoc.toggles.killstickbug and temptable.sbready then
                local event = game.ReplicatedStorage.Events:FindFirstChild("SelectNPCOption")
                if event then
                    event:FireServer("StartFreeStickBugEvent")
                end
                temptable.sbready = false
            end
            if lastfieldpos ~= fieldpos then
                task.wait(0.5)
                gettoken()
            end]]
            if bongkoc.toggles.autofarm then
                temptable.usegumdropsforquest = false
                if bongkoc.toggles.autodoquest and player.PlayerGui.ScreenGui.Menus.Children.Quests.Content:FindFirstChild("Frame") --[[and not bongkoc.toggles.farmboostedfield]] then
                    for i, v in next, player.PlayerGui.ScreenGui.Menus.Children.Quests:GetDescendants() do
                        if v.Name == "Description" and v.Parent and v.Parent.Parent then
                            local text = v.Text
                            local questName = v.Parent.Parent.TitleBar.Text
                            local pollentypes = {
                                "White Pollen", "Red Pollen", "Blue Pollen", "Blue Flowers", "Red Flowers", "White Flowers"
                            }
                            if (bongkoc.toggles.buckobeequests and questName:find("Bucko Bee")) or (bongkoc.toggles.rileybeequests and questName:find("Riley Bee")) or (bongkoc.toggles.polarbearquests and questName:find("Polar Bear")) or (bongkoc.toggles.brownbearquests and questName:find("Brown Bear")) or (bongkoc.toggles.blackbearquests and questName:find("Black Bear")) or (bongkoc.toggles.allquests and not questName:find("Bear:") and not questName:find("Bee:")) then
                                if not string.find(v.Text, "Puffshroom") then
                                    if text:find(" Goo ") then
                                        temptable.usegumdropsforquest = true
                                        if string.find(v.Text, "Complete!") then
                                            temptable.usegumpdropsforquest = false
                                        end
                                    end
                                    if api.returnvalue(fieldstable, text) and not string.find(v.Text, "Complete!") and not api.findvalue(bongkoc.blacklistedfields, api.returnvalue(fieldstable, text)) then
                                        d = api.returnvalue(fieldstable, text)
                                        fieldselected = game.Workspace.FlowerZones[d]
                                        break
                                    elseif api.returnvalue(pollentypes, text) and not string.find(v.Text, "Complete!") then
                                        d = api.returnvalue(pollentypes, text)
                                        if d == "Blue Flowers" or d == "Blue Pollen" then
                                            fieldselected = game.Workspace.FlowerZones[bongkoc.bestfields.blue]
                                            break
                                        elseif d == "White Flowers" or d == "White Pollen" then
                                            fieldselected = game.Workspace.FlowerZones[bongkoc.bestfields.white]
                                            break
                                        elseif d == "Red Flowers" or d == "Red Pollen" then
                                            fieldselected = game.Workspace.FlowerZones[bongkoc.bestfields.red]
                                            break
                                        end
                                    elseif questName:find("Bee") and string.find(text, "Feed") and not string.find(text, "Complete!") and not v:FindFirstChild("done") then
                                        local amount, kind = unpack((text:sub(6, text:find("to")-2)):split(" "))
                                        if amount and kind then
                                            if kind == "Blueberries" then
                                                --temptable.feed(bongkoc.beessettings.general.x, bongkoc.beessettings.general.y, "Blueberry", 5)
                                                game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg:InvokeServer(1, 1, "Blueberry", amount, false)
                                            elseif kind == "Strawberries" then
                                                --temptable.feed(bongkoc.beessettings.general.x, bongkoc.beessettings.general.y, "Strawberry", 5)
                                                game:GetService("ReplicatedStorage").Events.ConstructHiveCellFromEgg:InvokeServer(1, 1, "Strawberry", amount, false)
                                            end                                            
                                            local done = Instance.new("BoolValue", v)
                                            done.Name = "done"
                                            break
                                        end
                                    elseif string.find(text, "Ants.") and not string.find(text, "Complete!") then
                                        if rtsg().Eggs.AntPass == 0 and bongkoc.toggles.buyantpass then
                                            game.ReplicatedStorage.Events.ToyEvent:FireServer("Ant Pass Dispenser")
                                            task.wait(0.5)
                                        end
                                        if not game.Workspace.Toys["Ant Challenge"].Busy.Value and rtsg().Eggs.AntPass > 0 then
                                            if bongkoc.vars.questcolorprefer == "Any NPC" then
                                                farmant()
                                            else
                                                if questName:find(bongkoc.vars.questcolorprefer) then
                                                    farmant()
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        if i == #player.PlayerGui.ScreenGui.Menus.Children.Quests:GetDescendants() then
                            if bongkoc.toggles.followplayer then
                                local playerToFollow = game.Players:FindFirstChild(bongkoc.vars.playertofollow)
                                if playerToFollow and playerToFollow.Character and playerToFollow.Character:FindFirstChild("HumanoidRootPart") then
                                    fieldselected = findField(playerToFollow.Character.HumanoidRootPart.CFrame.p)
                                    if not fieldselected or tostring(fieldselected) == "Ant Field" then
                                        fieldselected = game.Workspace.FlowerZones[bongkoc.vars.field]
                                    end
                                end
                            else
                                fieldselected = game.Workspace.FlowerZones[bongkoc.vars.field]
                            end
                        end
                    end
                else
                    if bongkoc.toggles.followplayer then
                        local playerToFollow = game.Players:FindFirstChild(bongkoc.vars.playertofollow)
                        if playerToFollow and playerToFollow.Character and playerToFollow.Character:FindFirstChild("HumanoidRootPart") then
                            fieldselected = findField(playerToFollow.Character.HumanoidRootPart.CFrame.p)
                            if not fieldselected then
                                fieldselected = game.Workspace.FlowerZones[bongkoc.vars.field]
                            end
                        end
                    else
                        fieldselected = game.Workspace.FlowerZones[bongkoc.vars.field]
                    end
                end

                --[[local colorGroup = fieldselected:FindFirstChild("ColorGroup")
                if bongkoc.toggles.autoequipmask then 
                    if colorGroup then
                        if colorGroup.Value == "Red" then
                            maskequip("Demon Mask")
                        elseif colorGroup and colorGroup.Value == "Blue" then
                            maskequip("Diamond Mask")
                        else
                            maskequip("Gummy Mask")
                        end
                    end
                end]]

                local onlyonesprinkler = false

                fieldpos = CFrame.new(
                    fieldselected.Position.X,
                    fieldselected.Position.Y + 3,
                    fieldselected.Position.Z
                )
                fieldposition = fieldselected.Position
                if temptable.sprouts.detected and temptable.sprouts.coords and bongkoc.toggles.farmsprouts and not temptable.planting and not temptable.started.windy and not temptable.started.vicious and not temptable.detected.windy and not temptable.detected.vicious then
                    onlyonesprinkler = true
                    fieldposition = temptable.sprouts.coords.Position
                    fieldpos = temptable.sprouts.coords
                end
                --[[if bongkoc.toggles.instantconverters and temptable.sprouts.detected or temptable.sprouts.coords or game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") then
                    playeractivescommand:FireServer({["Name"] = "Micro-Converter"})
		            pollenpercentage = 100
                end]]
                if bongkoc.toggles.farmpuffshrooms and game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") and not temptable.planting and not temptable.started.windy and not temptable.started.vicious and not temptable.detected.windy and not temptable.detected.vicious then
                    local mythics = {}
                    local legendaries = {}
                    local epics = {}
                    local rares = {}
                    local commons = {}

                    local function isPuffInField(stem)
                        if stem and player.Character:FindFirstChild("HumanoidRootPart") then
                            return findField(stem.CFrame.p) == findField(api.humanoidrootpart().CFrame.p)
                        end
                        return false
                    end

                    for _,puffshroom in pairs(game.Workspace.Happenings.Puffshrooms:GetChildren()) do
                        local stem = puffshroom:FindFirstChild("Puffball Stem")
                        if stem then
                            if string.find(puffshroom.Name, "Mythic") then
                                table.insert(mythics, {stem, isPuffInField(stem)})
                            elseif string.find(puffshroom.Name, "Legendary") then
                                table.insert(legendaries, {stem, isPuffInField(stem)})
                            elseif string.find(puffshroom.Name, "Epic") then
                                table.insert(epics, {stem, isPuffInField(stem)})
                            elseif string.find(puffshroom.Name, "Rare") then
                                table.insert(rares, {stem, isPuffInField(stem)})
                            else
                                table.insert(commons, {stem, isPuffInField(stem)})
                            end
                        end
                    end

                    if #mythics ~= 0 then
                        for _,v in pairs(mythics) do
                            local stem, infield = unpack(v)
                            fieldpos = stem.CFrame
                        end
                        for _,v in pairs(mythics) do
                            local stem, infield = unpack(v)
                            if infield then
                                fieldpos = stem.CFrame
                            end
                        end
                    elseif #legendaries ~= 0 then
                        for _,v in pairs(legendaries) do
                            local stem, infield = unpack(v)
                            fieldpos = stem.CFrame
                        end
                        for _,v in pairs(legendaries) do
                            local stem, infield = unpack(v)
                            if infield then
                                fieldpos = stem.CFrame
                            end
                        end
                    elseif #epics ~= 0 then
                        for _,v in pairs(epics) do
                            local stem, infield = unpack(v)
                            fieldpos = stem.CFrame
                        end
                        for _,v in pairs(epics) do
                            local stem, infield = unpack(v)
                            if infield then
                                fieldpos = stem.CFrame
                            end
                        end
                    elseif #rares ~= 0 then
                        for _,v in pairs(rares) do
                            local stem, infield = unpack(v)
                            fieldpos = stem.CFrame
                        end
                        for _,v in pairs(rares) do
                            local stem, infield = unpack(v)
                            if infield then
                                fieldpos = stem.CFrame
                            end
                        end
                    elseif #commons ~= 0 then
                        fieldpos = api.getbiggestmodel(game.Workspace.Happenings.Puffshrooms):FindFirstChild("Puffball Stem").CFrame
                        for _,v in pairs(commons) do
                            local stem, infield = unpack(v)
                            if infield then
                                fieldpos = stem.CFrame
                            end
                        end
                    end

                    fieldposition = fieldpos.Position
                    temptable.magnitude = 35
                    onlyonesprinkler = true

                    --[[fieldselected = findField(fieldposition)
                    if fieldselected then
                        local colorGroup = fieldselected:FindFirstChild("ColorGroup")
                        if bongkoc.toggles.autoequipmask then 
                            if colorGroup then
                                if colorGroup.Value == "Red" then
                                    maskequip("Demon Mask")
                                elseif colorGroup and colorGroup.Value == "Blue" then
                                    maskequip("Diamond Mask")
                                else
                                    maskequip("Gummy Mask")
                                end
                            end
                        end
                    end]]
                end
                
                if bongkoc.toggles.convertballoons and not temptable.planting and not temptable.started.vicious and not temptable.started.windy and not temptable.detected.windy and not temptable.detected.vicious and bongkoc.vars.convertballoonpercent and gethiveballoon() and getBuffTime("8083443467") < tonumber(bongkoc.vars.convertballoonpercent) / 100 then
                    temptable.tokensfarm = false
                    api.tween(2, player.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 3))
                    task.wait(2)
                    api.humanoidrootpart().Velocity = Vector3.new(0, 0, 0)
                    api.tween(0.1, player.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 3))
                    temptable.converting = true
                    repeat converthoney() until player.CoreStats.Pollen.Value == 0
                    if bongkoc.toggles.convertballoons and gethiveballoon() then
                        task.wait(10)
                        repeat
                            task.wait()
                            converthoney()
                        until gethiveballoon() == false or not bongkoc.toggles.convertballoons
                    end
                    temptable.converting = false
                    temptable.act = temptable.act + 1
                    task.wait(6)
                    if bongkoc.toggles.autoant and not game.Workspace.Toys["Ant Challenge"].Busy.Value and rtsg().Eggs.AntPass > 0 then
                        farmant()
                    end
                    if bongkoc.toggles.autoquest then
                        makequests()
                    end
                    if bongkoc.toggles.autokillmobs and not temptable.started.vicious and not temptable.started.windy and not temptable.detected.windy and not temptable.detected.vicious and not temptable.planting then
                        if tick() - temptable.lastmobkill >= bongkoc.vars.monstertimer * 60 then
                            temptable.lastmobkill = tick()
                            temptable.started.monsters = true
                            temptable.act = 0
                            killmobs()
                            temptable.started.monsters = false
                        end
                    end
                    if bongkoc.vars.resetbeenergy then
                        if temptable.act2 >= bongkoc.vars.resettimer then
                            temptable.started.monsters = true
                            temptable.act2 = 0
                            repeat 
                                task.wait()
                            until player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
                            player.Character:BreakJoints()
                            task.wait(6.5)
                            repeat 
                                task.wait()
                            until player.Character
                            player.Character:BreakJoints()
                            task.wait(6.5)
                            repeat
                                task.wait()
                            until player.Character
                            temptable.started.monsters = false
                        end
                    end
                end
                if tonumber(temptable.pollenpercentage) < tonumber(bongkoc.vars.convertat) or bongkoc.toggles.disableconversion and not temptable.planting then
                    if not temptable.tokensfarm then
                        api.tween(2, fieldpos)
                        task.wait(2)
                        temptable.tokensfarm = true
                        if bongkoc.toggles.autosprinkler then
                            makesprinklers(fieldposition, onlyonesprinkler)
                            task.wait(0.5)
                            playeractivescommand:FireServer({["Name"] = "Sprinkler Builder"})
                        end
                    else
                        if not game.Workspace.MonsterSpawners.CoconutCrab.Attachment.TimerGui.TimerLabel.Visible and not temptable.started.vicious and not temptable.started.monsters and not temptable.started.windy and not temptable.detected.windy and not temptable.detected.vicious and findField(fieldposition).Name == "Coconut Field" then
                            maskequip("Demon Mask")
                            temptable.started.crab = true
                            while not game.Workspace.MonsterSpawners.CoconutCrab.Attachment.TimerGui.TimerLabel.Visible and not temptable.started.vicious and not temptable.started.monsters and not temptable.started.windy and not temptable.detected.windy and not temptable.detected.vicious and findField(fieldposition).Name == "Coconut Field" do
                                task.wait()
                                if api.humanoidrootpart() then
                                    api.humanoidrootpart().CFrame = CFrame.new(-307.52117919922, 110.11863250732, 467.86791992188)
                                end
                            end
                        end
                        temptable.started.crab = false
                        if bongkoc.toggles.killmondo then
                            while bongkoc.toggles.killmondo and game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") and not temptable.started.vicious and not temptable.started.windy and not temptable.planting and not temptable.started.monsters do
                                temptable.started.mondo = true
                                while game.Workspace.Monsters:FindFirstChild("Mondo Chick (Lvl 8)") and bongkoc.toggles.killmondo do
                                    disableall()
                                    game.Workspace.Map.Ground.HighBlock.CanCollide = false
                                    mondopition = game.Workspace.Monsters["Mondo Chick (Lvl 8)"].Head.Position
                                    api.tween(0.015, CFrame.new(
                                        mondopition.x,
                                        mondopition.y - 59.90,
                                        mondopition.z)
                                    )
                                    task.wait(0.85)
                                    temptable.float = true
                                end
                                task.wait(0.25)
                                game.Workspace.Map.Ground.HighBlock.CanCollide = true
                                temptable.float = false
                                api.tween(0.355, CFrame.new(73.2, 176.35, -167))
                                task.wait(0.8)
                                for i = 0, 50 do
                                    gettoken(CFrame.new(73.2, 176.35, -167).Position)
                                end
                                enableall()
                                api.tween(1.65, fieldpos)
                                temptable.started.mondo = false
                            end
                        end
                        if lastfieldpos ~= fieldpos then
                            task.wait(0.4)
                            gettoken()
                        end
                        --if bongkoc.toggles.farmboostedfield then farmboostedfield() end
                        if (fieldposition - api.humanoidrootpart().Position).magnitude > temptable.magnitude and findField(api.humanoidrootpart().CFrame.p) ~= findField(fieldposition) and not temptable.planting and not temptable.doingcrosshairs and not temptable.doingbubbles then
                            api.tween(0.1, fieldpos)
                            task.spawn(function()
                                task.wait(0.45)
                                if bongkoc.toggles.autosprinkler then
                                    makesprinklers(fieldposition, onlyonesprinkler)
                                end
                            end)
                        end
                        getprioritytokens()
                        if bongkoc.toggles.farmflame then 
                            getflame()
                        end
                        if bongkoc.toggles.avoidmobs then
                            avoidmob()
                        end
                        if bongkoc.toggles.farmclosestleaf then
                            closestleaf()
                        end
                        if bongkoc.toggles.farmfireflies then
                            getfireflies()
                        end
                        if bongkoc.toggles.farmsparkles then
                            getsparkles()
                        end
                        if bongkoc.toggles.farmclouds then
                            getcloud()
                        end
                        if bongkoc.toggles.farmunderballoons then
                            getballoons()
                        end
                        if not bongkoc.toggles.donotfarmtokens then
                            gettoken(nil, bongkoc.toggles.newtokencollection)
                        end
                        if not bongkoc.toggles.farmflower then
                            getflower()
                        end
                        if bongkoc.toggles.farmpuffshrooms and game.Workspace.Happenings.Puffshrooms:FindFirstChildOfClass("Model") and not temptable.planting then
                            getpuff()
                        end
                        if bongkoc.toggles.autox4 then
                            doautox4()
                        end
                        if temptable.usegumdropsforquest and bongkoc.toggles.usegumdropsforquest and tick() - temptable.lastgumdropuse > 3 then
                            temptable.lastgumdropuse = tick()
                            playeractivescommand:FireServer({["Name"] = "Gumdrops"})
                        end
                    end

                elseif tonumber(temptable.pollenpercentage) >= tonumber(bongkoc.vars.convertat) and not bongkoc.toggles.convertion --[[and not bongkoc.toggles.disableconversion]] and not temptable.started.vicious and not temptable.started.windy and not temptable.planting and not temptable.detected.windy and not temptable.detected.vicious then
                    if not bongkoc.toggles.disableconversion then
                        temptable.tokensfarm = false
                        api.tween(2, player.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 3))
                        task.wait(2)
                        api.humanoidrootpart().Velocity = Vector3.new(0, 0, 0)
                        api.tween(0.1, player.SpawnPos.Value * CFrame.fromEulerAnglesXYZ(0, 110, 0) + Vector3.new(0, 0, 3))
                        temptable.converting = true
                        repeat converthoney() until player.CoreStats.Pollen.Value == 0
                        if bongkoc.toggles.convertballoons and bongkoc.vars.convertballoonpercent == 0 and gethiveballoon() then
                            task.wait(10)
                            repeat
                                task.wait()
                                converthoney()
                            until gethiveballoon() == false or not bongkoc.toggles.convertballoons
                        end
                        equiptool(bongkoc.vars.deftool)
                        temptable.converting = false
                        temptable.act = temptable.act + 1
                        task.wait(6)
                        if bongkoc.toggles.autoant and not game.Workspace.Toys["Ant Challenge"].Busy.Value and rtsg().Eggs.AntPass > 0 then
                            farmant()
                        end
                        if bongkoc.toggles.autoquest then
                            makequests()
                        end
                        if bongkoc.toggles.autohoneywreath then
                            wait(2)
                        end
                        if bongkoc.toggles.autokillmobs and not temptable.started.vicious and not temptable.started.windy and not temptable.detected.windy and not temptable.detected.vicious then
                            if tick() - temptable.lastmobkill >= bongkoc.vars.monstertimer * 60 then
                                temptable.lastmobkill = tick()
                                temptable.started.monsters = true
                                temptable.act = 0
                                killmobs()
                                temptable.started.monsters = false
                            end
                        end
                        if bongkoc.vars.resetbeenergy then
                            if temptable.act2 >= bongkoc.vars.resettimer then
                                temptable.started.monsters = true
                                temptable.act2 = 0
                                repeat 
                                    task.wait()
                                until player.Character and player.Character:FindFirstChild("Humanoid") and player.Character.Humanoid.Health > 0
                                player.Character:BreakJoints()
                                task.wait(6.5)
                                repeat 
                                    task.wait()
                                until player.Character
                                player.Character:BreakJoints()
                                task.wait(6.5)
                                repeat
                                    task.wait()
                                until player.Character
                                temptable.started.monsters = false
                            end
                        end
                    end
                end
                lastfieldpos = fieldpos
            end
        end
    end
end)

--stickbug
--[[function checksbcooldown()
	local cooldown = time() - tonumber(stickbug_time)
	if not sbfirstcheck or cooldown > 1800 and not temptable.started.vicious and not temptable.started.windy then
		sbfirstcheck = true
		for i,v in next, game:GetService("Workspace").NPCs:GetChildren() do
			if v.Name == "Stick Bug" then
				if v:FindFirstChild("Platform") then
					if v.Platform:FindFirstChild("AlertPos") then
						if v.Platform.AlertPos:FindFirstChild("AlertGui") then
							if v.Platform.AlertPos.AlertGui:FindFirstChild("ImageLabel") then
								image = v.Platform.AlertPos.AlertGui.ImageLabel
								button = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ActivateButton.MouseButton1Click
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Platform.Position.X, v.Platform.Position.Y+3, v.Platform.Position.Z)
								task.wait(1)					
								for b,z in next, getconnections(button) do
									z.Function()
								end
								task.wait(1)
								break
							end
						end
					end
				end
			end
		end
		task.wait(1)
		local ScreenGui = game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("ScreenGui")	
		firesignal(ScreenGui.NPC.OptionFrame.Option3.MouseButton1Click)
		task.wait(1)
		firesignal(ScreenGui.NPC.ButtonOverlay.MouseButton1Click)
		task.wait(1)
		local sbReady = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.NPC.OptionFrame:FindFirstChild("Option1").Text	
		local sbtime = string.match(sbReady, "[%d:]+")
		if sbtime ~= nil then
			temptable.sbready = false
			mobsb:UpdateText("Stick Bug: "..tostring(sbtime))
		else
			temptable.sbready = true
			mobsb:UpdateText("Stick Bug: Ready")
		end
		stickbug_time = time()
	end
end


function DefenseTotemHP()
	local dtHP = 0
	for i,v in pairs(game:GetService("Workspace").Particles.StickBugTotem:GetChildren()) do
		--print(v.Name)
		if v:FindFirstChild("GuiPos") then
			if v:FindFirstChild("GuiPos"):FindFirstChild("Gui") then
				if v:FindFirstChild("GuiPos"):FindFirstChild("Gui"):FindFirstChild("Frame") then
					if v:FindFirstChild("GuiPos"):FindFirstChild("Gui"):FindFirstChild("Frame"):FindFirstChild("TextLabel") then
						local GuiText = v:FindFirstChild("GuiPos"):FindFirstChild("Gui"):FindFirstChild("Frame"):FindFirstChild("TextLabel")
						dtHP = tonumber(GuiText.Text)
						return dtHP
					end
				end
			end
		end
	end
end

 -- Auto Stick Bug
task.spawn(function()
    while task.wait(1) do
		if bongkoc.toggles.killstickbug and not temptable.started.windy and not temptable.started.vicious then
			local sbTime = 99
			local sbTimer = game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ChallengeInfo.SBChallengeInfo:FindFirstChild("TimeValue").Text
			if string.find(sbTimer, "s") then
				sbTime = string.gsub(sbTimer,"s","")
			end
			if tonumber(sbTime) < 15 then
				print("Stick Bug Challenge has finished " .. sbTimer)
				game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.ChallengeInfo.SBChallengeInfo:FindFirstChild("TimeValue").Text = "10:00"
				if temptable.started.stickbug then
					enableall()
					temptable.started.stickbug = false
					--print("Inside of sbTimer = 10:00")
					if bongkoc.toggles.godmode then
						print("disabling godmode")
						bongkoc.toggles.godmode = false
						--godmode:SetState(false)
						bssapi:godmode(false)
                        			temptable.float = false
					end
				end

			elseif sbTimer ~= "10:00" then
				if not temptable.started.stickbug then
					temptable.started.stickbug = true
					disableall()
					if not bongkoc.toggles.godmode then
						print("enabling godmode")
						bongkoc.toggles.godmode = true
						bssapi:godmode(true)
						--godmode:SetState(true)
					end
				end

				for i,v in pairs(workspace.Monsters:GetChildren()) do
					if string.find(v.Name,"Stick Bug") then
						print("Now attacking " .. v.Name)
						if game.Workspace.Particles:FindFirstChild("PollenHealthBar") then
							local sbpollenpos = game.Workspace.Particles:FindFirstChild("PollenHealthBar").Position
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(sbpollenpos.x,sbpollenpos.y,sbpollenpos.z)
							task.wait(1)
							temptable.magnitude = 23
							while game.Workspace.Particles:FindFirstChild("PollenHealthBar") do
								sbpollenpos = game.Workspace.Particles:FindFirstChild("PollenHealthBar").Position
								if (sbpollenpos-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > temptable.magnitude then
									api.tween(.2, CFrame.new(sbpollenpos.x, sbpollenpos.y, sbpollenpos.z))
								end
								gettoken(sbpollenpos)

								--game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(sbpollenpos.x,sbpollenpos.y,sbpollenpos.z)
								task.wait()					
							end
							for i = 1, 2 do gettoken(api.humanoidrootpart().Position) end
						end

						if game.Workspace.Monsters:FindFirstChild(v.Name) then
							local sbexists = game.Workspace.Monsters[v.Name]
							local sbposition = game.Workspace.Monsters[v.Name].Head.Position
							api.tween(.2, CFrame.new(sbposition.x, sbposition.y - 2, sbposition.z))
							task.wait(1)
							if bongkoc.toggles.autosprinkler then
								makesprinklers(position, onlyonesprinkler)
							end

							local sblvl = v.Name:gsub("%D+", "")
							if tonumber(sblvl) > 6 then 
								local buffs = fetchBuffTable(buffTable)
								if not tablefind(buffs, "Oil") then
									if GetItemListWithValue()["Oil"] > 0 then
										game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Oil"})
									end					
								end
								if not tablefind(buffs, "Jelly Beans") then
									if GetItemListWithValue()["JellyBeans"] > 0 then
										game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Jelly Beans"})
									end					
								end
							 end						
						end

						while game.Workspace.Monsters:FindFirstChild(v.Name) and not game.Workspace.Particles:FindFirstChild("StickBugTotem") do
							sbposition = game.Workspace.Monsters[v.Name].Head.Position
							if tonumber(sbposition.y) > 1000 then
								break
							end
							if (sbposition-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude > temptable.magnitude then
								api.tween(.2, CFrame.new(sbposition.x, sbposition.y - 2, sbposition.z))
							end
							gettoken(sbposition)
							local buffs = fetchBuffTable(buffTable)
							if not tablefind(buffs, "Jelly Beans") then
								if GetItemListWithValue()["JellyBeans"] > 0 then
									game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Jelly Beans"})
								end					
							end
							if not tablefind(buffs, "Stinger") then
								if GetItemListWithValue()["Stinger"] > 0 then
									game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Stinger"})
								end					
							end
							task.wait()
						end
						temptable.float = false

						if game.Workspace.Particles:FindFirstChild("StickBugTotem") then
							for j,k in pairs(game:GetService("Workspace").Particles.StickBugTotem:GetChildren()) do
								if k:FindFirstChild("NamePos") then
									game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(k.Position.x,k.Position.y,k.Position.z)
									break
								end				
							end
							task.wait(1)
							if bongkoc.toggles.autosprinkler then
								makesprinklers(position, onlyonesprinkler)
							end
							while game.Workspace.Particles:FindFirstChild("StickBugTotem") do
								gettoken(api.humanoidrootpart().Position)
								task.wait()
							end				
							for i = 1, 2 do gettoken(api.humanoidrootpart().Position) end
						else
							task.wait(1)
							[if bongkoc.toggles.autosprinkler then
								makesprinklers(fieldposition, onlyonesprinkler)
							end
							for i =1, 3 do gettoken(api.humanoidrootpart().Position) end			
						end
						break
					end
				end
			end
		end
	end
end)
--stickbug
]]

task.spawn(function()
    while task.wait(1) do
        if GetItemListWithValue()["Stinger"] > 0 and bongkoc.toggles.autousestinger then
            game:GetService("ReplicatedStorage").Events.PlayerActivesCommand:FireServer({["Name"] = "Stinger"})
            task.wait(30)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if bongkoc.toggles.killvicious and temptable.detected.vicious and not bongkoc.toggles.traincrab and not temptable.converting and not temptable.planting and not bongkoc.toggles.trainsnail and not temptable.started.commando and not temptable.started.mondo and not temptable.started.monsters and not game.Workspace.Toys["Ant Challenge"].Busy.Value then
            temptable.started.vicious = true
            disableall()
            local vichumanoid = api.humanoidrootpart()
            for i, v in next, game.workspace.Particles:GetChildren() do
                for x in string.gmatch(v.Name, "Vicious") do
                    if string.find(v.Name, "Vicious") then
                        api.tween(1, CFrame.new(v.Position.x, v.Position.y, v.Position.z))
                        task.wait(1)
                        api.tween(0.5, CFrame.new(v.Position.x, v.Position.y, v.Position.z))
                        task.wait(.5)
                    end
                end
            end
            for i, v in next, game.workspace.Particles:GetChildren() do
                for x in string.gmatch(v.Name, "Vicious") do
                    while bongkoc.toggles.killvicious and
                        temptable.detected.vicious do
                        task.wait()
                        if string.find(v.Name, "Vicious") then
                            for i = 1, 4 do
                                temptable.float = true
                                vichumanoid.CFrame =
                                    CFrame.new(v.Position.x + 10, v.Position.y,
                                               v.Position.z)
                                task.wait(.3)
                            end
                        end
                    end
                end
            end
            enableall()
            task.wait(1)
			temptable.float = false
            temptable.started.vicious = false
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if bongkoc.toggles.killwindy and temptable.detected.windy and not bongkoc.toggles.traincrab and not temptable.converting and not temptable.started.commando and not temptable.planting and not temptable.started.vicious and not temptable.started.mondo and not bongkoc.toggles.trainsnail and not temptable.started.monsters and not game.Workspace.Toys["Ant Challenge"].Busy.Value then
            temptable.started.windy = true
            local windytokendb = false
            local windytokentp = false
            local wlvl = ""
            local aw = false
            local awb = false -- some variable for autowindy, yk?
            disableall()
            local oldmask = rtsg()["EquippedAccessories"]["Hat"]
            maskequip("Demon Mask")
            while bongkoc.toggles.killwindy and temptable.detected.windy do
                if not aw then
                    for i, v in pairs(workspace.Monsters:GetChildren()) do
                        if string.find(v.Name, "Windy") then
                            wlvl = v.Name
                            aw = true -- we found windy!
                        end
                    end
                end
                if aw then
                    for i, v in pairs(workspace.Monsters:GetChildren()) do
                        if string.find(v.Name, "Windy") then
                            if v.Name ~= wlvl then
                                temptable.float = false
                                task.wait(2)
                                api.humanoidrootpart().CFrame = temptable.gacf(temptable.windy, 5)
                                task.wait(2)
                                for i = 1, 3 do
                                    gettoken(api.humanoidrootpart().Position)
                                end -- collect tokens :yessir:
                                wlvl = v.Name
                            end
                        end
                    end
                end
                if not awb then
                    api.tween(1, temptable.gacf(temptable.windy, 5))
                    task.wait(2)
                    api.tween(1, temptable.gacf(temptable.windy, 5))
                    task.wait(2)
                    awb = true
                end
                if awb and temptable.windy and temptable.windy.Name == "Windy" then
                    task.spawn(function()
                        if not windytokendb then
                            for _,token in pairs(workspace.Collectibles:GetChildren()) do
                                decal = token:FindFirstChildOfClass("Decal")
                                if decal and decal.Texture == "rbxassetid://1629547638" and api.humanoidrootpart() then
                                    windytokendb = true
                                    windytokentp = true
                                    task.wait()
                                    for i=0,20 do
                                        api.humanoidrootpart().CFrame = token.CFrame
                                        task.wait()
                                    end
                                    windytokentp = false
                                    task.wait(3)
                                    windytokendb = false
                                    break
                                end
                            end
                        end
                    end)
                    if not windytokentp and api.humanoidrootpart() then
                        api.humanoidrootpart().CFrame = temptable.gacf(temptable.windy, 25)
                        temptable.float = true
                    end
                    task.wait()
                end
            end
            maskequip(oldmask)
            enableall()
            temptable.float = false
            temptable.started.windy = false
        end
    end
end)

game.Workspace.Collectibles.ChildAdded:Connect(function(token)
    if bongkoc.toggles.trainsnail then farmcombattokens(token, CFrame.new(game.Workspace.FlowerZones["Stump Field"].Position.X, game.Workspace.FlowerZones["Stump Field"].Position.Y-10, game.Workspace.FlowerZones["Stump Field"].Position.Z), "snail") end   
    if bongkoc.toggles.traincrab then farmcombattokens(token, CFrame.new(-256, 110, 475), "crab") end
    --if bongkoc.toggles.farmfireflies then farmcombattokens(token, CFrame.new(0, 2, 0), "Firefly") end
    --if bongkoc.toggles.farmsparkles then farmcombattokens(token, CFrame.new(0, 2, 0), "Sparkles") end
    if bongkoc.toggles.traincommando then farmcombattokens(token, CFrame.new(520.758, 58.8, 161.651), "commando") end
end)

task.spawn(function()
    while task.wait(0.03) do
        if bongkoc.toggles.autodig then
            if player.Character then
                local tool = player.Character:FindFirstChildOfClass("Tool")
                if tool then
                    local clickEvent = tool:FindFirstChild("ClickEvent", true)
                    if clickEvent then
                        clickEvent:FireServer()
                    end
                end
                if bongkoc.vars.autodigmode == "Collector Steal" then
                    local onett = game.Workspace.NPCs.Onett.Onett["Porcelain Dipper"]:FindFirstChild("ClickEvent")
                    --local spirit = game:GetService("Workspace").NPCs["Spirit Bear"]["Spirit Bear"]["Petal Wand"]:FindFirstChild("ClickEvent")
                    if onett then
                        task.wait()
                        --spirit:FireServer()
                        onett:FireServer()
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        --[[if bongkoc.toggles.traincrab and api.humanoidrootpart() then
            api.humanoidrootpart().CFrame = CFrame.new(-307.52117919922, 110.11863250732, 467.86791992188)
        end]]
        --[[if bongkoc.toggles.traincommando and api.humanoidrootpart() then
            api.humanoidrootpart().CFrame = CFrame.new(517.768, 58.75, 159.651)
        end]]
        --[[if bongkoc.toggles.trainsnail and api.humanoidrootpart() then
            local fd = game.Workspace.FlowerZones["Stump Field"]
            api.humanoidrootpart().CFrame = CFrame.new(
                fd.Position.X,
                fd.Position.Y - 20,
                fd.Position.Z
            )
        end]]
        if bongkoc.toggles.farmtickets and not temptable.planting then
            for k,v in next, game.workspace.Collectibles:GetChildren() do
                if v.CFrame.YVector.Y == 1 then
                    if v.Transparency == 0 then
                        decal = v:FindFirstChildOfClass("Decal")
                        if decal.Texture == "1674871631" or decal.Texture == "rbxassetid://1674871631" then
                            api.humanoidrootpart().CFrame = v.CFrame
                            break
                        end
                    end
                end
            end
        end
        if bongkoc.toggles.farmleaves and not temptable.planting and not temptable.converting then
            task.wait(3.85)
            for i, v in next, game.Workspace.Flowers:GetDescendants() do
                if v.Name == "LeafBurst" and v.Parent:IsA("Part") and v.Parent then
                    api.humanoidrootpart().CFrame = CFrame.new(v.Parent.Position)
                    break
                end
            end
        end
        if bongkoc.toggles.farmrares and not temptable.planting and not temptable.started.ant and not temptable.converting then
            for k, v in next, game.workspace.Collectibles:GetChildren() do
                if v.CFrame.YVector.Y == 1 then
                    if v.Transparency == 0 then
                        decal = v:FindFirstChildOfClass("Decal")
                        for e, r in next, bongkoc.rares do
                            if decal.Texture == r or decal.Texture == "rbxassetid://" .. r then
                                api.humanoidrootpart().CFrame = v.CFrame
                                break
                            end
                        end
                    end
                end
            end
        end
    end
end)

function farmcombattokens(v, pos, type)
    if type == "snail" then
        if v.CFrame.YVector.Y == 1 and v.Transparency == 0 and v ~= nil and v.Parent ~= nil then
            if (v.Position - pos.Position).Magnitude < 50 then
                repeat
                    task.wait()
                    api.walkTo(v.Position)
                until not v.Parent or v.CFrame.YVector.Y ~= 1 or not v
                api.teleport(pos)
            end
        end
    elseif type == "crab" then
        if v.CFrame.YVector.Y == 1 and v.Transparency == 0 and v ~= nil and v.Parent ~= nil then
            if (v.Position - pos.Position).Magnitude < 50 then
                repeat
                    task.wait()
                    api.walkTo(v.Position)
                until not v.Parent or v.CFrame.YVector.Y ~= 1 or not v
                api.teleport(pos)
            end
        end
    --[[elseif type == "Firefly" then
        if v.CFrame.YVector.Y == 1 and v.Transparency == 0 and v ~= nil and v.Parent ~= nil then
            if (v.Position - pos.Position).Magnitude < 25 then
                repeat
                    task.wait()
                    api.walkTo(v.Position)
                until not v.Parent or v.CFrame.YVector.Y ~= 1 or not v
            end
        end
    elseif type == "Sparkles" then
        if v.CFrame.YVector.Y == 1 and v.Transparency == 0 and v ~= nil and v.Parent ~= nil then
            if (v.Position - pos.Position).Magnitude < 20 then
                repeat
                    task.wait()
                    api.walkTo(v.Position)
                until not v.Parent or v.CFrame.YVector.Y ~= 1 or not v
            end
        end]]
    elseif type =="commando" then
        if v.CFrame.YVector.Y == 1 and v.Transparency == 0 and v ~= nil and v.Parent ~= nil then
            if (v.Position - pos.Position).Magnitude < 55 then
                repeat
                    task.wait()
                    api.walkTo(v.Position)
                until not v.Parent or v.CFrame.YVector.Y ~= 1 or not v
                api.teleport(pos)
            end
        end
    end
end

game.Workspace.Particles.Folder2.ChildAdded:Connect(function(child)
    if child.Name == "Sprout" then
        temptable.sprouts.detected = true
        temptable.sprouts.coords = child.CFrame
    end
end)
game.Workspace.Particles.Folder2.ChildRemoved:Connect(function(child)
    if child.Name == "Sprout" then
        task.wait(30)
        temptable.sprouts.detected = false
        temptable.sprouts.coords = ""
    end
end)

Workspace.Particles.ChildAdded:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = true
    end
end)
Workspace.Particles.ChildRemoved:Connect(function(instance)
    if string.find(instance.Name, "Vicious") then
        temptable.detected.vicious = false
    end
end)
game.Workspace.NPCBees.ChildAdded:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3)
        temptable.windy = v
        temptable.detected.windy = true
    end
end)
game.Workspace.NPCBees.ChildRemoved:Connect(function(v)
    if v.Name == "Windy" then
        task.wait(3)
        temptable.windy = nil
        temptable.detected.windy = false
    end
end)

task.spawn(function()
    while task.wait(0.05) do
        if bongkoc.toggles.autofarm and not temptable.planting and not temptable.started.vicious and not temptable.started.windy and not temptable.started.ant and not bongkoc.toggles.traincrab then
            if bongkoc.toggles.autosamovar then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Samovar")
                platformm = game.Workspace.Toys.Samovar.Platform
                for i, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    if (v.Position - platformm.Position).magnitude < 25 and
                        v.CFrame.YVector.Y == 1 then
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            if bongkoc.toggles.autostockings then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Stockings")
                platformm = game.Workspace.Toys.Stockings.Platform
                for i, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    if (v.Position - platformm.Position).magnitude < 25 and
                        v.CFrame.YVector.Y == 1 then
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            if bongkoc.toggles.autosnowmachine then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Snow Machine")
            end
            if bongkoc.toggles.autoonettart then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Onett's Lid Art")
                platformm = game.Workspace.Toys["Onett's Lid Art"]
                                .Platform
                for i, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    if (v.Position - platformm.Position).magnitude < 25 and
                        v.CFrame.YVector.Y == 1 then
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            --[[if temptable.collecting.collecthoneytoken then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Honey Wreath")
                platformm = game.Workspace.Toys["Honey Wreath"]
                                .Platform
                for i, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    if (v.Position - platformm.Position).magnitude < 25 and
                        v.CFrame.YVector.Y == 1 then
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end]]
            if bongkoc.toggles.autocandles then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Honeyday Candles")
                platformm = game.Workspace.Toys["Honeyday Candles"].Platform
                for i, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    if (v.Position - platformm.Position).magnitude < 25 and
                        v.CFrame.YVector.Y == 1 then
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            if bongkoc.toggles.autofeast then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer(
                    "Beesmas Feast")
                platformm = game.Workspace.Toys["Beesmas Feast"]
                                .Platform
                for i, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                    if (v.Position - platformm.Position).magnitude < 25 and
                        v.CFrame.YVector.Y == 1 then
                        api.humanoidrootpart().CFrame = v.CFrame
                    end
                end
            end
            if game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true) then
                local pollenprglbl = game.Players.LocalPlayer.Character:FindFirstChild("ProgressLabel",true)
                maxpollen = tonumber(pollenprglbl.Text:match("%d+$"))
                local pollencount = game.Players.LocalPlayer.CoreStats.Pollen.Value
                pollenpercentage = pollencount/maxpollen*100
                if tonumber(temptable.pollenpercentage) >= tonumber(bongkoc.vars.convertat) and not bongkoc.toggles.disableconversion then
                    if bongkoc.toggles.autohoneywreath then
                        temptable.collecting.collecthoneytoken = true
                        wait(10)
                        temptable.collecting.collecthoneytoken = false
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(.1) do
        if temptable.collecting.collecthoneytoken then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Honey Wreath")
            platformm = game.Workspace.Toys["Honey Wreath"]
                            .Platform
            for i, v in pairs(game.Workspace.Collectibles:GetChildren()) do
                if (v.Position - platformm.Position).magnitude < 25 and
                    v.CFrame.YVector.Y == 1 then
                    api.humanoidrootpart().CFrame = v.CFrame
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(2) do
        temptable.runningfor = temptable.runningfor + 1
        temptable.honeycurrent = statsget().Totals.Honey
        if bongkoc.toggles.honeystorm then
            game.ReplicatedStorage.Events.ToyEvent:FireServer("Honeystorm")
        end
        if bongkoc.toggles.summonfreestickbug then
            game:GetService("ReplicatedStorage").Events.SelectNPCOption:FireServer("StartFreeStickBugEvent")
        end
        if bongkoc.toggles.meteorshower then
            game.ReplicatedStorage.Events.ToyEvent:FireServer("Mythic Meteor Shower")
        end
        if bongkoc.toggles.autospawnsprout then
            game.ReplicatedStorage.Events.ToyEvent:FireServer("Sprout Summoner")
        end
        if bongkoc.toggles.collectgingerbreads then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Gingerbread House")
        end
        if bongkoc.toggles.autodispense then
            if bongkoc.dispensesettings.rj then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Free Royal Jelly Dispenser")
            end
            if bongkoc.dispensesettings.blub then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Blueberry Dispenser")
            end
            if bongkoc.dispensesettings.straw then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Strawberry Dispenser")
            end
            if bongkoc.dispensesettings.treat then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Treat Dispenser")
            end
            if bongkoc.dispensesettings.coconut then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Coconut Dispenser")
            end
            if bongkoc.dispensesettings.glue then
                game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Glue Dispenser")
            end
        end
        if bongkoc.toggles.autoboosters then
            if bongkoc.dispensesettings.white then
                game.ReplicatedStorage.Events.ToyEvent:FireServer("Field Booster")
            end
            if bongkoc.dispensesettings.red then
                game.ReplicatedStorage.Events.ToyEvent:FireServer("Red Field Booster")
            end
            if bongkoc.dispensesettings.blue then
                game.ReplicatedStorage.Events.ToyEvent:FireServer("Blue Field Booster")
            end
        end
        if bongkoc.toggles.clock then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Wealth Clock")
        end
        if bongkoc.toggles.freeantpass then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Free Ant Pass Dispenser")
        end
        if bongkoc.toggles.freerobopass then
            game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Free Robo Pass Dispenser")
        end
        if bongkoc.toggles.visualnight then
            game:GetService("Lighting").TimeOfDay = "00:00:00"
            game:GetService("Lighting").Brightness = 0.03
            game:GetService("Lighting").ClockTime = 0
        end
        if bongkoc.toggles.autoquest then
            local completeQuest = game.ReplicatedStorage.Events.CompleteQuestFromPool
            completeQuest:FireServer("Polar Bear")
            completeQuest:FireServer("Brown Bear 2")
            completeQuest:FireServer("Black Bear 2")
            completeQuest:FireServer("Bucko Bee")
            completeQuest:FireServer("Riley Bee")
            if bongkoc.toggles.autoquesthoneybee then
                completeQuest:FireServer("Honey Bee")
            end
            task.wait(1)
            local getQuest = game.ReplicatedStorage.Events.GiveQuestFromPool
            getQuest:FireServer("Polar Bear")
            getQuest:FireServer("Brown Bear 2")
            getQuest:FireServer("Black Bear 2")
            getQuest:FireServer("Bucko Bee")
            getQuest:FireServer("Riley Bee")
            if bongkoc.toggles.autoquesthoneybee then
                completeQuest:FireServer("Honey Bee")
            end
        end
        local gained = temptable.honeycurrent - temptable.honeystart
        gainedhoneylabel:UpdateText("Gained Honey: " .. api.suffixstring(gained))
        windyfavor:UpdateText("Windy Favor: "..rtsg()["WindShrine"]["WindyFavor"])
        uptimelabel:UpdateText("Uptime: " .. truncatetime(math.round(tick() - temptable.starttime)))
    end
end)

game:GetService("RunService").Heartbeat:connect(function()
    if bongkoc.toggles.autoquest and player:FindFirstChild("PlayerGui") and player.PlayerGui:FindFirstChild("ScreenGui") and player.PlayerGui.ScreenGui:FindFirstChild("NPC") and player.PlayerGui.ScreenGui.NPC.Visible then
        firesignal(player.PlayerGui.ScreenGui.NPC.ButtonOverlay.MouseButton1Click)
    end
    if bongkoc.toggles.loopspeed and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = bongkoc.vars.walkspeed
    end
    if bongkoc.toggles.loopjump and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = bongkoc.vars.jumppower
    end
end)

game:GetService("RunService").Heartbeat:connect(function()
    for _, v in next, player.PlayerGui.ScreenGui:WaitForChild("MinigameLayer"):GetChildren() do
        for _, q in next, v:WaitForChild("GuiGrid"):GetDescendants() do
            if q.Name == "ObjContent" or q.Name == "ObjImage" then
                q.Visible = true
            end
        end
    end
end)

game:GetService("RunService").Heartbeat:connect(function()
    if temptable.float and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.BodyTypeScale.Value = 0
        floatpad.CanCollide = true
        floatpad.CFrame = CFrame.new(
            api.humanoidrootpart().Position.X,
            api.humanoidrootpart().Position.Y - 3.75,
            api.humanoidrootpart().Position.Z
        )
        task.wait(0)
    else
        floatpad.CanCollide = false
    end
end)

local vu = game:GetService("VirtualUser")
player.Idled:connect(function()
    vu:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    vu:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
end)

local canTeleport = true
game:GetService("Workspace").Particles.Snowflakes.ChildAdded:Connect(function(snowflake)
    if canTeleport == true and bongkoc.toggles.farmsnowflakes == true then
        local hash = tostring(math.random(1,10000))
        snowflake.Name = hash
        canTeleport = false
        repeat
           task.wait()
           getgenv().temptable.float = true
           getgenv().temptable.sakatNoclip=true
           tweenService:Create(api.humanoidrootpart(), TweenInfo.new(((api.humanoidrootpart().Position - snowflake.Position)).Magnitude / 80), {CFrame = snowflake.CFrame}):Play();
           if (api.humanoidrootpart().Position - snowflake.Position).Magnitude <=15 then
           api.humanoidrootpart().CFrame = snowflake.CFrame + Vector3.new(0,7.5,0)
        end
        until game:GetService("Workspace").Particles.Snowflakes:FindFirstChild(hash) == nil
        getgenv().temptable.float = false
        getgenv().sakatNoclip = false
        task.wait(2)
        canTeleport = true
    end
end)

--[[function farmsnowflakes(v)
    if bongkoc.toggles.farmsnowflakes then
            temptable.collecting.snowflake = true
        local SnowflakePosition = v.Position
        api.teleport(CFrame.new(SnowflakePosition))
        temptable.float = true
        repeat
            task.wait()
        until not v.Parent or v.CFrame.YVector.Y ~= 1 
        if temptable.float then temptable.float = false end
        task.wait(1)
        temptable.collecting.snowflake = false
    end
end]]

--[[function farmtickets(v)
    if bongkoc.toggles.farmtickets then 
        if v.CFrame.YVector.Y == 1 and v.Transparency == 0 and v ~= nil and v.Parent ~= nil then 
            decal = v:FindFirstChildOfClass("Decal") 
            if decal.Texture ~= "1674871631" and decal.Texture ~= "rbxassetid://1674871631" then return end
            temptable.collecting.tickets = true
            temptable.float = true
            local reenablespeed = bongkoc.toggles.loopspeed
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(v.Position) * CFrame.new(math.random(20, 30), -3, math.random(-10, 10)) 
            repeat 
                task.wait() 
                api.humanoid().WalkSpeed = 25
                api.walkTo(v.Position)
            until not v.Parent or v.CFrame.YVector.Y ~= 1 or not v.Transparency == 0 or (v.Position-api.humanoidrootpart().Position).Magnitude > 50
            temptable.collecting.tickets = false
            if temptable.float then temptable.float = false end
            bongkoc.toggles.loopspeed = reenablespeed
            task.wait(math.random(1, 5)/10)
        end
    end 
end]]

player.CharacterAdded:Connect(function(char)
    humanoid = char:WaitForChild("Humanoid")
    humanoid.Died:Connect(function()
        if bongkoc.toggles.autofarm then
            temptable.dead = true
            bongkoc.toggles.autofarm = false
            temptable.converting = false
            temptable.farmtoken = false
        end
        if temptable.dead then
            task.wait(25)
            temptable.dead = false
            bongkoc.toggles.autofarm = true
            temptable.converting = false
            temptable.tokensfarm = true
        end
    end)
end)

--[[game.Workspace.Particles.Snowflakes.ChildAdded:Connect(function(Object)
    if bongkoc.toggles.farmsnowflakes and temptable.collecting.snowflake == false then farmsnowflakes(Object) end
end)]]

task.spawn(function() while task.wait(1) do
    if bongkoc.toggles.autoequipmask and not temptable.converting and not temptable.started.monsters and not temptable.started.windy and not temptable.planting and not temptable.started.vicious and not bongkoc.toggles.traincrab and not bongkoc.toggles.trainsnail and api.humanoidrootpart() then
        if findFieldWithRay(api.humanoidrootpart().Position, Vector3.new(0,-90,0)) then
            local MaskField = findFieldWithRay(api.humanoidrootpart().Position, Vector3.new(0,-90,0))
            local FieldColor
            if MaskField:FindFirstChild("ColorGroup") then FieldColor = MaskField:FindFirstChild("ColorGroup").Value else FieldColor = "White" end
            if temptable.LastFieldColor == FieldColor then continue end
            temptable.LastFieldColor = FieldColor
            if FieldColor == "Blue" then
                --maskequip("Bubble Mask")
                maskequip("Diamond Mask")
            elseif FieldColor == "Red" then
                --maskequip("Fire Mask")
                maskequip("Demon Mask")
            else
                --maskequip("Honey Mask")
                maskequip("Gummy Mask")
            end
        end
    end
end end)

game.Workspace.Particles:FindFirstChild("PopStars").ChildAdded:Connect(function(v)
    task.wait(0.3)
    if (v.Position - api.humanoidrootpart().Position).magnitude < 15 then
        temptable.foundpopstar = true
    end
end)

game.Workspace.Particles:FindFirstChild("PopStars").ChildRemoved:Connect(function(v)
    if (v.Position - api.humanoidrootpart().Position).magnitude < 15 then
        temptable.foundpopstar = false
    end
end)

for _, v in next, game.workspace.Collectibles:GetChildren() do
    if string.find(v.Name, "") then v:Destroy() end
end

task.spawn(function()
    while task.wait() do
        if player.Character:FindFirstChild("HumanoidRootPart") then
            local pos = api.humanoidrootpart().Position
            task.wait(0.00001)
            local currentSpeed = (pos - api.humanoidrootpart().Position).magnitude
            if currentSpeed > 0 then
                temptable.running = true
            else
                temptable.running = false
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        temptable.currtool = rtsg()["EquippedCollector"]
    end
end)

task.spawn(function()
    while task.wait() do
        local torso = player.Character:FindFirstChild("UpperTorso")
        
        if temptable.currtool == "Tide Popper" then
            temptable.lookat = getfurthestballoon() or fieldposition
        elseif temptable.currtool == "Petal Wand" then
            temptable.lookat = fieldposition
        elseif temptable.currtool == "Dark Scythe" then
            temptable.lookat = fieldposition
            for i,v in pairs(game.Workspace.PlayerFlames:GetChildren()) do
                if v:FindFirstChild("PF") and v.PF.Color.Keypoints[1].Value.G ~= 0 and (v.Position - torso.Position).magnitude < 20 then
                    temptable.lookat = v.Position
                end
            end
        end
        
        if not temptable.started.ant and not temptable.started.vicious and bongkoc.toggles.autofarm and not temptable.converting then
            if torso then
                local bodygyro = torso:FindFirstChildOfClass("BodyGyro")

                if not bodygyro then
                    bodygyro = Instance.new("BodyGyro")
                    bodygyro.D = 10
                    bodygyro.P = 5000
                    bodygyro.MaxTorque = Vector3.new(0, 0, 0)
                    bodygyro.Parent = torso
                end
                
                if bodygyro then
                    if fieldposition and temptable.lookat then
                        bodygyro.CFrame = CFrame.new(torso.CFrame.p, temptable.lookat)
                        bodygyro.MaxTorque = Vector3.new(0, math.huge, 0)
                        bodygyro.D = 10
                        bodygyro.P = 5000
                    elseif bodygyro then
                        bodygyro:Destroy()
                    end
                end
            end
        else
            if torso then
                local bodygyro = torso:FindFirstChildOfClass("BodyGyro")
                if bodygyro then
                    bodygyro:Destroy()
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.45) do
        for i,v in pairs(game.Workspace.Planters:GetChildren()) do
            if v.Name == "PlanterBulb" then
                local attach = v:FindFirstChild("Gui Attach")
                if attach then
                    local gui = attach:FindFirstChild("Planter Gui")
                    if gui then
                        gui.MaxDistance = 1e5
                        gui.Size = UDim2.new(30, 0, 10, 0)
                        
                        local text = gui.Bar.TextLabel
                        if text then
                            text.Size = UDim2.new(0.9, 0, 1, 0)
                            text.Position = UDim2.new(0.05, 0, 0, 0)
                        end
                    end
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(1.25) do
        if bongkoc.toggles.docustomplanters then
            local plantercycles = {
                {
                    {Planter = bongkoc.vars.customplanter11, Field = bongkoc.vars.customplanterfield11, Percent = bongkoc.vars.customplanterdelay11},
                    {Planter = bongkoc.vars.customplanter12, Field = bongkoc.vars.customplanterfield12, Percent = bongkoc.vars.customplanterdelay12},
                    {Planter = bongkoc.vars.customplanter13, Field = bongkoc.vars.customplanterfield13, Percent = bongkoc.vars.customplanterdelay13},
                    {Planter = bongkoc.vars.customplanter14, Field = bongkoc.vars.customplanterfield14, Percent = bongkoc.vars.customplanterdelay14},
                    {Planter = bongkoc.vars.customplanter15, Field = bongkoc.vars.customplanterfield15, Percent = bongkoc.vars.customplanterdelay15}
                },
                {
                    {Planter = bongkoc.vars.customplanter21, Field = bongkoc.vars.customplanterfield21, Percent = bongkoc.vars.customplanterdelay21},
                    {Planter = bongkoc.vars.customplanter22, Field = bongkoc.vars.customplanterfield22, Percent = bongkoc.vars.customplanterdelay22},
                    {Planter = bongkoc.vars.customplanter23, Field = bongkoc.vars.customplanterfield23, Percent = bongkoc.vars.customplanterdelay23},
                    {Planter = bongkoc.vars.customplanter24, Field = bongkoc.vars.customplanterfield24, Percent = bongkoc.vars.customplanterdelay24},
                    {Planter = bongkoc.vars.customplanter25, Field = bongkoc.vars.customplanterfield25, Percent = bongkoc.vars.customplanterdelay25}
                },
                {
                    {Planter = bongkoc.vars.customplanter31, Field = bongkoc.vars.customplanterfield31, Percent = bongkoc.vars.customplanterdelay31},
                    {Planter = bongkoc.vars.customplanter32, Field = bongkoc.vars.customplanterfield32, Percent = bongkoc.vars.customplanterdelay32},
                    {Planter = bongkoc.vars.customplanter33, Field = bongkoc.vars.customplanterfield33, Percent = bongkoc.vars.customplanterdelay33},
                    {Planter = bongkoc.vars.customplanter34, Field = bongkoc.vars.customplanterfield34, Percent = bongkoc.vars.customplanterdelay34},
                    {Planter = bongkoc.vars.customplanter35, Field = bongkoc.vars.customplanterfield35, Percent = bongkoc.vars.customplanterdelay35}
                }
            }

            local steps = {
                5, 5, 5
            }

            for i,cycle in pairs(plantercycles) do
                for j,step in pairs(cycle) do
                    if not step.Planter or not step.Planter:find("Planter") then
                        steps[i] = steps[i] - 1
                    elseif not step.Field or (not step.Field:find("Field") and not step.Field:find("Patch") and not step.Field:find("Forest")) then
                        steps[i] = steps[i] - 1
                    end
                end
            end

            for i=1,3 do
                if not isfile("bongkoc/plantercache/cycle"..i.."cache.file") then
                    for _,planter in pairs(fetchAllPlanters()) do
                        RequestCollectPlanter(planter)
                    end
                    writefile("bongkoc/plantercache/cycle"..i.."cache.file", "1")
                end
            end

            if not temptable.started.ant and bongkoc.toggles.autofarm and not temptable.converting and not temptable.started.monsters then
                for i,cycle in pairs(plantercycles) do
                    if steps[i] == 0 then continue end
                    local planted = false
                    local currentstep = isfile("bongkoc/plantercache/cycle"..i.."cache.file") and tonumber(readfile("bongkoc/plantercache/cycle"..i.."cache.file")) or 1
                    currentstep = (currentstep - 1) % steps[i] + 1
                    for j,step in pairs(cycle) do
                        if step.Percent and step.Planter and step.Planter:find("Planter") and step.Field and (step.Field:find("Field") or step.Field:find("Patch") or step.Field:find("Forest")) then
                            for _,planter in pairs(fetchAllPlanters()) do
                                if planter.PotModel and planter.PotModel.Parent and planter.PotModel.PrimaryPart then
                                    if planter.GrowthPercent > step.Percent / 100 then
                                        if planter.PotModel.Name == step.Planter and getPlanterLocation(planter.PotModel.PrimaryPart) == step.Field then
                                            RequestCollectPlanter(planter)
                                        end
                                    else
                                        if planter.PotModel.Name == step.Planter and getPlanterLocation(planter.PotModel.PrimaryPart) == step.Field then
                                            planted = true
                                        end
                                    end
                                end
                            end
                        end
                    end
                    if not planted and cycle[currentstep].Planter and #fetchAllPlanters() < 3 then
                        local planter = cycle[currentstep].Planter
                        if planter == "The Planter Of Plenty" and GetItemListWithValue()["PlentyPlanter"] and GetItemListWithValue()["PlentyPlanter"] > 0 then
                            PlantPlanter(planter, cycle[currentstep].Field)
                            writefile("bongkoc/plantercache/cycle"..i.."cache.file", tostring((currentstep - 1) % steps[i] + 2))
                        else
                            if GetItemListWithValue()[planter:gsub(" Planter", "") .. "Planter"] and GetItemListWithValue()[planter:gsub(" Planter", "") .. "Planter"] > 0 then
                                PlantPlanter(planter:gsub(" Planter", ""), cycle[currentstep].Field)
                                writefile("bongkoc/plantercache/cycle"..i.."cache.file", tostring((currentstep - 1) % steps[i] + 2))
                            end
                        end
                    end
                end
            end
        else
            NectarBlacklist["Invigorating"] = bongkoc.toggles.blacklistinvigorating and "Invigorating" or nil
            NectarBlacklist["Comforting"] = bongkoc.toggles.blacklistcomforting and "Comforting" or nil
            NectarBlacklist["Motivating"] = bongkoc.toggles.blacklistmotivating and "Motivating" or nil
            NectarBlacklist["Refreshing"] = bongkoc.toggles.blacklistrefreshing and "Refreshing" or nil
            NectarBlacklist["Satisfying"] = bongkoc.toggles.blacklistsatisfying and "Satisfying" or nil

            planterData["Paper"] = not bongkoc.toggles.paperplanter and fullPlanterData["Paper"] or nil
            planterData["Ticket"] = not bongkoc.toggles.ticketplanter and fullPlanterData["Ticket"] or nil
            planterData["Plastic"] = not bongkoc.toggles.plasticplanter and fullPlanterData["Plastic"] or nil
            planterData["Candy"] = not bongkoc.toggles.candyplanter and fullPlanterData["Candy"] or nil
            planterData["Red Clay"] = not bongkoc.toggles.redclayplanter and fullPlanterData["Red Clay"] or nil
            planterData["Blue Clay"] = not bongkoc.toggles.blueclayplanter and fullPlanterData["Blue Clay"] or nil
            planterData["Tacky"] = not bongkoc.toggles.tackyplanter and fullPlanterData["Tacky"] or nil
            planterData["Hydroponic"] = not bongkoc.toggles.hydroponicplanter and fullPlanterData["Hydroponic"] or nil
            planterData["Heat-Treated"] = not bongkoc.toggles.heattreatedplanter and fullPlanterData["Heat-Treated"] or nil
            planterData["Pesticide"] = not bongkoc.toggles.pesticideplanter and fullPlanterData["Pesticide"] or nil
            planterData["Petal"] = not bongkoc.toggles.petalplanter and fullPlanterData["Petal"] or nil
            planterData["Festive"] = not bongkoc.toggles.festiveplanter and fullPlanterData["Festive"] or nil

            if bongkoc.toggles.autoplanters and not temptable.started.ant and not temptable.started.vicious and not temptable.started.windy and not temptable.started.mondo and not temptable.collecting.collecthoneytoken and not temptable.started.monsters and bongkoc.toggles.autofarm and not temptable.converting then
                RequestCollectPlanters(fetchAllPlanters())
                if #fetchAllPlanters() < 3 then
                    local LeastNectar = calculateLeastNectar(fetchNectarBlacklist())
                    local Field = fetchBestFieldWithNectar(LeastNectar)
                    local Planter = fetchBestMatch(LeastNectar, Field)
                    if LeastNectar and Field and Planter then
                        print(formatString(Planter, Field, LeastNectar))
                        PlantPlanter(Planter, Field)
                    end
                end
            end
        end
    end
end)

loadingLoops:UpdateText("Loaded Loops")

local function getMonsterName(name)
    local newName = nil
    local keywords = {
        ["Mushroom"] = "Ladybug",
        ["Rhino"] = "Rhino Beetle",
        ["Spider"] = "Spider",
        ["Ladybug"] = "Ladybug",
        ["Scorpion"] = "Scorpion",
        ["Mantis"] = "Mantis",
        ["Beetle"] = "Rhino Beetle",
        ["Tunnel"] = "Tunnel Bear",
        ["Coco"] = "Coconut Crab",
        ["Commando"] = "Commando Chick",
        ["King"] = "King Beetle",
        ["Stump"] = "Stump Snail",
        ["Were"] = "Werewolf"
    }
    for i, v in pairs(keywords) do
        if string.find(string.upper(name), string.upper(i)) then
            newName = v
            break
        end
    end
    if newName == nil then newName = name end
    return newName
end

local function getNearestField(part)
    local resultingFieldPos
    local lowestMag = math.huge
    for i, v in pairs(game.Workspace.FlowerZones:GetChildren()) do
        if (v.Position - part.Position).magnitude < lowestMag then
            lowestMag = (v.Position - part.Position).magnitude
            resultingFieldPos = v.Position
        end
    end
    if lowestMag > 100 then
        resultingFieldPos = part.Position + Vector3.new(0, 0, 10)
    end
    if string.find(part.Name, "Tunnel") then
        resultingFieldPos = part.Position + Vector3.new(20, -70, 0)
    end
    return resultingFieldPos
end

local function fetchVisualMonsterString(v)
    local mobText = nil
    if v:FindFirstChild("Attachment") then
        if v.Attachment:FindFirstChild("TimerGui") then
            if v.Attachment.TimerGui:FindFirstChild("TimerLabel") then
                if v.Attachment.TimerGui.TimerLabel.Visible then
                    local splitTimer = string.split(v.Attachment.TimerGui.TimerLabel.Text, " ")
                    if splitTimer[3] ~= nil then
                        mobText = getMonsterName(v.Name) .. ": " .. splitTimer[3]
                    elseif splitTimer[2] ~= nil then
                        mobText = getMonsterName(v.Name) .. ": " .. splitTimer[2]
                    else
                        mobText = getMonsterName(v.Name) .. ": " .. splitTimer[1]
                    end
                else
                    mobText = getMonsterName(v.Name) .. ": Ready"
                end
            end
        end
    end
    return mobText
end

local function getToyCooldown(toy)
    local c = require(game.ReplicatedStorage.ClientStatCache):Get()
    local name = toy
    local t = workspace.OsTime.Value - c.ToyTimes[name]
    local cooldown = workspace.Toys[name].Cooldown.Value
    local u = cooldown - t
    local canBeUsed = false
    if string.find(tostring(u), "-") then canBeUsed = true end
    return u, canBeUsed
end


game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ChildAdded:Connect(function(child)
    if child.Name == "ErrorPrompt" and child:FindFirstChild("MessageArea") and child.MessageArea:FindFirstChild("ErrorFrame") then
        if bongkoc.vars.webhookurl ~= "" and httpreq then
            task.wait(1)
            disconnected(bongkoc.vars.webhookurl, bongkoc.vars.discordid, child.MessageArea.ErrorFrame.ErrorMessage.Text)
        end
        if bongkoc.toggles.shutdownkick then
            game:Shutdown()
        end
    end
end)

task.spawn(function()
    local timestamp = tick()
    while task.wait(15) do
        local timeout = false
        task.spawn(function()
            timeout = true
            task.wait(15)
            if timeout then
                if bongkoc.vars.webhookurl ~= "" and httpreq then
                    disconnected(bongkoc.vars.webhookurl, bongkoc.vars.discordid, "Server Timeout (Game Freeze)")
                end
                if bongkoc.toggles.shutdownkick then
                    game:Shutdown()
                end
            end
        end)
        local timestamp = tick()
        local statstable = playerstatsevent:InvokeServer()
        while task.wait() do
            if timeout then
                timeout = false
                break
            end
        end
    end
end)

task.spawn(function()
    local timestamp = tick()
    while task.wait(0.1) do
        if tick() - timestamp > bongkoc.vars.webhooktimer * 60 then
            if httpreq and bongkoc.vars.webhookurl ~= "" and bongkoc.toggles.webhookupdates then
                hourly(bongkoc.toggles.webhookping, bongkoc.vars.webhookurl, bongkoc.vars.discordid)
            end
            timestamp = tick()
        end
    end
end)

task.spawn(function()
    pcall(function()
        loadingInfo:CreateLabel("")
        loadingInfo:CreateLabel("Script loaded!")
        task.wait(2)
        pcall(function()
            for i, v in pairs(game.CoreGui:GetDescendants()) do
                if v.Name == "Startup Section" then
                    v.Parent.Parent.RightSide["Information Section"].Parent = v.Parent
                    v:Destroy()
                end
            end
        end)
        local panel = hometab:CreateSection("Mob Panel")
        local statusTable = {}
        for i, v in pairs(monsterspawners:GetChildren()) do
            if not string.find(v.Name, "CaveMonster") then
                local mobText = nil
                mobText = fetchVisualMonsterString(v)
                if mobText ~= nil then
                    local mob = panel:CreateButton(mobText, function()
                        api.tween(1, CFrame.new(getNearestField(v)))
                    end)
                    table.insert(statusTable, {mob, v})
                end
            end
        end
        local mob2 = panel:CreateButton("Mondo Chick: 00:00", function()
            api.tween(1,
                      game.Workspace.FlowerZones["Mountain Top Field"]
                          .CFrame)
        end)
        local panel2 = hometab:CreateSection("Utility Panel")
        local windUpd = panel2:CreateButton("Wind Shrine: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.NPCs["Wind Shrine"]
                           .Circle.Position + Vector3.new(0, 5, 0)))
        end)
        local rfbUpd = panel2:CreateButton("Red Field Booster: 00:00",
                                           function()
            api.tween(1,
                      CFrame.new(
                          game.Workspace.Toys["Red Field Booster"]
                              .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local bfbUpd = panel2:CreateButton("Blue Field Booster: 00:00",
                                           function()
            api.tween(1,
                      CFrame.new(
                          game.Workspace.Toys["Blue Field Booster"]
                              .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local wfbUpd = panel2:CreateButton("White Field Booster: 00:00",
                                           function()
            api.tween(1, 
                      CFrame.new(
                          game.Workspace.Toys["Field Booster"]
                              .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local cocoDispUpd = panel2:CreateButton("Coconut Dispenser: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Coconut Dispenser"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local glueDispUpd = panel2:CreateButton("Glue Dispenser: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Glue Dispenser"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local emmaUpd = panel2:CreateButton("Extreme Memory Match: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Extreme Memory Match"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local nmmaUpd = panel2:CreateButton("Night Memory Match: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Night Memory Match"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local mmmaUpd = panel2:CreateButton("Mega Memory Match: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Mega Memory Match"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local ic1 = panel2:CreateButton("Instant Converter: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Instant Converter"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local ic2 = panel2:CreateButton("Instant Converter B: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Instant Converter B"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local ic3 = panel2:CreateButton("Instant Converter C: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Instant Converter C"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local wcUpd = panel2:CreateButton("Wealth Clock: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Wealth Clock"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local hsmUpd = panel2:CreateButton("Honeystorm: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys.Honeystorm
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local mmsUpd = panel2:CreateButton("Mythic Meteor Shower: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Mythic Meteor Shower"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local panel3 = hometab:CreateSection("🎄Beesmas Panel🎄")
        local snoUpd = panel3:CreateButton("Snowbear: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys.Snowbear
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local honwUpd = panel3:CreateButton("Honey Wreath: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Honey Wreath"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local snomUpd = panel3:CreateButton("Snow Machine: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Snow Machine"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local samvUpd = panel3:CreateButton("Samovar: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys.Samovar
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local oneaUpd = panel3:CreateButton("Onett's Lid Art: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Onett's Lid Art"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local beefUpd = panel3:CreateButton("Beesmas Feast: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Beesmas Feast"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local honcUpd = panel3:CreateButton("Honeyday Candles: 00:00", function()
            api.tween(1,
                      CFrame.new(
                       game.Workspace.Toys["Honeyday Candles"]
                           .Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local stocUpd = panel3:CreateButton("Stockings: 00:00", function()
            api.tween(1, CFrame.new( game.Workspace.Toys.Stockings.Platform.Position + Vector3.new(0, 5, 0)))
        end)
        local utilities = {
            ["Red Field Booster"] = rfbUpd,
            ["Blue Field Booster"] = bfbUpd,
            ["Field Booster"] = wfbUpd,
            ["Coconut Dispenser"] = cocoDispUpd,
            ["Glue Dispenser"] = glueDispUpd,
            ["Extreme Memory Match"] = emmaUpd,
            ["Night Memory Match"] = nmmaUpd,
            ["Mega Memory Match"] = mmmaUpd,
            ["Instant Converter"] = ic1,
            ["Instant Converter B"] = ic2,
            ["Instant Converter C"] = ic3,
            ["Wealth Clock"] = wcUpd,
            ["Honeystorm"] = hsmUpd,
            ["Mythic Meteor Shower"] = mmsUpd,
            ["Snowbear"] = snoUpd,
            ["Honey Wreath"] = honwUpd,
            ["Snow Machine"] = snomUpd,
            ["Samovar"] = samvUpd,
            ["Onett's Lid Art"] = oneaUpd,
            ["Beesmas Feast"] = beefUpd,
            ["Honeyday Candles"] = honcUpd,
            ["Stockings"] = stocUpd
        }
        while task.wait(1) do
            if bongkoc.toggles.enablestatuspanel then
                for i, v in pairs(statusTable) do
                    if v[1] and v[2] then
                        v[1]:UpdateText(fetchVisualMonsterString(v[2]))
                    end
                end
                if workspace:FindFirstChild("Clock") then
                    if workspace.Clock:FindFirstChild("SurfaceGui") then
                        if workspace.Clock.SurfaceGui:FindFirstChild("TextLabel") then
                            if workspace.Clock.SurfaceGui:FindFirstChild("TextLabel").Text == "! ! !" then
                                mob2:UpdateText("Mondo Chick: Ready")
                            else
                                mob2:UpdateText("Mondo Chick: " .. string.gsub(string.gsub(workspace.Clock.SurfaceGui:FindFirstChild("TextLabel").Text, "", ""), "Mondo Chick:", ""))
                            end
                        end
                    end
                end
                local cooldown = require(game.ReplicatedStorage.TimeString)(
                                     3600 -
                                         (require(game.ReplicatedStorage.OsTime)() -
                                             (require(
                                                 game.ReplicatedStorage
                                                     .StatTools).GetLastCooldownTime(
                                                 v1, "WindShrine") or 0)))
                if cooldown == "" then
                    windUpd:UpdateText("Wind Shrine: Ready")
                else
                    windUpd:UpdateText("Wind Shrine: " .. cooldown)
                end
                for i, v in pairs(utilities) do
                    local cooldown, isUsable = getToyCooldown(i)
                    if cooldown ~= nil and isUsable ~= nil then
                        if isUsable then
                            v:UpdateText(i .. ": Ready")
                        else
                            v:UpdateText(i .. ": " .. require(game.ReplicatedStorage.TimeString)(cooldown))
                        end
                    end
                end
            end
        end
    end)
end)

--if bongkoc.toggles.killstickbug then killstickbug:SetState(true) end
--if bongkoc.toggles.farmboostedfield then farmboostedfield:SetState(true) end

if _G.autoload then
    if isfile("bongkoc/BSS_" .. _G.autoload .. ".json") then
        bongkoc = game:service("HttpService"):JSONDecode(readfile("bongkoc/BSS_" .. _G.autoload .. ".json"))
        for i,v in pairs(guiElements) do
            for j,k in pairs(v) do
                local obj = k:GetObject()
                local lastCharacters = obj.Name:reverse():sub(0, obj.Name:reverse():find(" ")):reverse()
                if bongkoc[i][j] then
                    if lastCharacters == " Dropdown" then
                        obj.Container.Value.Text = bongkoc[i][j]
                    elseif lastCharacters == " Slider" then
                        task.spawn(function()
                            local Tween = game:GetService("TweenService"):Create(
                                obj.Slider.Bar,
                                TweenInfo.new(1),
                                {Size = UDim2.new((tonumber(bongkoc[i][j]) - k:GetMin()) / (k:GetMax() - k:GetMin()), 0, 1, 0)}
                            )
                            Tween:Play()
                            local startStamp = tick()
                            local startValue = tonumber(obj.Value.PlaceholderText)
                            while tick() - startStamp < 1 do
                                task.wait()
                                local partial = tick() - startStamp
                                local value = (startValue + ((tonumber(bongkoc[i][j]) - startValue) * partial))
                                obj.Value.PlaceholderText = math.round(value * 100) / 100
                            end
                            obj.Value.PlaceholderText = tonumber(bongkoc[i][j])
                        end)
                    elseif lastCharacters == " Toggle" then
                        obj.Toggle.BackgroundColor3 = bongkoc[i][j] and Config.Color or Color3.fromRGB(50,50,50)
                    elseif lastCharacters == " TextBox" then
                        obj.Background.Input.Text = bongkoc[i][j]
                    end
                end
            end
        end
    else
        api.notify("Bongkoc " .. temptable.version, "No such config file!", 2)
    end

    local menuTabs = player.PlayerGui.ScreenGui.Menus.ChildTabs
    local set_thread_identity = syn and syn.set_thread_identity or setthreadcontext or setidentity

    if not set_thread_identity then
        api.notify("Bongkoc " .. temptable.version, "your exploit only partially supports autoload!", 2)
    else
        for _,v in pairs(menuTabs:GetChildren()) do
            if v:FindFirstChild("Icon") and v.Icon.Image == "rbxassetid://1436835355" then
                set_thread_identity(2)
                firesignal(v.MouseButton1Click)
                set_thread_identity(7)
            end
        end
    end
end

task.spawn(function()
    while task.wait(0.0035) do
        if bongkoc.toggles.usbtoggle then
            if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.TypeName.Text:match(bongkoc.vars.usb) then
                temptable.feed(bongkoc.beessettings.general.x, bongkoc.beessettings.general.y, "RoyalJelly")
            end
        end
        if bongkoc.toggles.ugb then
            if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.TypeName.Text:match("Gifted") then
                temptable.feed(bongkoc.beessettings.general.x, bongkoc.beessettings.general.y, bongkoc.vars.selectedTreat)
            end
        end
        if bongkoc.toggles.af then
            temptable.feed(bongkoc.beessettings.general.x, bongkoc.beessettings.general.y, bongkoc.vars.selectedTreat, bongkoc.beessettings.general.amount)
        end
        if bongkoc.toggles.umb then
            if not game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.MutationFrame.MutationLabel.Text:match(bongkoc.vars.mutation) then
                temptable.feed(bongkoc.beessettings.general.x, bongkoc.beessettings.general.y, "Bitterberry", bongkoc.beessettings.general.amount)
            end
        end
    end
end)

game:GetService("Players").LocalPlayer.PlayerGui.ScreenGui.BeePopUp.MutationFrame.MutationLabel.Text = ""

--game:GetService("Workspace").Gates["5 Bee Gate"].Frame:Destroy()
--game:GetService("Workspace").Gates["15 Bee Gate"].Frame:Destroy()
--game:GetService("Workspace").Gates["25 Bee Gate"].Frame:Destroy()

for _, part in next, workspace:FindFirstChild("FieldDecos"):GetDescendants() do
    if part:IsA("BasePart") then
        part.CanCollide = false
        part.Transparency = part.Transparency < 0.75 and 0.75 or part.Transparency
        task.wait()
    end
end
for _, part in next, workspace:FindFirstChild("Decorations"):GetDescendants() do
    if part:IsA("BasePart") and
        (part.Parent.Name == "Bush" or part.Parent.Name == "Dandelion" or part.Parent.Name == "DiscoverSign" or part.Parent.Name == "HatchSign" or part.Parent.Name == "TicketSign" or part.Parent.Name == "Pine Tree" or part.Parent.Name == "SpiderCave" or part.Parent.Name == "Dandelion1" or part.Parent.Name == "Big Dandelion" or part.Parent.Name == "Blue Flower") then
        part.CanCollide = false
        part.Transparency = part.Transparency < 0.75 and 0.75 or part.Transparency
        task.wait()
    end
end
for _, Gate in next, workspace.Gates:GetDescendants() do 
    if Gate:IsA("BasePart") and string.find(Gate.parent.Name, "Bee Gate") then 
        Gate.CanCollide = false 
        Gate.Transparency = Gate.Transparency < 0.5 and 0.5 or Gate.Transparency
        task.wait() 
    end 
end
--[[for _, part in next, workspace:FindFirstChild("Gates"):GetDescendants() do
    if part:IsA("BasePart") and
        (part.Parent.Name == "5 Bee Gate.Frame" or part.Parent.Name == "10 Bee Gate" or part.Parent.Name == "15 Bee Gate" or part.Parent.Name == "20 Bee Gate" or part.Parent.Name == "25 Bee Gate" or part.Parent.Name == "30 Bee Gate" or part.Parent.Name == "35 Bee Gate") then
        part.CanCollide = false
        part.Transparency = part.Transparency < 0.65 and 0.65 or part.Transparency
        task.wait()
    end
end]]
for _, part in next, workspace.Map.Fences:GetDescendants() do
    if part:IsA("BasePart") then
        part.CanCollide = false
        part.Transparency = part.Transparency < 0.7 and 0.7 or part.Transparency
        task.wait()
    end
end
for i, v in next, workspace:FindFirstChild("Invisible Walls"):GetDescendants() do
    if v.Parent.Name == "InviswallVerticle" or "InviswallHorizon" then
        v.CanCollide = false
    end
end
for i, v in next, workspace.Decorations.Misc:GetDescendants() do
    if v.Parent.Name == "Blue Flower 3"
    or v.Parent.Name == "Blue Flower 2"
    or v.Parent.Name == "Blue Flower 1"
    or v.Parent.Name == "Blue Flower 4"
    or v.Parent.Name == "Blue Flower 5" then
        v.CanCollide = false
        v.Transparency = 0.75
    end
end
for i, v in next, workspace.Decorations.JumpGames:GetDescendants() do
    if v.Parent.Name == "Mushroom" then
        v.CanCollide = false
        v.Transparency = 0.75
    end
end
for i, v in next, workspace.Decorations.JumpGames:GetDescendants() do
    if v.Parent.Name == "RockClimbBamboo" then
        v.CanCollide = false
        v.Transparency = 0.75
    end
end
for i, v in next, workspace.Decorations.Misc:GetDescendants() do
    if v.Parent.Name == "Mushroom" then
        v.CanCollide = false
        v.Transparency = 0.75
    end
end
warn("LOADED BONGKOC!!")
