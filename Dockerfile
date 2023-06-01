FROM devopsedu/webapp
COPY . /var/www/html
CMD ["apache2ctl", "-D", "FOREGROUND"]
EXPOSE 80

