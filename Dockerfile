# build twister from source
# see accompanying README.md
# and upstream source instructions http://twister.net.co/
FROM lapax/precise-dev
MAINTAINER Lex Lapax <lexlapax@gmail.com>
ENV DEBIAN_FRONTEND noninteractive
RUN \ 
	add-apt-repository -y ppa:bitcoin/bitcoin ;\
	apt-get update ;\
	apt-get install libboost-all-dev libdb4.8-dev libdb4.8++-dev libminiupnpc8=1.6-3ubuntu1 libminiupnpc-dev -y 

RUN \
	mkdir -p /usr/local/src ~/.twister ;\
	cd /usr/local/src; \
	git clone https://github.com/miguelfreitas/twister-core.git ;\
	git clone https://github.com/miguelfreitas/twister-html.git

RUN \
	cd /usr/local/src/twister-core ;\
	./bootstrap.sh --enable-logging --enable-debug --enable-statistics ;\
	make V=1 ;\
	make install-binPROGRAMS 

RUN \
	cd ~/.twister ;\
	mv /usr/local/src/twister-html ./html ;\
	echo "rpcuser=user" >> ~/.twister/twister.conf ;\
	echo "rpcpassword=pwd" >> ~/.twister/twister.conf ;\
	echo "rpcallowip=*.*.*.*" >> ~/.twister/twister.conf 

EXPOSE 4433 4434 28332 28333 29333 29333/udp 
#CMD twisterd -daemon -rpcuser=user -rpcpassword=pwd -rpcallowip=127.0.0.1
CMD ["/bin/bash", "-i"]
CMD ["/usr/local/bin/twisterd"]
