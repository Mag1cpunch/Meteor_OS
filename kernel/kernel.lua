local fstree = {
    "/MeteorOS",
    "/MeteorOS/modules",
    "/MeteorOS/boot",
    "/MeteorOS/etc",
    "/MeteorOS/usr",
    "/MeteorOS/sbin",
    "/MeteorOS/var",
    "/MeteorOS/tmp",
    "/MeteorOS/dev",
    "/MeteorOS/dev/block",
    "/MeteorOS/dev/sda1"
}

-- File System
function initfs()
    print("Verifying EXT3 FileSystem...")
    os.sleep(3)
    if not fs.exists("/MeteorOS") then
        fs.makeDir("/MeteorOS")
    end
    if not fs.exists("/MeteorOS/modules") then
        fs.makeDir("/MeteorOS/modules")
    end
    if not fs.exists("/MeteorOS/boot") then
        fs.makeDir("/MeteorOS/boot")
    end
    if not fs.exists("/MeteorOS/etc") then
        fs.makeDir("/MeteorOS/etc")
    end
    if not fs.exists("/MeteorOS/usr") then
        fs.makeDir("/MeteorOS/usr")
    end
    if not fs.exists("/MeteorOS/sbin") then
        fs.makeDir("/MeteorOS/sbin")
    end
    if not fs.exists("/MeteorOS/var") then
        fs.makeDir("/MeteorOS/var")
    end
    if not fs.exists("/MeteorOS/tmp") then
        fs.makeDir("/MeteorOS/tmp")
    end
    if not fs.exists("/MeteorOS/dev") then
        fs.makeDir("/MeteorOS/dev")
    end
    if not fs.exists("/MeteorOS/dev/block") then
        fs.makeDir("/MeteorOS/dev/block")
    end
    if not fs.exists("/MeteorOS/dev/sda1") then
        fs.makeDir("/MeteorOS/dev/sda1")
    end
    print("[ OK ] EXT3 FileSystem Initialized!")
end

function cli()
    term.clear()
    term.setBackgroundColor(40)
    term.setTextColor(colors.orange)
    term.write("----------------------------------------------------------------\n")
    term.write("|Welcome to MeteorOS by Meteor! Say 'help' for list of commands|\n")
    term.write("----------------------------------------------------------------\n")
    shell.run("/MeteorOS/bin/shell.lua")
end

function meteorNet()
    rednet.host("1", "MeteorDevice" .. math.random(1000, 9999))
end

function kernel()
    initfs()
    meteorNet()
    cli()
end

kernel()