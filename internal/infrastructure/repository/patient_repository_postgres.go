package repository

import (
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/patient"
	"database/sql"
	"errors"
)

type PatientRepositoryPostgres struct {
	db *sql.DB
}

func NewPatientRepositoryPostgres(db *sql.DB) *PatientRepositoryPostgres {
	return &PatientRepositoryPostgres{db: db}
}

// Create insere o paciente no banco de dados e captura o ID gerado pelo Postgres
func (r *PatientRepositoryPostgres) Create(p *patient.Patient) error {
	query := `
		INSERT INTO patients (association_id, name, birth_date, gender, phone, email, address, status, created_by, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)
		RETURNING id`

	err := r.db.QueryRow(
		query,
		p.AssociationID,
		p.Name,
		p.BirthDate,
		p.Gender,
		p.Phone,
		p.Email,
		p.Address,
		p.Status,
		p.CreatedBy,
		p.CreatedAt,
		p.UpdatedAt,
	).Scan(&p.ID)

	return err
}

// FindByID busca um paciente garantindo que ele pertença à associação solicitante
func (r *PatientRepositoryPostgres) FindByID(associationID, id string) (*patient.Patient, error) {
	query := `SELECT id, association_id, name, birth_date, gender, phone, email, address, status, created_by, created_at, updated_at 
	          FROM patients WHERE association_id = $1 AND id = $2`

	row := r.db.QueryRow(query, associationID, id)

	var p patient.Patient
	err := row.Scan(&p.ID, &p.AssociationID, &p.Name, &p.BirthDate, &p.Gender, &p.Phone, &p.Email, &p.Address, &p.Status, &p.CreatedBy, &p.CreatedAt, &p.UpdatedAt)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, errors.New("paciente não encontrado nesta associação")
		}
		return nil, err
	}

	return &p, nil
}

// FindByEmail busca um paciente por e-mail dentro do escopo de uma associação específica
func (r *PatientRepositoryPostgres) FindByEmail(associationID, email string) (*patient.Patient, error) {
	query := `SELECT id, association_id, name, birth_date, gender, phone, email, address, status, created_by, created_at, updated_at 
	          FROM patients WHERE association_id = $1 AND email = $2`

	row := r.db.QueryRow(query, associationID, email)

	var p patient.Patient
	err := row.Scan(&p.ID, &p.AssociationID, &p.Name, &p.BirthDate, &p.Gender, &p.Phone, &p.Email, &p.Address, &p.Status, &p.CreatedBy, &p.CreatedAt, &p.UpdatedAt)
	if err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return nil, nil // Retorna nil se o e-mail estiver vago para esta associação
		}
		return nil, err
	}

	return &p, nil
}
