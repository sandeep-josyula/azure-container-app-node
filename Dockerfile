# Use Node image from Docker Hub
FROM node:16-alpine

# Set working directory. 
WORKDIR /app

# Copy the package, package-lock json files
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy parent directory ( where the Dockerfile is located )
COPY . .

# Expose port 3000
EXPOSE 3000

# Command to execute
CMD [ "npm", "start" ]

