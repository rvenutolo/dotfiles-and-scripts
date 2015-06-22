#!/bin/bash

update-alternatives --install /usr/bin/groovy groovy /opt/groovy/groovy-current/bin/groovy 1
update-alternatives --set groovy /opt/groovy/groovy-current/bin/groovy
update-alternatives --install /usr/bin/groovyc groovyc /opt/groovy/groovy-current/bin/groovyc 1
update-alternatives --set groovyc /opt/groovy/groovy-current/bin/groovyc
update-alternatives --install /usr/bin/groovyConsole groovyConsole /opt/groovy/groovy-current/bin/groovyConsole 1
update-alternatives --set groovyConsole /opt/groovy/groovy-current/bin/groovyConsole
update-alternatives --install /usr/bin/groovysh groovysh /opt/groovy/groovy-current/bin/groovysh 1
update-alternatives --set groovysh /opt/groovy/groovy-current/bin/groovysh
update-alternatives --install /usr/bin/java2groovy java2groovy /opt/groovy/groovy-current/bin/java2groovy 1
update-alternatives --set java2groovy /opt/groovy/groovy-current/bin/java2groovy

######## system config for /opt/java/jdk-current/bin/
###########################################
update-alternatives --install /usr/bin/jexec jexec /opt/java/jdk-current/lib/jexec 1
update-alternatives --set jexec /opt/java/jdk-current/lib/jexec
update-alternatives --install /usr/bin/appletviewer appletviewer /opt/java/jdk-current/bin/appletviewer 1
update-alternatives --set appletviewer /opt/java/jdk-current/bin/appletviewer
# the file /opt/java/jdk-current/bin/ControlPanel was ignored
update-alternatives --install /usr/bin/extcheck extcheck /opt/java/jdk-current/bin/extcheck 1
update-alternatives --set extcheck /opt/java/jdk-current/bin/extcheck
update-alternatives --install /usr/bin/idlj idlj /opt/java/jdk-current/bin/idlj 1
update-alternatives --set idlj /opt/java/jdk-current/bin/idlj
update-alternatives --install /usr/bin/jar jar /opt/java/jdk-current/bin/jar 1
update-alternatives --set jar /opt/java/jdk-current/bin/jar
update-alternatives --install /usr/bin/jarsigner jarsigner /opt/java/jdk-current/bin/jarsigner 1
update-alternatives --set jarsigner /opt/java/jdk-current/bin/jarsigner
update-alternatives --install /usr/bin/java java /opt/java/jdk-current/bin/java 1
update-alternatives --set java /opt/java/jdk-current/bin/java
update-alternatives --install /usr/bin/javac javac /opt/java/jdk-current/bin/javac 1
update-alternatives --set javac /opt/java/jdk-current/bin/javac
update-alternatives --install /usr/bin/javadoc javadoc /opt/java/jdk-current/bin/javadoc 1
update-alternatives --set javadoc /opt/java/jdk-current/bin/javadoc
update-alternatives --install /usr/bin/javafxpackager javafxpackager /opt/java/jdk-current/bin/javafxpackager 1
update-alternatives --set javafxpackager /opt/java/jdk-current/bin/javafxpackager
update-alternatives --install /usr/bin/javah javah /opt/java/jdk-current/bin/javah 1
update-alternatives --set javah /opt/java/jdk-current/bin/javah
update-alternatives --install /usr/bin/javap javap /opt/java/jdk-current/bin/javap 1
update-alternatives --set javap /opt/java/jdk-current/bin/javap
update-alternatives --install /usr/bin/javapackager javapackager /opt/java/jdk-current/bin/javapackager 1
update-alternatives --set javapackager /opt/java/jdk-current/bin/javapackager
update-alternatives --install /usr/bin/java-rmi.cgi java-rmi.cgi /opt/java/jdk-current/bin/java-rmi.cgi 1
update-alternatives --set java-rmi.cgi /opt/java/jdk-current/bin/java-rmi.cgi
update-alternatives --install /usr/bin/javaws javaws /opt/java/jdk-current/bin/javaws 1
update-alternatives --set javaws /opt/java/jdk-current/bin/javaws
update-alternatives --install /usr/bin/jcmd jcmd /opt/java/jdk-current/bin/jcmd 1
update-alternatives --set jcmd /opt/java/jdk-current/bin/jcmd
update-alternatives --install /usr/bin/jconsole jconsole /opt/java/jdk-current/bin/jconsole 1
update-alternatives --set jconsole /opt/java/jdk-current/bin/jconsole
update-alternatives --install /usr/bin/jcontrol jcontrol /opt/java/jdk-current/bin/jcontrol 1
update-alternatives --set jcontrol /opt/java/jdk-current/bin/jcontrol
update-alternatives --install /usr/bin/jdb jdb /opt/java/jdk-current/bin/jdb 1
update-alternatives --set jdb /opt/java/jdk-current/bin/jdb
update-alternatives --install /usr/bin/jdeps jdeps /opt/java/jdk-current/bin/jdeps 1
update-alternatives --set jdeps /opt/java/jdk-current/bin/jdeps
update-alternatives --install /usr/bin/jhat jhat /opt/java/jdk-current/bin/jhat 1
update-alternatives --set jhat /opt/java/jdk-current/bin/jhat
update-alternatives --install /usr/bin/jinfo jinfo /opt/java/jdk-current/bin/jinfo 1
update-alternatives --set jinfo /opt/java/jdk-current/bin/jinfo
update-alternatives --install /usr/bin/jjs jjs /opt/java/jdk-current/bin/jjs 1
update-alternatives --set jjs /opt/java/jdk-current/bin/jjs
update-alternatives --install /usr/bin/jmap jmap /opt/java/jdk-current/bin/jmap 1
update-alternatives --set jmap /opt/java/jdk-current/bin/jmap
update-alternatives --install /usr/bin/jmc jmc /opt/java/jdk-current/bin/jmc 1
update-alternatives --set jmc /opt/java/jdk-current/bin/jmc
update-alternatives --install /usr/bin/jmc.ini jmc.ini /opt/java/jdk-current/bin/jmc.ini 1
update-alternatives --set jmc.ini /opt/java/jdk-current/bin/jmc.ini
update-alternatives --install /usr/bin/jps jps /opt/java/jdk-current/bin/jps 1
update-alternatives --set jps /opt/java/jdk-current/bin/jps
update-alternatives --install /usr/bin/jrunscript jrunscript /opt/java/jdk-current/bin/jrunscript 1
update-alternatives --set jrunscript /opt/java/jdk-current/bin/jrunscript
update-alternatives --install /usr/bin/jsadebugd jsadebugd /opt/java/jdk-current/bin/jsadebugd 1
update-alternatives --set jsadebugd /opt/java/jdk-current/bin/jsadebugd
update-alternatives --install /usr/bin/jstack jstack /opt/java/jdk-current/bin/jstack 1
update-alternatives --set jstack /opt/java/jdk-current/bin/jstack
update-alternatives --install /usr/bin/jstat jstat /opt/java/jdk-current/bin/jstat 1
update-alternatives --set jstat /opt/java/jdk-current/bin/jstat
update-alternatives --install /usr/bin/jstatd jstatd /opt/java/jdk-current/bin/jstatd 1
update-alternatives --set jstatd /opt/java/jdk-current/bin/jstatd
update-alternatives --install /usr/bin/jvisualvm jvisualvm /opt/java/jdk-current/bin/jvisualvm 1
update-alternatives --set jvisualvm /opt/java/jdk-current/bin/jvisualvm
update-alternatives --install /usr/bin/keytool keytool /opt/java/jdk-current/bin/keytool 1
update-alternatives --set keytool /opt/java/jdk-current/bin/keytool
update-alternatives --install /usr/bin/native2ascii native2ascii /opt/java/jdk-current/bin/native2ascii 1
update-alternatives --set native2ascii /opt/java/jdk-current/bin/native2ascii
update-alternatives --install /usr/bin/orbd orbd /opt/java/jdk-current/bin/orbd 1
update-alternatives --set orbd /opt/java/jdk-current/bin/orbd
update-alternatives --install /usr/bin/pack200 pack200 /opt/java/jdk-current/bin/pack200 1
update-alternatives --set pack200 /opt/java/jdk-current/bin/pack200
update-alternatives --install /usr/bin/policytool policytool /opt/java/jdk-current/bin/policytool 1
update-alternatives --set policytool /opt/java/jdk-current/bin/policytool
update-alternatives --install /usr/bin/rmic rmic /opt/java/jdk-current/bin/rmic 1
update-alternatives --set rmic /opt/java/jdk-current/bin/rmic
update-alternatives --install /usr/bin/rmid rmid /opt/java/jdk-current/bin/rmid 1
update-alternatives --set rmid /opt/java/jdk-current/bin/rmid
update-alternatives --install /usr/bin/rmiregistry rmiregistry /opt/java/jdk-current/bin/rmiregistry 1
update-alternatives --set rmiregistry /opt/java/jdk-current/bin/rmiregistry
update-alternatives --install /usr/bin/schemagen schemagen /opt/java/jdk-current/bin/schemagen 1
update-alternatives --set schemagen /opt/java/jdk-current/bin/schemagen
update-alternatives --install /usr/bin/serialver serialver /opt/java/jdk-current/bin/serialver 1
update-alternatives --set serialver /opt/java/jdk-current/bin/serialver
update-alternatives --install /usr/bin/servertool servertool /opt/java/jdk-current/bin/servertool 1
update-alternatives --set servertool /opt/java/jdk-current/bin/servertool
update-alternatives --install /usr/bin/tnameserv tnameserv /opt/java/jdk-current/bin/tnameserv 1
update-alternatives --set tnameserv /opt/java/jdk-current/bin/tnameserv
update-alternatives --install /usr/bin/unpack200 unpack200 /opt/java/jdk-current/bin/unpack200 1
update-alternatives --set unpack200 /opt/java/jdk-current/bin/unpack200
update-alternatives --install /usr/bin/wsgen wsgen /opt/java/jdk-current/bin/wsgen 1
update-alternatives --set wsgen /opt/java/jdk-current/bin/wsgen
update-alternatives --install /usr/bin/wsimport wsimport /opt/java/jdk-current/bin/wsimport 1
update-alternatives --set wsimport /opt/java/jdk-current/bin/wsimport
update-alternatives --install /usr/bin/xjc xjc /opt/java/jdk-current/bin/xjc 1
update-alternatives --set xjc /opt/java/jdk-current/bin/xjc

