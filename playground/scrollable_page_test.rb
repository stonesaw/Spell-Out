require 'dxruby'
require_relative '../lib/utils/scrollable_page'

Font.install('MonospaceBold.ttf')

page = ScrollablePage.new(500, 400, [34, 34, 34], page_height: 800)

font = Font.new(24)
font_code = Font.new(21, 'Monospace')

usage = "
page = ScrollablePage.new(
  500, 400, [34, 34, 34], page_height: 800
)

a = Sprite.new(100, 0, Image.new(50, 50, C_RED))
a.target = page

Window.loop do
  break if Input.key_down? K_ESCAPE

  page.update

  page.draw_font(10, 550, \'Sample Text\', font)
  a.y = 650 - page.pos
  a.draw

  page.draw_scrollbar
  Window.draw(70, 40, page)
end
".split(/\R/)

a = Sprite.new(100, 0, Image.new(50, 50, C_RED))
a.target = page

Window.loop do
  break if Input.key_down? K_ESCAPE

  page.update

  page.draw_font(10, 10, "FPS : #{Window.real_fps}", font)
  page.draw_font(10, 34, 'class ScrollablePage', font)
  page.draw_font(10, 60, 'マウスのスクロールで動かせます', font)
  usage.length.times do |i|
    page.draw_font(10, 100 + font_code.size * i, usage[i], font_code)
  end
  page.draw_font(10, 550, 'result ... ', font)
  page.draw_font(10, 600, 'Sample Text', font)
  str = '© stonesaw'
  page.draw_font((page.width - font.get_width(str)) / 2, 800 - 34, str, font)

  a.y = 650 - page.pos
  a.draw

  page.draw_scrollbar
  Window.draw(70, 40, page)

  Window.draw_font(10, 10, page.pos.to_s, font)
end
