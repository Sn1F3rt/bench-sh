# bench-sh

This is the Official Benchmarking Script for Post4VPS, and an improved version of **@Hidden Refuge**'s bench-sh-2](https://github.com/hidden-refuge/bench-sh-2).

Demo Results: https://pastebin.com/bPzRABbW

## Direct Run

```sh
wget --no-check-certificate https://raw.githubusercontent.com/sohamb03/bench-sh/master/bench.sh && bash bench.sh && rm -rf bench.sh
```
OR
```sh
curl -O -k https://raw.githubusercontent.com/sohamb03/bench-sh/master/bench.sh && bash bench.sh && rm -rf bench.sh
```

## Parameters

Help Page:
`./bench.sh -h`

System Info + Speedtest IPv4 + Drive Speed:
`./bench.sh`
Classic mode. This will use 1.5 GB bandwidth!

System Info + Speedtest IPv6 + Drive Speed:
`./bench.sh -6`
IPv6 only speed test. This will use 1 GB bandwidth!

System Info + Speedtest IPv4 & IPv6 + Drive Speed:
`./bench.sh -46` or `./bench.sh -64`
Dual stack speed test. This will use 2.5 GB bandwidth!

System Info:
`./bench.sh -sys`
System information only.

Drive Speed:
`./bench.sh -io`
Drive speed test via DD only.

System Info + Speedtest IPv4 + Drive Speed + System Benchmark:
`./bench.sh -b`
Classic mode with system benchmark. This will use 1.5 GB bandwidth!

System Info + Speedtest IPv6 + Drive Speed + System Benchmark:
`./bench.sh -b6`
IPv6 only speed test with system benchmark. This will use 1 GB bandwidth!

System Info + Speedtest IPv4 & IPv6 + Drive Speed + System Benchmark:
`./bench.sh -b46` or `./bench.sh -b64`
Dual stack speed test with system benchmark. This will use 2.5 GB bandwidth.

## Issues/Suggestions
Any queries or help regarding the script can be posted here: https://post4vps.com/Thread-Post4VPS-Benchmarking-Script or you can create an issue on GitHub.
As aforesaid suggestions can be emailed to me, PMed, or you can fork and create a pull request.
