
Window.width = 1280
Window.height = 960
Window.scale = 0.8
Window.caption = "Spell Out"
Window.bgcolor = [26, 26, 26]

Font.install("assets/font/Poco.ttf")


$spell_list = [:fire, :water, :wind, :holy, :dark].freeze

class Mouse
  class << self
    @@x = -1
    @@y = -1
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


class Sprite
  def on_mouse?
    Mouse.is_draw == true &&
    (self.x..self.x + self.image.width).include?(Mouse.x) &&
    (self.y..self.y + self.image.height).include?(Mouse.y)
  end
end
