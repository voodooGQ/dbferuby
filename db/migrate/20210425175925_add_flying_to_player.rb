class AddFlyingToPlayer < ActiveRecord::Migration[5.2]
  def up
    add_column :players, :flying, :boolean, default: false
  end

  def down
    remove_column :players, :flying
  end
end
