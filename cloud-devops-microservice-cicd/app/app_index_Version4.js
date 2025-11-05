// Node.js Express microservice: /health and /metrics endpoints for ECS/Prometheus.

const express = require('express');
const promClient = require('prom-client');
const app = express();
const port = process.env.PORT || 3000;

// Prometheus Registry and Metrics
const register = new promClient.Registry();
const httpRequestCounter = new promClient.Counter({
  name: 'http_requests_total',
  help: 'Total HTTP requests',
  labelNames: ['method']
});
register.registerMetric(httpRequestCounter);
const httpRequestDuration = new promClient.Histogram({
  name: 'http_request_duration_seconds',
  help: 'Duration of HTTP requests in seconds',
  buckets: [0.1, 0.5, 1, 2, 5]
});
register.registerMetric(httpRequestDuration);

// Metrics Middleware
app.use((req, res, next) => {
  httpRequestCounter.inc({ method: req.method });
  const end = httpRequestDuration.startTimer();
  res.on('finish', end);
  next();
});

// Health Check
app.get('/health', (req, res) => {
  res.json({ status: 'UP' });
});

// Prometheus Metrics
app.get('/metrics', async (req, res) => {
  res.set('Content-Type', register.contentType);
  res.end(await register.metrics());
});

app.get('/', (req, res) => res.send('Microservice running!'));

app.listen(port, () => console.log(`Server listening on ${port}`));