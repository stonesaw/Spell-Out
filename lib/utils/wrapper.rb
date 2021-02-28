# Wrapping `Input.mouse_x`, `Input.mouse_y` and `Input.mouse_enable`
# And Update the mouse display when the keyboard is pressed
class Mouse
  @x = nil
  @y = nil
  @is_draw = true

  class << self
    attr_reader :x, :y, :is_draw
  end

  def self.update
    @old_x = @x
    @old_y = @y
    @x = Input.mouse_x / Window.scale
    @y = Input.mouse_y / Window.scale

    @is_draw = false unless Input.keys.empty?
    @is_draw = true if !(@old_x == @x && @old_y == @y)
    Input.mouse_enable = @is_draw
  end
end

# wrapping `DXRuby::Sprite
# Adding `on_mosue?()`
class Sprite
  def on_mouse?
    Mouse.is_draw == true &&
      (x..x + image.width).include?(Mouse.x) &&
      (y..y + image.height).include?(Mouse.y)
  end

  def mouse_clicked?(mouse_button)
    return (Input.mouse_down?(mouse_button) &&
    (self.x..self.x + self.image.width).include?(Mouse.x) &&
    (self.y..self.y + self.image.height).include?(Mouse.y))
  end

end
