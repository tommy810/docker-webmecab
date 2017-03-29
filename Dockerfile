FROM centos:latest
MAINTAINER tomita
RUN yum install -y https://centos7.iuscommunity.org/ius-release.rpm
RUN yum install -y wget gcc-c++ make git python35u python35u-libs python35u-devel python35u-pip
RUN mkdir ~/libsrc

RUN cd ~/libsrc && \
    wget -q "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE" -O mecab.tar.gz && \
    tar xzf mecab.tar.gz && \
    cd mecab-0.996 && \
    ./configure --enable-utf8-only && \
    make && \
    make install

RUN cd ~/libsrc && \
    wget -q "https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM" -O mecab-ipadic.tar.gz && \
    tar xvzf mecab-ipadic.tar.gz && \
    cd mecab-ipadic-2.7.0-20070801 && \
    ./configure --with-charset=utf8 && \
    make && \
    make install

RUN pip3.5 install falcon mecab-python3

RUN echo '/usr/local/lib' >> /etc/ld.so.conf.d/local.conf && \
    ldconfig

RUN mkdir /app && \
    cd /app && \
    git clone https://github.com/tommy810/webmecabapp.git

EXPOSE 8000

CMD ["python3.5", "/app/webmecabapp/webmecab.py"]
