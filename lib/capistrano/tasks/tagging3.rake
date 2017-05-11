namespace :tagging3 do
  set :tagging3_format, ':rails_env_:release'
  
  def fetch_or_send(method)
    fetch method, respond_to?(method) ? send(method) : nil
  end

  def tag(options = {})
    fetch(:tagging3_format).gsub(/:([a-z_]+[^_:])/i) do |match|
      method = $1.to_sym
      options.fetch method, fetch_or_send(method)
    end
  end

  def user_name
    `git config --get user.name`.chomp
  end

  def user_email
    `git config --get user.email`.chomp
  end

  def create_tag(name)
    puts `git tag #{name} #{fetch(:revision)} -m "Deployed by #{user_name} <#{user_email}>"`
    puts `git push origin refs/tags/#{name}:refs/tags/#{name}`
  end

  def remove_tag(name)
    puts `git tag -d #{name}`
    puts `git push origin :refs/tags/#{name}`
  end

  desc "Create release tag in local and origin repo"
  task :deploy do
    create_tag tag(:release => fetch(:release_timestamp))
  end

  desc "Remove release tag from local and origin repo"
  task :cleanup do
    count = fetch(:keep_releases, 5).to_i
    multiple_hosts = false
    on roles(:all) do |host|
      #puts "HOST: #{host.inspect}"
      releases = capture(:ls, '-xtr', releases_path).split

      if count >= releases.size
        puts "no old release tags to clean up" unless multiple_hosts
      else
        puts "keeping #{count} of #{releases.size} release tags"
        releases.first(releases.size - count).map do |release|
          remove_tag tag(:release => release)
        end
      end
      multiple_hosts = true
    end
  end
end

after  'deploy:restart', 'tagging3:deploy'
before 'deploy:cleanup', 'tagging3:cleanup'

