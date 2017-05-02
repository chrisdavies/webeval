(ns example.handler
  "Asynchronous compojure-api application."
  (:require [compojure.api.sweet :refer :all]
            [ring.util.http-response :refer :all]
            [manifold.deferred :as d]
            [postgres.async :refer :all]
            [clojure.core.async :as async]
            [clojure.java.jdbc :as j]
            [http.async.client :as http]
            compojure.api.async))

(def db (open-db {:hostname "localhost"
                  :port 5432 ; default
                  :database "cgweb_dev"
                  :username "postgres"
                  :password "password"
                  :pool-size 50}))

(def app
  (api
   {:swagger
    {:ui "/"
     :spec "/swagger.json"
     :data {:info {:title "Simple"
                   :description "Compojure Api example"}}}}

   (context "/api" []
     :tags ["api"]

     (GET  "/proxy/" []
       :summary "Proxies to dummy API"
       (fn [_ respond _]
         (with-open [client (http/create-client)]
          (let [response (http/GET client "http://127.0.0.1:8081/?ms=500")]
            (-> response
                http/await
                http/string
                ok
                respond)))))

    (GET "/users/" []
      :summary "Gets a list of users"
      (fn [_ respond _]
        (->> (async/<!! (execute! db ["select id, email from users limit 10"]))
             :rows
             ok
             respond)))

    (GET "/syncusers/" []
      :summary "Gets a list of users (synchronous)"
      (let [db  {:subprotocol "postgresql" :subname "//localhost:5432/cgweb_dev" :user "postgres" :password "password", :pool-size 50}]
       (ok {:result (j/query db ["SELECT u.id, u.email FROM users u LIMIT 10"])})))

    (GET "/test/" []
      :summary "Just a test endpoint"
      :return {:result Long}
      (ok {:result 1})))))
