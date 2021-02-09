class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title
      t.references :user, foreign_key: true
      t.string :impression
      t.integer :nowpage
      t.integer :page
      t.string :status
      t.string :code
      t.text :img
      t.date :date

      t.timestamps
    end
  end
end
