cat > internal/infrastructure/repository/prescription_repository_postgres.go << 'EOF'
package repository

import (
	"database/sql"
	"GitHubAlves150/cannacare-app-V2/cannacare/internal/domain/prescription"
)

type PrescriptionRepositoryPostgres struct {
	db *sql.DB
}

func NewPrescriptionRepositoryPostgres(db *sql.DB) *PrescriptionRepositoryPostgres {
	return &PrescriptionRepositoryPostgres{db: db}
}

// Create grava a receita médica vinculada ao ID do paciente
func (r *PrescriptionRepositoryPostgres) Create(p *prescription.Prescription) error {
	query := `
		INSERT INTO prescriptions (patient_id, doctor_name, doctor_crm, issue_date, expiry_date, description, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8)
		RETURNING id`

	err := r.db.QueryRow(
		query,
		p.PatientID,
		p.DoctorName,
		p.DoctorCRM,
		p.IssueDate,
		p.ExpiryDate,
		p.Description,
		p.CreatedAt,
		p.UpdatedAt,
	).Scan(&p.ID)

	return err
}

// FindByPatientID varre o banco e traz todas as receitas associadas àquele paciente
func (r *PrescriptionRepositoryPostgres) FindByPatientID(patientID string) ([]*prescription.Prescription, error) {
	query := `SELECT id, patient_id, doctor_name, doctor_crm, issue_date, expiry_date, description, created_at, updated_at 
	          FROM prescriptions WHERE patient_id = $1 ORDER BY expiry_date DESC`

	rows, err := r.db.Query(query, patientID)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var list []*prescription.Prescription

	// O rows.Next() funciona como um loop while, varrendo linha por linha retornada pelo banco
	for rows.Next() {
		var p prescription.Prescription
		err := rows.Scan(&p.ID, &p.PatientID, &p.DoctorName, &p.DoctorCRM, &p.IssueDate, &p.ExpiryDate, &p.Description, &p.CreatedAt, &p.UpdatedAt)
		if err != nil {
			return nil, err
		}
		list = append(list, &p)
	}

	return list, nil
}
EOF