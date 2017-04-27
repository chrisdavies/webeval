# Results

These were run on the following machine:

    MacBook Pro (Retina, 13-inch, Mid 2014)
    2.6 GHz Intel Core i5
    8 GB 1600 MHz DDR3


## Notes

Occasionally with the more performant services, Apache Bench would just fail midway through with a `apr_socket_recv: Connection reset by peer (54)`. As far as I can tell, there were no errors in the services when this happened. I'm not sure if this is a bug in AB, or something finnicky with the connectivity on my machine.


## Preliminary (and probably premature) analysis

The Clojure synchronous code is stable and performs consistently (but poorly).

The Clojure async code is significantly faster. It generally performs in the mid 3K requests per second. Very occasionally, I observed a *really* slow (1.5 seconds) request.

Go is hella fast, and really simple. Simple to set up. Simple to code. But it's also hella ugly. I may write a second go app using some ORMish tool and some web APIish tool that hopefully would reduce boilerplate, and would almost certainly reduce performance.


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

Go

    Requests per second:   10421.03 [#/sec] (mean)
                min  mean[+/-sd] median   max
    Connect:        1    5   0.9      4       8
    Processing:     1    5   1.0      5      10
    Waiting:        0    4   1.0      4       8
    Total:          5    9   1.3      9      14


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

Go

    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /api/users
    Document Length:        46 bytes

    Concurrency Level:      100
    Time taken for tests:   0.480 seconds
    Complete requests:      5000
    Failed requests:        0
    Non-2xx responses:      5000
    Total transferred:      1000000 bytes
    HTML transferred:       230000 bytes
    Requests per second:    10421.03 [#/sec] (mean)
    Time per request:       9.596 [ms] (mean)
    Time per request:       0.096 [ms] (mean, across all concurrent requests)
    Transfer rate:          2035.36 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        1    5   0.9      4       8
    Processing:     1    5   1.0      5      10
    Waiting:        0    4   1.0      4       8
    Total:          5    9   1.3      9      14
    WARNING: The median and mean for the initial connection time are not within a normal deviation
            These results are probably not that reliable.

    Percentage of the requests served within a certain time (ms)
    50%      9
    66%     10
    75%     10
    80%     11
    90%     11
    95%     12
    98%     13
    99%     13
    100%     14 (longest request)