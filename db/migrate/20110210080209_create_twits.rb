class CreateTwits < ActiveRecord::Migration
  def self.up
    create_table :twits do |t|
      t.integer :lastfm_id
      t.string :message

      t.timestamps
    end
  end

  def self.down
    drop_table :twits
  end
end
