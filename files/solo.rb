cookbook_path [ 
  File.expand_path("../cookbooks", __FILE__), 
  File.expand_path("../imported_cookbooks", __FILE__)
]

data_bag_path File.expand_path("../data_bags", __FILE__)
role_path File.expand_path("../roles", __FILE__)

