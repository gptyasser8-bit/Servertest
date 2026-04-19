FROM alpine:latest

# تثبيت الأدوات الضرورية
RUN apk add --no-cache ca-certificates curl unzip envsubst

# تحميل V2Ray
RUN mkdir /v2ray_bin && \
    curl -L https://github.com/v2fly/v2ray-core/releases/latest/download/v2ray-linux-64.zip -o /v2ray.zip && \
    unzip /v2ray.zip -d /v2ray_bin && \
    chmod +x /v2ray_bin/v2ray && \
    rm /v2ray.zip

# إنشاء ملف إعدادات مرن (Template)
RUN echo '{"log":{"loglevel":"none"},"inbounds":[{"port":${PORT},"protocol":"vless","settings":{"clients":[{"id":"00000000-0000-0000-0000-000000000000"}],"decryption":"none"},"streamSettings":{"network":"ws","wsSettings":{"path":"/v2ray-path"}}}],"outbounds":[{"protocol":"freedom"}]}' > /config.json.template

# تشغيل السيرفر مع استبدال بورت ريندر في وقت التشغيل
CMD envsubst '\${PORT}' < /config.json.template > /config.json && /v2ray_bin/v2ray run -c /config.json
