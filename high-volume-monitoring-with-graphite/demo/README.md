High Volume Monitoring Demo
===========================

This is minimalistic but fully functional demo for the Lecture

How to use
==========
* Install Vagrant
* Install vagrant plugin [vagrant-proxyconf](https://github.com/tmatilai/vagrant-proxyconf) (optional to speed up caching)
* Install some deb caching (apt-cache-ng)
* vagrant up
* python bin/loader.py

Some Notes
==========
Everything is shell

There are not a lot's of checks made

graphite-web is not functional (do it manually for now)

Host only networking is used for some isolation
