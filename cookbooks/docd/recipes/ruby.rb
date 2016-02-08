ruby_install_version = '0.6.0'
desired_ruby_version = '2.3.0'

execute 'install ruby-install' do
  command <<EOM
cd /tmp
wget -O ruby-install-#{ruby_install_version}.tar.gz https://github.com/postmodern/ruby-install/archive/v#{ruby_install_version}.tar.gz
tar -xzf ruby-install-#{ruby_install_version}.tar.gz
cd ruby-install-#{ruby_install_version}/
make install
EOM
  not_if { ::File.exist?("/tmp/ruby-install-#{ruby_install_version}") }
end

execute "install ruby version #{desired_ruby_version}" do
  command "/usr/local/bin/ruby-install --system ruby #{desired_ruby_version} && /usr/local/bin/gem install --no-document bundler"
  not_if "/usr/local/bin/ruby -e 'exit(RUBY_VERSION == \"#{desired_ruby_version}\")'"
end
