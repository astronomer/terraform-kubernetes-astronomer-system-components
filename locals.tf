locals {
  istio_local_gateway_helm_set_list = {
    "gateways.custom-gateway.autoscaleMin"                 = "1"
    "gateways.custom-gateway.autoscaleMax"                 = "1"
    "gateways.custom-gateway.cpu.targetAverageUtilization" = "60"
    "gateways.custom-gateway.labels.app"                   = "cluster-local-gateway"
    "gateways.custom-gateway.labels.istio"                 = "cluster-local-gateway"
    "gateways.custom-gateway.type"                         = "ClusterIP"
    "gateways.istio-egressgateway.enabled"                 = "false"
    "gateways.istio-ilbgateway.enabled"                    = "false"
  }

  istio_local_gateway_helm_values = <<EOF
---
# Common settings.
global:
  istioNamespace: istio-system
  proxy:
    # Sets the destination Statsd in envoy (the value of the "--statsdUdpAddress" proxy argument
    # would be <host>:<port>).
    # Disabled by default.
    # The istio-statsd-prom-bridge is deprecated and should not be used moving forward.
    envoyStatsd:
      # If enabled is set to true, host and port must also be provided. Istio no longer provides a statsd collector.
      enabled: false
      host: # example: statsd-svc.istio-system
      port: # example: 9125
#
# Gateways Configuration
# By default (if enabled) a pair of Ingress and Egress Gateways will be created for the mesh.
# You can add more gateways in addition to the defaults but make sure those are uniquely named
# and that NodePorts are not conflicting.
# Disable specific gateway by setting the `enabled` to false.
#
gateways:
  enabled: true
  cluster-local-gateway:
    enabled: true
    labels:
      app: cluster-local-gateway
    replicaCount: 1
    autoscaleMin: 1
    autoscaleMax: 5
    resources: {}
      # limits:
      #  cpu: 100m
      #  memory: 128Mi
      #requests:
      #  cpu: 1800m
      #  memory: 256Mi
    cpu:
      targetAverageUtilization: 80
    loadBalancerIP: ""
    loadBalancerSourceRanges: {}
    externalIPs: []
    serviceAnnotations: {}
    podAnnotations: {}
    type: LoadBalancer #change to NodePort, ClusterIP or LoadBalancer if need be
    #externalTrafficPolicy: Local #change to Local to preserve source IP or Cluster for default behaviour or leave commented out
    ports:
      ## You can add custom gateway ports
    - port: 80
      targetPort: 80
      name: http2
      # nodePort: 31380
    - port: 443
      name: https
      # nodePort: 31390
    - port: 31400
      name: tcp
      # nodePort: 31400
    # Pilot and Citadel MTLS ports are enabled in gateway - but will only redirect
    # to pilot/citadel if global.meshExpansion settings are enabled.
    - port: 15011
      targetPort: 15011
      name: tcp-pilot-grpc-tls
    - port: 8060
      targetPort: 8060
      name: tcp-citadel-grpc-tls
    # Addon ports for kiali are enabled in gateway - but will only redirect if
    # the gateway configuration for the various components are enabled.
    - port: 15029
      targetPort: 15029
      name: http2-kiali
    # Telemetry-related ports are enabled in gateway - but will only redirect if
    # the gateway configuration for the various components are enabled.
    - port: 15030
      targetPort: 15030
      name: http2-prometheus
    - port: 15031
      targetPort: 15031
      name: http2-grafana
    - port: 15032
      targetPort: 15032
      name: http2-tracing
    secretVolumes:
    - name: clusterlocalgateway-certs
      secretName: istio-clusterlocalgateway-certs
      mountPath: /etc/istio/clusterlocalgateway-certs
    - name: clusterlocalgateway-ca-certs
      secretName: istio-clusterlocalgateway-ca-certs
      mountPath: /etc/istio/clusterlocalgateway-ca-certs
EOF
}
