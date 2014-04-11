# Local deployment
set :repository,  "."
set :scm, :none
set :deploy_via, :copy

# deploy config

#require 'bundler/capistrano'
default_run_options[:pty] = true 
set :user, 'root'  # Your dreamhost account's username
set :domain, '50.116.54.146'  # Dreamhost servername where your account is located 
set :application, 'gerbsofwisdom'  # Your app's location (domain or sub-domain name as setup in panel)
set :applicationdir,"/home/#{user}/gerbsofwisdom.com"  # The standard Dreamhost setup
set :normalize_asset_timestamps, false
set :do_migrate,false

set :deploy_to, applicationdir
set :deploy_via, :copy
set :rails_env, "production"



role :web, domain                        # Your HTTP server, Apache/etc
role :app, domain                          # This may be the same as your `Web` server
role :db,  domain, :primary => true # This is where Rails migrations will run

task :reindex do
  run "cd #{deploy_to}/current; rake RAILS_ENV=#{rails_env} ts:conf "
  run "#{indexer_path} --config #{sphinx_config_file} --rotate --all "
  run "/bin/chmod a+rwx #{sphinx_pid}"

end

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
   run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

desc "Generate Site Maps"
  task :deploy_sitemapper do
        #run "ln -nfs /data/sitemaps #{deploy_to}/current/public/#{sitemaps_folder}"
        # turning this off for now - lets do this manually for the moment - kdw
        #run "chmod +x #{deploy_to}/current/generate_sitemapper.sh"
        run "cd #{deploy_to}/current; rake RAILS_ENV=#{rails_env} sitemaps:create_sitemap "
  end

    namespace :thinking_sphinx do
      
       task :update_indexes,:roles => :app do
         run("cd #{release_path} && rake ts:rebuild")
         
       end
      
      
    end
    namespace :bundler do
      task :install, :roles => :app, :except => { :no_release => true }  do
        run("gem install bundler --source=http://rubygems.org")
      end
     
      task :create_symlink, :roles => :app do
        shared_dir = File.join(shared_path, 'bundle')
        release_dir = File.join(current_release, '.bundle')
        run("mkdir -p #{shared_dir} && ln -fs #{shared_dir} #{release_dir}")
      end
     
      task :bundle_new_release, :roles => :app do
        bundler.create_symlink
        run "cd #{release_path} && bundle install --without test"
      end
     
      task :lock, :roles => :app do
        run "cd #{current_release} && bundle lock;"
      end
     
      task :unlock, :roles => :app do
        run "cd #{current_release} && bundle unlock;"
      end
    end
     
    
#after "deploy","thinking_sphinx:update_indexes"
after "deploy:setup", "bundler:install"
after  "deploy:update_code", "bundler:bundle_new_release"
#after "deploy", "deploy:migrate"
#after 'deploy','deploy_sitemapper'
