class Menu < Scene
  def initialize
    @@cover = Sprite.new(0, 0, Image.new(Window.width, Window.height, C_BLACK))
    @@cover.alpha = 100
    @@font = Font.new(160, "Poco")
  end

  class << self
    def update
      Input.mouse_enable = true
      SceneManager.next(:play, is_init: false) if Input.key_release?(K_TAB)
    end

    def draw
      Play.draw
      @@cover.draw
      Window.draw_font(100, 100, "MENU", @@font)
    end
  end
end
