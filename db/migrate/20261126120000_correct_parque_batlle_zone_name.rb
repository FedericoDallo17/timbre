class CorrectParqueBatlleZoneName < ActiveRecord::Migration[8.0]
  def up
    execute <<~SQL
      UPDATE zones
      SET name = 'Parque Batlle - Villa Dolores',
          aliases = ARRAY(SELECT DISTINCT unnest(aliases || ARRAY[
            'pque batlle villa dolores', 'parque batlle - villa dolores',
            'parque batlle villa dolores', 'parque batlle', 'villa dolores'
          ])),
          updated_at = CURRENT_TIMESTAMP
      WHERE slug = 'pque-batlle-villa-dolores'
    SQL
  end

  def down
    execute <<~SQL
      UPDATE zones
      SET name = 'Pque Batlle Villa Dolores', updated_at = CURRENT_TIMESTAMP
      WHERE slug = 'pque-batlle-villa-dolores'
    SQL
  end
end
