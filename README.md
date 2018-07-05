# jar-deployer
Simple bash script used to deploy JAR packaged applications with restart capability

It was written for a really specific usage, therefore some drawbacks exist, the main one being:
- JAR file must be in the same directory as the script

***


## What IS supported

### Restart
 
Restart option is also supported. It comes handy if you also want to restart JAR file once copied. 

If enabled JAR file is executed with `restart` command:
```bash
my_jar_file.jar restart
```
One scenario where restart command si supported OOTB is if JAR file represents Spring Boot application that runs as a service. [Read more](https://docs.spring.io/spring-boot/docs/current/reference/html/deployment-install.html#deployment-initd-service).


## Usage

### Parameters

Parameter | Description
---|---
-n name | Name of JAR (including .jar extension)
-r restart | Restart jar once deployed
-t target | Set predefined target
-s SSH target | Set SSH target, -t is then used for path to directory, see examples below
-h help | Help 


### Examples

### Copy + restart

**Instructions:**
- JAR named: `my_jar_name.jar` 
- to host: `my_host` 
- as user: `usr` 
- to directory: `/home/usr/path/to/dir`
- and restart it

**Execution:**
```
./deploy_jar -n my_jar_name.jar -s usr@my_host -t /home/usr/path/to/dir -r
```

### Copy to predefined target

**Instructions:**

- JAR named: `my_jar_name.jar` 
- to predefined target `target_1` 

> Predefined target `target_1` must be configured in script itself 

**Execution:**

```
./deploy_jar -n my_jar_name.jar -t target_1
```
