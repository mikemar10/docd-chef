cookbook_file '/home/docd/docd/shared/config/unicorn.rb' do
  source 'unicorn.rb'
  user 'docd'; group 'docd'; mode '644'
end

directory '/var/log/unicorn' do
  user 'root'; group 'root'; mode '755'
  recursive true
end

# runit
directory '/etc/service/docd_unicorn/log' do
  user 'root'; group 'root'; mode '755'
  recursive true
end

file '/etc/service/docd_unicorn/log/run' do
  content <<EOM
#!/bin/bash
set -ex
exec svlogd -tt /var/log/unicorn
EOM
  user 'root'; group 'root'; mode '755'
end

file '/etc/service/docd_unicorn/run' do
  content <<EOM
#!/bin/bash
set -ex
exec chpst -u docd:docd -/home/docd/docd/current unicorn -c config/unicorn.rb
EOM
  user 'root'; group 'root'; mode '755'
end
