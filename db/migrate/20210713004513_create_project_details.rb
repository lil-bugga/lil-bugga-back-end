class CreateProjectDetails < ActiveRecord::Migration[6.1]
  def change
    create_table :project_details do |t|
      t.references :project, null: false, foreign_key: true
      t.string :project_name
      t.text :description

      t.timestamps
    end
  end
end
