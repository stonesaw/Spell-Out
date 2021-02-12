require 'dxruby'
require 'json'
require 'time'
require 'pp'

$PATH = File.dirname(__FILE__)

Window.width = 1280
Window.height = 960
Window.scale = 0.8
Window.caption = 'Spell Out'
Window.bgcolor = [26, 26, 26]

Font.install("#{$PATH}/assets/font/Poco.ttf")
Font.install("#{$PATH}/assets/font/misaki_gothic.ttf")

$debug_mode = false

_img = Image.load_tiles("#{$PATH}/assets/image/wizard.png", 6, 4)
load_setting = [4, 3, 0, 1, 2, 7, 6, 5]
$player_images = []
8.times do |i|
  s = load_setting[i] * 3
  $player_images[i] = [_img[s], _img[s + 1], _img[s + 2]]
end

require_relative 'lib/utils/wrapper'
require_relative 'lib/utils/scene_manager'
require_relative 'lib/utils/debugger'
require_relative 'lib/utils/bgm'
require_relative 'lib/utils/se'
require_relative 'lib/utils/ui'
require_relative 'lib/utils/text_box'
require_relative 'lib/utils/seek_bar'
# require_relative 'lib/map'
require_relative 'lib/player'
require_relative 'lib/player_setting'
require_relative 'lib/bullet'
require_relative 'lib/enemy'
require_relative 'lib/enemies'
require_relative 'lib/enemy_spawn_system'
require_relative 'lib/data/enemies_data'
require_relative 'lib/data/bullet_data'
require_relative 'lib/scenes/loading'
require_relative 'lib/scenes/title'
require_relative 'lib/scenes/play'
require_relative 'lib/scenes/menu'
require_relative 'lib/scenes/game_over'
require_relative 'lib/scenes/ranking'

Debugger.new(48)

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
