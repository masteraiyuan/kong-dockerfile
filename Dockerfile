FROM kong:1.0.3

RUN  apk update && apk add logrotate

COPY logrotate/nginx /etc/logrotate.d/

CMD kong start --nginx-conf /etc/kong/nginx.template
