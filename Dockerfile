FROM cha53c/basic_builds:v5

ENV NGINX_HOME /opt/nginx
ENV APP_DIR my_webapp
ENV WEB_ROOT /var/www
ENV APP_HOME /var/www/$APP_DIR

RUN gem install bundler rails 
RUN gem install passenger -v '=5.0.6'
# ruby passenger gem method of installing passenger nginx
RUN passenger-install-nginx-module --auto-download --auto --prefix=$NGINX_HOME --languages ruby

# Install Postfix as send only SMTP server
CMD debconf-set-selections <<< 'postfix postfix/mailname string gibraltarbargains.com'
CMD debconf-set-selections <<< 'postfix postfix/main_mailer_type string "Internet Site"'
RUN apt-get update && apt-get install -y mailutils && apt-get install -y rsyslog && apt-get clean
RUN sed -i "s/^\(inet_interfaces\s*=\s*\).*\$/\1localhost/" /etc/postfix/main.cf
# do we need to set the FQDN in /etc/mailname 

# allow installed gems to be cashed if they have not changed
WORKDIR /tmp
ADD $APP_DIR/Gemfile Gemfile
ADD $APP_DIR/Gemfile.lock Gemfile.lock
RUN bundle install

# install nginx config
RUN mv $NGINX_HOME/conf/nginx.conf $NGINX_HOME/conf/nginx.conf.bck
COPY ./nginx.conf $NGINX_HOME/conf/

# Copy the rails app
COPY $APP_DIR $APP_HOME
RUN chmod -R 755 $WEB_ROOT && chown -R www-data:www-data $WEB_ROOT

# Setup up database
WORKDIR $APP_HOME
RUN bundle exec rake db:schema:load && bundle exec rake db:seed

#create the db file to use default config
RUN touch $APP_HOME/db/development.sqlite3 \
  && chmod 777 $APP_HOME/db/development.sqlite3

#Set readline to use vi
RUN touch ~/.inputrc && echo 'set editing-mode vi' >> ~/.inputrc

# Remove unused file
RUN rm -rf features test spec db/schema.rb db/seeds.rb db/migrate .drone.yml \
.gitignore .rspec Capfile README.rdoc /tmp/*

#ENV SECRET_KEY_BASE ?????

EXPOSE 80 
CMD ["/opt/nginx/sbin/nginx", "-g", "daemon off;"]

