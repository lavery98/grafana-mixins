local util = import '../dashboard-utils.libsonnet';
local grafonnet = import '../g.libsonnet';

local queries = import './queries.libsonnet';

local dashboard = grafonnet.dashboard;
local stat = grafonnet.panel.stat;
local timeSeries = grafonnet.panel.timeSeries;

{
  'dnsmasq-overview.json': (
    util.dashboard('Dnsmasq Overview', tags=['generated', 'dnsmasq'])
    + util.addMultiVariable('cluster', 'dnsmasq_exporter_build_info', 'cluster')
    + util.addMultiVariable('namespace', 'dnsmasq_exporter_build_info{cluster=~"$cluster"}', 'namespace')
    + dashboard.withPanels(
      util.makeGrid([
        util.stat.base('Upstream Queries', queries.upstreamQueriesIncrease),
        util.stat.base('Failed Upstream Queries', queries.failedUpstreamQueriesIncrease),
        util.stat.base('Percentage of Failed Upstream Queries', queries.failedUpstreamQueriesPercent)
        + {
          options+: {
            reduceOptions+: {
              calcs: [],
            },
          },
        }
        + stat.options.reduceOptions.withCalcs([
          'mean',
        ])
        + stat.standardOptions.withUnit('percentunit'),

        // New row
        util.timeSeries.base('Upstream Queries', queries.upstreamQueriesRate)
        + timeSeries.options.legend.withShowLegend(false),
        util.timeSeries.base('Failed Upstream Queries', queries.failedUpstreamQueriesRate)
        + timeSeries.options.legend.withShowLegend(false),

        // New row
        util.timeSeries.base('Cache Hits', queries.cacheHits)
        + timeSeries.options.legend.withShowLegend(false),
        util.timeSeries.base('Cache Misses', queries.cacheMisses)
        + timeSeries.options.legend.withShowLegend(false),
      ])
    )
  ),
}
