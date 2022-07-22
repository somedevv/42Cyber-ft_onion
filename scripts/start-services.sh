echo '[+] Starting ssh'

/usr/sbin/sshd -D &
echo '[+] Starting tor' &
tor

echo "Onion service URL: http://$( cat /var/lib/tor/hiddenservicename/hostname )" & 
sed -i "s/server_name _;/server_name $( cat /var/lib/tor/hiddenservicename/hostname );/" /etc/nginx/sites-available/default & 
echo '[+] Starting nginx\n' 

nginx & 
sleep infinity