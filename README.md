# Infracost Helm Charts

<a href="https://www.infracost.io/community-chat"><img alt="Community Slack channel" src="https://img.shields.io/badge/chat-Slack-%234a154b"/></a>

**Note: This is under active development so is not ready to be used yet**

This repository contains Helm charts for:
  * [Cloud Pricing API](https://github.com/infracost/cloud-pricing-api):

    ```sh
    helm repo add infracost https://infracost.github.io/helm-charts/
    helm repo update
    # `cat ~/.config/infracost/credentials.yml` or run `infracost register` to create
    # a new one. This is used by the weekly job to download the latest cloud pricing data from our service.
    helm install cloud-pricing-api infracost/cloud-pricing-api --set job.infracostAPIKey="YOUR_INFRACOST_API_KEY_HERE"
    ```

    For full details of options and see the [Cloud Pricing API chart README](https://github.com/infracost/helm-charts/blob/master/charts/cloud-pricing-api/README.md).

## Contributing

Issues and pull requests are welcome! For development details, see the [contributing](CONTRIBUTING.md) guide. For major changes, please open an issue first to discuss what you would like to change. [Join our community Slack channel](https://www.infracost.io/community-chat), we are a friendly bunch and happy to help you get started :)

We're also looking for [Sr Full Stack Engineer](https://www.infracost.io/join-the-team) to join our team.

## License

[Apache License 2.0](https://choosealicense.com/licenses/apache-2.0/)
