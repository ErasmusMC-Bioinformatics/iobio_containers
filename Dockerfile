FROM node:13 as build
    MAINTAINER Dennis Dollée

WORKDIR /app
COPY gene.iobio/ ./gene.iobio/
COPY clin.iobio/ ./clin.iobio/

RUN cd ./clin.iobio \
    && npm i --package-lock-only \
    && npm ci \
    && cd /app
RUN cd ./gene.iobio \
    && npm i --package-lock-only \
    && npm ci \
    && cd /app

RUN cd /app/gene.iobio && bash build.sh prod && \
    cd /app/clin.iobio && npm run build
RUN rm /app/gene.iobio/deploy/index.html && cp -f -r /app/gene.iobio/server/views/index.html /app/gene.iobio/deploy/index.html && \
    rm /app/gene.iobio/deploy/data && cp -f -r /app/gene.iobio/client/data /app/gene.iobio/deploy/data && \
    rm /app/gene.iobio/deploy/assets && cp -f -r /app/gene.iobio/client/assets /app/gene.iobio/deploy/assets && \
    rm /app/gene.iobio/deploy/js/thirdparty && cp -f -r /app/gene.iobio/client/js/thirdparty /app/gene.iobio/deploy/js/thirdparty && \
    rm /app/gene.iobio/deploy/app/third-party && cp -f -r /app/gene.iobio/client/app/third-party /app/gene.iobio/deploy/app/third-party && \
    rm /app/gene.iobio/deploy/dist/build.js && cp -f -r /app/gene.iobio/client/dist/build.js /app/gene.iobio/deploy/dist/build.js && \
    rm /app/gene.iobio/deploy/dist/build.js.map && cp -f -r /app/gene.iobio/client/dist/build.js.map /app/gene.iobio/deploy/dist/build.js.map


FROM nginx:alpine as production
COPY --from=build /app/gene.iobio/deploy /usr/share/nginx/html/gene
COPY --from=build /app/clin.iobio/dist /usr/share/nginx/html/clin
COPY default.conf /etc/nginx/conf.d/


RUN sed -i 's|http://localhost:4026|https://gene.iobio.io|g' /usr/share/nginx/html/clin/js/app.*.js


CMD ["nginx", "-g", "daemon off;"]
