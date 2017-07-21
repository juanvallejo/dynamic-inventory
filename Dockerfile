FROM centos:7

RUN INSTALL_PKGS="openssh-clients wget git" \
    && yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS \
    && rpm -q $INSTALL_PKGS \
    && yum clean all

LABEL name="dynamic-inventory-generator" \
      summary="Generates inventory file from host information" \
      description="A containerized dynamic inventory generator based on OpenShift host information"

COPY root /

ENV HOME=/opt/app-root \
	WORK_DIR=${HOME} \
	USER_UID=1001

WORKDIR ${HOME}
RUN /usr/local/bin/user_setup
# ENTRYPOINT /usr/local/bin/entrypoint
CMD /usr/local/bin/run

