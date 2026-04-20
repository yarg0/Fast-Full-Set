script_name("{e6953e}Fast Full Set {ffffff}by yargoff")
script_author('yargoff')

local hotkey = require('mimhotkey') -- подключаем библиотеку
local imgui = require 'mimgui'
local encoding = require 'encoding'
encoding.default = 'CP1251'
u8 = encoding.UTF8

local tag = '{c99732}[Fast Full Set]{ffffff}'
local base_color = 0xFFe69f35

local fullacs = {
    {
    ['Нимб медведя'] = '9575',
    ['Нимб 5 ЗВ'] = '8763',
    ['Джетпак'] = '7361',
    ['Космический джетпак'] = '9059'
},
    {
    ['Шапка медведя'] = '9566',
    ['Маска-невидимка'] = '6264',
    ['Энерго маска Госта'] = '8762',
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
    ['Энегетические часы'] = '8005'
},  
    {
    ['Ожерелье медведя'] = '9581',
    ['Обрез'] = '8763',
    ['Энергетический махинатор'] = '7852',
    ['Цепь Махинатор'] = '6313',
    ['Цепь Иллюмината'] = '8555',
    ['Золотая гангстерская цепь'] = '8727',
},
    {
    ['Наплечник медведя'] = '9563',
    ['Энергетический воздушный шар'] = '7410',
    ['Аркана ИО'] = '8183',
    ['Летучий Голладец'] = '8760',
    ['Энергетический КУРА шар'] = '8178'
},
    {
    ['Плащ медведя'] = '9578',
    ['Арабалет Траксы'] = '8167',
    ['Энергетический щит'] = '7253',
    ['Золотая монтировка'] = '8801',
},
    {
    ['Броня медведя'] = '9560',
    ['Генеральский бронежилет'] = '7846',
},
    {
    ['Пояс медведя'] = '9569',
    ['Энергетический чемодан'] = '7406',
    ['Чемодан криминала'] = '8794'
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

local settings = json('FastFullSet.json'):Load({
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

local renderWindow = imgui.new.bool(false)
imgui.OnInitialize(function()
    imgui.GetIO().IniFilename = nil
    theme()
end)

local newFrame = imgui.OnFrame(
    function() return renderWindow[0] end,
    function(player)
        local resX, resY = getScreenResolution()
        local sizeX, sizeY = 300, 400
        imgui.SetNextWindowPos(imgui.ImVec2(resX / 2, resY / 2), imgui.Cond.FirstUseEver, imgui.ImVec2(0.5, 0.5))
        imgui.SetNextWindowSize(imgui.ImVec2(sizeX, sizeY), imgui.Cond.FirstUseEver)
        if imgui.Begin('Fast Full Set', renderWindow, imgui.WindowFlags.NoCollapse + imgui.WindowFlags.NoScrollbar + imgui.WindowFlags.NoResize) then
            
            local NewKey_Use = hotkey.KeyEditor('bind', u8'Горячая клавиша')
            if NewKey_Use then
                sampAddChatMessage(tag..' Бинд изменен на: '..hotkey.GetBindKeys(NewKey_Use), base_color)
                settings.id_bind = NewKey_Use
                json('FastFullSet.json'):Save(settings)
            end

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
                            local status, code = json('FastFullSet.json'):Save(settings)
                            sampAddChatMessage(tag .. 
                            (status and ' Слот ' .. slotNum .. ': "' .. v .. '" (ID: ' .. matchedId .. ') сохранён!'
                            or ' Не смог сохранить: '..code), 
                            base_color)
                        end
                    end

                end
            end

            imgui.End()
        end
    end
)

local fastFullSet = false
local inventoryRequested = false
function main()
    while not isSampAvailable() do wait(0) end

    sampAddChatMessage(tag..' Скрипт загружен! Автор: {7ce653}yargoff', base_color)

    sampRegisterChatCommand('ffsm', function()
        renderWindow[0] = not renderWindow[0]
    end)
    
    sampRegisterChatCommand('ffs', FastFullSet)

    sampRegisterChatCommand('acs', function(arg)
        local SlotAcs, WhoIsAcs = arg:match('(%d+)%s+(.*)')

        if not SlotAcs or SlotAcs == '' then
            sampAddChatMessage(tag .. ' Отсутствует правильно введённый первый аргумент', base_color)
            return
        end

        local SAcs = tonumber(SlotAcs)
        if SAcs < 1 or SAcs > 8 then
            sampAddChatMessage(tag .. ' Выберите корректный слот для выбираемого аксессуара... (от 1 до 8)', base_color)
            return
        end

        -- Проверяем существование таблицы для выбранного слота
        if not fullacs[SAcs] then
            sampAddChatMessage(tag .. ' Таблица для слота ' .. SAcs .. ' не найдена!', base_color)
            return
        end

        -- Нормализуем поисковый запрос
        local normalizedQuery = WhoIsAcs:lower():gsub('%s+', ' '):gsub('^%s*(.-)%s*$', '%1')

        -- Получаем список названий предметов для выбранного слота
        local keys = {}
        for k in pairs(fullacs[SAcs]) do
            table.insert(keys, k)
        end

        local found = false
        local matchedName = nil
        local matchedId = nil
        local matchCount = 0

        -- Перебираем все названия предметов в таблице
        for _, itemName in ipairs(keys) do
            -- Нормализуем название предмета
            local normalizedName = itemName:lower():gsub('%s+', ' '):gsub('^%s*(.-)%s*$', '%1')

            -- Разбиваем запрос на слова
            local queryWords = {}
            for word in normalizedQuery:gmatch('%S+') do
                table.insert(queryWords, word)
            end

            -- Проверяем, что все слова из запроса присутствуют в названии
            local allWordsMatch = true
            for _, word in ipairs(queryWords) do
                if not string.find(normalizedName, word, 1, true) then
                    allWordsMatch = false
                    break
                end
            end

            if allWordsMatch then
                matchCount = matchCount + 1
                matchedName = itemName
                matchedId = fullacs[SAcs][itemName]
                found = true

                -- Если нашли более одного совпадения, прерываем
                if matchCount > 1 then
                    sampAddChatMessage(tag .. ' Найдено несколько похожих аксессуаров. Уточните запрос.', base_color)
                    return
                end
            end
        end

        -- Обрабатываем результаты поиска
        if found and matchCount == 1 then
            -- Динамически формируем имя поля в settings
            local settingField = 'Acs' .. SAcs
            settings[settingField] = matchedId

            local status, code = json('FastFullSet.json'):Save(settings)
            sampAddChatMessage(
                tag .. ' Слот ' .. SAcs .. ': "' .. matchedName .. '" (ID: ' .. matchedId .. ') сохранён!',
                base_color)
        elseif not found then
            sampAddChatMessage(tag .. ' Введённый вами аксессуар отсутствует в базе...', base_color)
        end
    end)

    hotkey.RegisterCallback('bind', settings.id_bind, FastFullSet)
    hotkey.Text.wait_for_key = u8'Нажмите клавишу...'
    hotkey.Text.no_key = u8'Отсутствует'
    while true do
        wait(0)

    end
end

function FastFullSet()
    if not isCursorActive() and not sampIsDialogActive() and not sampIsChatInputActive() then
        fastFullSet = true
        sampSendChat('/invent')
    end
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
                for slotNum = 1,8 do

                    local fAcs = 'Acs' .. slotNum
                    local ftypeInv = 'typeInv' .. slotNum
                    local fslotAcs = 'slotAcs' .. slotNum

                    local typeInv, slot = str:match('type":(%d+),"items":%[{"slot":(%d+),"available":1,"blackout":0,"item":'..tostring(settings[fAcs])..'')
                    
                    if typeInv then
                        settings[ftypeInv] = typeInv
                    end

                    if slot then
                        settings[fslotAcs] = slot
                    end

                    local status, code = json('FastFullSet.json'):Save(settings)

                    if not status then
                        sampAddChatMessage(tag .. ' Ошибка сохранения настроек: ' .. code, base_color)
                    end
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
                        for i = 1, 6 do
                            wait(30)
                            local typeField = 'typeInv' .. i
                            local slotField = 'slotAcs' .. i

                            if settings[typeField] ~= '2' and settings[slotField] ~= '' then
                                sendCEF('inventory.moveItemForce|{"slot": ' .. settings[slotField] .. ', "type": 1, "amount": 1}')
                            end
                        end

                        wait(80)
                        if settings.typeInv7 ~= '17' and settings.slotAcs7 ~= '' then
                            sendCEF('inventory.moveItem|{"from":{"slot":'..settings.slotAcs7..',"type":1,"amount":1},"to":{"slot":0,"type":17}}')
                        end
                        if settings.typeInv8 ~= '17' and settings.slotAcs8 ~= '' then
                            sendCEF('inventory.moveItem|{"from":{"slot":'..settings.slotAcs8..',"type":1,"amount":1},"to":{"slot":1,"type":17}}')
                        end

                        fastFullSet = false
                        sendCEF('inventoryClose')
                        inventoryRequested = false
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