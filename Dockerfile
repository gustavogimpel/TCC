FROM jupyter/base-notebook:python-3.8.5

LABEL maintainer="Gustavo Gimpel Correia Lima <gustavo.gimpel@gmail.com>"

USER root
COPY requirements.txt /tmp

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

# Instalação do LaTeX para exportação de notebooks via PDF
RUN apt-get install texlive-xetex texlive-fonts-recommended -y

# Forçando a versão do python em 3.6 devido a imagem do Spark que está sendo utilizada
RUN conda install --yes python=3.6	

#Instalação dos pacotes
RUN pip3 install --upgrade pip
RUN pip3 install -r /tmp/requirements.txt

# RUN /opt/conda/bin/pyspark --packages org.mongodb.spark:mongo-spark-connector_2.12:3.0.0

ENV TINI_VERSION v0.6.0
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /usr/bin/tini
RUN chmod +x /usr/bin/tini
ENTRYPOINT ["/usr/bin/tini", "--"]

EXPOSE 8888
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]

# Switch back to jovyan to avoid accidental container runs as root
USER $NB_UID
WORKDIR $HOME