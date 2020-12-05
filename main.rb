require "dxruby"
require "json"
require "time"
require "pp"


$PATH = File.dirname(__FILE__)


Window.width, Window.height = 1280, 960
Window.scale = 0.8
Window.caption = "Spell Out"
Window.bgcolor = [26, 26, 26]

Font.install("#{$PATH}/assets/font/Poco.ttf")
Font.install("#{$PATH}/assets/font/misaki_gothic.ttf")

$debug_mode = false

$se_retro04 = Sound.new("#{$PATH}/assets/sound/se_retro04.wav").set_volume(220)
$se_slime =   Sound.new("#{$PATH}/assets/sound/slime1.wav")

images = Image.load_tiles("#{$PATH}/assets/image/wizard.png", 6, 4)
load_setting = [4, 3, 0, 1, 2, 7, 6, 5]
$player_images = []
8.times do |i|
  s = load_setting[i] * 3
  $player_images[i] = [images[s], images[s + 1], images[s + 2]]
end

$spell_list = [:fire, :water, :wind, :holy, :dark]
$spell_color = {
  fire: [255, 0, 0], water: [55, 183, 230], wind: [23, 255, 123], holy: [249, 250, 212], dark: [121, 73, 173]
}



require_relative "lib/wrapper"
require_relative "lib/scene_manager"
require_relative "lib/debugger"
require_relative "lib/bgm"
require_relative "lib/ui"
require_relative "lib/text_box"
require_relative "lib/player"
require_relative "lib/player_setting"
require_relative "lib/bullet"
require_relative "lib/enemy_system"
require_relative "lib/enemies"
require_relative "lib/enemy_base"
require_relative "lib/data/enemies_data_list"
require_relative "lib/scenes/loading"
require_relative "lib/scenes/title"
require_relative "lib/scenes/play"
require_relative "lib/scenes/menu"
require_relative "lib/scenes/game_over"
require_relative "lib/scenes/ranking"


BGM.new
Debugger.new

SceneManager.new({
  title: Title,
  play: Play,
  menu: Menu,
  game_over: GameOver,
  ranking: Ranking
})


Window.loop do
  Window.close if Input.key_down?(K_ESCAPE)
  Mouse.update
  SceneManager.update
  SceneManager.draw
  BGM.update
  if $debug_mode
    Debugger.block_call
    Debugger.draw_msg
  end
end
