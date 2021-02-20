# Tools - Debegger

class Debugger
  @font = Font.new(24)
  @color = C_WHITE
  @ox = 0
  @oy = 0
  @_str = ''
  @_list = []

  def self.new(font_size: 24, font_name: '', option: {},
               color: C_WHITE, ox: 10, oy: 10)
    @font = Font.new(font_size, font_name, option)
    @color = color
    @ox = ox
    @oy = oy
    @_str = ''
    @_list = []
  end

  class << self
    attr_accessor :font, :color, :ox, :oy, :_str, :_list
  end

  def self.print(str)
    @_str << str.to_s
    self
  end

  def self.puts(str)
    @_str << [str.to_s.chomp, "\n"].join
    self
  end

  def self.draw_msg
    @_str.split(/\R/).each_with_index do |msg, i|
      Window.draw_font(@ox, @oy + @font.size * i, msg, @font, color: @color)
    end
    @_str = ''
  end

  def self.add_block(&block)
    @_list << block
    self
  end

  def self.block_call
    @_list.each {|l| l.call }
    @_list = []
  end

  # arg: sprite : Sprite Object | [ Sprite Object ]
  def self.draw_collision(sprite)
    if sprite.class < Sprite
      sprite = [sprite]
    elsif sprite.class == Array
    else
      raise ArgumentError, "please (Sprite or [Sprite])"
    end
    sprite.each do |sp|
      next unless sp.collision_enable

      # TODO Sprite#collision_sync の対応

      col = sp.collision
      if col.nil? # box
        Window.draw_box(sp.x, sp.y, sp.x + sp.image.width, sp.y + sp.image.height, @color)
      elsif col.length == 2 # dot
        Window.draw_pixel(sp.x + col[0], sp.y + col[1], @color)
      elsif col.length == 3 # circle
        Window.draw_circle(sp.x + col[0], sp.y + col[1], col[2], @color)
      elsif col.length == 4 # box
        Window.draw_box(sp.x + col[0], sp.y + col[1],
                        sp.x + col[2], sp.y + col[3], @color)
      elsif col.length == 6 # triangle
        Window.draw_triangle(sp.x + col[0], sp.y + col[1],
                             sp.x + col[2], sp.y + col[3],
                             sp.x + col[4], sp.y + col[5], @color)
      end
    end
  end
end
