# Grafana Dashboard Examples for Fuse

- [Fuse Pod Metrics Dashboard](#fuse-pod-metrics-dashboard)
  &mdash; A dashboard that collects metrics from a single Fuse application pod.
  - [fuse-grafana-dashboard.yml](fuse-grafana-dashboard.yml)
- [Fuse Camel Route Metrics Dashboard](#fuse-camel-route-metrics-dashboard)
  &mdash; A dashboard that collects metrics from a single Camel route in a Fuse application.
  - [fuse-grafana-dashboard-routes.yml](fuse-grafana-dashboard-routes.yml)

## Fuse Pod Metrics Dashboard

This dashboard collects metrics from a single Fuse application pod.

![Fuse Pod Metrics](img/fuse-pod-metrics.png)

Here is the table of panels that the Fuse Pod Metrics dashboard includes:

Title | Legend | Query | Description
------|--------|-------|-------------
Process Start Time | - | `process_start_time_seconds{pod="$pod"}*1000` | Time when the process started
Current Memory HEAP | - | `sum(jvm_memory_bytes_used{pod="$pod", area="heap"})*100/sum(jvm_memory_bytes_max{pod="$pod", area="heap"})` | Memory currently being used by Fuse
Memory Usage | committed | `sum(jvm_memory_bytes_committed{pod="$pod"})` | Memory committed
| | used | `sum(jvm_memory_bytes_used{pod="$pod"})` | Memory used
| | max | `sum(jvm_memory_bytes_max{pod="$pod"})` | Maximum memory
Threads | current | `jvm_threads_current{pod="$pod"}` | Number of current threads
| | daemon | `jvm_threads_daemon{pod="$pod"}` | Number of daemon threads
| | peak | `jvm_threads_peak{pod="$pod"}` | Number of peak threads
Camel Exchanges | Exchanges Completed | `sum(org_apache_camel_ExchangesCompleted{pod="$pod"})` | Completed Camel exchanges
| | Exchanges Failed | `sum(org_apache_camel_ExchangesFailed{pod="$pod"})` | Failed Camel exchanges
| | Exchanges Total | `sum(org_apache_camel_ExchangesTotal{pod="$pod"})` | Total Camel exchanges
| | Exchanges Inflight | `sum(org_apache_camel_ExchangesInflight{pod="$pod"})` | Camel exchanges currently being processed
Camel Processing Time | Delta Processing Time | `sum(org_apache_camel_DeltaProcessingTime{pod="$pod"})` | Delta of Camel processing time
| | Last Processing Time | `sum(org_apache_camel_LastProcessingTime{pod="$pod"})` | Last Camel processing time
| | Max Processing Time | `sum(org_apache_camel_MaxProcessingTime{pod="$pod"})` | Maximum Camel processing time
| | Min Processing Time | `sum(org_apache_camel_MinProcessingTime{pod="$pod"})` | Minimum Camel processing time
| | Mean Processing Time | `sum(org_apache_camel_MeanProcessingTime{pod="$pod"})` | Mean Camel processing time
Camel Service Durations | Maximum Duration | `sum(org_apache_camel_MaxDuration{pod="$pod"})` | Maximum Camel service durations
| | Minimum Duration | `sum(org_apache_camel_MinDuration{pod="$pod"})` | Minimum Camel service durations
| | Mean Duration | `sum(org_apache_camel_MeanDuration{pod="$pod"})` | Mean Camel service durations
Camel Failures & Redelivries | Redeliveries | `sum(org_apache_camel_Redeliveries{pod="$pod"})` | Number of redelivries
| | Last Processing Time | `sum(org_apache_camel_LastProcessingTime{pod="$pod"})` | Last Camel processing time
| | External Redeliveries | `sum(org_apache_camel_ExternalRedeliveries{pod="$pod"})` | Number of external redelivries

## Fuse Camel Route Metrics Dashboard

This dashboard collects metrics from a single Camel route in a Fuse application.

![Fuse Camel Route Metrics](img/fuse-camel-route-metrics.png)

Here is the table of panels that the Fuse Camel Route Metrics dashboard includes:

Title | Legend | Query | Description
------|--------|-------|-------------
Exchanges per second | - | `rate(org_apache_camel_ExchangesTotal{route="\"$route\""}[5m])` | Total Camel exchanges per second
Exchanges inflight | - | `max(org_apache_camel_ExchangesInflight{route="\"$route\""})` | Number of Camel exchanges currently being processed
Exchanges failure rate | - | `sum(org_apache_camel_ExchangesFailed{route="\"$route\""}) / sum(org_apache_camel_ExchangesTotal{route="\"$route\""})` | Percentage of failed Camel exchanges
Mean processing time | - | `org_apache_camel_MeanProcessingTime{route="\"$route\""}` | Mean Camel processing time
Exchanges per second | Failed | `rate(org_apache_camel_ExchangesFailed{route="\"$route\""}[5m])` | Failed exchanges per second
| | Completed | `rate(org_apache_camel_ExchangesCompleted{route="\"$route\""}[5m])` | Completed exchanges per second
Exchanges inflight | Exchanges inflight | `org_apache_camel_ExchangesInflight{route="\"$route\""}` | Camel exchanges currently being processed
Processing time | Max | `org_apache_camel_MaxProcessingTime{route="\"$route\""}` | Maximum Camel processing time
| | Mean | `org_apache_camel_MeanProcessingTime{route="\"$route\""}` | Mean Camel processing time
| | Min | `org_apache_camel_MinProcessingTime{route="\"$route\""}` | Minimum Camel processing time
External Redeliveries per second | - | `rate(org_apache_camel_ExternalRedeliveries{route="\"$route\""}[5m])` | External redeliveries per second
Redeliveries per second | - | `rate(org_apache_camel_Redeliveries{route="\"$route\""}[5m])` | Redeliveries per second
Failures handled per second | - | `rate(org_apache_camel_FailuresHandled{route="\"$route\""}[5m])` | Failures handled per second
