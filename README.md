# Chassis Elasticsearch

Adds an [ElasticSearch](https://www.elastic.co/) server to your
[Chassis](https://github.com/Chassis/Chassis) box.

## Installation

Via `config.yaml`:

You can add this repo name under the `extensions` section of your config file.

```yaml
extensions:
  chassis/chassis_elasticsearch
```

Via git:

```
cd path/to/chassis/extensions
git clone --recursive git@github.com:Chassis/Chassis_Elasticsearch.git chassis_elasticsearch
```

Then reprovision your machine:
```
vagrant provision
```

## Usage

Once the machine has finished provisioning you can access ElasticSearch at
`http://<host>:9200/` or from within the VM at `http://localhost:9200/`.

The extension also provides two PHP constants in your `local-config.php`:

```php
ELASTICSEARCH_HOST // defaults to localhost
ELASTICSEARCH_PORT // defaults to 9200
```

We recommend using the [Head Chrome Extension](https://chrome.google.com/webstore/detail/elasticsearch-head/ffmkiejjmecolpfloofpjologoblkegm/) for debugging queries and exploring
your indexes.

## Configuration

Chassis ElasticSearch provides some default options you can override from your
config file(s).

```yaml
elasticsearch:
  repo_version: '5.x'
  version: '5.5.3'
  plugins:
    - 'analysis-icu'
  host: '0.0.0.0'
  port: 9200
  timeout: 10
  instances:
    - 'es'
  jvm_options:
    # You may want to increase the memory limits here if you are indexing images & files.
    # Note you may also need to increase the memory limits for the VM and PHP also.
    - '-Xms256m'
    - '-Xmx256m'
```

#### Debugging Elasticsearch

If you're having trouble with Elasticsearch there are a few common commands you can run inside Vagrant.

1. First you need to `vagrant ssh`.
2. To check the status of Elasticsearch run: `sudo service elasticsearch-es status`.
3. To stop Elasticsearch run: `sudo service elasticsearch-es stop`
4. To start Elasticsearch run: `sudo service elasticsearch-es start`

Version and plugins are the only ones you'll likely want to change.

## About

License: GPLv3

This extension was made with ❤️ by [Human Made](https://hmn.md/)
