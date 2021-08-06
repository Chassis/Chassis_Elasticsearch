# Create an Elasticsearch class
class chassis_elasticsearch(
  $config
) {
  if ( ! empty( $config[disabled_extensions] ) and 'chassis/chassis_elasticsearch' in $config[disabled_extensions] ) {
    class { 'elasticsearch':
      ensure => 'absent'
    }
    package { 'java-common':
      ensure => 'absent'
    }
  } else {
    include ::java
    # Default settings for install
    $defaults = {
      'repo_version' => '7',
      'version'      => '7.10.2',
      'plugins'      => [
        'analysis-icu'
      ],
      'host'         => '0.0.0.0',
      'port'         => 9200,
      'timeout'      => 60,
      # Ensure Java doesn't try to eat all the RAMs by default
      'memory'       => 256,
      'jvm_options'  => [],
    }

    # Allow override from config.yaml
    $options = deep_merge($defaults, $config[elasticsearch])

    # Ensure memory is an integer
    $memory = Integer($options[memory])

    # Create default jvm_options using memory setting
    $jvm_options_defaults = [
      "-Xms${memory}m",
      "-Xmx${memory}m",
    ]

    # Merge JVM options using our custom function
    $jvm_options = merge_jvm_options($options[jvm_options], $jvm_options_defaults)

    # Support legacy repo version values.
    $repo_version = regsubst($options[repo_version], '^(\d+).*', '\\1')

    class { 'elastic_stack::repo':
      version => Integer($repo_version),
      notify  => Exec['apt_update'],
      oss     => true,
    }

    # Install Elasticsearch
    class { 'elasticsearch':
      manage_repo       => true,
      version           => $options[version],
      jvm_options       => $jvm_options,
      api_protocol      => 'http',
      api_host          => $options[host],
      api_port          => $options[port],
      api_timeout       => $options[timeout],
      config            => {
        'network.host'   => '0.0.0.0',
        'discovery.type' => 'single-node',
      },
      restart_on_change => true,
      status            => enabled,
      oss               => true,
    }

    # Install plugins
    elasticsearch::plugin { $options[plugins]: }

    # Ensure a dummy index is missing; this ensures the ES connection is
    # running before we try installing.
    elasticsearch::index { 'chassis-validate-es-connection':
      ensure  => 'absent',
      require => [
        Elasticsearch::Plugin[ $options[plugins] ],
      ],
      before  => Chassis::Wp[ $config['hosts'][0] ],
    }
  }
}
