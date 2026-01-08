local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local ConfigFolder = "Eternal_Configs"
if not isfolder(ConfigFolder) then makefolder(ConfigFolder) end

local Theme = {
    Background = Color3.fromRGB(20, 20, 28),
    Sidebar    = Color3.fromRGB(25, 25, 35),
    Element    = Color3.fromRGB(32, 32, 42),
    Text       = Color3.fromRGB(245, 245, 255),
    TextDim    = Color3.fromRGB(160, 160, 180),
    Accent1    = Color3.fromRGB(140, 20, 255), 
    Accent2    = Color3.fromRGB(255, 50, 180)
}

local ThemePresets = {
    ["Eternal (Default)"] = {
        Background = Color3.fromRGB(20, 20, 28), 
        Sidebar = Color3.fromRGB(25, 25, 35), 
        Element = Color3.fromRGB(32, 32, 42),
        Text = Color3.fromRGB(245, 245, 255), 
        TextDim = Color3.fromRGB(160, 160, 180),
        Accent1 = Color3.fromRGB(140, 20, 255), 
        Accent2 = Color3.fromRGB(255, 50, 180)
    },
    ["Ocean Breeze"] = {
        Background = Color3.fromRGB(10, 20, 30), 
        Sidebar = Color3.fromRGB(15, 25, 40), 
        Element = Color3.fromRGB(20, 35, 55),
        Text = Color3.fromRGB(240, 250, 255), 
        TextDim = Color3.fromRGB(140, 160, 180),
        Accent1 = Color3.fromRGB(0, 190, 255), 
        Accent2 = Color3.fromRGB(0, 100, 255)
    },
    ["Toxic Nature"] = {
        Background = Color3.fromRGB(20, 25, 20), 
        Sidebar = Color3.fromRGB(25, 35, 25), 
        Element = Color3.fromRGB(35, 45, 35),
        Text = Color3.fromRGB(240, 255, 240), 
        TextDim = Color3.fromRGB(150, 180, 150),
        Accent1 = Color3.fromRGB(100, 255, 50), 
        Accent2 = Color3.fromRGB(50, 180, 0)
    },
    ["Blood Moon"] = {
        Background = Color3.fromRGB(25, 10, 10), 
        Sidebar = Color3.fromRGB(35, 15, 15), 
        Element = Color3.fromRGB(45, 20, 20),
        Text = Color3.fromRGB(255, 240, 240), 
        TextDim = Color3.fromRGB(180, 140, 140),
        Accent1 = Color3.fromRGB(255, 50, 50), 
        Accent2 = Color3.fromRGB(180, 0, 0)
    },
    ["Midnight Sky"] = {
        Background = Color3.fromRGB(15, 15, 20), 
        Sidebar = Color3.fromRGB(25, 25, 30), 
        Element = Color3.fromRGB(35, 35, 45),
        Text = Color3.fromRGB(255, 255, 255), 
        TextDim = Color3.fromRGB(160, 160, 170),
        Accent1 = Color3.fromRGB(100, 100, 255), 
        Accent2 = Color3.fromRGB(180, 180, 255)
    },
    ["Cotton Candy"] = {
        Background = Color3.fromRGB(30, 20, 30), 
        Sidebar = Color3.fromRGB(40, 25, 40), 
        Element = Color3.fromRGB(50, 35, 50),
        Text = Color3.fromRGB(255, 245, 255), 
        TextDim = Color3.fromRGB(200, 160, 200),
        Accent1 = Color3.fromRGB(255, 100, 200), 
        Accent2 = Color3.fromRGB(100, 200, 255)
    },
    ["Sunset Dunes"] = {
        Background = Color3.fromRGB(30, 20, 15), 
        Sidebar = Color3.fromRGB(40, 25, 20), 
        Element = Color3.fromRGB(55, 35, 25),
        Text = Color3.fromRGB(255, 245, 235), 
        TextDim = Color3.fromRGB(200, 170, 150),
        Accent1 = Color3.fromRGB(255, 150, 50), 
        Accent2 = Color3.fromRGB(255, 100, 0)
    },
    ["Arctic Frost"] = {
        Background = Color3.fromRGB(20, 25, 30), 
        Sidebar = Color3.fromRGB(25, 35, 40), 
        Element = Color3.fromRGB(35, 45, 55),
        Text = Color3.fromRGB(240, 250, 255), 
        TextDim = Color3.fromRGB(180, 200, 220),
        Accent1 = Color3.fromRGB(100, 220, 255), 
        Accent2 = Color3.fromRGB(50, 150, 255)
    },
    ["Cyberpunk Neon"] = {
        Background = Color3.fromRGB(10, 5, 20), 
        Sidebar = Color3.fromRGB(15, 10, 30), 
        Element = Color3.fromRGB(25, 15, 40),
        Text = Color3.fromRGB(255, 255, 255), 
        TextDim = Color3.fromRGB(180, 180, 220),
        Accent1 = Color3.fromRGB(255, 0, 255), 
        Accent2 = Color3.fromRGB(0, 255, 255)
    },
    ["Forest Guardian"] = {
        Background = Color3.fromRGB(15, 25, 20), 
        Sidebar = Color3.fromRGB(20, 35, 25), 
        Element = Color3.fromRGB(30, 45, 35),
        Text = Color3.fromRGB(230, 255, 240), 
        TextDim = Color3.fromRGB(160, 200, 170),
        Accent1 = Color3.fromRGB(80, 220, 120), 
        Accent2 = Color3.fromRGB(40, 180, 100)
    },
    ["Royal Purple"] = {
        Background = Color3.fromRGB(25, 15, 35), 
        Sidebar = Color3.fromRGB(35, 20, 50), 
        Element = Color3.fromRGB(45, 30, 65),
        Text = Color3.fromRGB(255, 245, 255), 
        TextDim = Color3.fromRGB(200, 180, 220),
        Accent1 = Color3.fromRGB(180, 80, 255), 
        Accent2 = Color3.fromRGB(140, 40, 220)
    },
    ["Golden Hour"] = {
        Background = Color3.fromRGB(30, 25, 15), 
        Sidebar = Color3.fromRGB(40, 30, 20), 
        Element = Color3.fromRGB(55, 40, 25),
        Text = Color3.fromRGB(255, 250, 235), 
        TextDim = Color3.fromRGB(220, 200, 160),
        Accent1 = Color3.fromRGB(255, 200, 50), 
        Accent2 = Color3.fromRGB(220, 160, 30)
    },
    ["Abyssal Deep"] = {
        Background = Color3.fromRGB(5, 10, 20), 
        Sidebar = Color3.fromRGB(10, 15, 30), 
        Element = Color3.fromRGB(15, 25, 45),
        Text = Color3.fromRGB(230, 240, 255), 
        TextDim = Color3.fromRGB(150, 170, 200),
        Accent1 = Color3.fromRGB(0, 150, 200), 
        Accent2 = Color3.fromRGB(0, 100, 150)
    },
    ["Crimson Dawn"] = {
        Background = Color3.fromRGB(30, 10, 15), 
        Sidebar = Color3.fromRGB(40, 15, 20), 
        Element = Color3.fromRGB(55, 20, 25),
        Text = Color3.fromRGB(255, 235, 240), 
        TextDim = Color3.fromRGB(220, 160, 170),
        Accent1 = Color3.fromRGB(255, 60, 80), 
        Accent2 = Color3.fromRGB(200, 30, 50)
    },
    ["Matrix Green"] = {
        Background = Color3.fromRGB(5, 15, 10), 
        Sidebar = Color3.fromRGB(10, 25, 15), 
        Element = Color3.fromRGB(15, 35, 20),
        Text = Color3.fromRGB(220, 255, 220), 
        TextDim = Color3.fromRGB(150, 220, 150),
        Accent1 = Color3.fromRGB(0, 255, 100), 
        Accent2 = Color3.fromRGB(0, 180, 70)
    },
    ["Pastel Dream"] = {
        Background = Color3.fromRGB(240, 235, 245), 
        Sidebar = Color3.fromRGB(245, 240, 250), 
        Element = Color3.fromRGB(250, 245, 255),
        Text = Color3.fromRGB(40, 35, 50), 
        TextDim = Color3.fromRGB(120, 110, 140),
        Accent1 = Color3.fromRGB(255, 150, 200), 
        Accent2 = Color3.fromRGB(150, 200, 255)
    },
    ["Industrial Gray"] = {
        Background = Color3.fromRGB(35, 35, 40), 
        Sidebar = Color3.fromRGB(45, 45, 50), 
        Element = Color3.fromRGB(55, 55, 60),
        Text = Color3.fromRGB(240, 240, 245), 
        TextDim = Color3.fromRGB(180, 180, 190),
        Accent1 = Color3.fromRGB(255, 100, 50), 
        Accent2 = Color3.fromRGB(200, 150, 50)
    },
    ["Solar Flare"] = {
        Background = Color3.fromRGB(40, 25, 10), 
        Sidebar = Color3.fromRGB(50, 30, 15), 
        Element = Color3.fromRGB(65, 40, 20),
        Text = Color3.fromRGB(255, 250, 240), 
        TextDim = Color3.fromRGB(220, 200, 170),
        Accent1 = Color3.fromRGB(255, 180, 50), 
        Accent2 = Color3.fromRGB(255, 120, 30)
    },
    ["Twilight Zone"] = {
        Background = Color3.fromRGB(20, 15, 30), 
        Sidebar = Color3.fromRGB(30, 20, 40), 
        Element = Color3.fromRGB(40, 30, 55),
        Text = Color3.fromRGB(245, 240, 255), 
        TextDim = Color3.fromRGB(180, 170, 200),
        Accent1 = Color3.fromRGB(180, 100, 255), 
        Accent2 = Color3.fromRGB(100, 200, 255)
    },
    ["Mono Chrome"] = {
        Background = Color3.fromRGB(20, 20, 20), 
        Sidebar = Color3.fromRGB(30, 30, 30), 
        Element = Color3.fromRGB(40, 40, 40),
        Text = Color3.fromRGB(255, 255, 255), 
        TextDim = Color3.fromRGB(180, 180, 180),
        Accent1 = Color3.fromRGB(255, 255, 255), 
        Accent2 = Color3.fromRGB(200, 200, 200)
    },
}

local ThemeRegistry = {Objects = {}, Gradients = {}, Customs = {}}

local function RegisterTheme(obj, prop, key) 
    table.insert(ThemeRegistry.Objects, {Object=obj, Property=prop, Key=key}) 
    obj[prop] = Theme[key] 
    return obj 
end

local function RegisterGradient(gradient, key1, key2)
    table.insert(ThemeRegistry.Gradients, {Object=gradient, K1=key1, K2=key2})
    gradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Theme[key1]), ColorSequenceKeypoint.new(1, Theme[key2])}
    return gradient
end

local function UpdateTheme(themeName)
    local newTheme = ThemePresets[themeName] or ThemePresets["Eternal (Default)"]
    for k, v in pairs(newTheme) do Theme[k] = v end
    
    for i = #ThemeRegistry.Objects, 1, -1 do
        local data = ThemeRegistry.Objects[i]
        if data.Object and data.Object.Parent then
            pcall(function() TweenService:Create(data.Object, TweenInfo.new(0.5), {[data.Property]=Theme[data.Key]}):Play() end)
        else
            table.remove(ThemeRegistry.Objects, i)
        end
    end
    
    for i = #ThemeRegistry.Gradients, 1, -1 do
        local data = ThemeRegistry.Gradients[i]
        if data.Object and data.Object.Parent then
            pcall(function() data.Object.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Theme[data.K1]), ColorSequenceKeypoint.new(1, Theme[data.K2])} end)
        else
            table.remove(ThemeRegistry.Gradients, i)
        end
    end
end

local FontID = "rbxassetid://12187365364"
local FontMain = Font.new(FontID, Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local FontBold = Font.new(FontID, Enum.FontWeight.Bold, Enum.FontStyle.Normal)

local Icons = {

["a-arrow-down"] = "rbxassetid://92867583610071",
["a-arrow-up"] = "rbxassetid://132318504999733",
["a-large-small"] = "rbxassetid://111491496660216",
["accessibility"] = "rbxassetid://114029945302017",
["activity"] = "rbxassetid://94212016861936",
["air-vent"] = "rbxassetid://81517226012329",
["airplay"] = "rbxassetid://115020759309179",
["alarm-clock-check"] = "rbxassetid://76437352099157",
["alarm-clock-minus"] = "rbxassetid://77364179863205",
["alarm-clock-off"] = "rbxassetid://97904885874823",
["alarm-clock-plus"] = "rbxassetid://80468822979214",
["alarm-clock"] = "rbxassetid://126259032907535",
["alarm-smoke"] = "rbxassetid://96965448419685",
["album"] = "rbxassetid://127358331163602",
["align-center-horizontal"] = "rbxassetid://81570549209434",
["align-center-vertical"] = "rbxassetid://118470463752466",
["align-end-horizontal"] = "rbxassetid://139502909745427",
["align-end-vertical"] = "rbxassetid://96528869059554",
["align-horizontal-distribute-center"] = "rbxassetid://97220086126656",
["align-horizontal-distribute-end"] = "rbxassetid://106128590702022",
["align-horizontal-distribute-start"] = "rbxassetid://76074660002997",
["align-horizontal-justify-center"] = "rbxassetid://75732302772427",
["align-horizontal-justify-end"] = "rbxassetid://129167626402283",
["align-horizontal-justify-start"] = "rbxassetid://130161830325281",
["align-horizontal-space-around"] = "rbxassetid://91646106782950",
["align-horizontal-space-between"] = "rbxassetid://103886093046990",
["align-start-horizontal"] = "rbxassetid://125674804697729",
["align-start-vertical"] = "rbxassetid://105020230154823",
["align-vertical-distribute-center"] = "rbxassetid://93791183635525",
["align-vertical-distribute-end"] = "rbxassetid://139354223511433",
["align-vertical-distribute-start"] = "rbxassetid://74961997822126",
["align-vertical-justify-center"] = "rbxassetid://134754696166569",
["align-vertical-justify-end"] = "rbxassetid://92569381441969",
["align-vertical-justify-start"] = "rbxassetid://99692844572718",
["align-vertical-space-around"] = "rbxassetid://96206012459190",
["align-vertical-space-between"] = "rbxassetid://124998077349706",
["ambulance"] = "rbxassetid://78599995190651",
["ampersand"] = "rbxassetid://75272915739209",
["ampersands"] = "rbxassetid://126947193455996",
["amphora"] = "rbxassetid://137370389604364",
["anchor"] = "rbxassetid://92181172123618",
["angry"] = "rbxassetid://74237056000103",
["annoyed"] = "rbxassetid://80064369052011",
["antenna"] = "rbxassetid://99628923540956",
["anvil"] = "rbxassetid://100203029845919",
["aperture"] = "rbxassetid://83396154449972",
["app-window-mac"] = "rbxassetid://79587216113811",
["app-window"] = "rbxassetid://93142176757189",
["apple"] = "rbxassetid://104349242902442",
["archive-restore"] = "rbxassetid://78956681942188",
["archive-x"] = "rbxassetid://75830115088395",
["archive"] = "rbxassetid://122180020814574",
["armchair"] = "rbxassetid://105384358373973",
["arrow-big-down-dash"] = "rbxassetid://137987229582002",
["arrow-big-down"] = "rbxassetid://81081164158885",
["arrow-big-left-dash"] = "rbxassetid://97827621354677",
["arrow-big-left"] = "rbxassetid://85973092492641",
["arrow-big-right-dash"] = "rbxassetid://117825834972403",
["arrow-big-right"] = "rbxassetid://82960676755590",
["arrow-big-up-dash"] = "rbxassetid://99260194327483",
["arrow-big-up"] = "rbxassetid://93136954756149",
["arrow-down-0-1"] = "rbxassetid://120961896217875",
["arrow-down-1-0"] = "rbxassetid://93474255891850",
["arrow-down-a-z"] = "rbxassetid://99554596207900",
["arrow-down-from-line"] = "rbxassetid://132045845807798",
["arrow-down-left"] = "rbxassetid://102899325237364",
["arrow-down-narrow-wide"] = "rbxassetid://129105261655061",
["arrow-down-right"] = "rbxassetid://123109928624974",
["arrow-down-to-dot"] = "rbxassetid://101675355931221",
["arrow-down-to-line"] = "rbxassetid://87050478931254",
["arrow-down-up"] = "rbxassetid://85780258549577",
["arrow-down-wide-narrow"] = "rbxassetid://88461733425991",
["arrow-down-z-a"] = "rbxassetid://76115279362232",
["arrow-down"] = "rbxassetid://98764963621439",
["arrow-left-from-line"] = "rbxassetid://87857914437603",
["arrow-left-right"] = "rbxassetid://131324733048447",
["arrow-left-to-line"] = "rbxassetid://118645136026970",
["arrow-left"] = "rbxassetid://102531941843733",
["arrow-right-from-line"] = "rbxassetid://74073639809355",
["arrow-right-left"] = "rbxassetid://77015754304300",
["arrow-right-to-line"] = "rbxassetid://78632510329852",
["arrow-right"] = "rbxassetid://113692007244654",
["arrow-up-0-1"] = "rbxassetid://105257823943016",
["arrow-up-1-0"] = "rbxassetid://134175521693798",
["arrow-up-a-z"] = "rbxassetid://77763416595160",
["arrow-up-down"] = "rbxassetid://81019887641527",
["arrow-up-from-dot"] = "rbxassetid://124408496673275",
["arrow-up-from-line"] = "rbxassetid://95777664626453",
["arrow-up-left"] = "rbxassetid://123490598231261",
["arrow-up-narrow-wide"] = "rbxassetid://73006024672636",
["arrow-up-right"] = "rbxassetid://129280608535523",
["arrow-up-to-line"] = "rbxassetid://108818207813537",
["arrow-up-wide-narrow"] = "rbxassetid://87437426951568",
["arrow-up-z-a"] = "rbxassetid://107546173611884",
["arrow-up"] = "rbxassetid://89282378235317",
["arrows-up-from-line"] = "rbxassetid://133710016938621",
["asterisk"] = "rbxassetid://88552752106723",
["at-sign"] = "rbxassetid://79059152889146",
["atom"] = "rbxassetid://73167696981648",
["audio-lines"] = "rbxassetid://70930641819242",
["audio-waveform"] = "rbxassetid://86462036665209",
["award"] = "rbxassetid://132740088158419",
["axe"] = "rbxassetid://132405197863294",
["axis-3d"] = "rbxassetid://122438676546804",
["baby"] = "rbxassetid://93472926933440",
["backpack"] = "rbxassetid://140420225386018",
["badge-alert"] = "rbxassetid://101829200081951",
["badge-cent"] = "rbxassetid://133345018873154",
["badge-check"] = "rbxassetid://76078495178149",
["badge-dollar-sign"] = "rbxassetid://127139803581141",
["badge-euro"] = "rbxassetid://120016477674659",
["badge-indian-rupee"] = "rbxassetid://75659682309981",
["badge-info"] = "rbxassetid://131995373201472",
["badge-japanese-yen"] = "rbxassetid://99081574588615",
["badge-minus"] = "rbxassetid://140321561183881",
["badge-percent"] = "rbxassetid://121359224294885",
["badge-plus"] = "rbxassetid://100325578561866",
["badge-pound-sterling"] = "rbxassetid://119688217279444",
["badge-question-mark"] = "rbxassetid://121464963737502",
["badge-russian-ruble"] = "rbxassetid://108839463659864",
["badge-swiss-franc"] = "rbxassetid://91447608372740",
["badge-turkish-lira"] = "rbxassetid://137839965873529",
["badge-x"] = "rbxassetid://122931434733842",
["badge"] = "rbxassetid://116620312917084",
["baggage-claim"] = "rbxassetid://86922213051957",
["ban"] = "rbxassetid://90767043015246",
["banana"] = "rbxassetid://140713420056179",
["bandage"] = "rbxassetid://129660129590770",
["banknote-arrow-down"] = "rbxassetid://139366449345199",
["banknote-arrow-up"] = "rbxassetid://133758343082529",
["banknote-x"] = "rbxassetid://95348701438065",
["banknote"] = "rbxassetid://104840231536668",
["barcode"] = "rbxassetid://118473018143689",
["barrel"] = "rbxassetid://130647115622774",
["baseline"] = "rbxassetid://124677132511270",
["bath"] = "rbxassetid://76031400297942",
["battery-charging"] = "rbxassetid://80139357470047",
["battery-full"] = "rbxassetid://70906718268972",
["battery-low"] = "rbxassetid://139659256984314",
["battery-medium"] = "rbxassetid://105934079398915",
["battery-plus"] = "rbxassetid://91931341486966",
["battery-warning"] = "rbxassetid://115230083817257",
["battery"] = "rbxassetid://70765800346189",
["beaker"] = "rbxassetid://80902539995520",
["bean-off"] = "rbxassetid://98164436608714",
["bean"] = "rbxassetid://89491967076869",
["bed-double"] = "rbxassetid://73820193212911",
["bed-single"] = "rbxassetid://113423940880634",
["bed"] = "rbxassetid://97726529032925",
["beef"] = "rbxassetid://105850162318915",
["beer-off"] = "rbxassetid://120333134736361",
["beer"] = "rbxassetid://116404978807744",
["bell-dot"] = "rbxassetid://93161277118810",
["bell-electric"] = "rbxassetid://100277767266983",
["bell-minus"] = "rbxassetid://126334890449727",
["bell-off"] = "rbxassetid://78560046118930",
["bell-plus"] = "rbxassetid://77014333795836",
["bell-ring"] = "rbxassetid://94612128913941",
["bell"] = "rbxassetid://97392696311902",
["between-horizontal-end"] = "rbxassetid://81602774794322",
["between-horizontal-start"] = "rbxassetid://76112384929846",
["between-vertical-end"] = "rbxassetid://72817612571631",
["between-vertical-start"] = "rbxassetid://85278312190301",
["biceps-flexed"] = "rbxassetid://82004462003936",
["bike"] = "rbxassetid://102930322246035",
["binary"] = "rbxassetid://91751953950088",
["binoculars"] = "rbxassetid://101460003267896",
["biohazard"] = "rbxassetid://95956532900432",
["bird"] = "rbxassetid://132284145117371",
["birdhouse"] = "rbxassetid://83999157401433",
["bitcoin"] = "rbxassetid://95459240442938",
["blend"] = "rbxassetid://111679612185257",
["blinds"] = "rbxassetid://71164165283925",
["blocks"] = "rbxassetid://72212693357737",
["bluetooth-connected"] = "rbxassetid://96315134002985",
["bluetooth-off"] = "rbxassetid://80600044218117",
["bluetooth-searching"] = "rbxassetid://100673019606426",
["bluetooth"] = "rbxassetid://90506573139443",
["bold"] = "rbxassetid://116141470019166",
["bolt"] = "rbxassetid://102881251417484",
["bomb"] = "rbxassetid://139223800924636",
["bone"] = "rbxassetid://111242153474115",
["book-a"] = "rbxassetid://104067275658465",
["book-alert"] = "rbxassetid://124159928044853",
["book-audio"] = "rbxassetid://109208148317037",
["book-check"] = "rbxassetid://115999656081696",
["book-copy"] = "rbxassetid://108543407492005",
["book-dashed"] = "rbxassetid://127430784795958",
["book-down"] = "rbxassetid://101011730128222",
["book-headphones"] = "rbxassetid://108670200799574",
["book-heart"] = "rbxassetid://112788845135284",
["book-image"] = "rbxassetid://80808285757226",
["book-key"] = "rbxassetid://116024426170705",
["book-lock"] = "rbxassetid://118765061220571",
["book-marked"] = "rbxassetid://73211024251780",
["book-minus"] = "rbxassetid://112724962046282",
["book-open-check"] = "rbxassetid://130848362492667",
["book-open-text"] = "rbxassetid://100629528672195",
["book-open"] = "rbxassetid://129845326810392",
["book-plus"] = "rbxassetid://140267785051233",
["book-text"] = "rbxassetid://94011772484232",
["book-type"] = "rbxassetid://97817304725443",
["book-up-2"] = "rbxassetid://130161620853665",
["book-up"] = "rbxassetid://98640174079190",
["book-user"] = "rbxassetid://128489189240523",
["book-x"] = "rbxassetid://118754548186537",
["book"] = "rbxassetid://125383279695672",
["bookmark-check"] = "rbxassetid://93940443347986",
["bookmark-minus"] = "rbxassetid://96807096039910",
["bookmark-plus"] = "rbxassetid://121469724491615",
["bookmark-x"] = "rbxassetid://112272342584706",
["bookmark"] = "rbxassetid://121093149326239",
["boom-box"] = "rbxassetid://99901322535868",
["bot-message-square"] = "rbxassetid://96145330292478",
["bot-off"] = "rbxassetid://140417690560013",
["bot"] = "rbxassetid://80451686744860",
["bottle-wine"] = "rbxassetid://131675403196921",
["bow-arrow"] = "rbxassetid://124089655150375",
["box"] = "rbxassetid://101768155599700",
["boxes"] = "rbxassetid://136372617578355",
["braces"] = "rbxassetid://117761094704041",
["brackets"] = "rbxassetid://74368995728099",
["brain-circuit"] = "rbxassetid://70547962410202",
["brain-cog"] = "rbxassetid://132039205501538",
["brain"] = "rbxassetid://92424107303177",
["brick-wall-fire"] = "rbxassetid://92980588705520",
["brick-wall-shield"] = "rbxassetid://75954432775071",
["brick-wall"] = "rbxassetid://112878522258821",
["briefcase-business"] = "rbxassetid://129135125207283",
["briefcase-conveyor-belt"] = "rbxassetid://108665725653714",
["briefcase-medical"] = "rbxassetid://119917756334087",
["briefcase"] = "rbxassetid://96754188164225",
["bring-to-front"] = "rbxassetid://132975903553748",
["brush-cleaning"] = "rbxassetid://71728977448805",
["brush"] = "rbxassetid://127035535799640",
["bubbles"] = "rbxassetid://106183424168227",
["bug-off"] = "rbxassetid://88020025049245",
["bug-play"] = "rbxassetid://80107955888092",
["bug"] = "rbxassetid://83626408925438",
["building-2"] = "rbxassetid://77873775611951",
["building"] = "rbxassetid://110616258983082",
["bus-front"] = "rbxassetid://89863432456045",
["bus"] = "rbxassetid://133798469717463",
["cable-car"] = "rbxassetid://128643682205596",
["cable"] = "rbxassetid://128449944504901",
["cake-slice"] = "rbxassetid://136769828413242",
["cake"] = "rbxassetid://103131590503275",
["calculator"] = "rbxassetid://74915716529646",
["calendar-1"] = "rbxassetid://98458364171044",
["calendar-arrow-down"] = "rbxassetid://108415736543437",
["calendar-arrow-up"] = "rbxassetid://70574654109118",
["calendar-check-2"] = "rbxassetid://120231170248276",
["calendar-check"] = "rbxassetid://71551019465748",
["calendar-clock"] = "rbxassetid://119132152594595",
["calendar-cog"] = "rbxassetid://122402172360287",
["calendar-days"] = "rbxassetid://99072017568595",
["calendar-fold"] = "rbxassetid://117368871270394",
["calendar-heart"] = "rbxassetid://88839008103676",
["calendar-minus-2"] = "rbxassetid://98846170279891",
["calendar-minus"] = "rbxassetid://137354318924383",
["calendar-off"] = "rbxassetid://109726151749217",
["calendar-plus-2"] = "rbxassetid://112264562093883",
["calendar-plus"] = "rbxassetid://125266115249843",
["calendar-range"] = "rbxassetid://103641849247576",
["calendar-search"] = "rbxassetid://92010083223634",
["calendar-sync"] = "rbxassetid://78082218499697",
["calendar-x-2"] = "rbxassetid://107518051061147",
["calendar-x"] = "rbxassetid://106703374806500",
["calendar"] = "rbxassetid://114792700814035",
["camera-off"] = "rbxassetid://81057636835256",
["camera"] = "rbxassetid://79950339943067",
["candy-cane"] = "rbxassetid://71689468772492",
["candy-off"] = "rbxassetid://110232752314832",
["candy"] = "rbxassetid://107812129154678",
["cannabis"] = "rbxassetid://98792006538601",
["captions-off"] = "rbxassetid://105223545364193",
["captions"] = "rbxassetid://104960225031445",
["car-front"] = "rbxassetid://87380942739063",
["car-taxi-front"] = "rbxassetid://122455403384057",
["car"] = "rbxassetid://121065933462582",
["caravan"] = "rbxassetid://120070979471783",
["card-sim"] = "rbxassetid://134490550095771",
["carrot"] = "rbxassetid://119118221444304",
["case-lower"] = "rbxassetid://129303130603241",
["case-sensitive"] = "rbxassetid://125410273293056",
["case-upper"] = "rbxassetid://111633433531325",
["cassette-tape"] = "rbxassetid://137065788934157",
["cast"] = "rbxassetid://98202245922071",
["castle"] = "rbxassetid://119275077187784",
["cat"] = "rbxassetid://124252153404931",
["cctv"] = "rbxassetid://99979894766624",
["chart-area"] = "rbxassetid://123446436762366",
["chart-bar-big"] = "rbxassetid://72336824986044",
["chart-bar-decreasing"] = "rbxassetid://107217459044963",
["chart-bar-increasing"] = "rbxassetid://88268905998571",
["chart-bar-stacked"] = "rbxassetid://98478751113024",
["chart-bar"] = "rbxassetid://105389816384108",
["chart-candlestick"] = "rbxassetid://125676898615697",
["chart-column-big"] = "rbxassetid://98598733210787",
["chart-column-decreasing"] = "rbxassetid://73586137373563",
["chart-column-increasing"] = "rbxassetid://120421615068601",
["chart-column-stacked"] = "rbxassetid://86031449675105",
["chart-column"] = "rbxassetid://97915995538580",
["chart-gantt"] = "rbxassetid://88811660555940",
["chart-line"] = "rbxassetid://101833156055618",
["chart-network"] = "rbxassetid://104027882693561",
["chart-no-axes-column-decreasing"] = "rbxassetid://123371717192542",
["chart-no-axes-column-increasing"] = "rbxassetid://140383830943049",
["chart-no-axes-column"] = "rbxassetid://94078751170351",
["chart-no-axes-combined"] = "rbxassetid://121424233161912",
["chart-no-axes-gantt"] = "rbxassetid://131936541106368",
["chart-pie"] = "rbxassetid://113412261630136",
["chart-scatter"] = "rbxassetid://108217585014571",
["chart-spline"] = "rbxassetid://90307460742494",
["check-check"] = "rbxassetid://95183312173858",
["check-line"] = "rbxassetid://115122343485290",
["check"] = "rbxassetid://93898873302694",
["chef-hat"] = "rbxassetid://121744015002573",
["cherry"] = "rbxassetid://139519182403183",
["chess-bishop"] = "rbxassetid://121701705580238",
["chess-king"] = "rbxassetid://90885687223462",
["chess-knight"] = "rbxassetid://96467707042169",
["chess-pawn"] = "rbxassetid://111318574652751",
["chess-queen"] = "rbxassetid://98304702099749",
["chess-rook"] = "rbxassetid://76223925830262",
["chevron-down"] = "rbxassetid://134243273101015",
["chevron-first"] = "rbxassetid://105243363790238",
["chevron-last"] = "rbxassetid://89268452603731",
["chevron-left"] = "rbxassetid://73780377692148",
["chevron-right"] = "rbxassetid://92473583511724",
["chevron-up"] = "rbxassetid://122444883127455",
["chevrons-down-up"] = "rbxassetid://139404716013205",
["chevrons-down"] = "rbxassetid://100524612205956",
["chevrons-left-right-ellipsis"] = "rbxassetid://125035817741526",
["chevrons-left-right"] = "rbxassetid://87910685945204",
["chevrons-left"] = "rbxassetid://82617201744347",
["chevrons-right-left"] = "rbxassetid://87149546686569",
["chevrons-right"] = "rbxassetid://139121276490483",
["chevrons-up-down"] = "rbxassetid://131833120209646",
["chevrons-up"] = "rbxassetid://100463452364672",
["chromium"] = "rbxassetid://128165143739006",
["church"] = "rbxassetid://113714744350666",
["cigarette-off"] = "rbxassetid://77797883078452",
["circle-alert"] = "rbxassetid://83898160590116",
["circle-arrow-down"] = "rbxassetid://95901860261344",
["circle-arrow-left"] = "rbxassetid://102148876968988",
["circle-arrow-out-down-left"] = "rbxassetid://140598097856694",
["circle-arrow-out-down-right"] = "rbxassetid://119952801379305",
["circle-arrow-out-up-left"] = "rbxassetid://132858212688303",
["circle-arrow-out-up-right"] = "rbxassetid://81783743753173",
["circle-arrow-right"] = "rbxassetid://70786767999559",
["circle-arrow-up"] = "rbxassetid://84395128546494",
["circle-check-big"] = "rbxassetid://93202927221730",
["circle-check"] = "rbxassetid://85262178816537",
["circle-chevron-down"] = "rbxassetid://137069490345718",
["circle-chevron-left"] = "rbxassetid://130250009740827",
["circle-chevron-right"] = "rbxassetid://125943696958495",
["circle-chevron-up"] = "rbxassetid://111223574026321",
["circle-dashed"] = "rbxassetid://126799443883746",
["circle-divide"] = "rbxassetid://106398997754208",
["circle-dollar-sign"] = "rbxassetid://91106238890387",
["circle-dot-dashed"] = "rbxassetid://111451232827180",
["circle-dot"] = "rbxassetid://82947033619201",
["circle-ellipsis"] = "rbxassetid://91687150884779",
["circle-equal"] = "rbxassetid://95133963751438",
["circle-fading-arrow-up"] = "rbxassetid://104648212910336",
["circle-fading-plus"] = "rbxassetid://91847890443490",
["circle-gauge"] = "rbxassetid://108157549473765",
["circle-minus"] = "rbxassetid://133556159576809",
["circle-off"] = "rbxassetid://97923456918886",
["circle-parking-off"] = "rbxassetid://128369410981252",
["circle-parking"] = "rbxassetid://124034962915196",
["circle-pause"] = "rbxassetid://139337739700879",
["circle-percent"] = "rbxassetid://133311912860256",
["circle-play"] = "rbxassetid://120408917249739",
["circle-plus"] = "rbxassetid://113157136350384",
["circle-pound-sterling"] = "rbxassetid://105476153083828",
["circle-power"] = "rbxassetid://140676030155098",
["circle-question-mark"] = "rbxassetid://97516698664325",
["circle-slash-2"] = "rbxassetid://136766902186549",
["circle-slash"] = "rbxassetid://125206439913049",
["circle-small"] = "rbxassetid://73685402843600",
["circle-star"] = "rbxassetid://120318414957104",
["circle-stop"] = "rbxassetid://87400503942659",
["circle-user-round"] = "rbxassetid://95489465399880",
["circle-user"] = "rbxassetid://136220511671311",
["circle-x"] = "rbxassetid://76821953846248",
["circle"] = "rbxassetid://130359823580534",
["circuit-board"] = "rbxassetid://107695264369312",
["citrus"] = "rbxassetid://139018222976433",
["clapperboard"] = "rbxassetid://132660667070200",
["clipboard-check"] = "rbxassetid://92649798577170",
["clipboard-clock"] = "rbxassetid://123957515687745",
["clipboard-copy"] = "rbxassetid://125851897718493",
["clipboard-list"] = "rbxassetid://96460215958908",
["clipboard-minus"] = "rbxassetid://107968008485671",
["clipboard-paste"] = "rbxassetid://74382068849983",
["clipboard-pen-line"] = "rbxassetid://77711589791615",
["clipboard-pen"] = "rbxassetid://75290966822953",
["clipboard-plus"] = "rbxassetid://134285318675662",
["clipboard-type"] = "rbxassetid://89949374318028",
["clipboard-x"] = "rbxassetid://102222456890103",
["clipboard"] = "rbxassetid://89601995828423",
["clock-1"] = "rbxassetid://129363225422045",
["clock-10"] = "rbxassetid://104332695855541",
["clock-11"] = "rbxassetid://119023205186105",
["clock-12"] = "rbxassetid://117789618723068",
["clock-2"] = "rbxassetid://134710777209413",
["clock-3"] = "rbxassetid://136385631189327",
["clock-4"] = "rbxassetid://121808839832144",
["clock-5"] = "rbxassetid://85082019959457",
["clock-6"] = "rbxassetid://71009733505593",
["clock-7"] = "rbxassetid://103111188546225",
["clock-8"] = "rbxassetid://110059272125337",
["clock-9"] = "rbxassetid://77610027126437",
["clock-alert"] = "rbxassetid://97157344465162",
["clock-arrow-down"] = "rbxassetid://92349314416042",
["clock-arrow-up"] = "rbxassetid://111484286332629",
["clock-check"] = "rbxassetid://85231630218857",
["clock-fading"] = "rbxassetid://93205297285245",
["clock-plus"] = "rbxassetid://93367709263150",
["clock"] = "rbxassetid://121808839832144",
["closed-caption"] = "rbxassetid://99832644030788",
["cloud-alert"] = "rbxassetid://91967273658626",
["cloud-check"] = "rbxassetid://97318598202432",
["cloud-cog"] = "rbxassetid://96497764065749",
["cloud-download"] = "rbxassetid://121435581993566",
["cloud-drizzle"] = "rbxassetid://139525315752605",
["cloud-fog"] = "rbxassetid://76650233148776",
["cloud-hail"] = "rbxassetid://72320462748242",
["cloud-lightning"] = "rbxassetid://133517088924849",
["cloud-moon-rain"] = "rbxassetid://127667837827018",
["cloud-moon"] = "rbxassetid://71938114737914",
["cloud-off"] = "rbxassetid://131907154501444",
["cloud-rain-wind"] = "rbxassetid://107414583736721",
["cloud-rain"] = "rbxassetid://105547081967408",
["cloud-snow"] = "rbxassetid://72307126270226",
["cloud-sun-rain"] = "rbxassetid://99041604425705",
["cloud-sun"] = "rbxassetid://86114208148727",
["cloud-upload"] = "rbxassetid://93307473217005",
["cloud"] = "rbxassetid://121226497050352",
["cloudy"] = "rbxassetid://105360479023346",
["clover"] = "rbxassetid://74925550436750",
["club"] = "rbxassetid://108490365816628",
["code-xml"] = "rbxassetid://130150477351734",
["code"] = "rbxassetid://107380207681249",
["codepen"] = "rbxassetid://135643965971885",
["codesandbox"] = "rbxassetid://106911852964823",
["coffee"] = "rbxassetid://106864403231093",
["cog"] = "rbxassetid://116544501716299",
["coins"] = "rbxassetid://116510979641930",
["columns-2"] = "rbxassetid://113004100221850",
["columns-3-cog"] = "rbxassetid://121589691981064",
["columns-3"] = "rbxassetid://115223357399375",
["columns-4"] = "rbxassetid://130807991968419",
["combine"] = "rbxassetid://79908476334048",
["command"] = "rbxassetid://93648221906330",
["compass"] = "rbxassetid://115123411028382",
["component"] = "rbxassetid://110027788875080",
["computer"] = "rbxassetid://77480056459407",
["concierge-bell"] = "rbxassetid://140384259310436",
["cone"] = "rbxassetid://97759550688437",
["construction"] = "rbxassetid://106539489968173",
["contact-round"] = "rbxassetid://71907624112229",
["contact"] = "rbxassetid://75868297719012",
["container"] = "rbxassetid://91507237573499",
["contrast"] = "rbxassetid://112796643981497",
["cookie"] = "rbxassetid://73159504540002",
["cooking-pot"] = "rbxassetid://94959783129799",
["copy-check"] = "rbxassetid://91177247988892",
["copy-minus"] = "rbxassetid://109524509933035",
["copy-plus"] = "rbxassetid://113618379616952",
["copy-slash"] = "rbxassetid://93805787810390",
["copy-x"] = "rbxassetid://106557557978061",
["copy"] = "rbxassetid://78979572434545",
["copyleft"] = "rbxassetid://78559055698593",
["copyright"] = "rbxassetid://129433635747111",
["corner-down-left"] = "rbxassetid://90473561177832",
["corner-down-right"] = "rbxassetid://86512767702085",
["corner-left-down"] = "rbxassetid://139876989150630",
["corner-left-up"] = "rbxassetid://126228268096099",
["corner-right-down"] = "rbxassetid://89237035551302",
["corner-right-up"] = "rbxassetid://112851237026705",
["corner-up-left"] = "rbxassetid://84669279763024",
["corner-up-right"] = "rbxassetid://115099889693145",
["cpu"] = "rbxassetid://77549309870247",
["creative-commons"] = "rbxassetid://90408210735312",
["credit-card"] = "rbxassetid://99163352872346",
["croissant"] = "rbxassetid://130710485559420",
["crop"] = "rbxassetid://116344601101413",
["cross"] = "rbxassetid://101833377863588",
["crosshair"] = "rbxassetid://134242818164054",
["crown"] = "rbxassetid://127843403295538",
["cuboid"] = "rbxassetid://75618807946111",
["cup-soda"] = "rbxassetid://121098640829562",
["currency"] = "rbxassetid://90551250119972",
["cylinder"] = "rbxassetid://90569677179169",
["dam"] = "rbxassetid://76874486231393",
["database-backup"] = "rbxassetid://103403210984699",
["database-zap"] = "rbxassetid://131199921258418",
["database"] = "rbxassetid://126791525623846",
["decimals-arrow-left"] = "rbxassetid://120198500638749",
["decimals-arrow-right"] = "rbxassetid://118263047146797",
["delete"] = "rbxassetid://126279426372342",
["dessert"] = "rbxassetid://71508133278830",
["diameter"] = "rbxassetid://97429051503783",
["diamond-minus"] = "rbxassetid://128989071438290",
["diamond-percent"] = "rbxassetid://107717860105959",
["diamond-plus"] = "rbxassetid://134701163723675",
["diamond"] = "rbxassetid://105846996304890",
["dice-1"] = "rbxassetid://112650149591038",
["dice-2"] = "rbxassetid://112278274566793",
["dice-3"] = "rbxassetid://118526270626312",
["dice-4"] = "rbxassetid://113365650364004",
["dice-5"] = "rbxassetid://72768312430593",
["dice-6"] = "rbxassetid://85376239182543",
["dices"] = "rbxassetid://81268120302865",
["diff"] = "rbxassetid://135052708609715",
["disc-2"] = "rbxassetid://91419420404185",
["disc-3"] = "rbxassetid://135470554736048",
["disc-album"] = "rbxassetid://74693460404344",
["disc"] = "rbxassetid://101908120120777",
["divide"] = "rbxassetid://136678191878278",
["dna-off"] = "rbxassetid://89612426361540",
["dna"] = "rbxassetid://74007982981741",
["dock"] = "rbxassetid://121997427160252",
["dog"] = "rbxassetid://71920105558570",
["dollar-sign"] = "rbxassetid://127320961224019",
["donut"] = "rbxassetid://72204922742657",
["door-closed-locked"] = "rbxassetid://74027613267551",
["door-closed"] = "rbxassetid://136249099949073",
["door-open"] = "rbxassetid://91306356501736",
["dot"] = "rbxassetid://137321056643916",
["download"] = "rbxassetid://134814648082393",
["drafting-compass"] = "rbxassetid://99701976182841",
["drama"] = "rbxassetid://110297795801577",
["dribbble"] = "rbxassetid://80231809663849",
["drill"] = "rbxassetid://108644821412796",
["drone"] = "rbxassetid://117299095794783",
["droplet-off"] = "rbxassetid://119365002225172",
["droplet"] = "rbxassetid://100597455015098",
["droplets"] = "rbxassetid://140111846025180",
["drum"] = "rbxassetid://136979060344890",
["drumstick"] = "rbxassetid://104662462521709",
["dumbbell"] = "rbxassetid://80277236776212",
["ear-off"] = "rbxassetid://87421916192807",
["ear"] = "rbxassetid://121894949934209",
["earth-lock"] = "rbxassetid://88814147073745",
["earth"] = "rbxassetid://76231597751076",
["eclipse"] = "rbxassetid://114829622118222",
["egg-fried"] = "rbxassetid://90622538210545",
["egg-off"] = "rbxassetid://92288321309285",
["egg"] = "rbxassetid://117851493400222",
["ellipsis-vertical"] = "rbxassetid://117978708573781",
["ellipsis"] = "rbxassetid://140019550645825",
["equal-approximately"] = "rbxassetid://105382689698323",
["equal-not"] = "rbxassetid://76864449458032",
["equal"] = "rbxassetid://123467780715624",
["eraser"] = "rbxassetid://133957773112410",
["ethernet-port"] = "rbxassetid://75391715149314",
["euro"] = "rbxassetid://72229646524456",
["ev-charger"] = "rbxassetid://97906158859623",
["expand"] = "rbxassetid://137492887754537",
["external-link"] = "rbxassetid://129331830773832",
["eye-closed"] = "rbxassetid://111063268625789",
["eye-off"] = "rbxassetid://135928786788378",
["eye"] = "rbxassetid://100033680381365",
["facebook"] = "rbxassetid://72098528632192",
["factory"] = "rbxassetid://102170024318039",
["fan"] = "rbxassetid://78391400440696",
["fast-forward"] = "rbxassetid://121615540167909",
["feather"] = "rbxassetid://91872927606406",
["fence"] = "rbxassetid://123451565578029",
["ferris-wheel"] = "rbxassetid://79729205796176",
["figma"] = "rbxassetid://134182122852301",
["file-archive"] = "rbxassetid://77018106869967",
["file-axis-3d"] = "rbxassetid://133912328009885",
["file-badge"] = "rbxassetid://74564895394477",
["file-box"] = "rbxassetid://119264004071690",
["file-braces-corner"] = "rbxassetid://77253337986109",
["file-braces"] = "rbxassetid://95314128621234",
["file-chart-column-increasing"] = "rbxassetid://134449481172067",
["file-chart-column"] = "rbxassetid://82048481252560",
["file-chart-line"] = "rbxassetid://71954360551345",
["file-chart-pie"] = "rbxassetid://81072193564497",
["file-check-corner"] = "rbxassetid://76295552859171",
["file-check"] = "rbxassetid://82604001452455",
["file-clock"] = "rbxassetid://102325208830990",
["file-code-corner"] = "rbxassetid://78293841184371",
["file-code"] = "rbxassetid://130978036895504",
["file-cog"] = "rbxassetid://101385347151368",
["file-diff"] = "rbxassetid://96147216772241",
["file-digit"] = "rbxassetid://89220220354580",
["file-down"] = "rbxassetid://120650154178290",
["file-exclamation-point"] = "rbxassetid://102821865889635",
["file-headphone"] = "rbxassetid://100533735901986",
["file-heart"] = "rbxassetid://132214916401696",
["file-image"] = "rbxassetid://123334057511782",
["file-input"] = "rbxassetid://124728604166044",
["file-key"] = "rbxassetid://118790255921100",
["file-lock"] = "rbxassetid://72170228691242",
["file-minus-corner"] = "rbxassetid://119263271735124",
["file-minus"] = "rbxassetid://111014798459222",
["file-music"] = "rbxassetid://134948051536671",
["file-output"] = "rbxassetid://92146832572911",
["file-pen-line"] = "rbxassetid://104622936345006",
["file-pen"] = "rbxassetid://79556179730240",
["file-play"] = "rbxassetid://89006821567838",
["file-plus-corner"] = "rbxassetid://76544604043974",
["file-plus"] = "rbxassetid://78881710800060",
["file-question-mark"] = "rbxassetid://127617422859576",
["file-scan"] = "rbxassetid://129480105228213",
["file-search-corner"] = "rbxassetid://90974165234008",
["file-search"] = "rbxassetid://97780235974933",
["file-signal"] = "rbxassetid://122070252538165",
["file-sliders"] = "rbxassetid://85787771732439",
["file-spreadsheet"] = "rbxassetid://134501869359270",
["file-stack"] = "rbxassetid://138929929862605",
["file-symlink"] = "rbxassetid://91865722036510",
["file-terminal"] = "rbxassetid://116757454755476",
["file-text"] = "rbxassetid://90496405707281",
["file-type-corner"] = "rbxassetid://124902230275209",
["file-type"] = "rbxassetid://115272552799361",
["file-up"] = "rbxassetid://131173039312748",
["file-user"] = "rbxassetid://99552018455009",
["file-video-camera"] = "rbxassetid://81719056173960",
["file-volume"] = "rbxassetid://111264764438958",
["file-x-corner"] = "rbxassetid://87554136773609",
["file-x"] = "rbxassetid://107333775515154",
["file"] = "rbxassetid://74748492079329",
["files"] = "rbxassetid://102806336233202",
["film"] = "rbxassetid://120978945609706",
["fingerprint"] = "rbxassetid://112173305232811",
["fire-extinguisher"] = "rbxassetid://111643493006960",
["fish-off"] = "rbxassetid://89756724887508",
["fish-symbol"] = "rbxassetid://118475177681618",
["fish"] = "rbxassetid://124360663785796",
["flag-off"] = "rbxassetid://112944528856799",
["flag-triangle-left"] = "rbxassetid://88045221285272",
["flag-triangle-right"] = "rbxassetid://108292480304566",
["flag"] = "rbxassetid://78183383236196",
["flame-kindling"] = "rbxassetid://139728976917928",
["flame"] = "rbxassetid://98218034436456",
["flashlight-off"] = "rbxassetid://79780362871740",
["flashlight"] = "rbxassetid://100286985600444",
["flask-conical-off"] = "rbxassetid://112597970025298",
["flask-conical"] = "rbxassetid://128406680901165",
["flask-round"] = "rbxassetid://127508287324940",
["flip-horizontal-2"] = "rbxassetid://103726993598186",
["flip-horizontal"] = "rbxassetid://122937530107837",
["flip-vertical-2"] = "rbxassetid://103836358956328",
["flip-vertical"] = "rbxassetid://108003917346888",
["flower-2"] = "rbxassetid://72934574245145",
["flower"] = "rbxassetid://86129438272762",
["focus"] = "rbxassetid://87493973153317",
["fold-horizontal"] = "rbxassetid://92835712442240",
["fold-vertical"] = "rbxassetid://108873727253656",
["folder-archive"] = "rbxassetid://97312009460206",
["folder-check"] = "rbxassetid://128492920904557",
["folder-clock"] = "rbxassetid://111964836738545",
["folder-closed"] = "rbxassetid://118286209350843",
["folder-code"] = "rbxassetid://70624096349370",
["folder-cog"] = "rbxassetid://85299519462846",
["folder-dot"] = "rbxassetid://138687772725278",
["folder-down"] = "rbxassetid://118044108459225",
["folder-git-2"] = "rbxassetid://101394054141166",
["folder-git"] = "rbxassetid://121885778095158",
["folder-heart"] = "rbxassetid://79104747211105",
["folder-input"] = "rbxassetid://90699920697871",
["folder-kanban"] = "rbxassetid://78313285104072",
["folder-key"] = "rbxassetid://85270407596791",
["folder-lock"] = "rbxassetid://119201572260567",
["folder-minus"] = "rbxassetid://85648718999010",
["folder-open-dot"] = "rbxassetid://74741494767354",
["folder-open"] = "rbxassetid://76018996254888",
["folder-output"] = "rbxassetid://101532447937612",
["folder-pen"] = "rbxassetid://112770491173911",
["folder-plus"] = "rbxassetid://91865663406119",
["folder-root"] = "rbxassetid://103333751154693",
["folder-search-2"] = "rbxassetid://71276453442655",
["folder-search"] = "rbxassetid://110568075123861",
["folder-symlink"] = "rbxassetid://127485747227189",
["folder-sync"] = "rbxassetid://91544602659796",
["folder-tree"] = "rbxassetid://85577554337861",
["folder-up"] = "rbxassetid://72008269765857",
["folder-x"] = "rbxassetid://91699618247635",
["folder"] = "rbxassetid://80846616596607",
["folders"] = "rbxassetid://110351216219061",
["footprints"] = "rbxassetid://139192589041315",
["forklift"] = "rbxassetid://72030930983101",
["forward"] = "rbxassetid://97545944739523",
["frame"] = "rbxassetid://109080612832751",
["framer"] = "rbxassetid://108384807262391",
["frown"] = "rbxassetid://124407301067982",
["fuel"] = "rbxassetid://106447647274511",
["fullscreen"] = "rbxassetid://77793665526178",
["funnel-plus"] = "rbxassetid://100780233821928",
["funnel-x"] = "rbxassetid://70984385812555",
["funnel"] = "rbxassetid://108829540827529",
["gallery-horizontal-end"] = "rbxassetid://74672430161161",
["gallery-horizontal"] = "rbxassetid://80004001442122",
["gallery-thumbnails"] = "rbxassetid://136219289862706",
["gallery-vertical-end"] = "rbxassetid://106461402088317",
["gallery-vertical"] = "rbxassetid://119299431466725",
["gamepad-2"] = "rbxassetid://92483947987410",
["gamepad-directional"] = "rbxassetid://84342305212226",
["gamepad"] = "rbxassetid://121607283959010",
["gauge"] = "rbxassetid://110273524101447",
["gavel"] = "rbxassetid://78952298198456",
["gem"] = "rbxassetid://112904952151156",
["georgian-lari"] = "rbxassetid://98084432591687",
["ghost"] = "rbxassetid://113822048130017",
["gift"] = "rbxassetid://109855212076373",
["git-branch-minus"] = "rbxassetid://97385010649411",
["git-branch-plus"] = "rbxassetid://125944221134316",
["git-branch"] = "rbxassetid://90490195516649",
["git-commit-horizontal"] = "rbxassetid://133646041800147",
["git-commit-vertical"] = "rbxassetid://122098032990350",
["git-compare-arrows"] = "rbxassetid://84874426520216",
["git-compare"] = "rbxassetid://91945124438792",
["git-fork"] = "rbxassetid://89954992404765",
["git-graph"] = "rbxassetid://86166832019304",
["git-merge"] = "rbxassetid://131833355158059",
["git-pull-request-arrow"] = "rbxassetid://94507974577439",
["git-pull-request-closed"] = "rbxassetid://78070600389091",
["git-pull-request-create-arrow"] = "rbxassetid://127422677061091",
["git-pull-request-create"] = "rbxassetid://105929577383926",
["git-pull-request-draft"] = "rbxassetid://76173459869943",
["git-pull-request"] = "rbxassetid://138463010991471",
["github"] = "rbxassetid://120349554354380",
["gitlab"] = "rbxassetid://114054627192933",
["glass-water"] = "rbxassetid://115526102400988",
["glasses"] = "rbxassetid://87936407455373",
["globe-lock"] = "rbxassetid://134065526704402",
["globe"] = "rbxassetid://114238209622913",
["goal"] = "rbxassetid://120517954878160",
["gpu"] = "rbxassetid://95577823614219",
["graduation-cap"] = "rbxassetid://93771896340220",
["grape"] = "rbxassetid://134760640415561",
["grid-2x2-check"] = "rbxassetid://138468840220821",
["grid-2x2-plus"] = "rbxassetid://91811610580247",
["grid-2x2-x"] = "rbxassetid://72407303981388",
["grid-2x2"] = "rbxassetid://99050491897640",
["grid-3x2"] = "rbxassetid://95528684210010",
["grid-3x3"] = "rbxassetid://70419024781206",
["grip-horizontal"] = "rbxassetid://136255899715930",
["grip-vertical"] = "rbxassetid://137183678565296",
["grip"] = "rbxassetid://109058783556768",
["group"] = "rbxassetid://107643418926671",
["guitar"] = "rbxassetid://75915531867926",
["ham"] = "rbxassetid://74465607934635",
["hamburger"] = "rbxassetid://93086916815495",
["hammer"] = "rbxassetid://83545120140895",
["hand-coins"] = "rbxassetid://126990543175462",
["hand-fist"] = "rbxassetid://83341608917591",
["hand-grab"] = "rbxassetid://88867162163985",
["hand-heart"] = "rbxassetid://117507367668412",
["hand-helping"] = "rbxassetid://89897738419446",
["hand-metal"] = "rbxassetid://113619498548713",
["hand-platter"] = "rbxassetid://88594727743168",
["hand"] = "rbxassetid://130703864968637",
["handbag"] = "rbxassetid://135675846264061",
["handshake"] = "rbxassetid://78442115255814",
["hard-drive-download"] = "rbxassetid://73913801230614",
["hard-drive-upload"] = "rbxassetid://85762133615118",
["hard-drive"] = "rbxassetid://88183305858463",
["hard-hat"] = "rbxassetid://128050846767382",
["hash"] = "rbxassetid://82890331678520",
["hat-glasses"] = "rbxassetid://101165538224815",
["haze"] = "rbxassetid://108857561768901",
["hdmi-port"] = "rbxassetid://103693661037020",
["heading-1"] = "rbxassetid://118129315662110",
["heading-2"] = "rbxassetid://110209069670094",
["heading-3"] = "rbxassetid://90267885237062",
["heading-4"] = "rbxassetid://129625620307602",
["heading-5"] = "rbxassetid://120386663181267",
["heading-6"] = "rbxassetid://90959079775093",
["heading"] = "rbxassetid://129254312067735",
["headphone-off"] = "rbxassetid://85038251615641",
["headphones"] = "rbxassetid://118833729589183",
["headset"] = "rbxassetid://129269236787694",
["heart-crack"] = "rbxassetid://110987638564119",
["heart-handshake"] = "rbxassetid://111483078692002",
["heart-minus"] = "rbxassetid://96827380163326",
["heart-off"] = "rbxassetid://89748414415617",
["heart-plus"] = "rbxassetid://94877796283249",
["heart-pulse"] = "rbxassetid://129352925579546",
["heart"] = "rbxassetid://116559368303288",
["heater"] = "rbxassetid://140478466880916",
["helicopter"] = "rbxassetid://111557171735930",
["hexagon"] = "rbxassetid://127592089339199",
["highlighter"] = "rbxassetid://77411555641113",
["history"] = "rbxassetid://123980022019922",
["hop-off"] = "rbxassetid://103386036934034",
["hop"] = "rbxassetid://82778923997672",
["hospital"] = "rbxassetid://105868763850707",
["hotel"] = "rbxassetid://132283390859718",
["hourglass"] = "rbxassetid://86160434939203",
["house-heart"] = "rbxassetid://136054771868597",
["house-plug"] = "rbxassetid://71438263712075",
["house-plus"] = "rbxassetid://118495165208309",
["house-wifi"] = "rbxassetid://126495519725698",
["house"] = "rbxassetid://98755624629571",
["ice-cream-bowl"] = "rbxassetid://124867218454386",
["ice-cream-cone"] = "rbxassetid://90751397288639",
["id-card-lanyard"] = "rbxassetid://90761480469224",
["id-card"] = "rbxassetid://75354294622640",
["image-down"] = "rbxassetid://78972295741235",
["image-minus"] = "rbxassetid://101066016918565",
["image-off"] = "rbxassetid://81934811700938",
["image-play"] = "rbxassetid://129501806784210",
["image-plus"] = "rbxassetid://70391970623917",
["image-up"] = "rbxassetid://126610009605241",
["image-upscale"] = "rbxassetid://106963545024679",
["images"] = "rbxassetid://79350649395557",
["import"] = "rbxassetid://116545008906029",
["inbox"] = "rbxassetid://112591360302868",
["indian-rupee"] = "rbxassetid://113038778381805",
["infinity"] = "rbxassetid://98083086936965",
["info"] = "rbxassetid://124560466474914",
["inspection-panel"] = "rbxassetid://70905313146088",
["instagram"] = "rbxassetid://119864798614855",
["italic"] = "rbxassetid://96220378864282",
["iteration-ccw"] = "rbxassetid://140221832794083",
["iteration-cw"] = "rbxassetid://95534489554662",
["japanese-yen"] = "rbxassetid://106362863465813",
["joystick"] = "rbxassetid://99416790224739",
["kanban"] = "rbxassetid://125934100055431",
["kayak"] = "rbxassetid://136107544609389",
["key-round"] = "rbxassetid://83619031955390",
["key-square"] = "rbxassetid://94621420033649",
["key"] = "rbxassetid://96510194465420",
["keyboard-music"] = "rbxassetid://121058541758636",
["keyboard-off"] = "rbxassetid://92466375369772",
["keyboard"] = "rbxassetid://121474456068237",
["lamp-ceiling"] = "rbxassetid://80032758469141",
["lamp-desk"] = "rbxassetid://85290686983238",
["lamp-floor"] = "rbxassetid://104585881375892",
["lamp-wall-down"] = "rbxassetid://91271394132073",
["lamp-wall-up"] = "rbxassetid://132141464337445",
["lamp"] = "rbxassetid://110730830653382",
["land-plot"] = "rbxassetid://96449039620294",
["landmark"] = "rbxassetid://76885079756393",
["languages"] = "rbxassetid://90816903776498",
["laptop-minimal-check"] = "rbxassetid://114352019833865",
["laptop-minimal"] = "rbxassetid://136705765566068",
["laptop"] = "rbxassetid://111387063244975",
["lasso-select"] = "rbxassetid://105609719912753",
["lasso"] = "rbxassetid://121072936884007",
["laugh"] = "rbxassetid://104491311361166",
["layers-2"] = "rbxassetid://70536710516357",
["layers"] = "rbxassetid://81973586053257",
["layout-dashboard"] = "rbxassetid://139929981863901",
["layout-grid"] = "rbxassetid://81344910161871",
["layout-list"] = "rbxassetid://87462136296578",
["layout-panel-left"] = "rbxassetid://125092469751491",
["layout-panel-top"] = "rbxassetid://91943941515944",
["layout-template"] = "rbxassetid://115564446417985",
["leaf"] = "rbxassetid://119951075637174",
["leafy-green"] = "rbxassetid://105146290493154",
["lectern"] = "rbxassetid://106166425183862",
["library-big"] = "rbxassetid://106794530191412",
["library"] = "rbxassetid://114334671982047",
["life-buoy"] = "rbxassetid://81168450671956",
["ligature"] = "rbxassetid://111397873269411",
["lightbulb-off"] = "rbxassetid://83795722296178",
["lightbulb"] = "rbxassetid://103871245626488",
["line-squiggle"] = "rbxassetid://109555164424447",
["link-2-off"] = "rbxassetid://76885956296867",
["link-2"] = "rbxassetid://86072351557466",
["link"] = "rbxassetid://131607023382430",
["linkedin"] = "rbxassetid://132842789255788",
["list-check"] = "rbxassetid://72374358471156",
["list-checks"] = "rbxassetid://99809353635593",
["list-chevrons-down-up"] = "rbxassetid://137409641500711",
["list-chevrons-up-down"] = "rbxassetid://81825351389084",
["list-collapse"] = "rbxassetid://124505247702401",
["list-end"] = "rbxassetid://77650610048119",
["list-filter-plus"] = "rbxassetid://96385120752336",
["list-filter"] = "rbxassetid://103321376129527",
["list-indent-decrease"] = "rbxassetid://137879979228193",
["list-indent-increase"] = "rbxassetid://79051053161201",
["list-minus"] = "rbxassetid://138507965142671",
["list-music"] = "rbxassetid://126380635781840",
["list-ordered"] = "rbxassetid://83212528113913",
["list-plus"] = "rbxassetid://112384738137814",
["list-restart"] = "rbxassetid://91703153577421",
["list-start"] = "rbxassetid://84828348299727",
["list-todo"] = "rbxassetid://132980603752108",
["list-tree"] = "rbxassetid://97685396239010",
["list-video"] = "rbxassetid://93648525452489",
["list-x"] = "rbxassetid://113025303988861",
["list"] = "rbxassetid://113179976918783",
["loader-circle"] = "rbxassetid://116535712789945",
["loader-pinwheel"] = "rbxassetid://108513357940900",
["loader"] = "rbxassetid://78408734580845",
["locate-fixed"] = "rbxassetid://137367361548433",
["locate-off"] = "rbxassetid://73729216338137",
["locate"] = "rbxassetid://84467676590391",
["lock-keyhole-open"] = "rbxassetid://110863509313073",
["lock-keyhole"] = "rbxassetid://78672912777756",
["lock-open"] = "rbxassetid://93597915325122",
["lock"] = "rbxassetid://134724289526879",
["log-in"] = "rbxassetid://103768533135201",
["log-out"] = "rbxassetid://84895399304975",
["logs"] = "rbxassetid://89772091251787",
["lollipop"] = "rbxassetid://84681611583044",
["luggage"] = "rbxassetid://76619236486400",
["magnet"] = "rbxassetid://135162361226972",
["mail-check"] = "rbxassetid://86921536259917",
["mail-minus"] = "rbxassetid://81989813236553",
["mail-open"] = "rbxassetid://122785416858638",
["mail-plus"] = "rbxassetid://104886401588341",
["mail-question-mark"] = "rbxassetid://126540170949819",
["mail-search"] = "rbxassetid://135616173775287",
["mail-warning"] = "rbxassetid://81495303676089",
["mail-x"] = "rbxassetid://74607841705644",
["mail"] = "rbxassetid://103945161245599",
["mailbox"] = "rbxassetid://82765503320335",
["mails"] = "rbxassetid://90673453450080",
["map-minus"] = "rbxassetid://129525760577747",
["map-pin-check-inside"] = "rbxassetid://107130529843809",
["map-pin-check"] = "rbxassetid://118110914690154",
["map-pin-house"] = "rbxassetid://80546885029816",
["map-pin-minus-inside"] = "rbxassetid://79005529692964",
["map-pin-minus"] = "rbxassetid://74518762643623",
["map-pin-off"] = "rbxassetid://82474689391020",
["map-pin-pen"] = "rbxassetid://113515395277504",
["map-pin-plus-inside"] = "rbxassetid://134639656514430",
["map-pin-plus"] = "rbxassetid://91875228967029",
["map-pin-x-inside"] = "rbxassetid://126235934252379",
["map-pin-x"] = "rbxassetid://101085273547316",
["map-pin"] = "rbxassetid://84279202219901",
["map-pinned"] = "rbxassetid://103963788475034",
["map-plus"] = "rbxassetid://129388826743495",
["map"] = "rbxassetid://95107167260947",
["mars-stroke"] = "rbxassetid://131973193186828",
["mars"] = "rbxassetid://111287112372511",
["martini"] = "rbxassetid://82977695401058",
["maximize-2"] = "rbxassetid://73085922906397",
["maximize"] = "rbxassetid://76045941763188",
["medal"] = "rbxassetid://79016002264450",
["megaphone-off"] = "rbxassetid://124280774193935",
["megaphone"] = "rbxassetid://118759541854879",
["meh"] = "rbxassetid://132197867028557",
["memory-stick"] = "rbxassetid://93212591343119",
["menu"] = "rbxassetid://77021539815611",
["merge"] = "rbxassetid://126201866476775",
["message-circle-code"] = "rbxassetid://112865244991651",
["message-circle-dashed"] = "rbxassetid://81525157881897",
["message-circle-heart"] = "rbxassetid://101990756073677",
["message-circle-more"] = "rbxassetid://92856823884663",
["message-circle-off"] = "rbxassetid://134955643890328",
["message-circle-plus"] = "rbxassetid://106562979649273",
["message-circle-question-mark"] = "rbxassetid://107700302759934",
["message-circle-reply"] = "rbxassetid://137071749508334",
["message-circle-warning"] = "rbxassetid://119020096067894",
["message-circle-x"] = "rbxassetid://126843387725536",
["message-circle"] = "rbxassetid://127255077587058",
["message-square-code"] = "rbxassetid://110968863152123",
["message-square-dashed"] = "rbxassetid://107653455516238",
["message-square-diff"] = "rbxassetid://75472190472625",
["message-square-dot"] = "rbxassetid://127806382463916",
["message-square-heart"] = "rbxassetid://75612811742074",
["message-square-lock"] = "rbxassetid://81268215619563",
["message-square-more"] = "rbxassetid://120139782405970",
["message-square-off"] = "rbxassetid://99961019005789",
["message-square-plus"] = "rbxassetid://76934450256199",
["message-square-quote"] = "rbxassetid://116670768629340",
["message-square-reply"] = "rbxassetid://130985622754637",
["message-square-share"] = "rbxassetid://131017005324026",
["message-square-text"] = "rbxassetid://94899503194205",
["message-square-warning"] = "rbxassetid://138432903962261",
["message-square-x"] = "rbxassetid://137285463279462",
["message-square"] = "rbxassetid://83881670383280",
["messages-square"] = "rbxassetid://97532166733358",
["mic-off"] = "rbxassetid://82123034444822",
["mic-vocal"] = "rbxassetid://99082286164362",
["mic"] = "rbxassetid://89640799126523",
["microchip"] = "rbxassetid://73937907669903",
["microscope"] = "rbxassetid://116875530102782",
["microwave"] = "rbxassetid://108411735353008",
["milestone"] = "rbxassetid://101618292325920",
["milk-off"] = "rbxassetid://72388480962742",
["milk"] = "rbxassetid://96221903896918",
["minimize-2"] = "rbxassetid://116269596042539",
["minimize"] = "rbxassetid://121304296213645",
["minus"] = "rbxassetid://118026365011536",
["monitor-check"] = "rbxassetid://86651948439229",
["monitor-cloud"] = "rbxassetid://85931096038318",
["monitor-cog"] = "rbxassetid://94345128715799",
["monitor-dot"] = "rbxassetid://130394010063680",
["monitor-down"] = "rbxassetid://97466933743423",
["monitor-off"] = "rbxassetid://74395526657953",
["monitor-pause"] = "rbxassetid://76002184067562",
["monitor-play"] = "rbxassetid://133018824306217",
["monitor-smartphone"] = "rbxassetid://84335680433378",
["monitor-speaker"] = "rbxassetid://81744810060380",
["monitor-stop"] = "rbxassetid://98708958984757",
["monitor-up"] = "rbxassetid://96035360858377",
["monitor-x"] = "rbxassetid://126265210441423",
["monitor"] = "rbxassetid://72664649203050",
["moon-star"] = "rbxassetid://82782200506348",
["moon"] = "rbxassetid://83380517901735",
["motorbike"] = "rbxassetid://94580787368233",
["mountain-snow"] = "rbxassetid://105315495740588",
["mountain"] = "rbxassetid://73269957566415",
["mouse-off"] = "rbxassetid://75267871697595",
["mouse-pointer-2-off"] = "rbxassetid://104701076865632",
["mouse-pointer-2"] = "rbxassetid://117093892862228",
["mouse-pointer-ban"] = "rbxassetid://106849413057133",
["mouse-pointer-click"] = "rbxassetid://107150227368485",
["mouse-pointer"] = "rbxassetid://72322454962935",
["mouse"] = "rbxassetid://73096068864710",
["move-3d"] = "rbxassetid://103365982054003",
["move-diagonal-2"] = "rbxassetid://117298577948096",
["move-diagonal"] = "rbxassetid://101433481954184",
["move-down-left"] = "rbxassetid://102819433534567",
["move-down-right"] = "rbxassetid://101479760041877",
["move-down"] = "rbxassetid://70510115135583",
["move-horizontal"] = "rbxassetid://88513523439149",
["move-left"] = "rbxassetid://137614740247980",
["move-right"] = "rbxassetid://132455779472989",
["move-up-left"] = "rbxassetid://139079815540148",
["move-up-right"] = "rbxassetid://105885140592646",
["move-up"] = "rbxassetid://84505444262658",
["move-vertical"] = "rbxassetid://86234730730899",
["move"] = "rbxassetid://116138709011735",
["music-2"] = "rbxassetid://134397426600888",
["music-3"] = "rbxassetid://94466120066498",
["music-4"] = "rbxassetid://132459323665838",
["music"] = "rbxassetid://113343203848535",
["navigation-2-off"] = "rbxassetid://116569611780763",
["navigation-2"] = "rbxassetid://81889066747907",
["navigation-off"] = "rbxassetid://87003270290777",
["navigation"] = "rbxassetid://79308213542922",
["network"] = "rbxassetid://127410729922644",
["newspaper"] = "rbxassetid://123479530460544",
["nfc"] = "rbxassetid://76822396542242",
["non-binary"] = "rbxassetid://78442360386235",
["notebook-pen"] = "rbxassetid://140380614761023",
["notebook-tabs"] = "rbxassetid://127371085570083",
["notebook-text"] = "rbxassetid://93061585217270",
["notebook"] = "rbxassetid://136132108664987",
["notepad-text-dashed"] = "rbxassetid://135793446376219",
["notepad-text"] = "rbxassetid://93404682958966",
["nut-off"] = "rbxassetid://78795397311573",
["nut"] = "rbxassetid://127146410705656",
["octagon-alert"] = "rbxassetid://140438367956051",
["octagon-minus"] = "rbxassetid://74720436795421",
["octagon-pause"] = "rbxassetid://103161463909039",
["octagon-x"] = "rbxassetid://90498161006311",
["octagon"] = "rbxassetid://120803515514852",
["omega"] = "rbxassetid://70414080018786",
["option"] = "rbxassetid://100776883894054",
["orbit"] = "rbxassetid://108926136860562",
["origami"] = "rbxassetid://136020626667101",
["package-2"] = "rbxassetid://70394974762575",
["package-check"] = "rbxassetid://102374216055130",
["package-minus"] = "rbxassetid://114492858789692",
["package-open"] = "rbxassetid://132890233237818",
["package-plus"] = "rbxassetid://129261988138366",
["package-search"] = "rbxassetid://95465120894145",
["package-x"] = "rbxassetid://70818501607442",
["package"] = "rbxassetid://97261141732706",
["paint-bucket"] = "rbxassetid://124275586663284",
["paint-roller"] = "rbxassetid://115248074358348",
["paintbrush-vertical"] = "rbxassetid://105151296591292",
["paintbrush"] = "rbxassetid://125572663700289",
["palette"] = "rbxassetid://86350350950064",
["panda"] = "rbxassetid://132509022802512",
["panel-bottom-close"] = "rbxassetid://74287004071159",
["panel-bottom-dashed"] = "rbxassetid://131084651621603",
["panel-bottom-open"] = "rbxassetid://107768659586540",
["panel-bottom"] = "rbxassetid://132127145048511",
["panel-left-close"] = "rbxassetid://126579818823552",
["panel-left-dashed"] = "rbxassetid://75536606374585",
["panel-left-open"] = "rbxassetid://111075816195767",
["panel-left-right-dashed"] = "rbxassetid://110100707973959",
["panel-left"] = "rbxassetid://97419752870313",
["panel-right-close"] = "rbxassetid://139528655524132",
["panel-right-dashed"] = "rbxassetid://94959793877311",
["panel-right-open"] = "rbxassetid://118114419142794",
["panel-right"] = "rbxassetid://116365035443156",
["panel-top-bottom-dashed"] = "rbxassetid://134737235653344",
["panel-top-close"] = "rbxassetid://83578325777808",
["panel-top-dashed"] = "rbxassetid://70522913169237",
["panel-top-open"] = "rbxassetid://137959875507454",
["panel-top"] = "rbxassetid://75838479462875",
["panels-left-bottom"] = "rbxassetid://72996856149149",
["panels-right-bottom"] = "rbxassetid://90659068960726",
["panels-top-left"] = "rbxassetid://79858853850600",
["paperclip"] = "rbxassetid://92088291163453",
["parentheses"] = "rbxassetid://78950955173096",
["parking-meter"] = "rbxassetid://84652733960568",
["party-popper"] = "rbxassetid://111626795712193",
["pause"] = "rbxassetid://74873705394436",
["paw-print"] = "rbxassetid://112218825427601",
["pc-case"] = "rbxassetid://122978648019101",
["pen-line"] = "rbxassetid://109108135755303",
["pen-off"] = "rbxassetid://84807123119438",
["pen-tool"] = "rbxassetid://106145404953445",
["pen"] = "rbxassetid://72037878096321",
["pencil-line"] = "rbxassetid://88392917053533",
["pencil-off"] = "rbxassetid://103330927652832",
["pencil-ruler"] = "rbxassetid://110120288284597",
["pencil"] = "rbxassetid://137986121120732",
["pentagon"] = "rbxassetid://79184802179890",
["percent"] = "rbxassetid://130155041032013",
["person-standing"] = "rbxassetid://125020872044147",
["philippine-peso"] = "rbxassetid://91173798254675",
["phone-call"] = "rbxassetid://70555587592860",
["phone-forwarded"] = "rbxassetid://113269614319737",
["phone-incoming"] = "rbxassetid://82863576359288",
["phone-missed"] = "rbxassetid://130156165198376",
["phone-off"] = "rbxassetid://133318623553383",
["phone-outgoing"] = "rbxassetid://104576478735825",
["phone"] = "rbxassetid://128804946640049",
["pi"] = "rbxassetid://74936036243146",
["piano"] = "rbxassetid://85008880789520",
["pickaxe"] = "rbxassetid://105888023317688",
["picture-in-picture-2"] = "rbxassetid://112803319544468",
["picture-in-picture"] = "rbxassetid://80579597835123",
["piggy-bank"] = "rbxassetid://79498575790721",
["pilcrow-left"] = "rbxassetid://103803000849583",
["pilcrow-right"] = "rbxassetid://104881733911870",
["pilcrow"] = "rbxassetid://139512780392871",
["pill-bottle"] = "rbxassetid://118394692404597",
["pill"] = "rbxassetid://73280534813448",
["pin-off"] = "rbxassetid://127696372451750",
["pin"] = "rbxassetid://120978111007514",
["pipette"] = "rbxassetid://133167932934404",
["pizza"] = "rbxassetid://126964453193501",
["plane-landing"] = "rbxassetid://122555692211889",
["plane-takeoff"] = "rbxassetid://117179478829575",
["plane"] = "rbxassetid://126985561580989",
["play"] = "rbxassetid://135609604299893",
["plug-2"] = "rbxassetid://97912386476366",
["plug-zap"] = "rbxassetid://74506269884055",
["plug"] = "rbxassetid://99782373064495",
["plus"] = "rbxassetid://111774323017047",
["pocket-knife"] = "rbxassetid://134075428063965",
["pocket"] = "rbxassetid://136686762542964",
["podcast"] = "rbxassetid://109577075549215",
["pointer-off"] = "rbxassetid://95488389312794",
["pointer"] = "rbxassetid://92615117311099",
["popcorn"] = "rbxassetid://139446511232750",
["popsicle"] = "rbxassetid://112696318077073",
["pound-sterling"] = "rbxassetid://127482649469130",
["power-off"] = "rbxassetid://118768311012214",
["power"] = "rbxassetid://96479131758775",
["presentation"] = "rbxassetid://106134583757890",
["printer-check"] = "rbxassetid://130273549443689",
["printer"] = "rbxassetid://76080649734247",
["projector"] = "rbxassetid://103281856385283",
["proportions"] = "rbxassetid://130046855997237",
["puzzle"] = "rbxassetid://136837798892463",
["pyramid"] = "rbxassetid://107811442374127",
["qr-code"] = "rbxassetid://105329945723350",
["quote"] = "rbxassetid://103271711590001",
["rabbit"] = "rbxassetid://98580518804206",
["radar"] = "rbxassetid://138528222906635",
["radiation"] = "rbxassetid://104499586848433",
["radical"] = "rbxassetid://132758286926047",
["radio-receiver"] = "rbxassetid://129598303378835",
["radio-tower"] = "rbxassetid://93958663130054",
["radio"] = "rbxassetid://85611589536956",
["radius"] = "rbxassetid://89814505307129",
["rail-symbol"] = "rbxassetid://134295386306962",
["rainbow"] = "rbxassetid://132488862841895",
["rat"] = "rbxassetid://127400975953159",
["ratio"] = "rbxassetid://126369423897295",
["receipt-cent"] = "rbxassetid://91557573925201",
["receipt-euro"] = "rbxassetid://94015722210295",
["receipt-indian-rupee"] = "rbxassetid://89718170439990",
["receipt-japanese-yen"] = "rbxassetid://132472560758851",
["receipt-pound-sterling"] = "rbxassetid://73934967569625",
["receipt-russian-ruble"] = "rbxassetid://105164576936853",
["receipt-swiss-franc"] = "rbxassetid://72503668620116",
["receipt-text"] = "rbxassetid://138483536013737",
["receipt-turkish-lira"] = "rbxassetid://91950765836342",
["receipt"] = "rbxassetid://77877895901792",
["rectangle-circle"] = "rbxassetid://100642423153903",
["rectangle-ellipsis"] = "rbxassetid://112919953980965",
["rectangle-goggles"] = "rbxassetid://98605436666727",
["rectangle-horizontal"] = "rbxassetid://90224199814966",
["rectangle-vertical"] = "rbxassetid://117277050590967",
["recycle"] = "rbxassetid://140417023381961",
["redo-2"] = "rbxassetid://70451039017914",
["redo-dot"] = "rbxassetid://94252981719732",
["redo"] = "rbxassetid://116150342119054",
["refresh-ccw-dot"] = "rbxassetid://106702246753270",
["refresh-ccw"] = "rbxassetid://117913330389477",
["refresh-cw-off"] = "rbxassetid://140179498843054",
["refresh-cw"] = "rbxassetid://138133190015277",
["refrigerator"] = "rbxassetid://102614042652753",
["regex"] = "rbxassetid://100727200791841",
["remove-formatting"] = "rbxassetid://112833162022628",
["repeat-1"] = "rbxassetid://130144534857095",
["repeat-2"] = "rbxassetid://85927537182704",
["repeat"] = "rbxassetid://121886242955173",
["replace-all"] = "rbxassetid://127862728198635",
["replace"] = "rbxassetid://128404082279430",
["reply-all"] = "rbxassetid://71723137343562",
["reply"] = "rbxassetid://109788633497028",
["rewind"] = "rbxassetid://95205297521988",
["ribbon"] = "rbxassetid://94265331526851",
["rocket"] = "rbxassetid://87412317685854",
["rocking-chair"] = "rbxassetid://110420269495360",
["roller-coaster"] = "rbxassetid://112426178972099",
["rose"] = "rbxassetid://126336840238769",
["rotate-3d"] = "rbxassetid://76300551576392",
["rotate-ccw-key"] = "rbxassetid://74976035240976",
["rotate-ccw-square"] = "rbxassetid://90515853170424",
["rotate-ccw"] = "rbxassetid://110116685948665",
["rotate-cw-square"] = "rbxassetid://77095448159303",
["rotate-cw"] = "rbxassetid://84183336178654",
["route-off"] = "rbxassetid://106350402024079",
["route"] = "rbxassetid://89968303228953",
["router"] = "rbxassetid://102130331994471",
["rows-2"] = "rbxassetid://112556185960101",
["rows-3"] = "rbxassetid://117215586961375",
["rows-4"] = "rbxassetid://125646021959055",
["rss"] = "rbxassetid://131789058984793",
["ruler-dimension-line"] = "rbxassetid://70673861371412",
["ruler"] = "rbxassetid://81432445547423",
["russian-ruble"] = "rbxassetid://126357936542156",
["sailboat"] = "rbxassetid://87110567187540",
["salad"] = "rbxassetid://128864507821603",
["sandwich"] = "rbxassetid://104573187458917",
["satellite-dish"] = "rbxassetid://136742443888305",
["satellite"] = "rbxassetid://134967053164645",
["saudi-riyal"] = "rbxassetid://102282769104635",
["save-all"] = "rbxassetid://116946975799440",
["save-off"] = "rbxassetid://87085435778560",
["save"] = "rbxassetid://126116963775616",
["scale-3d"] = "rbxassetid://72414199620352",
["scale"] = "rbxassetid://108203682317477",
["scaling"] = "rbxassetid://122360365318466",
["scan-barcode"] = "rbxassetid://96889457154761",
["scan-eye"] = "rbxassetid://99244790601968",
["scan-face"] = "rbxassetid://109959345069668",
["scan-heart"] = "rbxassetid://106280819776142",
["scan-line"] = "rbxassetid://126544908146540",
["scan-qr-code"] = "rbxassetid://105409149549927",
["scan-search"] = "rbxassetid://80009010551347",
["scan-text"] = "rbxassetid://73702396787766",
["scan"] = "rbxassetid://123104789658180",
["school"] = "rbxassetid://76351530290068",
["scissors-line-dashed"] = "rbxassetid://122237447974173",
["scissors"] = "rbxassetid://118665510911274",
["screen-share-off"] = "rbxassetid://107677572669805",
["screen-share"] = "rbxassetid://85137895705653",
["scroll-text"] = "rbxassetid://97321022666868",
["scroll"] = "rbxassetid://74072101474951",
["search-check"] = "rbxassetid://75442076191356",
["search-code"] = "rbxassetid://117114794592802",
["search-slash"] = "rbxassetid://96483932261041",
["search-x"] = "rbxassetid://137319957522951",
["search"] = "rbxassetid://121018724060431",
["section"] = "rbxassetid://91732188298948",
["send-horizontal"] = "rbxassetid://111734392411664",
["send-to-back"] = "rbxassetid://75340312862253",
["send"] = "rbxassetid://127751956873796",
["separator-horizontal"] = "rbxassetid://84864453699927",
["separator-vertical"] = "rbxassetid://84031801478581",
["server-cog"] = "rbxassetid://138470287250966",
["server-crash"] = "rbxassetid://132810618000212",
["server-off"] = "rbxassetid://114048751507723",
["server"] = "rbxassetid://92188766517878",
["settings-2"] = "rbxassetid://135684703553372",
["settings"] = "rbxassetid://80758916183665",
["shapes"] = "rbxassetid://129989433311409",
["share-2"] = "rbxassetid://71210767962065",
["share"] = "rbxassetid://87340985053299",
["sheet"] = "rbxassetid://134902122480171",
["shell"] = "rbxassetid://140212943563599",
["shield-alert"] = "rbxassetid://114995877719925",
["shield-ban"] = "rbxassetid://108765041044649",
["shield-check"] = "rbxassetid://87354736164608",
["shield-ellipsis"] = "rbxassetid://114794739892123",
["shield-half"] = "rbxassetid://117842634172647",
["shield-minus"] = "rbxassetid://89965059528921",
["shield-off"] = "rbxassetid://133426959132690",
["shield-plus"] = "rbxassetid://100664857995498",
["shield-question-mark"] = "rbxassetid://135722075265150",
["shield-user"] = "rbxassetid://124832775645347",
["shield-x"] = "rbxassetid://73370117343811",
["shield"] = "rbxassetid://110987169760162",
["ship-wheel"] = "rbxassetid://130797795829448",
["ship"] = "rbxassetid://83995100553930",
["shirt"] = "rbxassetid://106579555405966",
["shopping-bag"] = "rbxassetid://71885477293226",
["shopping-basket"] = "rbxassetid://138646411956433",
["shopping-cart"] = "rbxassetid://128420521375441",
["shovel"] = "rbxassetid://102465000512056",
["shower-head"] = "rbxassetid://75884944024117",
["shredder"] = "rbxassetid://122125164414463",
["shrimp"] = "rbxassetid://102625900815307",
["shrink"] = "rbxassetid://90953687918880",
["shrub"] = "rbxassetid://127326280714343",
["shuffle"] = "rbxassetid://132382786975101",
["sigma"] = "rbxassetid://126884244870899",
["signal-high"] = "rbxassetid://130436670012270",
["signal-low"] = "rbxassetid://73674683500458",
["signal-medium"] = "rbxassetid://125003021367019",
["signal-zero"] = "rbxassetid://130045332414754",
["signal"] = "rbxassetid://78424889355261",
["signature"] = "rbxassetid://114402748013000",
["signpost-big"] = "rbxassetid://115780185675001",
["signpost"] = "rbxassetid://106584743791433",
["siren"] = "rbxassetid://134210267818039",
["skip-back"] = "rbxassetid://70466132711334",
["skip-forward"] = "rbxassetid://124844823753990",
["skull"] = "rbxassetid://137726256442333",
["slack"] = "rbxassetid://96089719516736",
["slash"] = "rbxassetid://117792185664263",
["slice"] = "rbxassetid://95810504278179",
["sliders-horizontal"] = "rbxassetid://85538382643347",
["sliders-vertical"] = "rbxassetid://101190569086853",
["smartphone-charging"] = "rbxassetid://102837532613995",
["smartphone-nfc"] = "rbxassetid://82326425754446",
["smartphone"] = "rbxassetid://96623008834511",
["smile-plus"] = "rbxassetid://131981881472144",
["smile"] = "rbxassetid://105880397565283",
["snail"] = "rbxassetid://70904536548363",
["snowflake"] = "rbxassetid://101235206534566",
["soap-dispenser-droplet"] = "rbxassetid://77258480479465",
["sofa"] = "rbxassetid://114427687218324",
["solar-panel"] = "rbxassetid://132448188047921",
["soup"] = "rbxassetid://115092551871618",
["space"] = "rbxassetid://87072088914178",
["spade"] = "rbxassetid://131444449466462",
["sparkle"] = "rbxassetid://111044800239623",
["sparkles"] = "rbxassetid://138635884129147",
["speaker"] = "rbxassetid://96227183003618",
["speech"] = "rbxassetid://87013139446349",
["spell-check-2"] = "rbxassetid://81556731785534",
["spell-check"] = "rbxassetid://91913483031334",
["spline-pointer"] = "rbxassetid://84842840956804",
["spline"] = "rbxassetid://129406685807412",
["split"] = "rbxassetid://105112438805988",
["spool"] = "rbxassetid://124541981347743",
["spotlight"] = "rbxassetid://77571742539344",
["spray-can"] = "rbxassetid://128372039366326",
["sprout"] = "rbxassetid://100091687832508",
["square-activity"] = "rbxassetid://89496630185293",
["square-arrow-down-left"] = "rbxassetid://108194680296901",
["square-arrow-down-right"] = "rbxassetid://99403846801050",
["square-arrow-down"] = "rbxassetid://135962519626588",
["square-arrow-left"] = "rbxassetid://111671474549238",
["square-arrow-out-down-left"] = "rbxassetid://125714881756353",
["square-arrow-out-down-right"] = "rbxassetid://89971003001390",
["square-arrow-out-up-left"] = "rbxassetid://103759986579087",
["square-arrow-out-up-right"] = "rbxassetid://91221896066807",
["square-arrow-right"] = "rbxassetid://113920471701361",
["square-arrow-up-left"] = "rbxassetid://112424670290693",
["square-arrow-up-right"] = "rbxassetid://76602291406940",
["square-arrow-up"] = "rbxassetid://106998604646718",
["square-asterisk"] = "rbxassetid://89186832353625",
["square-bottom-dashed-scissors"] = "rbxassetid://79076980104803",
["square-chart-gantt"] = "rbxassetid://104034017316411",
["square-check-big"] = "rbxassetid://115320390907184",
["square-check"] = "rbxassetid://134682053539509",
["square-chevron-down"] = "rbxassetid://91032307924592",
["square-chevron-left"] = "rbxassetid://73143404829510",
["square-chevron-right"] = "rbxassetid://90612077729930",
["square-chevron-up"] = "rbxassetid://85565910197337",
["square-code"] = "rbxassetid://81604576616881",
["square-dashed-bottom-code"] = "rbxassetid://100354801563230",
["square-dashed-bottom"] = "rbxassetid://101102319625624",
["square-dashed-kanban"] = "rbxassetid://90388067649847",
["square-dashed-mouse-pointer"] = "rbxassetid://121016142178467",
["square-dashed-top-solid"] = "rbxassetid://117157577548540",
["square-dashed"] = "rbxassetid://136905537847606",
["square-divide"] = "rbxassetid://99894657101970",
["square-dot"] = "rbxassetid://116613421354866",
["square-equal"] = "rbxassetid://110283363706707",
["square-function"] = "rbxassetid://86075219551088",
["square-kanban"] = "rbxassetid://114537101260131",
["square-library"] = "rbxassetid://73810931222081",
["square-m"] = "rbxassetid://117662700410577",
["square-menu"] = "rbxassetid://104067089444415",
["square-minus"] = "rbxassetid://116764432015770",
["square-mouse-pointer"] = "rbxassetid://76141850603920",
["square-parking-off"] = "rbxassetid://100857293535141",
["square-parking"] = "rbxassetid://133116656122387",
["square-pause"] = "rbxassetid://86608552787615",
["square-pen"] = "rbxassetid://120239476110475",
["square-percent"] = "rbxassetid://87111930314567",
["square-pi"] = "rbxassetid://75383328781618",
["square-pilcrow"] = "rbxassetid://131854284699367",
["square-play"] = "rbxassetid://108186325238481",
["square-plus"] = "rbxassetid://114713264461873",
["square-power"] = "rbxassetid://129240437805187",
["square-radical"] = "rbxassetid://132645931868292",
["square-round-corner"] = "rbxassetid://104592745113567",
["square-scissors"] = "rbxassetid://110601255612411",
["square-sigma"] = "rbxassetid://113231244246816",
["square-slash"] = "rbxassetid://105477013908757",
["square-split-horizontal"] = "rbxassetid://76095370148660",
["square-split-vertical"] = "rbxassetid://88589192032058",
["square-square"] = "rbxassetid://136555087357875",
["square-stack"] = "rbxassetid://100463396619394",
["square-star"] = "rbxassetid://94506958703720",
["square-stop"] = "rbxassetid://80018708472943",
["square-terminal"] = "rbxassetid://83969264476798",
["square-user-round"] = "rbxassetid://86484997229302",
["square-user"] = "rbxassetid://70771214183445",
["square-x"] = "rbxassetid://125136183850190",
["square"] = "rbxassetid://86304921356806",
["squares-exclude"] = "rbxassetid://102345385822324",
["squares-intersect"] = "rbxassetid://120869602570119",
["squares-subtract"] = "rbxassetid://131484650948795",
["squares-unite"] = "rbxassetid://96673080107843",
["squircle-dashed"] = "rbxassetid://129936702532522",
["squircle"] = "rbxassetid://82426632573807",
["squirrel"] = "rbxassetid://112864252085343",
["stamp"] = "rbxassetid://92370779813368",
["star-half"] = "rbxassetid://117449275562979",
["star-off"] = "rbxassetid://75742832732503",
["star"] = "rbxassetid://136141469398409",
["step-back"] = "rbxassetid://108672750005121",
["step-forward"] = "rbxassetid://126131872136145",
["stethoscope"] = "rbxassetid://122331031702148",
["sticker"] = "rbxassetid://79938203791608",
["sticky-note"] = "rbxassetid://111894074643919",
["store"] = "rbxassetid://90338129673705",
["stretch-horizontal"] = "rbxassetid://87665042192343",
["stretch-vertical"] = "rbxassetid://95265463417122",
["strikethrough"] = "rbxassetid://103417324549613",
["subscript"] = "rbxassetid://74553514785183",
["sun-dim"] = "rbxassetid://129141645592715",
["sun-medium"] = "rbxassetid://130278807964710",
["sun-moon"] = "rbxassetid://75752898854559",
["sun-snow"] = "rbxassetid://112791898014579",
["sun"] = "rbxassetid://110150589884127",
["sunrise"] = "rbxassetid://134705665494098",
["sunset"] = "rbxassetid://75904872203588",
["superscript"] = "rbxassetid://96887696590118",
["swatch-book"] = "rbxassetid://126786244872453",
["swiss-franc"] = "rbxassetid://113497920041625",
["switch-camera"] = "rbxassetid://76841154349737",
["sword"] = "rbxassetid://124448418211665",
["swords"] = "rbxassetid://81872698913435",
["syringe"] = "rbxassetid://123891270479254",
["table-2"] = "rbxassetid://95751552281545",
["table-cells-merge"] = "rbxassetid://95363715175258",
["table-cells-split"] = "rbxassetid://114799086088649",
["table-columns-split"] = "rbxassetid://111011625447949",
["table-of-contents"] = "rbxassetid://135044763275414",
["table-properties"] = "rbxassetid://125062886015372",
["table-rows-split"] = "rbxassetid://96443733673997",
["table"] = "rbxassetid://109109148250737",
["tablet-smartphone"] = "rbxassetid://133680859813404",
["tablet"] = "rbxassetid://128403991264386",
["tablets"] = "rbxassetid://80835787970735",
["tag"] = "rbxassetid://129104970103940",
["tags"] = "rbxassetid://107179263080798",
["tally-1"] = "rbxassetid://115301298241643",
["tally-2"] = "rbxassetid://110363186864027",
["tally-3"] = "rbxassetid://97655344572540",
["tally-4"] = "rbxassetid://102633494371890",
["tally-5"] = "rbxassetid://88031817475886",
["tangent"] = "rbxassetid://123263132981724",
["target"] = "rbxassetid://87563802520297",
["telescope"] = "rbxassetid://91755049143647",
["tent-tree"] = "rbxassetid://76698322463977",
["tent"] = "rbxassetid://109779587826330",
["terminal"] = "rbxassetid://106783148545356",
["test-tube-diagonal"] = "rbxassetid://75662704378840",
["test-tube"] = "rbxassetid://98801015650164",
["test-tubes"] = "rbxassetid://92555361447433",
["text-align-center"] = "rbxassetid://84051028246390",
["text-align-end"] = "rbxassetid://130041738343555",
["text-align-justify"] = "rbxassetid://80279880143030",
["text-align-start"] = "rbxassetid://134489585487649",
["text-cursor-input"] = "rbxassetid://107551944047171",
["text-cursor"] = "rbxassetid://115984654447300",
["text-initial"] = "rbxassetid://129458097472087",
["text-quote"] = "rbxassetid://139278366448736",
["text-search"] = "rbxassetid://92345384671606",
["text-select"] = "rbxassetid://117087320884956",
["text-wrap"] = "rbxassetid://114804318314018",
["theater"] = "rbxassetid://108558145549163",
["thermometer-snowflake"] = "rbxassetid://121876188028425",
["thermometer-sun"] = "rbxassetid://106693240074310",
["thermometer"] = "rbxassetid://106546011492311",
["thumbs-down"] = "rbxassetid://87794009914015",
["thumbs-up"] = "rbxassetid://111137070767020",
["ticket-check"] = "rbxassetid://105428777212507",
["ticket-minus"] = "rbxassetid://78966299769328",
["ticket-percent"] = "rbxassetid://80834774406405",
["ticket-plus"] = "rbxassetid://110086734392189",
["ticket-slash"] = "rbxassetid://89045681172265",
["ticket-x"] = "rbxassetid://88674114109926",
["ticket"] = "rbxassetid://126527071492145",
["tickets-plane"] = "rbxassetid://100367018248695",
["tickets"] = "rbxassetid://135268612687833",
["timer-off"] = "rbxassetid://110916370767271",
["timer-reset"] = "rbxassetid://110052125369932",
["timer"] = "rbxassetid://85473888890506",
["toggle-left"] = "rbxassetid://85887872573050",
["toggle-right"] = "rbxassetid://90411952142550",
["toilet"] = "rbxassetid://80930782432931",
["tool-case"] = "rbxassetid://87533537832522",
["tornado"] = "rbxassetid://88358291515768",
["torus"] = "rbxassetid://70855707283051",
["touchpad-off"] = "rbxassetid://78784008075456",
["touchpad"] = "rbxassetid://74882354908014",
["tower-control"] = "rbxassetid://95937619060532",
["toy-brick"] = "rbxassetid://86293483924633",
["tractor"] = "rbxassetid://103376704722051",
["traffic-cone"] = "rbxassetid://74110220470369",
["train-front-tunnel"] = "rbxassetid://105194827005114",
["train-front"] = "rbxassetid://125237934215370",
["train-track"] = "rbxassetid://77451032453723",
["tram-front"] = "rbxassetid://93315182364998",
["transgender"] = "rbxassetid://135530817673639",
["trash-2"] = "rbxassetid://109843431391323",
["trash"] = "rbxassetid://106723740584310",
["tree-deciduous"] = "rbxassetid://123124389219004",
["tree-palm"] = "rbxassetid://103846705893963",
["tree-pine"] = "rbxassetid://124662547202594",
["trees"] = "rbxassetid://121203841375919",
["trello"] = "rbxassetid://130987241149527",
["trending-down"] = "rbxassetid://139309232226438",
["trending-up-down"] = "rbxassetid://85083293981691",
["trending-up"] = "rbxassetid://81819858538839",
["triangle-alert"] = "rbxassetid://125920361880643",
["triangle-dashed"] = "rbxassetid://124324079103935",
["triangle-right"] = "rbxassetid://116930791412791",
["triangle"] = "rbxassetid://126330486745540",
["trophy"] = "rbxassetid://131545003268773",
["truck-electric"] = "rbxassetid://111873446387359",
["truck"] = "rbxassetid://86662707764771",
["turkish-lira"] = "rbxassetid://114589876174070",
["turntable"] = "rbxassetid://129870346487856",
["turtle"] = "rbxassetid://118295081560334",
["tv-minimal-play"] = "rbxassetid://99201833426972",
["tv-minimal"] = "rbxassetid://100382201729427",
["tv"] = "rbxassetid://135687724791776",
["twitch"] = "rbxassetid://71383308134888",
["twitter"] = "rbxassetid://88791703276842",
["type-outline"] = "rbxassetid://80108627791690",
["type"] = "rbxassetid://133543553793564",
["umbrella-off"] = "rbxassetid://72395143739955",
["umbrella"] = "rbxassetid://127502210274589",
["underline"] = "rbxassetid://123709229216544",
["undo-2"] = "rbxassetid://113885292059932",
["undo-dot"] = "rbxassetid://132055277744844",
["undo"] = "rbxassetid://111258459077271",
["unfold-horizontal"] = "rbxassetid://117128358526398",
["unfold-vertical"] = "rbxassetid://116593025265499",
["ungroup"] = "rbxassetid://106674800451003",
["university"] = "rbxassetid://84652528263642",
["unlink-2"] = "rbxassetid://128131898892572",
["unlink"] = "rbxassetid://139835795227752",
["unplug"] = "rbxassetid://90171381619874",
["upload"] = "rbxassetid://138212042425501",
["usb"] = "rbxassetid://117230058949613",
["user-check"] = "rbxassetid://81775205032725",
["user-cog"] = "rbxassetid://92795491530865",
["user-lock"] = "rbxassetid://78892639693821",
["user-minus"] = "rbxassetid://126976941957511",
["user-pen"] = "rbxassetid://87445472574836",
["user-plus"] = "rbxassetid://118514469915884",
["user-round-check"] = "rbxassetid://118794737621941",
["user-round-cog"] = "rbxassetid://78239503290053",
["user-round-minus"] = "rbxassetid://98944176636447",
["user-round-pen"] = "rbxassetid://108155244324878",
["user-round-plus"] = "rbxassetid://113301899567470",
["user-round-search"] = "rbxassetid://71565774381870",
["user-round-x"] = "rbxassetid://122367980560930",
["user-round"] = "rbxassetid://136485052187963",
["user-search"] = "rbxassetid://101335649828115",
["user-star"] = "rbxassetid://98777846316000",
["user-x"] = "rbxassetid://139748155894754",
["user"] = "rbxassetid://81589895647169",
["users-round"] = "rbxassetid://103005444008339",
["users"] = "rbxassetid://115398113982385",
["utensils-crossed"] = "rbxassetid://109520762270383",
["utensils"] = "rbxassetid://139952569804235",
["utility-pole"] = "rbxassetid://101965541238242",
["variable"] = "rbxassetid://104743088438151",
["vault"] = "rbxassetid://108049164599845",
["vector-square"] = "rbxassetid://86713728565344",
["vegan"] = "rbxassetid://119489190688082",
["venetian-mask"] = "rbxassetid://102636443033920",
["venus-and-mars"] = "rbxassetid://120227752103771",
["venus"] = "rbxassetid://82891342220859",
["vibrate-off"] = "rbxassetid://113446447326246",
["vibrate"] = "rbxassetid://108330910738733",
["video-off"] = "rbxassetid://132239189859305",
["video"] = "rbxassetid://107587444636945",
["videotape"] = "rbxassetid://114816894323398",
["view"] = "rbxassetid://118717253976805",
["voicemail"] = "rbxassetid://134313454010227",
["volleyball"] = "rbxassetid://83889351124153",
["volume-1"] = "rbxassetid://98514588731639",
["volume-2"] = "rbxassetid://89344380902620",
["volume-off"] = "rbxassetid://103047478058767",
["volume-x"] = "rbxassetid://139252359189540",
["volume"] = "rbxassetid://103236289817396",
["vote"] = "rbxassetid://89409762851246",
["wallet-cards"] = "rbxassetid://129728715308337",
["wallet-minimal"] = "rbxassetid://137800448816116",
["wallet"] = "rbxassetid://132331555762628",
["wallpaper"] = "rbxassetid://74682121235494",
["wand-sparkles"] = "rbxassetid://82546429942392",
["wand"] = "rbxassetid://114580617777835",
["warehouse"] = "rbxassetid://78388887451080",
["washing-machine"] = "rbxassetid://104194127573858",
["watch"] = "rbxassetid://130544621618405",
["waves-ladder"] = "rbxassetid://101808619355514",
["waves"] = "rbxassetid://96340135183647",
["waypoints"] = "rbxassetid://102450133666017",
["webcam"] = "rbxassetid://104148487911129",
["webhook-off"] = "rbxassetid://96370548093471",
["webhook"] = "rbxassetid://112812457747322",
["weight"] = "rbxassetid://103860559844854",
["wheat-off"] = "rbxassetid://133294844612307",
["wheat"] = "rbxassetid://85261952080359",
["whole-word"] = "rbxassetid://90111083954485",
["wifi-cog"] = "rbxassetid://110500263326209",
["wifi-high"] = "rbxassetid://81954601342139",
["wifi-low"] = "rbxassetid://138217335635913",
["wifi-off"] = "rbxassetid://74113634330106",
["wifi-pen"] = "rbxassetid://91290205064712",
["wifi-sync"] = "rbxassetid://84043971055177",
["wifi-zero"] = "rbxassetid://124286465246123",
["wifi"] = "rbxassetid://104669375183960",
["wind-arrow-down"] = "rbxassetid://127753987414870",
["wind"] = "rbxassetid://114551690399915",
["wine-off"] = "rbxassetid://108294164302317",
["wine"] = "rbxassetid://115743721332829",
["workflow"] = "rbxassetid://99186544029189",
["worm"] = "rbxassetid://115752311548091",
["wrench"] = "rbxassetid://112148279212860",
["x"] = "rbxassetid://110786993356448",
["youtube"] = "rbxassetid://123663668456341",
["zap-off"] = "rbxassetid://81385483183652",
["zap"] = "rbxassetid://130551565616516",
["zoom-in"] = "rbxassetid://127956924984803",
["zoom-out"] = "rbxassetid://108334162607319",
    ["search"] = "rbxassetid://121018724060431",
    ["home"] = "rbxassetid://98755624629571",
    ["settings"] = "rbxassetid://80758916183665",
    ["combat"] = "rbxassetid://124448418211665",
    ["visuals"] = "rbxassetid://100033680381365",
    ["list"] = "rbxassetid://113179976918783",
    ["info"] = "rbxassetid://124560466474914",
    ["check"] = "rbxassetid://93898873302694",
    ["chevron"] = "rbxassetid://134243273101015",
    ["resize_custom"] = "rbxassetid://122360365318466",
    ["folder"] = "rbxassetid://109080612832751",
    ["paint-bucket"] = "rbxassetid://124275586663284",
    ["save"] = "rbxassetid://126116963775616",
    ["trash"] = "rbxassetid://106723740584310"
}

local function RGBtoHex(color)
    local r, g, b = math.floor(color.R*255), math.floor(color.G*255), math.floor(color.B*255)
    return string.format("#%02X%02X%02X", r, g, b)
end
local function HexToRGB(hex)
    hex = hex:gsub("#","")
    local r = tonumber("0x"..hex:sub(1,2))
    local g = tonumber("0x"..hex:sub(3,4))
    local b = tonumber("0x"..hex:sub(5,6))
    if r and g and b then return Color3.fromRGB(r,g,b) end
    return nil
end

local function Tween(obj, props, time)
    TweenService:Create(obj, TweenInfo.new(time or 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), props):Play()
end

local FloatLocked = false

local function MakeDraggable(object, dragObject)
    local dragging, dragInput, dragStart, startPos
    local function Update(input)
        local delta = input.Position - dragStart
        Tween(object, {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}, 0.05)
    end
    dragObject.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not FloatLocked then
            dragging = true dragStart = input.Position startPos = object.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    dragObject.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    RunService.RenderStepped:Connect(function() if dragging and dragInput then Update(dragInput) end end)
end

local function MakeResizable(frame, handle)
    local resizing, startSize, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            resizing = true startSize = frame.AbsoluteSize startPos = input.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then resizing = false end end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startPos
            frame.Size = UDim2.new(0, math.max(500, startSize.X + delta.X), 0, math.max(350, startSize.Y + delta.Y))
        end
    end)
end

local Library = {Flags = {}, Elements = {}, Icons = Icons}
local ScreenGui, NotifyList

function Library:Notification(title, text, duration)
    if not NotifyList then return end
    local F = RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Element") F.Size=UDim2.new(1,0,0,60) F.Parent=NotifyList
    Instance.new("UICorner", F).CornerRadius=UDim.new(0,6)
    local B = RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Text") B.Size=UDim2.new(0,4,1,-16) B.Position=UDim2.new(0,6,0,8) F.ClipsDescendants=true B.Parent=F
    Instance.new("UICorner", B).CornerRadius=UDim.new(0,2)
    local G = RegisterGradient(Instance.new("UIGradient"), "Accent1", "Accent2") G.Rotation=90 G.Parent=B
    local T = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "Text") T.Text=title T.Size=UDim2.new(1,-20,0,20) T.Position=UDim2.new(0,18,0,8) T.BackgroundTransparency=1 T.FontFace=FontBold T.TextSize=15 T.TextXAlignment=Enum.TextXAlignment.Left T.Parent=F
    local D = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim") D.Text=text D.Size=UDim2.new(1,-20,0,20) D.Position=UDim2.new(0,18,0,28) D.BackgroundTransparency=1 D.FontFace=FontMain D.TextSize=13 D.TextXAlignment=Enum.TextXAlignment.Left D.TextWrapped=true D.Parent=F
    Tween(F,{Position=UDim2.new(0,0,0,0)}) task.delay(duration or 3, function() Tween(F,{Position=UDim2.new(1.2,0,0,0)}) task.wait(0.4) F:Destroy() end)
end

function Library:GetConfigs()
    local files = listfiles(ConfigFolder)
    local names = {}
    for _, file in ipairs(files) do
        local name = file:gsub(ConfigFolder .. "\\", ""):gsub(ConfigFolder .. "/", ""):gsub(".json", "")
        table.insert(names, name)
    end
    return names
end

function Library:SaveConfig(name)
    if not name or name == "" then Library:Notification("Config", "Invalid Config Name", 3) return end
    local data = {}
    for flag, value in pairs(Library.Flags) do
        if typeof(value) == "Color3" then
            data[flag] = {Type = "Color3", R = value.R, G = value.G, B = value.B}
        elseif typeof(value) == "EnumItem" then
            data[flag] = {Type = "Enum", Name = tostring(value)}
        elseif type(value) == "table" and value.Color and value.Transparency then
            data[flag] = {Type = "CP", R = value.Color.R, G = value.Color.G, B = value.Color.B, A = value.Transparency}
        else
            data[flag] = value
        end
    end
    writefile(ConfigFolder .. "/" .. name .. ".json", HttpService:JSONEncode(data))
    Library:Notification("Config", "Saved config: " .. name, 3)
end

function Library:LoadConfig(name)
    if not name or name == "" or not isfile(ConfigFolder .. "/" .. name .. ".json") then Library:Notification("Config", "Config not found", 3) return end
    local content = readfile(ConfigFolder .. "/" .. name .. ".json")
    local success, data = pcall(HttpService.JSONDecode, HttpService, content)
    if not success then Library:Notification("Config", "Decode Error", 3) return end
    
    for flag, value in pairs(data) do
        if Library.Elements[flag] then
            if type(value) == "table" and value.Type == "Color3" then
                Library.Elements[flag].Set(Color3.new(value.R, value.G, value.B))
            elseif type(value) == "table" and value.Type == "CP" then
                Library.Elements[flag].Set({Color = Color3.new(value.R, value.G, value.B), Transparency = value.A})
            else
                Library.Elements[flag].Set(value)
            end
        end
    end
    Library:Notification("Config", "Loaded config: " .. name, 3)
end

function Library:DeleteConfig(name)
    if not name or name == "" or not isfile(ConfigFolder .. "/" .. name .. ".json") then return end
    delfile(ConfigFolder .. "/" .. name .. ".json")
    Library:Notification("Config", "Deleted config: " .. name, 3)
end

function Library:Window(title, iconId, footerText, useTooltips)
    if CoreGui:FindFirstChild("EternalV36") then CoreGui.EternalV36:Destroy() end
    ScreenGui = Instance.new("ScreenGui") ScreenGui.Name="EternalV36"
    ScreenGui.Parent = gethui and gethui() or CoreGui

    local UIMainKeybind = Enum.KeyCode.RightControl

    NotifyList = Instance.new("Frame") NotifyList.Size=UDim2.new(0,250,1,-40) NotifyList.Position=UDim2.new(1,-260,0,20) NotifyList.BackgroundTransparency=1 NotifyList.Parent=ScreenGui
    local NIL = Instance.new("UIListLayout") NIL.Padding=UDim.new(0,10) NIL.VerticalAlignment=Enum.VerticalAlignment.Bottom NIL.HorizontalAlignment=Enum.HorizontalAlignment.Right NIL.Parent=NotifyList
    
    local Main = RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Background") Main.Size=UDim2.new(0,600,0,450) Main.AnchorPoint=Vector2.new(0.5,0.5) Main.Position=UDim2.new(0.5,0,0.5,0) Main.Parent=ScreenGui
    local UIScale = Instance.new("UIScale") UIScale.Scale=0 UIScale.Parent=Main Tween(UIScale,{Scale=1},0.4)
    Instance.new("UICorner", Main).CornerRadius=UDim.new(0,8)
    
    local MainStroke = Instance.new("UIStroke") MainStroke.Thickness = 2.5 MainStroke.Transparency = 0 MainStroke.Parent = Main
    local StrokeGrad = RegisterGradient(Instance.new("UIGradient"), "Accent1", "Accent2") StrokeGrad.Rotation = 45 StrokeGrad.Parent = MainStroke

    local BgGradient = Instance.new("UIGradient") BgGradient.Rotation = 60
    BgGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1,1,1)), ColorSequenceKeypoint.new(1, Color3.new(0.6,0.6,0.6))} BgGradient.Parent = Main

    MakeDraggable(Main, Main)
    
    local ResizeHandle = Instance.new("ImageButton") ResizeHandle.Size = UDim2.new(0, 20, 0, 20) ResizeHandle.Position = UDim2.new(1, -2, 1, -2) ResizeHandle.AnchorPoint = Vector2.new(1, 1) ResizeHandle.BackgroundTransparency = 1 ResizeHandle.Image = Icons["resize_custom"] or "rbxassetid://122360365318466"
    RegisterTheme(ResizeHandle, "ImageColor3", "TextDim") ResizeHandle.Parent = Main
    MakeResizable(Main, ResizeHandle)

    local VersionLabel = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim")
    VersionLabel.Name = "FooterInfo"
    VersionLabel.Text = footerText or "Eternal V36" 
    VersionLabel.Size = UDim2.new(1, 0, 0, 20)
    VersionLabel.AnchorPoint = Vector2.new(0.5, 1) 
    VersionLabel.Position = UDim2.new(0.5, 0, 1, -2) 
    VersionLabel.BackgroundTransparency = 1
    VersionLabel.FontFace = FontMain
    VersionLabel.TextSize = 12
    VersionLabel.ZIndex = 10 
    VersionLabel.Parent = Main

    -- // TOOLTIP SYSTEM
    local TabTooltip = Instance.new("Frame")
    local TooltipText = Instance.new("TextLabel")
    
    if useTooltips then
        TabTooltip.Name = "TabTooltip"
        TabTooltip.Size = UDim2.new(0, 0, 0, 24)
        TabTooltip.AutomaticSize = Enum.AutomaticSize.X
        TabTooltip.BackgroundColor3 = Theme.Background
        TabTooltip.BorderColor3 = Theme.Accent1
        TabTooltip.BorderSizePixel = 1
        TabTooltip.ZIndex = 100
        TabTooltip.Visible = false
        TabTooltip.Parent = ScreenGui 

        TooltipText.Size = UDim2.new(0, 0, 1, 0)
        TooltipText.AutomaticSize = Enum.AutomaticSize.X
        TooltipText.BackgroundTransparency = 1
        TooltipText.TextColor3 = Theme.Text
        TooltipText.FontFace = FontMain
        TooltipText.TextSize = 12
        TooltipText.Text = ""
        TooltipText.Parent = TabTooltip
        local TPad = Instance.new("UIPadding") TPad.PaddingLeft=UDim.new(0,5) TPad.PaddingRight=UDim.new(0,5) TPad.Parent=TabTooltip
        
        RunService.RenderStepped:Connect(function()
            if TabTooltip.Visible then
                local Mouse = UserInputService:GetMouseLocation()
                TabTooltip.Position = UDim2.new(0, Mouse.X + 15, 0, Mouse.Y + 5)
            end
        end)
    end

    -- // SIDEBAR
    local SidebarWidth = 110
    local Sidebar = RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Sidebar") Sidebar.Size=UDim2.new(0,SidebarWidth,1,0) Sidebar.Parent=Main
    Instance.new("UICorner", Sidebar).CornerRadius=UDim.new(0,8)
    
    local SidebarLine = RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Element") SidebarLine.Size = UDim2.new(0, 1, 1, 0) SidebarLine.Position = UDim2.new(1, 0, 0, 0) SidebarLine.BorderSizePixel = 0 SidebarLine.Parent = Sidebar
    
    local Logo = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "Text") Logo.Text = "E" Logo.Size = UDim2.new(1, 0, 0, 60) Logo.BackgroundTransparency = 1 Logo.FontFace = FontBold Logo.TextSize = 32 Logo.Parent = Sidebar

    if iconId and iconId ~= "" then
        Logo.TextTransparency = 1 
        local LogoIcon = Instance.new("ImageLabel") LogoIcon.Size = UDim2.new(0, 40, 0, 40) LogoIcon.Position = UDim2.new(0.5, -20, 0, 10) LogoIcon.BackgroundTransparency = 1
        local iconImage = Icons[iconId] or iconId LogoIcon.Image = iconImage LogoIcon.Parent = Sidebar
        RegisterGradient(Instance.new("UIGradient"), "Accent1", "Accent2").Parent = LogoIcon
    else
        RegisterGradient(Instance.new("UIGradient"), "Accent1", "Accent2").Parent = Logo
    end
    
    local TabScroll = Instance.new("ScrollingFrame") TabScroll.Size = UDim2.new(1, 0, 1, -100) TabScroll.Position = UDim2.new(0, 0, 0, 80) TabScroll.BackgroundTransparency = 1 
    TabScroll.ScrollBarThickness = 0 TabScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y TabScroll.CanvasSize = UDim2.new(0, 0, 0, 0) TabScroll.Parent = Sidebar
    local TL = Instance.new("UIListLayout") TL.HorizontalAlignment = Enum.HorizontalAlignment.Center TL.Padding = UDim.new(0, 5) TL.SortOrder = Enum.SortOrder.LayoutOrder TL.Parent = TabScroll
    
    -- // Content Area
    local Content = Instance.new("Frame") Content.Size=UDim2.new(1,-SidebarWidth,1,0) Content.Position=UDim2.new(0,SidebarWidth,0,0) Content.BackgroundTransparency=1 Content.ClipsDescendants=true Content.Parent=Main
    
    local MenuTitle = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "Text") MenuTitle.Text = title or "Eternal Menu" MenuTitle.Size = UDim2.new(1, -40, 0, 50) MenuTitle.Position = UDim2.new(0, 25, 0, 0) MenuTitle.BackgroundTransparency = 1 MenuTitle.FontFace = FontBold MenuTitle.TextSize = 22 MenuTitle.TextXAlignment = Enum.TextXAlignment.Left MenuTitle.ZIndex = 5 MenuTitle.Parent = Content
    RegisterGradient(Instance.new("UIGradient"), "Accent1", "Accent2").Parent = MenuTitle

    -- // Logic to Toggle UI
    UserInputService.InputBegan:Connect(function(input, gpe)
        if not gpe and input.KeyCode == UIMainKeybind then
            Main.Visible = not Main.Visible
            if Main.Visible then Tween(UIScale, {Scale = 1}) else Tween(UIScale, {Scale = 0}) end
        end
    end)

    -- // FLOAT FRAME (Small Bottom-Left Panel)
    local FloatFrame = RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Sidebar") FloatFrame.Size = UDim2.new(0, 110, 0, 45) FloatFrame.Position = UDim2.new(0, 20, 1, -80) FloatFrame.Parent = ScreenGui
    Instance.new("UICorner", FloatFrame).CornerRadius = UDim.new(0, 8)
    local FloatStroke = Instance.new("UIStroke") FloatStroke.Thickness = 2 FloatStroke.Parent = FloatFrame RegisterGradient(Instance.new("UIGradient"), "Accent1", "Accent2").Parent = FloatStroke
    local DragHandle = Instance.new("TextButton") DragHandle.Size = UDim2.new(1,0,1,0) DragHandle.BackgroundTransparency = 1 DragHandle.Text = "" DragHandle.ZIndex = 1 DragHandle.Parent = FloatFrame
    local OpenBtn = RegisterTheme(Instance.new("TextButton"), "BackgroundColor3", "Element") OpenBtn.Size = UDim2.new(0, 65, 1, -10) OpenBtn.Position = UDim2.new(0, 5, 0, 5) OpenBtn.Text = "Close" RegisterTheme(OpenBtn, "TextColor3", "Text") OpenBtn.FontFace = FontBold OpenBtn.TextSize = 13 OpenBtn.ZIndex = 2 OpenBtn.Parent = FloatFrame
    Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6) RegisterGradient(Instance.new("UIGradient"), "Accent1", "Accent2").Parent = OpenBtn
    local LockBtn = RegisterTheme(Instance.new("TextButton"), "BackgroundColor3", "Background") LockBtn.Size = UDim2.new(0, 30, 1, -10) LockBtn.Position = UDim2.new(1, -35, 0, 5) LockBtn.Text = "🔓" RegisterTheme(LockBtn, "TextColor3", "TextDim") LockBtn.FontFace = FontMain LockBtn.TextSize = 14 LockBtn.ZIndex = 2 LockBtn.Parent = FloatFrame
    Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 6)
    
    MakeDraggable(FloatFrame, DragHandle)
    local menuOpen = true
    OpenBtn.MouseButton1Click:Connect(function() menuOpen = not menuOpen if menuOpen then Main.Visible = true Tween(UIScale, {Scale = 1}) OpenBtn.Text = "Close" else Tween(UIScale, {Scale = 0}) task.wait(0.2) Main.Visible = false OpenBtn.Text = "Open" end end)
    LockBtn.MouseButton1Click:Connect(function() FloatLocked = not FloatLocked LockBtn.Text = FloatLocked and "🔒" or "🔓" Tween(LockBtn, {BackgroundColor3 = FloatLocked and Theme.Accent1 or Theme.Background}) end)

    local SidebarSortIndex = 0
    local FirstTab = true
    local WinObj = {}

    function WinObj:TabSection(text)
        SidebarSortIndex = SidebarSortIndex + 1
        local SecLabel = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim")
        SecLabel.Text = text
        SecLabel.Size = UDim2.new(1, -20, 0, 20)
        SecLabel.BackgroundTransparency = 1
        SecLabel.FontFace = FontBold
        SecLabel.TextSize = 11
        SecLabel.TextXAlignment = Enum.TextXAlignment.Left
        SecLabel.TextTransparency = 0.4
        SecLabel.LayoutOrder = SidebarSortIndex
        SecLabel.Parent = TabScroll
        local Pad = Instance.new("UIPadding") Pad.PaddingLeft = UDim.new(0, 5) Pad.Parent = SecLabel
    end
    
    function WinObj:Tab(name, icon, description)
        SidebarSortIndex = SidebarSortIndex + 1
        local TabBtn = Instance.new("TextButton") TabBtn.Size=UDim2.new(1, -10, 0, 35) TabBtn.BackgroundTransparency=1 TabBtn.Text="" TabBtn.LayoutOrder = SidebarSortIndex TabBtn.Parent=TabScroll
        
        -- // ЛОГИКА ОТОБРАЖЕНИЯ (ИКОНКА ИЛИ ТЕКСТ+ИКОНКА) //
        local hasText = (name and name ~= "")
        
        local TabIcon = RegisterTheme(Instance.new("ImageLabel"), "ImageColor3", "TextDim") 
        TabIcon.Size=UDim2.new(0,18,0,18) 
        TabIcon.BackgroundTransparency=1 
        TabIcon.Parent=TabBtn
        
        local RealIconId = Library.Icons[icon] or icon
        local CleanId = tostring(RealIconId):gsub("rbxassetid://", "") 
        TabIcon.Image = "rbxassetid://" .. CleanId
        
        local TabLabel = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim") 
        TabLabel.Text = name or "" 
        TabLabel.Size = UDim2.new(1, -35, 1, 0) 
        TabLabel.Position = UDim2.new(0, 32, 0, 0) 
        TabLabel.BackgroundTransparency = 1 
        TabLabel.FontFace = FontMain 
        TabLabel.TextSize = 13 
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left 
        TabLabel.Parent = TabBtn

        if hasText then
            -- Стандартный режим: Иконка слева, текст справа
            TabIcon.Position = UDim2.new(0, 8, 0.5, -9)
            TabLabel.Visible = true
        else
            -- Режим "Только иконка": Иконка по центру
            TabIcon.Position = UDim2.new(0.5, -9, 0.5, -9)
            TabLabel.Visible = false
        end
        -- // КОНЕЦ ЛОГИКИ //

        if useTooltips and description then
            TabBtn.MouseEnter:Connect(function() TooltipText.Text = description TabTooltip.Visible = true end)
            TabBtn.MouseLeave:Connect(function() TabTooltip.Visible = false end)
        end

        local TabFrame = Instance.new("Frame") TabFrame.Size = UDim2.new(1, 0, 1, -70) TabFrame.Position = UDim2.new(0, 0, 0, 50) TabFrame.BackgroundTransparency = 1 TabFrame.Visible = false TabFrame.Parent = Content
        local TopBar = Instance.new("Frame") TopBar.Size=UDim2.new(1,0,0,50) TopBar.BackgroundTransparency=1 TopBar.Parent=TabFrame
        local BtnHold = Instance.new("ScrollingFrame") BtnHold.Size = UDim2.new(1, 0, 1, 0) BtnHold.BackgroundTransparency = 1 BtnHold.Parent = TopBar BtnHold.ScrollBarThickness = 0 BtnHold.ScrollingDirection = Enum.ScrollingDirection.X BtnHold.AutomaticCanvasSize = Enum.AutomaticSize.X BtnHold.CanvasSize = UDim2.new(0, 0, 0, 0) BtnHold.ClipsDescendants = true
        local THL = Instance.new("UIListLayout") THL.FillDirection = Enum.FillDirection.Horizontal THL.HorizontalAlignment = Enum.HorizontalAlignment.Left THL.VerticalAlignment = Enum.VerticalAlignment.Center THL.Padding = UDim.new(0, 10) THL.Parent = BtnHold
        local TPad = Instance.new("UIPadding") TPad.PaddingLeft = UDim.new(0, 10) TPad.PaddingRight = UDim.new(0, 10) TPad.Parent = BtnHold
        local ActiveLine = Instance.new("Frame") ActiveLine.Size=UDim2.new(0,0,0,3) ActiveLine.BackgroundColor3=Color3.new(1,1,1) ActiveLine.BorderSizePixel=0 ActiveLine.Parent=TopBar
        RegisterGradient(Instance.new("UIGradient"), "Accent1", "Accent2").Parent = ActiveLine
        local PagesCont = Instance.new("Frame") PagesCont.Size=UDim2.new(1,-40,1,-60) PagesCont.Position=UDim2.new(0,20,0,55) PagesCont.BackgroundTransparency=1 PagesCont.ClipsDescendants=true PagesCont.Parent=TabFrame

        TabBtn.MouseButton1Click:Connect(function()
            for _,t in pairs(Content:GetChildren()) do if t:IsA("Frame") and t ~= MenuTitle then t.Visible=false end end
            for _,b in pairs(TabScroll:GetChildren()) do if b:IsA("TextButton") then Tween(b.ImageLabel,{ImageColor3=Theme.TextDim}) Tween(b.TextLabel,{TextColor3=Theme.TextDim}) end end
            TabFrame.Visible=true Tween(TabIcon,{ImageColor3=Theme.Accent2}) Tween(TabLabel,{TextColor3=Theme.Accent2})
        end)

        if FirstTab then FirstTab=false TabFrame.Visible=true TabIcon.ImageColor3=Theme.Accent2 TabLabel.TextColor3=Theme.Accent2 end

        local TabObj = {}
        local FirstPage = true
        function TabObj:Page(name, pageIcon)
            local PBtn = Instance.new("TextButton") PBtn.Text="" PBtn.AutomaticSize=Enum.AutomaticSize.X PBtn.Size=UDim2.new(0,0,1,0) PBtn.BackgroundTransparency=1 PBtn.Parent=BtnHold
            local PBLayout = Instance.new("UIListLayout") PBLayout.FillDirection=Enum.FillDirection.Horizontal PBLayout.VerticalAlignment=Enum.VerticalAlignment.Center PBLayout.Padding=UDim.new(0,5) PBLayout.Parent=PBtn
            local Pad = Instance.new("UIPadding") Pad.PaddingLeft=UDim.new(0,10) Pad.PaddingRight=UDim.new(0,10) Pad.Parent=PBtn
            if pageIcon and Icons[pageIcon] then local PIco = RegisterTheme(Instance.new("ImageLabel"), "ImageColor3", "TextDim") PIco.Size=UDim2.new(0,18,0,18) PIco.BackgroundTransparency=1 PIco.Image=Icons[pageIcon] PIco.Parent=PBtn end
            local PTxt = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim") PTxt.Text=name PTxt.FontFace=FontMain PTxt.TextSize=16 PTxt.AutomaticSize=Enum.AutomaticSize.XY PTxt.BackgroundTransparency=1 PTxt.Parent=PBtn

            local PCont = Instance.new("Frame") PCont.Size=UDim2.new(1,0,1,0) PCont.BackgroundTransparency=1 PCont.Visible=false PCont.Parent=PagesCont
            local Left = Instance.new("ScrollingFrame") Left.Size=UDim2.new(0.49,0,1,0) Left.BackgroundTransparency=1 Left.ScrollBarThickness=0 Left.AutomaticCanvasSize = Enum.AutomaticSize.Y Left.CanvasSize=UDim2.new(0,0,0,0) Left.Parent=PCont
            local Right = Instance.new("ScrollingFrame") Right.Size=UDim2.new(0.49,0,1,0) Right.Position=UDim2.new(0.51,0,0,0) Right.BackgroundTransparency=1 Right.ScrollBarThickness=0 Right.AutomaticCanvasSize = Enum.AutomaticSize.Y Right.CanvasSize=UDim2.new(0,0,0,0) Right.Parent=PCont
            Instance.new("UIListLayout", Left).Padding=UDim.new(0,10) Instance.new("UIListLayout", Right).Padding=UDim.new(0,10)

            local function Line(inst) if PBtn.Parent then local w = PBtn.AbsoluteSize.X local p = PBtn.AbsolutePosition.X - TopBar.AbsolutePosition.X if p < 0 or p + w > TopBar.AbsoluteSize.X then Tween(ActiveLine, {BackgroundTransparency = 1}, 0.1) else Tween(ActiveLine, {BackgroundTransparency = 0}, 0.1) end if inst then ActiveLine.Size=UDim2.new(0,w,0,3) ActiveLine.Position=UDim2.new(0,p,0,0) else Tween(ActiveLine,{Size=UDim2.new(0,w,0,3),Position=UDim2.new(0,p,0,0)}) end end end
            BtnHold:GetPropertyChangedSignal("CanvasPosition"):Connect(function() if PCont.Visible then Line(true) end end)
            PBtn.MouseButton1Click:Connect(function() for _,p in pairs(PagesCont:GetChildren()) do p.Visible=false end for _,b in pairs(BtnHold:GetChildren()) do if b:IsA("TextButton") then for _, c in pairs(b:GetChildren()) do if c:IsA("TextLabel") then Tween(c, {TextColor3 = Theme.TextDim}) end if c:IsA("ImageLabel") then Tween(c, {ImageColor3 = Theme.TextDim}) end end end end PCont.Visible=true for _, c in pairs(PBtn:GetChildren()) do if c:IsA("TextLabel") then Tween(c, {TextColor3 = Theme.Text}) end if c:IsA("ImageLabel") then Tween(c, {ImageColor3 = Theme.Text}) end end Line(false) end)
            if FirstPage then FirstPage=false PCont.Visible=true for _, c in pairs(PBtn:GetChildren()) do if c:IsA("TextLabel") then c.TextColor3 = Theme.Text end if c:IsA("ImageLabel") then c.ImageColor3 = Theme.Text end end task.spawn(function() task.wait(0.1) Line(true) end) end
            local function col(s) return s=="Right" and Right or Left end

            -- // Helper: Add Info Icon
            local function AddInfoIcon(parent, text)
                local I = RegisterTheme(Instance.new("ImageButton"), "ImageColor3", "TextDim") 
                I.Name = "InfoIcon" 
                I.Size = UDim2.new(0, 14, 0, 14) 
                I.AnchorPoint = Vector2.new(0, 0) 
                I.Position = UDim2.new(0, 5, 0, 2) 
                I.BackgroundTransparency = 1 
                I.Image = Icons["info"] or "rbxassetid://124560466474914" 
                I.ZIndex = 20 
                I.Parent = parent
                I.MouseEnter:Connect(function() Tween(I, {ImageColor3 = Theme.Accent2}) end) 
                I.MouseLeave:Connect(function() Tween(I, {ImageColor3 = Theme.TextDim}) end)
                I.MouseButton1Click:Connect(function() Library:Notification("Info", text, 4) end)
            end

            local function CreateBase(parent, title, desc, baseH)
                local hasDesc = (desc and desc ~= "")
                local h = baseH 
                
                local F = RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Element") F.Size=UDim2.new(1,0,0,h) F.Parent=parent Instance.new("UICorner",F).CornerRadius=UDim.new(0,6)
                
                local titleOffset = hasDesc and 25 or 10
                local L = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "Text") 
                L.Text=title 
                L.Size=UDim2.new(1,-titleOffset-10,0,20) 
                L.Position=UDim2.new(0,titleOffset,0, (baseH > 40) and 2 or 8) 
                L.BackgroundTransparency=1 
                L.FontFace=FontMain 
                L.TextSize=14 
                L.TextXAlignment=Enum.TextXAlignment.Left 
                L.Parent=F
                
                if hasDesc then
                    AddInfoIcon(F, desc)
                end
                
                return F
            end

            local Generators = {}
            
            function Generators.Label(parent, t)
                local LC=Instance.new("Frame") LC.Size=UDim2.new(1,0,0,25) LC.BackgroundTransparency=1 LC.Parent=parent
                local LT=RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim") LT.Text=t LT.Size=UDim2.new(1,-10,1,0) LT.Position=UDim2.new(0,5,0,0) LT.BackgroundTransparency=1 LT.FontFace=FontBold LT.TextSize=13 LT.TextXAlignment=Enum.TextXAlignment.Left LT.TextYAlignment=Enum.TextYAlignment.Bottom LT.Parent=LC
            end

            function Generators.Button(parent, t, desc, cb)
                 local B = CreateBase(parent, t, desc, 35) 
                 local Btn = Instance.new("TextButton") Btn.Size=UDim2.new(1,0,1,0) Btn.BackgroundTransparency=1 Btn.Text="" Btn.Parent=B
                 Btn.MouseButton1Click:Connect(function() pcall(cb) Tween(B, {BackgroundColor3=Theme.Sidebar}, 0.1) task.wait(0.1) Tween(B, {BackgroundColor3=Theme.Element}, 0.1) end)
            end

            function Generators.Keybind(parent, t, f, def, cb, desc)
                Library.Flags[f] = def or Enum.KeyCode.E
                local B = CreateBase(parent, t, desc, 35)
                local BindBtn = RegisterTheme(Instance.new("TextButton"), "BackgroundColor3", "Background") 
                BindBtn.Size=UDim2.new(0,80,0,20) BindBtn.Position=UDim2.new(1,-90,0,8) BindBtn.Text="" 
                BindBtn.Parent=B Instance.new("UICorner",BindBtn).CornerRadius=UDim.new(0,4)
                
                local BindTxt = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim") 
                BindTxt.Text = tostring(def or "None"):gsub("Enum.KeyCode.","") 
                BindTxt.Size=UDim2.new(1,0,1,0) BindTxt.BackgroundTransparency=1 BindTxt.FontFace=FontMain BindTxt.TextSize=12 BindTxt.Parent=BindBtn
                
                local binding = false
                BindBtn.MouseButton1Click:Connect(function()
                    if binding then return end binding = true BindTxt.Text = "..."
                    local connection; connection = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard or input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
                            local key = (input.UserInputType == Enum.UserInputType.Keyboard) and input.KeyCode or input.UserInputType
                            if key.Name == "Unknown" then return end
                            if key == Enum.KeyCode.Escape then Library.Flags[f] = nil BindTxt.Text = "None" else Library.Flags[f] = key BindTxt.Text = key.Name end
                            binding = false connection:Disconnect() pcall(cb, Library.Flags[f])
                        end
                    end)
                end)
                Library.Elements[f] = { Set = function(v) Library.Flags[f]=v BindTxt.Text=v and v.Name or "None" end }
            end

            function Generators.Checkbox(parent, t, f, d, desc, cb)
                local st=false Library.Flags[f]=st
                local B = CreateBase(parent, t, desc, 35)
                local BoxOut=RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Background") BoxOut.Size=UDim2.new(0,20,0,20) BoxOut.Position=UDim2.new(1,-30,0,8) BoxOut.Parent=B Instance.new("UICorner",BoxOut).CornerRadius=UDim.new(0,4)
                local CheckImg=RegisterTheme(Instance.new("ImageLabel"), "ImageColor3", "Text") CheckImg.Size=UDim2.new(0,14,0,14) CheckImg.Position=UDim2.new(0.5,-7,0.5,-7) CheckImg.BackgroundTransparency=1 CheckImg.Image=Icons["check"] CheckImg.ImageTransparency=1 CheckImg.Parent=BoxOut
                local Click = Instance.new("TextButton") Click.Size=UDim2.new(1,0,1,0) Click.BackgroundTransparency=1 Click.Text="" Click.Parent=B
                local function Set(b) st=b Library.Flags[f]=st Tween(CheckImg,{ImageTransparency=st and 0 or 1}) Tween(BoxOut,{BackgroundColor3=st and Theme.Accent1 or Theme.Background}) pcall(cb, st) end 
                Click.MouseButton1Click:Connect(function() Set(not st) end) 
                if d then Set(true) end
                Library.Elements[f]={Set=Set}
            end

            function Generators.Toggle(parent, t, f, d, desc, cb)
                local st=false Library.Flags[f]=st
                local B = CreateBase(parent, t, desc, 35)
                local SwitchBg=RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Background") SwitchBg.Size=UDim2.new(0,32,0,18) SwitchBg.Position=UDim2.new(1,-42,0,9) SwitchBg.Parent=B Instance.new("UICorner",SwitchBg).CornerRadius=UDim.new(1,0)
                local Circle=RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "TextDim") Circle.Size=UDim2.new(0,14,0,14) Circle.Position=UDim2.new(0,2,0.5,-7) Circle.Parent=SwitchBg Instance.new("UICorner",Circle).CornerRadius=UDim.new(1,0)
                local Click = Instance.new("TextButton") Click.Size=UDim2.new(1,0,1,0) Click.BackgroundTransparency=1 Click.Text="" Click.Parent=B
                local function Set(b) st=b Library.Flags[f]=st Tween(Circle,{Position=UDim2.new(st and 1 or 0, st and -16 or 2, 0.5, -7), BackgroundColor3=st and Theme.Text or Theme.TextDim}) Tween(SwitchBg,{BackgroundColor3=st and Theme.Accent1 or Theme.Background}) pcall(cb, st) end 
                Click.MouseButton1Click:Connect(function() Set(not st) end) 
                if d then Set(true) end
                Library.Elements[f]={Set=Set}
            end

            function Generators.Slider(parent, t, f, min, max, def, cb, desc)
                local v=def or min Library.Flags[f]=v
                local F = CreateBase(parent, t, desc, 50)
                local V=RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim") V.Text=tostring(v) V.Size=UDim2.new(0.3,-10,0,20) V.Position=UDim2.new(1,-10,0,5) V.AnchorPoint=Vector2.new(1,0) V.BackgroundTransparency=1 V.TextXAlignment=Enum.TextXAlignment.Right V.Parent=F
                local B=RegisterTheme(Instance.new("TextButton"), "BackgroundColor3", "Sidebar") B.Size=UDim2.new(1,-20,0,6) B.Position=UDim2.new(0,10,1,-15) B.Text="" B.Parent=F Instance.new("UICorner",B).CornerRadius=UDim.new(1,0)
                local Fill=Instance.new("Frame") Fill.Size=UDim2.new((v-min)/(max-min),0,1,0) Fill.BackgroundColor3=Color3.new(1,1,1) Fill.Parent=B Instance.new("UICorner",Fill).CornerRadius=UDim.new(1,0)
                local FG=Instance.new("UIGradient") RegisterGradient(FG, "Accent1", "Accent2") FG.Parent=Fill
                local function Set(n) v=math.clamp(n,min,max) Library.Flags[f]=v V.Text=tostring(v) Tween(Fill,{Size=UDim2.new((v-min)/(max-min),0,1,0)},0.05) pcall(cb,v) end
                local d=false B.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=true local m=i.Position.X local p=math.clamp((m-B.AbsolutePosition.X)/B.AbsoluteSize.X,0,1) Set(math.floor(min+(max-min)*p)) end end)
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then d=false end end)
                UserInputService.InputChanged:Connect(function(i) if d and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then local m=i.Position.X local p=math.clamp((m-B.AbsolutePosition.X)/B.AbsoluteSize.X,0,1) Set(math.floor(min+(max-min)*p)) end end)
                Set(def) Library.Elements[f]={Set=Set}
            end

            function Generators.TextBox(parent, t, f, def, cb, desc)
                 Library.Flags[f]=def or ""
                 local C = CreateBase(parent, t, desc, 45)
                 local B=RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Background") B.Size=UDim2.new(0.4,0,0,26) B.Position=UDim2.new(1,-10,0,5) B.AnchorPoint=Vector2.new(1,0) B.Parent=C Instance.new("UICorner",B).CornerRadius=UDim.new(0,4)
                 local In=RegisterTheme(Instance.new("TextBox"), "TextColor3", "Text") In.Size=UDim2.new(1,-10,1,0) In.Position=UDim2.new(0,5,0,0) In.BackgroundTransparency=1 In.Text=def or "" In.PlaceholderText="..." In.TextXAlignment=Enum.TextXAlignment.Left In.Parent=B
                 In.FocusLost:Connect(function() Library.Flags[f]=In.Text pcall(cb,In.Text) end)
                 Library.Elements[f]={Set=function(v) In.Text=v Library.Flags[f]=v end}
            end

            function Generators.Dropdown(parent, t,f,items,cb,desc)
                local sel=items[1] or "None" Library.Flags[f]=sel local exp=false
                local Con = CreateBase(parent, t, desc, 40) Con.ClipsDescendants=true
                local B=Instance.new("TextButton") B.Size=UDim2.new(1,0,0,40) B.BackgroundTransparency=1 B.Text="" B.Parent=Con
                local S=RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim") S.Text=sel S.Size=UDim2.new(0.5,-40,0,20) S.Position=UDim2.new(1,-30,0,10) S.AnchorPoint=Vector2.new(1,0) S.BackgroundTransparency=1 S.FontFace=FontMain S.TextSize=14 S.TextXAlignment=Enum.TextXAlignment.Right S.Parent=B
                local I=RegisterTheme(Instance.new("ImageLabel"), "ImageColor3", "TextDim") I.Size=UDim2.new(0,16,0,16) I.Position=UDim2.new(1,-26,0,12) I.BackgroundTransparency=1 I.Image=Icons["chevron"] I.Parent=B
                local List=Instance.new("ScrollingFrame") List.Size=UDim2.new(1,-10,1,-45) List.Position=UDim2.new(0,5,0,45) List.BackgroundTransparency=1 List.BorderSizePixel=0 List.ScrollBarThickness=2 List.AutomaticCanvasSize=Enum.AutomaticSize.Y List.CanvasSize=UDim2.new(0,0,0,0) List.Parent=Con List.Visible=false Instance.new("UIListLayout", List).Padding=UDim.new(0,2)
                local function Upd() for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end for _,v in pairs(items) do local IB=RegisterTheme(Instance.new("TextButton"), "BackgroundColor3", "Sidebar") IB.Size=UDim2.new(1,0,0,30) IB.Text="  "..v RegisterTheme(IB, "TextColor3", sel==v and "Accent2" or "TextDim") IB.FontFace=FontMain IB.TextSize=14 IB.TextXAlignment=Enum.TextXAlignment.Left IB.Parent=List Instance.new("UICorner",IB).CornerRadius=UDim.new(0,4) IB.MouseButton1Click:Connect(function() sel=v S.Text=v Library.Flags[f]=v exp=false Tween(Con,{Size=UDim2.new(1,0,0,Con:GetAttribute("H"))}) task.delay(0.2, function() if not exp then List.Visible=false end end) Upd() pcall(cb,v) end) end end
                B.MouseButton1Click:Connect(function() exp=not exp Con:SetAttribute("H", Con.AbsoluteSize.Y) if exp then List.Visible=true end Tween(I,{Rotation=exp and 180 or 0}) Tween(Con,{Size=UDim2.new(1,0,0,exp and math.min(180,#items*32+50) or 40)}) if not exp then task.delay(0.2, function() if not exp then List.Visible=false end end) end end) Upd()
                Library.Elements[f]={Set=function(v) sel=v S.Text=v Library.Flags[f]=v Upd() pcall(cb,v) end, Refresh=function(n) items=n Upd() end}
            end

            function Generators.MultiDropdown(parent, t,f,items,cb,desc)
                local sel = {} Library.Flags[f] = sel local exp = false
                local Con = CreateBase(parent, t, desc, 40) Con.ClipsDescendants = true
                local B = Instance.new("TextButton") B.Size = UDim2.new(1, 0, 0, 40) B.BackgroundTransparency = 1 B.Text = "" B.Parent = Con
                local S = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim") S.Text = "None" S.Size = UDim2.new(0.5, -40, 0, 20) S.Position = UDim2.new(1, -30, 0, 10) S.AnchorPoint = Vector2.new(1, 0) S.BackgroundTransparency = 1 S.FontFace = FontMain S.TextSize = 14 S.TextXAlignment = Enum.TextXAlignment.Right S.Parent = B
                local I = RegisterTheme(Instance.new("ImageLabel"), "ImageColor3", "TextDim") I.Size = UDim2.new(0, 16, 0, 16) I.Position = UDim2.new(1, -26, 0, 12) I.BackgroundTransparency = 1 I.Image = Icons["chevron"] I.Parent = B
                local List = Instance.new("ScrollingFrame") List.Size = UDim2.new(1, -10, 1, -45) List.Position = UDim2.new(0, 5, 0, 45) List.BackgroundTransparency = 1 List.BorderSizePixel = 0 List.ScrollBarThickness = 2 List.AutomaticCanvasSize = Enum.AutomaticSize.Y List.CanvasSize = UDim2.new(0, 0, 0, 0) List.Parent = Con List.Visible=false Instance.new("UIListLayout", List).Padding = UDim.new(0, 2)
                
                local function UpdateText() local count = 0 local txt = "" for k,v in pairs(sel) do if v then count=count+1 txt=txt..k..", " end end if count == 0 then S.Text = "None" elseif count > 2 then S.Text = count.." Selected" else S.Text = txt:sub(1, -3) end end
                local function Upd() for _,v in pairs(List:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end for _,v in pairs(items) do local IB = RegisterTheme(Instance.new("TextButton"), "BackgroundColor3", "Sidebar") IB.Size = UDim2.new(1, 0, 0, 30) IB.Text = "  "..v IB.TextColor3 = sel[v] and Theme.Accent2 or Theme.TextDim IB.FontFace = FontMain IB.TextSize = 14 IB.TextXAlignment = Enum.TextXAlignment.Left IB.Parent = List Instance.new("UICorner", IB).CornerRadius = UDim.new(0, 4) IB.MouseButton1Click:Connect(function() if sel[v] then sel[v] = nil else sel[v] = true end Library.Flags[f] = sel IB.TextColor3 = sel[v] and Theme.Accent2 or Theme.TextDim UpdateText() pcall(cb, sel) end) end end
                B.MouseButton1Click:Connect(function() exp = not exp if exp then List.Visible=true end Tween(I, {Rotation = exp and 180 or 0}) Tween(Con, {Size = UDim2.new(1, 0, 0, exp and math.min(150, #items * 32 + 50) or 40)}) if not exp then task.delay(0.2, function() if not exp then List.Visible=false end end) end end) Upd()
                Library.Elements[f] = {Set = function(v) sel = v or {} Library.Flags[f] = sel UpdateText() Upd() end}
            end

            function Generators.Paragraph(parent, title, text)
                local P = RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Element") 
                P.Size = UDim2.new(1, 0, 0, 0) P.Parent = parent P.AutomaticSize = Enum.AutomaticSize.Y 
                Instance.new("UICorner", P).CornerRadius = UDim.new(0, 6)
                local T = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "Text") 
                T.Text = title T.Size = UDim2.new(1, -20, 0, 20) T.Position = UDim2.new(0, 10, 0, 8) 
                T.BackgroundTransparency = 1 T.FontFace = FontBold T.TextSize = 14 T.TextXAlignment = Enum.TextXAlignment.Left T.Parent = P
                local C = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "TextDim") 
                C.Text = text C.Size = UDim2.new(1, -20, 0, 0) C.Position = UDim2.new(0, 10, 0, 32) 
                C.BackgroundTransparency = 1 C.FontFace = FontMain C.TextSize = 13 C.TextXAlignment = Enum.TextXAlignment.Left C.TextWrapped = true 
                C.AutomaticSize = Enum.AutomaticSize.Y C.Parent = P
                local Pad = Instance.new("UIPadding") Pad.PaddingBottom = UDim.new(0, 12) Pad.Parent = P
            end

            function Generators.ColorPicker(parent, t, f, def, alpha, cb, desc)
                local curColor = def or Color3.fromRGB(255, 255, 255)
                local curAlpha = alpha or 1
                local h, s_hsv, v = curColor:ToHSV()
                local expanded = false
                Library.Flags[f] = {Color = curColor, Transparency = curAlpha}
                
                local Main = CreateBase(parent, t, desc, 40) Main.ClipsDescendants = true
                
                local Trigger = RegisterTheme(Instance.new("TextButton"), "BackgroundColor3", "Background") 
                Trigger.Size = UDim2.new(0, 40, 0, 20) Trigger.Position = UDim2.new(1, -70, 0, 10) Trigger.Text = "" Trigger.Parent = Main
                Instance.new("UICorner", Trigger).CornerRadius = UDim.new(0, 4)
                
                local TChecker = Instance.new("ImageLabel") TChecker.Size = UDim2.new(1, 0, 1, 0) TChecker.Image = "rbxassetid://15655263661" TChecker.ScaleType = Enum.ScaleType.Tile TChecker.TileSize = UDim2.new(0, 10, 0, 10) TChecker.Parent = Trigger
                Instance.new("UICorner", TChecker).CornerRadius = UDim.new(0, 4)
                local TColor = Instance.new("Frame") TColor.Size = UDim2.new(1, 0, 1, 0) TColor.BackgroundColor3 = curColor TColor.BackgroundTransparency = 1 - curAlpha TColor.Parent = Trigger
                Instance.new("UICorner", TColor).CornerRadius = UDim.new(0, 4)

                local Picker = Instance.new("Frame") Picker.Size = UDim2.new(1, -20, 0, 210) Picker.Position = UDim2.new(0, 10, 0, 45) Picker.BackgroundTransparency = 1 Picker.Visible=false Picker.Parent = Main
                
                local SV = Instance.new("TextButton") SV.Size = UDim2.new(0, 120, 0, 120) SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1) SV.Text = "" SV.AutoButtonColor = false SV.Parent = Picker
                local SatLayer = Instance.new("Frame") SatLayer.Size = UDim2.new(1, 0, 1, 0) SatLayer.BackgroundColor3 = Color3.new(1, 1, 1) SatLayer.Parent = SV
                local SatGrad = Instance.new("UIGradient") SatGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)), ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))} 
                SatGrad.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)} SatGrad.Parent = SatLayer
                local ValLayer = Instance.new("Frame") ValLayer.Size = UDim2.new(1, 0, 1, 0) ValLayer.BackgroundColor3 = Color3.new(0, 0, 0) ValLayer.Parent = SV
                local ValGrad = Instance.new("UIGradient") ValGrad.Rotation = -90 
                ValGrad.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)), ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))} 
                ValGrad.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1)} ValGrad.Parent = ValLayer
                local SVPoint = Instance.new("Frame") SVPoint.Size = UDim2.new(0, 8, 0, 8) SVPoint.BackgroundColor3 = Color3.new(1, 1, 1) SVPoint.Position = UDim2.new(s_hsv, -4, 1 - v, -4) SVPoint.Parent = SV
                Instance.new("UICorner", SVPoint).CornerRadius = UDim.new(1, 0) Instance.new("UIStroke", SVPoint).Thickness = 1
                
                local HueF = Instance.new("TextButton") HueF.Size = UDim2.new(0, 20, 0, 120) HueF.Position = UDim2.new(0, 130, 0, 0) HueF.BackgroundColor3 = Color3.new(1, 1, 1) HueF.Text = "" HueF.AutoButtonColor = false HueF.Parent = Picker
                local HG = Instance.new("UIGradient") HG.Rotation = 90 HG.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)), ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)), ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))} HG.Parent = HueF
                local HuePoint = Instance.new("Frame") HuePoint.Size = UDim2.new(1, 2, 0, 4) HuePoint.Position = UDim2.new(0, -1, h, -2) HuePoint.BackgroundColor3 = Color3.new(1, 1, 1) HuePoint.Parent = HueF Instance.new("UIStroke", HuePoint).Thickness = 1
                
                local AlphaF = Instance.new("TextButton") AlphaF.Size = UDim2.new(1, 0, 0, 15) AlphaF.Position = UDim2.new(0, 0, 0, 130) AlphaF.BackgroundColor3 = Color3.new(1, 1, 1) AlphaF.Text = "" AlphaF.AutoButtonColor = false AlphaF.Parent = Picker
                local Checker = Instance.new("ImageLabel") Checker.Size = UDim2.new(1, 0, 1, 0) Checker.Image = "rbxassetid://15655263661" Checker.ScaleType = Enum.ScaleType.Tile Checker.TileSize = UDim2.new(0, 10, 0, 10) Checker.Parent = AlphaF
                local AlphaGrad = Instance.new("Frame") AlphaGrad.Size = UDim2.new(1, 0, 1, 0) AlphaGrad.BackgroundColor3 = Color3.new(1, 1, 1) AlphaGrad.Parent = AlphaF
                local AG = Instance.new("UIGradient") AG.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, curColor), ColorSequenceKeypoint.new(1, curColor)} 
                AG.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0)} AG.Parent = AlphaGrad
                local AlphaPoint = Instance.new("Frame") AlphaPoint.Size = UDim2.new(0, 4, 1, 2) AlphaPoint.Position = UDim2.new(curAlpha, -2, 0, -1) AlphaPoint.BackgroundColor3 = Color3.new(1, 1, 1) AlphaPoint.Parent = AlphaF Instance.new("UIStroke", AlphaPoint).Thickness = 1
                
                local Inputs = Instance.new("Frame") Inputs.Size = UDim2.new(0.4, 0, 0, 120) Inputs.Position = UDim2.new(1, -100, 0, 0) Inputs.BackgroundTransparency = 1 Inputs.Parent = Picker
                local HexBox = RegisterTheme(Instance.new("TextBox"), "BackgroundColor3", "Background") HexBox.Size = UDim2.new(1, 0, 0, 25) RegisterTheme(HexBox, "TextColor3", "Text") HexBox.Text = RGBtoHex(curColor) HexBox.FontFace = FontMain HexBox.TextSize = 12 HexBox.PlaceholderText = "HEX" HexBox.Parent = Inputs Instance.new("UICorner", HexBox).CornerRadius = UDim.new(0, 4)
                
                local RGBFrame = Instance.new("Frame") RGBFrame.Size = UDim2.new(1, 0, 0, 25) RGBFrame.Position = UDim2.new(0, 0, 0, 30) RGBFrame.BackgroundTransparency = 1 RGBFrame.Parent = Inputs
                local RGBLayout = Instance.new("UIListLayout") RGBLayout.FillDirection = Enum.FillDirection.Horizontal RGBLayout.Padding = UDim.new(0, 3) RGBLayout.Parent = RGBFrame
                
                local function CreateRGBBox(ph) local Box = RegisterTheme(Instance.new("TextBox"), "BackgroundColor3", "Background") Box.Size = UDim2.new(0.31, 0, 1, 0) RegisterTheme(Box, "TextColor3", "Text") Box.FontFace = FontMain Box.TextSize = 12 Box.PlaceholderText = ph Box.Parent = RGBFrame Instance.new("UICorner", Box).CornerRadius = UDim.new(0, 4) return Box end
                local RBox, GBox, BBox = CreateRGBBox("R"), CreateRGBBox("G"), CreateRGBBox("B")
                
                local function Update()
                    curColor = Color3.fromHSV(h, s_hsv, v)
                    Library.Flags[f] = {Color = curColor, Transparency = curAlpha}
                    TColor.BackgroundColor3 = curColor TColor.BackgroundTransparency = 1 - curAlpha SV.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    AG.Color = ColorSequence.new{ColorSequenceKeypoint.new(0, curColor), ColorSequenceKeypoint.new(1, curColor)}
                    if not HexBox:IsFocused() then HexBox.Text = RGBtoHex(curColor) end
                    if not RBox:IsFocused() then RBox.Text = math.floor(curColor.R * 255) end
                    if not GBox:IsFocused() then GBox.Text = math.floor(curColor.G * 255) end
                    if not BBox:IsFocused() then BBox.Text = math.floor(curColor.B * 255) end
                    pcall(cb, curColor, curAlpha)
                end
                
                HexBox.FocusLost:Connect(function() local nc = HexToRGB(HexBox.Text) if nc then h, s_hsv, v = nc:ToHSV() SVPoint.Position = UDim2.new(s_hsv, -4, 1 - v, -4) HuePoint.Position = UDim2.new(0, -1, h, -2) Update() else HexBox.Text = RGBtoHex(curColor) end end)
                local function UpdateFromRGB() local r = tonumber(RBox.Text) or 0 local g = tonumber(GBox.Text) or 0 local b = tonumber(BBox.Text) or 0 local nc = Color3.fromRGB(math.clamp(r, 0, 255), math.clamp(g, 0, 255), math.clamp(b, 0, 255)) h, s_hsv, v = nc:ToHSV() SVPoint.Position = UDim2.new(s_hsv, -4, 1 - v, -4) HuePoint.Position = UDim2.new(0, -1, h, -2) Update() end
                RBox.FocusLost:Connect(UpdateFromRGB) GBox.FocusLost:Connect(UpdateFromRGB) BBox.FocusLost:Connect(UpdateFromRGB)
                
                local dSV, dHue, dAlpha = false, false, false
                SV.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dSV = true local m = i.Position local rX = math.clamp((m.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X, 0, 1) local rY = math.clamp((m.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y, 0, 1) s_hsv = rX v = 1 - rY SVPoint.Position = UDim2.new(s_hsv, -4, 1 - v, -4) Update() end end)
                HueF.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dHue = true local m = i.Position local rY = math.clamp((m.Y - HueF.AbsolutePosition.Y) / HueF.AbsoluteSize.Y, 0, 1) h = rY HuePoint.Position = UDim2.new(0, -1, h, -2) Update() end end)
                AlphaF.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dAlpha = true local m = i.Position local rX = math.clamp((m.X - AlphaF.AbsolutePosition.X) / AlphaF.AbsoluteSize.X, 0, 1) curAlpha = rX AlphaPoint.Position = UDim2.new(curAlpha, -2, 0, -1) Update() end end)
                
                UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dSV = false dHue = false dAlpha = false end end)
                UserInputService.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then if dSV then local m = i.Position local rX = math.clamp((m.X - SV.AbsolutePosition.X) / SV.AbsoluteSize.X, 0, 1) local rY = math.clamp((m.Y - SV.AbsolutePosition.Y) / SV.AbsoluteSize.Y, 0, 1) s_hsv = rX v = 1 - rY SVPoint.Position = UDim2.new(s_hsv, -4, 1 - v, -4) Update() end if dHue then local m = i.Position local rY = math.clamp((m.Y - HueF.AbsolutePosition.Y) / HueF.AbsoluteSize.Y, 0, 1) h = rY HuePoint.Position = UDim2.new(0, -1, h, -2) Update() end if dAlpha then local m = i.Position local rX = math.clamp((m.X - AlphaF.AbsolutePosition.X) / AlphaF.AbsoluteSize.X, 0, 1) curAlpha = rX AlphaPoint.Position = UDim2.new(curAlpha, -2, 0, -1) Update() end end end)
                
                Trigger.MouseButton1Click:Connect(function() expanded = not expanded if expanded then Picker.Visible=true end Tween(Main, {Size = UDim2.new(1, 0, 0, expanded and 265 or 40)}) if not expanded then task.delay(0.2, function() if not expanded then Picker.Visible=false end end) end end)
                Library.Elements[f] = {Set = function(t) if type(t) == "table" then local nc = t.Color or curColor local na = t.Transparency or curAlpha h, s_hsv, v = nc:ToHSV() curAlpha = na SVPoint.Position = UDim2.new(s_hsv, -4, 1 - v, -4) HuePoint.Position = UDim2.new(0, -1, h, -2) AlphaPoint.Position = UDim2.new(curAlpha, -2, 0, -1) Update() end end}
                Update()
            end

            -- // ELEMENT FUNCTIONS
            local Elems = {}

            -- // COLLAPSIBLE SECTION //
            function Elems:Section(text, side)
                local parent = col(side)
                
                local SectionFrame = RegisterTheme(Instance.new("Frame"), "BackgroundColor3", "Element")
                SectionFrame.Size = UDim2.new(1, 0, 0, 36)
                SectionFrame.ClipsDescendants = true
                SectionFrame.Parent = parent
                Instance.new("UICorner", SectionFrame).CornerRadius = UDim.new(0, 6)

                local HeaderBtn = Instance.new("TextButton")
                HeaderBtn.Size = UDim2.new(1, 0, 0, 36)
                HeaderBtn.BackgroundTransparency = 1
                HeaderBtn.Text = ""
                HeaderBtn.Parent = SectionFrame

                local HeaderText = RegisterTheme(Instance.new("TextLabel"), "TextColor3", "Text")
                HeaderText.Text = text
                HeaderText.Size = UDim2.new(1, -30, 0, 36)
                HeaderText.Position = UDim2.new(0, 10, 0, 0)
                HeaderText.BackgroundTransparency = 1
                HeaderText.FontFace = FontBold
                HeaderText.TextSize = 13
                HeaderText.TextXAlignment = Enum.TextXAlignment.Left
                HeaderText.Parent = HeaderBtn

                local Chevron = RegisterTheme(Instance.new("ImageLabel"), "ImageColor3", "TextDim")
                Chevron.Size = UDim2.new(0, 16, 0, 16)
                Chevron.Position = UDim2.new(1, -26, 0.5, -8)
                Chevron.BackgroundTransparency = 1
                Chevron.Image = Icons["chevron"]
                Chevron.Parent = HeaderBtn

                local ContentFrame = Instance.new("Frame")
                ContentFrame.Size = UDim2.new(1, 0, 0, 0)
                ContentFrame.Position = UDim2.new(0, 0, 0, 36)
                ContentFrame.BackgroundTransparency = 1
                ContentFrame.AutomaticSize = Enum.AutomaticSize.Y
                ContentFrame.Parent = SectionFrame
                
                local Pad = Instance.new("UIPadding")
                Pad.PaddingTop = UDim.new(0, 5)
                Pad.PaddingBottom = UDim.new(0, 10)
                Pad.PaddingLeft = UDim.new(0, 5)
                Pad.PaddingRight = UDim.new(0, 5)
                Pad.Parent = ContentFrame
                
                local List = Instance.new("UIListLayout")
                List.Padding = UDim.new(0, 5)
                List.Parent = ContentFrame

                local expanded = false
                
                HeaderBtn.MouseButton1Click:Connect(function()
                    expanded = not expanded
                    Tween(Chevron, {Rotation = expanded and 180 or 0})
                    if expanded then SectionFrame.AutomaticSize = Enum.AutomaticSize.Y else SectionFrame.AutomaticSize = Enum.AutomaticSize.None Tween(SectionFrame, {Size = UDim2.new(1, 0, 0, 36)}) end
                end)

                local SectionElems = {}
                function SectionElems:Label(t) Generators.Label(ContentFrame, t) end
                function SectionElems:Button(t, d, cb) Generators.Button(ContentFrame, t, d, cb) end
                function SectionElems:Keybind(t, f, def, cb, d) Generators.Keybind(ContentFrame, t, f, def, cb, d) end
                function SectionElems:Checkbox(t, f, d, tip, cb) Generators.Checkbox(ContentFrame, t, f, d, tip, cb) end
                function SectionElems:Toggle(t, f, d, tip, cb) Generators.Toggle(ContentFrame, t, f, d, tip, cb) end
                function SectionElems:Slider(t, f, min, max, def, cb, d) Generators.Slider(ContentFrame, t, f, min, max, def, cb, d) end
                function SectionElems:TextBox(t, f, def, cb, d) Generators.TextBox(ContentFrame, t, f, def, cb, d) end
                function SectionElems:Dropdown(t, f, items, cb, d) Generators.Dropdown(ContentFrame, t, f, items, cb, d) end
                function SectionElems:MultiDropdown(t, f, items, cb, d) Generators.MultiDropdown(ContentFrame, t, f, items, cb, d) end
                function SectionElems:Paragraph(title, text) Generators.Paragraph(ContentFrame, title, text) end
                function SectionElems:ColorPicker(t, f, def, alpha, cb, tip) Generators.ColorPicker(ContentFrame, t, f, def, alpha, cb, tip) end
                
                return SectionElems
            end
            -- // END SECTION //

            function Elems:Label(t,s) Generators.Label(col(s), t) end
            function Elems:Button(t,desc,s,cb) Generators.Button(col(s), t, desc, cb) end
            function Elems:Keybind(t, f, def, s, cb, desc) Generators.Keybind(col(s), t, f, def, cb, desc) end
            function Elems:Checkbox(t,f,d,desc,s,cb) Generators.Checkbox(col(s), t, f, d, desc, cb) end
            function Elems:Toggle(t, f, d, desc, s, cb) Generators.Toggle(col(s), t, f, d, desc, cb) end
            function Elems:Slider(t,f,min,max,def,s,cb,desc) Generators.Slider(col(s), t, f, min, max, def, cb, desc) end
            function Elems:TextBox(t,f,def,s,cb,desc) Generators.TextBox(col(s), t, f, def, cb, desc) end
            function Elems:Dropdown(t,f,items,s,cb,desc) Generators.Dropdown(col(s), t, f, items, cb, desc) end
            function Elems:MultiDropdown(t,f,items,s,cb,desc) Generators.MultiDropdown(col(s), t, f, items, cb, desc) end
            function Elems:Paragraph(title, text, s) Generators.Paragraph(col(s), title, text) end
            function Elems:ColorPicker(t, f, def, alpha, s, cb, desc) Generators.ColorPicker(col(s), t, f, def, alpha, cb, desc) end

            return Elems
        end
        return TabObj
    end
    return WinObj
end

function Library:ConfigSystem(Window)
    local S = Window:Tab("Settings", "settings")
    local Cfg = S:Page("Configs", "folder")
    local ThemePage = S:Page("Themes", "paint-bucket")
    
    local selConfig = ""
    local configDropdown = nil
    
    local function RefreshConfigs()
        local configs = Library:GetConfigs()
        if configDropdown and Library.Elements["ConfigList"] then
            Library.Elements["ConfigList"].Refresh(configs)
        end
    end

    Cfg:Dropdown("Available Configs", "ConfigList", Library:GetConfigs(), "Left", function(v) selConfig = v end)
    Cfg:TextBox("New Config Name", "ConfigName", "", "Left", function(v) selConfig = v end)
    
    Cfg:Button("Save Config", "Saves settings", "Left", function() Library:SaveConfig(selConfig) RefreshConfigs() end)
    Cfg:Button("Load Config", "Loads settings", "Left", function() Library:LoadConfig(selConfig) end)
    Cfg:Button("Delete Config", "Deletes settings", "Right", function() Library:DeleteConfig(selConfig) RefreshConfigs() end)
    Cfg:Button("Refresh List", "Reloads file list", "Right", function() RefreshConfigs() end)

    local presets = {}
    for k, v in pairs(ThemePresets) do table.insert(presets, k) end
    table.sort(presets)
    
    ThemePage:Dropdown("Theme Presets", "ThemePreset", presets, "Left", function(v) UpdateTheme(v) end)
end

return Library
