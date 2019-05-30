FROM mongo:4.1

ENV AUTH yes
ENV STORAGE_ENGINE wiredTiger
ENV JOURNALING yes

ADD run.sh usr/local/bin/run.sh
ADD set_mongodb_password.sh usr/local/bin/set_mongodb_password.sh

RUN ["chmod", "+x", "usr/local/bin/run.sh"]
RUN ["chmod", "+x", "usr/local/bin/set_mongodb_password.sh"]

CMD ["usr/local/bin/run.sh"]