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

Go is hella fast (10K requests per second), and really simple. Simple to set up. Simple to code. But it's also hella ugly. I may write a second go app using some ORMish tool and some web APIish tool that hopefully would reduce boilerplate, and would almost certainly reduce performance.

.NET's best-case performed surprisingly well, considering I was using a full ORM (EF Core). But it did have pretty bad standard deviations, raning from 3500 reqs/sec down to the low 200s. Some runs produced *19 second* max request times, presumably due to GC. In general, though, the runs seemed to hover around the mid 2K requests per second. With Dapper, a micro ORM, this improved up to the low-to-mid 3K requests per second.

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

.NET (Entity Framework)

    Requests per second:    2584.93 [#/sec] (mean)
                min  mean[+/-sd] median   max
    Connect:        0    2   4.9      0      38
    Processing:     4   36  10.8     33      86
    Waiting:        4   35  10.5     33      83
    Total:          8   38  10.3     35      91

.NET (Dapper (A micro ORM))

    Requests per second:    3263.32 [#/sec] (mean)
                min  mean[+/-sd] median   max
    Connect:        0    9   8.6      9      89
    Processing:     3   21  12.2     19     102
    Waiting:        3   18  10.4     16      92
    Total:          9   30  12.9     29     113


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


.NET Core (Entity Framework)

    Server Software:        Kestrel
    Server Hostname:        localhost
    Server Port:            5000

    Document Path:          /api/users
    Document Length:        392 bytes

    Concurrency Level:      100
    Time taken for tests:   1.934 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      2655000 bytes
    HTML transferred:       1960000 bytes
    Requests per second:    2584.93 [#/sec] (mean)
    Time per request:       38.686 [ms] (mean)
    Time per request:       0.387 [ms] (mean, across all concurrent requests)
    Transfer rate:          1340.43 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    2   4.9      0      38
    Processing:     4   36  10.8     33      86
    Waiting:        4   35  10.5     33      83
    Total:          8   38  10.3     35      91

    Percentage of the requests served within a certain time (ms)
    50%     35
    66%     38
    75%     43
    80%     46
    90%     53
    95%     58
    98%     73
    99%     75
    100%     91 (longest request)


.NET Core (Dapper)

    Server Software:        Kestrel
    Server Hostname:        localhost
    Server Port:            5000

    Document Path:          /api/usersdapp
    Document Length:        512 bytes

    Concurrency Level:      100
    Time taken for tests:   1.532 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      3255000 bytes
    HTML transferred:       2560000 bytes
    Requests per second:    3263.32 [#/sec] (mean)
    Time per request:       30.644 [ms] (mean)
    Time per request:       0.306 [ms] (mean, across all concurrent requests)
    Transfer rate:          2074.63 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    9   8.6      9      89
    Processing:     3   21  12.2     19     102
    Waiting:        3   18  10.4     16      92
    Total:          9   30  12.9     29     113

    Percentage of the requests served within a certain time (ms)
    50%     29
    66%     31
    75%     32
    80%     33
    90%     37
    95%     48
    98%     69
    99%    104
    100%    113 (longest request)