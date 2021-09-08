Screen = Object.extend(Object)

function Screen:new(bgpath)
  self.bg = love.graphics.newImage(bgpath);
end

function Screen:draw()
  love.graphics.draw(self.bg, 0,0)
end
