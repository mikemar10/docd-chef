lsb_release = node[:lsb][:codename]

file '/etc/apt/sources.list.d/nginx.list' do
  content <<EOM
deb http://ppa.launchpad.net/nginx/stable/ubuntu #{lsb_release} main 
deb-src http://ppa.launchpad.net/nginx/stable/ubuntu #{lsb_release} main 
EOM
  user 'root'; group 'root'; mode 644
  notifies :run, 'execute[import nginx repo key]', :immediately
  notifies :run, 'execute[update apt package index]', :delayed
end

file '/etc/apt/sources.list.d/postgresql.list' do
  content <<EOM
deb http://apt.postgresql.org/pub/repos/apt/ #{lsb_release}-pgdg main
EOM
  user 'root'; group 'root'; mode 644
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
  action :nothing
end

packages_to_install = %w[
  build-essential
  dstat
  git
  htop
  nginx
  postgresql-9.5
  vim
]

package packages_to_install do
  action :nothing
  subscribes :install, 'execute[update apt package index]', :immediately
end