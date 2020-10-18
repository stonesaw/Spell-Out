# Tools - Debegger

class Debugger
  def initialize(font_size = 48, color: C_WHITE, ox: 10, oy: 10)
    @@font = Font.new(font_size)
    @@font_size = font_size
    @@color = color
    @@ox = ox
    @@oy = oy
    @@_str = ""
    @@_list = []
  end

  class << self
    def print(str)
      @@_str += str.to_s
    end

    def puts(str)
      @@_str += str.to_s.chomp + "\n"
    end

    def draw_msg
      s = ""
      h_count = @@oy
      @@_str.size.times do |i|
        if @@_str[i] == "\n"
          Window.draw_font(@@ox, h_count, s, @@font, color: @@color)
          s = ""
          h_count += @@font_size
        else
          s += @@_str[i]
        end
      end
      @@_str = ""
    end

    def add_block(&block)
      @@_list << block
    end

    def block_call
      @@_list.each { |l| l.call }
      @@_list = []
    end

    # accessor
    def font_size
      @@font_size
    end

    def font_size=(num)
      @@font_size = num
      @@font = Font.new(@@font_size)
    end

    def color
      @@color
    end

    def color=(color_code)
      @@color = color_code
    end
    
    def ox
      @@ox
    end
    
    def ox=(num)
      @@ox = num
    end
        
    def oy
      @@oy
    end
    
    def oy=(num)
      @@oy = num
    end
  end
end
