# Use a secure base image
FROM gcr.io/distroless/nodejs:18

# Set working directory
WORKDIR /app

# Create a non-root user
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Copy package files and install dependencies securely
COPY --chown=appuser:appgroup ./app/package.json ./app/package-lock.json ./
RUN npm ci --only=production

# Copy application code
COPY --chown=appuser:appgroup . .

# Switch to non-root user
USER appuser

# Expose application port
EXPOSE 4000

# Run the application
CMD ["node", "index.js"]
 
