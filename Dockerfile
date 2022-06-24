FROM node:13 as build
    MAINTAINER Dennis Dollée

WORKDIR /usr/src/
COPY gene.iobio/package*.json ./gene.iobio/
COPY clin.iobio/package*.json ./clin.iobio/

RUN cd ./clin.iobio \
    && npm ci \
    && cd ../gene.iobio \
    && npm ci \
    && cd /usr/src

COPY . .

RUN cd ./gene.iobio && bash build.sh prod \
    cd ../clin.iobio && npm run build

FROM nginx:alpine as production
COPY --from=build /usr/src/gene.iobio/deploy /usr/share/nginx/html/gene
COPY --from=build /usr/src/clin.iobio/dist /usr/share/nginx/html/clin
COPY --from=build /usr/src/default.conf /etc/nginx/conf.d/
CMD ["nginx", "-g", "daemon off;"]
