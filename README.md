
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

  <h3 align="center">Radicle Seed Node Creature</h3>

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
* Web server for Radicle brwoser UI and convenience
* A separate mount for repositories so that only git repos data gets backed up

Of course, nothing is perfect, but I will try to keep this up to date and fix issues right here.
If you've truly tried everything and still can't get this to work for you, try to reach out. Or raise an issue. But I make no promise

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### Built With

- [docker](https://docker.com) - of course, but [you don't have to](https://opencontainers.org/).
- [radicle](https://radicle.xyz/) - that's beast

### Also using

- [caddy](https://caddyserver.com/) - as reverse proxy. Because why not caddy. 


<hr/>

<!-- GETTING STARTED -->

## Getting Started

### Prerequisites

- you need [Docker](https://docker.com) installed
- or [podman](https://podman.io) or something that can handle containers

### Set up and run locally

```bash
$ git clone https://github.com/apply-creatures/radicle-seed-node.git
```

Navigate to the repo root's folder and build the container

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
docker run -dp 8776:8776 radicle-node-container
```

### Deploy

Best is to deploy the thing somewhere. Here is how

#### Deploy on fly.io

**First time**

```bash
$ fly launch
```

**Redeploy**

```bash
$ fly deploy
```

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<hr/>

## Roadmap

- [x] Write a Dockerfile.
- [x] Write a Shell Script for automating setups.
- [x] Test on local machine.
- [x] Deploy to a PaaS.
- [ ] Connect to deployed node from local machine.
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
