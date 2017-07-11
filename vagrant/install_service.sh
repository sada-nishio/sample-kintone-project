#! /bin/bash -e

WEB_SERVER=$1
[ -z ${WEB_SERVER} ] && WEB_SERVER="httpd"

#Create PATH
SC_PATH="/kintone-dev"
SC_PATH_SOURCE="${SC_PATH}/"
SC_PATH_SSL="/etc/kintone-dev-ssl"

#Check folder exist and create
[ ! -d $SC_PATH ] && mkdir -p $SC_PATH
[ ! -d $SC_PATH_PROJECT ] && mkdir -p $SC_PATH_PROJECT
[ ! -d $SC_PATH_SSL ] && mkdir -p $SC_PATH_SSL

# Update package ...
echo -e "\Update current package..."
yum update -y

# install package
echo -e "\nInstalling epel-release..."
yum install epel-release -y
echo -e "\nInstalling package require for build kintone plugin..."
yum install openssh expect zip -y
echo -e "\nInstalling golang..."
yum install golang mercurial -y
echo -e "\nInstalling httpd..."
yum install httpd -y
echo -e "\nInstalling nodejs..."
yum install nodejs -y

#NPM
echo -e "\nInstalling npm package...."
yum install npm -y

#Config npm package for Vagrant...."
echo "alias npm='npm --no-bin-links'" >> /home/vagrant/.bashrc

#
echo -e "\nInstalling another package..."
yum install git vim -y

#########################
  ## install SSL ##
#########################
echo -e "\nInstalling SSL..."
yum install -y mod_ssl openssl

domain=$(hostname)
commonname=$domain
country="JP"
state="Tokyo"
locality="Chuo-ku"
organization="Example Inc"
organizationalunit="Example Inc"
email="abc@example.com"
#Pasword - Optional
password=""

#Cert Path
PATH_SSL_KEY="${SC_PATH_SSL}/${domain}.key"
PATH_SSL_CSR="${SC_PATH_SSL}/${domain}.csr"
PATH_SSL_CERT="${SC_PATH_SSL}/${domain}.crt"
PATH_SSL_CONF="${SC_PATH_SSL}/openssl.cnf"
PATH_SSL_CONF_SAN="${SC_PATH_SSL}/openssl_san.cnf"

# Set DNS
cat /etc/pki/tls/openssl.cnf > "${PATH_SSL_CONF_SAN}"
printf "[ SAN ]\nsubjectAltName=DNS:${domain}" >> "${PATH_SSL_CONF_SAN}"

#Create SSL cert and key
openssl req -x509 -nodes -sha256 -days 3650 -new -newkey rsa:2048 \
-keyout $PATH_SSL_KEY -out $PATH_SSL_CERT -passin pass:$password \
-subj "/C=$country/ST=$state/L=$locality/O=$organization/OU=$organizationalunit/CN=$commonname/emailAddress=$email" \
-config "${PATH_SSL_CONF_SAN}" -reqexts SAN -extensions SAN

#########################
  ## install apache ##
#########################
if [ ${WEB_SERVER} = "httpd" ]; then
    echo -e "\nInstalling apache webserver..."
    yum install httpd php php-mysql  -y
    #Config webserver
    #disable auth
    sed -i -e 's/'"Require all denied"'/'""'/g' /etc/httpd/conf/httpd.conf

    #config host
    HOST_PATH_CONFIG="/etc/httpd/conf.d/${domain}.conf"
    cp -R /vagrant/host.conf.sample $HOST_PATH_CONFIG
    sed -i 's/'"_HOST_NAME_"'/'${domain////\\/}'/g' $HOST_PATH_CONFIG
    sed -i 's/'"_PATH_ROOT_"'/'${SC_PATH_SOURCE////\\/}'/g' $HOST_PATH_CONFIG
    sed -i 's/'"_PATH_SSL_CERT_"'/'${PATH_SSL_CERT////\\/}'/g' $HOST_PATH_CONFIG
    sed -i 's/'"_PATH_SSL_KEY_"'/'${PATH_SSL_KEY////\\/}'/g' $HOST_PATH_CONFIG

    [ -f /etc/httpd/conf.d/ssl.conf ] && mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.default
    [ -f /etc/httpd/conf.d/welcome.conf ] && mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.default
    systemctl restart httpd
else
    systemctl stop httpd
fi

###############################
  ## install npm webserver ##
###############################
if [ ${WEB_SERVER} = "nodejs" ]; then
    #install npm webserver: https://github.com/indexzero/http-server
	echo -e "\nInstalling npm http-server..."
    npm install http-server -g
    
# Create file force start webservice when vagrant reload
printf "pkill node
#HTTPS
http-server ${SC_PATH_SOURCE} -p 443 --ssl --cert ${PATH_SSL_CERT} --key ${PATH_SSL_KEY}  -i -d -g > /dev/null 2>&1 &
#HTTP
#http-server ${SC_PATH_SOURCE} -p 80 -i -d -g > /dev/null 2>&1 &
#Show status webserver
echo -e \"Status:\"
sleep 1
netstat -tnlp | grep -E \"80|443\"
" > "/vagrant/http-server-nodejs-start.sh"
    # Make sure file can execute
    chmod +x "/vagrant/http-server-nodejs-start.sh"
fi

##Force cd SCVN folder when login
if ! grep -Fxq "cd ${SC_PATH}" /root/.bash_profile
then
    echo "cd ${SC_PATH}" >> /root/.bash_profile
    echo 'export PROMPT_COMMAND="echo -n \[\$(date +%F\ %H:%M)\]\ "' >> /root/.bash_profile
fi
echo -e "\n\nINSTALL SERVICE COMPLETED!\n\n"

exit
