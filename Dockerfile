# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
FROM jupyter/scipy-notebook

MAINTAINER Vitaliy Radchenko
USER root

RUN pip install --upgrade pip

RUN apt-get update && apt-get -y install cmake

# XGBoost
RUN git clone --recursive https://github.com/dmlc/xgboost && \
    cd xgboost && \
    make -j4 && \
    cd python-package; python setup.py install && cd ../..

# LightGBM
RUN cd /usr/local/src && git clone --recursive --depth 1 https://github.com/Microsoft/LightGBM && \
    cd LightGBM && mkdir build && cd build && cmake .. && make -j $(nproc) && \
    cd /usr/local/src/LightGBM/python-package && python setup.py install 

# TensorFlow 
RUN wget https://storage.googleapis.com/tensorflow/linux/cpu/tensorflow-0.10.0rc0-cp35-cp35m-linux_x86_64.whl && \
    pip install tensorflow-0.10.0rc0-cp35-cp35m-linux_x86_64.whl

RUN git clone https://github.com/facebookresearch/fastText.git && \
    cd fastText && \
    make && \
    cd ..

RUN pip install -U spacy

# Keras with TensorFlow backend
RUN pip install keras

# some other useful libraries
RUN pip install seaborn pydot plotly https://pypi.python.org/packages/source/n/nltk/nltk-3.2.1.tar.gz textblob theano

# Switch back to user to avoid accidental container runs as root
USER $NB_USER
