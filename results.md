# Results

These were run on the following machine:

    MacBook Pro (Retina, 13-inch, Mid 2014)
    2.6 GHz Intel Core i5
    8 GB 1600 MHz DDR3

Apache Bench is not a great tool, but I don't know of a better one. I noticed it often would fail to finish a test run due to connection issues. I saw some bad std deviations (particularly with .NET and Clojure), which may have been due to the GC, but seemed to be due rather to Apache Bench being fickle.


## Preliminary (and probably premature) analysis

Go is fast and simple, as promised, and its resource utilization (especially memory) is stellar.

Clojure is pretty capable for such an expressive, dynamic language with 1st class support for immutability. Its resource utilization is terrible, though. The JVM loves RAM the way I love chocolate cake. And I suspect that Clojure's expressiveness and immutability is what causes it to consume extra CPU.

.NET's SQL performed surprisingly well, considering it was using a full ORM (EF Core). In general, the runs seemed to hover around the mid 2K requests per second. With Dapper, a micro ORM, this improved up to the low-to-mid 3K requests per second. .NET fell over when doing 400 concurrent requests to a sluggish API. In this case, .NET pegged my CPU and just crapped out. Not sure what the underlying issue is, there.

Node was super simple to set up. Its perf, however, was surprisingly sub-par.

Phoenix feels Railsey which in my book is not a good thing. However, for being a full-fledged framework, it performs well. It hovered around the mid 3K requests per second. This is the only platform that logged extensivley when run (a reasonable default). So, to be fair to Phoenix, I disabled logging. This bumped the perf up by a few hundred requests per second. Elixir's resource utilization was not as good as I expected. I just assumed it would use almost nothing, as the BEAM was designed for old hardware.

Rails is the worst performer of the group, coming in at around 300 requests per second. This is unsurprising and a little unfair to Rails, as I didn't do any extra configuration to get it to take advantage of all my CPU cores, so if it is like Node in this regard, this would partly explain its poor perf.

Python Japronto is supposed to be blazing fast. It was unimpressive in the SQL test, but fared well in the web-service proxy test. In the SQL test, it is faster than Rails, but slower than everything else. I suspect the Postgres driver is either not great, is synchronous under the hood, or else doesn't automatically use connection pooling, but I'm not sure. Any advice is appreciated (or better yet, pull requests!).


## Perf Summaries

### Performance (Postgres)

- Go 5366.29 [#/sec] (mean), 7.5 std dev
- Clojure 3760.26 [#/sec] (mean), 5.1 std dev
- Elixir 3305.47 [#/sec] (mean), 11.0 std dev
- C# EF 2525.39 [#/sec] (mean), 9.7 std dev
- Node 2223.32 [#/sec] (mean), 14.8 std dev
- Python 389.44 [#/sec] (mean), 50.8 std dev
- Rails 343.73 [#/sec] (mean), 20.7 std dev


### Performance (API Call)

- Go 196.99 [#/sec] (mean), time per: 507.638 [ms] (mean), 3.0 std dev
- C# 194.33 [#/sec] (mean), 514.595 [ms] (mean), 10.8 std dev
- Clojure 194.40 [#/sec] (mean), 514.401 [ms] (mean), 13.4 std dev
- Elixir 194.13 [#/sec] (mean), time per: 515.129 [ms] (mean), 6.2 std dev
- Python 176.89 [#/sec] (mean), 565.313 [ms] (mean), 25.7 std dev
- Node 186.03 [#/sec] (mean), 537.540 [ms] (mean), 18.3 std dev
- Rails 9.79 [#/sec] (mean), 10209.735 [ms] (mean), 1238.1 std dev


### Resource utilization (Postgres)

- Go          - CPU: 19%, RAM: 6.7 MB
- Python      - CPU: 38%, RAM: ~40 MB
- Elixir      - CPU: 70%, RAM: ~70 MB
- Rails5      - CPU: 39.3%, RAM: 98 MB
- .NET Core   - CPU: 89%, RAM: ~170 MB
- Node        - CPU: 116%, RAM: 272 MB (4 cores at ~25%)
- Clojure     - CPU: 100%, RAM: ~700 MB


### Resource utilization (Proxy)

- Go          - CPU: 5%, RAM: 35 MB
- Python      - CPU: 15%, RAM: ~40 MB
- Rails5      - CPU: 3.4%, RAM: 90 MB (climbed steadily)
- Node        - CPU: 15%, RAM: ~100 MB
- Elixir      - CPU: 38-56%, RAM: ~100 MB
- .NET Core   - CPU: 60%, RAM: 170 MB
- Clojure     - CPU: 50%, RAM: 850 MB


## Raw results

### Postgres Query

In this test, we are running a simple Postgres query, and returning the results (a list of 10 user objects) as JSON.

    ab -c 100 -n 5000 http://127.0.0.1:3000/api/users/

Clojure (async db connection)

    Server Software:        Jetty(9.2.z-SNAPSHOT)
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/users/
    Document Length:        392 bytes

    Concurrency Level:      100
    Time taken for tests:   1.330 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      2630000 bytes
    HTML transferred:       1960000 bytes
    Requests per second:    3760.26 [#/sec] (mean)
    Time per request:       26.594 [ms] (mean)
    Time per request:       0.266 [ms] (mean, across all concurrent requests)
    Transfer rate:          1931.54 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    1   1.2      0      16
    Processing:     6   26   5.4     25      53
    Waiting:        5   25   5.2     25      48
    Total:         10   26   5.1     25      55

    Percentage of the requests served within a certain time (ms)
    50%     25
    66%     27
    75%     28
    80%     29
    90%     33
    95%     37
    98%     41
    99%     44
    100%    55 (longest request)


Clojure (synchronous db connection)

    Server Software:        Jetty(9.2.z-SNAPSHOT)
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/syncusers/
    Document Length:        403 bytes

    Concurrency Level:      100
    Time taken for tests:   16.656 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      2685000 bytes
    HTML transferred:       2015000 bytes
    Requests per second:    300.19 [#/sec] (mean)
    Time per request:       333.126 [ms] (mean)
    Time per request:       3.331 [ms] (mean, across all concurrent requests)
    Transfer rate:          157.42 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    1   0.9      0      23
    Processing:    85  330 224.0    263    1516
    Waiting:       84  329 224.3    262    1515
    Total:         91  331 223.9    263    1516
    WARNING: The median and mean for the initial connection time are not within a normal deviation
            These results are probably not that reliable.

    Percentage of the requests served within a certain time (ms)
    50%    263
    66%    277
    75%    292
    80%    313
    90%    659
    95%    829
    98%   1394
    99%   1417
    100%   1516 (longest request)

C# (ASP Core + Entity Framework)

    Server Software:        Kestrel
    Server Hostname:        localhost
    Server Port:            5000

    Document Path:          /api/users/
    Document Length:        392 bytes

    Concurrency Level:      100
    Time taken for tests:   1.980 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      2655000 bytes
    HTML transferred:       1960000 bytes
    Requests per second:    2525.39 [#/sec] (mean)
    Time per request:       39.598 [ms] (mean)
    Time per request:       0.396 [ms] (mean, across all concurrent requests)
    Transfer rate:          1309.55 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    3   6.4      0      36
    Processing:     5   37  11.1     35      97
    Waiting:        4   36  11.3     35      96
    Total:         13   39   9.7     36      97

    Percentage of the requests served within a certain time (ms)
    50%     36
    66%     41
    75%     44
    80%     45
    90%     48
    95%     51
    98%     71
    99%     90
    100%     97 (longest request)

C# (ASP Core + Dapper Micro ORM)

    Server Software:        Kestrel
    Server Hostname:        localhost
    Server Port:            5000

    Document Path:          /api/usersdapp/
    Document Length:        512 bytes

    Concurrency Level:      100
    Time taken for tests:   1.485 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      3255000 bytes
    HTML transferred:       2560000 bytes
    Requests per second:    3366.51 [#/sec] (mean)
    Time per request:       29.704 [ms] (mean)
    Time per request:       0.297 [ms] (mean, across all concurrent requests)
    Transfer rate:          2140.23 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    7   8.4      5     113
    Processing:     1   22  15.4     20     131
    Waiting:        1   19  14.0     18     118
    Total:          6   30  15.4     27     133

    Percentage of the requests served within a certain time (ms)
    50%     27
    66%     30
    75%     32
    80%     33
    90%     38
    95%     44
    98%     72
    99%    124
    100%    133 (longest request)

Elixir (Phoeinx)

    Server Software:        Cowboy
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/users/
    Document Length:        392 bytes

    Concurrency Level:      100
    Time taken for tests:   1.513 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      3635000 bytes
    HTML transferred:       1960000 bytes
    Requests per second:    3305.47 [#/sec] (mean)
    Time per request:       30.253 [ms] (mean)
    Time per request:       0.303 [ms] (mean, across all concurrent requests)
    Transfer rate:          2346.75 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    0   1.9      0      73
    Processing:     5   30  10.9     27     114
    Waiting:        4   29  10.6     27     111
    Total:          7   30  11.0     28     114

    Percentage of the requests served within a certain time (ms)
    50%     28
    66%     30
    75%     32
    80%     34
    90%     38
    95%     41
    98%     78
    99%     95
    100%    114 (longest request)


Go

    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /api/users/
    Document Length:        393 bytes

    Concurrency Level:      200
    Time taken for tests:   0.932 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      2510000 bytes
    HTML transferred:       1965000 bytes
    Requests per second:    5366.29 [#/sec] (mean)
    Time per request:       37.270 [ms] (mean)
    Time per request:       0.186 [ms] (mean, across all concurrent requests)
    Transfer rate:          2630.74 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    9   6.1      7      30
    Processing:     1   28   8.9     29      68
    Waiting:        1   23   8.8     25      58
    Total:          2   37   7.5     36      77

    Percentage of the requests served within a certain time (ms)
    50%     36
    66%     38
    75%     39
    80%     41
    90%     44
    95%     46
    98%     51
    99%     61
    100%    77 (longest request)

JavaScript (Node + Express)

    Server Software:
    Server Hostname:        localhost
    Server Port:            3000

    Document Path:          /api/users/
    Document Length:        392 bytes

    Concurrency Level:      100
    Time taken for tests:   2.249 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      3005000 bytes
    HTML transferred:       1960000 bytes
    Requests per second:    2223.32 [#/sec] (mean)
    Time per request:       44.978 [ms] (mean)
    Time per request:       0.450 [ms] (mean, across all concurrent requests)
    Transfer rate:          1304.90 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    0   0.5      0       6
    Processing:    12   44  14.8     40     210
    Waiting:       11   44  14.8     40     210
    Total:         12   44  14.8     41     210

    Percentage of the requests served within a certain time (ms)
    50%     41
    66%     44
    75%     48
    80%     50
    90%     55
    95%     67
    98%     83
    99%    100
    100%    210 (longest request)

Python3 (Japronto)

    Server Software:
    Server Hostname:        127.0.0.1
    Server Port:            8080

    Document Path:          /api/users
    Document Length:        431 bytes

    Concurrency Level:      100
    Time taken for tests:   12.839 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      2590000 bytes
    HTML transferred:       2155000 bytes
    Requests per second:    389.44 [#/sec] (mean)
    Time per request:       256.781 [ms] (mean)
    Time per request:       2.568 [ms] (mean, across all concurrent requests)
    Transfer rate:          197.00 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    0   0.9      0       9
    Processing:    35  255  50.8    252     465
    Waiting:       35  248  49.6    244     460
    Total:         39  256  50.8    252     465

    Percentage of the requests served within a certain time (ms)
    50%    252
    66%    269
    75%    280
    80%    289
    90%    328
    95%    343
    98%    368
    99%    395
    100%    465 (longest request)

Ruby (Rails 5)

    Server Software:
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/users
    Document Length:        392 bytes

    Concurrency Level:      100
    Time taken for tests:   14.546 seconds
    Complete requests:      5000
    Failed requests:        0
    Total transferred:      3610000 bytes
    HTML transferred:       1960000 bytes
    Requests per second:    343.73 [#/sec] (mean)
    Time per request:       290.924 [ms] (mean)
    Time per request:       2.909 [ms] (mean, across all concurrent requests)
    Transfer rate:          242.36 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    0   0.6      0       7
    Processing:    78  288  20.7    287     444
    Waiting:       75  287  20.7    286     444
    Total:         84  288  20.7    287     450

    Percentage of the requests served within a certain time (ms)
    50%    287
    66%    292
    75%    294
    80%    296
    90%    302
    95%    318
    98%    333
    99%    350
    100%    450 (longest request)

### Slow (500ms) API query

In this test, we are basically proxying a call to a slow (500ms per request) API. The idea here is to test how these various platforms will perform when they inevitably have to call out to a 3rd party API (like Stripe) that will be slower than a DB connection (though hopefully not 500ms slow!).

The idea is that requests *should* be close to 500ms per request. If a system is much over that, it's not handling concurrent IO very well. I had to hack my mac to allow more open connections because the more optimal platforms were overwheliming my laptop.

Go was the best performer, with Elixir and .NET coming in close behind. Node faired fairly well, but had a larger standard deviation than expected. Python's async IO does really well here, not as well as the others, but good enough! Clojure faired about half as well as the top stacks. I'm not sure why. And Rails, unsurprisingly faired poorly. This test is rigged against Rails, since I think it is possible to do async requests in Rails, however, in real-world codebases I have never seen this done. The default is to use standard, synchronous calls both to the DB and to third-party services like Stripe.


#### Slow IO results

    ab -c 400 -n 2000 http://127.0.0.1:3000/api/proxy/

Go

    CPU: 5%, RAM: 35 MB

    Server Software:
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      100
    Time taken for tests:   10.153 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      274000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    196.99 [#/sec] (mean)
    Time per request:       507.638 [ms] (mean)
    Time per request:       5.076 [ms] (mean, across all concurrent requests)
    Transfer rate:          26.36 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    1   0.8      1       6
    Processing:   500  506   2.8    506     514
    Waiting:      500  506   2.7    505     514
    Total:        501  507   3.0    507     519

    Percentage of the requests served within a certain time (ms)
    50%    507
    66%    508
    75%    509
    80%    509
    90%    511
    95%    512
    98%    514
    99%    515
    100%    519 (longest request)


Elixir

    CPU: 38-56%, RAM: ~100 MB

    Server Software:        Cowboy
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      100
    Time taken for tests:   10.303 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      696000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    194.13 [#/sec] (mean)
    Time per request:       515.129 [ms] (mean)
    Time per request:       5.151 [ms] (mean, across all concurrent requests)
    Transfer rate:          65.97 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    1   0.6      0       4
    Processing:   501  512   6.1    511     538
    Waiting:      501  512   6.0    511     538
    Total:        501  513   6.2    512     540
    WARNING: The median and mean for the initial connection time are not within a normal deviation
            These results are probably not that reliable.

    Percentage of the requests served within a certain time (ms)
    50%    512
    66%    515
    75%    516
    80%    518
    90%    521
    95%    525
    98%    529
    99%    531
    100%    540 (longest request)

Clojure

    Server Software:        Jetty(9.2.17.v20160517)
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      100
    Time taken for tests:   10.288 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      258000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    194.40 [#/sec] (mean)
    Time per request:       514.401 [ms] (mean)
    Time per request:       5.144 [ms] (mean, across all concurrent requests)
    Transfer rate:          24.49 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    1   1.2      0       9
    Processing:   501  511  12.7    508     599
    Waiting:      501  511  12.7    508     599
    Total:        502  512  13.4    509     602

    Percentage of the requests served within a certain time (ms)
    50%    509
    66%    511
    75%    513
    80%    514
    90%    518
    95%    525
    98%    574
    99%    587
    100%    602 (longest request)

.NET Core

    CPU: 60%, RAM: 170 MB

    Server Software:        Kestrel
    Server Hostname:        127.0.0.1
    Server Port:            5000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      100
    Time taken for tests:   10.292 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      346000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    194.33 [#/sec] (mean)
    Time per request:       514.595 [ms] (mean)
    Time per request:       5.146 [ms] (mean, across all concurrent requests)
    Transfer rate:          32.83 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    0   0.6      0       4
    Processing:   502  511  10.4    508     567
    Waiting:      502  511  10.4    508     566
    Total:        502  512  10.8    509     569

    Percentage of the requests served within a certain time (ms)
    50%    509
    66%    510
    75%    512
    80%    514
    90%    521
    95%    533
    98%    560
    99%    565
    100%    569 (longest request)

Node

    CPU: 15%, RAM: ~100 MB

    Server Software:
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      100
    Time taken for tests:   10.751 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      236000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    186.03 [#/sec] (mean)
    Time per request:       537.540 [ms] (mean)
    Time per request:       5.375 [ms] (mean, across all concurrent requests)
    Transfer rate:          21.44 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    2   1.2      2       5
    Processing:   501  534  19.4    532     627
    Waiting:      501  533  19.1    531     627
    Total:        501  536  19.3    534     628

    Percentage of the requests served within a certain time (ms)
    50%    534
    66%    540
    75%    545
    80%    547
    90%    554
    95%    565
    98%    601
    99%    615
    100%    628 (longest request)

Rails5

    CPU: 3.4%, RAM: 90 MB (climbed steadily)

    Server Software:
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      100
    Time taken for tests:   204.195 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      688000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    9.79 [#/sec] (mean)
    Time per request:       10209.735 [ms] (mean)
    Time per request:       102.097 [ms] (mean, across all concurrent requests)
    Transfer rate:          3.29 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    0   0.7      0       4
    Processing:   531 9961 1238.6  10200   10276
    Waiting:      531 9960 1238.7  10200   10276
    Total:        534 9961 1238.1  10201   10276

    Percentage of the requests served within a certain time (ms)
    50%  10201
    66%  10213
    75%  10220
    80%  10224
    90%  10235
    95%  10247
    98%  10261
    99%  10268
    100%  10276 (longest request)

Python

    CPU: 15%, RAM: ~40 MB

    Server Software:
    Server Hostname:        127.0.0.1
    Server Port:            8080

    Document Path:          /api/proxy
    Document Length:        20 bytes

    Concurrency Level:      100
    Time taken for tests:   11.306 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      200000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    176.89 [#/sec] (mean)
    Time per request:       565.313 [ms] (mean)
    Time per request:       5.653 [ms] (mean, across all concurrent requests)
    Transfer rate:          17.27 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    2   5.6      2      46
    Processing:   502  555  23.9    557     621
    Waiting:      502  553  23.1    555     620
    Total:        502  557  25.7    558     623

    Percentage of the requests served within a certain time (ms)
    50%    558
    66%    566
    75%    571
    80%    573
    90%    590
    95%    598
    98%    616
    99%    617
    100%    623 (longest request)

### Concurrency 400

.NET Core

    Clobbered my CPU and didn't finish correctly (one of the AB connections timed out).

Clojure

    Server Software:        Jetty(9.2.17.v20160517)
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      400
    Time taken for tests:   2.974 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      258000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    672.51 [#/sec] (mean)
    Time per request:       594.789 [ms] (mean)
    Time per request:       1.487 [ms] (mean, across all concurrent requests)
    Transfer rate:          84.72 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    3   4.1      1      16
    Processing:   501  549  98.9    506     908
    Waiting:      500  549  99.0    506     908
    Total:        501  551 101.5    507     914

    Percentage of the requests served within a certain time (ms)
    50%    507
    66%    512
    75%    519
    80%    530
    90%    729
    95%    826
    98%    879
    99%    896
    100%    914 (longest request)

Go

    Server Software:
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      400
    Time taken for tests:   2.694 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      274000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    742.52 [#/sec] (mean)
    Time per request:       538.706 [ms] (mean)
    Time per request:       1.347 [ms] (mean, across all concurrent requests)
    Transfer rate:          99.34 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    7   5.7      5      20
    Processing:   500  517  17.0    510     573
    Waiting:      500  515  16.1    509     571
    Total:        500  524  21.4    515     591

    Percentage of the requests served within a certain time (ms)
    50%    515
    66%    528
    75%    531
    80%    533
    90%    551
    95%    580
    98%    585
    99%    588
    100%    591 (longest request)

Node

    Server Software:
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      400
    Time taken for tests:   2.925 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      236000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    683.70 [#/sec] (mean)
    Time per request:       585.054 [ms] (mean)
    Time per request:       1.463 [ms] (mean, across all concurrent requests)
    Transfer rate:          78.79 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0    3   5.2      0      16
    Processing:   501  546  51.8    519     721
    Waiting:      501  545  51.0    519     719
    Total:        501  549  54.5    520     722

    Percentage of the requests served within a certain time (ms)
    50%    520
    66%    564
    75%    590
    80%    609
    90%    637
    95%    662
    98%    673
    99%    675
    100%    722 (longest request)

Elixir

    Server Software:        Cowboy
    Server Hostname:        127.0.0.1
    Server Port:            3000

    Document Path:          /api/proxy/
    Document Length:        20 bytes

    Concurrency Level:      400
    Time taken for tests:   3.071 seconds
    Complete requests:      2000
    Failed requests:        0
    Total transferred:      696000 bytes
    HTML transferred:       40000 bytes
    Requests per second:    651.20 [#/sec] (mean)
    Time per request:       614.253 [ms] (mean)
    Time per request:       1.536 [ms] (mean, across all concurrent requests)
    Transfer rate:          221.31 [Kbytes/sec] received

    Connection Times (ms)
                min  mean[+/-sd] median   max
    Connect:        0   13  33.2      0     114
    Processing:   502  565  38.2    567     662
    Waiting:      502  564  38.3    567     662
    Total:        502  578  46.3    577     685

    Percentage of the requests served within a certain time (ms)
    50%    577
    66%    597
    75%    611
    80%    619
    90%    635
    95%    665
    98%    680
    99%    682
    100%    685 (longest request)