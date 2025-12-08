--[[ 
    ETERNESUS UI REMASTERED v12.5 (PLATINUM + ICONS + PROFILE)
    Language: LuaU
    Added: 
    1. Player Profile (Sidebar Bottom)
    2. RadioButton Element
]]

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = Workspace.CurrentCamera

local Library = {}

--// ICON LIBRARY (Названия вместо цифр)
local Icons = {
    Home = "6031068428",
    Settings = "6031280882",
    Visuals = "6034509993",
    Combat = "6031090835",
    Player = "6031280894",
    Cloud = "6034509990",
    Folder = "6031068426",
    Shield = "6031090867",
    Sword = "6031090835",
    Search = "6031154871",
    Bug = "6031280887",
    Info = "6031280883",
    Lock = "6031090854",
    List = "6031091000",
    a_arrow_down = "92867583610071",
    a_arrow_up = "132318504999733",
    a_large_small = "111491496660216",
    accessibility = "114029945302017",
    activity = "94212016861936",
    air_vent = "81517226012329",
    airplay = "115020759309179",
    alarm_clock_check = "76437352099157",
    alarm_clock_minus = "77364179863205",
    alarm_clock_off = "97904885874823",
    alarm_clock_plus = "80468822979214",
    alarm_clock = "126259032907535",
    alarm_smoke = "96965448419685",
    album = "127358331163602",
    align_center_horizontal = "81570549209434",
    align_center_vertical = "118470463752466",
    align_end_horizontal = "139502909745427",
    align_end_vertical = "96528869059554",
    align_horizontal_distribute_center = "97220086126656",
    align_horizontal_distribute_end = "106128590702022",
    align_horizontal_distribute_start = "76074660002997",
    align_horizontal_justify_center = "75732302772427",
    align_horizontal_justify_end = "129167626402283",
    align_horizontal_justify_start = "130161830325281",
    align_horizontal_space_around = "91646106782950",
    align_horizontal_space_between = "103886093046990",
    align_start_horizontal = "125674804697729",
    align_start_vertical = "105020230154823",
    align_vertical_distribute_center = "93791183635525",
    align_vertical_distribute_end = "139354223511433",
    align_vertical_distribute_start = "74961997822126",
    align_vertical_justify_center = "134754696166569",
    align_vertical_justify_end = "92569381441969",
    align_vertical_justify_start = "99692844572718",
    align_vertical_space_around = "96206012459190",
    align_vertical_space_between = "124998077349706",
    ambulance = "78599995190651",
    ampersand = "75272915739209",
    ampersands = "126947193455996",
    amphora = "137370389604364",
    anchor = "92181172123618",
    angry = "74237056000103",
    annoyed = "80064369052011",
    antenna = "99628923540956",
    anvil = "100203029845919",
    aperture = "83396154449972",
    app_window_mac = "79587216113811",
    app_window = "93142176757189",
    apple = "104349242902442",
    archive_restore = "78956681942188",
    archive_x = "75830115088395",
    archive = "122180020814574",
    armchair = "105384358373973",
    arrow_big_down_dash = "137987229582002",
    arrow_big_down = "81081164158885",
    arrow_big_left_dash = "97827621354677",
    arrow_big_left = "85973092492641",
    arrow_big_right_dash = "117825834972403",
    arrow_big_right = "82960676755590",
    arrow_big_up_dash = "99260194327483",
    arrow_big_up = "93136954756149",
    arrow_down_0_1 = "120961896217875",
    arrow_down_1_0 = "93474255891850",
    arrow_down_a_z = "99554596207900",
    arrow_down_from_line = "132045845807798",
    arrow_down_left = "102899325237364",
    arrow_down_narrow_wide = "129105261655061",
    arrow_down_right = "123109928624974",
    arrow_down_to_dot = "101675355931221",
    arrow_down_to_line = "87050478931254",
    arrow_down_up = "85780258549577",
    arrow_down_wide_narrow = "88461733425991",
    arrow_down_z_a = "76115279362232",
    arrow_down = "98764963621439",
    arrow_left_from_line = "87857914437603",
    arrow_left_right = "131324733048447",
    arrow_left_to_line = "118645136026970",
    arrow_left = "102531941843733",
    arrow_right_from_line = "74073639809355",
    arrow_right_left = "77015754304300",
    arrow_right_to_line = "78632510329852",
    arrow_right = "113692007244654",
    arrow_up_0_1 = "105257823943016",
    arrow_up_1_0 = "134175521693798",
    arrow_up_a_z = "77763416595160",
    arrow_up_down = "81019887641527",
    arrow_up_from_dot = "124408496673275",
    arrow_up_from_line = "95777664626453",
    arrow_up_left = "123490598231261",
    arrow_up_narrow_wide = "73006024672636",
    arrow_up_right = "129280608535523",
    arrow_up_to_line = "108818207813537",
    arrow_up_wide_narrow = "87437426951568",
    arrow_up_z_a = "107546173611884",
    arrow_up = "89282378235317",
    arrows_up_from_line = "133710016938621",
    asterisk = "88552752106723",
    at_sign = "79059152889146",
    atom = "73167696981648",
    audio_lines = "70930641819242",
    audio_waveform = "86462036665209",
    award = "132740088158419",
    axe = "132405197863294",
    axis_3d = "122438676546804",
    baby = "93472926933440",
    backpack = "140420225386018",
    badge_alert = "101829200081951",
    badge_cent = "133345018873154",
    badge_check = "76078495178149",
    badge_dollar_sign = "127139803581141",
    badge_euro = "120016477674659",
    badge_indian_rupee = "75659682309981",
    badge_info = "131995373201472",
    badge_japanese_yen = "99081574588615",
    badge_minus = "140321561183881",
    badge_percent = "121359224294885",
    badge_plus = "100325578561866",
    badge_pound_sterling = "119688217279444",
    badge_question_mark = "121464963737502",
    badge_russian_ruble = "108839463659864",
    badge_swiss_franc = "91447608372740",
    badge_turkish_lira = "137839965873529",
    badge_x = "122931434733842",
    badge = "116620312917084",
    baggage_claim = "86922213051957",
    ban = "90767043015246",
    banana = "140713420056179",
    bandage = "129660129590770",
    banknote_arrow_down = "139366449345199",
    banknote_arrow_up = "133758343082529",
    banknote_x = "95348701438065",
    banknote = "104840231536668",
    barcode = "118473018143689",
    barrel = "130647115622774",
    baseline = "124677132511270",
    bath = "76031400297942",
    battery_charging = "80139357470047",
    battery_full = "70906718268972",
    battery_low = "139659256984314",
    battery_medium = "105934079398915",
    battery_plus = "91931341486966",
    battery_warning = "115230083817257",
    battery = "70765800346189",
    beaker = "80902539995520",
    bean_off = "98164436608714",
    bean = "89491967076869",
    bed_double = "73820193212911",
    bed_single = "113423940880634",
    bed = "97726529032925",
    beef = "105850162318915",
    beer_off = "120333134736361",
    beer = "116404978807744",
    bell_dot = "93161277118810",
    bell_electric = "100277767266983",
    bell_minus = "126334890449727",
    bell_off = "78560046118930",
    bell_plus = "77014333795836",
    bell_ring = "94612128913941",
    bell = "97392696311902",
    between_horizontal_end = "81602774794322",
    between_horizontal_start = "76112384929846",
    between_vertical_end = "72817612571631",
    between_vertical_start = "85278312190301",
    biceps_flexed = "82004462003936",
    bike = "102930322246035",
    binary = "91751953950088",
    binoculars = "101460003267896",
    biohazard = "95956532900432",
    bird = "132284145117371",
    birdhouse = "83999157401433",
    bitcoin = "95459240442938",
    blend = "111679612185257",
    blinds = "71164165283925",
    blocks = "72212693357737",
    bluetooth_connected = "96315134002985",
    bluetooth_off = "80600044218117",
    bluetooth_searching = "100673019606426",
    bluetooth = "90506573139443",
    bold = "116141470019166",
    bolt = "102881251417484",
    bomb = "139223800924636",
    bone = "111242153474115",
    book_a = "104067275658465",
    book_alert = "124159928044853",
    book_audio = "109208148317037",
    book_check = "115999656081696",
    book_copy = "108543407492005",
    book_dashed = "127430784795958",
    book_down = "101011730128222",
    book_headphones = "108670200799574",
    book_heart = "112788845135284",
    book_image = "80808285757226",
    book_key = "116024426170705",
    book_lock = "118765061220571",
    book_marked = "73211024251780",
    book_minus = "112724962046282",
    book_open_check = "130848362492667",
    book_open_text = "100629528672195",
    book_open = "129845326810392",
    book_plus = "140267785051233",
    book_text = "94011772484232",
    book_type = "97817304725443",
    book_up_2 = "130161620853665",
    book_up = "98640174079190",
    book_user = "128489189240523",
    book_x = "118754548186537",
    book = "125383279695672",
    bookmark_check = "93940443347986",
    bookmark_minus = "96807096039910",
    bookmark_plus = "121469724491615",
    bookmark_x = "112272342584706",
    bookmark = "121093149326239",
    boom_box = "99901322535868",
    bot_message_square = "96145330292478",
    bot_off = "140417690560013",
    bot = "80451686744860",
    bottle_wine = "131675403196921",
    bow_arrow = "124089655150375",
    box = "101768155599700",
    boxes = "136372617578355",
    braces = "117761094704041",
    brackets = "74368995728099",
    brain_circuit = "70547962410202",
    brain_cog = "132039205501538",
    brain = "92424107303177",
    brick_wall_fire = "92980588705520",
    brick_wall_shield = "75954432775071",
    brick_wall = "112878522258821",
    briefcase_business = "129135125207283",
    briefcase_conveyor_belt = "108665725653714",
    briefcase_medical = "119917756334087",
    briefcase = "96754188164225",
    bring_to_front = "132975903553748",
    brush_cleaning = "71728977448805",
    brush = "127035535799640",
    bubbles = "106183424168227",
    bug_off = "88020025049245",
    bug_play = "80107955888092",
    bug = "83626408925438",
    building_2 = "77873775611951",
    building = "110616258983082",
    bus_front = "89863432456045",
    bus = "133798469717463",
    cable_car = "128643682205596",
    cable = "128449944504901",
    cake_slice = "136769828413242",
    cake = "103131590503275",
    calculator = "74915716529646",
    calendar_1 = "98458364171044",
    calendar_arrow_down = "108415736543437",
    calendar_arrow_up = "70574654109118",
    calendar_check_2 = "120231170248276",
    calendar_check = "71551019465748",
    calendar_clock = "119132152594595",
    calendar_cog = "122402172360287",
    calendar_days = "99072017568595",
    calendar_fold = "117368871270394",
    calendar_heart = "88839008103676",
    calendar_minus_2 = "98846170279891",
    calendar_minus = "137354318924383",
    calendar_off = "109726151749217",
    calendar_plus_2 = "112264562093883",
    calendar_plus = "125266115249843",
    calendar_range = "103641849247576",
    calendar_search = "92010083223634",
    calendar_sync = "78082218499697",
    calendar_x_2 = "107518051061147",
    calendar_x = "106703374806500",
    calendar = "114792700814035",
    camera_off = "81057636835256",
    camera = "79950339943067",
    candy_cane = "71689468772492",
    candy_off = "110232752314832",
    candy = "107812129154678",
    cannabis = "98792006538601",
    captions_off = "105223545364193",
    captions = "104960225031445",
    car_front = "87380942739063",
    car_taxi_front = "122455403384057",
    car = "121065933462582",
    caravan = "120070979471783",
    card_sim = "134490550095771",
    carrot = "119118221444304",
    case_lower = "129303130603241",
    case_sensitive = "125410273293056",
    case_upper = "111633433531325",
    cassette_tape = "137065788934157",
    cast = "98202245922071",
    castle = "119275077187784",
    cat = "124252153404931",
    cctv = "99979894766624",
    chart_area = "123446436762366",
    chart_bar_big = "72336824986044",
    chart_bar_decreasing = "107217459044963",
    chart_bar_increasing = "88268905998571",
    chart_bar_stacked = "98478751113024",
    chart_bar = "105389816384108",
    chart_candlestick = "125676898615697",
    chart_column_big = "98598733210787",
    chart_column_decreasing = "73586137373563",
    chart_column_increasing = "120421615068601",
    chart_column_stacked = "86031449675105",
    chart_column = "97915995538580",
    chart_gantt = "88811660555940",
    chart_line = "101833156055618",
    chart_network = "104027882693561",
    chart_no_axes_column_decreasing = "123371717192542",
    chart_no_axes_column_increasing = "140383830943049",
    chart_no_axes_column = "94078751170351",
    chart_no_axes_combined = "121424233161912",
    chart_no_axes_gantt = "131936541106368",
    chart_pie = "113412261630136",
    chart_scatter = "108217585014571",
    chart_spline = "90307460742494",
    check_check = "95183312173858",
    check_line = "115122343485290",
    check = "93898873302694",
    chef_hat = "121744015002573",
    cherry = "139519182403183",
    chess_bishop = "121701705580238",
    chess_king = "90885687223462",
    chess_knight = "96467707042169",
    chess_pawn = "111318574652751",
    chess_queen = "98304702099749",
    chess_rook = "76223925830262",
    chevron_down = "134243273101015",
    chevron_first = "105243363790238",
    chevron_last = "89268452603731",
    chevron_left = "73780377692148",
    chevron_right = "92473583511724",
    chevron_up = "122444883127455",
    chevrons_down_up = "139404716013205",
    chevrons_down = "100524612205956",
    chevrons_left_right_ellipsis = "125035817741526",
    chevrons_left_right = "87910685945204",
    chevrons_left = "82617201744347",
    chevrons_right_left = "87149546686569",
    chevrons_right = "139121276490483",
    chevrons_up_down = "131833120209646",
    chevrons_up = "100463452364672",
    chromium = "128165143739006",
    church = "113714744350666",
    cigarette_off = "77797883078452",
    circle_alert = "83898160590116",
    circle_arrow_down = "95901860261344",
    circle_arrow_left = "102148876968988",
    circle_arrow_out_down_left = "140598097856694",
    circle_arrow_out_down_right = "119952801379305",
    circle_arrow_out_up_left = "132858212688303",
    circle_arrow_out_up_right = "81783743753173",
    circle_arrow_right = "70786767999559",
    circle_arrow_up = "84395128546494",
    circle_check_big = "93202927221730",
    circle_check = "85262178816537",
    circle_chevron_down = "137069490345718",
    circle_chevron_left = "130250009740827",
    circle_chevron_right = "125943696958495",
    circle_chevron_up = "111223574026321",
    circle_dashed = "126799443883746",
    circle_divide = "106398997754208",
    circle_dollar_sign = "91106238890387",
    circle_dot_dashed = "111451232827180",
    circle_dot = "82947033619201",
    circle_ellipsis = "91687150884779",
    circle_equal = "95133963751438",
    circle_fading_arrow_up = "104648212910336",
    circle_fading_plus = "91847890443490",
    circle_gauge = "108157549473765",
    circle_minus = "133556159576809",
    circle_off = "97923456918886",
    circle_parking_off = "128369410981252",
    circle_parking = "124034962915196",
    circle_pause = "139337739700879",
    circle_percent = "133311912860256",
    circle_play = "120408917249739",
    circle_plus = "113157136350384",
    circle_pound_sterling = "105476153083828",
    circle_power = "140676030155098",
    circle_question_mark = "97516698664325",
    circle_slash_2 = "136766902186549",
    circle_slash = "125206439913049",
    circle_small = "73685402843600",
    circle_star = "120318414957104",
    circle_stop = "87400503942659",
    circle_user_round = "95489465399880",
    circle_user = "136220511671311",
    circle_x = "76821953846248",
    circle = "130359823580534",
    circuit_board = "107695264369312",
    citrus = "139018222976433",
    clapperboard = "132660667070200",
    clipboard_check = "92649798577170",
    clipboard_clock = "123957515687745",
    clipboard_copy = "125851897718493",
    clipboard_list = "96460215958908",
    clipboard_minus = "107968008485671",
    clipboard_paste = "74382068849983",
    clipboard_pen_line = "77711589791615",
    clipboard_pen = "75290966822953",
    clipboard_plus = "134285318675662",
    clipboard_type = "89949374318028",
    clipboard_x = "102222456890103",
    clipboard = "89601995828423",
    clock_1 = "129363225422045",
    clock_10 = "104332695855541",
    clock_11 = "119023205186105",
    clock_12 = "117789618723068",
    clock_2 = "134710777209413",
    clock_3 = "136385631189327",
    clock_4 = "121808839832144",
    clock_5 = "85082019959457",
    clock_6 = "71009733505593",
    clock_7 = "103111188546225",
    clock_8 = "110059272125337",
    clock_9 = "77610027126437",
    clock_alert = "97157344465162",
    clock_arrow_down = "92349314416042",
    clock_arrow_up = "111484286332629",
    clock_check = "85231630218857",
    clock_fading = "93205297285245",
    clock_plus = "93367709263150",
    clock = "121808839832144",
    closed_caption = "99832644030788",
    cloud_alert = "91967273658626",
    cloud_check = "97318598202432",
    cloud_cog = "96497764065749",
    cloud_download = "121435581993566",
    cloud_drizzle = "139525315752605",
    cloud_fog = "76650233148776",
    cloud_hail = "72320462748242",
    cloud_lightning = "133517088924849",
    cloud_moon_rain = "127667837827018",
    cloud_moon = "71938114737914",
    cloud_off = "131907154501444",
    cloud_rain_wind = "107414583736721",
    cloud_rain = "105547081967408",
    cloud_snow = "72307126270226",
    cloud_sun_rain = "99041604425705",
    cloud_sun = "86114208148727",
    cloud_upload = "93307473217005",
    cloud = "121226497050352",
    cloudy = "105360479023346",
    clover = "74925550436750",
    club = "108490365816628",
    code_xml = "130150477351734",
    code = "107380207681249",
    codepen = "135643965971885",
    codesandbox = "106911852964823",
    coffee = "106864403231093",
    cog = "116544501716299",
    coins = "116510979641930",
    columns_2 = "113004100221850",
    columns_3_cog = "121589691981064",
    columns_3 = "115223357399375",
    columns_4 = "130807991968419",
    combine = "79908476334048",
    command = "93648221906330",
    compass = "115123411028382",
    component = "110027788875080",
    computer = "77480056459407",
    concierge_bell = "140384259310436",
    cone = "97759550688437",
    construction = "106539489968173",
    contact_round = "71907624112229",
    contact = "75868297719012",
    container = "91507237573499",
    contrast = "112796643981497",
    cookie = "73159504540002",
    cooking_pot = "94959783129799",
    copy_check = "91177247988892",
    copy_minus = "109524509933035",
    copy_plus = "113618379616952",
    copy_slash = "93805787810390",
    copy_x = "106557557978061",
    copy = "78979572434545",
    copyleft = "78559055698593",
    copyright = "129433635747111",
    corner_down_left = "90473561177832",
    corner_down_right = "86512767702085",
    corner_left_down = "139876989150630",
    corner_left_up = "126228268096099",
    corner_right_down = "89237035551302",
    corner_right_up = "112851237026705",
    corner_up_left = "84669279763024",
    corner_up_right = "115099889693145",
    cpu = "77549309870247",
    creative_commons = "90408210735312",
    credit_card = "99163352872346",
    croissant = "130710485559420",
    crop = "116344601101413",
    cross = "101833377863588",
    crosshair = "134242818164054",
    crown = "127843403295538",
    cuboid = "75618807946111",
    cup_soda = "121098640829562",
    currency = "90551250119972",
    cylinder = "90569677179169",
    dam = "76874486231393",
    database_backup = "103403210984699",
    database_zap = "131199921258418",
    database = "126791525623846",
    decimals_arrow_left = "120198500638749",
    decimals_arrow_right = "118263047146797",
    delete = "126279426372342",
    dessert = "71508133278830",
    diameter = "97429051503783",
    diamond_minus = "128989071438290",
    diamond_percent = "107717860105959",
    diamond_plus = "134701163723675",
    diamond = "105846996304890",
    dice_1 = "112650149591038",
    dice_2 = "112278274566793",
    dice_3 = "118526270626312",
    dice_4 = "113365650364004",
    dice_5 = "72768312430593",
    dice_6 = "85376239182543",
    dices = "81268120302865",
    diff = "135052708609715",
    disc_2 = "91419420404185",
    disc_3 = "135470554736048",
    disc_album = "74693460404344",
    disc = "101908120120777",
    divide = "136678191878278",
    dna_off = "89612426361540",
    dna = "74007982981741",
    dock = "121997427160252",
    dog = "71920105558570",
    dollar_sign = "127320961224019",
    donut = "72204922742657",
    door_closed_locked = "74027613267551",
    door_closed = "136249099949073",
    door_open = "91306356501736",
    dot = "137321056643916",
    download = "134814648082393",
    drafting_compass = "99701976182841",
    drama = "110297795801577",
    dribbble = "80231809663849",
    drill = "108644821412796",
    drone = "117299095794783",
    droplet_off = "119365002225172",
    droplet = "100597455015098",
    droplets = "140111846025180",
    drum = "136979060344890",
    drumstick = "104662462521709",
    dumbbell = "80277236776212",
    ear_off = "87421916192807",
    ear = "121894949934209",
    earth_lock = "88814147073745",
    earth = "76231597751076",
    eclipse = "114829622118222",
    egg_fried = "90622538210545",
    egg_off = "92288321309285",
    egg = "117851493400222",
    ellipsis_vertical = "117978708573781",
    ellipsis = "140019550645825",
    equal_approximately = "105382689698323",
    equal_not = "76864449458032",
    equal = "123467780715624",
    eraser = "133957773112410",
    ethernet_port = "75391715149314",
    euro = "72229646524456",
    ev_charger = "97906158859623",
    expand = "137492887754537",
    external_link = "129331830773832",
    eye_closed = "111063268625789",
    eye_off = "135928786788378",
    eye = "100033680381365",
    facebook = "72098528632192",
    factory = "102170024318039",
    fan = "78391400440696",
    fast_forward = "121615540167909",
    feather = "91872927606406",
    fence = "123451565578029",
    ferris_wheel = "79729205796176",
    figma = "134182122852301",
    file_archive = "77018106869967",
    file_axis_3d = "133912328009885",
    file_badge = "74564895394477",
    file_box = "119264004071690",
    file_braces_corner = "77253337986109",
    file_braces = "95314128621234",
    file_chart_column_increasing = "134449481172067",
    file_chart_column = "82048481252560",
    file_chart_line = "71954360551345",
    file_chart_pie = "81072193564497",
    file_check_corner = "76295552859171",
    file_check = "82604001452455",
    file_clock = "102325208830990",
    file_code_corner = "78293841184371",
    file_code = "130978036895504",
    file_cog = "101385347151368",
    file_diff = "96147216772241",
    file_digit = "89220220354580",
    file_down = "120650154178290",
    file_exclamation_point = "102821865889635",
    file_headphone = "100533735901986",
    file_heart = "132214916401696",
    file_image = "123334057511782",
    file_input = "124728604166044",
    file_key = "118790255921100",
    file_lock = "72170228691242",
    file_minus_corner = "119263271735124",
    file_minus = "111014798459222",
    file_music = "134948051536671",
    file_output = "92146832572911",
    file_pen_line = "104622936345006",
    file_pen = "79556179730240",
    file_play = "89006821567838",
    file_plus_corner = "76544604043974",
    file_plus = "78881710800060",
    file_question_mark = "127617422859576",
    file_scan = "129480105228213",
    file_search_corner = "90974165234008",
    file_search = "97780235974933",
    file_signal = "122070252538165",
    file_sliders = "85787771732439",
    file_spreadsheet = "134501869359270",
    file_stack = "138929929862605",
    file_symlink = "91865722036510",
    file_terminal = "116757454755476",
    file_text = "90496405707281",
    file_type_corner = "124902230275209",
    file_type = "115272552799361",
    file_up = "131173039312748",
    file_user = "99552018455009",
    file_video_camera = "81719056173960",
    file_volume = "111264764438958",
    file_x_corner = "87554136773609",
    file_x = "107333775515154",
    file = "74748492079329",
    files = "102806336233202",
    film = "120978945609706",
    fingerprint = "112173305232811",
    fire_extinguisher = "111643493006960",
    fish_off = "89756724887508",
    fish_symbol = "118475177681618",
    fish = "124360663785796",
    flag_off = "112944528856799",
    flag_triangle_left = "88045221285272",
    flag_triangle_right = "108292480304566",
    flag = "78183383236196",
    flame_kindling = "139728976917928",
    flame = "98218034436456",
    flashlight_off = "79780362871740",
    flashlight = "100286985600444",
    flask_conical_off = "112597970025298",
    flask_conical = "128406680901165",
    flask_round = "127508287324940",
    flip_horizontal_2 = "103726993598186",
    flip_horizontal = "122937530107837",
    flip_vertical_2 = "103836358956328",
    flip_vertical = "108003917346888",
    flower_2 = "72934574245145",
    flower = "86129438272762",
    focus = "87493973153317",
    fold_horizontal = "92835712442240",
    fold_vertical = "108873727253656",
    folder_archive = "97312009460206",
    folder_check = "128492920904557",
    folder_clock = "111964836738545",
    folder_closed = "118286209350843",
    folder_code = "70624096349370",
    folder_cog = "85299519462846",
    folder_dot = "138687772725278",
    folder_down = "118044108459225",
    folder_git_2 = "101394054141166",
    folder_git = "121885778095158",
    folder_heart = "79104747211105",
    folder_input = "90699920697871",
    folder_kanban = "78313285104072",
    folder_key = "85270407596791",
    folder_lock = "119201572260567",
    folder_minus = "85648718999010",
    folder_open_dot = "74741494767354",
    folder_open = "76018996254888",
    folder_output = "101532447937612",
    folder_pen = "112770491173911",
    folder_plus = "91865663406119",
    folder_root = "103333751154693",
    folder_search_2 = "71276453442655",
    folder_search = "110568075123861",
    folder_symlink = "127485747227189",
    folder_sync = "91544602659796",
    folder_tree = "85577554337861",
    folder_up = "72008269765857",
    folder_x = "91699618247635",
    folder = "80846616596607",
    folders = "110351216219061",
    footprints = "139192589041315",
    forklift = "72030930983101",
    forward = "97545944739523",
    frame = "109080612832751",
    framer = "108384807262391",
    frown = "124407301067982",
    fuel = "106447647274511",
    fullscreen = "77793665526178",
    funnel_plus = "100780233821928",
    funnel_x = "70984385812555",
    funnel = "108829540827529",
    gallery_horizontal_end = "74672430161161",
    gallery_horizontal = "80004001442122",
    gallery_thumbnails = "136219289862706",
    gallery_vertical_end = "106461402088317",
    gallery_vertical = "119299431466725",
    gamepad_2 = "92483947987410",
    gamepad_directional = "84342305212226",
    gamepad = "121607283959010",
    gauge = "110273524101447",
    gavel = "78952298198456",
    gem = "112904952151156",
    georgian_lari = "98084432591687",
    ghost = "113822048130017",
    gift = "109855212076373",
    git_branch_minus = "97385010649411",
    git_branch_plus = "125944221134316",
    git_branch = "90490195516649",
    git_commit_horizontal = "133646041800147",
    git_commit_vertical = "122098032990350",
    git_compare_arrows = "84874426520216",
    git_compare = "91945124438792",
    git_fork = "89954992404765",
    git_graph = "86166832019304",
    git_merge = "131833355158059",
    git_pull_request_arrow = "94507974577439",
    git_pull_request_closed = "78070600389091",
    git_pull_request_create_arrow = "127422677061091",
    git_pull_request_create = "105929577383926",
    git_pull_request_draft = "76173459869943",
    git_pull_request = "138463010991471",
    github = "120349554354380",
    gitlab = "114054627192933",
    glass_water = "115526102400988",
    glasses = "87936407455373",
    globe_lock = "134065526704402",
    globe = "114238209622913",
    goal = "120517954878160",
    gpu = "95577823614219",
    graduation_cap = "93771896340220",
    grape = "134760640415561",
    grid_2x2_check = "138468840220821",
    grid_2x2_plus = "91811610580247",
    grid_2x2_x = "72407303981388",
    grid_2x2 = "99050491897640",
    grid_3x2 = "95528684210010",
    grid_3x3 = "70419024781206",
    grip_horizontal = "136255899715930",
    grip_vertical = "137183678565296",
    grip = "109058783556768",
    group = "107643418926671",
    guitar = "75915531867926",
    ham = "74465607934635",
    hamburger = "93086916815495",
    hammer = "83545120140895",
    hand_coins = "126990543175462",
    hand_fist = "83341608917591",
    hand_grab = "88867162163985",
    hand_heart = "117507367668412",
    hand_helping = "89897738419446",
    hand_metal = "113619498548713",
    hand_platter = "88594727743168",
    hand = "130703864968637",
    handbag = "135675846264061",
    handshake = "78442115255814",
    hard_drive_download = "73913801230614",
    hard_drive_upload = "85762133615118",
    hard_drive = "88183305858463",
    hard_hat = "128050846767382",
    hash = "82890331678520",
    hat_glasses = "101165538224815",
    haze = "108857561768901",
    hdmi_port = "103693661037020",
    heading_1 = "118129315662110",
    heading_2 = "110209069670094",
    heading_3 = "90267885237062",
    heading_4 = "129625620307602",
    heading_5 = "120386663181267",
    heading_6 = "90959079775093",
    heading = "129254312067735",
    headphone_off = "85038251615641",
    headphones = "118833729589183",
    headset = "129269236787694",
    heart_crack = "110987638564119",
    heart_handshake = "111483078692002",
    heart_minus = "96827380163326",
    heart_off = "89748414415617",
    heart_plus = "94877796283249",
    heart_pulse = "129352925579546",
    heart = "116559368303288",
    heater = "140478466880916",
    helicopter = "111557171735930",
    hexagon = "127592089339199",
    highlighter = "77411555641113",
    history = "123980022019922",
    hop_off = "103386036934034",
    hop = "82778923997672",
    hospital = "105868763850707",
    hotel = "132283390859718",
    hourglass = "86160434939203",
    house_heart = "136054771868597",
    house_plug = "71438263712075",
    house_plus = "118495165208309",
    house_wifi = "126495519725698",
    house = "98755624629571",
    ice_cream_bowl = "124867218454386",
    ice_cream_cone = "90751397288639",
    id_card_lanyard = "90761480469224",
    id_card = "75354294622640",
    image_down = "78972295741235",
    image_minus = "101066016918565",
    image_off = "81934811700938",
    image_play = "129501806784210",
    image_plus = "70391970623917",
    image_up = "126610009605241",
    image_upscale = "106963545024679",
    images = "79350649395557",
    import = "116545008906029",
    inbox = "112591360302868",
    indian_rupee = "113038778381805",
    infinity = "98083086936965",
    info = "124560466474914",
    inspection_panel = "70905313146088",
    instagram = "119864798614855",
    italic = "96220378864282",
    iteration_ccw = "140221832794083",
    iteration_cw = "95534489554662",
    japanese_yen = "106362863465813",
    joystick = "99416790224739",
    kanban = "125934100055431",
    kayak = "136107544609389",
    key_round = "83619031955390",
    key_square = "94621420033649",
    key = "96510194465420",
    keyboard_music = "121058541758636",
    keyboard_off = "92466375369772",
    keyboard = "121474456068237",
    lamp_ceiling = "80032758469141",
    lamp_desk = "85290686983238",
    lamp_floor = "104585881375892",
    lamp_wall_down = "91271394132073",
    lamp_wall_up = "132141464337445",
    lamp = "110730830653382",
    land_plot = "96449039620294",
    landmark = "76885079756393",
    languages = "90816903776498",
    laptop_minimal_check = "114352019833865",
    laptop_minimal = "136705765566068",
    laptop = "111387063244975",
    lasso_select = "105609719912753",
    lasso = "121072936884007",
    laugh = "104491311361166",
    layers_2 = "70536710516357",
    layers = "81973586053257",
    layout_dashboard = "139929981863901",
    layout_grid = "81344910161871",
    layout_list = "87462136296578",
    layout_panel_left = "125092469751491",
    layout_panel_top = "91943941515944",
    layout_template = "115564446417985",
    leaf = "119951075637174",
    leafy_green = "105146290493154",
    lectern = "106166425183862",
    library_big = "106794530191412",
    library = "114334671982047",
    life_buoy = "81168450671956",
    ligature = "111397873269411",
    lightbulb_off = "83795722296178",
    lightbulb = "103871245626488",
    line_squiggle = "109555164424447",
    link_2_off = "76885956296867",
    link_2 = "86072351557466",
    link = "131607023382430",
    linkedin = "132842789255788",
    list_check = "72374358471156",
    list_checks = "99809353635593",
    list_chevrons_down_up = "137409641500711",
    list_chevrons_up_down = "81825351389084",
    list_collapse = "124505247702401",
    list_end = "77650610048119",
    list_filter_plus = "96385120752336",
    list_filter = "103321376129527",
    list_indent_decrease = "137879979228193",
    list_indent_increase = "79051053161201",
    list_minus = "138507965142671",
    list_music = "126380635781840",
    list_ordered = "83212528113913",
    list_plus = "112384738137814",
    list_restart = "91703153577421",
    list_start = "84828348299727",
    list_todo = "132980603752108",
    list_tree = "97685396239010",
    list_video = "93648525452489",
    list_x = "113025303988861",
    list = "113179976918783",
    loader_circle = "116535712789945",
    loader_pinwheel = "108513357940900",
    loader = "78408734580845",
    locate_fixed = "137367361548433",
    locate_off = "73729216338137",
    locate = "84467676590391",
    lock_keyhole_open = "110863509313073",
    lock_keyhole = "78672912777756",
    lock_open = "93597915325122",
    lock = "134724289526879",
    log_in = "103768533135201",
    log_out = "84895399304975",
    logs = "89772091251787",
    lollipop = "84681611583044",
    luggage = "76619236486400",
    magnet = "135162361226972",
    mail_check = "86921536259917",
    mail_minus = "81989813236553",
    mail_open = "122785416858638",
    mail_plus = "104886401588341",
    mail_question_mark = "126540170949819",
    mail_search = "135616173775287",
    mail_warning = "81495303676089",
    mail_x = "74607841705644",
    mail = "103945161245599",
    mailbox = "82765503320335",
    mails = "90673453450080",
    map_minus = "129525760577747",
    map_pin_check_inside = "107130529843809",
    map_pin_check = "118110914690154",
    map_pin_house = "80546885029816",
    map_pin_minus_inside = "79005529692964",
    map_pin_minus = "74518762643623",
    map_pin_off = "82474689391020",
    map_pin_pen = "113515395277504",
    map_pin_plus_inside = "134639656514430",
    map_pin_plus = "91875228967029",
    map_pin_x_inside = "126235934252379",
    map_pin_x = "101085273547316",
    map_pin = "84279202219901",
    map_pinned = "103963788475034",
    map_plus = "129388826743495",
    map = "95107167260947",
    mars_stroke = "131973193186828",
    mars = "111287112372511",
    martini = "82977695401058",
    maximize_2 = "73085922906397",
    maximize = "76045941763188",
    medal = "79016002264450",
    megaphone_off = "124280774193935",
    megaphone = "118759541854879",
    meh = "132197867028557",
    memory_stick = "93212591343119",
    menu = "77021539815611",
    merge = "126201866476775",
    message_circle_code = "112865244991651",
    message_circle_dashed = "81525157881897",
    message_circle_heart = "101990756073677",
    message_circle_more = "92856823884663",
    message_circle_off = "134955643890328",
    message_circle_plus = "106562979649273",
    message_circle_question_mark = "107700302759934",
    message_circle_reply = "137071749508334",
    message_circle_warning = "119020096067894",
    message_circle_x = "126843387725536",
    message_circle = "127255077587058",
    message_square_code = "110968863152123",
    message_square_dashed = "107653455516238",
    message_square_diff = "75472190472625",
    message_square_dot = "127806382463916",
    message_square_heart = "75612811742074",
    message_square_lock = "81268215619563",
    message_square_more = "120139782405970",
    message_square_off = "99961019005789",
    message_square_plus = "76934450256199",
    message_square_quote = "116670768629340",
    message_square_reply = "130985622754637",
    message_square_share = "131017005324026",
    message_square_text = "94899503194205",
    message_square_warning = "138432903962261",
    message_square_x = "137285463279462",
    message_square = "83881670383280",
    messages_square = "97532166733358",
    mic_off = "82123034444822",
    mic_vocal = "99082286164362",
    mic = "89640799126523",
    microchip = "73937907669903",
    microscope = "116875530102782",
    microwave = "108411735353008",
    milestone = "101618292325920",
    milk_off = "72388480962742",
    milk = "96221903896918",
    minimize_2 = "116269596042539",
    minimize = "121304296213645",
    minus = "118026365011536",
    monitor_check = "86651948439229",
    monitor_cloud = "85931096038318",
    monitor_cog = "94345128715799",
    monitor_dot = "130394010063680",
    monitor_down = "97466933743423",
    monitor_off = "74395526657953",
    monitor_pause = "76002184067562",
    monitor_play = "133018824306217",
    monitor_smartphone = "84335680433378",
    monitor_speaker = "81744810060380",
    monitor_stop = "98708958984757",
    monitor_up = "96035360858377",
    monitor_x = "126265210441423",
    monitor = "72664649203050",
    moon_star = "82782200506348",
    moon = "83380517901735",
    motorbike = "94580787368233",
    mountain_snow = "105315495740588",
    mountain = "73269957566415",
    mouse_off = "75267871697595",
    mouse_pointer_2_off = "104701076865632",
    mouse_pointer_2 = "117093892862228",
    mouse_pointer_ban = "106849413057133",
    mouse_pointer_click = "107150227368485",
    mouse_pointer = "72322454962935",
    mouse = "73096068864710",
    move_3d = "103365982054003",
    move_diagonal_2 = "117298577948096",
    move_diagonal = "101433481954184",
    move_down_left = "102819433534567",
    move_down_right = "101479760041877",
    move_down = "70510115135583",
    move_horizontal = "88513523439149",
    move_left = "137614740247980",
    move_right = "132455779472989",
    move_up_left = "139079815540148",
    move_up_right = "105885140592646",
    move_up = "84505444262658",
    move_vertical = "86234730730899",
    move = "116138709011735",
    music_2 = "134397426600888",
    music_3 = "94466120066498",
    music_4 = "132459323665838",
    music = "113343203848535",
    navigation_2_off = "116569611780763",
    navigation_2 = "81889066747907",
    navigation_off = "87003270290777",
    navigation = "79308213542922",
    network = "127410729922644",
    newspaper = "123479530460544",
    nfc = "76822396542242",
    non_binary = "78442360386235",
    notebook_pen = "140380614761023",
    notebook_tabs = "127371085570083",
    notebook_text = "93061585217270",
    notebook = "136132108664987",
    notepad_text_dashed = "135793446376219",
    notepad_text = "93404682958966",
    nut_off = "78795397311573",
    nut = "127146410705656",
    octagon_alert = "140438367956051",
    octagon_minus = "74720436795421",
    octagon_pause = "103161463909039",
    octagon_x = "90498161006311",
    octagon = "120803515514852",
    omega = "70414080018786",
    option = "100776883894054",
    orbit = "108926136860562",
    origami = "136020626667101",
    package_2 = "70394974762575",
    package_check = "102374216055130",
    package_minus = "114492858789692",
    package_open = "132890233237818",
    package_plus = "129261988138366",
    package_search = "95465120894145",
    package_x = "70818501607442",
    package = "97261141732706",
    paint_bucket = "124275586663284",
    paint_roller = "115248074358348",
    paintbrush_vertical = "105151296591292",
    paintbrush = "125572663700289",
    palette = "86350350950064",
    panda = "132509022802512",
    panel_bottom_close = "74287004071159",
    panel_bottom_dashed = "131084651621603",
    panel_bottom_open = "107768659586540",
    panel_bottom = "132127145048511",
    panel_left_close = "126579818823552",
    panel_left_dashed = "75536606374585",
    panel_left_open = "111075816195767",
    panel_left_right_dashed = "110100707973959",
    panel_left = "97419752870313",
    panel_right_close = "139528655524132",
    panel_right_dashed = "94959793877311",
    panel_right_open = "118114419142794",
    panel_right = "116365035443156",
    panel_top_bottom_dashed = "134737235653344",
    panel_top_close = "83578325777808",
    panel_top_dashed = "70522913169237",
    panel_top_open = "137959875507454",
    panel_top = "75838479462875",
    panels_left_bottom = "72996856149149",
    panels_right_bottom = "90659068960726",
    panels_top_left = "79858853850600",
    paperclip = "92088291163453",
    parentheses = "78950955173096",
    parking_meter = "84652733960568",
    party_popper = "111626795712193",
    pause = "74873705394436",
    paw_print = "112218825427601",
    pc_case = "122978648019101",
    pen_line = "109108135755303",
    pen_off = "84807123119438",
    pen_tool = "106145404953445",
    pen = "72037878096321",
    pencil_line = "88392917053533",
    pencil_off = "103330927652832",
    pencil_ruler = "110120288284597",
    pencil = "137986121120732",
    pentagon = "79184802179890",
    percent = "130155041032013",
    person_standing = "125020872044147",
    philippine_peso = "91173798254675",
    phone_call = "70555587592860",
    phone_forwarded = "113269614319737",
    phone_incoming = "82863576359288",
    phone_missed = "130156165198376",
    phone_off = "133318623553383",
    phone_outgoing = "104576478735825",
    phone = "128804946640049",
    pi = "74936036243146",
    piano = "85008880789520",
    pickaxe = "105888023317688",
    picture_in_picture_2 = "112803319544468",
    picture_in_picture = "80579597835123",
    piggy_bank = "79498575790721",
    pilcrow_left = "103803000849583",
    pilcrow_right = "104881733911870",
    pilcrow = "139512780392871",
    pill_bottle = "118394692404597",
    pill = "73280534813448",
    pin_off = "127696372451750",
    pin = "120978111007514",
    pipette = "133167932934404",
    pizza = "126964453193501",
    plane_landing = "122555692211889",
    plane_takeoff = "117179478829575",
    plane = "126985561580989",
    play = "135609604299893",
    plug_2 = "97912386476366",
    plug_zap = "74506269884055",
    plug = "99782373064495",
    plus = "111774323017047",
    pocket_knife = "134075428063965",
    pocket = "136686762542964",
    podcast = "109577075549215",
    pointer_off = "95488389312794",
    pointer = "92615117311099",
    popcorn = "139446511232750",
    popsicle = "112696318077073",
    pound_sterling = "127482649469130",
    power_off = "118768311012214",
    power = "96479131758775",
    presentation = "106134583757890",
    printer_check = "130273549443689",
    printer = "76080649734247",
    projector = "103281856385283",
    proportions = "130046855997237",
    puzzle = "136837798892463",
    pyramid = "107811442374127",
    qr_code = "105329945723350",
    quote = "103271711590001",
    rabbit = "98580518804206",
    radar = "138528222906635",
    radiation = "104499586848433",
    radical = "132758286926047",
    radio_receiver = "129598303378835",
    radio_tower = "93958663130054",
    radio = "85611589536956",
    radius = "89814505307129",
    rail_symbol = "134295386306962",
    rainbow = "132488862841895",
    rat = "127400975953159",
    ratio = "126369423897295",
    receipt_cent = "91557573925201",
    receipt_euro = "94015722210295",
    receipt_indian_rupee = "89718170439990",
    receipt_japanese_yen = "132472560758851",
    receipt_pound_sterling = "73934967569625",
    receipt_russian_ruble = "105164576936853",
    receipt_swiss_franc = "72503668620116",
    receipt_text = "138483536013737",
    receipt_turkish_lira = "91950765836342",
    receipt = "77877895901792",
    rectangle_circle = "100642423153903",
    rectangle_ellipsis = "112919953980965",
    rectangle_goggles = "98605436666727",
    rectangle_horizontal = "90224199814966",
    rectangle_vertical = "117277050590967",
    recycle = "140417023381961",
    redo_2 = "70451039017914",
    redo_dot = "94252981719732",
    redo = "116150342119054",
    refresh_ccw_dot = "106702246753270",
    refresh_ccw = "117913330389477",
    refresh_cw_off = "140179498843054",
    refresh_cw = "138133190015277",
    refrigerator = "102614042652753",
    regex = "100727200791841",
    remove_formatting = "112833162022628",
    repeat_1 = "130144534857095",
    repeat_2 = "85927537182704",
    repeat = "121886242955173",
    replace_all = "127862728198635",
    replace = "128404082279430",
    reply_all = "71723137343562",
    reply = "109788633497028",
    rewind = "95205297521988",
    ribbon = "94265331526851",
    rocket = "87412317685854",
    rocking_chair = "110420269495360",
    roller_coaster = "112426178972099",
    rose = "126336840238769",
    rotate_3d = "76300551576392",
    rotate_ccw_key = "74976035240976",
    rotate_ccw_square = "90515853170424",
    rotate_ccw = "110116685948665",
    rotate_cw_square = "77095448159303",
    rotate_cw = "84183336178654",
    route_off = "106350402024079",
    route = "89968303228953",
    router = "102130331994471",
    rows_2 = "112556185960101",
    rows_3 = "117215586961375",
    rows_4 = "125646021959055",
    rss = "131789058984793",
    ruler_dimension_line = "70673861371412",
    ruler = "81432445547423",
    russian_ruble = "126357936542156",
    sailboat = "87110567187540",
    salad = "128864507821603",
    sandwich = "104573187458917",
    satellite_dish = "136742443888305",
    satellite = "134967053164645",
    saudi_riyal = "102282769104635",
    save_all = "116946975799440",
    save_off = "87085435778560",
    save = "126116963775616",
    scale_3d = "72414199620352",
    scale = "108203682317477",
    scaling = "122360365318466",
    scan_barcode = "96889457154761",
    scan_eye = "99244790601968",
    scan_face = "109959345069668",
    scan_heart = "106280819776142",
    scan_line = "126544908146540",
    scan_qr_code = "105409149549927",
    scan_search = "80009010551347",
    scan_text = "73702396787766",
    scan = "123104789658180",
    school = "76351530290068",
    scissors_line_dashed = "122237447974173",
    scissors = "118665510911274",
    screen_share_off = "107677572669805",
    screen_share = "85137895705653",
    scroll_text = "97321022666868",
    scroll = "74072101474951",
    search_check = "75442076191356",
    search_code = "117114794592802",
    search_slash = "96483932261041",
    search_x = "137319957522951",
    search = "121018724060431",
    section = "91732188298948",
    send_horizontal = "111734392411664",
    send_to_back = "75340312862253",
    send = "127751956873796",
    separator_horizontal = "84864453699927",
    separator_vertical = "84031801478581",
    server_cog = "138470287250966",
    server_crash = "132810618000212",
    server_off = "114048751507723",
    server = "92188766517878",
    settings_2 = "135684703553372",
    settings = "80758916183665",
    shapes = "129989433311409",
    share_2 = "71210767962065",
    share = "87340985053299",
    sheet = "134902122480171",
    shell = "140212943563599",
    shield_alert = "114995877719925",
    shield_ban = "108765041044649",
    shield_check = "87354736164608",
    shield_ellipsis = "114794739892123",
    shield_half = "117842634172647",
    shield_minus = "89965059528921",
    shield_off = "133426959132690",
    shield_plus = "100664857995498",
    shield_question_mark = "135722075265150",
    shield_user = "124832775645347",
    shield_x = "73370117343811",
    shield = "110987169760162",
    ship_wheel = "130797795829448",
    ship = "83995100553930",
    shirt = "106579555405966",
    shopping_bag = "71885477293226",
    shopping_basket = "138646411956433",
    shopping_cart = "128420521375441",
    shovel = "102465000512056",
    shower_head = "75884944024117",
    shredder = "122125164414463",
    shrimp = "102625900815307",
    shrink = "90953687918880",
    shrub = "127326280714343",
    shuffle = "132382786975101",
    sigma = "126884244870899",
    signal_high = "130436670012270",
    signal_low = "73674683500458",
    signal_medium = "125003021367019",
    signal_zero = "130045332414754",
    signal = "78424889355261",
    signature = "114402748013000",
    signpost_big = "115780185675001",
    signpost = "106584743791433",
    siren = "134210267818039",
    skip_back = "70466132711334",
    skip_forward = "124844823753990",
    skull = "137726256442333",
    slack = "96089719516736",
    slash = "117792185664263",
    slice = "95810504278179",
    sliders_horizontal = "85538382643347",
    sliders_vertical = "101190569086853",
    smartphone_charging = "102837532613995",
    smartphone_nfc = "82326425754446",
    smartphone = "96623008834511",
    smile_plus = "131981881472144",
    smile = "105880397565283",
    snail = "70904536548363",
    snowflake = "101235206534566",
    soap_dispenser_droplet = "77258480479465",
    sofa = "114427687218324",
    solar_panel = "132448188047921",
    soup = "115092551871618",
    space = "87072088914178",
    spade = "131444449466462",
    sparkle = "111044800239623",
    sparkles = "138635884129147",
    speaker = "96227183003618",
    speech = "87013139446349",
    spell_check_2 = "81556731785534",
    spell_check = "91913483031334",
    spline_pointer = "84842840956804",
    spline = "129406685807412",
    split = "105112438805988",
    spool = "124541981347743",
    spotlight = "77571742539344",
    spray_can = "128372039366326",
    sprout = "100091687832508",
    square_activity = "89496630185293",
    square_arrow_down_left = "108194680296901",
    square_arrow_down_right = "99403846801050",
    square_arrow_down = "135962519626588",
    square_arrow_left = "111671474549238",
    square_arrow_out_down_left = "125714881756353",
    square_arrow_out_down_right = "89971003001390",
    square_arrow_out_up_left = "103759986579087",
    square_arrow_out_up_right = "91221896066807",
    square_arrow_right = "113920471701361",
    square_arrow_up_left = "112424670290693",
    square_arrow_up_right = "76602291406940",
    square_arrow_up = "106998604646718",
    square_asterisk = "89186832353625",
    square_bottom_dashed_scissors = "79076980104803",
    square_chart_gantt = "104034017316411",
    square_check_big = "115320390907184",
    square_check = "134682053539509",
    square_chevron_down = "91032307924592",
    square_chevron_left = "73143404829510",
    square_chevron_right = "90612077729930",
    square_chevron_up = "85565910197337",
    square_code = "81604576616881",
    square_dashed_bottom_code = "100354801563230",
    square_dashed_bottom = "101102319625624",
    square_dashed_kanban = "90388067649847",
    square_dashed_mouse_pointer = "121016142178467",
    square_dashed_top_solid = "117157577548540",
    square_dashed = "136905537847606",
    square_divide = "99894657101970",
    square_dot = "116613421354866",
    square_equal = "110283363706707",
    square_function = "86075219551088",
    square_kanban = "114537101260131",
    square_library = "73810931222081",
    square_m = "117662700410577",
    square_menu = "104067089444415",
    square_minus = "116764432015770",
    square_mouse_pointer = "76141850603920",
    square_parking_off = "100857293535141",
    square_parking = "133116656122387",
    square_pause = "86608552787615",
    square_pen = "120239476110475",
    square_percent = "87111930314567",
    square_pi = "75383328781618",
    square_pilcrow = "131854284699367",
    square_play = "108186325238481",
    square_plus = "114713264461873",
    square_power = "129240437805187",
    square_radical = "132645931868292",
    square_round_corner = "104592745113567",
    square_scissors = "110601255612411",
    square_sigma = "113231244246816",
    square_slash = "105477013908757",
    square_split_horizontal = "76095370148660",
    square_split_vertical = "88589192032058",
    square_square = "136555087357875",
    square_stack = "100463396619394",
    square_star = "94506958703720",
    square_stop = "80018708472943",
    square_terminal = "83969264476798",
    square_user_round = "86484997229302",
    square_user = "70771214183445",
    square_x = "125136183850190",
    square = "86304921356806",
    squares_exclude = "102345385822324",
    squares_intersect = "120869602570119",
    squares_subtract = "131484650948795",
    squares_unite = "96673080107843",
    squircle_dashed = "129936702532522",
    squircle = "82426632573807",
    squirrel = "112864252085343",
    stamp = "92370779813368",
    star_half = "117449275562979",
    star_off = "75742832732503",
    star = "136141469398409",
    step_back = "108672750005121",
    step_forward = "126131872136145",
    stethoscope = "122331031702148",
    sticker = "79938203791608",
    sticky_note = "111894074643919",
    store = "90338129673705",
    stretch_horizontal = "87665042192343",
    stretch_vertical = "95265463417122",
    strikethrough = "103417324549613",
    subscript = "74553514785183",
    sun_dim = "129141645592715",
    sun_medium = "130278807964710",
    sun_moon = "75752898854559",
    sun_snow = "112791898014579",
    sun = "110150589884127",
    sunrise = "134705665494098",
    sunset = "75904872203588",
    superscript = "96887696590118",
    swatch_book = "126786244872453",
    swiss_franc = "113497920041625",
    switch_camera = "76841154349737",
    sword = "124448418211665",
    swords = "81872698913435",
    syringe = "123891270479254",
    table_2 = "95751552281545",
    table_cells_merge = "95363715175258",
    table_cells_split = "114799086088649",
    table_columns_split = "111011625447949",
    table_of_contents = "135044763275414",
    table_properties = "125062886015372",
    table_rows_split = "96443733673997",
    table = "109109148250737",
    tablet_smartphone = "133680859813404",
    tablet = "128403991264386",
    tablets = "80835787970735",
    tag = "129104970103940",
    tags = "107179263080798",
    tally_1 = "115301298241643",
    tally_2 = "110363186864027",
    tally_3 = "97655344572540",
    tally_4 = "102633494371890",
    tally_5 = "88031817475886",
    tangent = "123263132981724",
    target = "87563802520297",
    telescope = "91755049143647",
    tent_tree = "76698322463977",
    tent = "109779587826330",
    terminal = "106783148545356",
    test_tube_diagonal = "75662704378840",
    test_tube = "98801015650164",
    test_tubes = "92555361447433",
    text_align_center = "84051028246390",
    text_align_end = "130041738343555",
    text_align_justify = "80279880143030",
    text_align_start = "134489585487649",
    text_cursor_input = "107551944047171",
    text_cursor = "115984654447300",
    text_initial = "129458097472087",
    text_quote = "139278366448736",
    text_search = "92345384671606",
    text_select = "117087320884956",
    text_wrap = "114804318314018",
    theater = "108558145549163",
    thermometer_snowflake = "121876188028425",
    thermometer_sun = "106693240074310",
    thermometer = "106546011492311",
    thumbs_down = "87794009914015",
    thumbs_up = "111137070767020",
    ticket_check = "105428777212507",
    ticket_minus = "78966299769328",
    ticket_percent = "80834774406405",
    ticket_plus = "110086734392189",
    ticket_slash = "89045681172265",
    ticket_x = "88674114109926",
    ticket = "126527071492145",
    tickets_plane = "100367018248695",
    tickets = "135268612687833",
    timer_off = "110916370767271",
    timer_reset = "110052125369932",
    timer = "85473888890506",
    toggle_left = "85887872573050",
    toggle_right = "90411952142550",
    toilet = "80930782432931",
    tool_case = "87533537832522",
    tornado = "88358291515768",
    torus = "70855707283051",
    touchpad_off = "78784008075456",
    touchpad = "74882354908014",
    tower_control = "95937619060532",
    toy_brick = "86293483924633",
    tractor = "103376704722051",
    traffic_cone = "74110220470369",
    train_front_tunnel = "105194827005114",
    train_front = "125237934215370",
    train_track = "77451032453723",
    tram_front = "93315182364998",
    transgender = "135530817673639",
    trash_2 = "109843431391323",
    trash = "106723740584310",
    tree_deciduous = "123124389219004",
    tree_palm = "103846705893963",
    tree_pine = "124662547202594",
    trees = "121203841375919",
    trello = "130987241149527",
    trending_down = "139309232226438",
    trending_up_down = "85083293981691",
    trending_up = "81819858538839",
    triangle_alert = "125920361880643",
    triangle_dashed = "124324079103935",
    triangle_right = "116930791412791",
    triangle = "126330486745540",
    trophy = "131545003268773",
    truck_electric = "111873446387359",
    truck = "86662707764771",
    turkish_lira = "114589876174070",
    turntable = "129870346487856",
    turtle = "118295081560334",
    tv_minimal_play = "99201833426972",
    tv_minimal = "100382201729427",
    tv = "135687724791776",
    twitch = "71383308134888",
    twitter = "88791703276842",
    type_outline = "80108627791690",
    type = "133543553793564",
    umbrella_off = "72395143739955",
    umbrella = "127502210274589",
    underline = "123709229216544",
    undo_2 = "113885292059932",
    undo_dot = "132055277744844",
    undo = "111258459077271",
    unfold_horizontal = "117128358526398",
    unfold_vertical = "116593025265499",
    ungroup = "106674800451003",
    university = "84652528263642",
    unlink_2 = "128131898892572",
    unlink = "139835795227752",
    unplug = "90171381619874",
    upload = "138212042425501",
    usb = "117230058949613",
    user_check = "81775205032725",
    user_cog = "92795491530865",
    user_lock = "78892639693821",
    user_minus = "126976941957511",
    user_pen = "87445472574836",
    user_plus = "118514469915884",
    user_round_check = "118794737621941",
    user_round_cog = "78239503290053",
    user_round_minus = "98944176636447",
    user_round_pen = "108155244324878",
    user_round_plus = "113301899567470",
    user_round_search = "71565774381870",
    user_round_x = "122367980560930",
    user_round = "136485052187963",
    user_search = "101335649828115",
    user_star = "98777846316000",
    user_x = "139748155894754",
    user = "81589895647169",
    users_round = "103005444008339",
    users = "115398113982385",
    utensils_crossed = "109520762270383",
    utensils = "139952569804235",
    utility_pole = "101965541238242",
    variable = "104743088438151",
    vault = "108049164599845",
    vector_square = "86713728565344",
    vegan = "119489190688082",
    venetian_mask = "102636443033920",
    venus_and_mars = "120227752103771",
    venus = "82891342220859",
    vibrate_off = "113446447326246",
    vibrate = "108330910738733",
    video_off = "132239189859305",
    video = "107587444636945",
    videotape = "114816894323398",
    view = "118717253976805",
    voicemail = "134313454010227",
    volleyball = "83889351124153",
    volume_1 = "98514588731639",
    volume_2 = "89344380902620",
    volume_off = "103047478058767",
    volume_x = "139252359189540",
    volume = "103236289817396",
    vote = "89409762851246",
    wallet_cards = "129728715308337",
    wallet_minimal = "137800448816116",
    wallet = "132331555762628",
    wallpaper = "74682121235494",
    wand_sparkles = "82546429942392",
    wand = "114580617777835",
    warehouse = "78388887451080",
    washing_machine = "104194127573858",
    watch = "130544621618405",
    waves_ladder = "101808619355514",
    waves = "96340135183647",
    waypoints = "102450133666017",
    webcam = "104148487911129",
    webhook_off = "96370548093471",
    webhook = "112812457747322",
    weight = "103860559844854",
    wheat_off = "133294844612307",
    wheat = "85261952080359",
    whole_word = "90111083954485",
    wifi_cog = "110500263326209",
    wifi_high = "81954601342139",
    wifi_low = "138217335635913",
    wifi_off = "74113634330106",
    wifi_pen = "91290205064712",
    wifi_sync = "84043971055177",
    wifi_zero = "124286465246123",
    wifi = "104669375183960",
    wind_arrow_down = "127753987414870",
    wind = "114551690399915",
    wine_off = "108294164302317",
    wine = "115743721332829",
    workflow = "99186544029189",
    worm = "115752311548091",
    wrench = "112148279212860",
    x = "110786993356448",
    youtube = "123663668456341",
    zap_off = "81385483183652",
    zap = "130551565616516",
    zoom_in = "127956924984803",
    zoom_out = "108334162607319",
}

--// THEME & CONFIG
local Theme = {
    Main = Color3.fromRGB(18, 18, 22),
    Sidebar = Color3.fromRGB(25, 25, 30),
    Section = Color3.fromRGB(28, 28, 33),
    Accent = Color3.fromRGB(0, 255, 127),     -- Ядовитый Неон
    TextMain = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(145, 145, 155),
    Stroke = Color3.fromRGB(45, 45, 50),
    Glow = "rbxassetid://4996891970",
    Font = Enum.Font.GothamBold
}

--// UTILITY
local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    return obj
end

local function MakeDraggable(topbar, object)
    local Dragging, DragInput, DragStart, StartPos
    
    topbar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = object.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then Dragging = false end
            end)
        end
    end)
    
    topbar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - DragStart
            TweenService:Create(object, TweenInfo.new(0.05), {
                Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
            }):Play()
        end
    end)
end

--// LIBRARY START
function Library:Window(name)
    local Window = {}
    
    -- ScreenGui
    local ScreenGui = Create("ScreenGui", {
        Name = "EternesusUltimate",
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or CoreGui,
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    -- TOOLTIP SYSTEM
    local Tooltip = Create("Frame", {
        Name = "Tooltip",
        Parent = ScreenGui,
        BackgroundColor3 = Color3.fromRGB(35, 35, 40),
        Size = UDim2.new(0, 0, 0, 24),
        AutomaticSize = Enum.AutomaticSize.X,
        Visible = false,
        ZIndex = 100
    })
    Create("UICorner", {Parent = Tooltip, CornerRadius = UDim.new(0, 4)})
    Create("UIStroke", {Parent = Tooltip, Color = Theme.Accent, Thickness = 1})
    local TooltipText = Create("TextLabel", {
        Parent = Tooltip,
        BackgroundTransparency = 1,
        TextColor3 = Theme.TextMain,
        TextSize = 12,
        Font = Enum.Font.Gotham,
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X
    })
    Create("UIPadding", {Parent = Tooltip, PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8)})

    RunService.RenderStepped:Connect(function()
        if Tooltip.Visible then
            local mPos = UserInputService:GetMouseLocation()
            Tooltip.Position = UDim2.new(0, mPos.X + 15, 0, mPos.Y + 15)
        end
    end)

    local function AddTooltip(obj, text)
        obj.MouseEnter:Connect(function()
            TooltipText.Text = text
            Tooltip.Visible = true
        end)
        obj.MouseLeave:Connect(function()
            Tooltip.Visible = false
        end)
    end

    -- Auto-Detect Screen Size
    local Viewport = Camera.ViewportSize
    local StartSize = UDim2.new(0, 700, 0, 500)
    
    if Viewport.X < 800 then
        StartSize = UDim2.new(0.7, 0, 0.6, 0)
    end

    -- Main Frame
    local Main = Create("Frame", {
        Name = "Main",
        Parent = ScreenGui,
        BackgroundColor3 = Theme.Main,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        Size = StartSize,
        ClipsDescendants = true
    })
    Create("UICorner", {Parent = Main, CornerRadius = UDim.new(0, 8)})
    Create("UIStroke", {Parent = Main, Color = Theme.Stroke, Thickness = 1})

    -- Glow
    local Glow = Create("ImageLabel", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, -15, 0, -15),
        Size = UDim2.new(1, 30, 1, 30),
        ZIndex = 0,
        Image = Theme.Glow,
        ImageColor3 = Theme.Accent,
        ImageTransparency = 0.6,
        ScaleType = Enum.ScaleType.Slice,
        SliceCenter = Rect.new(20, 20, 280, 280)
    })

    -- Sidebar (Background only)
    local Sidebar = Create("Frame", {
        Parent = Main,
        BackgroundColor3 = Theme.Sidebar,
        Size = UDim2.new(0, 180, 1, 0),
        ZIndex = 1 
    })
    Create("UICorner", {Parent = Sidebar, CornerRadius = UDim.new(0, 8)})
    Create("Frame", {Parent = Sidebar, BackgroundColor3 = Theme.Sidebar, Size = UDim2.new(0, 10, 1, 0), Position = UDim2.new(1, -10, 0, 0), BorderSizePixel = 0})

    -- Title
    local Title = Create("TextLabel", {
        Parent = Main, 
        Text = name,
        Font = Enum.Font.GothamBlack,
        TextColor3 = Theme.Accent,
        TextSize = 22,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 200, 0, 60),
        Position = UDim2.new(0, 0, 0, 5),
        ZIndex = 10,
        TextXAlignment = Enum.TextXAlignment.Center
    })

    -- Drag Area
    local TopbarArea = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 60),
        ZIndex = 15
    })
    MakeDraggable(TopbarArea, Main)

    -- WINDOW CONTROLS
    local ControlHolder = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 60, 0, 30),
        Position = UDim2.new(1, -65, 0, 15), 
        ZIndex = 20
    })
    
    local MinBtn = Create("ImageButton", {
        Parent = ControlHolder,
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926307971",
        ImageRectOffset = Vector2.new(884, 284),
        ImageRectSize = Vector2.new(36, 36),
        ImageColor3 = Theme.TextDim,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 0, 0, 0)
    })

    local CloseBtn = Create("ImageButton", {
        Parent = ControlHolder,
        BackgroundTransparency = 1,
        Image = "rbxassetid://3926305904",
        ImageRectOffset = Vector2.new(284, 4),
        ImageRectSize = Vector2.new(24, 24),
        ImageColor3 = Theme.TextDim,
        Size = UDim2.new(0, 24, 0, 24),
        Position = UDim2.new(0, 30, 0, 0)
    })

    local ContentArea -- Forward decl
    local Minimized = false
    local OldSize = Main.Size
    
    MinBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            OldSize = Main.Size
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 250, 0, 60)}):Play()
            Sidebar.Visible = false
            if ContentArea then ContentArea.Visible = false end
            Title.Position = UDim2.new(0, 10, 0, 0)
            Title.TextXAlignment = Enum.TextXAlignment.Left
        else
            TweenService:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Size = OldSize}):Play()
            task.wait(0.2)
            Sidebar.Visible = true
            if ContentArea then ContentArea.Visible = true end
            Title.Position = UDim2.new(0, 0, 0, 5)
            Title.TextXAlignment = Enum.TextXAlignment.Center
        end
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        TweenService:Create(Main, TweenInfo.new(0.2), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
        wait(0.2)
        ScreenGui:Destroy()
    end)
    
    CloseBtn.MouseEnter:Connect(function() CloseBtn.ImageColor3 = Color3.fromRGB(255, 80, 80) end)
    CloseBtn.MouseLeave:Connect(function() CloseBtn.ImageColor3 = Theme.TextDim end)

    -- RESIZE HANDLE
    local ResizeHandle = Create("TextButton", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 1, -20),
        Text = "◢",
        Font = Enum.Font.Gotham,
        TextSize = 20,
        TextColor3 = Theme.TextDim,
        ZIndex = 50,
        AutoButtonColor = false
    })

    local Resizing = false
    local ResizeStartPos, ResizeStartSize

    ResizeHandle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and not Minimized then
            Resizing = true
            ResizeStartPos = input.Position
            ResizeStartSize = Main.AbsoluteSize
            ResizeHandle.TextColor3 = Theme.Accent
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Resizing and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local Delta = input.Position - ResizeStartPos
            local NewX = math.max(500, ResizeStartSize.X + Delta.X)
            local NewY = math.max(350, ResizeStartSize.Y + Delta.Y)
            Main.Size = UDim2.new(0, NewX, 0, NewY)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Resizing = false
            ResizeHandle.TextColor3 = Theme.TextDim
        end
    end)

    -- // PLAYER PROFILE (NEW)
    local ProfileFrame = Create("Frame", {
        Parent = Sidebar,
        BackgroundColor3 = Theme.Section,
        Size = UDim2.new(0, 160, 0, 50),
        Position = UDim2.new(0, 10, 1, -60),
        ZIndex = 5
    })
    Create("UICorner", {Parent = ProfileFrame, CornerRadius = UDim.new(0, 6)})
    Create("UIStroke", {Parent = ProfileFrame, Color = Theme.Stroke, Thickness = 1})

    local AvatarImg = Create("ImageLabel", {
        Parent = ProfileFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 34, 0, 34),
        Position = UDim2.new(0, 8, 0, 8),
        Image = "rbxassetid://0" -- Placeholder
    })
    Create("UICorner", {Parent = AvatarImg, CornerRadius = UDim.new(1, 0)})
    
    -- Async load avatar
    task.spawn(function()
        local content = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
        AvatarImg.Image = content
    end)

    local PName = Create("TextLabel", {
        Parent = ProfileFrame,
        Text = LocalPlayer.DisplayName,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMain,
        TextSize = 12,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -55, 0, 16),
        Position = UDim2.new(0, 50, 0, 8),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    local PUser = Create("TextLabel", {
        Parent = ProfileFrame,
        Text = "@" .. LocalPlayer.Name,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextDim,
        TextSize = 10,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -55, 0, 14),
        Position = UDim2.new(0, 50, 0, 24),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTruncate = Enum.TextTruncate.AtEnd
    })

    -- Tab Container (Уменьшили размер, чтобы вместить профиль)
    local TabContainer = Create("ScrollingFrame", {
        Parent = Sidebar,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 80),
        Size = UDim2.new(1, 0, 1, -150), -- Изменено с -80 на -150
        ScrollBarThickness = 0,
        CanvasSize = UDim2.new(0,0,0,0),
        ZIndex = 2
    })
    local TabList = Create("UIListLayout", {Parent = TabContainer, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 5)})

    -- Content Area
    ContentArea = Create("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 190, 0, 10),
        Size = UDim2.new(1, -200, 1, -20),
        ClipsDescendants = true
    })

    local Tabs = {}
    local FirstTab = true
    local CurrentTab = nil

    function Window:Tab(text, icon)
        --// АВТОМАТИЧЕСКАЯ ЗАМЕНА ИКОНКИ ПО НАЗВАНИЮ
        if icon and Icons[icon] then
            icon = Icons[icon]
        end

        local Tab = {}
        local TabBtn = Create("TextButton", {
            Parent = TabContainer,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 42),
            Text = "",
            AutoButtonColor = false,
            ZIndex = 3
        })

        local TabLabel = Create("TextLabel", {
            Parent = TabBtn,
            Text = text,
            Font = Enum.Font.GothamMedium,
            TextColor3 = Theme.TextDim,
            TextSize = 14,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -45, 1, 0),
            Position = UDim2.new(0, 45, 0, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3
        })

        local Indicator = Create("Frame", {
            Parent = TabBtn,
            BackgroundColor3 = Theme.Accent,
            Size = UDim2.new(0, 3, 0, 24),
            Position = UDim2.new(0, 0, 0.5, -12),
            BackgroundTransparency = 1,
            ZIndex = 3
        })

        if icon then
            Create("ImageLabel", {
                Parent = TabBtn,
                Image = "rbxassetid://"..icon,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(0, 15, 0.5, -10),
                ImageColor3 = Theme.TextDim,
                ZIndex = 3
            })
        end

        local PageFrame = Create("Frame", {
            Parent = ContentArea,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Visible = false
        })

        local SubTabContainer = Create("Frame", {
            Parent = PageFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 35),
            Visible = false
        })
        local SubTabList = Create("UIListLayout", {
            Parent = SubTabContainer,
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Padding = UDim.new(0, 10)
        })

        local RealContent = Create("Frame", {
            Parent = PageFrame,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
        })

        local function Activate()
            if CurrentTab then
                TweenService:Create(CurrentTab.Label, TweenInfo.new(0.3), {TextColor3 = Theme.TextDim}):Play()
                TweenService:Create(CurrentTab.Ind, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
                CurrentTab.Page.Visible = false
            end
            CurrentTab = {Label = TabLabel, Ind = Indicator, Page = PageFrame}
            TweenService:Create(TabLabel, TweenInfo.new(0.3), {TextColor3 = Theme.TextMain}):Play()
            TweenService:Create(Indicator, TweenInfo.new(0.3), {BackgroundTransparency = 0}):Play()
            PageFrame.Visible = true
        end
        TabBtn.MouseButton1Click:Connect(Activate)
        if FirstTab then Activate(); FirstTab = false end

        local function CreateContentPage(parent)
            local Scroll = Create("ScrollingFrame", {
                Parent = parent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                ScrollBarThickness = 2,
                ScrollBarImageColor3 = Theme.Accent,
                CanvasSize = UDim2.new(0,0,0,0)
            })
            
            local Layout = Create("UIListLayout", {
                Parent = Scroll,
                FillDirection = Enum.FillDirection.Horizontal,
                SortOrder = Enum.SortOrder.LayoutOrder,
                Padding = UDim.new(0, 15)
            })
            
            local LeftCol = Create("Frame", {Parent = Scroll, BackgroundTransparency = 1, Size = UDim2.new(0.5, -8, 1, 0)})
            local LeftList = Create("UIListLayout", {Parent = LeftCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})
            
            local RightCol = Create("Frame", {Parent = Scroll, BackgroundTransparency = 1, Size = UDim2.new(0.5, -8, 1, 0)})
            local RightList = Create("UIListLayout", {Parent = RightCol, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 12)})

            local function UpdateCanvas()
                Scroll.CanvasSize = UDim2.new(0, 0, 0, math.max(LeftList.AbsoluteContentSize.Y, RightList.AbsoluteContentSize.Y) + 20)
            end
            LeftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)
            RightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateCanvas)

            return {Left = LeftCol, Right = RightCol, LList = LeftList, RList = RightList}
        end

        local DefaultPageObj = CreateContentPage(RealContent)
        
        local SubTabCount = 0
        local CurrentSubTab = nil
        function Tab:SubTab(subName)
            if SubTabCount == 0 then
                SubTabContainer.Visible = true
                RealContent.Position = UDim2.new(0, 0, 0, 40)
                RealContent.Size = UDim2.new(1, 0, 1, -40)
                for _, v in pairs(RealContent:GetChildren()) do v:Destroy() end
            end
            SubTabCount = SubTabCount + 1

            local SubBtn = Create("TextButton", {
                Parent = SubTabContainer,
                Text = subName,
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.TextDim,
                TextSize = 13,
                BackgroundColor3 = Theme.Section,
                Size = UDim2.new(0, 0, 1, 0),
                AutomaticSize = Enum.AutomaticSize.X,
                AutoButtonColor = false
            })
            Create("UICorner", {Parent = SubBtn, CornerRadius = UDim.new(0, 6)})
            Create("UIPadding", {Parent = SubBtn, PaddingLeft = UDim.new(0,10), PaddingRight = UDim.new(0,10)})
            
            local SubPage = Create("Frame", {
                Parent = RealContent,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Visible = false
            })
            local PageObj = CreateContentPage(SubPage)

            SubBtn.MouseButton1Click:Connect(function()
                if CurrentSubTab then
                    TweenService:Create(CurrentSubTab.Btn, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim, BackgroundColor3 = Theme.Section}):Play()
                    CurrentSubTab.Page.Visible = false
                end
                CurrentSubTab = {Btn = SubBtn, Page = SubPage}
                TweenService:Create(SubBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Main, BackgroundColor3 = Theme.Accent}):Play()
                SubPage.Visible = true
            end)

            if SubTabCount == 1 then
                CurrentSubTab = {Btn = SubBtn, Page = SubPage}
                TweenService:Create(SubBtn, TweenInfo.new(0.2), {TextColor3 = Theme.Main, BackgroundColor3 = Theme.Accent}):Play()
                SubPage.Visible = true
            end

            return PageObj
        end
        
        local function GetTarget(subtab_res)
            if subtab_res then return subtab_res end
            return DefaultPageObj
        end

        function Tab:Section(title, side, subtab_ref)
            local TargetObj = GetTarget(subtab_ref)
            local ParentCol = (side == "Right") and TargetObj.Right or TargetObj.Left
            local ParentList = (side == "Right") and TargetObj.RList or TargetObj.LList

            local SectionFrame = Create("Frame", {
                Parent = ParentCol,
                BackgroundColor3 = Theme.Section,
                Size = UDim2.new(1, 0, 0, 50),
                ClipsDescendants = true
            })
            Create("UICorner", {Parent = SectionFrame, CornerRadius = UDim.new(0, 6)})
            Create("UIStroke", {Parent = SectionFrame, Color = Theme.Stroke, Thickness = 1})

            local SecTitle = Create("TextLabel", {
                Parent = SectionFrame,
                Text = title:upper(),
                Font = Enum.Font.GothamBold,
                TextColor3 = Theme.Accent,
                TextSize = 11,
                Size = UDim2.new(1, -20, 0, 25),
                Position = UDim2.new(0, 12, 0, 4),
                BackgroundTransparency = 1,
                TextXAlignment = Enum.TextXAlignment.Left
            })

            local Container = Create("Frame", {
                Parent = SectionFrame,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, 10, 0, 28),
                Size = UDim2.new(1, -20, 0, 0)
            })
            local List = Create("UIListLayout", {Parent = Container, SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 6)})

            local function Resize()
                local contentHeight = List.AbsoluteContentSize.Y
                TweenService:Create(SectionFrame, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 0, contentHeight + 38)}):Play()
            end
            List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(Resize)

            local Elements = {}

            --// LABEL
            function Elements:Label(text)
                local Lab = Create("TextLabel", {
                    Parent = Container,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextDim,
                    TextSize = 12,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                Resize()
                return Lab 
            end

            --// PARAGRAPH
            --// PARAGRAPH (ИСПРАВЛЕНО)
--// PARAGRAPH (ИСПРАВЛЕНО)
function Elements:Paragraph(title, content)
    local ParaFrame = Create("Frame", {
        Parent = Container,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0), 
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    Create("TextLabel", {
        Parent = ParaFrame,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextColor3 = Theme.TextMain,
        TextSize = 12,
        Size = UDim2.new(1, 0, 0, 15),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left
    })
    
    local ContentFrame = Create("Frame", {
        Parent = ParaFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Position = UDim2.new(0, 0, 0, 18),
        AutomaticSize = Enum.AutomaticSize.Y
    })
    
    local ContentLabel = Create("TextLabel", {
        Parent = ContentFrame,
        Text = content,
        Font = Enum.Font.Gotham,
        TextColor3 = Theme.TextDim,
        TextSize = 11,
        Size = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextWrapped = true,
        AutomaticSize = Enum.AutomaticSize.Y,
        TextYAlignment = Enum.TextYAlignment.Top
    })
    
    Create("UIPadding", {
        Parent = ParaFrame, 
        PaddingBottom = UDim.new(0, 5)
    })
    
    Resize()
end

            --// CHECKBOX
            function Elements:Checkbox(text, default, callback, tooltip)
                local State = default or false
                local CBFrame = Create("TextButton", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 26),
                    Text = "",
                    AutoButtonColor = false
                })

                local BoxOutline = Create("Frame", {
                    Parent = CBFrame,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                    Size = UDim2.new(0, 20, 0, 20),
                    Position = UDim2.new(0, 0, 0.5, -10)
                })
                Create("UICorner", {Parent = BoxOutline, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = BoxOutline, Color = Theme.Stroke, Thickness = 1})

                local CheckIcon = Create("ImageLabel", {
                    Parent = BoxOutline,
                    Image = "rbxassetid://6031094667", -- Checkmark
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(0.5, -8, 0.5, -8),
                    ImageColor3 = Theme.TextMain,
                    ImageTransparency = State and 0 or 1
                })

                if State then BoxOutline.BackgroundColor3 = Theme.Accent end

                local Label = Create("TextLabel", {
                    Parent = CBFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -25, 1, 0),
                    Position = UDim2.new(0, 25, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                CBFrame.MouseButton1Click:Connect(function()
                    State = not State
                    if State then
                        TweenService:Create(BoxOutline, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Accent}):Play()
                        TweenService:Create(CheckIcon, TweenInfo.new(0.2), {ImageTransparency = 0, Size = UDim2.new(0,16,0,16)}):Play()
                    else
                        TweenService:Create(BoxOutline, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 45)}):Play()
                        TweenService:Create(CheckIcon, TweenInfo.new(0.2), {ImageTransparency = 1, Size = UDim2.new(0,0,0,0)}):Play()
                    end
                    callback(State)
                end)
                
                if tooltip then AddTooltip(CBFrame, tooltip) end
                Resize()
            end

            --// RADIO BUTTON (NEW)
            function Elements:RadioButton(text, options, default, callback)
                local RadioFrame = Create("Frame", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 0), -- Auto sized
                    AutomaticSize = Enum.AutomaticSize.Y
                })

                Create("TextLabel", {
                    Parent = RadioFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local OptionContainer = Create("Frame", {
                    Parent = RadioFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 22),
                    Size = UDim2.new(1, 0, 0, 0),
                    AutomaticSize = Enum.AutomaticSize.Y
                })
                Create("UIListLayout", {
                    Parent = OptionContainer,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 6)
                })

                local CurrentSelected = default or options[1]
                local Visuals = {}

                for _, opt in pairs(options) do
                    local OptBtn = Create("TextButton", {
                        Parent = OptionContainer,
                        BackgroundTransparency = 1,
                        Text = "",
                        Size = UDim2.new(1, 0, 0, 24),
                        AutoButtonColor = false
                    })

                    local Circle = Create("Frame", {
                        Parent = OptBtn,
                        BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                        Size = UDim2.new(0, 18, 0, 18),
                        Position = UDim2.new(0, 0, 0.5, -9)
                    })
                    Create("UICorner", {Parent = Circle, CornerRadius = UDim.new(1, 0)})
                    Create("UIStroke", {Parent = Circle, Color = Theme.Stroke, Thickness = 1})

                    local Dot = Create("Frame", {
                        Parent = Circle,
                        BackgroundColor3 = Theme.Accent,
                        Size = UDim2.new(0, 10, 0, 10),
                        Position = UDim2.new(0.5, -5, 0.5, -5),
                        BackgroundTransparency = (opt == CurrentSelected) and 0 or 1
                    })
                    Create("UICorner", {Parent = Dot, CornerRadius = UDim.new(1, 0)})

                    local OptLabel = Create("TextLabel", {
                        Parent = OptBtn,
                        Text = opt,
                        Font = Enum.Font.Gotham,
                        TextColor3 = (opt == CurrentSelected) and Theme.TextMain or Theme.TextDim,
                        TextSize = 12,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, -25, 1, 0),
                        Position = UDim2.new(0, 25, 0, 0),
                        TextXAlignment = Enum.TextXAlignment.Left
                    })

                    Visuals[opt] = {Dot = Dot, Label = OptLabel}

                    OptBtn.MouseButton1Click:Connect(function()
                        if CurrentSelected == opt then return end
                        
                        -- Reset old
                        if Visuals[CurrentSelected] then
                            TweenService:Create(Visuals[CurrentSelected].Dot, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
                            TweenService:Create(Visuals[CurrentSelected].Label, TweenInfo.new(0.2), {TextColor3 = Theme.TextDim}):Play()
                        end

                        CurrentSelected = opt
                        -- Set new
                        TweenService:Create(Visuals[CurrentSelected].Dot, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
                        TweenService:Create(Visuals[CurrentSelected].Label, TweenInfo.new(0.2), {TextColor3 = Theme.TextMain}):Play()
                        
                        callback(opt)
                    end)
                end
                
                Create("UIPadding", {Parent = RadioFrame, PaddingBottom = UDim.new(0, 5)})
                Resize()
            end

            --// TOGGLE
            function Elements:Toggle(text, default, callback)
                local State = default or false
                local TFrame = Create("TextButton", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 26),
                    Text = "",
                    AutoButtonColor = false
                })

                Create("TextLabel", {
                    Parent = TFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -40, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local TBox = Create("Frame", {
                    Parent = TFrame,
                    BackgroundColor3 = Color3.fromRGB(40, 40, 45),
                    Size = UDim2.new(0, 36, 0, 18),
                    Position = UDim2.new(1, -36, 0.5, -9)
                })
                Create("UICorner", {Parent = TBox, CornerRadius = UDim.new(1, 0)})
                
                local TDot = Create("Frame", {
                    Parent = TBox,
                    BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                    Size = UDim2.new(0, 14, 0, 14),
                    Position = State and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
                })
                Create("UICorner", {Parent = TDot, CornerRadius = UDim.new(1, 0)})

                if State then TBox.BackgroundColor3 = Theme.Accent end

                TFrame.MouseButton1Click:Connect(function()
                    State = not State
                    TweenService:Create(TBox, TweenInfo.new(0.2), {BackgroundColor3 = State and Theme.Accent or Color3.fromRGB(40, 40, 45)}):Play()
                    TweenService:Create(TDot, TweenInfo.new(0.2), {Position = State and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
                    callback(State)
                end)
                Resize()
            end
            
            --// INPUT
            function Elements:Input(text, placeholder, callback, tooltip)
                local InputFrame = Create("Frame", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 45)
                })
                
                Create("TextLabel", {
                    Parent = InputFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local BoxBg = Create("Frame", {
                    Parent = InputFrame,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, 20)
                })
                Create("UICorner", {Parent = BoxBg, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = BoxBg, Color = Theme.Stroke, Thickness = 1})

                local Box = Create("TextBox", {
                    Parent = BoxBg,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    Font = Enum.Font.Gotham,
                    Text = "",
                    PlaceholderText = placeholder or "Type here...",
                    TextColor3 = Theme.TextMain,
                    PlaceholderColor3 = Theme.TextDim,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ClearTextOnFocus = false
                })

                Box.FocusLost:Connect(function()
                    callback(Box.Text)
                end)
                
                if tooltip then AddTooltip(InputFrame, tooltip) end
                Resize()
            end
            
            --// KEYBIND
            function Elements:Keybind(text, defaultKey, callback, tooltip)
                local Key = defaultKey or Enum.KeyCode.E
                local Binding = false
                
                local BindFrame = Create("Frame", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30)
                })
                
                Create("TextLabel", {
                    Parent = BindFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(0.6, 0, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local BindBtn = Create("TextButton", {
                    Parent = BindFrame,
                    Text = Key.Name,
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.TextDim,
                    TextSize = 11,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    Size = UDim2.new(0, 60, 0, 20),
                    Position = UDim2.new(1, -60, 0.5, -10),
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = BindBtn, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = BindBtn, Color = Theme.Stroke, Thickness = 1})

                BindBtn.MouseButton1Click:Connect(function()
                    Binding = true
                    BindBtn.Text = "..."
                    
                    local con
                    con = UserInputService.InputBegan:Connect(function(input)
                        if input.UserInputType == Enum.UserInputType.Keyboard then
                            Key = input.KeyCode
                            BindBtn.Text = Key.Name
                            Binding = false
                            callback(Key)
                            con:Disconnect()
                        end
                    end)
                end)
                
                if tooltip then AddTooltip(BindFrame, tooltip) end
                Resize()
            end

            --// SLIDER
            function Elements:Slider(text, min, max, default, callback)
                local Value = default or min
                local SFrame = Create("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40)})
                
                Create("TextLabel", {
                    Parent = SFrame,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(0.7, 0, 0, 20),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local ValLabel = Create("TextLabel", {
                    Parent = SFrame,
                    Text = tostring(Value),
                    Font = Enum.Font.GothamBold,
                    TextColor3 = Theme.Accent,
                    TextSize = 12,
                    Size = UDim2.new(0.3, 0, 0, 20),
                    Position = UDim2.new(0.7, 0, 0, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Right
                })

                local Bar = Create("Frame", {
                    Parent = SFrame,
                    BackgroundColor3 = Color3.fromRGB(40,40,45),
                    Size = UDim2.new(1, 0, 0, 4),
                    Position = UDim2.new(0, 0, 0, 28)
                })
                Create("UICorner", {Parent = Bar, CornerRadius = UDim.new(1,0)})
                
                local Fill = Create("Frame", {
                    Parent = Bar,
                    BackgroundColor3 = Theme.Accent,
                    Size = UDim2.new((Value-min)/(max-min), 0, 1, 0)
                })
                Create("UICorner", {Parent = Fill, CornerRadius = UDim.new(1,0)})

                local function Update(input)
                    local P = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
                    Value = math.floor(min + (max-min)*P)
                    ValLabel.Text = tostring(Value)
                    TweenService:Create(Fill, TweenInfo.new(0.05), {Size = UDim2.new(P, 0, 1, 0)}):Play()
                    callback(Value)
                end

                local Dragging = false
                Bar.InputBegan:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
                        Dragging = true; Update(input) 
                    end 
                end)
                UserInputService.InputEnded:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging = false end 
                end)
                UserInputService.InputChanged:Connect(function(input)
                    if Dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then Update(input) end
                end)
                Resize()
            end

            --// DROPDOWN
            function Elements:Dropdown(text, items, callback)
                local DropFrame = Create("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), ClipsDescendants = true})
                local Open = false
                
                local Header = Create("TextButton", {
                    Parent = DropFrame,
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    AutoButtonColor = false
                })
                
                Create("TextLabel", {
                    Parent = Header,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -25, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local Arrow = Create("ImageLabel", {
                    Parent = Header,
                    Image = "rbxassetid://6031091004",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -16, 0.5, -8),
                    ImageColor3 = Theme.Accent
                })

                local ListFrame = Create("Frame", {
                    Parent = DropFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 0)
                })
                local ItemList = Create("UIListLayout", {Parent = ListFrame, SortOrder = Enum.SortOrder.LayoutOrder})

                local function Toggle()
                    Open = not Open
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = Open and 180 or 0}):Play()
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, Open and (30 + ItemList.AbsoluteContentSize.Y) or 30)}):Play()
                    wait(0.05); Resize(); wait(0.3); Resize()
                end
                Header.MouseButton1Click:Connect(Toggle)

                for _, item in pairs(items) do
                    local IB = Create("TextButton", {
                        Parent = ListFrame,
                        Text = item,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.TextDim,
                        TextSize = 12,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 24)
                    })
                    IB.MouseButton1Click:Connect(function()
                        callback(item)
                        Toggle()
                    end)
                end
                Resize()
            end

            --// MULTI DROPDOWN
            function Elements:MultiDropdown(text, items, callback)
                local DropFrame = Create("Frame", {Parent = Container, BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 30), ClipsDescendants = true})
                local Open = false
                local Selected = {}
                
                local Header = Create("TextButton", {
                    Parent = DropFrame,
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    AutoButtonColor = false
                })
                
                local TitleLbl = Create("TextLabel", {
                    Parent = Header,
                    Text = text .. " [...]",
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -25, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })

                local Arrow = Create("ImageLabel", {
                    Parent = Header,
                    Image = "rbxassetid://6031091004",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new(1, -16, 0.5, -8),
                    ImageColor3 = Theme.Accent
                })

                local ListFrame = Create("Frame", {
                    Parent = DropFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 0)
                })
                local ItemList = Create("UIListLayout", {Parent = ListFrame, SortOrder = Enum.SortOrder.LayoutOrder})

                local function UpdateTitle()
                    local count = 0
                    for k, v in pairs(Selected) do if v then count = count + 1 end end
                    TitleLbl.Text = (count == 0) and (text .. " [...]") or (text .. " [" .. count .. "]")
                end

                local function Toggle()
                    Open = not Open
                    TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = Open and 180 or 0}):Play()
                    TweenService:Create(DropFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, Open and (30 + ItemList.AbsoluteContentSize.Y) or 30)}):Play()
                    wait(0.05); Resize(); wait(0.3); Resize()
                end
                Header.MouseButton1Click:Connect(Toggle)

                for _, item in pairs(items) do
                    Selected[item] = false
                    local IB = Create("TextButton", {
                        Parent = ListFrame,
                        Text = item,
                        Font = Enum.Font.Gotham,
                        TextColor3 = Theme.TextDim,
                        TextSize = 12,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 0, 24)
                    })
                    
                    IB.MouseButton1Click:Connect(function()
                        Selected[item] = not Selected[item]
                        IB.TextColor3 = Selected[item] and Theme.Accent or Theme.TextDim
                        UpdateTitle()
                        callback(Selected)
                    end)
                end
                Resize()
            end

            --// COLOR PICKER
            function Elements:ColorPicker(text, defaultColor, defaultAlpha, callback)
                local h, s, v = Color3.toHSV(defaultColor or Color3.new(1,1,1))
                local alpha = defaultAlpha or 0
                local Color = Color3.fromHSV(h,s,v)
                local Open = false
                
                local CPFrame = Create("Frame", {
                    Parent = Container,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    ClipsDescendants = true
                })
                
                local Header = Create("TextButton", {
                    Parent = CPFrame,
                    Text = "",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 30),
                    AutoButtonColor = false
                })

                Create("TextLabel", {
                    Parent = Header,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    Size = UDim2.new(1, -40, 1, 0),
                    BackgroundTransparency = 1,
                    TextXAlignment = Enum.TextXAlignment.Left
                })
                
                local PreviewBg = Create("ImageLabel", {
                    Parent = Header,
                    Image = "rbxassetid://382766746",
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0,10,0,10),
                    Size = UDim2.new(0, 30, 0, 16),
                    Position = UDim2.new(1, -30, 0.5, -8),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = PreviewBg, CornerRadius = UDim.new(0, 4)})

                local Preview = Create("Frame", {
                    Parent = PreviewBg,
                    BackgroundColor3 = Color,
                    BackgroundTransparency = alpha,
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = Preview, CornerRadius = UDim.new(0, 4)})

                local Palette = Create("Frame", {
                    Parent = CPFrame,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 30),
                    Size = UDim2.new(1, 0, 0, 195)
                })

                -- 1. SV
                local SVMap = Create("Frame", {
                    Parent = Palette,
                    Size = UDim2.new(1, 0, 0, 100),
                    Position = UDim2.new(0, 0, 0, 0),
                    BackgroundColor3 = Color3.fromHSV(h, 1, 1),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = SVMap, CornerRadius = UDim.new(0, 4)})
                
                local SatGradient = Create("Frame", {
                    Parent = SVMap,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.new(1,1,1),
                    BorderSizePixel = 0,
                    ZIndex = 2
                })
                Create("UICorner", {Parent = SatGradient, CornerRadius = UDim.new(0, 4)})
                Create("UIGradient", {Parent = SatGradient, Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}})

                local ValGradient = Create("Frame", {
                    Parent = SVMap,
                    Size = UDim2.new(1, 0, 1, 0),
                    BackgroundColor3 = Color3.new(0,0,0),
                    BorderSizePixel = 0,
                    ZIndex = 3
                })
                Create("UICorner", {Parent = ValGradient, CornerRadius = UDim.new(0, 4)})
                Create("UIGradient", {
                    Parent = ValGradient, 
                    Rotation = -90,
                    Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}
                })

                local SVCursor = Create("ImageLabel", {
                    Parent = ValGradient,
                    Image = "rbxassetid://4953646208",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(0, 12, 0, 12),
                    Position = UDim2.new(s, -6, 1 - v, -6),
                    ZIndex = 4
                })

                -- 2. Hue
                local HueBar = Create("Frame", {
                    Parent = Palette,
                    Size = UDim2.new(1, 0, 0, 18),
                    Position = UDim2.new(0, 0, 0, 110),
                    BackgroundColor3 = Color3.new(1,1,1),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = HueBar, CornerRadius = UDim.new(0, 4)})
                Create("UIGradient", {
                    Parent = HueBar,
                    Color = ColorSequence.new{
                        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
                        ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                        ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
                        ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                        ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))
                    }
                })

                local HueCursor = Create("Frame", {
                    Parent = HueBar,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 2, 1, 0),
                    Position = UDim2.new(h, -1, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 5
                })
                Create("UIStroke", {Parent = HueCursor, Color = Color3.new(0,0,0), Thickness = 1})

                -- 3. Alpha
                local AlphaBar = Create("ImageLabel", {
                    Parent = Palette,
                    Image = "rbxassetid://382766746",
                    ScaleType = Enum.ScaleType.Tile,
                    TileSize = UDim2.new(0, 10, 0, 10),
                    Size = UDim2.new(1, 0, 0, 18),
                    Position = UDim2.new(0, 0, 0, 135)
                })
                Create("UICorner", {Parent = AlphaBar, CornerRadius = UDim.new(0, 4)})
                
                local AlphaGradient = Create("Frame", {
                    Parent = AlphaBar,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(1, 0, 1, 0),
                    BorderSizePixel = 0
                })
                Create("UICorner", {Parent = AlphaGradient, CornerRadius = UDim.new(0, 4)})
                Create("UIGradient", {Parent = AlphaGradient, Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0,0), NumberSequenceKeypoint.new(1,1)}})

                local AlphaCursor = Create("Frame", {
                    Parent = AlphaBar,
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    Size = UDim2.new(0, 2, 1, 0),
                    Position = UDim2.new(alpha, -1, 0, 0),
                    BorderSizePixel = 0,
                    ZIndex = 5
                })
                Create("UIStroke", {Parent = AlphaCursor, Color = Color3.new(0,0,0), Thickness = 1})

                -- 4. INPUTS
                local InputFrame = Create("Frame", {
                    Parent = Palette,
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, 0, 0, 160),
                    Size = UDim2.new(1, 0, 0, 30)
                })

                local Inputs = {}
                local function CreateInput(name, ph, sizeX, posX)
                    local BoxFrame = Create("Frame", {
                        Parent = InputFrame,
                        BackgroundColor3 = Color3.fromRGB(25, 25, 30),
                        Size = UDim2.new(sizeX, 0, 1, 0),
                        Position = UDim2.new(posX, 0, 0, 0)
                    })
                    Create("UICorner", {Parent = BoxFrame, CornerRadius = UDim.new(0, 4)})
                    Create("UIStroke", {Parent = BoxFrame, Color = Theme.Stroke, Thickness = 1})
                    
                    local Box = Create("TextBox", {
                        Parent = BoxFrame,
                        BackgroundTransparency = 1,
                        Size = UDim2.new(1, 0, 1, 0),
                        Font = Enum.Font.GothamBold,
                        Text = "",
                        PlaceholderText = ph,
                        TextColor3 = Theme.TextMain,
                        PlaceholderColor3 = Theme.TextDim,
                        TextSize = 11
                    })
                    Inputs[name] = Box
                    return Box
                end

                CreateInput("R", "R", 0.18, 0)
                CreateInput("G", "G", 0.18, 0.22)
                CreateInput("B", "B", 0.18, 0.44)
                CreateInput("Hex", "Hex", 0.32, 0.68)

                local IgnoreUpdate = false

                local function UpdateColor()
                    Color = Color3.fromHSV(h, s, v)
                    Preview.BackgroundColor3 = Color
                    Preview.BackgroundTransparency = alpha
                    SVMap.BackgroundColor3 = Color3.fromHSV(h, 1, 1)
                    
                    if not IgnoreUpdate then
                        IgnoreUpdate = true
                        Inputs.R.Text = tostring(math.floor(Color.R * 255))
                        Inputs.G.Text = tostring(math.floor(Color.G * 255))
                        Inputs.B.Text = tostring(math.floor(Color.B * 255))
                        Inputs.Hex.Text = "#" .. Color:ToHex()
                        IgnoreUpdate = false
                    end
                    
                    callback(Color, alpha)
                end

                local function SetRGB()
                    local r = tonumber(Inputs.R.Text) or 0
                    local g = tonumber(Inputs.G.Text) or 0
                    local b = tonumber(Inputs.B.Text) or 0
                    Color = Color3.fromRGB(r, g, b)
                    h, s, v = Color3.toHSV(Color)
                    TweenService:Create(HueCursor, TweenInfo.new(0.2), {Position = UDim2.new(h, -1, 0, 0)}):Play()
                    TweenService:Create(SVCursor, TweenInfo.new(0.2), {Position = UDim2.new(s, -6, 1-v, -6)}):Play()
                    UpdateColor()
                end

                local function SetHex()
                    local hex = Inputs.Hex.Text:gsub("#", "")
                    local s, result = pcall(function() return Color3.fromHex(hex) end)
                    if s and result then
                        Color = result
                        h, s, v = Color3.toHSV(Color)
                        TweenService:Create(HueCursor, TweenInfo.new(0.2), {Position = UDim2.new(h, -1, 0, 0)}):Play()
                        TweenService:Create(SVCursor, TweenInfo.new(0.2), {Position = UDim2.new(s, -6, 1-v, -6)}):Play()
                        UpdateColor()
                    end
                end

                Inputs.R.FocusLost:Connect(SetRGB)
                Inputs.G.FocusLost:Connect(SetRGB)
                Inputs.B.FocusLost:Connect(SetRGB)
                Inputs.Hex.FocusLost:Connect(SetHex)

                local Dragging = {SV = false, Hue = false, Alpha = false}

                local function MonitorInput(input, type)
                    if type == "SV" then
                        local relativeX = math.clamp((input.Position.X - SVMap.AbsolutePosition.X) / SVMap.AbsoluteSize.X, 0, 1)
                        local relativeY = math.clamp((input.Position.Y - SVMap.AbsolutePosition.Y) / SVMap.AbsoluteSize.Y, 0, 1)
                        s = relativeX
                        v = 1 - relativeY
                        TweenService:Create(SVCursor, TweenInfo.new(0.05), {Position = UDim2.new(s, -6, 1-v, -6)}):Play()
                    elseif type == "Hue" then
                        local relativeX = math.clamp((input.Position.X - HueBar.AbsolutePosition.X) / HueBar.AbsoluteSize.X, 0, 1)
                        h = relativeX
                        TweenService:Create(HueCursor, TweenInfo.new(0.05), {Position = UDim2.new(h, -1, 0, 0)}):Play()
                    elseif type == "Alpha" then
                        local relativeX = math.clamp((input.Position.X - AlphaBar.AbsolutePosition.X) / AlphaBar.AbsoluteSize.X, 0, 1)
                        alpha = relativeX
                        TweenService:Create(AlphaCursor, TweenInfo.new(0.05), {Position = UDim2.new(alpha, -1, 0, 0)}):Play()
                    end
                    UpdateColor()
                end

                SVMap.InputBegan:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging.SV = true; MonitorInput(input, "SV") end 
                end)
                HueBar.InputBegan:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging.Hue = true; MonitorInput(input, "Hue") end 
                end)
                AlphaBar.InputBegan:Connect(function(input) 
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then Dragging.Alpha = true; MonitorInput(input, "Alpha") end 
                end)

                UserInputService.InputChanged:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                        if Dragging.SV then MonitorInput(input, "SV")
                        elseif Dragging.Hue then MonitorInput(input, "Hue")
                        elseif Dragging.Alpha then MonitorInput(input, "Alpha") end
                    end
                end)
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                        Dragging.SV = false; Dragging.Hue = false; Dragging.Alpha = false
                    end
                end)

                Header.MouseButton1Click:Connect(function()
                    Open = not Open
                    TweenService:Create(CPFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, Open and 225 or 30)}):Play()
                    task.wait(0.05); Resize(); task.wait(0.3); Resize()
                end)
                
                UpdateColor()
                Resize()
            end
            
            --// BUTTON
            function Elements:Button(text, callback)
                 local Btn = Create("TextButton", {
                    Parent = Container,
                    Text = text,
                    Font = Enum.Font.GothamMedium,
                    TextColor3 = Theme.TextMain,
                    TextSize = 12,
                    BackgroundColor3 = Color3.fromRGB(35, 35, 40),
                    Size = UDim2.new(1, 0, 0, 30),
                    AutoButtonColor = false
                })
                Create("UICorner", {Parent = Btn, CornerRadius = UDim.new(0, 4)})
                Create("UIStroke", {Parent = Btn, Color = Theme.Stroke, Thickness = 1})

                Btn.MouseButton1Click:Connect(function()
                    TweenService:Create(Btn, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent, TextColor3 = Color3.new(0,0,0)}):Play()
                    wait(0.15)
                    TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(35, 35, 40), TextColor3 = Theme.TextMain}):Play()
                    callback()
                end)
                Resize()
            end

            return Elements
        end
        return Tab
    end
    return Window
end

return Library
