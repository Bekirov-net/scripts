#!/bin/sh
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo apt install php-fpm php-common php-mysql php-gmp php-curl php-intl php-mbstring php-xmlrpc php-gd php-xml php-cli php-zip -y
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo rm -rf /var/www/html/*
sudo mv wordpress/* /var/www/html
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/
sudo echo '		
server {
    listen 80;
    listen [::]:80;
    root /var/www/html;
    index  index.php index.html index.htm;
    server_name  wordpress;

    client_max_body_size 100M;
    autoindex off;
    location / {
        try_files $uri $uri/ /index.php?$args;
    }

    location ~ \.php$ {
         include snippets/fastcgi-php.conf;
         fastcgi_pass unix:/var/run/php/php-fpm.sock;
         fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
         include fastcgi_params;
    }
}
' > /tmp/default
sudo mv /tmp/default /etc/nginx/sites-available/default
sudo chmod -R 755 /etc/nginx/sites-available/default
sudo systemctl restart nginx
