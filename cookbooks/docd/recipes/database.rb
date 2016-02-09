database_credentials = Chef::EncryptedDataBagItem.load(:docd, :database)

execute 'create docd database user' do
  command "psql -U postgres -c \"CREATE ROLE docd ENCRYPTED PASSWORD #{database_credentials['password']} CREATEDB LOGIN;\""
  not_if "psql -U postgres -c \"SELECT * FROM pg_user WHERE usename='docd'\" | grep docd"
end

execute 'create docd database' do
  command 'createdb -U postgres -O docd docd'
  not_if "psql -U postgres -c \"SELECT * FROM pg_database WHERE datname='docd'\" | grep docd"
end

