{{/* vim: set filetype=mustache: */}}

{{/*
Expand the name of the chart.
*/}}
{{- define "zigbee2mqtt.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Expands image name.
*/}}
{{- define "zigbee2mqtt.image" -}}
{{- $tag := default .Chart.AppVersion .Values.image.tag -}}
{{- printf "%s:%s" .Values.image.repository $tag -}}
{{- end -}}

{{/*
The standart k8s probe used for redinessProbe and livenessProbe
zigbee2mqtt.probe is http get request
*/}}
{{- define "zigbee2mqtt.probe" -}}
httpGet:
  path: /
  port: {{ .Values.service.internalPort }}
initialDelaySeconds: 5
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "zigbee2mqtt.fullname" -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
labels.standard prints the standard Helm labels.
The standard labels are frequently used in metadata.
*/}}
{{- define "zigbee2mqtt.labels.standard" -}}
app: {{ template "zigbee2mqtt.name" . }}
heritage: {{ .Release.Service | quote }}
release: {{ .Release.Name | quote }}
chart: {{ template "zigbee2mqtt.chartref" . }}
{{- end -}}

{{/*
chartref prints a chart name and version.
It does minimal escaping for use in Kubernetes labels.
*/}}
{{- define "zigbee2mqtt.chartref" -}}
  {{- replace "+" "_" .Chart.Version | printf "%s-%s" .Chart.Name -}}
{{- end -}}

{{/*
Templates in zigbee2mqtt.utils namespace are help functions.
*/}}

{{/*
zigbee2mqtt.utils.tls functions makes host-tls from host name
usage: {{ "www.example.com" | zigbee2mqtt.utils.tls }}
output: www-example-com-tls
*/}}
{{- define "zigbee2mqtt.utils.tls" -}}
{{- $host := index . | replace "." "-" -}}
{{- printf "%s-tls" $host -}}
{{- end -}}
