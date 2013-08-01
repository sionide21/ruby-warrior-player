class Player
  attr_reader :warrior, :old_health

  def initialize
    @old_health = 20
    @backward = true
  end

  def under_attack?
    warrior.health < old_health
  end

  def backward?
    @backward &&= !warrior.feel(:backward).wall?
  end

  def play_turn(warrior)
    @warrior = warrior
    case
    when under_attack?
      vlad = DangerVald
    when backward?
      vlad = BackwardsVlad
    else
      vlad = Vlad
    end
    vlad.new(warrior).act!
    @old_health = warrior.health
  end
end

class Vlad
  attr_reader :warrior
  def initialize(warrior)
    @warrior = warrior
  end

  def direction
    :forward
  end
  def backward
    :backward
  end

  def hurt?
    warrior.health < 19
  end

  def feel
    warrior.feel direction
  end

  def should_fight?
    feel.enemy?
  end

  def should_heal?
    hurt?
  end

  def should_rescue?
    feel.captive?
  end

  def should_retreat?
    false
  end

  def act!
    case
    when should_retreat?
      warrior.walk! backward
    when should_rescue?
      warrior.rescue! direction
    when should_fight?
      warrior.attack! direction
    when should_heal?
      warrior.rest!
    else
      warrior.walk! direction
    end
  end
end

class DangerVald < Vlad
  def should_heal?
    false
  end
  def should_retreat?
    warrior.health < 10
  end
end

class BackwardsVlad < Vlad
  def direction
    :backward
  end
  def backward
    :forward
  end
end
