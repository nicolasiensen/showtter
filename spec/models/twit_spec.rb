# coding:utf-8
require 'spec_helper'

describe Twit do
  it{should_not allow_value("X" * 141).for(:message)}

  let(:event1){mock("Rockstar::Event", :eid => 1)}
  let(:event2){mock("Rockstar::Event", :eid => 2)}

  before :each do
    Twitter.stub :update
  end
  
  describe ".sync" do
    before :each do
      Twit.stub(:message)
    end

    it "synchronizes event 1 and 2" do
      Rockstar.stub(:events).with(:location => 'porto alegre').and_return([event1, event2])
      Twit.sync
      Twit.all.map{|t| t.lastfm_id}.should be_== [event1.eid, event2.eid]
    end

    context "event 1 already exist" do
      before :each do
        Twit.create :lastfm_id => event1.eid
      end

      it "synchronizes just event2" do
        Rockstar.stub(:events).with(:location => 'porto alegre').and_return([event1, event2])
        Twit.sync
        Twit.all.map{|t| t.lastfm_id}.should be_== [event1.eid, event2.eid]
      end
    end
  end

  describe ".message" do
    let(:escalandrum){mock("Rockstar::Event", :title => "Escalandrum", :venue => mock("Rockstar::Venue", :city => "Porto Alegre", :name => "Santander Cultural"), :start_date => Time.new(2010, 10, 2, 18, 0, 0), :url => "http://www.last.fm/venue/8808164+Santander+Cultural")}
    
    before :each do
      Bitly.stub(:new).and_return(mock "Bitly::V3::Client", :shorten => mock("Bitly::V3::Url", :short_url => "http://bit.ly/xxxxxx"))
    end

    it "returns Escalandrum message" do
      Twit.message(escalandrum).should be_== "Escalandrum em Porto Alegre (Santander Cultural) dia 02/10/2010 às 18:00 - #{Bitly.new.shorten.short_url}"
    end
  end
end
