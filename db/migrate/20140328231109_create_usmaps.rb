class CreateUsmaps < ActiveRecord::Migration
  def change
    create_table :usmaps do |t|

      t.timestamps
    end
  end
end
