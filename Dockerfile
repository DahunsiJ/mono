# Stage 1: Build stage
FROM node:18 as build

# Set up a non-root user for security
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Set the working directory
WORKDIR /app

# Copy package files and install dependencies securely
COPY --chown=appuser:appgroup package.json package-lock.json ./
RUN npm ci --only=production

# Copy the remaining application files
COPY --chown=appuser:appgroup . .

# Build the application 
RUN npm run build

# Stage 2: Production stage
FROM gcr.io/distroless/nodejs:18

# Set the working directory
WORKDIR /app

# Copy built application and dependencies from the build stage
COPY --from=build --chown=nonroot:nonroot /app /app

# Preserve the user and group details
COPY --from=build /etc/passwd /etc/passwd
COPY --from=build /etc/group /etc/group

# Use non-root user for better security
USER appuser

# Expose the application port
EXPOSE 4000

# Start the application using absolute path
CMD ["/nodejs/bin/node", "/app/index.js"]
