local currentDir = "/"
local modem = peripheral.find("modem")

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

local function parseCommand(input)
    local parts = {}
    for part in string.gmatch(input, "%S+") do
        table.insert(parts, part)
    end

    if #parts >= 1 then
        return parts[1], parts[2], parts[3]
    else
        return nil, nil, nil
    end
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
    else
        print("Invalid command!")
        return -- Add this line
    end
end

while true do
    io.write(currentDir .. " $~ ")
    local input = read()

    local command, param1, param2 = parseCommand(input)
    executeCommand(command, param1, param2)
end