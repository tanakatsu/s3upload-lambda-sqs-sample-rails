class CreatePictures < ActiveRecord::Migration[5.0]
  def change
    create_table :pictures do |t|
      t.string :memo
      t.boolean :thumb_created

      t.timestamps
    end
  end
end
