docker exec -i cannacare_postgres psql -U postgres -d cannacare_db -c "
CREATE TABLE IF NOT EXISTS products (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    association_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    quantity INT NOT NULL DEFAULT 0,
    price_cents INT NOT NULL, -- Guardamos em centavos (ex: R$ 150,00 vira 15000) para evitar problemas com floats
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_products_association FOREIGN KEY (association_id) REFERENCES associations(id) ON DELETE CASCADE
);
"