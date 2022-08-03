<div id="top"></div>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->

<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![LinkedIn][linkedin-shield]][linkedin-url]

<!-- PROJECT LOGO -->
<br />
<div align="center">
  <a href="https://github.com/ppfenning/docker-hadoop">
    <img src="media/hadoop.jpeg" alt="Hadoop" width="80" height="80">
  </a>

<h3 align="center">Best-README-Template</h3>

  <p align="center">
    An awesome README template to jumpstart your projects!
    <br />
    <a href="https://github.com/ppfenning/docker-hadoop"><strong>Explore the docs »</strong></a>
    <br />
    <br />
    <a href="https://github.com/ppfenning/docker-hadoop">View Demo</a>
    ·
    <a href="https://github.com/ppfenning/docker-hadoop/issues">Report Bug</a>
    ·
    <a href="https://github.com/ppfenning/docker-hadoop/issues">Request Feature</a>
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#usage">Usage</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#contact">Contact</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>


<!-- ABOUT THE PROJECT -->
## About The Project

[![Docker Hadoop][product-screenshot]](https://example.com)

> **GOAL:** Create a multihomed Hadoop solution over a self-contained subnetwork.

<p align="right">(<a href="#top">back to top</a>)</p>

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

* [docker-compose](https://docs.docker.com/compose/install/) _or with_ `pip install docker-compose`
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads)
* [Git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) 

#### Helpful (but not needed) tools

* [Docker Desktop](https://www.docker.com/products/docker-desktop/)
* [Portainer](https://www.portainer.io/install-BE-now)

### Installation

1. Clone the repo
   ```sh
   git clone https://github.com/ppfenning/docker-hadoop.git
   ```
2. Change directories to the install repo
   ```sh
   cd docker-hadoop
   ```
3. Deploy the network
   ```
   # local
   make
   
   # from dockerhub
   make LOCAL=0
   ```
> **_NOTE:_**  This command will build all necessary images and bring the network online



<p align="right">(<a href="#top">back to top</a>)</p>



<p align="right">(<a href="#top">back to top</a>)</p>


<!-- TODO -->
## TODO

- [X] Hadoop single namenode
- [x] Namenode with single datanode
- [x] Namenode with 2 datanodes
- [x] Namenode with _N_ datanodes __(max 6)__
- [x] Resource and Node managers
- [x] History server
- [x] Pig terminal node
- [x] Hive terminal node
- [x] Scale datanodes dynamically
- [X] Example Compose files to run jobs
- [X] Terminal endpoints for
  - [X] Hadoop
  - [X] Pig
  - [X] Hive
  - [ ] Spark
- [ ] Build with spark backend
- [ ] Create CLI rather than just Makefile

See the [open issues](https://github.com/ppfenning/docker-hadoop/issues) for a full list of proposed features (and known issues).

<p align="right">(<a href="#top">back to top</a>)</p>


<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#top">back to top</a>)</p>

License
=======
    Copyright 2022 Patrick Pfenning

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

<p align="right">(<a href="#top">back to top</a>)</p>



<!-- CONTACT -->
## Contact

- Patrick Pfenning - Data Science Master's candidate at Wentworth - ppfenning@wit.edu
- Github: [ppfenning](https://github.com/ppfenning)
- Project Link: [docker-hadoop](https://github.com/ppfenning/docker-hadoop)

<p align="right">(<a href="#top">back to top</a>)</p>

<!-- ACKNOWLEDGMENTS -->
## Acknowledgments

Use this space to list resources you find helpful and would like to give credit to. I've included a few of my favorites to kick things off!

* [Big Data Europe Repo](https://github.com/big-data-europe/docker-hadoop)
> This project was forked from Big Data Europe's repo. I couldn't have completed this without the base
* [The Apache Sortware Foundation](https://apache.org/)
> [Hadoop](https://hadoop.apache.org/), [Spark](https://spark.apache.org/), [Pig](https://pig.apache.org/) and [Hive](https://hive.apache.org/) are all open source Apache solutions!
* [Docker Cheatsheet](https://dockerlabs.collabnix.com/docker/cheatsheet/)
> I learned a ton about docker in this project...
* [phoenixNAP](https://phoenixnap.com/kb/)
> Helped a ton with property setup
* [Makefile Tutorial](https://makefiletutorial.com/)
* [Salem Othman](https://wit.edu/salem-othman) 
> My professor for Big Data Systems


<p align="right">(<a href="#top">back to top</a>)</p>


<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[contributors-shield]: https://img.shields.io/github/contributors/ppfenning/docker-hadoop.svg?style=for-the-badge
[contributors-url]: https://github.com/ppfenning/docker-hadoop/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/ppfenning/docker-hadoop.svg?style=for-the-badge
[forks-url]: https://github.com/ppfenning/docker-hadoop/network/members
[stars-shield]: https://img.shields.io/github/stars/ppfenning/docker-hadoop.svg?style=for-the-badge
[stars-url]: https://github.com/ppfenning/docker-hadoop/stargazers
[issues-shield]: https://img.shields.io/github/issues/ppfenning/docker-hadoop.svg?style=for-the-badge
[issues-url]: https://github.com/ppfenning/docker-hadoop/issues
[license-shield]: https://img.shields.io/github/license/ppfenning/docker-hadoop.svg?style=for-the-badge
[license-url]: https://github.com/ppfenning/docker-hadoop/blob/master/LICENSE.txt
[linkedin-shield]: https://img.shields.io/badge/-LinkedIn-black.svg?style=for-the-badge&logo=linkedin&colorB=555
[linkedin-url]: https://linkedin.com/in/patrick-pfenning
[product-screenshot]: /media/intro/screen-shot.png
[Next.js]: https://img.shields.io/badge/next.js-000000?style=for-the-badge&logo=nextdotjs&logoColor=white
[Next-url]: https://nextjs.org/
[React.js]: https://img.shields.io/badge/React-20232A?style=for-the-badge&logo=react&logoColor=61DAFB
[React-url]: https://reactjs.org/
[Vue.js]: https://img.shields.io/badge/Vue.js-35495E?style=for-the-badge&logo=vuedotjs&logoColor=4FC08D
[Vue-url]: https://vuejs.org/
[Angular.io]: https://img.shields.io/badge/Angular-DD0031?style=for-the-badge&logo=angular&logoColor=white
[Angular-url]: https://angular.io/
[Svelte.dev]: https://img.shields.io/badge/Svelte-4A4A55?style=for-the-badge&logo=svelte&logoColor=FF3E00
[Svelte-url]: https://svelte.dev/
[Laravel.com]: https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white
[Laravel-url]: https://laravel.com
[Bootstrap.com]: https://img.shields.io/badge/Bootstrap-563D7C?style=for-the-badge&logo=bootstrap&logoColor=white
[Bootstrap-url]: https://getbootstrap.com
[JQuery.com]: https://img.shields.io/badge/jQuery-0769AD?style=for-the-badge&logo=jquery&logoColor=white
[JQuery-url]: https://jquery.com 
[repo-url]: https://github.com/ppfenning/docker-hadoop
