class PlayerSetting
  attr_accessor :auto_attack

  def initialize
    @auto_attack = false
  end
end

$p_set = PlayerSetting.new
