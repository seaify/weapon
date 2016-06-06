class WeaponGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def generate_grape_entity
    names = args[0].split('/')
    column_names = names[-1].camelize.constantize.column_names
    infos = column_names.map {|column| "expose :#{column}"}
    a = Magicfile.new
    a.append_modules(names[0..-2])
    a.append_class(names[-1].camelize, 'Grape::Entity')
    a.append_string_lines(infos)
    a.to_file("app/#{args[0]}.rb")
  end


end
