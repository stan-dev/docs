# Base image for R 4.2.0
FROM r-base:4.2.0

ENV QUATRO_VERSION 1.4.550

ARG PUID
ARG PGID

# Install OS Dependencies
RUN apt-get update -y && \
    apt-get install curl libssl-dev libcurl4-openssl-dev libxml2-dev libfontconfig1-dev git texlive-full python3 pandoc -y

RUN update-ca-certificates -f

RUN mkdir -p /tmp/quatro && wget -O "/tmp/quatro/quatro.deb" https://github.com/quarto-dev/quarto-cli/releases/download/v${QUATRO_VERSION}/quarto-${QUATRO_VERSION}-linux-amd64.deb && \
    dpkg -i /tmp/quatro/quatro.deb && \
    rm -rf /tmp/quatro

# Setup jenkins uid/gid
RUN addgroup -gid ${PGID} jenkins
RUN adduser --disabled-password --gecos '' --ingroup jenkins --uid ${PUID} jenkins
RUN usermod -a -G sudo jenkins
RUN echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
RUN chown -R jenkins:sudo /usr/local

USER jenkins
WORKDIR /home/jenkins

# Install R depdendencies
RUN Rscript -e 'install.packages(c("dplyr", "ggplot2", "kableExtra", "bookdown", "pandoc-citeproc"), repos="https://cloud.r-project.org")'