#Use CxFlow Base image
FROM checkmarx/cx-flow
RUN apk add maven
RUN apk add py3-pip

#install sbt
ENV SBT_VERSION 1.8.2
RUN apk add --no-cache bash curl && \
curl -sL "https://github.com/sbt/sbt/releases/download/v$SBT_VERSION/sbt-$SBT_VERSION.tgz" | gunzip | tar -x -C /usr/local && \
ln -s /usr/local/sbt/bin/sbt /usr/local/bin/sbt && \
chmod 0755 /usr/local/bin/sbt 

#SCA Resolver Logs
COPY Configuration.yml /app/Configuration.yml
RUN grep "LogLevel" /app/Configuration.yml

#SCAResolver
RUN mkdir /scar
COPY ScaResolver /scar/ScaResolver
RUN chmod +x /scar/ScaResolver

RUN mkdir -p /root/.ivy2 && mkdir /root/.pip
COPY .nexus.rsci.co.credentials /root/.ivy2/.nexus.rsci.co.credentials
COPY pip.conf /root/.pip/pip.conf

RUN pip3 install virtualenv

#Copy the entrypoint script and properties used for the action
COPY entrypoint.sh /app/entrypoint.sh
#Make it executable
RUN chmod +x /app/entrypoint.sh
ENTRYPOINT ["/app/entrypoint.sh"]
