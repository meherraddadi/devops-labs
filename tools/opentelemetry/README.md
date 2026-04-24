# OpenTelemetry — Observabilité unifiée

## C'est quoi ?

OpenTelemetry (OTel) est le standard CNCF pour collecter **traces, métriques et logs** avec un seul SDK et protocole (OTLP). Remplace les SDKs propriétaires Jaeger, Zipkin, Datadog. Tes apps instrumented avec OTel peuvent envoyer vers n'importe quel backend.

## Type d'installation

Docker Compose (Collector + Jaeger pour visualisation)

## Démarrage

```bash
cd ~/dev/devops-labs/tools/opentelemetry
docker compose up -d

# Vérifier que le collector est healthy
curl http://localhost:13133/

# Jaeger UI → http://localhost:16686
```

## Tester avec une trace manuelle

```bash
# Envoyer une trace de test via curl (OTLP HTTP)
curl -X POST http://localhost:4318/v1/traces \
  -H "Content-Type: application/json" \
  -d '{
    "resourceSpans": [{
      "resource": {"attributes": [{"key": "service.name", "value": {"stringValue": "test-service"}}]},
      "scopeSpans": [{
        "spans": [{
          "traceId": "5b8efff798038103d269b633813fc60c",
          "spanId": "eee19b7ec3c1b174",
          "name": "test-operation",
          "startTimeUnixNano": "1544712660000000000",
          "endTimeUnixNano": "1544712661000000000",
          "kind": 1
        }]
      }]
    }]
  }'
```

## Instrumenter une app Python

```bash
pip install opentelemetry-distro opentelemetry-exporter-otlp

# Auto-instrumentation (Flask, Django, FastAPI, requests...)
opentelemetry-bootstrap -a install

OTEL_SERVICE_NAME=mon-api \
OTEL_EXPORTER_OTLP_ENDPOINT=http://localhost:4318 \
opentelemetry-instrument python app.py
```

## URLs

- Jaeger UI : http://localhost:16686
- OTLP gRPC : localhost:4317
- OTLP HTTP : localhost:4318
- Collector health : http://localhost:13133
