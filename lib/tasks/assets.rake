# lib/tasks/assets.rake
namespace :assets do
  desc "Clobber assets, precompile them, and start bin/dev"
  task rebuild_and_dev: :environment do
    puts "Clobbering assets..."
    system("rails assets:clobber") or abort("Failed to clobber assets")

    puts "Precompiling assets..."
    system("rails assets:precompile") or abort("Failed to precompile assets")

    puts "Starting bin/dev..."
    exec("bin/dev")
  end
end
