local function drawButton(text, x, y, width)
  local height = 3
  local padding = 2
  local textX = x + (width - #text) / 2
  local textY = y + (height - 1) / 2

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

local function drawMenu()
  clearScreen()

  local menuWidth = 20
  local menuHeight = 10
  local menuX = math.floor((term.getSize() - menuWidth) / 2)
  local menuY = math.floor((term.getSize() - menuHeight) / 2)

  drawButton("CLI", menuX, menuY, menuWidth)
  drawButton("GUI", menuX, menuY + 4, menuWidth)
end

local function handleButtonClick(x, y)
  if y == menuY then
    -- Handle Boot to CLI button click
    -- Add your CLI boot logic here
    print("Booting to CLI...")
    sleep(2)
    shell.run("/MeteorOS/modules/system.lua")
  elseif y == menuY + 4 then
    -- Handle Boot to GUI button click
    -- Add your GUI boot logic here
    print("Booting to GUI...")
    sleep(2)
    shell.run("/MeteorOS/modules/gui.lua")
  end
end

local function waitForButtonClick()
  while true do
    local event, button, x, y = os.pullEvent("mouse_click")

    if event == "mouse_click" then
      if x >= menuX and x < menuX + menuWidth then
        if y == menuY or y == menuY + 4 then
          handleButtonClick(x, y)
          return
        end
      end
    end
  end
end

drawMenu()
waitForButtonClick()

function boot()
    local freespace = getFreeSpace("/")
    local romsize = fs.getSize("/rom")
    local meteorsize = fs.getSize("/MeteorOS")
    local totalspace = meteorsize + romsize + freespace
    print("/dev/sda1: clean, "..totalspace.."/"..totalspace.." files, 4146215/121076480 blocks")
    print("Starting MeteorOS...")
    os.sleep(3)
    shell.run("/MeteorOS/modules/system.lua")
end
boot()
