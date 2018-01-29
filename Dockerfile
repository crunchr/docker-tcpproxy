FROM ubuntu:16.04

# Install dependencies
RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get update && \
    apt-get install -y socat runit iproute2 && \
    rm -rf /var/lib/apt/lists/*

# Create a reduced-right user
RUN groupadd -r worker && \
    useradd --no-log-init --system --shell /bin/false --gid worker worker

ADD entrypoint.sh /entrypoint
RUN chmod +x /entrypoint

CMD ["/entrypoint"]
