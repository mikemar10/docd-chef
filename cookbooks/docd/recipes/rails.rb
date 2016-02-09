database_credentials = Chef::EncryptedDataBagItem.load(:docd, :database)
rails_secrets = Chef::EncryptedDataBagItem.load(:docd, :secrets)

template '/home/docd/docd/shared/config/database.yml' do
  source 'database.yml.erb'
  user 'docd'; group 'docd'; mode '400'
  variables(
    password: database_credentials['password']
  )
end

template '/home/docd/docd/shared/config/secrets.yml' do
  source 'secrets.yml.erb'
  user 'docd'; group 'docd'; mode '400'
  variables(
    prod_secret: rails_secrets['production']
  )
end
