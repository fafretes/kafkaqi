#FROM rockylinux:9
FROM centos:centos7.9.2009
LABEL maintainer="gabriel@ipvmendoza.gov.ar"
RUN yum install tar
RUN useradd kafka -m
RUN echo 'kafka:KakFA1234' | chpasswd
RUN usermod -aG wheel kafka
#RUN curl https://downloads.apache.org/kafka/3.2.3/kafka_2.13-3.2.3.tgz -o ~/Downloads/kafka.tgz
#RUN wget https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.16%2B8/OpenJDK11U-jdk_x64_linux_11.0.16_8.tar.gz
ADD https://downloads.apache.org/kafka/3.2.3/kafka_2.13-3.2.3.tgz /opt
RUN mv /opt/kafka_2.13-3.2.3.tgz /opt/kafka.tgz
#COPY ./kafka.tgz /opt ##cambiado por ffretes las dos lineas de arriba
RUN tar xvzf /opt/kafka.tgz
USER root
ENV SCALA_VERSION=2.13
ENV JAVA_VERSION=11.0.13
ENV JAVA_HOME=/usr/local/openjdk-11
ENV PATH=/usr/local/openjdk-11/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/opt/kafka/bin
ADD https://github.com/AdoptOpenJDK/openjdk11-upstream-binaries/releases/download/jdk-11.0.16%2B8/OpenJDK11U-jdk_x64_linux_11.0.16_8.tar.gz /opt
#COPY ./OpenJDK11U-jdk_x64_linux_11.0.16_8.tar.gz /opt   ##cambiado por ffretes la l√nea de arriba
RUN tar xvzf /opt/OpenJDK11U-jdk_x64_linux_11.0.16_8.tar.gz
RUN mv openjdk-11.0.16_8 /usr/local/openjdk-11
RUN mv kafka_2.13-3.2.3 /opt/kafka
RUN rm -f /opt/OpenJDK11U-jdk_x64_linux_11.0.16_8.tar.gz /opt/kafka.tgz
COPY ./entrypoint.sh /opt/kafka/
#permisos agregados
RUN chown -R 1001380000:root /opt/kafka && \
    chgrp -R 0 /opt/kafka && \
    chmod -R 775 /opt/kafka
RUN mkdir /mnt/kafka && \
    chown -R 1001380000:root /mnt/kafka && \
    chgrp -R 0 /mnt/kafka && \
    chmod -R 775 /mnt/kafka 
#fin permisos agregados
WORKDIR /opt/kafka
ENTRYPOINT ["sh", "entrypoint.sh"]
#ENTRYPOINT ["/opt/kafka/entrypoint.sh"]
