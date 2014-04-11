class CreateBubbles < ActiveRecord::Migration
  def change
    create_table :bubbles do |t|

      t.timestamps
    end
  end
end
