services = %w[nginx postgresql]

services.each do |svc|
  service svc do
    action %i[enable start]
    supports %i[start stop restart status reload].zip([true].cycle).to_h
  end
end
