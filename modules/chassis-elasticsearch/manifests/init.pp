class chassis-elasticsearch(
  $config
) {

  # Default settings for install
  $defaults = {
    'version'   => '5.x',
    'plugins'   => [
      'analysis-icu'
    ],
    'host'      => '0.0.0.0',
    'port'      => 9200,
    'timeout'   => 10,
    'instances' => [
      'es'
    ]
  }

  # Allow override from config.yaml
  $options = deep_merge( $defaults, $config[elasticsearch] )

  # Install Elasticsearch
  class { 'elasticsearch':
    java_install      => true,
    manage_repo       => true,
    repo_version      => $options[version],
    # Ensure Java doesn't try to eat all the RAMs
    jvm_options       => [
      '-Xms512m',
      '-Xmx512m'
    ],
    api_protocol      => 'http',
    api_host          => $options[host],
    api_port          => $options[port],
    api_timeout       => $options[timeout],
  }

  # Create instances
  elasticsearch::instance { $options[instances]: }

  # Install plugins
  elasticsearch::plugin { $options[plugins]:
    instances => $options[instances],
  }

}
