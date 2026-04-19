FROM node:lts-alpine

# تثبيت المتطلبات
RUN apk add --no-cache curl unzip

# تحميل نواة السيرفر
RUN mkdir /v2ray_bin && \
    curl -L https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o /v2ray.zip && \
    unzip /v2ray.zip -d /v2ray_bin && \
    chmod +x /v2ray_bin/v2ray && \
    rm /v2ray.zip

# إعداد ملف التكوين (سنستخدم بورت 10000 كقيمة افتراضية ونربطه بريندر)
RUN echo '{"log":{"loglevel":"debug"},"inbounds":[{"port":10000,"protocol":"vless","settings":{"clients":[{"id":"00000000-0000-0000-0000-000000000000"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"/v2ray-path"}}}],"outbounds":[{"protocol":"freedom"}]}' > /config.json

# تشغيل السيرفر باستخدام منفذ ريندر المتغير
CMD /v2ray_bin/v2ray run -c /config.json -port $PORT
