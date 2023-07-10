function boot()
    local freespace = getFreeSpace("/")
    local romsize = fs.getSize("/rom")
    local meteorsize = fs.getSize("/MeteorOS")
    local totalspace = meteorsize + romsize + freespace
    print("/dev/sda1: clean, "..totalspace.."/"..totalspace.." files, 4146215/121076480 blocks")
    print("Starting MeteorOS...")
    os.sleep(3)
    shell.run("/MeteorOS/modules/system.lua")
end
boot()
