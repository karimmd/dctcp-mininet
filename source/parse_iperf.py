#!/usr/bin/python

# Parse the iperf.txt files and generate new files that can be used for plotting
# throughput vs time

from argparse import ArgumentParser
import sys
import os

parser = ArgumentParser(description="iperfParser")
parser.add_argument('--n',
                    type=int,
                    help="Number of hosts",
                    default=5)

parser.add_argument('--dir', '-d',
                    help="Directory to store outputs",
                    required=True)

args = parser.parse_args()

for i in range(1,args.n):
    fi = open("%s/iperf%d.txt"%(args.dir,i), "r")
    lines_after_6 = fi.readlines()[6:]
    lines_after_6 = lines_after_6[:-1]
    fo = open("%s/iperf%d-plot.txt"%(args.dir,i),"w+")
    for t in range(30*(i-1)):
        fo.write("%d,0 \n"%t)
    t = 30*(i-1)  
    for line in lines_after_6:
        word = line.split()
        fo.write("%d,%s \n"%(t,word[len(word)-2]))
        t = t+1        
    
    for t in range(t,300):
        fo.write("%d,0 \n"%t)


