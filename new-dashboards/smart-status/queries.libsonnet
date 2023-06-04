local grafonnet = import 'github.com/grafana/grafonnet/gen/grafonnet-v9.4.0/main.libsonnet';

local prometheusQuery = grafonnet.query.prometheus;

{
  disksMonitored:
    prometheusQuery.new('$datasource', 'sum(smartmon_device_active{cluster=~"$cluster", namespace=~"$namespace", host="$host"})')
    + prometheusQuery.withFormat('time_series')
    + prometheusQuery.withInstant(true)
    + prometheusQuery.withIntervalFactor(null),

  unhealthyDisks:
    prometheusQuery.new('$datasource', 'sum(smartmon_device_smart_enabled{cluster=~"$cluster", namespace=~"$namespace", host="$host"})-sum(smartmon_device_smart_healthy{cluster=~"$cluster", namespace=~"$namespace", host="$host"})')
    + prometheusQuery.withFormat('time_series')
    + prometheusQuery.withInstant(true)
    + prometheusQuery.withIntervalFactor(null),

  diskDrives:
    prometheusQuery.new('$datasource', 'smartmon_device_info{cluster=~"$cluster", namespace=~"$namespace", host="$host"}')
    + prometheusQuery.withFormat('table')
    + prometheusQuery.withInstant(true)
    + prometheusQuery.withIntervalFactor(null),

  temperatureHistory:
    prometheusQuery.new('$datasource', 'smartmon_attr_raw_value{cluster=~"$cluster", namespace=~"$namespace", host="$host", name="temperature_celsius"}')
    + prometheusQuery.withFormat('time_series')
    + prometheusQuery.withLegendFormat('{{device}} {{disk}}'),

  powerOnHours:
    prometheusQuery.new('$datasource', 'smartmon_attr_raw_value{cluster=~"$cluster", namespace=~"$namespace", host="$host", name="power_on_hours"}')
    + prometheusQuery.withLegendFormat('{{device}} {{disk}}')
    + prometheusQuery.withInstant(true)
    + prometheusQuery.withIntervalFactor(null)
}
