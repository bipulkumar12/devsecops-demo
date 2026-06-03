# Build stage
FROM node:20-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build


# Production stage
FROM nginx:1.29-alpine

# Upgrade Alpine packages to pull security fixes
RUN apk update && apk upgrade --no-cache

# Copy built application
COPY --from=build /app/dist /usr/share/nginx/html

# Optional: remove default nginx page
RUN rm -f /usr/share/nginx/html/index.html

COPY --from=build /app/dist/* /usr/share/nginx/html/

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
