FROM ubuntu:14.04

RUN /sbin/ldconfig -p

RUN sh -c 'echo "deb http://packages.ros.org/ros/ubuntu trusty main" > /etc/apt/sources.list.d/ros-latest.list'

RUN apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN apt-get update

RUN apt-get -y install ros-indigo-desktop-full


RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable trusty main" > /etc/apt/sources.list.d/gazebo-stable.list'

RUN apt-get -y install wget

RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

RUN  apt-get update


RUN wget https://bitbucket.org/osrf/release-tools/raw/default/jenkins-scripts/lib/dependencies_archive.sh -O /tmp/dependencies.sh

RUN apt-get -y install build-essential \
                     cmake \
                     mercurial

#Needed for gazebo 6, comment out for Gazebo 4
RUN hg clone https://bitbucket.org/ignitionrobotics/ign-math /tmp/ign-math
RUN cd /tmp/ign-math && \
	hg up ign-math2 && \
	mkdir build && \
	cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr ../ && \
	make -j4 && \
	make install

RUN apt-get -y install build-essential \
                     cmake \
                     mercurial \
                     python \
                     libboost-system-dev \
                     libboost-filesystem-dev \
                     libboost-program-options-dev \
                     libboost-regex-dev \
                     libboost-iostreams-dev \
                     libtinyxml-dev \
                     libxml2-utils \
                     ruby-dev \
                     ruby

RUN hg clone https://bitbucket.org/osrf/sdformat /tmp/sdformat
RUN cd /tmp/sdformat && \
#	hg up sdf_2.3 && \ 
	hg up sdf3 && \  
	mkdir build && \
	cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr ../ && \
	make -j4 && \
	make install



RUN hg clone https://lpuck@bitbucket.org/arocchi/gazebo ./tmp/gazebo 

RUN apt-get -y install protobuf-compiler libprotoc-dev libtar-dev




RUN cd /tmp/gazebo && \
	hg pull && \
	hg update blem_gz6_6.5.1 && \
	cd deps/kris_library && \
        cmake . && \
	make KrisLibrary  &&\
	make install

RUN /sbin/ldconfig -p

RUN whereis KrisLibrary

RUN	cd /tmp/gazebo && \
	mkdir build && \
    	cd build && \
	cmake -DCMAKE_INSTALL_PREFIX=/usr ../ && \  
	make -j4 && \
	make install 


