## Requirement 
 WAS Account 
 WAS home directory
 JDK 1.7 or higer

## Installation 
 - host]# setup.sh
 - Follow instruct from setup script

## Add Instance 
 - instmanager [INSTANCE_NAME] add
 - check instance directory 

## Remove Instance 
 - instmanager [INSTANCE_NAME] remove  

## Running Instance
 - host]#./cwas [INSTANACE_NAME] start 

## Directory structure  
 setup.sh : CWAS install script 
 instnamager : Instance add / remove , the new instance will located under instance directory  
 cwas : cwas control script for start, stop, kill and etc function 
 engine : tomcat core engine for CWAS (include standard startup/stop script and setenv.sh)
 instance : It will made by instnamager script when you add new instance 
 share : file for install CWAS package  
```
.
├── engine
│   ├── bin
│   ├── conf
│   ├── lib
│   ├── temp
│   └── webapps
├── instance
│   ├── test1
│   │   ├── conf
│   │   │   └── Catalina
│   │   │       └── localhost
│   │   ├── lib
│   │   ├── logs
│   │   ├── temp
│   │   ├── webapps
│   │               └── ROOT
│   └── test3
│       ├── conf
│       │   └── Catalina
│       │       └── localhost
│       ├── lib
│       ├── logs
│       ├── temp
│       ├── webapps
│       │   └── ROOT
└── share
    ├── conf
    ├── dist
    └── webapps
```
## cwas command 
 - execute with ./cwas command on cli mode 
 - ./cwas [INSTANCE_NAME] [SUB-COMMAND]
 - cwas has sub-command as below
   * start   : start [INSTANCE_NAME] 
   * stop    : stop [INSTANCE_NAME]  
   * restart : stop [INSTANCE_NAME] and start [INSTANCE_NAME] 
   * status  : check status of [INSTANCE_NAME]  such as all of port and PID  
   * config  : open config file of [INSTNACE_NAME] ${INSTALLED_PATH}/instance/[INSTANCE_NAME]/conf/sia.conf
   * kill    : kill [INSTANCE_NAME] process
   * log     : watch [INSTANCE_NAME] log (catalina.out)
   * thread  : check thread count of [INSTANCE_NAME] 

   
## REFERENCE
http://tomcat.apache.org/tomcat-7.0-doc/index.html
