if not fs.exists("/rom/MeteorOS") then
    fs.makeDir("/rom/MeteorOS")
end
if not fs.exists("/rom/MeteorOS/modules") then
    fs.makeDir("/rom/MeteorOS/modules")
end
local githubURL = "https://raw.githubusercontent.com/Mag1cpunch/Meteor_OS/main"
local filesToDownload = {
    {
        path = "/rom/MeteorOS/modules/system.lua"
        url = githubURL .. "/modules/system.lua"
    },
    {
        path = "/rom/MeteorOS/modules/bootloader.lua"
        url = githubURL .. "/modules/bootloader.lua"
    },
    {
        path = "/rom/MeteorOS/modules/gui.lua"
        url = githubURL .. "/modules/gui.lua"
    },
    {
        path = "/rom/MeteorOS/modules/meteorkernel.lua"
        url = githubURL .. "/modules/meteorkernel.lua"
    },
    {
        path = "/rom/startup.lua"
        url = githubURL .. "/scr/startup.lua"
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
local function init()
    if fs.exists("/rom/startup.lua") then
        print("Formatting...")
        os.sleep(2)
        fs.delete("/rom/startup.lua")
        print("Successfully Formated!")
        os.sleep(2)
        installFiles()
        print("Installation complete!")
        os.sleep(1)
        print("Rebooting in 3 seconds...")
        os.reboot()
    else
        installFiles()
        print("Installation complete!")
        os.sleep(1)
        print("Rebooting in 3 seconds...")
        os.reboot()
    end
end
init()
