FROM openjdk:8-jdk
MAINTAINER Chris Lavin chris.lavin@xilinx.com

# Install Python and Jupyter Notebook/Labs
RUN apt-get update && apt-get install -y python3-pip
RUN pip3 install --no-cache-dir notebook==5.5.* jupyterlab==0.32.*

# Download RapidWright and install kernel
USER root
RUN mkdir rapidwright_kernel && cd rapidwright_kernel
RUN curl -L https://github.com/Xilinx/RapidWright/releases/download/v2018.3.0-beta/rapidwright-2018.3.0-standalone-lin64.jar > rapidwright-2018.3.0-standalone-lin64.jar
#RUN java -jar rapidwright-2018.3.0-standalone-lin64.jar --create_jupyter_kernel

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
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--no-browser", "--allow-root"]
