# Chassis Elasticsearch

Adds an [ElasticSearch](https://www.elastic.co/) server to your
[Chassis](https://github.com/Chassis/Chassis) box.

## Installation

Via `config.yaml`:

You can add this repo name under the `extensions` section of your config file.

```yaml
extensions:
  chassis/chassis-elasticsearch
```

Via git:

```
cd path/to/chassis/extensions
git clone --recursive git@github.com:Chassis/Chassis-Elasticsearch.git
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
  version: '5.x'
  plugins:
    - 'analysis-icu'
  host: '0.0.0.0'
  port: 9200
  timeout: 10
  instances:
    - 'es'
```

Version and plugins are the only ones you'll likely want to change.

## About

License: GPLv3

This extension was made with ❤️ by [Human Made](https://hmn.md/)
