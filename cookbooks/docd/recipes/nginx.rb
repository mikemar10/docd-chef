cookbook_file '/etc/nginx/nginx.conf' do
  source 'nginx.conf'
  user 'root'; group 'root'; mode '644'
  verify 'nginx -t -c %{path}'
  notifies :reload, 'service[nginx]', :immediately
end
