# Open Monitoring Distribution
#
## VERSION	1.0
FROM centos:latest
# original MAINTAINER Johan Warlander, jwarlander@redbridge.se
MAINTAINER Alex Klymov al3xxx@gmail.com

# Make sure package repository is up to date
# install EPEL as requirement for OMD
RUN /bin/rm -rf /var/cache/yum &&\
  /usr/bin/yum clean all &&\
  /usr/bin/yum makecache fast &&\
  /usr/bin/yum update &&\
  /usr/bin/yum -y install https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

# Install OMD repo
RUN /usr/bin/yum -y install "https://labs.consol.de/repo/stable/rhel7/x86_64/labs-consol-stable.rhel7.noarch.rpm" &&\
  yum -y install omd

# Set up a default site
RUN omd create default &&\
# We don't want TMPFS as it requires higher privileges
  omd config default set TMPFS off &&\
# Accept connections on any IP address, since we get a random one
  omd config default set APACHE_TCP_ADDR 0.0.0.0

# Add watchdog script
ADD watchdog.sh /opt/omd/watchdog.sh

# Set up runtime options
EXPOSE 5000
ENTRYPOINT ["/opt/omd/watchdog.sh"]
