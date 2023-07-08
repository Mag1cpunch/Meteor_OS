--Operating System API
function wait(time)
    os.sleep(time)
end
function version()
    print("Current Firmware version is: "..os.version().."")
end
function day()
    print("Amount of days passed: "..os.day().."")
end

--FileSystem API
function com(basePath, localPath)
    fs.combine(basePath, localPath)
end

--Network API
function netstart(side)
    rednet.open(side)
end
function netstop(side)
    rednet.close(side)
end
function netsend(receiverID, message, protocol)
    rednet.send(receiverID, message, protocol)
end
function netcast(message, protocol)
    rednet.broadcast(message, protocol)
end
function netrec(protocolFilter, timeout)
    rednet.receive(protocolFilter, timeout)
end
function isnetopen(side)
    rednet.isOpen(side)
end
function netlist(protocol, hostname)
    rednet.lookup(protocol, hostname)
end
function netrun()
    rednet.run()
end

--GPS API
function gpsloc(timeout, debug)
    gps.locate(timeout, debug)
end

-- TextUtils API
function slowprint(text, rate)
    textutils.slowPrint(text, rate)
end
function slowwrite(text, rate)
    textutils.slowWrite(text, rate)
end
function tabprint(table1, color1, table2, color2)
    textutils.tabulate(table1, color1, table2, color2)
end

--HTTP API
function httprequest(url, postData, headers)
    http.request(url, postData, headers)
end
function httpget(url, headers)
    http.get(url, headers)
end
function httppost(url, postData, headers)
    http.post(url, postData, headers)
end
function checkURL(url)
    http.checkURL(url)
end

--Term API
function termwrite(text)
    term.write(text)
end
function termblit(text, textcolors, backgroundcolors)
    term.blit(text, textcolors, backgroundcolors)
end
function clear()
    term.clear()
end
function lclear()
    term.clearLine
end
function getmousepos(debugisenabled)
    local mousepos = term.getCursorPos
    if debugisenabled == true then
        print(mousepos)
        return mousepos
    else
        return mousepos
    end
end
function setmousepos(x, y)
    term.setCursorPos(x, y)
end
function setmouseblink(bool)
    term.setCursorBlink(bool)
end
function iscolor(debugisenabled)
    local colorsupport = term.isColor()
    if debugisenabled == true then
        print(colorsupport)
        return colorsupport
    else
        return colorsupport
    end
end
function getres(debugisenabled)
    local res = term.getSize
    if debugisenabled == true
        print(res)
        return res
    else
        return res
    end
end
function scroll(n)
    term.scroll(n)
end
function redirect(target)
    term.redirect(target)
end
function current()
    local current = term.current()
    return current
end
function native()
    local native = term.native
    return native
end
function settextcolor(color)
    term.setTextColor(color)
end
function gettextcolor()
    local color = term.getTextColor()
    return color
end
function setbgcolor(color1, color2, color3)
    term.setBackgroundColor(color1, color2, color3)
end
function getbgcolor()
    local bgcolor = term.getBackgroundColor()
    return bgcolor
end
function setmonitortextscale(scale)
    monitor.setTextScale(scale)
end

--MT Window System
function wsetvisible(bool)
    window.setVisible(bool)
end
function wredraw()
    window.redraw()
end
function wrestmouse()
    window.restoreCursor()
end
function wgetpos()
    wpos = window.getPosition()
    return wpos
end
function wrepos(x, y, width, height)
    window.reposition(x, y, width, height)
end

--Colors API
function colorscom(color1, color2)
    colors.combine(color1, color2)
end
function colorssub(colors, color1, color2, color3, color4)
    colors.subtract(colors, color1, color2, color3, color4)
end
function test(colors, color)
    colors.test(colors, color)
end

--Commands API
function exec(command)
    commands.exec(command)
end
function execAsync(command)
    commands.execAsync(command)
end
function commandlist()
    commands.list()
end
function getblockpos()
    local blockpos = commands.getBlockPosition()
    return blockpos
end
function getblockinfo(x, y, z)
    local blockinfo = commands.getBlockInfo(x, y, z)
    return blockinfo
end
function getblockinfos(x1, y1, z1, x2, y2, z2)
    local blockinfos = commands.getBlockInfos(x1, y1, z1, x2, y2, z2)
    return blockinfos
end

--Meteor API
function setupgui()
    local resolution = getres(false)
    setbgcolor(255, 255, 255)
end
