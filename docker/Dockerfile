FROM ubuntu

RUN apt-get update && \
    apt-get install -y \
         nano \
	     python3.7 \
	     python3-pip \
         git && \
    pip3 install \
        networkx \
        tqdm==4.31.1 \
        pandas \
        numpy \
        biopython \
        matplotlib
