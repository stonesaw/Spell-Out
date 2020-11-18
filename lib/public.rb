
Window.width = 1280
Window.height = 960
Window.scale = 0.8
Window.caption = "Spell Out"
Window.bgcolor = [26, 26, 26]

Font.install("#{$PATH}/assets/font/Poco.ttf")
Font.install("#{$PATH}/assets/font/misaki_gothic.ttf")

$debug_mode = false

$spell_list = [:fire, :water, :wind, :holy, :dark].freeze
$se_retro04 = Sound.new("#{$PATH}/assets/sound/se_retro04.wav").set_volume(220)
$se_slime =   Sound.new("#{$PATH}/assets/sound/slime1.wav")

images = Image.load_tiles("#{$PATH}/assets/image/wizard.png", 6, 4)
$player_images = []
load_setting = [4, 3, 0, 1, 2, 7, 6, 5]
8.times do |i|
  s = load_setting[i] * 3
  $player_images[i] = [images[s], images[s + 1], images[s + 2]]
end

$spell_color = {
  fire: [255, 0, 0], water: [55, 183, 230], wind: [23, 255, 123], holy: [249, 250, 212], dark: [121, 73, 173]
}


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
