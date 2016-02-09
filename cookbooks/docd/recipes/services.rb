services = %w[memcached nginx postgresql runsvdir]

file '/etc/init/runsvdir.conf' do
  content <<EOM
# for runit - manage /usr/sbin/runsvdir-start
start on runlevel 2
start on runlevel 3
start on runlevel 4
start on runlevel 5
stop on shutdown
respawn
exec /usr/sbin/runsvdir-start
EOM
  user 'root'; group 'root'; mode '644'
end

services.each do |svc|
  service svc do
    action %i[enable start]
    supports %i[start stop restart status reload].zip([true].cycle).to_h
  end
end
