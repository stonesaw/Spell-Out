class Enemies
  @@list = []
  @@_spell_match = [
    # [to, from] (bullet -> enemy)
    [:fire, :wind],
    [:wind, :water],
    [:water, :fire],
    [:holy, :dark],
    [:dark, :holy]
  ]
  @@_spell_miss = @@_spell_match.map.with_index {|spells, i| spells.reverse if i < 3 }
  @@_spell_miss.compact!

  class << self
    def update(now_stage, tick, player)
      i = 1
      @@list.length.times do
        enemy = @@list[-i]
        _move(enemy, now_stage, tick, player)

        bullets = enemy.check(Bullet.list)
        unless bullets.empty? # hit bulett
          $se_slime.play
          $se_slime.set_volume(225 * $volume)
          _calc_hp(enemy, bullets[0])

          # delete sprite
          Bullet.list.delete(bullets[0])
          if enemy.data.hp <= 0
            $se_retro04.play
            $se_retro04.set_volume(255 * $volume)
            @@list.delete_at(-i)
            $score += enemy.data.score
          end
          next
        end
        # @@list.delete_at(-i) if enemy.y > Window.height
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

    private
    def _move(enemy, now_stage, tick, player)
      stg = now_stage
      stg = :any unless enemy.data.stage_hash.has_key?(now_stage)
      enemy.data.stage_hash[stg].call(enemy, tick, player)
    end
    
    def _calc_hp(enemy, bullet)
      if _spell_matching?(bullet, enemy)
        boost = 1.5
      elsif _spell_missing?(bullet, enemy)
        boost = 0.3
      else
        boost = 1.0
      end

      enemy.data.hp -= bullet.attack * boost
      enemy.data.hp = [0, enemy.data.hp].max
    end

    def _spell_matching?(bullet, enemy)
      @@_spell_match.each do |to, from|
        return true if bullet.spell == to && enemy.data.spell == from
      end
      false
    end

    def _spell_missing?(bullet, enemy)
      @@_spell_miss.each do |to, from|
        return true if bullet.spell == to && enemy.data.spell == from
      end
      false
    end
  end
end

Enemies.new
