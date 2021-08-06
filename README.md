# Chassis Elasticsearch

Adds an [ElasticSearch](https://www.elastic.co/) server to your
[Chassis](https://github.com/Chassis/Chassis) box.

## 🚨 Breaking Changes 🚨

The Elasticsearch puppet module no longer supports multiple instances and there is no migration path to the new set up. You may need to back up your database, destroy the machine and recreate for it to provision successfully.

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

### Custom Dictionary Files

Elasticsearch supports using text files for providing stopwords, synonyms and if using the `analysis-kuromoji` plugin a custom user dictionary file for tokenisation.

This extension ensures there is a directory at `/usr/share/elasticsearch/config` that is writable by the web server.

To reference files added to that location you can use a relative path with the `config/` prefix. For example you could create an analyser using a custom stopwords file in the following way:

```json
{
  "analysis": {
    "filter": {
      "custom_stopwords": {
        "type": "stop",
        "stopwords_path": "config/stopwords.txt"
      }
    },
    "analyzer": {
      "default": {
        "type": "custom",
        "filter": [
          "custom_stopwords"
        ],
        "tokenizer": "standard"
      }
    }
  }
}
```

## Configuration

Chassis ElasticSearch provides some default options you can override from your
config file(s).

```yaml
elasticsearch:
  repo_version: '7'
  version: '7.10.2'
  plugins:
    - 'analysis-icu'
  host: '0.0.0.0'
  port: 9200
  timeout: 60
  # You may want to increase the memory limit here if you are indexing images & files.
  # Note you may also need to increase the memory limits for the VM and PHP also.
  # Value is in Megabytes.
  memory: 256
  # You can override the default JVM options here as an array. For more information
  # see the docs at https://www.elastic.co/guide/en/elasticsearch/reference/master/jvm-options.html
  jvm_options:
    # Alternative way to configure the memory heap size settings at a more granular level.
    - '-Xms256m'
    - '-Xmx256m'
```

### A note on memory usage

If you do increase the memory available to Elasticsearch you should generally ensure the VM itself has double that amount of memory to ensure all extensions and services run smoothly.

The below example gives Elasticsearch 1Gig of memory and increases the VM memory to 2Gig.

```yaml
elasticsearch:
  memory: 1024

virtualbox:
  memory: 2048
```

### Debugging Elasticsearch

If you're having trouble with Elasticsearch there are a few common commands you can run inside Vagrant.

1. First you need to `vagrant ssh`.
2. To check the status of Elasticsearch run: `sudo service elasticsearch-es status`.
3. To stop Elasticsearch run: `sudo service elasticsearch-es stop`
4. To start Elasticsearch run: `sudo service elasticsearch-es start`

Version and plugins are the only ones you'll likely want to change.

## About

License: GPLv3

This extension was made with ❤️ by [Human Made](https://hmn.md/)
