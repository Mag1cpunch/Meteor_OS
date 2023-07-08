-- Operating System API
function wait(time)
    os.sleep(time)
end

function version()
    print("Current Firmware version is: " .. os.version())
end

function day()
    print("Amount of days passed: " .. os.day())
end

-- FileSystem API
function com(basePath, localPath)
    return fs.combine(basePath, localPath)
end

-- Network API
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
    return rednet.receive(protocolFilter, timeout)
end

function isnetopen(side)
    return rednet.isOpen(side)
end

function netlist(protocol, hostname)
    return rednet.lookup(protocol, hostname)
end

function netrun()
    rednet.run()
end

-- GPS API
function gpsloc(timeout, debug)
    return gps.locate(timeout, debug)
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

-- HTTP API
function httprequest(url, postData, headers)
    return http.request(url, postData, headers)
end

function httpget(url, headers)
    return http.get(url, headers)
end

function httppost(url, postData, headers)
    return http.post(url, postData, headers)
end

function checkURL(url)
    return http.checkURL(url)
end

-- Term API
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
    term.clearLine()
end

function getmousepos(debugisenabled)
    local mousepos = term.getCursorPos()
    if debugisenabled == true then
        print(mousepos)
    end
    return mousepos
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
    end
    return colorsupport
end

function getres(debugisenabled)
    local res = term.getSize()
    if debugisenabled == true then
        print(res)
    end
    return res
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
    local native = term.native()
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

-- MT Window System
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
    local wpos = window.getPosition()
    return wpos
end

function wrepos(x, y, width, height)
    window.reposition(x, y, width, height)
end

-- Colors API
function colorscom(color1, color2)
    return colors.combine(color1, color2)
end

function colorssub(colors, color1, color2, color3, color4)
    return colors.subtract(colors, color1, color2, color3, color4)
end

function test(colors, color)
    return colors.test(colors, color)
end

-- Commands API
function exec(command)
    return commands.exec(command)
end

function execAsync(command)
    return commands.execAsync(command)
end

function commandlist()
    return commands.list()
end

function getblockpos()
    return commands.getBlockPosition()
end

function getblockinfo(x, y, z)
    return commands.getBlockInfo(x, y, z)
end

function getblockinfos(x1, y1, z1, x2, y2, z2)
    return commands.getBlockInfos(x1, y1, z1, x2, y2, z2)
end

-- Meteor API
function setupgui()
    local resolution = getres(false)
    setbgcolor(255, 255, 255)
end
