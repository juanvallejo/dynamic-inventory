FROM openshift/base-centos7

RUN INSTALL_PKGS="openssh-clients" \
    && yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS \
    && EPEL_PKGS="ansible python-passlib python2-boto" \
    && yum install -y epel-release \
    && yum install -y --setopt=tsflags=nodocs $EPEL_PKGS \
    && rpm -q $INSTALL_PKGS $EPEL_PKGS \
    && yum clean all

LABEL name="dynamic-inventory-generator" \
      summary="Generates inventory file from host information" \
      description="A containerized dynamic inventory generator based on OpenShift host information"

COPY root /

ENV HOME=/opt/app-root \
	WORK_DIR=${HOME} \
	USER_UID=1000

RUN /usr/local/bin/user_setup
# ENTRYPOINT /usr/local/bin/entrypoint
CMD /usr/local/bin/run

