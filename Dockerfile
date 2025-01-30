# Stage 1: Build stage
FROM node:18 AS build

# Set up a non-root user with a valid home directory for security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup --home /home/appuser appuser

# Set the working directory
WORKDIR /app

# I've set HOME environment variable for npm to avoid permission issues
ENV HOME=/home/appuser

# Ensure npm directories are writable
RUN mkdir -p /home/appuser/.npm && chown -R appuser:appgroup /home/appuser/.npm

# Copy package files and install dependencies securely
COPY app/package.json app/package-lock.json ./

# Ensure correct permissions for cleanup operations
RUN chmod -R u+w package-lock.json

# Run the cleanup before installing dependencies  
RUN rm -rf node_modules package-lock.json

# Install dependencies securely with a clean slate
RUN npm cache clean --force

# Increased timeout for npm installation to prevent timeouts in slow environments  
RUN npm config set fetch-timeout 60000

# Perform a clean dependency installation  
RUN npm install --only=production --loglevel verbose

# Copy the remaining application files  
COPY app/ ./ 

# Ensure the app files are owned by appuser  
RUN chown -R appuser:appgroup /app

# Switch to the non-root user for security  
USER appuser

# Build the application  
RUN npm run build

# Stage 2: Production stage  
FROM gcr.io/distroless/nodejs:18

# Set the working directory  
WORKDIR /app

# Copy built application and dependencies from the build stage  
COPY --from=build --chown=nonroot:nonroot /app /app

# Use non-root user for better security  
USER nonroot

# Expose the application port  
EXPOSE 4000

# Start the application using absolute path  
CMD ["/nodejs/bin/node", "/app/index.js"]
