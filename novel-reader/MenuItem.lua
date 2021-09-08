MenuItem = Object.extend(Object)

function MenuItem:new(atlasfile, x, y)
  
  self.image = love.graphics.newImage(atlasfile)
  
  self.x = x
  self.y = y
  self.up = y - 30
  self.down =  y + 30
  self.left = x - 75
  self.right = x + 75
  
  self.quad = {}
  self.quad.dark = love.graphics.newQuad(0,0,150,60,
    self.image:getDimensions())
  self.quad.glow = love.graphics.newQuad(150,0,150,60,
    self.image:getDimensions())
  
  self.state = "glow"

end

function MenuItem:collide(x,y)
  if x > self.left and x < self.right then
    if y < self.down and y > self.up then
      return true
    end
  end
  return false
end



function MenuItem:setState(state)
  self.state = state
end

function MenuItem:draw()
  --love.graphics.rectangle('line',self.left, self.up, self.right - self.left , self.down - self.up)
  if self.state == "glow" then
    love.graphics.draw(self.image, self.quad.glow,
      self.x, self.y, 0, 1, 1, 75, 30)
  elseif self.state == "dark" then
    love.graphics.draw(self.image, self.quad.dark,
      self.x, self.y, 0, 1, 1, 75, 30)
  end
end


function MenuItem:updateState(x,y)
  if self:collide(x,y) then
    self.state = "dark"
  else
    self.state = "glow"
  end
end

function MenuItem:isClicked(x,y)
  if self:collide(x,y) then
    return true
  else
    return false
  end
end

