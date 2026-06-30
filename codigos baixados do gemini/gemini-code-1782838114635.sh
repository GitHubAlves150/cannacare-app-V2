curl -X POST http://localhost:8080/patients \
  -H "Content-Type: application/json" \
  -d '{
    "association_id": "61a72d3e-d4f9-4b34-b37a-6b0c26ede728",
    "name": "Paciente de Teste Maciel",
    "birth_date": "1995-04-10T00:00:00Z",
    "gender": "Masculino",
    "phone": "(11) 98888-7777",
    "email": "paciente@email.com",
    "address": "Rua das Flores, 123 - São Paulo",
    "created_by": "61a72d3e-d4f9-4b34-b37a-6b0c26ede728"
  }'