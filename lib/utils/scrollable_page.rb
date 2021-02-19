class ScrollablePage < RenderTarget
  attr_reader :pos

  def initialize(width, height, bgcolor = [0, 0, 0, 0],
                 page_width: nil, page_height: nil,
                 scrollbar: nil, scrollbar_base: nil,
                 bar_w: 16, bar_color: [200, 200, 200], bar_base_color: C_WHITE)
    super(width, height, bgcolor)
    @page_width = page_width || self.width
    @page_height = page_height || self.height

    @bar_h_per = [self.height.to_f / @page_height, 1].min
    @scrollbar = scrollbar || Image.new(bar_w, (self.height * @bar_h_per).to_i, bar_color)
    @scrollbar_base = scrollbar_base || Image.new(bar_w, self.height, bar_base_color)

    @pos = 0
    @_before_mouse_wheel = Input.mouse_wheel_pos
  end

  def draw_scrollbar
    draw(width - @scrollbar_base.width, @pos, @scrollbar_base)
    draw(width - @scrollbar.width, @pos * @bar_h_per + @pos, @scrollbar)
  end

  def update
    scroll_volume = (@_before_mouse_wheel - Input.mouse_wheel_pos) / 120
    scroll_volume *= 50
    @_before_mouse_wheel = Input.mouse_wheel_pos

    @pos += scroll_volume
    @pos = [0, [@pos, @page_height - height].min].max
  end

  # wrapping methods
  [
    'draw(x, y,image, z=0)',
    'draw_scale(x, y, image, scale_x, scale_y, center_x=nil, center_y=nil, z=0)',
    'draw_rot(x, y, image, angle, center_x=nil, center_y=nil, z=0)',
    'draw_alpha(x, y, image, alpha, z=0)',
    'draw_add(x, y, image, z=0)',
    'draw_sub(x, y, image, z=0)',
    'draw_shader(x, y, image, shader, z=0)',
    'draw_ex(x, y, image, option={})',
    'draw_font(x, y, text, font, option={})',
    'draw_font_ex(x, y, text, font, option={})',
    'draw_morph(x1, y1, x2, y2, x3, y3, x4, y4, image, option={})',
    'draw_tile(base_x, base_y, map, image_array, start_x, start_y, size_x, size_y, z=0)',
    'draw_pixel(x, y, color, z=0)',
    'draw_line(x1, y1, x2, y2, color, z=0)',
    'draw_box(x1, y1, x2, y2, color, z=0)',
    'draw_box_fill(x1, y1, x2, y2, color, z=0)',
    'draw_circle(x, y, r, color, z=0)',
    'draw_circle_fill(x, y, r, color, z=0)',
  ].each do |method|
    match = method.match(/^(\w*)\((.+)\)$/)
    name = match[1]
    arg = match[2]
    # puts "#{name}(#{arg})"
    new_arg = arg.
      gsub(/(\w+)\s*=.+?,/, '\\1,').
      sub(/(\w+)\s*=.+?$/, '\\1').
      gsub(/(x|x\d), (y|y\d),/, '\\1, \\2 - @pos,')
    # puts "#{' ' * (name.length - 2)}=> #{new_arg}"
    eval "def #{name}(#{arg})
            super(#{new_arg})
          end"
  end
end
