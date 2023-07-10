function bootcli()
    local freespace = getFreeSpace("/")
    local romsize = fs.getSize("/rom")
    local meteorsize = fs.getSize("/MeteorOS")
    local filessize = romsize + meteorsize
    local totalspace = meteorsize + romsize + freespace
    print("/dev/sda1: clean, ".. filessize .."/".. totalspace .." files, 4146215/121076480 blocks")
    print("Starting MeteorOS...")
    os.sleep(3)
    shell.run("/MeteorOS/bin/shell.lua")
end

bootcli()