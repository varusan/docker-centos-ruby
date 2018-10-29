# sshd
#
# VERSION               0.0.1

FROM     drecom/centos-base:latest AS build

MAINTAINER Drecom Technical Development Department <pr_itn@drecom.co.jp>

RUN git clone git://github.com/rbenv/rbenv.git /usr/local/rbenv \
&&  git clone git://github.com/rbenv/ruby-build.git /usr/local/rbenv/plugins/ruby-build \
&&  git clone git://github.com/jf/rbenv-gemset.git /usr/local/rbenv/plugins/rbenv-gemset \
&&  /usr/local/rbenv/plugins/ruby-build/install.sh
ENV PATH /usr/local/rbenv/bin:$PATH
ENV RBENV_ROOT /usr/local/rbenv

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /etc/profile.d/rbenv.sh \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /etc/profile.d/rbenv.sh \
&&  echo 'eval "$(rbenv init -)"' >> /etc/profile.d/rbenv.sh

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc \
&&  echo 'export PATH=/usr/local/rbenv/bin:$PATH' >> /root/.bashrc \
&&  echo 'eval "$(rbenv init -)"' >> /root/.bashrc

ENV CONFIGURE_OPTS --disable-install-doc
ENV PATH /usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH

ENV RBENV_VERSION 2.5.3
RUN eval "$(rbenv init -)"; rbenv install $RBENV_VERSION \
&&  eval "$(rbenv init -)"; rbenv global $RBENV_VERSION \
&&  eval "$(rbenv init -)"; gem update --system \
&&  eval "$(rbenv init -)"; gem install bundler -f \
&&  rm -rf /tmp/*

FROM centos:latest
ENV RBENV_ROOT /usr/local/rbenv

COPY --from=build $RBENV_ROOT $RBENV_ROOT

ENV PATH /usr/local/rbenv/bin:/usr/local/rbenv/shims:$PATH

RUN echo 'export RBENV_ROOT=/usr/local/rbenv' >> /root/.bashrc \
&&  echo 'eval "$(rbenv init -)"' >> /root/.bashrc \
&&  yum -y install epel-release make gcc git libxslt-devel openssl-dev mysql-dev redis sqlite-devel
