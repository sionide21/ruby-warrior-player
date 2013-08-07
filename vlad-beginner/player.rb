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
      vlad = ArcherVlad
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

  def should_turn?
    warrior.feel.wall? or warrior.look(backward).map(&:captive?).any?
  end

  def attack!
    warrior.attack! direction
  end

  def act!
    case
    when should_turn?
      warrior.pivot!
    when should_retreat?
      warrior.walk! backward
    when should_rescue?
      warrior.rescue! direction
    when should_fight?
      attack!
    when should_heal?
      warrior.rest!
    else
      warrior.walk! direction
    end
  end
end


class ArcherVlad < Vlad
  def direction
    @direction or super
  end

  def attack!
    warrior.shoot! direction
  end

  def should_fight?
    @direction ||= [backward, direction].select do |d|
      warrior.look(d).take_while{|s| not s.captive?}.map(&:enemy?).any?
    end.first
  end
end

class DangerVald < ArcherVlad
  def should_heal?
    false
  end
  def should_retreat?
    warrior.health < 10
  end
end
