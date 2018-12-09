class CreateChartData < ActiveRecord::Migration[5.1]
  def change
    create_table :chart_data do |t|
      t.references :artifact_status, foreign_key: true, null: false
      t.references :artifact, foreign_key: true, null: false

      t.timestamps
    end
  end
end
