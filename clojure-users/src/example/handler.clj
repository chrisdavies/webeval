(ns example.handler
  "Asynchronous compojure-api application."
  (:require [compojure.api.sweet :refer :all]
            [ring.util.http-response :refer :all]
            [manifold.deferred :as d]
            [postgres.async :refer :all]
            [clojure.core.async :as async]
            [clojure.java.jdbc :as j]
            compojure.api.async))

(def db (open-db {:hostname "localhost"
                  :port 5432 ; default
                  :database "cgweb_dev"
                  :username "postgres"
                  :password "password"
                  :pool-size 50})) ; default

(def app
  (api
   {:swagger
    {:ui "/"
     :spec "/swagger.json"
     :data {:info {:title "Simple"
                   :description "Compojure Api example"}
            :tags [{:name "api", :description "some apis"}]}}}

   (context "/api" []
     :tags ["api"]

     (GET "/users" []
       :summary "Gets a list of users"
       (ok (async/<!! (execute! db ["select id, email from users limit 10"]))))

    (GET "/syncusers" []
      :summary "Gets a list of users (synchronous)"
      (let [db  {:subprotocol "postgresql" :subname "//localhost:5432/cgweb_dev" :user "postgres" :password "password"}]
       (ok {:result (j/query db ["SELECT u.id, u.email FROM users u LIMIT 10"])})))

    (GET "/test" []
     :summary "Just a test endpoint"
     :return {:result Long}
     (ok {:result 1})))))
