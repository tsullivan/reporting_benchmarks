FROM docker.elastic.co/beats/metricbeat:8.1.0-SNAPSHOT
COPY metricbeat.docker.yml /usr/share/metricbeat/metricbeat.yml
USER root
RUN chown root:root /usr/share/metricbeat/metricbeat.yml
RUN chmod go-w /usr/share/metricbeat/metricbeat.yml
USER metricbeat
