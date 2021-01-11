class EnemySpawnSystem
  def initialize
    @@boss_spawn_ticks = 180
    @@is_boss = false
    @@enemy_count = 0
    @@slime_count = 0
    @@slime = EnemiesData.list[:slime1]
  end

  class << self
    def update(tick)
      if tick % 160 == 0 && !@@is_boss
        if @@enemy_count <= 0
          @@enemy_count = rand(2..6)
          @@slime_count += 1
          @@slime = EnemiesData.list["slime#{@@slime_count % 2 + 1}".to_sym]
        end
        if @@slime_count % 2 == 1
          _x = Window.width / 2
          _y = Window.height * 0.5
        else
          _x = 100 + rand(Window.width - @@slime.image.width - 100)
          _y = -@@slime.image.height - rand(200)
        end
        Enemy.new(@@slime, tick, _x, _y).add_hp_bar(x: 0.7, y: 0.7)
        p "spawn", _x, _y
        @@enemy_count -= 1
      end
    end

    def is_boss
      @@is_boss
    end
  end
end
