# Scene - Play

class Play < Scene
  def initialize
    Debugger.color = [240, 240, 240]
    Window.bgcolor = [26, 26, 26]
    # @@fx_images = []
    # 61.times do |i|
    #   @@fx_images << Image.load(["assets/image/Fx_pack/1/1_", i, ".png"].join)
    # end
    image = Image.new(80, 80, [0, 100, 255])
    @@player = Player.new(:fire, (Window.width - image.width) * 0.5, Window.height * 0.7, image)
    @@e_list = EnemiesDataList.new
    @@tick = 0
    $score = 0
  end

  class << self
    def update
      # test
      SceneManager.next(:title) if Input.key_push?(K_BACK)
      
      Enemy.new(@@e_list.slime, @@tick, 300, -@@e_list.slime.image.height).add_hp_bar if @@tick % 160 == 0
      
      @@player.update
      SceneManager.next(:game_over) if @@player.life <= 0
      Bullet.update
      Enemies.update(:any, @@tick, @@player)
      @@tick += 1
    end

    def draw
      Debugger.puts ["fps : ", Window.real_fps].join
      Debugger.puts ["tick : ", @@tick].join
      Debugger.puts ["score : ", $score].join
      # Debugger.puts ["bullet len : ", Bullet.all.length].join
      # Debugger.puts ["enemy  len : ", Enemies.list.length].join
      Debugger.puts ["my life : ", @@player.life].join
      
      @@player.draw
      Bullet.draw
      Enemies.draw
      UI.draw
    end
  end
end
