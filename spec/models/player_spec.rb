require File.dirname(__FILE__) + '/../spec_helper'

describe Player do
  context "dead" do
    before(:each) do
      @player = Player.new
    end
    it "is true when health is 0 or below" do
      @player.health = 0
      @player.dead?.should be_true
    end
    
    it "is false when health is more than 0" do
      @player.health = 10
      @player.dead?.should be_false
    end
  end
  
  context "location" do
    before(:each) do
      @player = Player.new
      @player.x = 10
      @player.y = 23
    end
    
    it "returns true if the player is in the location passed to it" do
      @player.in?(10,23).should be_true
    end
    
    it "returns false if the user is not in the location passed in" do
      @player.in?(14,76).should be_false
    end
  end
end
