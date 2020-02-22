FROM lzzeng/node-gitbook-cli:alpine AS build

WORKDIR /srv
COPY . .
RUN  gitbook install
#    gitbook build . public


#FROM httpd:2.4 AS final
#COPY --from=build /srv/public /usr/local/apache2/htdocs/

CMD ["sh", "-c", "gitbook serve"]
