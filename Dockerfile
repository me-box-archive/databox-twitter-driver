FROM node:argon

ADD package.json package.json
RUN npm install
ADD . .

LABEL databox.type="driver"
LABEL databox.manifestURL="http://datashop.amar.io/databox-twitter-driver/manifest.json"

EXPOSE 8080

CMD ["npm","start"]
