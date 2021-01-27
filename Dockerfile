FROM jupyter/base-notebook:python-3.8.5

USER root

# Install OpenJDK-8
RUN apt-get update && \
    apt-get install -y openjdk-8-jdk && \
    apt-get install -y ant && \
    apt-get clean;

# Fix certificate issues
RUN apt-get update && \
    apt-get install ca-certificates-java && \
    apt-get clean && \
    update-ca-certificates -f;

ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/
RUN export JAVA_HOME

RUN conda install --yes python=3.6

RUN pip install sklearn
RUN pip install seaborn
RUN pip install pymongo
RUN pip install numpy
RUN pip install pandas
RUN pip install pyspark
RUN pip install matplotlib

CMD ["start-notebook.sh"]