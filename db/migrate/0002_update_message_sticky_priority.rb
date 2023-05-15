class UpdateMessageStickyPriority < ActiveRecord::Migration[4.2]
  def self.up
    Message.all.each do |msg|
      if msg.sticky?
        msg.sticky_priority=1
        msg.save!
      end
    end
  end

  def self.down
  end
end
