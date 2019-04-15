# dctcp-mininet
A Sample Scenario on DCTCP based on Mininet

Submitted by Padmapriya Duraisamy <ppriya@stanford.edu> and Venkata Durga Ganesh Reddy Aakula <durga@stanford.edu>
1. Launch an instance with our AMI DCTCP_CS244_16 and in Configure Instance
Details, please select tenancy as Dedicated - Run a Dedicated Instance 
Be sure to allow all TCP, UDP and HTTP traffic from anywhere while setting the
security groups.
2. ssh to the instance 
3. Clone the dctcp repo - 
hg clone https://priyaduraisamy@bitbucket.org/priyaduraisamy/dctcp
3. cd to dctcp folder
4. sudo mn -c && sudo ./run.sh

The experiments totally take about 1 hour to run. Please ensure ssh connectivity
does not break while the code is running. Alternatively, you could run it on a
separate screen and detach it and check after about an hour. 

In the end, there is a folder results within dctcp that contains the results. 
We observed very rarely that the resulted figures are a bit off from what is 
expected - we think it is due to load variations on AWS servers. If this happens, 
we request the reader to run it again to see the results if are ok.

To view the graphs :
	a. cd /dctcp/results
	b. python -m SimpleHTTPServer 

Open a browser and type <instance_ip>:8000 and open each image to view. The
images are named appropriately so you can identify them easily.
