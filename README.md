# AI SRE Lab

## Overview

The **AI SRE Lab** is a local development environment designed to simulate a Site Reliability Engineering (SRE) setup. It provides tools and services for monitoring, incident management, and observability, enabling users to experiment with and learn SRE practices in a controlled environment.

## Features

- **K3d**: Lightweight Kubernetes clusters for local development.
- **Prometheus**: Metrics collection and monitoring.
- **Grafana**: Visualization and dashboarding for metrics.
- **Incident Bot**: A sample application for incident management.

## Prerequisites

- Docker (Docker Desktop for Windows users)
- WSL (if running on Windows)

## Setup Instructions

1. Clone this repository:
   ```bash
   git clone <repository-url>
   cd ai-sre-lab
   ```

2. Run the setup script:
   ```bash
   ./scripts/setup-sre-lab.sh
   ```

3. Access Grafana:
   - URL: [http://localhost:3000](http://localhost:3000)
   - Username: `admin`
   - Password: Retrieved from the setup script.

4. Stop the Grafana port-forwarding when done:
   ```bash
   kill <PORT_FORWARD_PID>
   ```

## Goal

This repository aims to provide a hands-on environment for learning and practicing SRE principles, including:

- Setting up and managing Kubernetes clusters.
- Configuring monitoring and observability tools.
- Deploying and managing applications in a Kubernetes environment.

## Contributing

Contributions are welcome! Feel free to submit issues or pull requests to improve the lab.

## License

This project is licensed under the MIT License.