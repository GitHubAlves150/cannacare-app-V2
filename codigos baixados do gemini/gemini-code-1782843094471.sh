curl -X POST http://localhost:8080/products \
  -H "Content-Type: application/json" \
  -d '{
    "association_id": "61a72d3e-d4f9-4b34-b37a-6b0c26ede728",
    "name": "Óleo CBD Full Spectrum 30ml",
    "description": "Concentração de 50mg/ml",
    "quantity": 10,
    "price_cents": 15000
  }'