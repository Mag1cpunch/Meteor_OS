local currentDir = "/"
local modem = peripheral.find("modem")
local mapi = os.loadAPI("/MeteorOS/modules/meteorapi.lua")
local ui = os.loadAPI("/MeteorOS/modules/gui.lua")

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

local function clearScreen()
  term.clear()
  term.setCursorPos(1, 1)
end

local function drawButton(text, x, y, width)
  local height = 3
  local padding = 2
  local textX = x + (width - #text) / 2
  local textY = y + (height - 1) / 2

  term.setCursorPos(x, y)
  term.setBackgroundColor(colors.lightGray)
  term.setTextColor(colors.white)
  term.clearLine()

  term.setCursorPos(x, y + 1)
  term.write(string.rep(" ", width))

  term.setCursorPos(x, y + height)
  term.clearLine()

  term.setCursorPos(textX, textY)
  term.write(text)
end

local function drawMenu()
  clearScreen()

  local menuWidth = 20
  local menuHeight = 10
  local menuX = math.floor((term.getSize() - menuWidth) / 2)
  local menuY = math.floor((term.getSize() - menuHeight) / 2)

  drawButton("CLI", menuX, menuY, menuWidth)
  drawButton("GUI", menuX, menuY + 4, menuWidth)
end

local function handleButtonClick(x, y)
  if y == menuY then
    -- Handle Boot to CLI button click
    -- Add your CLI boot logic here
    print("Booting to CLI...")
    sleep(2)
    shell.run("/MeteorOS/modules/system.lua")
  elseif y == menuY + 4 then
    -- Handle Boot to GUI button click
    -- Add your GUI boot logic here
    print("Booting to GUI...")
    sleep(2)
    shell.run("/MeteorOS/modules/gui.lua")
  end
end

local function waitForButtonClick()
  while true do
    local event, button, x, y = os.pullEvent("mouse_click")

    if event == "mouse_click" then
      if x >= menuX and x < menuX + menuWidth then
        if y == menuY or y == menuY + 4 then
          handleButtonClick(x, y)
          return
        end
      end
    end
  end
end

local function drawDesktop()
    term.setBackgroundColor(colors.lightGray)
    term.clear()
    drawTaskbar()
end

local function startGUI()
    while true do
        drawDesktop()
        local event, button, x, y = os.pullEvent("mouse_click")
        if button == 1 and y == 1 then
            print("Start menu clicked!")
            -- Add your start menu functionality here
        end
    end
end

drawMenu()
waitForButtonClick()

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
        gotoDirectory(param1)
    elseif command == "diskspace" then
        diskspace()
    elseif command == "createdir" then
        createDir(param1)
    elseif command == "removedir" then
        removeDir(param1)
    elseif command == "sendfile" then
        sendFile(param1, param2)
    elseif command == "senddir" then
        sendDirectory(param1, param2)
    elseif command == "devices" then
        checkDevicesInRange()
    elseif command == "gui" then
        ui.setupgui()
    elseif command == "gui" then
        startGUI()
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
