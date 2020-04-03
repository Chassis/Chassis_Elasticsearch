# Create an Elasticsearch class
class chassis_elasticsearch(
  $config
) {
  include ::java
  if ( ! empty( $config[disabled_extensions] ) and 'chassis/chassis_elasticsearch' in $config[disabled_extensions] ) {
    service { 'elasticsearch-es':
      ensure => stopped,
      before => Class['elasticsearch']
    }
    class { 'elasticsearch':
      ensure => 'absent'
    }
    package { 'java-common':
      ensure => absent
    }
  } else {
    # Default settings for install
    $defaults = {
      'repo_version' => '5',
      'version'      => '5.6.1',
      'plugins'      => [
        'analysis-icu'
      ],
      'host'         => '0.0.0.0',
      'port'         => 9200,
      'timeout'      => 30,
      'instances'    => [
        'es'
      ],
      # Ensure Java doesn't try to eat all the RAMs
      'jvm_options'  => [
        '-Xms256m',
        '-Xmx256m',
        # The following rules ensure these settings are only used for
        # versions of Java that support them, otherwise Elastic will fail
        # to start.
        '8:-XX:NumberOfGCLogFiles=32',
        '8:-XX:GCLogFileSize=64m',
        '8:-XX:+UseGCLogFileRotation',
        '8:-XX:+PrintTenuringDistribution',
        '8:-XX:+PrintGCDateStamps',
        '8:-XX:+PrintGCApplicationStoppedTime',
        '8:-XX:+UseConcMarkSweepGC',
        '8:-XX:+UseCMSInitiatingOccupancyOnly',
        '11:-XX:+UseG1GC',
        '11:-XX:InitiatingHeapOccupancyPercent=75'
      ],
    }

    # Allow override from config.yaml
    $options = deep_merge($defaults, $config[elasticsearch])

    # Support legacy repo version values.
    $repo_version = regsubst($options[repo_version], '^(\d+).*', '\\1')

    class { 'elastic_stack::repo':
      version => Integer($repo_version),
    }

    # Install Elasticsearch
    class { 'elasticsearch':
      manage_repo  => true,
      version      => $options[version],
      jvm_options  => $options[jvm_options],
      api_protocol => 'http',
      api_host     => $options[host],
      api_port     => $options[port],
      api_timeout  => $options[timeout],
    }

    # Create instances
    elasticsearch::instance { $options[instances]:
      config => {
        'network.host' => '0.0.0.0'
      },
    }

    # Install plugins
    elasticsearch::plugin { $options[plugins]:
      instances => $options[instances],
    }

    # Ensure a dummy index is missing; this ensures the ES connection is
    # running before we try installing.
    elasticsearch::index { 'chassis-validate-es-connection':
      ensure  => 'absent',
      require => [
        Elasticsearch::Instance[ $options[instances] ],
        Elasticsearch::Plugin[ $options[plugins] ],
      ],
      before  => Chassis::Wp[ $config['hosts'][0] ],
    }
  }
}
