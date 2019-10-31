locals {
  istio_local_gateway_helm_values = <<EOF
---
gateways:
  cluster-local-gateway:
    autoscaleMax: 5
    autoscaleMin: 1
    cpu:
      targetAverageUtilization: 80
    enabled: true
    externalIPs: []
    labels:
      app: cluster-local-gateway
    loadBalancerIP: ""
    loadBalancerSourceRanges: {}
    podAnnotations: {}
    ports:
    - name: http2
      port: 80
      targetPort: 80
    - name: https
      port: 443
    - name: tcp
      port: 31400
    - name: tcp-pilot-grpc-tls
      port: 15011
      targetPort: 15011
    - name: tcp-citadel-grpc-tls
      port: 8060
      targetPort: 8060
    - name: http2-kiali
      port: 15029
      targetPort: 15029
    - name: http2-prometheus
      port: 15030
      targetPort: 15030
    - name: http2-grafana
      port: 15031
      targetPort: 15031
    - name: http2-tracing
      port: 15032
      targetPort: 15032
    replicaCount: 1
    resources: {}
    secretVolumes:
    - mountPath: /etc/istio/clusterlocalgateway-certs
      name: clusterlocalgateway-certs
      secretName: istio-clusterlocalgateway-certs
    - mountPath: /etc/istio/clusterlocalgateway-ca-certs
      name: clusterlocalgateway-ca-certs
      secretName: istio-clusterlocalgateway-ca-certs
    serviceAnnotations: {}
    type: LoadBalancer
  custom-gateway:
    autoscaleMax: 1
    autoscaleMin: 1
    cpu:
      targetAverageUtilization: 60
    labels:
      app: cluster-local-gateway
      istio: cluster-local-gateway
    type: ClusterIP
  enabled: true
  istio-egressgateway:
    enabled: false
  istio-ilbgateway:
    enabled: false
global:
  istioNamespace: istio-system
  proxy:
    envoyStatsd:
      enabled: false
      host: null
      port: null
EOF
}
