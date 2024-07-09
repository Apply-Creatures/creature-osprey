
<!-- PROJECT SHIELDS -->
[![Codacy Badge][codacy-shield]][codacy-url]
[![Issues][issues-shield]][issues-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![repo-size][repo-size-shield]][repo-size-url]
[![Contributors][contributors-shield]][contributors-url]
[![license][license-shield]][license-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">

  <h3 align="center">Creature Pigeon</h3>

   <a href="#">
      <img src="./images/radicle-logo.png" alt="Radicle logo" width="30%">
   </a>

  <p align="center">
    A Container for Radicle
    <br />
    <a href="#"><strong>See live (soon) »</strong></a>
    <br />
    <br />
    <a href="https://github.com/apply-creatures/radicle-seed-node/issues">Report Bug</a>
    ::
    <a href="https://github.com/apply-creatures/radicle-seed-node/issues">Request Feature</a>
  </p>
</div>

<p align="center">
OK, DOkey
</p>

<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
      <ol>
         <li>
            <a href="#about">About</a>
            <ul>
                <li>
                    <a href="#built-with">Built With</a>
                </li>
            </ul>
         </li>
         <li>
         <a href="#getting-started">Getting Started</a>
         <ul>
            <li><a href="#prerequisites">Prerequisites</a></li>
            <li><a href="#repo">Repo</a></li>
            <li><a href="#develop">Develop</a></li>
            <li><a href="#build">Build</a></li>
            <li><a href="#deploy">deploy</a></li>
         </ul>
         </li>
         <li><a href="#roadmap">Roadmap</a></li>
         <li><a href="#contributing">Contributing</a></li>
         <li><a href="#license">License</a></li>
         <li><a href="#acknowledgments">Acknowledgments</a></li>
      </ol>
</details>

<hr/>

**TL;DR** - skip to [getting-started](#getting-started)


<hr/>

<!-- ABOUT THE PROJECT -->

## About

This project is to facilitate launching and operating a Radicle Seed Node via docker containers. The goal is to automate the process of planting a Radicle Seed node in a Docker supported environment - removing the manual process of setting up and hosting the seed node on your local or remote machine.


### Motivation and Context

Hosting a Radicle seed node on your local machine 24/7 would not be a good idea. For public repos there are some buene amigos seeders out there, but for private stuff you need your own seedinfg host. 

*Why not just use Github/Gitlab?*

Because Microsoft doesn't respect privacy. Gitlab and other centralized git services seem to enjoy building AI solutions, what do you think they train their models with?

So I created a container that can run a Radicle seed node anywhere in any environments.

## Features

* Turn key ready OCI compliant container
* Run locally, or elsewhere
* Shell script to set everything up
* Deployment tested on some PaaS
* An acceptance security posture
* Web server for Radicle browser UI and convenience
* A separate mount for repositories so that only git repos data gets backed up

Of course, nothing is perfect, but I will try to keep this up to date and fix issues right here.
If you've truly tried everything and still can't get this to work for you, try to reach out. Or raise an issue. But I make no promise.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

- [docker](https://docker.com) - of course, but [you don't have to](https://opencontainers.org/).
- [radicle](https://radicle.xyz/) - that's beast!

### Also using

- [caddy](https://caddyserver.com/) - as reverse proxy. Because why not **caddy**. 


<hr/>

<!-- GETTING STARTED -->

## Getting Started

### Prerequisites

- you need [Docker](https://docker.com) installed
- or [podman](https://podman.io) or something that can handle containers
- you need `ssh-agent`
- you may need to install [fly.io](https://fly.io) to test it on the cloud environment. (Optional)

### Set up and run locally

```bash
$ git clone https://github.com/apply-creatures/creature-pigeon.git
```

Navigate to the repo root's folder and build the container
```bash
$ cd ./creature-pigeon
```

1. Build the Docker Image

```bash
docker build -t radicle-node .
```

If you don't want to cache the docker build, use this command

```bash
docker build --no-cache -t radicle-node-image .
```

2. Run the docker container

```bash
docker run --name radicle-node-container -dp 8776:8776 radicle-node-image
```

### Deploy on fly.io

Best is to deploy the thing somewhere. Here is how:


**a. "<em>Pigeon! Fly!</em>" - Launch**

```bash
# This command will setup your container and deploy it right away. It will create 2 virtual machines by default.  
$ fly launch
```


```bash
# Use this command if you don't want auto scaling/immediate deploy for your container.
$ fly launch --no-deploy --ha=false
```

**b. Set the secrets for your Radicle identity**

```bash
$ fly secrets set RAD_PASSPHRASE=secretpassphrase
```

**c. Create volume for your Radicle container**
```bash
# This creates a volume called radicle_volumes in region waw (Kraków)
$ fly volumes create radicle_volumes -r waw
```

**d. Deploy**

```bash
$ fly deploy
```

**Note**: You can use this command to re-deploy the container when changes were made, or when `--no-deploy` tag was used in the `fly launch` command to deploy the app.

If there is any confusion trying to deploy, please visit [fly.io](https://fly.io/docs) to have further understandings.

### Connect to your Radicle container node
Once you have successfully run you container locally or remotely, it is time to make connections to your containerized Radicle seed node. In order to do so, you need to do some configurations to your host Radicle node. 

**Note:** Make sure you stop your host Radicle node before performing these steps.

1. Navigate to your Radicle directory (normally `.radicle`)
```bash
# This directory contains all configurations and files needed to start your node
$ cd /path/to/.radicle
```

2. Add the container node's address to some fields of the `config.json` file and save your changes

```bash
{  
   "preferredSeeds": ["<node-address>"],
   ...
   "node": {
      "listen": ["0.0.0.0:8776"],
      ...
      "connect": ["<node-address>"],
      "externalAddresses": ["<your-hostname>:<port>"],
      ...
   }
}
```

3. Start your host Radicle seed node
```bash
$ eval `ssh-agent` # Start running SSH agent
$ rad auth  # Add the keys to your Radicle identity
$ rad node start # Start the host node
```

4. Connect to the host Radicle seed node
```bash
$ rad node connect <node-address>
```

5. Verify if the connection is successful or not
```bash
$ rad node status
```

A successful connection will have output similar to this
```bash
✓ Node is running and listening on 0.0.0.0:8776.

╭────────────────────────────────────────────────────────────────────────────────────────────────────────────╮
│ Peer                                               Address                         State       Since       │
├────────────────────────────────────────────────────────────────────────────────────────────────────────────┤
│ z6MkjvUk2LPQZmMhWEZ9qPjUUtG9zGXFYMUaxjMMLFXL1w8F   creature-radicle.fly.dev:8776   connected   2.214 seco… │
╰────────────────────────────────────────────────────────────────────────────────────────────────────────────╯

2024-07-08T23:21:48.863+07:00 INFO  service  Received command QueryState(..)
2024-07-08T23:21:49.328+07:00 INFO  service  Connected to z6MkjvUk2LPQZmMhWEZ9qPjUUtG9zGXFYMUaxjMMLFXL1w8F (creature-radicle.fly.dev:8776) (Outbound)
2024-07-08T23:21:49.329+07:00 INFO  service  Connected to z6MkpzcieiF9gDXHHNMfpEzf6D6FjD5wFfYz457DHi5isSnh (creature-radicle.fly.dev:8776) (Outbound)
2024-07-08T23:21:49.329+07:00 INFO  service  Connected to z6MksCFEJVyHBpGNY5Ln3q5oJYE84choMFULnGzMjHLZQhH8 (creature-radicle.fly.dev:8776) (Outbound)
2024-07-08T23:21:49.633+07:00 INFO  service  Disconnected from z6MkpzcieiF9gDXHHNMfpEzf6D6FjD5wFfYz457DHi5isSnh (connection reset)
2024-07-08T23:21:49.652+07:00 WARN  service  Not enough available peers to connect to (available=0, target=8)
2024-07-08T23:21:49.879+07:00 INFO  service  Disconnected from z6MksCFEJVyHBpGNY5Ln3q5oJYE84choMFULnGzMjHLZQhH8 (connection reset)
2024-07-08T23:21:49.898+07:00 WARN  service  Not enough available peers to connect to (available=0, target=8)
2024-07-08T23:21:51.213+07:00 INFO  service  Received command ListenAddrs
2024-07-08T23:21:51.214+07:00 INFO  service  Received command QueryState(..)
```


### Clone the Radicle repository
After successfully connected to the container seed node, all is left for us to do is to clone the Radicle repository to start working on it. 

```bash
$ rad clone <repository-id> --scope followed
```

Congratulations! You've cloned the Radicle repository on your host machine. You can now proceed to make changes and contribute to the private repository.

If you want to know how to push, checkout or issue to the Radicle repository, you can head to [Radicle](https://radicle.xyz/guides)'s guides to find your answers.

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<hr/>

## Roadmap

- [x] Write a Dockerfile.
- [x] Write a Shell Script for automating setups.
- [x] Test on local machine.
- [x] Deploy to a PaaS.
- [x] Connect to deployed node from local machine.
- [x] Persist the Radicle identity and its configurations.
- [ ] Safeguard the container from security concerns.

<hr/>

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. fork the Project
2. create your Feature Branch (`git checkout -b feature/some-feature`)
3. commit your Changes (`git commit -m 'Add some feature'`)
4. push to the Branch (`git push origin feature/some-feature`)
5. open a Pull Request

<hr/>

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<hr/>

## Acknowledgments

It would never end. I've done this work not just off dozens of other people's open source work, but hundreds, thousands, or maybe millions.


<!-- Refs -->

[codacy-url]: https://app.codacy.com/gh/apply-creatures/radicle-seed-node/dashboard
[codacy-shield]: https://img.shields.io/codacy/grade/appid?style=for-the-badge
[contributors-shield]: https://img.shields.io/github/contributors/apply-creatures/radicle-seed-node.svg?style=for-the-badge
[contributors-url]: https://github.com/apply-creatures/radicle-seed-node/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/apply-creatures/radicle-seed-node.svg?style=for-the-badge
[forks-url]: https://github.com/apply-creatures/radicle-seed-node/network/members
[stars-shield]: https://img.shields.io/github/stars/apply-creatures/radicle-seed-node.svg?style=for-the-badge
[stars-url]: https://github.com/apply-creatures/radicle-seed-node/stargazers
[issues-shield]: https://img.shields.io/github/issues/apply-creatures/radicle-seed-node.svg?style=for-the-badge
[issues-url]: https://github.com/apply-creatures/radicle-seed-node/issues
[license-shield]: https://img.shields.io/github/license/apply-creatures/radicle-seed-node.svg?style=for-the-badge
[license-url]: https://github.com/apply-creatures/radicle-seed-node/blob/main/LICENSE
[score-shield]: https://img.shields.io/ossf-scorecard/github.com/apply-creatures/radicle-seed-node?style=for-the-badge
[score-url]: https://github.com/apply-creatures/radicle-seed-node
[repo-size-shield]: https://img.shields.io/github/repo-size/apply-creatures/radicle-seed-node?style=for-the-badge
[repo-size-url]: https://github.com/apply-creatures/radicle-seed-node/archive/refs/heads/main.zip
[product-screenshot]: images/apply-creatures-logo.png

## Changelog

Changelog see [here](CHANGELOG.md)

## License

[![license][license-shield]][license-url]


If you too produce work and publish it out there, it's clearer to choose a [license](https://choosealicense.com).

```markdown
MIT License

Copyright (c) 2024 Bachiro, Apply Creatures

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
