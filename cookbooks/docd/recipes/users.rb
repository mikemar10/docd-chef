group 'docd'

user 'docd' do
  home '/home/docd'
  shell '/bin/bash'
  manage_home true
  group 'docd'
end

directory '/home/docd/.ssh' do
  user 'docd'; group 'docd'; mode 700
end

file '/home/docd/.ssh/authorized_keys' do
  content <<EOM
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDu6VTRBDUGRUgHrrQ+iQqlr4LkLkFhHpxcKWRA7dVz2RDNfy2ZxlmuzeRqetaQC3Q2Cym0l7qR1YIPyHl8Sy9rskA5xFFdgbx3KqYenaCxXumvP4IrkO/X9CUOsxRMSvw1uEpyIGJElgEQYJf/lrJgB0gj7sa1xvnxMFiL0m8R+rerzpPJywdZz5AS/TGl/7fIeRJzOAWUtSDoJKyqTAQUIrvm9U29pVH9GPsZUL81Q36UvXhvIcCNtcryHFiGlt3HZwca6vJLNakiBFYs+OQQYnMCTmuPyovch+tQcFPZrNeI/wKlqjsTEw+AvO7rS/WWUqwCD4EDbcNJzVgWhsc3
EOM
  user 'docd'; group 'docd'; mode 600
end
