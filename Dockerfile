FROM fuzzers/afl:2.52

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev libjpeg-dev python3 python3-pip python3-setuptools python3-wheel ninja-build
RUN pip3 install meson
RUN git clone https://github.com/zchunk/zchunk
WORKDIR /zchunk
RUN CC=afl-clang CXX=afl-clang++ meson build
WORKDIR /zchunk/build
RUN ninja
RUN ninja install
WORKDIR /zchunk
RUN mkdir /testsuite
COPY multi:1a0fae6f2d670a6f9e79d3a33614fcda2b9d48cc8d7532d77b438cd425e0ece3 in /testsuite/

#zck - harness no2.
RUN mkdir /zckTest
RUN echo "A" > 0.txt
RUN echo "@@@!HELLO" > 1.txt
RUN wget https://file-examples.com/wp-content/uploads/2017/10/file_example_PNG_500kB.png
RUN wget https://chromium.googlesource.com/chromium/src/+/lkgr/media/test/data/4ch.wav
RUN mv *.txt /zckTest
RUN mv *.png /zckTest
RUN mv *.wav /zckTest
ENV LD_LIBRARY_PATH=/usr/local/lib


ENTRYPOINT  ["afl-fuzz", "-i", "/testsuite", "-o", "/zckOut"]
CMD ["/zchunk/build/src/unzck", "@@"]
# harness no 2.
#ENTRYPOINT ["afl-fuzz", "-i", "/zckTest", "-o", "/zckTestOut"]
#CMD ["/zchunk/build/src/zck", "@@"]
