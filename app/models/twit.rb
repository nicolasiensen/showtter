# coding:utf-8
class Twit < ActiveRecord::Base
  validates_uniqueness_of :lastfm_id
  validates_length_of :message, :maximum => 140
  before_create {|twit| Twitter.update twit.message}

  def self.sync
    Rockstar.events(:location => 'porto alegre').each do |event|
      Twit.create :lastfm_id => event.eid, :message => Twit.message(event)
    end
  end

  def self.message event
    bitly = Bitly.new('showtter', 'R_a4ff4fe172d3c4743e8fc8da4b1a1820')
    "#{event.title} em #{event.venue.city} (#{event.venue.name}) dia #{event.start_date.strftime('%d/%m/%Y às %H:%M')} - #{bitly.shorten(event.url).short_url}"
  end
end
