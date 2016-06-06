class ModelFromSqlGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  def build_models
    tables = ActiveRecord::Base.connection.tables

    Rails.application.eager_load!
    in_models = ActiveRecord::Base.descendants.map(&:table_name)
    ap in_models
    new_tables = tables - in_models - ['schema_migrations', 'ar_internal_metadata']

    new_tables.each do |table_name|
      generate "model #{table_name} --skip-migration" # or whatever you want here
      model_file = "app/models/#{table_name.singularize}.rb"
      inject_into_file model_file, before: "end\n" do <<-'RUBY'
  self.table_name = "table_name_replace"
      RUBY
      end
      gsub_file model_file, 'table_name_replace', table_name
    end

  end
end