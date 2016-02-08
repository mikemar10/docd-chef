ruby_install_version = '0.6.0'

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

desired_ruby_versions = %w[
  2.3.0
]

desired_ruby_versions.each do |ruby_version| do
  execute "install ruby version #{ruby_version}" do
    command "ruby-install --system ruby #{ruby_version}"
  end
end
