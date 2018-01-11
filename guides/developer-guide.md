# RIG Developer Guide

TODO getting started

Our conventions are documented in [`guides/architecture/decisions/`](guides/architecture/decisions/). See [0001-record-architecture-decisions.md](guides/architecture/decisions/0001-record-architecture-decisions.md) for more details.

## Project Layout

Since 2.0, RIG uses the [umbrella project layout](https://elixir-lang.org/getting-started/mix-otp/dependencies-and-umbrella-apps.html#umbrella-projects), in order to make the code an easier read and adding/removing features simple. The following table should give you an idea how the code is organized:

Path | Umbrella App | What's in there
---- | ------------ | ---------------
`apps/rig_api` | `:rig_api` | The internal API, built as a Phoenix app. The actual code triggered by a call to this API would typically be implemented in another umbrella app (for example, see `RigApi.MessageController`, which uses `RigOutboundGateway.send/1` underneath).
`apps/rig_inbound_gateway` | `:rig_inbound_gateway` | The externally facing HTTP server, built as a Phoenix app. It includes the reverse proxy, which forwards requests to back-end services as configured, as well as the Phoenix transports (e.g., WebSocket and SSE endpoints). Other responsibilities include connection-related things like managing and enforcing the JWT blacklist, and rate limiting would also go in here.
`apps/rig_outbound_gateway` | `:rig_outbound_gateway` | Messages that are to be distributed to connected front-ends go through the outbound gateway. Even handlers in other apps (e.g., `:rig_api`) use the outbound-gateway's `send/1` to deliver messages.
`apps/rig` | `:rig` | Cross-cutting helpers, like `Rig.Config`.
`apps/rig_mesh` | `:rig_mesh` | Owns the Phoenix PubSub server. (Communication) services used by multiple umbrella apps would go in there.
`apps/rig_auth` | `:rig_auth` | Code concerned with handling JWTs (or authentication, in general).

While all apps share the same config, the convention is to put an app's config in its own config file and use the umbrella config file only for things that concern multiple apps.

Indeed, there are even more apps on our backlog:

Path | Umbrella App | What's in there
---- | ------------ | ---------------
`apps/rig_admin_frontend` | `:rig_admin_frontend` | An admin UI (again, a Phoenix app). For displaying and changing RIG's internal state, only `:rig_api` will be used. Ideas what could be offered: data about front-end connections, connections to other RIG nodes, message throughput, ..
`apps/rig_monitor` | `:rig_monitor` | Provides statistics to external monitoring applications like Prometheus, relying on `:rig_api` to gather the data.