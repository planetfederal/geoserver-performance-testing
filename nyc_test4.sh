#!/bin/bash

DATASET=nyc256_test4
DURATION=300
STORE=roads_buildings
JMETERFILE=nyc_test4.jmx

echo "Setting OpenJDK as JVM..." 
ssh scale2 "sudo sed -i 's:.*JAVA_HOME=/usr/lib/jvm/jre1.*:#JAVA_HOME=/usr/lib/jvm/jre1.7.0_51:' /etc/default/tomcat6"

echo "Disabling Marlin rasterizer..."
ssh scale2 "sudo mv /usr/share/tomcat6/bin/setenv.sh /usr/share/tomcat6/bin/setenv.x"

echo "Restarting tomcat6 to make changes effective..."
ssh scale2 "sudo service tomcat6 restart"

#echo "Set test duration to $DURATION."
#ssh dev "sed -i 's:.*ThreadGroup.duration.*:<stringProp name=\"ThreadGroup.duration\">$DURATION</stringProp>:' /home/lcollares/performance_tests/$JMETERFILE"

for THREADS in 1 2 4 8 16 32 64
do
  sed -i 's:.*ThreadGroup.num_threads.*:<stringProp name=\"ThreadGroup.num_threads\">'$THREADS'</stringProp>:' /home/lcollares/performance_tests/$JMETERFILE
  echo "Thread number set to $THREADS."
   
  echo "Running JMeter script..."
  (cd /home/lcollares/performance_tests/apache-jmeter-2.11/bin/;java -jar ApacheJMeter.jar -n -t /home/lcollares/performance_tests/$JMETERFILE)

  OUTPUT="open_S$STORE"_D"$DATASET"_T"$DURATION"_TH"$THREADS".csv
  (cd /home/lcollares/performance_tests/apache-jmeter-2.11/bin/;mv results.csv /home/lcollares/performance_tests/apache-jmeter-2.11/bin/results/$OUTPUT)
  echo "Output filename: $OUTPUT."
  
done   

echo "Enabling Marlin rasterizer..."
ssh scale2 "sudo mv /usr/share/tomcat6/bin/setenv.x /usr/share/tomcat6/bin/setenv.sh"

for THREADS in 1 2 4 8 16 32 64
do
  sed -i 's:.*ThreadGroup.num_threads.*:<stringProp name=\"ThreadGroup.num_threads\">'$THREADS'</stringProp>:' /home/lcollares/performance_tests/$JMETERFILE
  echo "Thread number set to $THREADS."

  for PIXELSIZE in 256 512 1024 2048 4096 8192 16384 
  do
    ssh scale2 "sudo sed -i 's:SIZE=.*:SIZE=${PIXELSIZE}:' /usr/share/tomcat6/bin/setenv.sh"
    echo "Pixel size set to $PIXELSIZE."
      
    for THREADLOCAL in true false
    do
      ssh scale2 "sudo sed -i 's:USE_TL=.*:USE_TL=${THREADLOCAL}:' /usr/share/tomcat6/bin/setenv.sh"
      echo "Thread local set to $THREADLOCAL."
         
       echo "Restarting tomcat6 to make changes effective..."
       ssh scale2 "sudo service tomcat6 restart"                    
         
       echo "Running JMeter script..."
       (cd /home/lcollares/performance_tests/apache-jmeter-2.11/bin/;java -jar ApacheJMeter.jar -n -t /home/lcollares/performance_tests/$JMETERFILE)       

       OUTPUT="open_S$STORE"_D"$DATASET"_T"$DURATION"_TH"$THREADS"_TL"$THREADLOCAL"_PS"$PIXELSIZE".csv
       (cd /home/lcollares/performance_tests/apache-jmeter-2.11/bin/;mv results.csv /home/lcollares/performance_tests/apache-jmeter-2.11/bin/results/$OUTPUT)
       echo "Output filename: $OUTPUT."
    done
  done
done
         
echo "Setting OracleJDK as JVM..."
ssh scale2 "sudo sed -i 's:.*JAVA_HOME=/usr/lib/jvm/jre1.*:JAVA_HOME=/usr/lib/jvm/jre1.7.0_51:' /etc/default/tomcat6"

echo "Disabling Marlin rasterizer..."
ssh scale2 "sudo mv /usr/share/tomcat6/bin/setenv.sh /usr/share/tomcat6/bin/setenv.x"

echo "Restarting tomcat6 to make changes effective..."
ssh scale2 "sudo service tomcat6 restart"

for THREADS in 1 2 4 8 16 32 64 
do
   sed -i 's:.*ThreadGroup.num_threads.*:<stringProp name=\"ThreadGroup.num_threads\">'$THREADS'</stringProp>:' /home/lcollares/performance_tests/$JMETERFILE
   echo "Thread number set to $THREADS."

   echo "Running JMeter script..."
   (cd /home/lcollares/performance_tests/apache-jmeter-2.11/bin/;java -jar ApacheJMeter.jar -n -t /home/lcollares/performance_tests/$JMETERFILE)

   OUTPUT="oracle_S$STORE"_D"$DATASET"_T"$DURATION"_TH"$THREADS".csv
   (cd /home/lcollares/performance_tests/apache-jmeter-2.11/bin/;mv results.csv /home/lcollares/performance_tests/apache-jmeter-2.11/bin/results/$OUTPUT)
   echo "Output filename: $OUTPUT."   
    
done

echo "Enabling Marlin rasterizer..."
ssh scale2 "sudo mv /usr/share/tomcat6/bin/setenv.x /usr/share/tomcat6/bin/setenv.sh"

for THREADS in 1 2 4 8 16 32 64
do
   sed -i 's:.*ThreadGroup.num_threads.*:<stringProp name=\"ThreadGroup.num_threads\">'$THREADS'</stringProp>:' /home/lcollares/performance_tests/$JMETERFILE
   echo "Thread number set to $THREADS."

   for PIXELSIZE in 256 512 1024 2048 4096 8192 16384
   do
      ssh scale2 "sudo sed -i 's:SIZE=.*:SIZE=${PIXELSIZE}:' /usr/share/tomcat6/bin/setenv.sh"
      echo "Pixel size set to $PIXELSIZE."

      for THREADLOCAL in true false
      do
         ssh scale2 "sudo sed -i 's:USE_TL=.*:USE_TL=${THREADLOCAL}:' /usr/share/tomcat6/bin/setenv.sh"
         echo "Thread local set to $THREADLOCAL."

         echo "Restarting tomcat6 to make changes effective..."
         ssh scale2 "sudo service tomcat6 restart"

         echo "Running JMeter script..."
         (cd /home/lcollares/performance_tests/apache-jmeter-2.11/bin/;java -jar ApacheJMeter.jar -n -t /home/lcollares/performance_tests/$JMETERFILE)

         OUTPUT="oracle_S$STORE"_D"$DATASET"_T"$DURATION"_TH"$THREADS"_TL"$THREADLOCAL"_PS"$PIXELSIZE".csv
         (cd /home/lcollares/performance_tests/apache-jmeter-2.11/bin/;mv results.csv /home/lcollares/performance_tests/apache-jmeter-2.11/bin/results/$OUTPUT)
         echo "Output filename: $OUTPUT."
      done
   done
done       


