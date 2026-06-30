curl -X POST http://localhost:8080/products/dispense \
  -H "Content-Type: application/json" \
  -d '{
    "association_id": "61a72d3e-d4f9-4b34-b37a-6b0c26ede728",
    "product_id": "COLE_O_ID_DO_PRODUTO_AQUI",
    "quantity": 2
  }'