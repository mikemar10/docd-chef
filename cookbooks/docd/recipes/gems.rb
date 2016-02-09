gems_to_install = %w[
  unicorn
]

gems_to_install.each do |gem|
  gem_package gem do
    gem_binary '/usr/local/bin/gem'
    options '--no-document'
  end
end
