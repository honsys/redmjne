#!/bin/csh -f
# to generate a self-signed certificate for use by tomcat:
keytool -genkey -alias tomcat -keyalg RSA -keystore honsys.keystore
# the server.xml conf must be edited with the indicated password...
# this is one way to see the public key in use by tomcat on port 8443:
# openssl s_client -connect honsys.net:8443
# the above command displays a master-key, which is presumably the public key
# above can be placed into sslcert.crt
# and the private key into sslcert.key via ...
# extract the private key:
keytool -v -importkeystore -srckeystore honsys.keystore -srcalias tomcat -destkeystore honsys.key -deststoretype PKCS12
#
# not sure if these keys can be used by a nodejs https app ala:
# nodejs code:
#var privateKey  = fs.readFileSync('sslcert.key').toString();
#var certificate = fs.readFileSync('sslcert.crt').toString();
#var credentials = {key: privateKey, cert: certificate};
#var https = http.createServer(credentials, server);
