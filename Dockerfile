FROM node:lts-alpine

RUN apk add --no-cache curl unzip

# تحميل V2Ray
RUN mkdir /v2ray_bin && \
    curl -L https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o /v2ray.zip && \
    unzip /v2ray.zip -d /v2ray_bin && \
    chmod +x /v2ray_bin/v2ray && \
    rm /v2ray.zip

# إنشاء ملف الإعدادات ووضع علامة PORT_NUMBER لنقوم بتبديلها لاحقاً
RUN echo '{"log":{"loglevel":"none"},"inbounds":[{"port":PORT_NUMBER,"protocol":"vless","settings":{"clients":[{"id":"00000000-0000-0000-0000-000000000000"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"/v2ray-path"}}}],"outbounds":[{"protocol":"freedom"}]}' > /config.json

# أمر التشغيل: استبدال الكلمة بقيمة البورت الحقيقية ثم تشغيل السيرفر
CMD sed -i "s/PORT_NUMBER/$PORT/g" /config.json && /v2ray_bin/v2ray run -c /config.json
