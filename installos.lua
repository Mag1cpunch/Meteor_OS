if not fs.exists("/MeteorOS") then
    fs.makeDir("/MeteorOS")
end
if not fs.exists("/MeteorOS/modules") then
    fs.makeDir("/MeteorOS/modules")
end
local githubURL = "https://raw.githubusercontent.com/Mag1cpunch/Meteor_OS/main"
local filesToDownload = {
    {
        path = "/MeteorOS/modules/system.lua",
        url = githubURL .. "/modules/system.lua"
    },
    {
        path = "/MeteorOS/modules/bootloader.lua",
        url = githubURL .. "/modules/bootloader.lua"
    },
    {
        path = "/MeteorOS/modules/gui.lua",
        url = githubURL .. "/modules/gui.lua"
    },
    {
        path = "/MeteorOS/modules/meteorkernel.lua",
        url = githubURL .. "/modules/meteorkernel.lua"
    },
    {
        path = "/startup",
        url = githubURL .. "/src/startup"
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
	if fs.exists("/MeteorOS") then
		print("MeteorOS installation was found, formatting for update...")
		os.sleep(6)
		if fs.exists("/MeteorOS/Modules/system.lua") then
			fs.delete("/MeteorOS/Modules/system.lua")
		end
		if fs.exists("/MeteorOS/Modules/bootloader.lua") then
			fs.delete("/MeteorOS/Modules/bootloader.lua")
		end
		if fs.exists("/MeteorOS/Modules/meteorkernel.lua") then
			fs.delete("/MeteorOS/Modules/meteorkernel.lua")
		end
		if fs.exists("/MeteorOS/Modules/gui.lua") then
			fs.delete("/MeteorOS/Modules/gui.lua")
		end
		if fs.exists("/MeteorOS/Modules") then
			fs.delete("/MeteorOS/Modules")
		end
		if fs.exists("/startup") then
			fs.delete("/startup")
		end
		fs.delete("/MeteorOS")
		os.sleep(3)
		print("Successfully Formatted!")
		os.sleep(2)
	end
	print("Installing the system")
	installFiles()
    print("Installation complete!")
    os.sleep(1)
    print("Rebooting in 3 seconds...")
    os.reboot()
end
init()
