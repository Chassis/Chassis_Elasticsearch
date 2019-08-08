# A Class to create an Elasticsearch instance.
class instance(
  $name = 'es1',
  $host = '127.0.0.1',
  $port = 9200,
) {

  elasticsearch::instance { $name: }

}
