docker run --network=host \
  docker.elastic.co/beats/metricbeat:7.16.3 \
  setup -E setup.kibana.host=kibana:5601 \
  -E output.elasticsearch.hosts=["elasticsearch:9200"] \
  -E output.elasticsearch.username=elastic \
  -E output.elasticsearch.password=changeme
