class TextBox
  attr_accessor :x, :y, :width, :height, :font_name, :font_size, :string, :frame_color, :font_color

  def initialize(x, y, width, height,
                 font_name: '', font_size: height * 0.8, font_color: C_WHITE, font_ox: 0, font_oy: 0, string: '', frame_color: C_WHITE, cursor_scale: 1)
    @x = x
    @y = y
    @width = width
    @height = height
    @font_size = font_size
    @string = string
    @frame_color = frame_color
    @font_color = font_color
    @font = Font.new(@font_size, font_name)
    @font_w = @font.get_width(@string)
    @frame = Sprite.new(@x, @y, Image.new(@width, @height).box(0, 0, @width, @height, @frame_color))
    @moji =   Sprite.new(@x + @width * 0.03 + font_ox, @y + @height * 0.1 + font_oy, Image.new(@width * 0.94, @height * 0.8).draw_font(0, 0, @string, @font, @font_color))
    @cursor = Sprite.new(@x + @width * 0.03, @y + @height * 0.1, Image.new(1, @font_size * cursor_scale, @frame_color))
    @is_choose = true
    @@tick = 0
    @@alphabet = ('a'..'z').to_a
    @@flash_rate = 60
  end

  def update
    return nil unless @is_choose

    @@tick += 1
    typing
    @font_w = @font.get_width(@string)
    if @font_w > @moji.image.width
      @cursor.x = @moji.x + @moji.image.width + 1
      diff = @font_w - @moji.image.width
      @moji.image =  Image.new(@width * 0.94, @height * 0.8).draw_font(-diff, 0, @string, @font, @font_color)
    else
      @cursor.x = @frame.x + @width * 0.03 + @font_w
      @moji.image = Image.new(@width * 0.94, @height * 0.8).draw_font(0, 0, @string, @font, @font_color)
    end
  end

  def draw
    @frame.draw
    @moji.draw
    @cursor.draw if @is_choose && (@@tick % @@flash_rate * 2 < @@flash_rate)
  end

  private

  def typing
    26.times do |i|
      next unless Input.key_push?(eval('K_' + @@alphabet[i].upcase))

      @string += @@alphabet[i].upcase

      # choose upcase or down case cf. pushig shift key
      # if Input.key_down?(K_LSHIFT) || Input.key_down?(K_RSHIFT)
      #   @string += @@alphabet[i].upcase
      # else
      #   @string += @@alphabet[i]
      # end
    end
    @string += ' ' if Input.key_push?(K_SPACE) || Input.key_down?(K_SPACE) && @@tick % 6 == 0
    @string[-1] = '' if @string.length > 0 && (Input.key_push?(K_BACK) || Input.key_down?(K_BACK) && @@tick % 6 == 0)
  end
end
