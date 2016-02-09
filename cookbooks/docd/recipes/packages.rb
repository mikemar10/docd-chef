lsb_release = node[:lsb][:codename]

apt_lock_file = '/var/lib/apt/periodic/update-success-stamp'

packages_to_install = %w[
  build-essential
  curl
  dstat
  git
  htop
  libpq-dev
  memcached
  nginx
  postgresql-9.5
  runit
  vim
  wget
]

file '/etc/apt/apt.conf.d/15update-timestamp' do
  content <<EOM
APT::Update::Post-Invoke-Success {"touch #{apt_lock_file} 2>/dev/null || true";};
EOM
  user 'root'; group 'root'; mode '644'
end

file '/etc/apt/sources.list.d/nginx.list' do
  content <<EOM
deb http://ppa.launchpad.net/nginx/stable/ubuntu #{lsb_release} main 
deb-src http://ppa.launchpad.net/nginx/stable/ubuntu #{lsb_release} main 
EOM
  user 'root'; group 'root'; mode '644'
  notifies :run, 'execute[import nginx repo key]', :immediately
  notifies :run, 'execute[update apt package index]', :delayed
end

file '/etc/apt/sources.list.d/postgresql.list' do
  content <<EOM
deb http://apt.postgresql.org/pub/repos/apt/ #{lsb_release}-pgdg main
EOM
  user 'root'; group 'root'; mode '644'
  notifies :run, 'execute[import postgresql repo key]', :immediately
  notifies :run, 'execute[update apt package index]', :delayed
end

execute 'import nginx repo key' do
  command 'wget -q -O- "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x00A6F0A3C300EE8C" | apt-key add -'
  action :nothing
end

execute 'import postgresql repo key' do
  command 'wget -q -O- "https://www.postgresql.org/media/keys/ACCC4CF8.asc" | apt-key add -'
  action :nothing
end

execute 'update apt package index' do
  command 'apt-get update'
  not_if { 
    last_update = File.exist?(apt_lock_file) ? File.stat(apt_lock_file).atime : Time.now - (86400 * 2)
    Time.now - last_update <= 86400 
  }
end

package packages_to_install do
  action :nothing
  subscribes :install, 'execute[update apt package index]', :immediately
end
