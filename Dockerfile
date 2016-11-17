FROM ubuntu:14.04

MAINTAINER Stephen Bolton <steve@boltn.com>

#Disable Interactive Functions
ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update -y && \
	apt-get install -y build-essential wget bsdmainutils dnsutils git zlib1g-dev libncurses5-dev && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
RUN chmod +x /usr/local/bin/dumb-init

RUN mkdir testssl
WORKDIR /testssl

RUN git clone https://github.com/PeterMosmans/openssl.git
RUN cd openssl && \
	./config zlib --prefix=/opt/openssl --openssldir=/usr/local/ssl shared zlib-dynamic && \
	make depend && \
	make install && \
	cd ..
RUN	wget -q -O testssl.sh https://testssl.sh/testssl.sh && \
	chmod +x /testssl/testssl.sh


ENV OPENSSL /testssl/bin/openssl.Linux.i686

ENTRYPOINT ["/usr/local/bin/dumb-init", "--","/testssl/testssl.sh", "--openssl=/opt/openssl/bin/openssl"]
CMD ["-h"]
