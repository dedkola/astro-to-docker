# Step 1: Use Node.js 18 as the base image
FROM node:18-alpine AS builder

# Step 2: Set the working directory inside the container
WORKDIR /app

# Step 3: Copy the package.json and package-lock.json (or yarn.lock) to /app
COPY package.json package-lock.json ./

# Step 4: Install dependencies
RUN npm install  # or RUN yarn install if you're using yarn

# Step 5: Copy the rest of the application files to /app
COPY . .

# Step 6: Build the Astro site
RUN npm run build  # This will generate the production-ready files

# Step 7: Use a lightweight server image (like nginx or node) for serving the static files
# Here, we're using nginx
FROM nginx:alpine AS runner

# Step 8: Copy the built Astro site from the builder stage
COPY --from=builder /app/dist /usr/share/nginx/html

# Step 9: Expose the port where nginx will serve the files (port 80 by default)
EXPOSE 80

# Step 10: Start nginx
CMD ["nginx", "-g", "daemon off;"]
