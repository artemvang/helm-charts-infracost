{{/*
Expand the name of the chart.
*/}}
{{- define "cloud-pricing-api.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloud-pricing-api.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "cloud-pricing-api.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "cloud-pricing-api.labels" -}}
helm.sh/chart: {{ include "cloud-pricing-api.chart" . }}
{{ include "cloud-pricing-api.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cloud-pricing-api.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloud-pricing-api.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cloud-pricing-api.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cloud-pricing-api.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified app name for the postgreSQL instance
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloud-pricing-api.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Get PostgreSQL host
*/}}
{{- define "cloud-pricing-api.postgresql.host" -}}
{{ .Values.postgresql.host }}
{{- end -}}

{{/*
Get PostgreSQL port
*/}}
{{- define "cloud-pricing-api.postgresql.port" -}}
{{ .Values.postgresql.port | quote }}
{{- end -}}

{{/*
Get PostgreSQL database
*/}}
{{- define "cloud-pricing-api.postgresql.database" -}}
{{ .Values.postgresql.database }}
{{- end -}}

{{/*
Get PostgreSQL user
*/}}
{{- define "cloud-pricing-api.postgresql.user" -}}
{{ .Values.postgresql.user }}
{{- end -}}

{{/*
Get the PostgreSQL secret name
*/}}
{{- define "cloud-pricing-api.postgresql.secretName" -}}
{{- printf "%s" (include "cloud-pricing-api.fullname" .) -}}
{{- end -}}
