FROM httpd:2.4

# Copy your custom HTML to the default Apache document root
COPY ./public-html/ /usr/local/apache2/htdocs/

EXPOSE 80