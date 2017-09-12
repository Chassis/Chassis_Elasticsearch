class chassis-elasticsearch(
  $config
) {

  # Install Elasticsearch
  class { 'elasticsearch':
    java_install      => true,
    manage_repo       => true,
    repo_version      => '5.x',
    restart_on_change => true,
    api_protocol      => 'http',
    api_host          => 'localhost',
    api_port          => 9200,
    api_timeout       => 10,
    validate_tls      => false,
  }

  # Create an instance
  elasticsearch::instance { 'es': }

  # ICU
  elasticsearch::plugin { 'analysis-icu':
    instances => 'es',
  }

}
