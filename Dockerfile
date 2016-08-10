FROM ubuntu:16.04
MAINTAINER Whit Morriss <whit.morriss@canonical.com>

ENV juju_user="ubuntu"
ENV juju_user_home="/home/$juju_user"
ENV juju_user_env="$juju_user_home/.bash_profile"

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

RUN useradd -m -d $juju_user_home -s /bin/bash $juju_user

USER $juju_user
RUN mkdir -p $juju_user_home/.juju \
	$juju_user_home/trusty \
	$juju_user_home/precise

USER root
VOLUME ["$juju_user_home/.juju"]

USER $juju_user
RUN git clone https://github.com/juju/plugins.git $juju_user_home/.juju-plugins

RUN echo "export JUJU_HOME=$juju_user_home/.juju" >> $juju_user_env && \
	echo "export JUJU_REPOSITORY=$juju_user_home" >> $juju_user_env && \
	echo "export PROJECT_HOME=$juju_user_home" >> $juju_user_env && \
	echo "export PATH=\$PATH:$juju_user_home/.juju-plugins" >> $juju_user_env && \
	echo "unset juju_user juju_user_home juju_user_env" >> $juju_user_env && \
	echo "echo 'welcome to juju'" >> $juju_user_env

USER root
RUN apt-get remove -qy cython \
	gcc \
	git \
	perl
RUN apt-get autoremove -qy && \
	apt-get autoclean -qy && \
	apt-get clean -qy && \
	rm -rf /var/lib/apt/lists/*

USER $juju_user
CMD ["/bin/bash", "--login"]
