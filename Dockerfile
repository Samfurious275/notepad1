# Use a specific NGINX version for stability
FROM nginx:1.23


# Start NGINX in the foreground
CMD ["nginx", "-g", "daemon off;"]
