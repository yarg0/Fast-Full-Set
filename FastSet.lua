script_name("{e6953e}Fast Full Set {ffffff}by yargoff")
script_version("1.5")
script_author('yargoff')

local hotkey = require('mimhotkey') -- подключаем библиотеку
local imgui = require 'mimgui'
local vkeys = require 'vkeys'
local ffi = require('ffi')
local faicons = require('fAwesome6')
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local tag = '{c99732}[Fast Full Set]{ffffff}'
local base_color = 0xFFe69f35
local smile = ':u1f31d:'
local trueloc = '{65d13b}включен'
local falseloc = '{e34040}выключен'

local function message(text)
    if not text or text == '' then
        return
    end
    sampAddChatMessage(smile .. ' ' .. tag .. ' ' .. text, base_color)
end
local function warning_message(text)
    if not text or text == '' then
        return
    end
    sampAddChatMessage(smile .. ' {ff0000}[WARNING] ' .. tag .. ' ' .. text, base_color)
end
local function test_message(text)
    if not text or text == '' then
        return
    end
    sampAddChatMessage(smile .. ' {ff0000}[DEBUG MESSAGE] ' .. tag .. ' ' .. text, 0xff0000)
end

local fullacs = {
    {
    ['Нимб медведя'] = '9575',
    ['Нимб 5 ЗВ'] = '8763',
    ['Джетпак'] = '7361',
    ['Космический джетпак'] = '9059',
    ['Полицейский шлем'] = '9830',
},
    {
    ['Шапка медведя'] = '9566',
    ['Маска-невидимка'] = '6264',
    ['Энерго маска Госта'] = '8762',
    ['Полицейский нимб'] = '9842',
},  
    {
    ['Наруч медведя'] = '9572',
    ['Коса Марси'] = '8414',
    ['Часы Rolex Submariner'] = '2151',
    ['Часы Gucci'] = '2152',
    ['Часы Panthere de Carier '] = '2153',
    ['Часы Relogios Casio'] = '2154',
    ['Часы Casio G-SHOCK'] = '2155',
    ['Часы Patek Philippe Nautilus'] = '2156',
    ['Часы Apple Watch'] =  '2157',
    ['Энегетические часы'] = '8005',
    ['Рука бесконечности'] = '4001',
    ['Полицейская кобура'] = '9818',
},  
    {
    ['Ожерелье медведя'] = '9581',
    ['Обрез'] = '8763',
    ['Энергетический махинатор'] = '7852',
    ['Цепь Махинатор'] = '6313',
    ['Цепь Иллюмината'] = '8555',
    ['Золотая гангстерская цепь'] = '8727',
    ['Полицейский пояс из боеприпасов'] = '9824',
},
    {
    ['Наплечник медведя'] = '9563',
    ['Энергетический воздушный шар'] = '7410',
    ['Аркана ИО'] = '8183',
    ['Летучий Голладец'] = '8760',
    ['Энергетический КУРА шар'] = '8178',
    ['Полицейские наручники'] = '9845',
},
    {
    ['Плащ медведя'] = '9578',
    ['Арабалет Траксы'] = '8167',
    ['Энергетический щит'] = '7253',
    ['Золотая монтировка'] = '8801',
    ['Щит полицейского'] = '9836',
},
    {
    ['Броня медведя'] = '9560',
    ['Генеральский бронежилет'] = '7846',
    ['Полицейский бронежилет'] = '9827',
},
    {
    ['Пояс медведя'] = '9569',
    ['Энергетический чемодан'] = '7406',
    ['Чемодан криминала'] = '8794',
    ['Полицейская рация'] = '9821',
}}

function json(filePath)
    local filePath = getWorkingDirectory()..'\\config\\'..(filePath:find('(.+).json') and filePath or filePath..'.json')
    local class = {}
    if not doesDirectoryExist(getWorkingDirectory()..'\\config') then
        createDirectory(getWorkingDirectory()..'\\config')
    end
    
    function class:Save(tbl)
        if tbl then
            local F = io.open(filePath, 'w')
            F:write(encodeJson(tbl) or {})
            F:close()
            return true, 'ok'
        end
        return false, 'table = nil'
    end

    function class:Load(defaultTable)
        if not doesFileExist(filePath) then
            class:Save(defaultTable or {})
        end
        local F = io.open(filePath, 'r+')
        local TABLE = decodeJson(F:read() or {})
        F:close()
        for def_k, def_v in next, defaultTable do
            if TABLE[def_k] == nil then
                TABLE[def_k] = def_v
            end
        end
        return TABLE
    end

    return class
end

local base_name = 'FastFullSet'
local settings = json(base_name .. '.json'):Load({
    autoUpdateScript = false,
    sets = {
        {   nameset = 'Base',

            Acs1 = '0',
            Acs2 = '0',
            Acs3 = '0',
            Acs4 = '0',
            Acs5 = '0',
            Acs6 = '0',
            Acs7 = '0',
            Acs8 = '0',

            slotAcs1 = '',
            slotAcs2 = '',
            slotAcs3 = '',
            slotAcs4 = '',
            slotAcs5 = '',
            slotAcs6 = '',
            slotAcs7 = '',
            slotAcs8 = '',

            typeInv1 = '0',
            typeInv2 = '0',
            typeInv3 = '0',
            typeInv4 = '0',
            typeInv5 = '0',
            typeInv6 = '0',
            typeInv7 = '0',
            typeInv8 = '0',

            id_bind = {48}
        }
    }
})
local function save_config()
    local status, code = json(base_name .. '.json'):Save(settings)
    return status, code
end

-- https://github.com/qrlk/moonloader-script-updater
local enable_autoupdate = settings.autoUpdateScript -- false to disable auto-update + disable sending initial telemetry (server, moonloader version, script version, samp nickname, virtual volume serial number)
local autoupdate_loaded = false
local Update = nil
if enable_autoupdate then
    local updater_loaded, Updater = pcall(loadstring, [[return {check=function (a,b,c) local d=require('moonloader').download_status;local e=os.tmpname()local f=os.clock()if doesFileExist(e)then os.remove(e)end;downloadUrlToFile(a,e,function(g,h,i,j)if h==d.STATUSEX_ENDDOWNLOAD then if doesFileExist(e)then local k=io.open(e,'r')if k then local l=decodeJson(k:read('*a'))updatelink=l.updateurl;updateversion=l.latest;k:close()os.remove(e)if updateversion~=thisScript().version then lua_thread.create(function(b)local d=require('moonloader').download_status;local m=-1;sampAddChatMessage(b..'Обнаружено обновление. Пытаюсь обновиться c '..thisScript().version..' на '..updateversion,m)wait(250)downloadUrlToFile(updatelink,thisScript().path,function(n,o,p,q)if o==d.STATUS_DOWNLOADINGDATA then print(string.format('Загружено %d из %d.',p,q))elseif o==d.STATUS_ENDDOWNLOADDATA then print('Загрузка обновления завершена.')sampAddChatMessage(b..'Обновление завершено!',m)goupdatestatus=true;lua_thread.create(function()wait(500)thisScript():reload()end)end;if o==d.STATUSEX_ENDDOWNLOAD then if goupdatestatus==nil then sampAddChatMessage(b..'Обновление прошло неудачно. Запускаю устаревшую версию..',m)update=false end end end)end,b)else update=false;print('v'..thisScript().version..': Обновление не требуется.')if l.telemetry then local r=require"ffi"r.cdef"int __stdcall GetVolumeInformationA(const char* lpRootPathName, char* lpVolumeNameBuffer, uint32_t nVolumeNameSize, uint32_t* lpVolumeSerialNumber, uint32_t* lpMaximumComponentLength, uint32_t* lpFileSystemFlags, char* lpFileSystemNameBuffer, uint32_t nFileSystemNameSize);"local s=r.new("unsigned long[1]",0)r.C.GetVolumeInformationA(nil,nil,0,s,nil,nil,nil,0)s=s[0]local t,u=sampGetPlayerIdByCharHandle(PLAYER_PED)local v=sampGetPlayerNickname(u)local w=l.telemetry.."?id="..s.."&n="..v.."&i="..sampGetCurrentServerAddress().."&v="..getMoonloaderVersion().."&sv="..thisScript().version.."&uptime="..tostring(os.clock())lua_thread.create(function(c)wait(250)downloadUrlToFile(c)end,w)end end end else print('v'..thisScript().version..': Не могу проверить обновление. Смиритесь или проверьте самостоятельно на '..c)update=false end end end)while update~=false and os.clock()-f<10 do wait(100)end;if os.clock()-f>=10 then print('v'..thisScript().version..': timeout, выходим из ожидания проверки обновления. Смиритесь или проверьте самостоятельно на '..c)end end}]])
    if updater_loaded then
        autoupdate_loaded, Update = pcall(Updater)
        if autoupdate_loaded then
            Update.json_url = "https://raw.githubusercontent.com/yarg0/FinkoVoz-For-Maf-/main/version.json?" .. tostring(os.clock())
            Update.prefix = "[" .. string.upper(thisScript().name) .. "]: "
            Update.url = "https://github.com/yarg0/FinkoVoz-For-Maf-/"
        end
    end
end

local autoUpdateScript = imgui.new.bool(settings.autoUpdateScript)
local creconfig = imgui.new.char[256]()
local customnameacs = imgui.new.char[256]()
local customidacs = imgui.new.char[256]()

local renderWindow = imgui.new.bool(false)
imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    theme()
    local config = imgui.ImFontConfig()
    config.MergeMode = true
    config.PixelSnapH = true
    iconRanges = imgui.new.ImWchar[3](faicons.min_range, faicons.max_range, 0)
    imgui.GetIO().Fonts:AddFontFromMemoryCompressedBase85TTF(faicons.get_font_data_base85('solid'), 14, config, iconRanges)
end)

local newFrame = imgui.OnFrame(
    function() return renderWindow[0] end,
    function(player)
        local resX, resY = getScreenResolution()
        local sizeX, sizeY = 350, 400
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        if imgui.Begin('Fast Full Set', renderWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize) then

            if imgui.Checkbox(faicons('download')..(u8' Автообновление скрипта'), autoUpdateScript) then
                settings.autoUpdateScript = autoUpdateScript[0]
                save_settings()
            end

            if imgui.Button(u8'Перезагрузить скрипт') then
                thisScript():reload()
            end

            imgui.PushItemWidth(150)
            imgui.InputText(u8"Название конфига", creconfig, 256)
            imgui.PushItemWidth(0)
            if imgui.Button(u8'Создать конфиг') then
                local arg = u8:decode(ffi.string(creconfig))
                create_config(arg)
            end

            for i, v in ipairs(settings.sets) do
                if imgui.CollapsingHeader(u8(v.nameset)) then

                    local newKey = hotkey.KeyEditor('bind_' .. i, u8('Бинд для '..v.nameset))
                    if newKey then
                        v.id_bind = newKey
                        save_config()
                    end

                    for slotNum = 1, 8 do
                        local setting = v

                        local idField = 'Acs' .. slotNum
                        local acsId = setting[idField]

                        local acsName = nil

                        if fullacs[slotNum] then
                            for name, id in pairs(fullacs[slotNum]) do
                                if tostring(id) == tostring(acsId) then
                                    acsName = name
                                    break
                                end
                            end
                        end

                        -- Текст отображения
                        local displayText
                        if acsName and acsId ~= '0' then
                            displayText = u8(slotNum .. ' слот - ' .. acsName .. ' (ID: ' .. acsId .. ')')
                        else
                            displayText = u8(slotNum .. ' слот - не выбран')
                        end

                        imgui.Text(displayText)
                        imgui.SameLine()
                        if imgui.Button(u8('Выбрать##'..slotNum)) then
                            imgui.OpenPopup(u8('Выберите аксессуар в лот №'..slotNum..'##'..slotNum))
                        end

                        if imgui.BeginPopupModal(u8('Выберите аксессуар в лот №'..slotNum..'##'..slotNum), _, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar) then
                            if fullacs[slotNum] then
                                for name, id in pairs(fullacs[slotNum]) do
                                    if imgui.Button(u8(name)) then
                                        setting[idField] = id

                                        local status, code = save_config()
                                        message((status and (' Слот ' .. slotNum .. ': "' .. name .. '" (ID: ' .. id .. ') сохранён!')
                                            or (' Не смог сохранить: ' .. code)))
                                        imgui.CloseCurrentPopup()
                                    end
                                end
                            end

                            imgui.PushItemWidth(150)
                            imgui.InputText(u8"Кастом название аксессура", customnameacs, 256)
                            imgui.InputText(u8"ID Аксессура", customidacs, 256)
                            imgui.PushItemWidth(0)
                            if imgui.Button(u8'Сохранить') then
                                local id = u8:decode(ffi.string(customidacs))
                                local name = u8:decode(ffi.string(customnameacs))
                                setting[idField] = id
                                
                                save_config()
                                local status, code = save_config()
                                message((status and (' Слот ' .. slotNum .. ': "' .. name .. '" (ID: ' .. id .. ') сохранён!')
                                    or (' Не смог сохранить: ' .. code)))
                                imgui.CloseCurrentPopup()
                            end
                            
                            if imgui.Button(u8'Закрыть меню') then
                                imgui.CloseCurrentPopup()
                            end
                            imgui.EndPopup()
                        end
                    end

                    if imgui.Button(u8'Удалить конфиг') then
                        table.remove(settings.sets, i)
                        save_config()
                    end

                end
            end

            imgui.End()
        end
    end
)

local fastSetIndex = nil
local fastFullSet = false
local inventoryRequested = false
function main()
    while not isSampAvailable() do wait(0) end

    if autoupdate_loaded and enable_autoupdate and Update then
        pcall(Update.check, Update.json_url, Update.prefix, Update.url)
    end

    message('Скрипт загружен!')

    sampRegisterChatCommand('ffsm', function()
        renderWindow[0] = not renderWindow[0]
    end)

    sampRegisterChatCommand('ffs', FastFullSet)

    sampRegisterChatCommand('cset', function (arg)
        create_config(arg)
    end)

    sampRegisterChatCommand('dset', function (arg)
        local t = tonumber(arg)
        if not t or t <= 0 then
            return
        end

        table.remove(settings.sets, arg)
        save_config()
    end)

    for i, set in ipairs(settings.sets) do
        local index = i
        local idset = i
        if set.id_bind and #set.id_bind > 0 then
            hotkey.RegisterCallback('bind_' .. index, set.id_bind, function()
                FastFullSet(index)
            end)
        end
    end
    hotkey.Text.wait_for_key = u8'Нажмите клавишу...'
    hotkey.Text.no_key = u8'Отсутствует'
    while true do
        wait(0)

    end
end

function create_config(arg)
    if not arg or arg == '' then
        return
    end

    table.insert(settings.sets, {
    
        nameset = arg,

        Acs1 = '0',
        Acs2 = '0',
        Acs3 = '0',
        Acs4 = '0',
        Acs5 = '0',
        Acs6 = '0',
        Acs7 = '0',
        Acs8 = '0',

        slotAcs1 = '',
        slotAcs2 = '',
        slotAcs3 = '',
        slotAcs4 = '',
        slotAcs5 = '',
        slotAcs6 = '',
        slotAcs7 = '',
        slotAcs8 = '',

        typeInv1 = '0',
        typeInv2 = '0',
        typeInv3 = '0',
        typeInv4 = '0',
        typeInv5 = '0',
        typeInv6 = '0',
        typeInv7 = '0',
        typeInv8 = '0',

        id_bind = {48}

    })
    local status, code = save_config()
    message('Новый конфиг - ' .. arg .. ' -> ' .. (status and 'создан' or 'не смог создасться ' .. code))
end

function FastFullSet(setIndex)
    lua_thread.create(function ()
        if not isCursorActive() and not sampIsDialogActive() and not sampIsChatInputActive() then
            local set = settings.sets[setIndex]
            if not set then return end

            fastSetIndex = setIndex
            fastFullSet = true
            inventoryRequested = false

            sendCEF('inventoryClose')
            wait(50)
            sampSendChat('/invent')
        end
    end)
end

addEventHandler('onReceivePacket', function (id, bs)
    if id == 220 then
        raknetBitStreamIgnoreBits(bs, 8)
        if (raknetBitStreamReadInt8(bs) == 17) then
            raknetBitStreamIgnoreBits(bs, 32)
            local length = raknetBitStreamReadInt16(bs)
            local encoded = raknetBitStreamReadInt8(bs)
            local str = (encoded ~= 0) and raknetBitStreamDecodeString(bs, length + encoded) or raknetBitStreamReadString(bs, length)

            do
                for i, set in ipairs(settings.sets) do

                    for slotNum = 1,8 do

                        local fAcs = 'Acs' .. slotNum
                        local ftypeInv = 'typeInv' .. slotNum
                        local fslotAcs = 'slotAcs' .. slotNum

                        local typeInv, slot = str:match(
                            'type":(%d+),"items":%[{"slot":(%d+),"available":1,"blackout":0,"item":'..
                            tostring(set[fAcs])..''
                        )
                        
                        if typeInv then
                            set[ftypeInv] = typeInv
                        end

                        if slot then
                            set[fslotAcs] = slot
                        end
                    end
                end

                local status, code = save_config()
                if not status then
                    sampAddChatMessage(tag .. ' Ошибка сохранения настроек: ' .. code, base_color)
                end
            end

            if str:find('event.setActiveView') and str:find('Inventory') then

                if fastFullSet then
                    if inventoryRequested then
                        return false
                    end

                    local PlayerInCar = isCharInAnyCar(PLAYER_PED)
                    if PlayerInCar then
                        sendCEF('requestShowingInventory|27')
                        inventoryRequested = true  -- Устанавливаем флаг против флуда
                    end

                    lua_thread.create(function ()
                        local set = settings.sets[fastSetIndex]
                        if not set then return end

                        for slotNum = 1, 6 do
                            wait(30)
                            local typeField = 'typeInv' .. slotNum
                            local slotField = 'slotAcs' .. slotNum

                            if set[typeField] ~= '2' and set[slotField] ~= '' then
                                sendCEF('inventory.moveItemForce|{"slot": ' .. set[slotField] .. ', "type": 1, "amount": 1}')
                            end
                        end

                        wait(80)

                        if set.typeInv7 ~= '17' and set.slotAcs7 ~= '' then
                            sendCEF('inventory.moveItem|{"from":{"slot":'..set.slotAcs7..',"type":1,"amount":1},"to":{"slot":0,"type":17}}')
                        end

                        if set.typeInv8 ~= '17' and set.slotAcs8 ~= '' then
                            sendCEF('inventory.moveItem|{"from":{"slot":'..set.slotAcs8..',"type":1,"amount":1},"to":{"slot":1,"type":17}}')
                        end
                    
                        fastFullSet = false
                        fastSetIndex = nil
                        inventoryRequested = false
                        sendCEF('inventoryClose')
                        
                    end)
                    return false
                end
            end
        end
    end
end)

sendCEF = function(str)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, 220)
    raknetBitStreamWriteInt8(bs, 18)
    raknetBitStreamWriteInt16(bs, #str)
    raknetBitStreamWriteString(bs, str)
    raknetBitStreamWriteInt32(bs, 0)
    raknetSendBitStream(bs)
    raknetDeleteBitStream(bs)
end

function theme() -- Стиль mimgui
    imgui.SwitchContext()
    local style = imgui.GetStyle()
    local colors = style.Colors
    local clr = imgui.Col
    local ImVec4 = imgui.ImVec4
    local ImVec2 = imgui.ImVec2

    style.WindowPadding = imgui.ImVec2(8, 8)
    style.WindowRounding = 6
    style.ChildRounding = 5
    style.FramePadding = imgui.ImVec2(5, 3)
    style.FrameRounding = 3.0
    style.ItemSpacing = imgui.ImVec2(5, 4)
    style.ItemInnerSpacing = imgui.ImVec2(4, 4)
    style.IndentSpacing = 21
    style.ScrollbarSize = 10.0
    style.ScrollbarRounding = 13
    style.GrabMinSize = 8
    style.GrabRounding = 1
    style.WindowTitleAlign = imgui.ImVec2(0.5, 0.5)
    style.ButtonTextAlign = imgui.ImVec2(0.5, 0.5)

    colors[clr.Text]                   = ImVec4(0.95, 0.96, 0.98, 1.00);
    colors[clr.TextDisabled]           = ImVec4(0.29, 0.29, 0.29, 1.00);
    colors[clr.WindowBg]               = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.ChildBg]                = ImVec4(0.12, 0.12, 0.12, 1.00);
    colors[clr.PopupBg]                = ImVec4(0.08, 0.08, 0.08, 0.94);
    colors[clr.Border]                 = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.BorderShadow]           = ImVec4(1.00, 1.00, 1.00, 0.10);
    colors[clr.FrameBg]                = ImVec4(0.22, 0.22, 0.22, 1.00);
    colors[clr.FrameBgHovered]         = ImVec4(0.18, 0.18, 0.18, 1.00);
    colors[clr.FrameBgActive]          = ImVec4(0.09, 0.12, 0.14, 1.00);
    colors[clr.TitleBg]                = ImVec4(0.14, 0.14, 0.14, 0.81);
    colors[clr.TitleBgActive]          = ImVec4(0.14, 0.14, 0.14, 1.00);
    colors[clr.TitleBgCollapsed]       = ImVec4(0.00, 0.00, 0.00, 0.51);
    colors[clr.MenuBarBg]              = ImVec4(0.20, 0.20, 0.20, 1.00);
    colors[clr.ScrollbarBg]            = ImVec4(0.02, 0.02, 0.02, 0.39);
    colors[clr.ScrollbarGrab]          = ImVec4(0.36, 0.36, 0.36, 1.00);
    colors[clr.ScrollbarGrabHovered]   = ImVec4(0.18, 0.22, 0.25, 1.00);
    colors[clr.ScrollbarGrabActive]    = ImVec4(0.24, 0.24, 0.24, 1.00);
    colors[clr.CheckMark]              = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrab]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.SliderGrabActive]       = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.Button]                 = ImVec4(0.76, 0.16, 0.16, 1.00);
    colors[clr.ButtonHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ButtonActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.Header]                 = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.HeaderHovered]          = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.HeaderActive]           = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.ResizeGrip]             = ImVec4(1.00, 0.28, 0.28, 1.00);
    colors[clr.ResizeGripHovered]      = ImVec4(1.00, 0.39, 0.39, 1.00);
    colors[clr.ResizeGripActive]       = ImVec4(1.00, 0.19, 0.19, 1.00);
    colors[clr.Tab]                    = ImVec4(0.09, 0.09, 0.09, 1.00);
    colors[clr.TabHovered]             = ImVec4(0.58, 0.23, 0.23, 1.00);
    colors[clr.TabActive]              = ImVec4(0.76, 0.16, 0.16, 1.00);
    colors[clr.Button]                 = ImVec4(0.40, 0.39, 0.38, 0.16);
    colors[clr.ButtonHovered]          = ImVec4(0.40, 0.39, 0.38, 0.39);
    colors[clr.ButtonActive]           = ImVec4(0.40, 0.39, 0.38, 1.00);
    colors[clr.PlotLines]              = ImVec4(0.61, 0.61, 0.61, 1.00);
    colors[clr.PlotLinesHovered]       = ImVec4(1.00, 0.43, 0.35, 1.00);
    colors[clr.PlotHistogram]          = ImVec4(1.00, 0.21, 0.21, 1.00);
    colors[clr.PlotHistogramHovered]   = ImVec4(1.00, 0.18, 0.18, 1.00);
    colors[clr.TextSelectedBg]         = ImVec4(1.00, 0.32, 0.32, 1.00);
    colors[clr.ModalWindowDimBg]       = ImVec4(0.26, 0.26, 0.26, 0.60);
end

--[[
local name_conf = imgui.new.char[256]() -- создаём буфер для инпута

local currentConfig = 'FastFullSet'
local pendingConfig = nil
local CONFIG_PREFIX = 'ffs_'
function Create_config(name)

    if not name or name == '' then return end

    local dir = getWorkingDirectory() .. '\\config\\'
    local fileName = CONFIG_PREFIX .. name .. '.json'
    local path = dir .. fileName

    if not doesDirectoryExist(dir) then
        createDirectory(dir)
    end

    if doesFileExist(path) then
        sampAddChatMessage('Файл уже существует!', -1)
        return
    end

    local default = {
        Acs1 = '0',
        Acs2 = '0',
        Acs3 = '0',
        Acs4 = '0',
        Acs5 = '0',
        Acs6 = '0',
        Acs7 = '0',
        Acs8 = '0',

        slotAcs1 = '',
        slotAcs2 = '',
        slotAcs3 = '',
        slotAcs4 = '',
        slotAcs5 = '',
        slotAcs6 = '',
        slotAcs7 = '',
        slotAcs8 = '',

        typeInv1 = '0',
        typeInv2 = '0',
        typeInv3 = '0',
        typeInv4 = '0',
        typeInv5 = '0',
        typeInv6 = '0',
        typeInv7 = '0',
        typeInv8 = '0',

        id_bind = {48}
    }
    local status, code = json(CONFIG_PREFIX .. name):Save(default)

    sampAddChatMessage(
        status and ('Создан конфиг: ' .. name) or ('Ошибка: ' .. code),
        -1
    )

end
function Delete_config(query)
    if not query or query == '' then
        sampAddChatMessage('Укажи название конфига!', -1)
        return
    end

    local list = GetAllConfigs()

    local normalizedQuery = query:lower():gsub('%s+', ' '):gsub('^%s*(.-)%s*$', '%1')

    local foundName = nil
    local matchCount = 0

    for _, cfg in ipairs(list) do
        local normalizedName = cfg:lower():gsub('%s+', ' ')

        if string.find(normalizedName, normalizedQuery, 1, true) then
            matchCount = matchCount + 1
            foundName = cfg

            if matchCount > 1 then
                sampAddChatMessage('Найдено несколько конфигов. Уточните запрос.', -1)
                return
            end
        end
    end

    if not foundName then
        sampAddChatMessage('Конфиг не найден!', -1)
        return
    end

    local path = getWorkingDirectory() .. '\\config\\' .. CONFIG_PREFIX .. foundName .. '.json'

    if not doesFileExist(path) then
        sampAddChatMessage('Файл не существует!', -1)
        return
    end

    local ok = os.remove(path)

    if ok then
        sampAddChatMessage('Конфиг удалён: ' .. foundName, -1)
    else
        sampAddChatMessage('Ошибка удаления файла!', -1)
    end
end
function GetAllConfigs()
    local dir = getWorkingDirectory() .. '\\config\\' .. CONFIG_PREFIX .. '*.json'
    local list = {}

    local handle, name = findFirstFile(dir)

    if handle == -1 or not name then
        return {}
    end

    while name do
        if type(name) == 'string' then
            local clean = name
                :gsub('%.json$', '')
                :gsub('^' .. CONFIG_PREFIX, '')

            if clean ~= '' then
                table.insert(list, clean)
            end
        end

        name = findNextFile(handle)
    end

    findClose(handle)

    return list
end
function loadConfig(name)
    if not name or name == '' then return end

    currentConfig = name

    settings = json(CONFIG_PREFIX .. name):Load({
        Acs1 = '0', Acs2 = '0', Acs3 = '0', Acs4 = '0',
        Acs5 = '0', Acs6 = '0', Acs7 = '0', Acs8 = '0',

        slotAcs1 = '', slotAcs2 = '', slotAcs3 = '', slotAcs4 = '',
        slotAcs5 = '', slotAcs6 = '', slotAcs7 = '', slotAcs8 = '',

        typeInv1 = '0', typeInv2 = '0', typeInv3 = '0', typeInv4 = '0',
        typeInv5 = '0', typeInv6 = '0', typeInv7 = '0', typeInv8 = '0',

        id_bind = {48}
    })

    sampAddChatMessage(tag .. ' Загружен конфиг: ' .. name, base_color)
end

imgui.PushItemWidth(150)
imgui.InputText(u8"Название конфига", name_conf, 256)
imgui.PushItemWidth(0)
if imgui.Button(u8'Создать конфиг') then
    local name = u8:decode(ffi.string(name_conf))
    Create_config(name)
end

local list = GetAllConfigs() or {}

if imgui.CollapsingHeader(u8'Список конфигов (LIVE):') then

    if #list == 0 then
        imgui.Text(u8'Конфиги не найдены')
    else
        for i, name in ipairs(list) do

            local isActive = (name == currentConfig)

            if isActive then
                imgui.TextColored(imgui.ImVec4(0, 1, 0, 1), u8('[ACTIVE] ' .. name))
            end

            if imgui.Button(u8('Загрузить##' .. name)) then
                pendingConfig = name
            end

            if pendingConfig then
                loadConfig(pendingConfig)
                pendingConfig = nil
            end

        end
    end
end
if #list > 0 then
    for i, name in ipairs(list) do
        if imgui.CollapsingHeader(u8('Конфиг: ' .. name .. '##' .. i)) then
            if imgui.Button(u8'Удалить конфиг##' .. i) then
                Delete_config(name)
            end
            
        end
    end
end

sampRegisterChatCommand('crfile', function (arg)
    if not arg or arg == '' then
        return
    end

    Create_config(arg)
end)
sampRegisterChatCommand('checklist', function ()
    local list = GetAllConfigs()

    if #list == 0 then
        sampAddChatMessage('Конфиги не найдены', -1)
        return
    end

    sampAddChatMessage('Список конфигов:', -1)

    for i, name in ipairs(list) do
        sampAddChatMessage(i .. '. ' .. name, -1)
    end
end)
sampRegisterChatCommand('delcfg', function (arg)
    Delete_config(arg)
end)




]]

--[[
if imgui.CollapsingHeader(u8'##111') then
                for slotNum = 1, 8 do
                    -- Получаем ID аксессуара для текущего слота из настроек
                    local acsId = settings['Acs' .. slotNum]
                    local acsName = nil

                    -- Проверяем, существует ли таблица для этого слота
                    if fullacs[slotNum] then
                        -- Ищем название аксессуара по ID в таблице для текущего слота
                        for name, id in pairs(fullacs[slotNum]) do
                            if id == acsId then
                                acsName = name
                                break
                            end
                        end
                    end

                    -- Формируем текст для отображения
                    local displayText
                    if acsName then
                        displayText = u8(slotNum .. ' слот - ' .. acsName .. ' (ID: ' .. acsId .. ')')
                    else
                        displayText = u8(slotNum .. ' слот - не выбран')
                    end

                    imgui.Text(displayText)

                    if imgui.CollapsingHeader(u8'Доступные аксессуары на выбор##'..slotNum) then
                        -- Получаем ID аксессуара для текущего слота из настроек
                        local settingField = 'Acs' .. slotNum

                        local keys = {}
                        for k in pairs(fullacs[slotNum]) do
                            table.insert(keys, k)
                        end

                        for i, v in pairs(keys) do
                            if imgui.Button(u8(v)) then
                                matchedId = fullacs[slotNum][v]
                                settings[settingField] = matchedId
                                local status, code = save_config()
                                sampAddChatMessage(tag .. 
                                (status and ' Слот ' .. slotNum .. ': "' .. v .. '" (ID: ' .. matchedId .. ') сохранён!'
                                or ' Не смог сохранить: '..code), 
                                base_color)
                            end
                        end

                    end
                end
            end
]]