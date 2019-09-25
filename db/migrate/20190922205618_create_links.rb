class CreateLinks < ActiveRecord::Migration[6.0]
  def change
    create_table :links do |t|
      t.string :url
      t.string :slug
      t.text :title
      t.integer :views

      t.timestamps
      t.index :url, unique: true
      t.index :slug, unique: true
    end
  end
end
