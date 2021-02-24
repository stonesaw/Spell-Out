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

  # arg: sprites : Sprite Object | [ Sprite Object ]
  def self.draw_collision(sprites)
    if sprites.class < Sprite
      sprites = [sprites]
    elsif sprites.class == Array
    else
      raise ArgumentError, "sprites please : (Sprite | Array[Sprite])"
    end
    sprites.each do |sp|
      next unless sp.collision_enable
      col = sp.collision

      # スケールやアングルが変わっている場合
      if sp.angle != 0 || sp.scale_x != 1 || sp.scale_y != 1
        img = Image.new(sp.image.width, sp.image.height)
        if col.nil? # box
          img.box(0, 0, sp.image.width, sp.image.height, @color)
        elsif col.length == 2 # dot
          img.pixel(*col, @color)
        elsif col.length == 3 # circle
          img.circle(*col, @color)
        elsif col.length == 4 # box
          img.box(*col, @color)
        elsif col.length == 6 # triangle
          img.triangle(*col, @color)
        end
        Window.draw_ex(sp.x, sp.y, img,
                       scale_x: sp.scale_x,
                       scale_y: sp.scale_y,
                       center_x: sp.center_x,
                       center_y: sp.center_y,
                       angle: sp.angle)
      else
        if col.nil? # box
          Window.draw_box(sp.x, sp.y, sp.x + sp.image.width, sp.y + sp.image.height, @color)
          next
        else
          new_col = col.map.with_index do |_col, index|
            if index % 2 == 0
              sp.x + _col
            else
              sp.y + _col
            end
          end
        end

        if col.length == 2 # dot
          Window.draw_pixel(*new_col, @color)
        elsif col.length == 3 # circle
          Window.draw_circle(sp.x + col[0], sp.y + col[1], col[2], @color)
        elsif col.length == 4 # box
          Window.draw_box(*new_col, @color)
        elsif col.length == 6 # triangle
          Window.draw_triangle(*new_col, @color)
        end
      end
    end
  end
end
