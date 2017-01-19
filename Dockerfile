#Pull node from Docker Hub ( https://hub.docker.com/_/node/)
#Image that we pull already come with Node.js and NPM already installed
FROM node:boron


#Add dump-init
RUN wget https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64.deb
RUN dpkg -i dumb-init_*.deb
#RUN wget -O /usr/local/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v1.2.0/dumb-init_1.2.0_amd64
#RUN chmod +x /usr/local/bin/dumb-init


# Runs "/usr/bin/dumb-init -- /my/script --with --args"
ENTRYPOINT ["/usr/bin/dumb-init", "--"]

#Add non root for security purposes
RUN groupadd -r nodejs \
  && useradd -m -r -g nodejs nodejs


USER nodejs

#Create app directory
RUN mkdir -p /home/nodejs/testnodejs
WORKDIR /home/nodejs/testnodejs

#Install app dependencies
COPY package.json /home/nodejs/testnodejs/
RUN npm install  --production

#Bundle app source
COPY . /home/nodejs/testnodejs

#Set env
ENV NODE_ENV production

#Our app binds to port 8080 , therefore need to map it using EXPOSE
EXPOSE 8080

#We need to define command to run you app using CMD
CMD [ "npm", "start" ]

