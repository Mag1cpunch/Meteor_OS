local mapi = os.loadAPI("/MeteorOS/modules/meteorapi.lua")
local fstree = {
    "/MeteorOS",
    "/MeteorOS/modules",
    "/MeteorOS/boot",
    "/MeteorOS/etc",
    "/MeteorOS/usr",
    "/MeteorOS/bin",
    "/MeteorOS/sbin",
    "/MeteorOS/dev",
    "/MeteorOS/dev/block",
    "/MeteorOS/dev/sda1"
}

--File System
function initfs()
    if not fs.exists(in fstree)
        mapi.makedirs(fstree)
    end
end
function cli()
    term.clear()
    term.setBackgroundColor(40, 40, 40)
    term.setTextColor(255, 147, 0)
    term.write("----------------------------------------------------------------")
    term.write("|Welcome to MeteorOS by Meteor! Say 'help' for list of commands|")
    term.write("----------------------------------------------------------------")
end
function kernel()
    initfs()
    cli()
end
kernel()