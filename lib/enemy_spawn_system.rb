class EnemySpawnSystem
  def initialize
    @@is_boss = false
    @@enemy_count = 0
    @@slime_count = 0
    @@slime = EnemiesData.list[:slime1]
    @@boss_count = 0
    @@boss_spawn_ticks = 1200
  end

  class << self
    def update(tick)
      # TODO スライムは画面の上下左右の端からランダムで出現
      if tick % 160 == 0 && !@@is_boss && tick < @@boss_spawn_ticks
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
        @@enemy_count -= 1
      end
      
      if tick >= @@boss_spawn_ticks
        Enemies.list.clear if !@@is_boss
        @@is_boss = true
        _x = 100 + rand(Window.width - EnemiesData.list[:golem].image.width - 100)
        _y = -EnemiesData.list[:golem].image.height - rand(200)
        if tick % 200 == 0 && @@boss_count < 3
          @@boss_count += 1
          Enemy.new(EnemiesData.list[:golem], tick, _x, _y).add_hp_bar
        end
      end
    end

    def is_boss?
      @@is_boss
    end
  end
end
