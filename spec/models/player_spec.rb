require File.dirname(__FILE__) + '/../spec_helper'

describe Player do
  context "dead" do
    it "is true when health is 0 or below" do
      player = Player.new
      player.health = 0
      player.dead?.should be_true
    end
    
    it "is false when health is more than 0" do
      player = Player.new
      player.health = 10
      player.dead?.should be_false
    end
  end
end
