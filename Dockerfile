FROM debian:stretch-slim


LABEL version="1.0"
LABEL description="A simple web base image for Symfony project."
LABEL maintainer="Nicolas DOUSSON"


RUN apt-get update

RUN echo 'Installation of usefull librairies : Start'
RUN apt-get install -y unzip \ 
    gnupg
RUN echo 'Installaton of usefull librairies : Done'


RUN echo 'Installaton of Apache : Start'
RUN apt-get install -y apache2
RUN a2enmod rewrite env
RUN service apache2 restart
RUN echo 'Installaton of Apache : Done'


RUN echo 'Installation of Sury package for PHP 7.0+ : Start'
RUN apt-get -y install curl apt-transport-https lsb-release ca-certificates
RUN curl -ssL -o /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg
RUN sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list'
RUN echo 'Installation of Sury package : Done'


RUN echo 'Installation of PHP v7.2 : Start'
RUN apt-get update
RUN apt-get install -y php7.2
RUN php -v
RUN echo 'Installation of PHP v7.2 : Done'


RUN echo 'Installation of NodeJS : Start'
RUN curl -sL https://deb.nodesource.com/setup_11.x | bash -
RUN apt-get install -y nodejs
RUN echo 'Installation of NodeJS : Done'


RUN echo 'Installation of Yarn : Start'
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN sh -c 'echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list'
RUN apt-get update
RUN apt-get install -y yarn
RUN yarn --version
RUN echo 'Installation of Yarn : Done'


RUN echo 'Installation of Composer : Start'
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
RUN composer --version
RUN echo 'Installation of Composer : Done'


RUN echo 'Installation of Symfony requierements : Start'
RUN apt-get install -y php7.2-xml \
    php7.2-curl \
    php7.2-mbstring \
    php7.2-zip
RUN echo 'Installation of Symfony requierements : Done'


WORKDIR /var/www/html
EXPOSE 80


CMD [ "apache2ctl", "-D", "FOREGROUND" ]