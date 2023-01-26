FROM node:13-alpine as build
MAINTAINER Dennis Dollée

WORKDIR /app
#COPY gene.iobio/ ./gene.iobio/
COPY clin-code/ ./clin.iobio/


RUN set -eux; apk add --no-cache curl bash;

RUN cd ./clin.iobio \
    && npm install \
    && cd /app
#RUN cd ./gene.iobio \
#    && npm install \
#    && cd /app

#RUN cd /app/gene.iobio && bash build.sh prod && \
RUN cd /app/clin.iobio && npm run build
#RUN rm /app/gene.iobio/deploy/index.html && cp -f -r /app/gene.iobio/server/views/index.html /app/gene.iobio/deploy/index.html && \
#    rm /app/gene.iobio/deploy/data && cp -f -r /app/gene.iobio/client/data /app/gene.iobio/deploy/data && \
#    rm /app/gene.iobio/deploy/assets && cp -f -r /app/gene.iobio/client/assets /app/gene.iobio/deploy/assets && \
#    rm /app/gene.iobio/deploy/js/thirdparty && cp -f -r /app/gene.iobio/client/js/thirdparty /app/gene.iobio/deploy/js/thirdparty && \
#    rm /app/gene.iobio/deploy/app/third-party && cp -f -r /app/gene.iobio/client/app/third-party /app/gene.iobio/deploy/app/third-party && \
#    rm /app/gene.iobio/deploy/dist/build.js && cp -f -r /app/gene.iobio/client/dist/build.js /app/gene.iobio/deploy/dist/build.js && \
#    rm /app/gene.iobio/deploy/dist/build.js.map && cp -f -r /app/gene.iobio/client/dist/build.js.map /app/gene.iobio/deploy/dist/build.js.map

#RUN ls /app/gene.iobio/deploy/ && ls /app/gene.iobio/deploy/js/
RUN ls /app/clin.iobio/dist/ && ls /app/clin.iobio/dist/js/


#RUN cp -Rv /app/clin.iobio/dist/js/* /app/gene.iobio/deploy/js/
#RUN cp -Rv /app/clin.iobio/dist/img/* /app/gene.iobio/deploy/img/
#RUN cp -Rv /app/clin.iobio/dist/css/* /app/gene.iobio/deploy/css/
#RUN cp -Rv /app/clin.iobio/dist/fonts/* /app/gene.iobio/deploy/fonts/

#RUN cp -Rv /app/gene.iobio/deploy/js/* /app/clin.iobio/dist/js/
#RUN cp -Rv /app/gene.iobio/deploy/assets/ /app/clin.iobio/dist/
#RUN cp -Rv /app/gene.iobio/deploy/data/ /app/clin.iobio/dist/


#RUN sed -i "s|http://localhost:4026|http://'+window.location.hostname+'/gene|g" ./clin.iobio/src/components/pages/ClinHome.vue && ls ./clin.iobio/ && cat ./clin.iobio/src/components/pages/ClinHome.vue | grep 4026

#RUN sed -i "s|http://localhost:4026|http://'+window.location.hostname+':4002|g" ./clin.iobio/src/components/pages/ClinHome.vue && sed -i "s|frame_source=' + window.document.URL|frame_source=' + window.location.hostname + ':4002' + window.location.search|g" ./clin.iobio/src/components/pages/ClinHome.vue && ls ./clin.iobio/ && cat ./clin.iobio/src/components/pages/ClinHome.vue | grep frame_source
#RUN sed -i "s|http://localhost:4026|http://\"+window.location.hostname+\":4002|g" ./clin.iobio/src/components/pages/ClinHome.vue && ls ./clin.iobio/ && cat ./clin.iobio/src/components/pages/ClinHome.vue | grep frame_source
#RUN sed -i "s|https://clin.iobio.io|http://\"+window.location.hostname+\":4002|g" ./gene.iobio/client/app/components/pages/GeneHome.vue


FROM nginx:alpine as production
#COPY --from=build /app/gene.iobio/deploy /usr/share/nginx/html/gene
#COPY --from=build /app/clin.iobio/dist /usr/share/nginx/html/clin

#COPY --from=build /app/gene.iobio/deploy /usr/share/nginx/html/bak/gene
#COPY --from=build /app/clin.iobio/dist /usr/share/nginx/html/bak/clin

#RUN cp -Rfnv /usr/share/nginx/html/gene/* /usr/share/nginx/html/
#RUN cp -Rfnv /usr/share/nginx/html/clin/* /usr/share/nginx/html/
COPY --from=build /app/clin.iobio/dist /usr/share/nginx/html

#COPY --from=build /app/default.conf /etc/nginx/conf.d/

EXPOSE 4030
COPY default.conf /etc/nginx/conf.d/


RUN sed -i 's|http://localhost:4026|http://gene.iobio.io|g' /usr/share/nginx/html/js/app.*.js

CMD ["nginx", "-g", "daemon off;"]

