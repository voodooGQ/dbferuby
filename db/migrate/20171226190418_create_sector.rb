class CreateSector < ActiveRecord::Migration[5.1]
  def change
    create_table :sectors do |t|
      t.string :name, null: false, unique: true
      t.string :character_code, limit: 1, null: false, unique: true
      t.string :symbol
      t.string :color
      t.string :alternate_symbol
      t.string :alternate_color
    end
  end
end
