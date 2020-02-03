FROM docker-navkit.navkit-pipeline.tt3.com/tomtom/ubuntu-base:4.0.3

LABEL maintainer="NavKit Pipeline <Pipeline@groups.tomtom.com>"

ENV AZURE_EXTENSION_DIR=/opt/azurecliextensions

RUN apt-get update && \
    apt-get install g++ libssl-dev libffi-dev python3-dev python3-pip python3-setuptools git && \
    pip3 install --upgrade pip && \
    mkdir  $AZURE_EXTENSION_DIR && \
    chmod 777 $AZURE_EXTENSION_DIR

RUN pip install azure-cli --extra-index-url https://azurecliprod.blob.core.windows.net/edge
RUN az extension add -n azure-devops

ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]