# Name

<p align="center">
<img src="./images/logo.png" width="200" alt="Name">
<br/>

- [Name](#name)
- [About](#about)
- [Getting Started](#getting-started)
  - [Requirements](#requirements)
  - [Installation](#installation)
  - [Quickstart](#quickstart)
  - [Note](#note)

# About

<!-- Include a blurb about your project, including a link to docs if applicable -->

# Getting Started

The Commit-Reveal smart contract is designed to demonstrate a simple commit-reveal scheme, which is often used in cryptographic protocols to ensure fair and secure data submission and revelation processes. In this contract, participants can commit their guesses by submitting a hash of their guess along with their address. After the guessing period ends, they reveal their guesses by submitting the actual guess, which is then verified against the original commitment. Winners are determined based on matching commitments, and they can claim their share of the total prize pool.

## Requirements

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`
- [foundry](https://getfoundry.sh/)
  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`
  <!-- Additional requirements here -->

## Installation

```bash
git clone git@github.com:PanGan21/commit-reveal.git
cd commit-reveal
make
```

## Quickstart

```bash
make test
```

## Note

This small project is only for demonstration purposes and no audit has been performed. The contract, as implemented, may lack various security features and optimizations necessary for production use.</br>
**Do not use in production system.**
