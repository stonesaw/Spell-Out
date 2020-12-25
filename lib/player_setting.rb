class PlayerSetting
  @auto_attack = false

  class << self
    attr_accessor :auto_attack
  end
end

PlayerSetting.new
