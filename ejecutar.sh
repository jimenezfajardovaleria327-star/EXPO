export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export HADOOP_HOME=/opt/hadoop-3.3.6
export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin:$JAVA_HOME/bin

# Iniciar servicios de Hadoop si no están corriendo
start-dfs.sh 2>/dev/null
start-yarn.sh 2>/dev/null

# Crear carpeta temporal y archivos de entrada
mkdir -p /tmp/practica2 && cd /tmp/practica2
echo "Hadoop MapReduce procesa datos masivos en paralelo" > archivo1.txt
echo "La desviacion estandar mide la dispersion de palabras" > archivo2.txt

# Preparar directorios en HDFS
hdfs dfs -mkdir -p /tema2/std_input
hdfs dfs -mkdir -p /tema2/multi_input
hdfs dfs -put -f archivo1.txt /tema2/std_input/
hdfs dfs -put -f archivo1.txt archivo2.txt /tema2/multi_input/

# 1. Ejecutar Word Standard Deviation
echo "=== RESULTADO: DESVIACION ESTANDAR ==="
hdfs dfs -rm -r /tema2/std_output 2>/dev/null
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar \
  wordstandarddeviation /tema2/std_input /tema2/std_output
hdfs dfs -cat /tema2/std_output/part-r-00000

# 2. Ejecutar Multi-File Word Count
echo "=== RESULTADO: CONTEO MULTI-ARCHIVO ==="
hdfs dfs -rm -r /tema2/multi_output 2>/dev/null
hadoop jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.3.6.jar \
  multifilewc /tema2/multi_input /tema2/multi_output
hdfs dfs -cat /tema2/multi_output/part-r-00000
