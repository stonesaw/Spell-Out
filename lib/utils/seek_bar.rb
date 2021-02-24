class SeekBar < Sprite
  attr_accessor :bar_image, :toggle_image, :percent, :pushed

  def initialize(x, y, bar_image, toggle_image, percent: 1,
                 enable_key_input: true,
                 pushed_toggle_scale: 0.8)

    super
    self.x = x
    self.y = y
    @bar_image = bar_image
    @toggle_image = toggle_image

    @percent = percent
    @enable_key_input = enable_key_input
    @pushed_toggle_scale = pushed_toggle_scale

    @pushed = false
  end

  def update
    @tog_x = x + @bar_image.width * @percent - @toggle_image.width * 0.5
    @tog_y = y + (@bar_image.height - @toggle_image.height) * 0.5
    if Input.mouse_push?(0) &&
      (@tog_x..@tog_x + @toggle_image.width).include?(Mouse.x) &&
      (@tog_y..@tog_y + @toggle_image.height).include?(Mouse.y)
      @pushed = true
    end
    if Input.mouse_release?(0)
      @pushed = false
    end
    if @pushed
      per = (Mouse.x - x) / @bar_image.width.to_f
      @percent = [[0, per].max, 1.0].min.floor(2)
    end
  end

  def draw
    Window.draw(x, y, @bar_image)
    Window.draw(@tog_x, @tog_y, @toggle_image)
  end
end
