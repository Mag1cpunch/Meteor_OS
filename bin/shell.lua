local currentDir = "/MeteorOS"
local modem = peripheral.find("modem")

function errorHandler(err)
    -- Log the error or perform any necessary actions
    print("An error occurred: " .. tostring(err))
end

function safeCall(func, ...)
    local args = {...}
    local success, result = pcall(function()
      return func(unpack(args))
    end)
    
    if not success then
      errorHandler(result)
    end
    
    return result
end

local function list()
    local files = fs.list(currentDir)
    for file in files do
        print(file)
    end
end

local function gotoDirectory(dir)
    if dir == ".." then
        -- Go up one level
        currentDir = fs.path(currentDir)
    elseif dir == "/" then
        -- Go to the root directory
        currentDir = "/"
    else
        -- Check if the directory exists
        local path = fs.concat(currentDir, dir)
        if fs.isDirectory(path) then
            currentDir = path
        else
            print("Directory '" .. dir .. "' does not exist!")
        end
    end
end

local function createDir(dir)
    local path = fs.combine(currentDir, dir)
    if not fs.exists(path) then
        fs.makeDir(path)
        print("Directory '" .. dir .. "' created!")
    else
        print("Directory '" .. dir .. "' already exists!")
    end
end

local function removeDir(dir)
    local path = fs.combine(currentDir, dir)
    if fs.exists(path) then
        fs.delete(path)
        print("Directory '" .. dir .. "' removed!")
    else
        print("Directory '" .. dir .. "' does not exist!")
    end
end

local function diskspace()
    local freeSpace = fs.getFreeSpace("/")
    local usedSpace = fs.getSize("/")
    local totalSpace = freeSpace + usedSpace

    print("Disk Space:")
    print("Total: " .. totalSpace .. " bytes")
    print("Used: " .. usedSpace .. " bytes")
    print("Free: " .. freeSpace .. " bytes")
end

local function sendFile(source, destination)
    if not fs.exists(source) then
        print("File '" .. source .. "' does not exist!")
        return
    end

    if not modem then
        print("Wireless modem not found!")
        return
    end

    modem.transmit(1337, 1337, fs.getName(source), fs.open(source, "r").readAll())
    print("File '" .. source .. "' sent to '" .. destination .. "'")
end

local function sendDirectory(source, destination)
    if not fs.exists(source) then
        print("Directory '" .. source .. "' does not exist!")
        return
    end

    if not modem then
        print("Wireless modem not found!")
        return
    end

    local function traverse(dir)
        for _, item in pairs(fs.list(dir)) do
            local path = fs.combine(dir, item)
            local destPath = fs.combine(destination, fs.combine(dir, item):gsub("^" .. source, ""))

            if fs.isDir(path) then
                fs.makeDir(destPath)
                traverse(path)
            else
                modem.transmit(1337, 1337, destPath, fs.open(path, "r").readAll())
                print("File '" .. path .. "' sent to '" .. destPath .. "'")
            end
        end
    end

    fs.makeDir(destination)
    traverse(source)
end

local function checkDevicesInRange()
    local devices = peripheral.getNames()
    local modems = {}

    for _, device in ipairs(devices) do
        if peripheral.getType(device) == "modem" then
            table.insert(modems, device)
        end
    end

    if #modems > 0 then
        print("Devices with wireless modems in range:")
        for _, device in ipairs(modems) do
            print(device)
        end
    else
        print("No devices with wireless modems in range.")
    end
end

local function drawTaskbar()
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1, 1)
    term.clearLine()
    term.write("[Start]")
    term.setCursorPos(2, 1)
    term.write("Taskbar")
end

local function drawDesktop()
    term.setBackgroundColor(colors.lightGray)
    term.clear()
    drawTaskbar()
end

local function startGUI()
    while true do
        safeCall(drawDesktop)
        local event, button, x, y = os.pullEvent("mouse_click")
        if button == 1 and y == 1 then
            print("Start menu clicked!")
            -- Add your start menu functionality here
        end
    end
end

local function parseCommand(input)
    local command, param1, param2 = string.match(input, "(%S+)%s*(%S*)%s*(%S*)")
    return command, param1, param2
end

local function executeCommand(command, param1, param2)
    if command == "list" then
        if param1 == "" then
            list(currentDir)
        else
            list(param1)
        end
    elseif command == "reboot" then
        os.reboot()
    elseif command == "shutdown" then
        os.shutdown()
    elseif command == "goto" then
        safeCall(gotoDirectory, param1)
    elseif command == "diskspace" then
        safeCall(diskspace)
    elseif command == "createdir" then
        safeCall(createDir, param1)
    elseif command == "removedir" then
        safeCall(removeDir, param1)
    elseif command == "sendfile" then
        safeCall(sendFile, param1, param2)
    elseif command == "senddir" then
        safeCall(sendDirectory, param1, param2)
    elseif command == "devices" then
        safeCall(checkDevicesInRange)
    elseif command == "gui" then
        safeCall(startGUI)
    else
        print("Invalid command!")
    end
end

while true do
    io.write(currentDir .. " $~ ")
    local input = read()

    local command, param1, param2 = parseCommand(input)
    executeCommand(command, param1, param2)
end