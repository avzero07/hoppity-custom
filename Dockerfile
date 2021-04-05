FROM continuumio/miniconda3:latest

RUN conda install python=3.7

RUN apt-get update && apt-get install -y \
    build-essential \
    npm \
    vim \
    bash-completion \
    tmux
WORKDIR /hoppity-custom

COPY hoppity/requirements.txt ./
RUN pip install torch==1.3.1 && \
    pip install -r requirements.txt

COPY . .
RUN cd hoppity/deps/torchext && \
    pip install -e . && \
    cd /hoppity-custom/hoppity && \
    pip install -e .
RUN npm install shift-parser && \
    npm install ts-morph && \
    npm install shift-spec-consumer \
    npm install fast-json-patch
RUN mkdir -p /hoppity-custom/babel-dir && \
    cd /hoppity-custom/babel-dir && \
    npm init -y
#    npm install --save-dev @babel/core @babel/cli \
#    npm install --save-dev @babel/preset-react \
#    npm install --save-dev @babel/plugin-proposal-class-properties \
RUN cd /hoppity-custom/babel-dir && \
    touch .babelrc
ENV CRAWLER_HOME=/hoppity-custom/gh-crawler
RUN mkdir -p /hoppity-custom/output_dir
ENV DATA_HOME=/hoppity-custom/output_dir
ENV GENOME_HOME=/hoppity-custom/input_dir
RUN mkdir -p /hoppity-custom/input_dir
ENV BABEL_DIR=/hoppity-custom/babel-dir
ENV NODE_PATH=/hoppity-custom/babel-dir
SHELL ["/bin/bash", "-c"]

