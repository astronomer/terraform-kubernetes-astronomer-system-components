locals {
  istio_local_gateway_helm_values = <<EOF
---
gateways:
  cluster-local-gateway:
    enabled: true
    autoscaleMax: 1
    autoscaleMin: 1
    cpu:
      targetAverageUtilization: 60
    enabled: true
    labels:
      app: cluster-local-gateway
      istio: cluster-local-gateway
    ports:
      - name: status-port
        port: 15020
      - name: http2
        port: 80
        targetPort: 8080
      - name: https
        port: 443
    type: ClusterIP
  enabled: true
  istio-egressgateway:
    enabled: false
  istio-ilbgateway:
    enabled: false
  istio-ingressgateway:
    enabled: false
EOF
}
