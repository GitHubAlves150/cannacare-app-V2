docker exec -i cannacare_postgres psql -U postgres -d cannacare_db -c "
CREATE TABLE IF NOT EXISTS patients (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    association_id UUID NOT NULL,
    name VARCHAR(255) NOT NULL,
    birth_date DATE NOT NULL,
    gender VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(255),
    address TEXT,
    status VARCHAR(50) DEFAULT 'pending_documentation', -- pending_documentation, under_analysis, approved, denied
    created_by UUID NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_patients_association FOREIGN KEY (association_id) REFERENCES associations(id) ON DELETE CASCADE,
    CONSTRAINT fk_patients_creator FOREIGN KEY (created_by) REFERENCES users(id),
    CONSTRAINT uq_association_cpf_placeholder UNIQUE (association_id, email) -- Garante e-mail único por associação
);
"