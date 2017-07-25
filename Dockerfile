FROM centos:7

RUN INSTALL_PKGS="openssh-clients wget git" \
    && yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS \
    && EPEL_PKGS="PyYAML" \
 	&& yum install -y epel-release \
 	&& yum install -y --setopt=tsflags=nodocs $EPEL_PKGS \
    && rpm -q $INSTALL_PKGS $EPEL_PKGS \
    && yum clean all

LABEL name="dynamic-inventory-generator" \
      summary="Generates inventory file from host information" \
      description="A containerized dynamic inventory generator based on OpenShift host information"

COPY root /

ENV APP_ROOT=/opt/app-root \
	HOME=/opt/app-root/src \
	WORK_DIR=/opt/app-root \
	USER_UID=1001

WORKDIR ${HOME}
RUN /usr/local/bin/user_setup

ENTRYPOINT [ "/usr/local/bin/entrypoint" ]
CMD [ "/usr/local/bin/run" ]