class EnemySystem
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
    def move(enemy, now_stage, tick, player)
      stg = now_stage
      stg = :any unless enemy.data.stage_hash.has_key?(now_stage)
      enemy.data.stage_hash[stg].call(enemy, tick, player)
    end

    def calc_hp(enemy, bullet)
      boost = if spell_matching?(bullet, enemy)
                1.5
              elsif spell_missing?(bullet, enemy)
                0.3
              else
                1.0
              end

      enemy.data.hp -= bullet.attack * boost
      enemy.data.hp = [0, enemy.data.hp].max
    end

    def spell_matching?(bullet, enemy)
      @@_spell_match.each do |to, from|
        return true if bullet.spell == to && enemy.data.spell == from
      end
      false
    end

    def spell_missing?(bullet, enemy)
      @@_spell_miss.each do |to, from|
        return true if bullet.spell == to && enemy.data.spell == from
      end
      false
    end
  end
end
