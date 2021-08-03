# Release

[@alikhajeh1](https://github.com/alikhajeh1) and [@aliscott](https://github.com/aliscott) rotate release responsibilities between them.

1. As needed, update the `version` and `appVersion` in Chart.yaml
2. Generate the chart docs using:
  ```sh
  brew install norwoodj/tap/helm-docs
  helm-docs
  ```

The docs for each chart are generated automatically from the README.md.gotmpl files in each chart using the `# --` comments within the chart.

When changes are pushed to master there is a GitHub action that checks if the version is bumped and if so:
  * Creates a new release
  * Pushes the release to https://infracost.github.io/helm-charts
