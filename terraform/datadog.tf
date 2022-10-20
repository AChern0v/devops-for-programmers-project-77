resource "datadog_monitor" "check" {
  name    = "Grafana status"
  type    = "service check"
  message = "[FIRING] {{host.name}} not respond!"
  query   = "\"http.can_connect\".over(\"instance:grafana_status\").by(\"host\",\"instance\",\"url\").last(5).count_by_status()"
}
