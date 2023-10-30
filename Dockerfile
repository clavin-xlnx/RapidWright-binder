FROM adoptopenjdk/openjdk11
MAINTAINER Chris Lavin chris.lavin@xilinx.com

# Install Python and Jupyter Notebook/Labs
RUN apt-get update && apt-get install -y python3-pip
#RUN pip3 install --no-cache-dir notebook==5.5.* jupyterlab==0.32.*
#RUN pip3 install --no-cache-dir notebook==5.7.*
RUN pip3 install --no-cache-dir notebook==6.0.*

# Download RapidWright and install kernel
#USER root
#RUN mkdir rapidwright_kernel
#RUN curl -L https://github.com/Xilinx/RapidWright/releases/download/v2022.1.0-beta/rapidwright-2022.1.0-standalone-lin64.jar > /rapidwright_kernel/rapidwright-2022.1.0-standalone-lin64.jar
#RUN cd rapidwright_kernel && java -jar rapidwright-2022.1.0-standalone-lin64.jar --create_jupyter_kernel
RUN pip3 install rapidwright

# Patch for 2022.1.0
#RUN mkdir -p /rapidwright_kernel/com/xilinx/rapidwright/util
#RUN curl -L https://raw.githubusercontent.com/Xilinx/RapidWright/a5ef9dc51bfbd12db73868c707cd0c95e965a6c8/src/com/xilinx/rapidwright/util/ParallelismTools.java > /rapidwright_kernel/com/xilinx/rapidwright/util/ParallelismTools.java
#RUN curl -L https://repo1.maven.org/maven2/org/jetbrains/annotations/20.1.0/annotations-20.1.0.jar > /rapidwright_kernel/annotations-20.1.0.jar
#RUN javac -cp /rapidwright_kernel/annotations-20.1.0.jar:/rapidwright_kernel/rapidwright-2022.1.0-standalone-lin64.jar /rapidwright_kernel/com/xilinx/rapidwright/util/ParallelismTools.java
#RUN sed -i 's=/rapidwright_kernel/=/rapidwright_kernel:/rapidwright_kernel/=' /rapidwright_kernel/jython27/kernel.json

#RUN jupyter kernelspec install /rapidwright_kernel/jython27

# Setup user environment
ENV NB_USER jovyan
ENV NB_UID 1000
ENV HOME /home/$NB_USER

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid $NB_UID \
    $NB_USER

COPY . $HOME
RUN chown -R $NB_UID $HOME

USER $NB_USER

# Launch the notebook server
WORKDIR $HOME
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--no-browser"]
