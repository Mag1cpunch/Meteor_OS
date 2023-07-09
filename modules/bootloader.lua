function boot()
    print("/dev/"..fs.getDir("/rom")..": clean, "..fs.getSize("/").."/"..fs.getCapacity("/").." files, 4146215/121076480 blocks")
    print("Starting MeteorOS...")
    os.sleep(3)
    shell.run("/MeteorOS/modules/system.lua")
end
boot()