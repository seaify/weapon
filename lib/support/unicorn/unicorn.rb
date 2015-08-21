app_path = File.expand_path( File.join(File.dirname(__FILE__), '..'))
worker_processes   2
timeout            180
listen             '/tmp/app_name_for_replace.unicorn.sock'
pid                "#{app_path}/tmp/pids/unicorn.pid"
stderr_path        "log/unicorn.log"
stdout_path        "log/unicorn.log"

before_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  old_pid = "#{server.config[:pid]}.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
  end
end

working_directory("#{app_path}")
puts app_path

before_exec do |server| # 修正无缝重启unicorn后更新的Gem未生效的问题，原因是config/boot.rb会优先从ENV中获取BUNDLE_GEMFILE，而无缝重启时ENV['BUNDLE_GEMFILE']的值并未被清除，仍指向旧目录的Gemfile
  ENV["BUNDLE_GEMFILE"] = "#{app_path}/Gemfile"
end
