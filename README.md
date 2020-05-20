#   terraform-azure


Azure :
===========
To provison 2 linux vm and validate machine communication to each other.
+ script provision_vm.tf for allocation of UBUNTU VM's on azure using network and linuxserver modules.
+ output logs showing logs from the terraform at outputlogs file.
---
Script for sever metrics of server 
+ CPU 
+ Network usage
+ Disk Usage 

script is present in file **memcpu.sh**
output as :
``` 
./memcpu.sh adminuser server                                                  (master|●1✚4)
Memory Usage: 287/386MB (74.35%)
Disk Usage: 103/466GB (23%)
RECEIVED: (2559.59)MB 
TRANSMITTED: (1.91)MB 
CPU Load: 0.71

./memcpu.sh azureadmin                                                                                          (master|●1✚4)
Usage: ./memcpu.sh adminusername server
```
---
Linux
=====
Elastic search Running in a docker container.

Script **runelasticandcheckhalth.sh** works on two arguments;
1. with arg as run it will spin up elasticsearch 1 node cluster with port 9200 mappped to host machine.
2. with checkstatus as argument it will check health of elasticsearch running on localhost mapped to container on 9200 port.

> Script relies on jq  and if package not found on ubuntu it will install jq with sudo.

Linux problem Solving
=====================
####Redis not starting.
+ validated the service status ir was stopped and failing.
+ Run sudo journalctl -xe gives following ouput.
```commandline
-- Unit redis-server.service has begun starting up.
May 15 10:32:44 amit-lnx run-parts[73059]: run-parts: executing /etc/redis/redis-server.pre-up.d/00_example
May 15 10:32:44 amit-lnx redis-server[73071]: *** FATAL CONFIG FILE ERROR ***
May 15 10:32:44 amit-lnx redis-server[73071]: Reading the configuration file, at line 108
May 15 10:32:44 amit-lnx redis-server[73071]: >>> 'logfile /var/log/redis-server.log'
May 15 10:32:44 amit-lnx redis-server[73071]: Can't open the log file: Read-only file system
May 15 10:32:44 amit-lnx systemd[1]: redis-server.service: Control process exited, code=exited status=1
May 15 10:32:44 amit-lnx systemd[1]: Failed to start Advanced key-value store.
-- Subject: Unit redis-server.service has failed
-- Defined-By: systemd
-- Support: http://lists.freedesktop.org/mailman/listinfo/systemd-devel
-- 
-- Unit redis-server.service has failed.
-- 
-- The result is failed.
May 15 10:32:44 amit-lnx systemd[1]: redis-server.service: Unit entered failed state.
May 15 10:32:44 amit-lnx systemd[1]: redis-server.service: Failed with result 'exit-code'.
May 15 10:32:44 amit-lnx systemd[1]: redis-server.service: Service hold-off time over, scheduling restart.
May 15 10:32:44 amit-lnx systemd[1]: Stopped Advanced key-value store.
```
+ config file have defined the log file to /var/log/redis-server.log while the log file was defined at /var/log/redis/redis-server.log and hence permission issues.
+ updated configuration file using ```sudo vim /etc/redis/redis.conf``` to the log file as 
```commandline

# Specify the log file name. Also the empty string can be used to force
# Redis to log on the standard output. Note that if you use standard
# output for logging but daemonize, logs will be sent to /dev/null
logfile /var/log/redis/redis-server.log

```
+ service restarted and validated
```commandline
stylelabs@amit-lnx:/var/log$ sudo vim /etc/redis/redis.conf
stylelabs@amit-lnx:/var/log$ sudo service redis-server start 
stylelabs@amit-lnx:/var/log$ sudo service redis-server status
● redis-server.service - Advanced key-value store
   Loaded: loaded (/lib/systemd/system/redis-server.service; enabled; vendor preset: enabled)
   Active: active (running) since Fri 2020-05-15 10:38:28 UTC; 5s ago
     Docs: http://redis.io/documentation,
           man:redis-server(1)
  Process: 73741 ExecStartPost=/bin/run-parts --verbose /etc/redis/redis-server.post-up.d (code=exited, status=0/SUCCESS)
  Process: 73736 ExecStart=/usr/bin/redis-server /etc/redis/redis.conf (code=exited, status=0/SUCCESS)
  Process: 73724 ExecStartPre=/bin/run-parts --verbose /etc/redis/redis-server.pre-up.d (code=exited, status=0/SUCCESS)
 Main PID: 73740 (redis-server)
    Tasks: 3
   Memory: 6.8M
      CPU: 24ms
   CGroup: /system.slice/redis-server.service
           └─73740 /usr/bin/redis-server 127.0.0.1:6379       

May 15 10:38:28 amit-lnx systemd[1]: Starting Advanced key-value store...
May 15 10:38:28 amit-lnx run-parts[73724]: run-parts: executing /etc/redis/redis-server.pre-up.d/00_example
May 15 10:38:28 amit-lnx run-parts[73741]: run-parts: executing /etc/redis/redis-server.post-up.d/00_example
May 15 10:38:28 amit-lnx systemd[1]: Started Advanced key-value store.
stylelabs@amit-lnx:/var/log$ redis-cli ping 
PONG


```

Windows troubleshooting
=======================
+ Issue : hitting localhost gives 503.
+ navigated to event center-> IIS and saw default application pool as stopped.
+ tried restaring default application pool but it stopped again.
+ go to default application pool advanced settings and update Identity to ** ApllicationPoolIdentity**.
+ Restart default application pool.
+ Service started and localhost shows default IIS page.

![alt text][application_pool]
[applicationpool] USerpool.png

![alt text][IIS]
[IIS] IIS.png
