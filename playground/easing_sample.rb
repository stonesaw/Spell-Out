require 'dxruby'
require_relative './../lib/utils/easing'

Window.bgcolor = C_WHITE

boxes = []
6.times do |i|
  boxes << Sprite.new(60, 40 + 45 * i, Image.new(40, 40, [120, 160, 240]))
end

sp = Sprite.new(60, 320, Image.new(40, 40, [210, 120, 160, 240]))
boxes2 = []
3.times do |y|
  boxes2 << Sprite.new(60, 380 + y * 23, Image.new(20, 20, [170, 120, 160, 240]))
end


font = Font.new(24, "Comic sans MS")

Window.loop do
  break if Input.key_down?(K_ESCAPE)

  if Input.key_push?(K_SPACE)
    Easing.new(sp, :x, :ease_in_out_quad, 60, 260)
    Easing.new(boxes2, :x, :ease_in_out_quad, 60, 260)
  end

  boxes[0].x = Easing.ease_in_quart(        60, 260)
  boxes[1].x = Easing.ease_out_quart(       60, 260)
  boxes[2].x = Easing.ease_in_out_quad(    60, 260)
  boxes[3].x = Easing.ease_in_sine(    60, 260)
  boxes[4].x = Easing.ease_out_sine(   60, 260)
  boxes[5].x = Easing.ease_in_out_sine(60, 260)

  boxes.length.times do |i|
    Window.draw_font_ex(10, 50 + 45 * i, "#{((boxes[i].x - 60) * 100.0 / 260).round}%", font, color: C_BLACK)
  end
  Sprite.draw(boxes)
  Sprite.draw(boxes2)
  sp.draw

  Window.draw_font_ex(0, 0, "fps: #{Window.real_fps}", font, color: C_BLACK)
end
