local currentDir = "/"
local modem = peripheral.find("modem")

print("---------------------------------")
print("[[Welcome to MeteorOS by Meteor!]]")
print("---------------------------------")

local function list(dir)
    if fs.exists(dir) then
        local files = fs.list(dir)
        for _, file in pairs(files) do
            print(file)
        end
    else
        print("Directory '" .. dir .. "' doesn't exist!")
    end
end

local function gotoDirectory(dir)
    if dir == "" then
        dir = currentDir
    end

    if fs.isDir(dir) then
        currentDir = fs.combine(currentDir, dir)
    else
        print("'" .. dir .. "' is not a valid directory!")
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

local function showHelp()
    print("Available Commands:")
    print("help - Show available commands.")
    print("updateos - Update the operating system.")
    print("reboot - Reboot the operating system.")
    print("shutdown - Shutdown the operating system.")
    print("goto - Will go to specified folder.")
    print("diskspace - Will show diskspace.")
    print("createdir - Will create a dir with a specified name.")
    print("removedir - Will delete dir with a specified name")
    print("sendfile - Will send a specified file to specified device")
    print("senddir - Will send a specified dir to specified device")
    print("devices - Will show available devices in range(Requires Wireless Modem or Ender Modem)")
    print("gui - Will start the system gui(Not working)")
    print("list - Will list directories and files in the current selected path")
end

local githubURL = "https://raw.githubusercontent.com/Mag1cpunch/Meteor_OS/main"
local filesToDownload = {
    {
        path = "/rom/MeteorOS/modules/system.lua",
        url = githubURL .. "/modules/system.lua"
    },
    {
        path = "/rom/MeteorOS/modules/bootloader.lua",
        url = githubURL .. "/modules/bootloader.lua"
    },
    {
        path = "/rom/MeteorOS/modules/gui.lua",
        url = githubURL .. "/modules/gui.lua"
    },
    {
        path = "/rom/MeteorOS/modules/meteorkernel.lua",
        url = githubURL .. "/modules/meteorkernel.lua"
    },
    {
        path = "/rom/startup",
        url = githubURL .. "/scr/startup"
    },
}

function downloadFile(url, path)
    local response = http.get(url)
    if response then
        local file = fs.open(path, "w")
        file.write(response.readAll())
        file.close()
        response.close()
        return true
    else
        print("Failed to download file: " .. path)
        return false
    end
end

local function installFiles()
    for _, file in ipairs(filesToDownload) do
        print("Downloading file: " .. file.path)
        local success = downloadFile(file.url, file.path)
        if success then
            print("File installed: " .. file.path)
        else
            print("Failed to install file: " .. file.path)
        end
    end
end

local function initinstall()
    if fs.exists("/rom/startup.lua") then
        print("Formatting...")
        os.sleep(2)
        fs.delete("/rom/startup.lua")
        print("Successfully Formated!")
        os.sleep(2)
        print("Creating directories...")
        os.sleep(2)
        if not fs.exists("/MeteorOS") then
            fs.makeDir("/rom/MeteorOS")
        end
        if not fs.exists("/MeteorOS/modules") then
            fs.makeDir("/MeteorOS/modules")
        end
        os.sleep(2)
        print("Updating System...")
        installFiles()
        print("Installation complete!")
        os.sleep(1)
        print("Rebooting in 3 seconds...")
        os.reboot()
    else
        print("Creating directories...")
        os.sleep(2)
        if not fs.exists("/MeteorOS") then
            fs.makeDir("/rom/MeteorOS")
        end
        if not fs.exists("/MeteorOS/modules") then
            fs.makeDir("/MeteorOS/modules")
        end
        print("Installing system...")
        os.sleep(2)
        installFiles()
        print("Installation complete!")
        os.sleep(1)
        print("Rebooting in 3 seconds...")
        os.reboot()
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
        drawDesktop()
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
    elseif command == "help" then
        showHelp()
    elseif command == "gui" then
        startGUI()
    elseif command == "updateos" then
        initinstall()
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
