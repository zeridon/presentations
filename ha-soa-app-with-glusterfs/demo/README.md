GlusterFS Demo setup
====================
This demo is based on vagrant. It starts 3 boxes:
 * HAProxy load balancer (172.20.20.10)
 * 2x GlusterFS cluster members

On Initial start it will create VM's, install gluster and configure a base server.

The demo application is mostly useless but serves to demonstrate the principles of replication and updating the local state of data on change from the remote end.

The demo application is started by upstart. The unit file (conf/app.conf) takes care to start/stop the app and handle some dependencies.
