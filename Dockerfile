FROM node:12-alpine

ENV project_dir /project
WORKDIR "$project_dir"

COPY package.json "$project_dir"
COPY package-lock.json "$project_dir"
COPY src "$project_dir"
COPY test "$project_dir"

RUN npm install
RUN npm run build

CMD ["npm", "start"]
