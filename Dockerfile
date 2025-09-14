# Stage 1: build
FROM node:18-alpine as builder
WORKDIR /app


# copy package files first to leverage Docker cache
COPY package*.json ./
# if you use package-lock.json/npm-shrinkwrap use npm ci for reproducible builds
RUN npm ci --silent


# copy rest of project
COPY . .


# build the React app
RUN npm run build


# Stage 2: serve with nginx
FROM nginx:alpine
# remove default nginx content
RUN rm -rf /usr/share/nginx/html/*


# copy build output to nginx html directory
COPY --from=builder /app/build /usr/share/nginx/html


# optional: copy custom nginx config if you have one
# COPY nginx.conf /etc/nginx/conf.d/default.conf


EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
