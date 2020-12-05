# Wrapping `Input.mouse_x`, `Input.mouse_y` and `Input.mouse_enable`  
# And Update the mouse display when the keyboard is pressed
class Mouse
  class << self
    @@x = nil
    @@y = nil

    def update
      @@old_x = @@x
      @@old_y = @@y
      @@x = Input.mouse_x / Window.scale
      @@y = Input.mouse_y / Window.scale

      @@is_draw = false unless Input.keys.empty?
      @@is_draw = true unless @@old_x == @@x && @@old_y == @@y
      Input.mouse_enable = @@is_draw
    end

    def x
      @@x
    end

    def y
      @@y
    end

    def is_draw
      @@is_draw
    end
  end
end


# wrapping `DXRuby::Sprite
# Adding `on_mosue?()`
class Sprite
  def on_mouse?
    Mouse.is_draw == true &&
    (self.x..self.x + self.image.width).include?(Mouse.x) &&
    (self.y..self.y + self.image.height).include?(Mouse.y)
  end
end
