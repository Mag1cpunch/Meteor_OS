function bootcli()
    shell.run("/MeteorOS/kernel/kernel.lua")
    print("Starting MeteorOS...")
    os.sleep(3)
    shell.run("/MeteorOS/bin/shell.lua")
end

bootcli()