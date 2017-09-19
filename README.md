# HDMI REST API
This project was created to control HDMI devices connected to a Raspberry Pi B over a REST API. The main purpose is to create an interface to control "non-smart" over HTTP requests. Additionally I wanted to play around with docker and teach me some python. If you want to build the image on another version of Pis just change the base image.

# How to use it?
First of all you have to build the image with ```docker build -t hdmi-rest-api .``` which tooks ages to finish on my Pi (~20min). In the future the build process could be speeded up, if the alpine package libcec has been compiled with RPI support enabled (see [alpine issue 7754](http://bugs.alpinelinux.org/issues/7754)). At the moment we have to compile it on our own. Used compiling instructions for libcec are basically copied from the project [home-assistant](https://github.com/home-assistant/hassio-build/blob/757dd45e46ae52227b51655d134154c5d8aa1942/homeassistant/machine/raspberrypi) which is licensed under Apache 2.0.

If you have created the docker image just run the container with following command ```docker run --device=/dev/vchiq -p 4711:4711 hdmi-rest-api```. To give docker access to the HDMI devices ```/dev/vchiq``` needs to be mounted. The port currently used by the python app is ```4711```.
