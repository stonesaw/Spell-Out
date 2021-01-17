class SeekBar < Sprite
  attr_accessor :bar_image, :toggle_image, :percent, :pushed

  # arg: option
  # - percent: 1,
  # - enable_key_input: true,
  # - pushed_toggle_scale: 0.8
  def initialize(x, y, bar_image, toggle_image, **option)
    super
    self.x = x
    self.y = y
    @bar_image    = bar_image
    @toggle_image = toggle_image
    # option
    @percent = option[:percent] || 1
    @enable_key_input = option[:enable_key_input] || true,
    @pushed_toggle_scale = option[:pushed_toggle_scale] || 0.8

    @pushed = false
  end

  def update
    @tog_x = self.x + (@bar_image.width) * @percent - @toggle_image.width * 0.5
    @tog_y = self.y + (@bar_image.height - @toggle_image.height) * 0.5
    if Input.mouse_push?(0) && 
      (@tog_x..@tog_x + @toggle_image.width).include?(Mouse.x) &&
      (@tog_y..@tog_y + @toggle_image.height).include?(Mouse.y)
      @pushed = true
    end
    if Input.mouse_release?(0)
      @pushed = false
    end
    if @pushed
      per = (Mouse.x - self.x) / @bar_image.width.to_f
      @percent = ([[0, per].max, 1.0].min).floor(2)
    end
  end

  def draw
    Window.draw(self.x, self.y, @bar_image)
    Window.draw(@tog_x, @tog_y, @toggle_image)
  end
end
