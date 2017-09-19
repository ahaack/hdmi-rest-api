FROM resin/raspberry-pi-alpine:3.6

RUN apk add --no-cache raspberrypi raspberrypi-libs raspberrypi-dev usbutils gcc

RUN apk add --no-cache build-base cmake eudev-dev git python3-dev swig \
    && git clone --depth 1 -b p8-platform-2.1.0.1 https://github.com/Pulse-Eight/platform /usr/src/platform \
    && mkdir -p /usr/src/platform/build \
    && cd /usr/src/platform/build \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr .. \
    && make \
    && make install \
    && cd /usr/src \
    && rm -rf platform \
    && git clone --depth 1 -b libcec-4.0.2 https://github.com/Pulse-Eight/libcec /usr/src/libcec \
    && mkdir -p /usr/src/libcec/build \
    && cd /usr/src/libcec/build \
    && cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr \
        -DRPI_INCLUDE_DIR=/opt/vc/include \
        -DRPI_LIB_DIR=/opt/vc/lib \
        -DPYTHON_LIBRARY="/usr/lib/libpython3.6m.so" \
        -DPYTHON_INCLUDE_DIR="/usr/include/python3.6m" .. \
    && make \
    && make install \
    && echo "cec" > "/usr/lib/python3.6/site-packages/cec.pth" \
    && cd /usr/src \
    && rm -rf libcec \
    && apk del build-base cmake eudev-dev git \
           python3-dev swig

ENV LD_LIBRARY_PATH=/opt/vc/lib:${LD_LIBRARY_PATH}

RUN apk add --no-cache python3 && \
    python3 -m ensurepip && \
    rm -r /usr/lib/python*/ensurepip && \
    pip3 install --upgrade pip setuptools gunicorn && \
    rm -r /root/.cache

COPY ./app/requirements.txt /tmp/requirements.txt
RUN pip3 install -qr /tmp/requirements.txt \
    && rm /tmp/requirements.txt

RUN mkdir -p /opt/app
COPY ./app /opt/app/

WORKDIR /opt/app
ENTRYPOINT ["gunicorn"]
CMD ["app:app", "-b", "0.0.0.0:4711"]

EXPOSE 4711