(defproject example "0.1.0-SNAPSHOT"
  :description "FIXME: write description"
  :dependencies [[org.clojure/clojure "1.8.0"]
                 [metosin/compojure-api "1.2.0-alpha5"]
                 [ring "1.6.0-RC3"]
                 [compojure "1.6.0-beta3"]
                 [manifold "0.1.6"]
                 [org.clojure/core.async "0.3.442"]
                 [alaisi/postgres.async "0.8.0"]
                 [org.clojure/java.jdbc "0.7.0-alpha3"]
                 [org.postgresql/postgresql "9.4.1212.jre7"]]
  :ring {:handler example.handler/app
         :async? true}
  :uberjar-name "server.jar"
  :profiles {:dev {:plugins [[lein-ring "0.11.0"]]}})
