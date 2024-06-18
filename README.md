# A Container for Radicle Seed Node
This project is to launch a Radicle Seed Node to any PaaS by utilizing Docker containers. The goal is to automate the process of planting a Radicle Seed node on the could environments - removing the manual process of setting up and hosting the seed node on your local machine.

## 💡 About
Hosting a Radicle seed node on your local machine 24/7 would not be a good idea. We also need somewhere to host our repos without relying on platforms such as GitHub or GitLab.

So I created a container that can run a Radicle seed node anywhere in any environments.

## 🛠️ Setup 
1. Build the Docker Image

```
docker build -t radicle-node .
```


If you don't want to cache the docker build, use this command
```
docker build --no-cache -t radicle-node-image .
```

2. Run the docker container
```
docker run -dp 8776:8776 radicle-node-container
```

## Roadmap
- [x] Write a Dockerfile.
- [x] Write a Shell Script for automating setups.
- [x] Test on local machine.
- [x] Deploy to a PaaS.
- [ ] Connect to deployed node from local machine.
- [ ] Safeguard the container from security concerns.