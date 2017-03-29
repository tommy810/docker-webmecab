FROM centos:latest
MAINTAINER tomita
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum install -y wget gcc-c++ make git python35u python35u-libs python35u-devel python35u-pip
RUN mkdir ~/libsrc

VOLUME /app

# Install MeCab
RUN cd ~/libsrc && \
    wget -q "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" -O mecab.tar.gz && \
    tar xzf mecab.tar.gz && \
    cd mecab-0.996 && \
    ./configure --enable-utf8-only && \
    make && \
    make install

# Install MeCab ipa Dictionary
RUN cd ~/libsrc && \
    wget -q "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" -O mecab-ipadic.tar.gz && \
    tar xvzf mecab-ipadic.tar.gz && \
    cd mecab-ipadic-2.7.0-20070801 && \
    ./configure --with-charset=utf8 && \
    make && \
    make install

RUN echo '/usr/local/lib' >> /etc/ld.so.conf.d/local.conf && \
    ldconfig

RUN pip3.5 install falcon django mecab-python3

#RUN mkdir /app && \
#    cd /app && \
#    git clone https://github.com/tommy810/webmecabapp.git

EXPOSE 8000

CMD ["/app/start.sh"]
