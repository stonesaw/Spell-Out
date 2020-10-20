# Scene - Play

class Play < Scene
  def initialize
    Debugger.color = [240, 240, 240]
    Window.bgcolor = [26, 26, 26]
    @@spell_icon = Sprite.new(1000, 600, Image.new(64, 64, C_WHITE))
    # @@fx_images = []
    # 61.times do |i|
    #   @@fx_images << Image.load(["#{$PATH}/assets/image/Fx_pack/1/1_", i, ".png"].join)
    # end
  end

  class << self
    def start
      image = Image.new(80, 80, [0, 100, 255])
      @@player = Player.new(:fire, (Window.width - image.width) * 0.5, Window.height * 0.7, image)
      @@e_list = EnemiesDataList.new
      @@tick = 0
      @@boss_spawn_ticks = 180
      @@is_boss = false
      $score = 0
      BGM.set_s_time
    end

    def update
      # test
      SceneManager.next(:title) if Input.key_push?(K_BACK)
      
      if @@tick % 200 == 0 && !@is_boss
        x = 100 + rand(Window.width - @@e_list.slime.image.width - 200)
        Enemy.new(@@e_list.slime, @@tick, x, -@@e_list.slime.image.height).add_hp_bar(x: 0.7, y: 0.7)
      end
      
      # if @@tick > @@boss_spawn_ticks && Enemies.list.length == 0
      #   x = (Window.width - @@e_list.slime.image.width) / 2
      #   Enemy.new(@@e_list.big_slime, @@tick, x, 0).add_boss_bar
      # end

      @@player.update
      SceneManager.next(:game_over) if @@player.life <= 0
      Bullet.update
      Enemies.update(:any, @@tick, @@player)
      @@tick += 1
    end

    def draw
      Debugger.puts ["fps : ", Window.real_fps].join
      Debugger.puts ["score : ", $score].join
      Debugger.puts ["my life : ", @@player.life].join
      # Debugger.puts ["bullet len : ", Bullet.all.length].join
      # Debugger.puts ["enemy  len : ", Enemies.list.length].join
      
      @@player.draw
      Bullet.draw
      Enemies.draw
      UI.draw

      # @@spell_icon.draw
    end
  end
end
