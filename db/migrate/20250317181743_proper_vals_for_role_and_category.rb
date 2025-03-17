class ProperValsForRoleAndCategory < ActiveRecord::Migration[8.0]
  def change
    reversible do |dir|
      dir.up do
        return unless table_exists?(:roles) && table_exists?(:categories)

        # Add the roles
        role_names = [ "Student", "Teaching Assistant", "Professor" ]
        role_names.each do |name|
          next if connection.select_value("SELECT 1 FROM roles WHERE name = #{connection.quote(name)}")
          connection.execute(
            "INSERT INTO roles (name, created_at, updated_at) VALUES (#{connection.quote(name)}, #{connection.quote(Time.current)}, #{connection.quote(Time.current)})"
          )
        end

        # Add the categories
        category_names = [ "Tool", "Material", "Equipment" ]
        category_names.each do |name|
          next if connection.select_value("SELECT 1 FROM categories WHERE name = #{connection.quote(name)}")
          connection.execute(
            "INSERT INTO categories (name, created_at, updated_at) VALUES (#{connection.quote(name)}, #{connection.quote(Time.current)}, #{connection.quote(Time.current)})"
          )
        end
      end

      dir.down do
        if table_exists?(:roles)
          connection.execute("DELETE FROM roles WHERE name IN ('Student', 'Teaching Assistant', 'Professor')")
        end

        if table_exists?(:categories)
          connection.execute("DELETE FROM categories WHERE name IN ('Tool', 'Material', 'Equipment')")
        end
      end
    end
  end
end
