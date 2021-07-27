# Cloud Pricing API

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.0.1](https://img.shields.io/badge/AppVersion-v0.0.1-informational?style=flat-square)

A Helm chart for running the Infracost [Cloud Pricing API](https://github.com/infracost/cloud-pricing-api).

## TL;DR

To install the chart with the name `cloud-pricing-api`:

```sh
helm repo add infracost https://infracost.github.io/helm-charts/
helm repo update
# `cat ~/.config/infracost/credentials.yml` or run `infracost register` to create
# a new one. This is used by the weekly job to download the latest cloud pricing DB dump from our service.
helm install cloud-pricing-api infracost/cloud-pricing-api --set job.infracostAPIKey="YOUR_INFRACOST_API_KEY_HERE"
```

Uninstalling the Chart:

```sh
helm uninstall cloud-pricing-api
```

## Configure Infracost to use the self-hosted Cloud Pricing API

The best way to get instructions for configuring Infracost to use the self-hosted Cloud Pricing API is to check the output at the end of the `helm install` step since this contains the exact commands you need to run. If these are not available then instructions are below.

If you don't have ingress enabled you can port-forward the Cloud Pricing API to your local machine by doing this:
```sh
export POD_NAME=$(kubectl get pods --namespace <NAMESPACE> -l "app.kubernetes.io/name=cloud-pricing-api,app.kubernetes.io/instance=cloud-pricing-api" -o jsonpath="{.items[0].metadata.name}")
export CONTAINER_PORT=$(kubectl get pod --namespace <NAMESPACE> $POD_NAME -o jsonpath="{.spec.containers[0].ports[0].containerPort}")
kubectl --namespace <NAMESPACE> port-forward $POD_NAME 8080:$CONTAINER_PORT
```
You can then use `http://localhost:8080` as the `<CLOUD_PRICING_API_ENDPOINT>` below.

You can retrieve the configured static API key using:
```sh
export INFRACOST_API_KEY=$(kubectl get secret --namespace <NAMESPACE> cloud-pricing-api.name --template="{{ index .data \"self-hosted-infracost-api-key\" }}" | base64 -D)
```

To configure Infracost to use the self-hosted Cloud Pricing API you can use:
```sh
export INFRACOST_PRICING_API_ENDPOINT=https://<CLOUD_PRICING_API_ENDPOINT>
export INFRACOST_API_KEY=$INFRACOST_API_KEY
infracost breakdown --path /path/to/code
```

## Prerequisites

* Kubernetes 1.12+ with Beta APIs enabled
* Helm >= 3.1.0
* PV provisioner support in the underlying infrastructure

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.bitnami.com/bitnami | postgresql | 10.x.x |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| api.affinity | object | `{}` | API affinity |
| api.autoscaling.enabled | bool | `false` | Create a HorizontalPodAutoscaler for the API  |
| api.autoscaling.maxReplicas | int | `10` | The maximum replicas for the API autoscaler |
| api.autoscaling.minReplicas | int | `1` | The minimum replicas for the API autoscaler |
| api.autoscaling.targetCPUUtilizationPercentage | int | `80` | The target CPU threshold for the API autoscaler |
| api.disableSelfHostedInfracostAPIKey | bool | `false` |  |
| api.livenessProbe.enabled | bool | `true` | Enable the liveness probe |
| api.livenessProbe.failureThreshold | int | `3` | The liveness probe failure threshold |
| api.livenessProbe.initialDelaySeconds | int | `5` | The liveness probe initial delay seconds |
| api.livenessProbe.periodSeconds | int | `5` | The liveness probe period seconds |
| api.livenessProbe.successThreshold | int | `1` | The liveness probe success threshold |
| api.livenessProbe.timeoutSeconds | int | `2` | The liveness probe timeout seconds |
| api.nodeSelector | object | `{}` | API node selector |
| api.readinessProbe.enabled | bool | `true` | Enable the readiness probe |
| api.readinessProbe.failureThreshold | int | `3` | The readiness probe failure threshold |
| api.readinessProbe.initialDelaySeconds | int | `5` | The readiness probe initial delay seconds |
| api.readinessProbe.periodSeconds | int | `5` | The readiness probe period seconds |
| api.readinessProbe.successThreshold | int | `1` | The readiness probe success threshold |
| api.readinessProbe.timeoutSeconds | int | `2` | The readiness probe timeout seconds |
| api.replicaCount | int | `1` | Replica count |
| api.resources | object | `{}` | API resource limits and requests |
| api.selfHostedInfracostAPIKey | string | `""` | Specify a custom API key for CLIs to authenticate with this Cloud Pricing API. Not setting this will cause the helm chat to generate one for you. |
| api.tolerations | list | `[]` | API tolerations |
| fullnameOverride | string | `""` | Full name override for the deployed app |
| image.pullPolicy | string | `"Always"` | Image pull policy pullPolicy: IfNotPresent |
| image.repository | string | `"infracost/cloud-pricing-api"` | Cloud Pricing API image |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` | Any image pull secrets |
| ingress.annotations | object | `{}` | Ingress annotation |
| ingress.enabled | bool | `false` | Enable the ingress controller resource |
| ingress.hosts[0].host | string | `"cloud-pricing-api.local"` | Host name |
| ingress.hosts[0].paths[0].path | string | `"/"` | Path for host |
| ingress.tls | list | `[]` | TLS configuration |
| job.affinity | object | `{}` | Job affinity |
| job.backoffLimit | int | `6` | Job backoff limit |
| job.failedJobsHistoryLimit | int | `5` | History limit for failed jobs |
| job.infracostAPIKey | string | `""` | Your company Infracost API key that you got from running `infracost register`. This is used to download the weekly pricing DB dump from our official service. |
| job.nodeSelector | object | `{}` | Job node selector |
| job.resources | object | `{}` | Job resource limits and requests |
| job.runInitJob | bool | `true` | Run the job as a one-off on deploy |
| job.schedule | string | `"0 4 * * SUN"` | Job schedule |
| job.startingDeadlineSeconds | int | `3600` | Deadline seconds for the job starting |
| job.successfulJobsHistoryLimit | int | `5` | History limit for successful jobs |
| job.tolerations | list | `[]` | Job tolerations |
| nameOverride | string | `""` | Name override for the deployed app |
| podAnnotations | object | `{}` | Any pod annotations |
| podSecurityContext | object | `{}` | The pod security context |
| postgresql.enabled | bool | `true` | Deploy PostgreSQL servers. See [below](#postgresql) for more details |
| postgresql.postgresqlDatabase | string | `"cloudpricingapi"` |  |
| postgresql.postgresqlUsername | string | `"cloudpricingapi"` | Name of the PostgreSQL user |
| postgresql.usePasswordFile | bool | `false` | Have the secrets mounted as a file instead of env vars |
| securityContext | object | `{}` | The container security context |
| service.port | int | `80` | Kubernetes service port |
| service.type | string | `"ClusterIP"` | Kubernetes service type |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created |
| serviceAccount.name | string | `""` | The name of the service account to use. If not set and create is true, a name is generated using the fullname template |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example:

```sh
helm install cloud-pricing-api infracost/cloud-pricing-api \
  --set api.selfHostedInfracostAPIKey=CUSTOM_API_KEY
```

Alternatively, a YAML file that specifies the values for the above parameters can be provided while installing the chart. For example:

```sh
helm install -f my-values.yaml cloud-pricing-api infracost/cloud-pricing-api
```

## PostgreSQL

By default, PostgreSQL is installed as part of the chart using the [Bitnami PostgreSQL chart](https://github.com/bitnami/charts/blob/master/bitnami/postgresql/README.md). You can specify the values for this chart by prefixing them with `postgresql.`.

To use an external PostgreSQL server set `postgresql.enabled` to `false` and then set the `postgresql.external.*` values.

To avoid issues when upgrading this chart, provide `postgresql.postgresqlPassword` for subsequent upgrades. This is due to an issue in the PostgreSQL chart where password will be overwritten with randomly generated passwords otherwise. See https://github.com/helm/charts/tree/master/stable/postgresql#upgrade for more detail.

## Examples

### Install in AWS with ALB ingress

This is how the Infracost team deploys the Cloud Pricing API on our EKS cluster to test it.

```sh
export DOMAIN=cloud-pricing.api.dev.infracost.io
export CERTIFICATE_DOMAIN=*.api.dev.infracost.io
export CERTIFICATE_ARN=$(aws acm list-certificates --query 'CertificateSummaryList[].[CertificateArn,DomainName]' --output text | grep ${CERTIFICATE_DOMAIN} | cut -f1)

helm install cloud-pricing-api infracost/cloud-pricing-api \
  --set ingress.enabled=true \
  --set ingress.hosts\[0\].host=${DOMAIN} \
  --set ingress.hosts\[0\].paths\[0\].path=/\* \
  --set ingress.extraPaths\[0\].path=/\* \
  --set ingress.extraPaths\[0\].backend.serviceName=ssl-redirect \
  --set ingress.extraPaths\[0\].backend.servicePort=use-annotation \
  --set ingress.annotations."kubernetes\.io/ingress\.class"=alb \
  --set ingress.annotations."alb\.ingress\.kubernetes\.io/scheme"=internet-facing \
  --set ingress.annotations."alb\.ingress\.kubernetes\.io/target-type"=ip \
  --set ingress.annotations."alb\.ingress\.kubernetes\.io/certificate-arn"=${CERTIFICATE_ARN} \
  --set ingress.annotations."alb\.ingress\.kubernetes\.io/healthcheck-path"=/health
  --set-string ingress.annotations."alb\.ingress\.kubernetes\.io/listen-ports"="\[\{\"HTTP\": 80\}\, \{\"HTTPS\":443\}\]" \
  --set-string ingress.annotations."alb\.ingress\.kubernetes\.io/ssl-redirect"="\{\"Type\": \"redirect\"\, \"RedirectConfig\": \{ \"Protocol\": \"HTTPS\"\, \"Port\": \"443\"\, \"StatusCode\": \"HTTP_301\"\}\}"
```

## Development

To install the chart from your local repository with the name `my-release`:

```sh
helm install my-release .
```

To uninstall `my-release` deployment:

```sh
helm uninstall my-release
```

To debug issues, such as `job-cron.yaml: error converting YAML to JSON: yaml: line X`, use the following:

```sh
helm template cloud-pricing-api charts/cloud-pricing-api/ --debug > out.yaml
cat out.yaml # look for issues in the YAML in the erroring resource
```
