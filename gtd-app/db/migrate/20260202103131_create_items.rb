class CreateItems < ActiveRecord::Migration[8.1]
  def change
    create_table :items do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.text :description
      t.string :item_type
      t.string :status
      t.references :context, null: true, foreign_key: true
      t.references :project, null: true, foreign_key: true
      t.date :due_date
      t.datetime :completed_at
      t.string :energy_level
      t.integer :time_required

      t.timestamps
    end
  end
end
