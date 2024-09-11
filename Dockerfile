# Use the official Node.js Alpine image as a base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install app dependencies, only production dependencies
RUN npm install --production

# Copy the entire app to the working directory
COPY . .

# Expose the port the app runs on
EXPOSE 3000

# Start the Node.js app
CMD [ "node", "app.js" ]
