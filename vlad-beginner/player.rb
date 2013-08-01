class Player
  attr_reader :warrior, :old_health

  def initialize
    @old_health = 20
  end

  def under_attack?
    warrior.health < old_health
  end

  def play_turn(warrior)
    @warrior = warrior
    case
    when under_attack?
      vlad = DangerVald
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

  def hurt?
    warrior.health < 19
  end

  def should_fight?
    warrior.feel.enemy?
  end

  def should_heal?
    hurt?
  end

  def should_rescue?
    warrior.feel.captive?
  end

  def act!
    case
    when should_rescue?
      warrior.rescue!
    when should_fight?
      warrior.attack!
    when should_heal?
      warrior.rest!
    else
      warrior.walk!
    end
  end
end

class DangerVald < Vlad
  def should_heal?
    false
  end
end
