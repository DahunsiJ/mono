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
COPY --chown=appuser:appgroup app/package.json app/package-lock.json ./

# Switch to the non-root user for security
USER appuser

# Clean npm cache before installing dependencies
RUN npm cache clean --force

# I increased timeout for npm installation
RUN npm config set fetch-timeout 60000

# Force a clean install
RUN rm -rf node_modules package-lock.json

# Install dependencies (I just replaced `npm ci` with `npm install`)
RUN npm install --only=production --loglevel verbose

# Copy the remaining application files
COPY --chown=appuser:appgroup app/ ./ 

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
