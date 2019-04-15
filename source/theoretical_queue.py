#!/usr/bin/python

import math
import numpy as np
from argparse import ArgumentParser
import sys
import os
from math import sqrt

#Argument parsing
parser = ArgumentParser(description="Theoretical Analysis of DCTCP")
parser.add_argument('--K',
                    type=int,
                    help="Threshold Queue occupancy K for DCTCP (pkts)", 
                    default=20)


parser.add_argument('--C',
                    type=float,
                    help="The bottleneck link bandwidth (pkt/sec)",
                    default=100)

parser.add_argument('--RTT',
                    type=float,
                    help="RTT (sec)",
                    default=100)

parser.add_argument('--N',
                    type=int,
                    help="The number of flows",
                    default=100)


parser.add_argument('--dir', '-d',
                    help="Directory to store outputs",
                    required=True)

args = parser.parse_args()
C = (args.C * (10 ** 6)) / (1500 * 8)
RTT = args.RTT * (10 ** -6)

# Refer to DCTCP paper for the forumla and derivation 
A = 0.5* sqrt(2 * args.N *(C * RTT + args.K))
Tc = (A/args.N) * RTT

Qmax = args.K + args.N
Qmin = args.K + args.N - A

t1 = Tc/A * Qmin

# Generate 10 samples per Tc
t = np.arange(t1, t1+5*Tc, Tc/10)

Qt = A/Tc * t[0:10]
Q = []
for n in range(5):
  Q = np.append(Q,Qt)


fo = open("%s/theo-log.txt" % args.dir,"w+")
for i in range(len(Q)):
  fo.write("%s,%s \n"%(t[i],Q[i]))

