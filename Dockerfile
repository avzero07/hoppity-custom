FROM torch_cuda_base_final:latest

#RUN conda install python=3.7

RUN sudo apt-get update && sudo apt-get install -y \
    build-essential \
    npm \
    vim \
    bash-completion \
    tmux
WORKDIR hoppity-custom

COPY hoppity/requirements.txt ./
RUN pip install -r requirements.txt

# Install Pytorch Geometric
ENV CPATH=/usr/local/cuda/include:$CPATH
ENV LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
ENV DYLD_LIBRARY_PATH=/usr/local/cuda/lib:$DYLD_LIBRARY_PATH

COPY . .
RUN sudo chmod -R 777 .
RUN cd torch_geometric && \
    for f in *.tar.gz; do tar xf "$f"; done \
    pip install -e pytorch_scatter-1.4.0 && \
    pip install -e pytorch_sparse-0.4.3 && \
    pip install -e pytorch_cluster-1.4.5 && \
    pip install -e pytorch_spline_conv-1.1.1 && \
    pip install -e pytorch_geometric-1.3.2
RUN cd /app/hoppity-custom/hoppity/deps/torchext && \
    pip install -e . && \
    cd /app/hoppity-custom/hoppity && \
    pip install -e .
RUN curl -fsSL https://deb.nodesource.com/setup_10.x | sudo -E bash - && \
    sudo apt-get install -y nodejs
RUN npm install shift-parser && \
	npm install ts-morph && \
	npm install shift-spec-consumer \
	npm install fast-json-patch
RUN mkdir -p /app/hoppity-custom/babel-dir && \
	cd /app/hoppity-custom/babel-dir && \
	npm init -y
#    npm install --save-dev @babel/core @babel/cli \
#    npm install --save-dev @babel/preset-react \
#    npm install --save-dev @babel/plugin-proposal-class-properties \
RUN cd /app/hoppity-custom/babel-dir && \
    touch .babelrc
ENV CRAWLER_HOME=/app/hoppity-custom/gh-crawler
RUN mkdir -p /app/hoppity-custom/output_dir
ENV DATA_HOME=/app/hoppity-custom/output_dir
ENV GENOME_HOME=/app/hoppity-custom/input_dir
RUN mkdir -p /app/hoppity-custom/input_dir
ENV BABEL_DIR=/app/hoppity-custom/babel-dir
ENV NODE_PATH=/app/hoppity-custom/babel-dir
SHELL ["/bin/bash", "-c"]

