# Results

These were run on the following machine:

    MacBook Pro (Retina, 13-inch, Mid 2014)
    2.6 GHz Intel Core i5
    8 GB 1600 MHz DDR3

## Notes

The Clojure synchronous code is stable and performs consistently (but poorly).

The Clojure async code is significantly faster, but seems to deliver inconsistent results. It generally performs in the mid 3K requests per second. However, occasionally (every few runs) Apache Bench would just fail midway through with a `apr_socket_recv: Connection reset by peer (54)`. There were no errors in the Clojure console when this happened, and the server was still running. Very occasionally, I observed a *really* slow (1.5 seconds) request.

## Summary

Clojure (users), async postgres test

    Requests per second:    3569.53 [#/sec] (mean)
                  min  mean[+/-sd] median   max
    Connect:        0    2   4.5      0      26
    Processing:     4   26  12.5     24     116
    Waiting:        3   25  12.7     24     114
    Total:          9   28  11.9     25     116

Clojure (syncusers), synchronous postgres test

    Requests per second:    301.42 [#/sec] (mean)
                min  mean[+/-sd] median   max
    Connect:        0    1   1.0      0      30
    Processing:   192  329 127.2    318    1278
    Waiting:      192  329 127.1    317    1274
    Total:        192  329 127.3    318    1278


## Raw

Clojure (users)

    Server Software:        Jetty(9.2.z-SNAPSHOT)
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /api/users
    Document Length:        413 bytes

    Concurrency Level:      100
    Time taken for tests:   1.401 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      2735000 bytes
    HTML transferred:       2065000 bytes
    Requests per second:    3569.53 [#/sec] (mean)
    Time per request:       28.015 [ms] (mean)
    Time per request:       0.280 [ms] (mean, across all concurrent requests)
    Transfer rate:          1906.77 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    2   4.5      0      26
    Processing:     4   26  12.5     24     116
    Waiting:        3   25  12.7     24     114
    Total:          9   28  11.9     25     116

    Percentage of the requests served within a certain time (ms)
      50%     25
      66%     27
      75%     28
      80%     30
      90%     34
      95%     38
      98%     46
      99%    105
    100%    116 (longest request)

Clojure (syncusers)

    Server Software:        Jetty(9.2.z-SNAPSHOT)
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /api/syncusers
    Document Length:        403 bytes

    Concurrency Level:      100
    Time taken for tests:   16.588 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      2685000 bytes
    HTML transferred:       2015000 bytes
    Requests per second:    301.42 [#/sec] (mean)
    Time per request:       331.766 [ms] (mean)
    Time per request:       3.318 [ms] (mean, across all concurrent requests)
    Transfer rate:          158.07 [Kbytes/sec] received

    Connection Times (ms)
                  min  mean[+/-sd] median   max
    Connect:        0    1   1.0      0      30
    Processing:   192  329 127.2    318    1278
    Waiting:      192  329 127.1    317    1274
    Total:        192  329 127.3    318    1278
    WARNING: The median and mean for the initial connection time are not within a normal deviation
            These results are probably not that reliable.

    Percentage of the requests served within a certain time (ms)
      50%    318
      66%    326
      75%    331
      80%    333
      90%    349
      95%    422
      98%   1063
      99%   1120
      100%   1278 (longest request)