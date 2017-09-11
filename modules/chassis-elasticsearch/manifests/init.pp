class chassis_elasticsearch(
  $config
) {
  notify { 'Installing Elasticsearch': }

  # Install Elasticsearch
  class { 'elasticsearch':
    # version: '1.5.2'
  }

  # Create an instance?
  class { 'instance': }

  # Check for list of plugins defined in config

}
