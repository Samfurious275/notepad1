# Use a specific NGINX version for stability
FROM nginx:1.23

# Copy all static files from the local /public directory to the NGINX directory
COPY /public /usr/share/nginx/html/

# Optionally, copy a custom NGINX configuration file
# COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80 for HTTP traffic
EXPOSE 80

# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
