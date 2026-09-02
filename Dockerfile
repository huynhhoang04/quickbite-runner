FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    curl \
    git \
    docker.io \
    sudo \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m runner && echo "runner ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

ARG RUNNER_VERSION=2.317.0
RUN curl -o actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -L https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && mkdir -p /home/runner/actions-runner && tar xzf actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -C /home/runner/actions-runner \
    && rm actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz \
    && /home/runner/actions-runner/bin/installdependencies.sh \
    && chown -R runner:runner /home/runner/actions-runner

WORKDIR /home/runner
COPY --chown=runner:runner run.sh .

USER runner

ENTRYPOINT ["./run.sh"]