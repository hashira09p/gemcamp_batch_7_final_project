class CreateMemberLevels < ActiveRecord::Migration[7.0]
  def change
    create_table :member_levels do |t|
      t.integer :level, null: true
      t.integer :required_members, null: true
      t.integer :coins, null: true

      t.timestamps
    end
  end
end
