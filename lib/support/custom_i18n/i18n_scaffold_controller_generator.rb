require 'rails/generators/resource_helpers'

module Rails
  module Generators
    class I18nScaffoldControllerGenerator < NamedBase # :nodoc:
      include ResourceHelpers

      check_class_collision suffix: "Controller"

      class_option :helper, type: :boolean
      class_option :orm, banner: "NAME", type: :string, required: true,
                         desc: "ORM to generate the controller for"
      class_option :api, type: :boolean,
                         desc: "Generates API controller"

      argument :attributes, type: :array, default: [], banner: "field:type field:type"

      def update_i18n
        data = YAML.load_file "config/locales/zh-CN.yml"
        if not data.has_key?("zh-CN")
          data["zh-CN"] = {}
        end
        if not data['zh-CN'].has_key?("activerecord")
          data["zh-CN"]["activerecord"] = {"models" => {}, "attributes" => {file_name => {}}}
        end
        if not data["zh-CN"].has_key?("helpers")
          data["zh-CN"]["helpers"] = {}
        end

        if not data["zh-CN"]["helpers"].has_key?("submit")
          data["zh-CN"]["helpers"]["submit"] = {}
        end
        data["zh-CN"]["helpers"]["submit"][file_name] = {"create" => "创建", "update" => "更新"}

        data["zh-CN"]["activerecord"]["models"][file_name] = file_name
        data["zh-CN"]["activerecord"]["attributes"][file_name] = {}

        attributes.each do |attr|
          data["zh-CN"]["activerecord"]["attributes"][file_name][attr.name] = attr.name
        end
        data["zh-CN"]["activerecord"]["attributes"][file_name]['id'] = 'ID'
        data["zh-CN"]["activerecord"]["attributes"][file_name]['created_at'] = '创建时间'
        data["zh-CN"]["activerecord"]["attributes"][file_name]['updated_at'] = '更新时间'

        data["zh-CN"]['action'] = {'back' => '返回', 'new' => '创建', 'show' => '查看', 'edit' => '编辑', 'delete' => '删除', 'confirm_delete' => '确认删除', 'created' => {'successfully' => '创建成功'}, 'updated' => {'successfully' => '更新成功'}, 'destroyed' => {'successfully' => '删除成功'}}

        File.open("config/locales/zh-CN.yml", 'wb') { |f| YAML.dump(data, f) }
      end

      def create_controller_files
        template_file = options.api? ? "api_controller.rb" : "controller.rb"
        template template_file, File.join('app/controllers', controller_class_path, "#{controller_file_name}_controller.rb")
      end

      hook_for :template_engine, :test_framework, as: :scaffold

      # Invoke the helper using the controller name (pluralized)
      hook_for :helper, as: :scaffold do |invoked|
        invoke invoked, [ controller_name ]
      end
    end
  end
end
