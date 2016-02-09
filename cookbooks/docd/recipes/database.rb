database_credentials = Chef::EncryptedDataBagItem.load(:docd, :database)

execute 'create docd database user' do
  command "psql -c \"CREATE ROLE docd ENCRYPTED PASSWORD '#{database_credentials['password']}' CREATEDB LOGIN;\""
  user 'postgres'
  not_if "psql -c \"SELECT * FROM pg_user WHERE usename='docd';\" | grep docd"
end

execute 'create docd database' do
  command 'createdb -O docd docd'
  user 'postgres'
  not_if "psql -c \"SELECT * FROM pg_database WHERE datname='docd';\" | grep docd"
end

