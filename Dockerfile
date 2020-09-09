FROM rocker/rstudio

COPY config/Rprofile.site /usr/local/lib/R/etc/
COPY util /root/util/

RUN apt-get update -y
RUN apt-get install -y dpkg-dev zlib1g-dev libssl-dev libffi-dev
RUN apt-get install -y curl libcurl4-openssl-dev
RUN R -e "install.packages('synapser', repos=c('http://ran.synapse.org', 'http://cran.fhcrc.org'))"

RUN apt-get install -y libxml2-dev

RUN bash /root/util/add_users.sh /root/util/users.csv
