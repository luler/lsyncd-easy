FROM theorangeone/lsyncd

COPY ./config /config

RUN chmod 700 /config/.ssh && chmod 600 /config/.ssh/id_rsa