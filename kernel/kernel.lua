local mapi = os.loadAPI("/MeteorOS/modules/meteorapi.lua")
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
    if not fs.exists(fstree) then
        print("EXT3 FileSystem tree not found generating new...")
        os.sleep(3)
        mapi.makedirs(fstree)
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
    rednet.open("back")
    rednet.open("front")
    rednet.open("left")
    rednet.open("right")
    rednet.open("top")
    rednet.open("bottom")
    rednet.host("1", "MeteorDevice" .. math.random(1000, 9999))
end

function kernel()
    initfs()
    meteorNet()
    cli()
end

kernel()