local mapi = {}

--Operating System API
function mapi.wait(time)
    os.sleep(time)
end
function mapi.require(path)
    os.loadAPI(path)
end
function mapi.version()
    print("Current Firmware version is: "..os.version().."")
end
function mapi.day()
    print("Amount of days passed: "..os.day().."")
end

--FileSystem API
function mapi.makedirs(dirs)
    -- Create directories recursively
    local currentPath = ""
    for i, dir in ipairs(dirs) do
        currentPath = fs.combine(currentPath, dir)
        if not fs.exists(currentPath) then
            fs.makeDir(currentPath)
        elseif not fs.isDir(currentPath) then
            print("Error: Path '" .. currentPath .. "' already exists and is not a directory.")
            return
        end
    end
end
function mapi.com(basePath, localPath)
    fs.combine(basePath, localPath)
end

--Network API
function mapi.netstart(side)
    rednet.open(side)
end
function mapi.netstop(side)
    rednet.close(side)
end
function mapi.netsend(receiverID, message, protocol)
    rednet.send(receiverID, message, protocol)
end
function mapi.netcast(message, protocol)
    rednet.broadcast(message, protocol)
end
function mapi.netrec(protocolFilter, timeout)
    rednet.receive(protocolFilter, timeout)
end
function mapi.isnetopen(side)
    rednet.isOpen(side)
end
function mapi.netlist(protocol, hostname)
    rednet.lookup(protocol, hostname)
end
function mapi.netrun()
    rednet.run()
end

--GPS API
function mapi.gpsloc(timeout, debug)
    gps.locate(timeout, debug)
end

-- TextUtils API
function mapi.slowprint(text, rate)
    textutils.slowPrint(text, rate)
end
function mapi.slowwrite(text, rate)
    textutils.slowWrite(text, rate)
end
function mapi.tabprint(table1, color1, table2, color2)
    textutils.tabulate(table1, color1, table2, color2)
end

--HTTP API
function mapi.httprequest(url, postData, headers)
    http.request(url, postData, headers)
end
function mapi.httpget(url, headers)
    http.get(url, headers)
end
function mapi.httppost(url, postData, headers)
    http.post(url, postData, headers)
end
function mapi.checkURL(url)
    http.checkURL(url)
end

--Term API
function mapi.termwrite(text)
    term.write(text)
end
function mapi.termblit(text, textcolors, backgroundcolors)
    term.blit(text, textcolors, backgroundcolors)
end
function mapi.clear()
    term.clear()
end
function mapi.lclear()
    term.clearLine
end
function mapi.getmousepos(debugisenabled)
    local mousepos = term.getCursorPos
    if debugisenabled == true then
        print(mousepos)
        return mousepos
    else
        return mousepos
    end
end
function mapi.setmousepos(x, y)
    term.setCursorPos(x, y)
end
function mapi.setmouseblink(bool)
    term.setCursorBlink(bool)
end
function mapi.iscolor(debugisenabled)
    local colorsupport = term.isColor()
    if debugisenabled == true then
        print(colorsupport)
        return colorsupport
    else
        return colorsupport
    end
end
function mapi.getres(debugisenabled)
    local res = term.getSize
    if debugisenabled == true
        print(res)
        return res
    else
        return res
    end
end
function mapi.scroll(n)
    term.scroll(n)
end
function mapi.redirect(target)
    term.redirect(target)
end
function mapi.current()
    local current = term.current()
    return current
end
function mapi.native()
    local native = term.native
    return native
end
function mapi.settextcolor(color)
    term.setTextColor(color)
end
function mapi.gettextcolor()
    local color = term.getTextColor()
    return color
end
function mapi.setbgcolor(color1, color2, color3)
    term.setBackgroundColor(color1, color2, color3)
end
function mapi.getbgcolor()
    local bgcolor = term.getBackgroundColor()
    return bgcolor
end
function mapi.setmonitortextscale(scale)
    monitor.setTextScale(scale)
end

--MT Window System
function mapi.wsetvisible(bool)
    window.setVisible(bool)
end
function mapi.wredraw()
    window.redraw()
end
function mapi.wrestmouse()
    window.restoreCursor()
end
function mapi.wgetpos()
    wpos = window.getPosition()
    return wpos
end
function mapi.wrepos(x, y, width, height)
    window.reposition(x, y, width, height)
end

--Colors API
function mapi.colorscom(color1, color2)
    colors.combine(color1, color2)
end
function mapi.colorssub(colors, color1, color2, color3, color4)
    colors.subtract(colors, color1, color2, color3, color4)
end
function mapi.test(colors, color)
    colors.test(colors, color)
end

--Commands API
function mapi.exec(command)
    commands.exec(command)
end
function mapi.execAsync(command)
    commands.execAsync(command)
end
function mapi.commandlist()
    commands.list()
end
function mapi.getblockpos()
    local blockpos = commands.getBlockPosition()
    return blockpos
end
function mapi.getblockinfo(x, y, z)
    local blockinfo = commands.getBlockInfo(x, y, z)
    return blockinfo
end
function mapi.getblockinfos(x1, y1, z1, x2, y2, z2)
    local blockinfos = commands.getBlockInfos(x1, y1, z1, x2, y2, z2)
    return blockinfos
end

--Meteor API
function mapi.setupgui()
    local resolution = getres(false)
    setbgcolor(255, 255, 255)
end

return mapi