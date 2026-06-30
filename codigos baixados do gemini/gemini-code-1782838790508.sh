curl -X POST http://localhost:8080/users \
  -H "Content-Type: application/json" \
  -d '{
    "association_id": "61a72d3e-d4f9-4b34-b37a-6b0c26ede728",
    "name": "Lucas Alves",
    "email": "lucas@email.com",
    "password": "senha_segura_123",
    "role": "admin"
  }'