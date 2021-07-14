# Infracost Helm Charts

<a href="https://www.infracost.io/community-chat"><img alt="Community Slack channel" src="https://img.shields.io/badge/chat-Slack-%234a154b"/></a>

**Note: This is under active development so is not ready to be used yet**

This repository contains Helm charts for:
 * [Cloud Pricing API](https://github.com/infracost/cloud-pricing-api):

    ```sh
    helm repo add infracost https://infracost.github.io/helm-charts/
    helm repo update
    helm install cloud-pricing-api infracost/cloud-pricing-api
    ```

    For full details of options and see the [Cloud Pricing API chart README](https://github.com/infracost/helm-charts/blob/master/charts/cloud-pricing-api/README.md).

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
