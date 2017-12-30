class AddAdminFlagToPlayer < ActiveRecord::Migration[5.1]
  def up
    add_column :players, :admin, :boolean, default: false
  end

  def down
    remove_column :players, :admin
  end
end

