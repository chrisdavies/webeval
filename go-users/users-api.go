package main

import (
	"database/sql"
	"encoding/json"
	"log"
	"net/http"

	_ "github.com/lib/pq"
)

var connStr = "user=postgres password=password dbname=cgweb_dev sslmode=disable"

type Customer struct {
	ID    int    `json:"id"`
	Email string `json:"email"`
}

func usersHandler(w http.ResponseWriter, r *http.Request) {
	var v struct {
		Data []Customer `json:"data"`
	}
	db, err := sql.Open("postgres", connStr)
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()
	rows, err := db.Query("SELECT id, email FROM users LIMIT 10")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()
	for rows.Next() {
		// Scan one customer record
		var c Customer
		if err := rows.Scan(&c.ID, &c.Email); err != nil {
			log.Fatal(err)
		}
		v.Data = append(v.Data, c)
	}
	if rows.Err() != nil {
		log.Fatal(err)
	}
	p, err := json.Marshal(v)
	if err != nil {
		log.Fatal(err)
	}
	w.Write(p)
}

func main() {
	http.HandleFunc("/api/users/", usersHandler)
	http.ListenAndServe(":3000", nil)
}
