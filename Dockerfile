FROM ubuntu:16.04
MAINTAINER github/skripniuk

RUN apt-get update; \
	apt-get install -y cmake; \
	apt-get install -y g++-4.9

# make g++ 4.9 the default compiler (instead of g++ 5)

RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-4.9 20; \
	update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 20; \
	update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30; \
	update-alternatives --set cc /usr/bin/gcc; \
	update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30; \
	update-alternatives --set c++ /usr/bin/g++

# RUN update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-5.4 10

# RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-4.9 20
# RUN update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-5.4 10

# RUN update-alternatives --install /usr/bin/cc cc /usr/bin/gcc 30
# RUN update-alternatives --set cc /usr/bin/gcc

# RUN update-alternatives --install /usr/bin/c++ c++ /usr/bin/g++ 30
# RUN update-alternatives --set c++ /usr/bin/g++



RUN apt-get install -y mesa-utils kmod binutils

# install nvidia driver
ADD NVIDIA-DRIVER.run /tmp/NVIDIA-DRIVER.run
RUN sh /tmp/NVIDIA-DRIVER.run -a -N --ui=none --no-kernel-module; \
	rm /tmp/NVIDIA-DRIVER.run

RUN apt-get install -y mesa-utils libalut-dev libvorbis-dev cmake libxrender-dev libxrender1 libxrandr-dev zlib1g-dev libpng16-dev; \
	apt-get install -y freeglut3 freeglut3-dev; \
	apt-get install -y libxmu-dev libxmu6 libxi-dev; \
	apt-get install -y wget

# install PLIB-1.8.5
RUN wget http://plib.sourceforge.net/dist/plib-1.8.5.tar.gz; \
	tar xfvz plib-1.8.5.tar.gz; \
	ln -s /usr/lib/libGL.so.1 /usr/lib/libGL.so

# PLIB should be compiled with "-fPIC"
RUN cd plib-1.8.5; \
	export CFLAGS="-fPIC"; \
	export CPPFLAGS=$CFLAGS; \
	export CXXFLAGS=$CFLAGS; \
	./configure; \
	make install


# install openal-1.17.2
RUN wget http://kcat.strangesoft.net/openal-releases/openal-soft-1.17.2.tar.bz2; \
	apt-get install bzip2; \
	tar xfvj openal-soft-1.17.2.tar.bz2; \
	cd openal-soft-1.17.2/build; \
	cmake ..; \
	make; \
	make install


# install dependencies for screen sharing

# opencv
RUN apt-get install -y git qtbase5-dev; \
	git clone --depth 1 https://github.com/opencv/opencv.git /root/opencv && \
	cd /root/opencv && \
	mkdir build && \
	cd build && \
	cmake -DWITH_QT=ON -DWITH_OPENGL=ON -DFORCE_VTK=ON -DWITH_TBB=ON -DWITH_GDAL=ON -DWITH_XINE=ON -DBUILD_EXAMPLES=ON .. && \
	make -j"$(nproc)"  && \
	make install && \
	ldconfig && \
	echo 'ln /dev/null /dev/raw1394' >> ~/.bashrc


# ZMQ
RUN echo "deb http://httpredir.debian.org/debian/ experimental main contrib non-free" >> /etc/apt/sources.list; \
	echo "deb-src http://httpredir.debian.org/debian/ experimental main contrib non-free" >> /etc/apt/sources.list; \
	apt-get update; \
	apt-get install -y libzmq5-dev

# protobuf, Matplotlib, pip
RUN apt-get install -y libprotobuf-dev python-protobuf python-matplotlib python-pip

# Anaconda
RUN wget https://repo.continuum.io/archive/Anaconda2-4.4.0-Linux-x86_64.sh; \
	chmod +x Anaconda2-4.4.0-Linux-x86_64.sh; \
	sh -c '/bin/echo -e "\nyes\n\nyes\n" | ./Anaconda2-4.4.0-Linux-x86_64.sh'; \
	export PATH=$PATH:/root/anaconda2/bin; \
	/root/anaconda2/bin/conda install -y -c conda-forge ipdb=0.10.1; \
	/root/anaconda2/bin/conda install -y -c menpo opencv3=3.1.0; \
	/root/anaconda2/bin/conda install -y -c anaconda protobuf=3.0.0


# install TORCS
ADD torcs-1.3.7 torcs-1.3.7

RUN cd torcs-1.3.7; \
	make; \
	make install; \
	make datainstall

RUN apt-get install -y pkg-config; \
	cd torcs-1.3.7/screenpipe; \
	g++ IPC_command.cpp torcs_data.pb.cc -o IPC_command `pkg-config --cflags --libs opencv protobuf libzmq`

#RUN sed -i '68s/.*/    static zmq::socket_t socket(context, ZMQ_REP);/' IPC_command.cpp; \
#		sed -i '120s/.*/            zmq::message_t request;/' IPC_command.cpp; \
#		sed -i '123s/.*/            \/\/std::cout << "Recived from client: " + replyMessage << std::endl;/' IPC_command.cpp

RUN apt-get install -y tmux vim