
# Problems or at least statements of reality

* Dealing w/ alerting on build/decom seems to be a consistently painful and inconsistent
* Most companies don’t leverage PagerDuty’s services as services, they do Service = ( Team | Urgency for a Team | Alert Channel for a Team)
Really, many barely leverage PagerDuty except as a scheduler+pager (which… normal, but very expensive).
Very little in Pagerduty seems to be terraformized.
Most companies don’t have a lot of encouraged shareable best practices around using PagerDuty, its very much "there is our tool

 (and it seems like our integration is actually rather weak? i’m talkin
@bgoleno
about this)
High level thoughts
Manage PagerDuty more programmatically (read: terraform)
Specifically services and event rules
These can be exposed as modules but also maybe we can make it so people don’t even need to use the modules directly, its just part of the build
Arguably even GC or treasuremap could be utilized for this
Represent our architecture in PagerDuty (and also New Relic) rather than representing teams, specifically by utilizing PagerDuty’s basic Technical and Business Services model.
App/Tech service = ${cell}_${appstack}_${application} (appstack preferably should not == org/team names but.. someone will do it)
Business services that define dependencies with other Business and Tech Services to show:
A tier (test,staging,perf,prod) Test Environment US Production (Which, mixing
A cell test-odd-wire
An app stack for a cell: ${tier} Kafka Platform
A Feature: ${tier} - Feature - ${feature} ie: Test - Feature - Ingest
In general I’d prefer that  tier get left off the last 2, but simplified data model, ya know?
But now that is a lot of services defined in PagerDuty. How does the data get to the right places?
Each Appstack can create a Event Ruleset in Pagerduty. This acts as a single “entry” point to pagerduty that they would configure as a notification channel in New Relic. Example in PagerDuty
Then as part of setting up each new tech service on cell build, a rule gets added to that Event Ruleset with whatever is appropriately usable metadata in the alert to route the notification to the right Tech Service.
This may take some tuning and also recommended practices to teams, but we can probably come up with a decent rule set that would work for most and “do it for them” like above as well.
But wait.. what about associations w/ escalation policies and such?
Teams can keep managing those as they do, they just need to provide the right name/id of the escalation policy for the service creation steps.
Challenges
Adoption, but the more of this that is centrally built and managed the easier that is
Metadata and tuning for routing event rules - apparently we are all over the place here.. but that is in itself a problem we should be addressing
nrrdbot and herobot et al rely on Tech services, not escalation policies
1: can still have a fall through Tech Service (their existing one) that the bots and EventRuleset can use to fall back on
2: Just change them to support escalation policies instead ?
Adding dependencies in PagerDuty Business Services ( although, arguably this could be generated from datanerd.yml or grandcentral and managed separately)
Benefits
Can disable an entire cell (or just a single service in the cell) from paging without impacting other cells!
The dependency mapping becomes a thing visible in the Service Graph in PagerDuty, that will also show “status” and support Subscribing to services you care about, but also for when something is having issues in our own stack.
Better reporting in PagerDuty (although NrAiIncidents being exposed makes this way better already)