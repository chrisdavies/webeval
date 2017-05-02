package main

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"net/http"
	"runtime"

	"github.com/jackc/pgx"
	"github.com/julienschmidt/httprouter"
)

var db *pgx.ConnPool

type User struct {
	ID    int    `json:"id"`
	Email string `json:"email"`
}

func main() {
	http.DefaultTransport.(*http.Transport).MaxIdleConnsPerHost = 200
	runtime.GOMAXPROCS(runtime.NumCPU())

	db = initDatabase()

	initServer()
}

func usersHandler(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	rows, err := db.Query("select id, email from users limit 10")

	if err != nil {
		log.Fatalf("Error selecting db data: %v", err)
	}
	defer rows.Close()

	users := make([]User, 0, 10)

	for rows.Next() {
		var u User
		err := rows.Scan(&u.ID, &u.Email)
		if err != nil {
			log.Fatalf("Error reading row: %v", err)
		}
		users = append(users, u)
	}

	jsonMarshal(w, users)
}

func jsonMarshal(w http.ResponseWriter, v interface{}) {
	w.Header().Set("Content-Type", "application/json")

	if err := json.NewEncoder(w).Encode(v); err != nil {
		log.Fatalf("error in json.Encoder.Encode: %s", err)
	}
}

func proxyHandler(w http.ResponseWriter, r *http.Request, _ httprouter.Params) {
	resp, err := http.Get("http://127.0.0.1:8081/?ms=500")
	if err != nil {
		log.Printf("error proxying: %s\n", err)
		w.WriteHeader(http.StatusInternalServerError)
		w.Write([]byte("Connection reset!"))
		return
	}
	defer resp.Body.Close()
	body, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		log.Fatalf("error in json.Encoder.Encode: %s", err)
	}
	w.Write(body)
}

func initServer() {
	router := httprouter.New()
	router.GET("/api/users/", usersHandler)
	router.GET("/api/proxy/", proxyHandler)

	log.Fatal(http.ListenAndServe(":3000", router))
}

func initDatabase() *pgx.ConnPool {
	var config pgx.ConnPoolConfig

	config.Host = "localhost"
	config.User = "postgres"
	config.Password = "password"
	config.Database = "cgweb_dev"
	config.Port = 5432
	config.MaxConnections = runtime.NumCPU() * 2

	connPool, err := pgx.NewConnPool(config)
	if err != nil {
		log.Fatalf("DB connection failed: \n ", err)
	}

	return connPool, err
}
