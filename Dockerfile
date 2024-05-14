# Use an official Ubuntu base image
FROM ubuntu:20.04

# Set non-interactive installation to avoid prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary packages
RUN apt-get update && \
    apt-get install -y nginx openssl && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a directory for SSL certificates
RUN mkdir /etc/nginx/ssl

# Generate a self-signed SSL certificate and private key
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost"

# Remove the default NGINX configuration
RUN rm /etc/nginx/sites-enabled/default

# Add a custom NGINX config file
COPY nginx.conf /etc/nginx/sites-available/default

# Link the config file to the sites-enabled directory
RUN ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

# Expose port 80 and 443 for HTTP and HTTPS traffic
EXPOSE 80 443

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
