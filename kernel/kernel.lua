local mkernel = {}
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

local rootDevice = {
    type = "virtual",
    path = "/",
    children = {
        dev = {
            type = "virtual",
            path = "/dev",
            children = {
                mcblk0p1 = {
                    type = "disk",
                    path = "/dev/mcblk0p1",
                },
                mcblk0p2 = {
                    type = "disk",
                    path = "/dev/mcblk0p2",
                },
            },
        },
    },
}

-- File System
function initfs()
    if not fs.exists(fstree) then
        mapi.makedirs(fstree)
    end
    fs.mount(rootDevice, "/")
    fs.mount(rootDevice.children.dev.mcblk0p2, "/var")
    shell.run("/MeteorOS/bin/shell.lua")
end

function cli()
    term.clear()
    term.setBackgroundColor(40)
    term.setTextColor(colors.orange)
    term.write("----------------------------------------------------------------\n")
    term.write("|Welcome to MeteorOS by Meteor! Say 'help' for list of commands|\n")
    term.write("----------------------------------------------------------------\n")
end

function mkernel.drawBox(startX, startY, endX, endY, color)
    term.setBackgroundColor(color)
    term.clear()
end

function mkernel.drawButton(text, x, y, width)
    local height = 3
    local padding = 2
    local textX = x + math.floor((width - #text) / 2)
    local textY = y + math.floor((height - 1) / 2)

    term.setCursorPos(x, y)
    term.setBackgroundColor(colors.lightGray)
    term.setTextColor(colors.white)
    term.clearLine()

    term.setCursorPos(x, y + 1)
    term.write(string.rep(" ", width))

    term.setCursorPos(x, y + height)
    term.clearLine()

    term.setCursorPos(textX, textY)
    term.write(text)
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
    cli()
    meteorNet()
end

kernel()
return mkernel