FROM alpine:latest

RUN apk add --no-cache ca-certificates curl unzip

# تحميل وتجهيز V2Ray
RUN mkdir /v2ray_bin && \
    curl -L https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o /v2ray.zip && \
    unzip /v2ray.zip -d /v2ray_bin && \
    chmod +x /v2ray_bin/v2ray && \
    rm /v2ray.zip

# إعداد الإعدادات (رندر يستخدم بورت متغير، لذا سنستخدم PORT كمغير بيئة)
# المعرف UUID: 00000000-0000-0000-0000-000000000000
RUN echo '{"log":{"loglevel":"none"},"inbounds":[{"port":10000,"protocol":"vless","settings":{"clients":[{"id":"00000000-0000-0000-0000-000000000000"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"/v2ray-path"}}}],"outbounds":[{"protocol":"freedom"}]}' > /config.json

# تشغيل السيرفر على البورت الذي يحدده رندر تلقائياً
CMD /v2ray_bin/v2ray run -c /config.json
