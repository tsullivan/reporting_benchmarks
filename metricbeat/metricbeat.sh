set -o verbose

cd /vagrant/metricbeat

# build metricbeat with custom config
docker build -t reporting-benchmarks-metricbeat /vagrant/metricbeat

# setup
docker run --network=host reporting-benchmarks-metricbeat \
  setup -E setup.kibana.host=kibana:5601 \
  -E output.elasticsearch.hosts=["elasticsearch:9200"] \
  -E output.elasticsearch.username=elastic \
  -E output.elasticsearch.password=changeme

# run
# add -d for to run in background
docker run -d --network=host \
  --name=metricbeat \
  --user=root \
  --volume="/var/run/docker.sock:/var/run/docker.sock:ro" \
  --volume="/sys/fs/cgroup:/hostfs/sys/fs/cgroup:ro" \
  --volume="/proc:/hostfs/proc:ro" \
  --volume="/:/hostfs:ro" \
  reporting-benchmarks-metricbeat metricbeat -e \
  -E output.elasticsearch.hosts=["elasticsearch:9200"]  
