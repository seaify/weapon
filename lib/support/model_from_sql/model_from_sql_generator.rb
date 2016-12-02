class ModelFromSqlGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  def build_models
    ap 'args is '
    ap args[0]
    tables = ActiveRecord::Base.connection.tables

    Rails.application.eager_load!
    in_models = ActiveRecord::Base.descendants.map(&:table_name)
    ap 'tables from database'
    ap tables
    ap in_models
    new_tables = tables - in_models - ['schema_migrations', 'ar_internal_metadata']
    if args[0]
      new_tables = new_tables.select {|table| table.include?(args[0])}
    end


    ap 'new tables'
    ap new_tables

    new_tables.each do |table_name|
      generate "model #{table_name} --skip-migration" # or whatever you want here
      model_file = "app/models/#{table_name.singularize}.rb"
      ap 'new model file'
      ap 'output columns'
      self.generate_migrate(table_name)
      ap model_file
      inject_into_file model_file, before: "end\n" do <<-'RUBY'
  self.table_name = "table_name_replace"
      RUBY
      end
      gsub_file model_file, 'table_name_replace', table_name
    end
  end

  def generate_migrate(table_name)
    valid_columns = ActiveRecord::Base.connection.columns(table_name).select {|column| !['id', 'created_at', 'updated_at'].include?(column.name)}
    ap valid_columns
    add_columns = valid_columns.map do |column|
      ap column
      ap column.name
      ap column.default
      ap column.comment
      ap column.sql_type_metadata
      sql = "add_column :#{column.table_name}, :#{column.name}, :#{column.sql_type_metadata.type}"
      sql += ", default: #{column.default}" if column.default && column.default.is_a?(Integer)
      sql += ", default: '#{column.default}'" if column.default && column.default.is_a?(String)
      sql += ", comment: '#{column.comment}'" if column.comment
      sql += ", null: #{column.null}"
      sql
    end
    ap add_columns
    migrate_file = "db/migrate/#{Time.now.strftime("%Y%m%d%H%M%S")}_create_#{table_name}.rb"
    run "touch #{migrate_file}"
    run "echo 'replace\n' >> #{migrate_file}"
    inject_into_file migrate_file, before: "replace\n" do <<-'RUBY'
class CreateModelReplace < ActiveRecord::Migration
  def change
    create_table :table_replace
    add_columns
  end
end
    RUBY
    end
    gsub_file migrate_file, 'ModelReplace', table_name.camelize
    gsub_file migrate_file, 'add_columns', add_columns.join("\n    ")
    gsub_file migrate_file, 'table_replace', table_name.pluralize
    gsub_file migrate_file, 'replace', ''
  end

end