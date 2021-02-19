# Tools - Debegger

class Debugger
  @font = Font.new(24)
  @color = C_WHITE
  @ox = 0
  @oy = 0
  @_str = ''
  @_list = []

  def initialize(font_size = 24, font_name = '', option = {}, color: C_WHITE, ox: 10, oy: 10)
    self.class.font = Font.new(font_size, font_name, option)
    self.class.color = color
    self.class.ox = ox
    self.class.oy = oy
    self.class._str = ''
    self.class._list = []
  end

  class << self
    attr_accessor :font, :color, :ox, :oy, :_str, :_list

    def print(str)
      @_str += str.to_s
      self
    end

    def puts(str)
      @_str += [str.to_s.chomp, "\n"].join
      self
    end

    def draw_msg
      @_str.split(/\R/).each_with_index do |msg, i|
        Window.draw_font(@ox, @oy + @font.size * i, msg, @font, color: @color)
      end
      @_str = ''
    end

    def add_block(&block)
      @_list << block
      self
    end

    def block_call
      @_list.each { |l| l.call }
      @_list = []
    end
  end
end
