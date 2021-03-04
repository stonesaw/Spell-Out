class StageSelect < Scene
  def self.new(stage_name)
    @font = Font.new(80, 'Poco')
    @stage_name = stage_name
    if /(\d)-(?<section>\d)/ =~ @stage_name
      $stage = [section.to_i, $stage].max
    else
      raise ArgumentError, "stage_name ( <chapter>-<section> )"
    end
    @stage_base = []
    2.times do |y|
      3.times do |x|
        _x = (Window.width - 300 * 2 - 250) / 2
        _y = (Window.height - 250 * 1 - 200) / 2
        @stage_base << Sprite.new(_x + x * 300, _y + y * 250, Image.new(250, 200, [150, 255, 255, 255]))
      end
    end
    @tick = 0
  end

  def self.set_music
    BGM.list[:mist][0].play
  end

  def self.update
    @tick += 1
    Input.mouse_enable = true
    @stage_base.length.times do |i|
      sp = @stage_base[i]
      if sp.on_mouse?
        if Input.mouse_push?(0) && i <= $stage
          SceneManager.next(:play, "1-#{i + 1}", loading: true)
        end
      end
    end
  end

  def self.draw
    Sprite.draw(@stage_base)
    Window.draw_font(10, -20, 'Stage Select', @font)
    Window.draw_font(10, 40, "CLEAR #{@stage_name}", @font)
    @stage_base.length.times do |i|
      sp = @stage_base[i]
      Window.draw_font(sp.x + 8, sp.y + sp.image.height - @font.size, "1-#{i + 1}", @font, color: C_WHITE)
      if $stage == i
        Window.draw_font(sp.x + 120, sp.y - 20, "NEXT", @font, color: C_WHITE) if @tick % 20 > 10
      elsif $stage < i
        Window.draw_box_fill(sp.x, sp.y, sp.x + sp.image.width, sp.y + sp.image.height, [100, 0, 0, 0])
      end
      if sp.on_mouse?
        Window.draw_box(sp.x, sp.y, sp.x + sp.image.width, sp.y + sp.image.height, C_WHITE)
      end
    end
  end

  def self.last
    BGM.list[:mist][0].stop
  end
end
