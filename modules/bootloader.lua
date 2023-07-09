function boot()
    print("Starting MeteorOS...")
    os.sleep(3)
    shell.run("/MeteorOS/modules/system.lua")
end
boot()
