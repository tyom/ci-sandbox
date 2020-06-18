# CircleCI TestCafe in Docker containers

Run TestCafe and Next.js app in separate Docker containers and use Docker network
to allow internal communication.
 
CircleCI doesn't allow access from its own Docker container to another Docker
container running within so this is a workaround to be able to connect to a
Docker container internally.  
