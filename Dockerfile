FROM opensuse/leap:15.6

ADD ansible /ansible/ 
ADD init.sh /ansible/ 

WORKDIR /ansible/

RUN zypper --non-interactive in --auto-agree-with-licenses python3 python3-PyYAML python3-requests ansible git which wget acl perl-rrdtool make gcc munin 
RUN cpan install CGI::Fast 
RUN ls -la /ansible/
RUN ansible-playbook local.yml -c local
RUN zypper rm --clean-deps -y make gcc ansible
RUN rm -rf /ansible/roles /ansible/local.yml
RUN chmod +x init.sh

ENV INVENTORY_GEN="repo" \ 
    HOSTS_REPO="https:\/\/your\/repo.git" \
    HOSTS_LIST="1 10 node domain" \
    HOSTS_URL="https:\/\/example.com\/munin_inventory" \
    APACHE_REQUIRE="all granted" \
    APACHE_DOMAIN="munin" \
    APACHE_MAIL="admin@munin"\
    TIMEZONE="/Europe/Paris"

EXPOSE 80
EXPOSE 4949

VOLUME /etc/munin/
VOLUME /etc/apache2/vhosts.d/
VOLUME /var/lib/munin/

ENTRYPOINT ["./init.sh"]
CMD ["/usr/sbin/apachectl", "start",  "-DFOREGROUND"]
