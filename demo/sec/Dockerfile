FROM softwaresecurityproject/zap-weekly
COPY ./zap-baseline.py .
RUN mkdir /zap/wrk
ENTRYPOINT ["/bin/sh", "-c", "zap.sh -daemon -host 0.0.0.0 -port 8083 -config api.addrs.addr.name=.* -config api.addrs.addr.regex=true -config api.key=\"${ZAP_API_KEY}\" -config network.localServers.aliases.alias.name=\"${ZAP_API_ALIAS}\""]
EXPOSE 8083
