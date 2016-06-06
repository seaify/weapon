class BuildActiveadminPagesGenerator < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)

  def build_pages
    Rails.application.eager_load!

    all_models = ActiveRecord::Base.descendants

    all_models.each do |model_ins|

    end


  end
end