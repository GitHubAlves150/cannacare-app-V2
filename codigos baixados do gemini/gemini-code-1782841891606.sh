curl -X POST http://localhost:8080/prescriptions \
  -H "Content-Type: application/json" \
  -d '{
    "association_id": "61a72d3e-d4f9-4b34-b37a-6b0c26ede728",
    "patient_id": "086b81b5-5ae4-4d13-b37a-6b0c26ede728",
    "doctor_name": "Dra. Maria Clara",
    "doctor_crm": "CRM/SP 123456",
    "issue_date": "2023-01-10T00:00:00Z",
    "expiry_date": "2023-07-10T00:00:00Z",
    "description": "Óleo CBD Full Spectrum - 30ml"
  }'