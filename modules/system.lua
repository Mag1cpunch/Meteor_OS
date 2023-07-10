local fs = {}

local pr = {
    peripheral.find("back")
    peripheral.find("front")
    peripheral.find("left")
    peripheral.find("right")
    peripheral.find("top")
    peripheral.find("bottom")
}
local freespace = fs.getFreeSpace("/")
function fs.getTotalSpace()
    local a = fs.getSize("/rom")
    local b = fs.getSize("/MeteorOS")
    local c = fs.getFreeSpace("/")
    local totalspace = a + b + c
    return totalspace
end
function fs.isexist(path)
    return fs.exists(path)
end
function fs.getCap(path)
    local cap = fs.getCapacity(path)
    return cap
end
function fs.cp(fPath, tPath)
    fs.copy(fPath, tPath)
end
function fs.cmb(bPath, lPath)
    fs.combine(bPath, lPath)
end

return fs
