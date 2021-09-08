-- enable print while running
io.stdout:setvbuf('no')

-- enable love debugging for zerobrane ide
if arg[#arg] == "-debug" then
  require("mobdebug").start()
end
  

--require libraries
Object = require 'util.classic'
inspect = require 'util.inspect'

-- require game config
config_game = require 'config_game'

--require game objects
require 'MenuItem'
require 'Screen'


current_screen = "title"

function love.load(arg)
  
  -- configure game parameters
  config_game()
  
  title_screen = Screen('assets/screens/title/title_bg.png')
  reader_screen = Screen('assets/screens/reader/reader_bg.png')
  
  startitem = MenuItem('assets/screens/title/title_start.png', 70, 260)
  quititem = MenuItem('assets/screens/title/title_quit.png', 70, 320)
  

 
  text_bg = love.graphics.newImage('assets/screens/reader/text_bg.png')
 
  text = love.filesystem.read('compiled_book.txt')

  

  _, lines = font:getWrap(text, 880)
    

 
  feed = {}
  
  current_line = 1
  current_letter = 1
  
  fcurrent_line = current_line
  fcurrent_letter = current_letter
  

end

function love.mousemoved(x, y)
  
  startitem:updateState(x,y)
  quititem:updateState(x,y)
  
end

function love.mousepressed(x,y)
  
  -- start reading
  if startitem:isClicked(x,y) then
    current_screen = "reader"
  end
  
  -- quit game 
  if quititem:isClicked(x,y) then
    love.event.quit()
  end
  
  if current_screen == "reader" then
    stop_cursor = false
    quotecount = 0
  end

end



function love.keypressed(k)

  if current_screen == "reader" then

    if k == "up" then  
      textspeed = textspeed + 50
      if textspeed > 500 then textspeed = 500 end
      
    elseif k == "down" then
      textspeed = textspeed - 50
      if textspeed < 100 then textspeed = 100 end
    
    elseif k == "s" then
      savefile = io.open('savedata.txt', 'w')
 
      savefile:write(savedata)
      savefile:flush()
      savefile:close()
      
      
    elseif k == "l" then
        savedata = love.filesystem.read('savedata.txt')
      
        
        feed = {}
        fcurrent_letter = 1
        fcurrent_line = 1
        current_letter = 1
        current_line = tonumber(savedata)
        
        stop_cursor = false
      
      
    elseif k == "escape" then
      current_screen = "title"
    end
  end
end



meter = 0
textspeed = 300

function love.update(dt)
  

  
  if current_screen == "reader" then
    
    meter = meter + textspeed * dt
  
    if not stopadv and not stop_cursor and meter > 5 then
      meter = 0
      
      
      special_kword = lines[current_line]:sub(current_letter, current_letter+7)
  
      if special_kword == "[[page]]" then
        current_line = current_line + 1
        feed = {}
        fcurrent_letter = 1
        fcurrent_line = 1
        savedata = current_line

      
      elseif special_kword == "[[stop]]" then
        current_letter = current_letter + 8
        stop_cursor = true
      end
    
    
    
      if feed[fcurrent_line] == nil then
        feed[fcurrent_line] = {}
      end
      
      
  
      table.insert(
        feed[fcurrent_line],
        lines[current_line]:sub(current_letter,current_letter)
      )

 
      -- insert shades
      shadeline = {}
      for i = 1, fcurrent_letter do
        if i == fcurrent_letter - 2 and fcurrent_letter - 2 > 0 then 
          table.insert(shadeline, {1,1,1, 0.75})
        end
        if i == fcurrent_letter - 1 and fcurrent_letter - 1 > 0 then 
          table.insert(shadeline, {1,1,1, 0.5})
        end
        if i == fcurrent_letter  then 
          table.insert(shadeline, {1,1,1, 0.25})
        end
        table.insert(shadeline, feed[fcurrent_line][i])
      end
      
      table.insert(shadeline, feed[fcurrent_line][i])


      current_letter = current_letter + 1
      fcurrent_letter = fcurrent_letter + 1
      
      if current_letter > #lines[current_line] then
        current_letter = 1
        fcurrent_letter = 1
        
        if current_line < #lines then
          current_line = current_line + 1
          fcurrent_line = fcurrent_line + 1
        else
          
          stopadv = true
          
        end
      end
      
      
    end
  
  
  end

  
end





function love.draw()
  
  if current_screen == "title" then
    
    title_screen:draw()
    startitem:draw()
    quititem:draw()
  
  elseif current_screen == "reader" then

    reader_screen:draw()
    
    love.graphics.draw(
      text_bg,
      love.graphics.getWidth() /2,
      love.graphics.getHeight() / 2,
      0, 6, 6,
      text_bg:getWidth() /2,
      text_bg:getHeight() / 2
    )
  
    for i, v in ipairs(feed) do
      if i == #feed and not stop_cursor then
        v = shadeline
      end
      love.graphics.print(v, 80,40+i*40)
    end
    

  end
end

  