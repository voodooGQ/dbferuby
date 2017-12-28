class CreateArea < ActiveRecord::Migration[5.1]
  def change
    create_table :areas do |t|
      t.string :name
    end
  end
end
