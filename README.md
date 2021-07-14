# Infracost Helm Charts

<a href="https://www.infracost.io/community-chat"><img alt="Community Slack channel" src="https://img.shields.io/badge/chat-Slack-%234a154b"/></a>

**Note: This is under active development so is not ready to be used yet**

This repository contains Helm charts for:
 * [Cloud Pricing API](https://github.com/infracost/helm-charts/blob/master/charts/cloud-pricing-api/README.md):

    ```sh
    helm repo add infracost https://infracost.github.io/helm-charts/
    helm repo update
    helm install cloud-pricing-api infracost/cloud-pricing-api
    ```

    For full details of options and see the [Cloud Pricing API chart README](https://github.com/infracost/helm-charts/blob/master/charts/cloud-pricing-api/README.md).

## Examples

### Install in AWS with ALB ingress

This is how the Infracost team deploys the Cloud Pricing API on our EKS cluster to test it.

```sh
export MONGODB_URI=mongodb://pricing-api-mongo:27017/pricing # TODO: Remove when we switch fully to PostgreSQL
export DOMAIN=cloud-pricing.api.dev.infracost.io
export CERTIFICATE_DOMAIN=*.api.dev.infracost.io
export CERTIFICATE_ARN=$(aws acm list-certificates --query 'CertificateSummaryList[].[CertificateArn,DomainName]' --output text | grep ${CERTIFICATE_DOMAIN} | cut -f1)

helm install cloud-pricing-api infracost/cloud-pricing-api \
  --set mongoDBURI=${MONGODB_URI} \
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
  --set-string ingress.annotations."alb\.ingress\.kubernetes\.io/listen-ports"="\[\{\"HTTP\": 80\}\, \{\"HTTPS\":443\}\]" \
  --set-string ingress.annotations."alb\.ingress\.kubernetes\.io/ssl-redirect"="\{\"Type\": \"redirect\"\, \"RedirectConfig\": \{ \"Protocol\": \"HTTPS\"\, \"Port\": \"443\"\, \"StatusCode\": \"HTTP_301\"\}\}"
```

## Release

Before releasing a new version of a chart, generate the chart docs using:

```sh
brew install norwoodj/tap/helm-docs
helm-docs
```

The docs for each chart generated automatically from the README.md.gotmpl files in each chart using the `# --` comments within the chart.

When changes are pushed to master there is a GitHub action that checks if the version is bumped and if so:
 * Creates a new release
 * Pushes the release to https://infracost.github.io/helm-charts
