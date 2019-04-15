#!/bin/bash

# Note: Mininet must be run as root.  So invoke this shell script
# using sudo.

bw_sender=100
bw_receiver=100
delay=0.25

iperf_port=5001
for qsize in 120; do
    dirResult=results

    # Expt 1 : Queue occupancy over time - comparing DCTCP & TCP
    dir1=dctcp-q$qsize
    time=10
    dir2=tcp-q$qsize
    #Make directories for TCP, DCTCP and the comparison graph
    mkdir $dir1 $dir2 $dirResult 2>/dev/null
    # Measure queue occupancy with DCTCP
    python dctcp.py --bw-sender $bw_sender \
                    --bw-receiver $bw_receiver \
                    --delay $delay \
                    --dir $dir1 \
                    --maxq $qsize \
                    --time $time \
                    --n 3 \
                    --enable-ecn 1 \
                    --enable-dctcp 1 \
                    --expt 1

    # Measure queue occupancy with TCP
    python dctcp.py --bw-sender $bw_sender \
                    --bw-receiver $bw_receiver \
                    --delay $delay \
                    --dir $dir2 \
                    --maxq $qsize \
                    --time $time \
                    --n 3 \
                    --enable-ecn 0 \
                    --enable-dctcp 0 \
                    --expt 1
    
    # Plot comparison graph
    python plot_queue.py -f $dir1/q.txt $dir2/q.txt \
                         --legend DCTCP TCP -o $dirResult/q.png

    # Remove intermediate folder  
    rm -rf $dir1 $dir2
 

    # Expt 2 : Convergence test for DCTCP vs TCP
    dir=convergenceDCTCP-q$qsize
    time=180
    mkdir $dir 2>/dev/null 

    for i in 1 2 3 4 5; do
    # Measure throughput over time for 5 flows
    python dctcp.py --bw-sender $bw_sender \
                    --bw-receiver $bw_receiver \
                    --delay $delay \
                    --dir $dir \
                    --maxq $qsize \
                    --time $time \
                    --n 6 \
                    --enable-ecn 1 \
                    --enable-dctcp 1 \
                    --expt 2

    # Parse the iperf.txt files for each sender 
    python parse_iperf.py --n 6 --dir $dir
    
    # Plot convergence graph
    python plot_throughput.py -f $dir/iperf1-plot.txt $dir/iperf2-plot.txt \
                                 $dir/iperf3-plot.txt $dir/iperf4-plot.txt \
                                 $dir/iperf5-plot.txt --legend flow1 flow2 \
                                 flow3 flow4 flow5 -o \
                                 $dirResult/convergenceDCTCP.png
    done
    rm -rf $dir
    # Repeat above for TCP
    dir=convergenceTCP-q$qsize
    time=180
    mkdir $dir 2>/dev/null 
    for i in 1 2 3 4 5; do
    python dctcp.py --bw-sender $bw_sender \
                    --bw-receiver $bw_receiver \
                    --delay $delay \
                    --dir $dir \
                    --maxq $qsize \
                    --time $time \
                    --n 6 \
                    --enable-ecn 0 \
                    --enable-dctcp 0 \
                    --expt 2
    python parse_iperf.py --n 6 --dir $dir
    python plot_throughput.py -f $dir/iperf1-plot.txt $dir/iperf2-plot.txt \
                                 $dir/iperf3-plot.txt $dir/iperf4-plot.txt \
                                 $dir/iperf5-plot.txt --legend flow1 flow2 \
                                 flow3 flow4 flow5 -o \
                                 $dirResult/convergenceTCP.png
    done
    rm -rf $dir

    time=10
    dir1=theoretical_vs_analytical-n2
    dir2=theoretical_vs_analytical-n10
    dir3=theoretical_vs_analytical-n40
    mkdir $dir1 $dir2 $dir3 2>/dev/null
    # Measure queue occupancy with DCTCP
    python dctcp.py --bw-sender $bw_sender \
                    --bw-receiver $bw_receiver \
                    --delay $delay \
                    --dir $dir1 \
                    --maxq $qsize \
                    --time $time \
                    --n 3 \
                    --enable-ecn 1 \
                    --enable-dctcp 1 \
                    --expt 1

    # Analytical queue occupancy with DCTCP
    python theoretical_queue.py --K 20 \
                                --C 100 \
                                --RTT 500 \
                                --N 2 \
                                --dir $dir1

    # Plot experimental
    python plot_queue.py -f $dir1/q.txt \
                         --legend Experimental -o $dirResult/q_n2_exptal.png

    # Plot analytical 
    python plot_queue.py -f $dir1/theo-log.txt \
                         --legend Analytical -o $dirResult/q_n2_analytical.png

    # Measure queue occupancy with DCTCP
    python dctcp.py --bw-sender $bw_sender \
                    --bw-receiver $bw_receiver \
                    --delay $delay \
                    --dir $dir2 \
                    --maxq $qsize \
                    --time $time \
                    --n 11 \
                    --enable-ecn 1 \
                    --enable-dctcp 1 \
                    --expt 1

    # Analytical queue occupancy with DCTCP
    python theoretical_queue.py --K 20 \
                                --C 100 \
                                --RTT 500 \
                                --N 10 \
                                --dir $dir2

    # Plot experimental
    python plot_queue.py -f $dir2/q.txt \
                         --legend Experimental -o $dirResult/q_n10_exptal.png

    # Plot analytical 
    python plot_queue.py -f $dir2/theo-log.txt \
                         --legend Analytical -o $dirResult/q_n10_analytical.png

    # Measure queue occupancy with DCTCP
    python dctcp.py --bw-sender $bw_sender \
                    --bw-receiver $bw_receiver \
                    --delay $delay \
                    --dir $dir3 \
                    --maxq $qsize \
                    --time $time \
                    --n 41 \
                    --enable-ecn 1 \
                    --enable-dctcp 1 \
                    --expt 1

    # Analytical queue occupancy with DCTCP
    python theoretical_queue.py --K 20 \
                                --C 100 \
                                --RTT 500 \
                                --N 40 \
                                --dir $dir3

    # Plot experimental
    python plot_queue.py -f $dir3/q.txt \
                         --legend Experimental -o $dirResult/q_n40_exptal.png

    # Plot analytical 
    python plot_queue.py -f $dir3/theo-log.txt \
                         --legend Analytical -o $dirResult/q_n40_analytical.png

    rm -rf $dir1 $dir2 $dir3

done
