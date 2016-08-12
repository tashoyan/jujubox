FROM ubuntu:16.04
MAINTAINER Whit Morriss <whit.morriss@canonical.com>

ENV env_file="/root/.bash_profile"

RUN apt-get update -qq && \
	apt-get install -qy juju-1-default \
		juju-core \
		juju-deployer \
		python-jujuclient \
		juju-local \
		tmux \
		charm-tools \
		openssh-client \
		virtualenvwrapper \
		python-dev \
		cython \
		git

RUN mkdir -p /root/.juju \
	/root/trusty \
	/root/precise

VOLUME ["/root/.juju"]

RUN git clone https://github.com/juju/plugins.git /root/.juju-plugins

RUN echo "export JUJU_HOME=/root/.juju" >> $env_file && \
	echo "export JUJU_REPOSITORY=/root" >> $env_file && \
	echo "export PROJECT_HOME=/root" >> $env_file && \
	echo "export PATH=\$PATH:/root/.juju-plugins" >> $env_file && \
	echo "echo 'welcome to juju'" >> $env_file

RUN apt-get remove -qy cython \
	gcc \
	git \
	perl
RUN apt-get autoremove -qy && \
	apt-get autoclean -qy && \
	apt-get clean -qy && \
	rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash", "--login"]
