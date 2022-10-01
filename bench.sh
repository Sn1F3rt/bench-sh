#!/bin/bash

sysinfo () {
        # Removing existing bench.log, if any
        rm -rf $HOME/bench.log

        # Reading CPU model
        cname=$( awk -F: '/model name/ {name=$2} END {print name}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
        # Reading amount of CPU cores
        cores=$( awk -F: '/model name/ {core++} END {print core}' /proc/cpuinfo )
        # Reading CPU frequency in MHz
        freq=$( awk -F: ' /cpu MHz/ {freq=$2} END {print freq}' /proc/cpuinfo | sed 's/^[ \t]*//;s/[ \t]*$//' )
        # Reading total memory in MB
        tram=$( free -m | awk 'NR==2 {print $2}' )
        # Reading Swap in MB
        vram=$( free -m | awk 'NR==3 {print $2}' )

        # Reading system uptime
        up=$( uptime | awk '{ $1=$2=$(NF-6)=$(NF-5)=$(NF-4)=$(NF-3)=$(NF-2)=$(NF-1)=$NF=""; print }' | sed 's/^[ \t]*//;s/[ \t]*$//' )

        # Reading operating system and version
        opsy=$( cat /etc/os-release | grep PRETTY_NAME | tr -d '"' | sed -e "s/^PRETTY_NAME=//" ) 

        # Reading Architecture
        arch=$( uname -m ) 
        # Reading Architecture in Bit
        lbit=$( getconf LONG_BIT )

        # Reading Hostname
        hn=$( hostname ) 
        # Reading Kernel
        kern=$( uname -r )

        # Date of benchmark
        bdates=$( date )

        echo '' | tee -a $HOME/bench.log
        echo '__________                     .__        _________ ___ ___  ' | tee -a $HOME/bench.log
        echo '\______   \ ____   ____   ____ |  |__    /   _____//   |   \ ' | tee -a $HOME/bench.log
        echo ' |    |  _// __ \ /    \_/ ___\|  |  \   \_____  \/    ~    \' | tee -a $HOME/bench.log
        echo ' |    |   \  ___/|   |  \  \___|   Y  \  /        \    Y    /' | tee -a $HOME/bench.log
        echo ' |______  /\___  >___|  /\___  >___|  / /_______  /\___|_  / ' | tee -a $HOME/bench.log
        echo '        \/     \/     \/     \/     \/          \/       \/  ' | tee -a $HOME/bench.log
        echo '' | tee -a $HOME/bench.log

        echo "Benchmark started on $bdates" | tee -a $HOME/bench.log
        echo "Full benchmark log: $HOME/bench.log" | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log

        # Output of results
        echo "System Info" | tee -a $HOME/bench.log
        echo "-----------" | tee -a $HOME/bench.log
        echo "Processor : $cname" | tee -a $HOME/bench.log
        echo "CPU Cores : $cores @ $freq MHz" | tee -a $HOME/bench.log
        echo "Memory    : $tram MiB" | tee -a $HOME/bench.log
        echo "Swap      : $vram MiB" | tee -a $HOME/bench.log
        echo "Uptime    : $up" | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log
        echo "OS        : $opsy" | tee -a $HOME/bench.log
        echo "Arch      : $arch ($lbit Bit)" | tee -a $HOME/bench.log
        echo "Kernel    : $kern" | tee -a $HOME/bench.log
        echo "Hostname  : $hn" | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log
}

speedtest4 () {
        # Getting IPv4 address
        ipiv=$( wget -qO- ipv4.icanhazip.com ) 

        # Speed test via wget for IPv4 only with 15x 100 MB files. 1.5 GB bandwidth will be used!
        echo "Speedtest (IPv4 only)" | tee -a $HOME/bench.log
        echo "---------------------" | tee -a $HOME/bench.log
        echo "Your public IPv4 is $ipiv" | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log

        # Cachefly CDN speed test
        echo "Location                Provider        Speed" | tee -a $HOME/bench.log
        echo "--------                --------        -----" | tee -a $HOME/bench.log
        cachefly=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://cachefly.cachefly.net/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$cachefly" ]; then echo "CDN                     Cachefly        $cachefly" | tee -a $HOME/bench.log; else :; fi
        echo "" | tee -a $HOME/bench.log

        # United States speed test
        linatl=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://speedtest.atlanta.linode.com/100MB-atlanta.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$linatl" ]; then echo "Atlanta, GA, US         Linode          $linatl " | tee -a $HOME/bench.log; else :; fi
        sldltx=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://speedtest.dal05.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$sldltx" ]; then echo "Dallas, TX, US          Softlayer       $sldltx " | tee -a $HOME/bench.log; else :; fi
        dpwa=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://sea.download.datapacket.com/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$dpwa" ]; then echo "Seattle, WA, US         Datapacket      $dpwa " | tee -a $HOME/bench.log; else :; fi
        hhsfc=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://heliohost.org/speedtest/100MB.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$hhsfc" ]; then echo "San Francisco, CA, US   HelioHost       $hhsfc " | tee -a $HOME/bench.log; else :; fi
        slwdc=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://mirror.wdc1.us.leaseweb.net/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$slwdc" ]; then echo "Washington, DC, US      Leaseweb        $slwdc " | tee -a $HOME/bench.log; else :; fi
        echo "" | tee -a $HOME/bench.log

        # South America Speed test
        slsao=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://speedtest.sao01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$slsao" ]; then echo "Sao Paulo, Brazil       Softlayer       $slsao " | tee -a $HOME/bench.log; else :; fi
        echo "" | tee -a $HOME/bench.log

        # Asia speed test
        dosg=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://speedtest-sgp1.digitalocean.com/100mb.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$dosg" ]; then echo "Singapore               DigitalOcean    $dosg " | tee -a $HOME/bench.log; else :; fi
        hitw=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://tpdb.speed2.hinet.net/test_100m.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' ) 
        if ! [ -z "$hitw" ]; then echo "Taiwan                  Hinet           $hitw " | tee -a $HOME/bench.log; else :; fi
        lintky=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://speedtest.tokyo2.linode.com/100MB-tokyo2.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$lintky" ]; then echo "Tokyo, Japan            Linode          $lintky " | tee -a $HOME/bench.log; else :; fi
        echo "" | tee -a $HOME/bench.log

        # Europe speed test
        hetzde=$( wget -4 -O /dev/null --timeout=3 --tries=2 https://speed.hetzner.de/100MB.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$hetzde" ]; then echo "Nuremberg, Germany      Hetzner         $hetzde" | tee -a $HOME/bench.log; else :; fi
        i3d=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://mirror.i3d.net/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$i3d" ]; then echo "Rotterdam, Netherlands  id3.net         $i3d" | tee -a $HOME/bench.log; else :; fi        
        leaseweb=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://mirror.leaseweb.com/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$leaseweb" ]; then echo "Haarlem, Netherlands    Leaseweb        $leaseweb " | tee -a $HOME/bench.log; else :; fi
        mlnit=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://speedtest.mil01.softlayer.com/downloads/test100.zip 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$mlnit" ]; then echo "Milan, Italy            Softlayer       $mlnit" | tee -a $HOME/bench.log; else :; fi
        echo "" | tee -a $HOME/bench.log

        # Australia Speed Test
        unetsyd=$( wget -4 -O /dev/null --timeout=3 --tries=2 http://au-syd-speedtest01.urlnetworks.net/file100.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$unetsyd" ]; then echo "Sydney, AU              URL Networks    $unetsyd " | tee -a $HOME/bench.log; else :; fi
        
        echo "" | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log

}
speedtest6 () {
        # Getting IPv6
        ipvii=$( wget -qO- ipv6.icanhazip.com )

        # Speed test via wget for IPv6 only with 10x 100 MB files. 1 GB bandwidth will be used! No CDN - Cachefly not IPv6 ready...
        echo "Speedtest (IPv6 only)" | tee -a $HOME/bench.log
        echo "---------------------" | tee -a $HOME/bench.log
        echo "Your public IPv6 is $ipvii" | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log
        echo "Location                Provider        Speed" | tee -a $HOME/bench.log
        echo "--------                --------        -----" | tee -a $HOME/bench.log

        # United States speed test
        v6atl=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://[2602:fff6:3::4:4]/100MB.test 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6dal" ]; then echo "Atanta, GA, US         QuadraNET               $v6atl" | tee -a $HOME/bench.log; else :; fi
        v6dal=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://speedtest.dallas.linode.com/100MB-dallas.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6dal" ]; then echo "Dallas, TX, US         Linode          $v6dal" | tee -a $HOME/bench.log; else :; fi
        v6new=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://speedtest.newark.linode.com/100MB-newark.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6new" ]; then echo "Newark, NJ, US         Linode          $v6new" | tee -a $HOME/bench.log; else :; fi
        v6fre=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://speedtest.fremont.linode.com/100MB-fremont.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6fre" ]; then echo "Fremont, CA, US                Linode          $v6fre" | tee -a $HOME/bench.log; else :; fi
        v6chi=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://testfile.chi.steadfast.net/data.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6chi" ]; then echo "Chicago, IL, US                Steadfast       $v6chi" | tee -a $HOME/bench.log; else :; fi
        echo "" | tee -a $HOME/bench.log

        # Asia speed test
        v6tok=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://speedtest.tokyo2.linode.com/100MB-tokyo2.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6tok" ]; then echo "Tokyo, Japan           Linode          $v6tok" | tee -a $HOME/bench.log; else :; fi
        v6sin=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://speedtest.singapore.linode.com/100MB-singapore.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6sin" ]; then echo "Singapore              Linode          $v6sin" | tee -a $HOME/bench.log; else :; fi
        echo "" | tee -a $HOME/bench.log

        # Europe speed test
        v6fra=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://speedtest.frankfurt.linode.com/100MB-frankfurt.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6fra" ]; then echo "Frankfurt, Germany     Linode          $v6fra" | tee -a $HOME/bench.log; else :; fi
        v6lon=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://speedtest.london.linode.com/100MB-london.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6lon" ]; then echo "London, UK             Linode          $v6lon" | tee -a $HOME/bench.log; else :; fi
        v6har=$( wget -6 -O /dev/null --timeout=3 --tries=2 http://mirror.nl.leaseweb.net/speedtest/100mb.bin 2>&1 | awk '/\/dev\/null/ {speed=$3 $4} END {gsub(/\(|\)/,"",speed); print speed}' )
        if ! [ -z "$v6har" ]; then echo "Haarlem, Netherlands   Leaseweb        $v6har" | tee -a $HOME/bench.log; else :; fi
        echo "" | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log
}
iotest () {
        echo "Buffered Sequential Write Speed" | tee -a $HOME/bench.log
        echo "-------------------------------" | tee -a $HOME/bench.log

        # Measuring disk speed with DD
        io=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
        io2=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )
        io3=$( ( dd if=/dev/zero of=test_$$ bs=64k count=16k conv=fdatasync && rm -f test_$$ ) 2>&1 | awk -F, '{io=$NF} END { print io}' | sed 's/^[ \t]*//;s/[ \t]*$//' )

        # Calculating avg I/O (better approach with awk for non int values)
        ioraw=$( echo $io | awk 'NR==1 {print $1}' )
        ioraw2=$( echo $io2 | awk 'NR==1 {print $1}' )
        ioraw3=$( echo $io3 | awk 'NR==1 {print $1}' )
        ioall=$( awk 'BEGIN{print '$ioraw' + '$ioraw2' + '$ioraw3'}' )
        ioavg=$( awk 'BEGIN{print '$ioall'/3}' )

        # Output of DD result
        echo "I/O (1st run)     : $io" | tee -a $HOME/bench.log
        echo "I/O (2nd run)     : $io2" | tee -a $HOME/bench.log
        echo "I/O (3rd run)     : $io3" | tee -a $HOME/bench.log
        echo "Average I/O       : $ioavg MB/s" | tee -a $HOME/bench.log

        echo "" | tee -a $HOME/bench.log
}
gbench () {
        echo "" | tee -a $HOME/bench.log

        echo "System Benchmark (Experimental)" | tee -a $HOME/bench.log
        echo "-------------------------------" | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log
        echo "Note: The benchmark might not always work (eg: missing dependencies)." | tee -a $HOME/bench.log
        echo "Failures are highly possible. We're using Geekbench for this test." | tee -a $HOME/bench.log
        echo "" | tee -a $HOME/bench.log
        gb_dl="http://cdn.geekbench.com/Geekbench-5.0.1-Linux.tar.gz"
        gb_name="Geekbench 5.0.1"
        echo "File is located at $gb_dl" | tee -a $HOME/bench.log
        echo "Downloading and extracting $gb_name" | tee -a $HOME/bench.log
        wget -qO - "$gb_dl" | tar xzv 2>&1 >/dev/null
        echo "" | tee -a $HOME/bench.log
        echo "Starting $gb_name" | tee -a $HOME/bench.log
        echo "The system benchmark may take a while." | tee -a $HOME/bench.log
        echo "Don't close your terminal/SSH session!" | tee -a $HOME/bench.log
        echo "All output is redirected into a result file." | tee -a $HOME/bench.log
        echo "" >> $HOME/bench.log
        echo "--- Geekbench Results ---" >> $HOME/bench.log
        sleep 2
        $HOME/Geekbench-5.0.1-Linux/geekbench5 >> $HOME/bench.log
        echo "--- Geekbench Results End ---" >> $HOME/bench.log
        echo "" >> $HOME/bench.log
        echo "Finished. Removing Geekbench files" | tee -a $HOME/bench.log
        sleep 1
        rm -rf $HOME/Geekbench-5.0.1-Linux/
        echo "" | tee -a $HOME/bench.log
        gbl=$(sed -n '/following link/,/following link/ {/following link\|^$/b; p}' $HOME/bench.log | sed 's/^[ \t]*//;s/[ \t]*$//' )
        echo "Benchmark Results: $gbl" | tee -a $HOME/bench.log
        echo "Full report available at $HOME/bench.log" | tee -a $HOME/bench.log

        echo "" | tee -a $HOME/bench.log
}
hlp () {
        echo ""
        echo "bench-sh - VPS Benchmarking Script by Sn1F3rt <sn1f3rt@outlook.com>"
        echo ""
        echo "Usage: sh bench.sh <option>"
        echo ""
        echo "Available options:"
        echo "No option         : System information, IPv4 only speedtest and disk speed benchmark will be run."
        echo "-sys              : Displays system information such as CPU, amount CPU cores, RAM and more."
        echo "-io               : Runs a disk speed test and a IOPing benchmark and displays the results."
        echo "-6                : Normal benchmark but with a IPv6 only speedtest (run when you have IPv6)."
        echo "-46               : Normal benchmark with IPv4 and IPv6 speedtest."
        echo "-64               : Same as above."
        echo "-b                : Normal benchmark with IPv4 only speedtest, I/O test and Geekbench system benchmark."
        echo "-b6               : Normal benchmark with IPv6 only speedtest, I/O test and Geekbench system benchmark."
        echo "-b46              : Normal benchmark with IPv4 and IPv6 speedtest, I/O test and Geekbench system benchmark."       
        echo "-b64              : Same as above."
        echo "-h                : This help page."
        echo ""
        echo "The Geekbench system benchmark is experimental. So beware of failure!"
        echo ""
}
case $1 in
        '-sys')
                sysinfo;;
        '-io')
                iotest;;
        '-6' )
                sysinfo; speedtest6; iotest;;
        '-46' )
                sysinfo; speedtest4; speedtest6; iotest;;
        '-64' )
                sysinfo; speedtest4; speedtest6; iotest;;
        '-b' )
                sysinfo; speedtest4; iotest; gbench;;
        '-b6' )
                sysinfo; speedtest6; iotest; gbench;;
        '-b46' )
                sysinfo; speedtest4; speedtest6; iotest; gbench;;
        '-b64' )
                sysinfo; speedtest4; speedtest6; iotest; gbench;;
        '-h' )
                hlp;;
        '-gbench' )
                gbench;;
        *)
                sysinfo; speedtest4; iotest;;
esac
