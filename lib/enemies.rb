class Enemies
  @@list = []

  class << self
    def update(now_stage, tick, player)
      i = 1
      @@list.length.times do
        enemy = @@list[-i]
        EnemySystem.move(enemy, now_stage, tick, player)

        bullets = enemy.check(Bullet.list)
        unless bullets.empty? # hit bulett
          $se_slime.play
          EnemySystem.calc_hp(enemy, bullets[0])

          # delete sprite
          Bullet.list.delete(bullets[0])
          if enemy.data.hp <= 0
            $se_retro04.play
            @@list.delete_at(-i)
            $score += enemy.data.score
          end
          next
        end
        @@list.delete_at(-i) if enemy.y > Window.height
        i += 1
      end
    end

    def draw
      Sprite.draw(@@list)
    end

    def list
      @@list
    end

    def reset
      @@list = []
    end
  end
end

Enemies.new
