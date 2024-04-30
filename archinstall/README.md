# for cloning and install in this folder
archinstall --config  user_configuration.json --creds  user_credentials.json --disk_layouts  user_disk_layout.json

# else:
url="https://raw.githubusercontent.com/raisinbl/arch/master/archinstall"
archinstall --config  $url/user_configuration.json --creds  $url/user_credentials.json --disk_layouts  $url/user_disk_layout.json

