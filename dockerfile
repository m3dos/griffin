# Official LTS from node
FROM node:22.13.0-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY . . 

EXPOSE 3000
CMD ["npm", "start"]