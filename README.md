# fancyproject
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)



## Provisioning resources on Chameleon Cloud

The `chi` directory in your newly created project automates setting up data buckets, bringing up compute instances, and launching a fully configured Jupyter environment with MLFlow experiment tracking for your machine learning experiments.

In [Chameleon JupyterHub](https://jupyter.chameleoncloud.org/hub/), clone your new project and open the `chi` directory.

### Prerequisites

You must have a [Chameleon Cloud](https://chameleoncloud.org) account, and an allocation as part of a project. You should have already configured SSH keys at the Chameleon site that you plan to use, e.g. following [Hello, Chameleon](https://teaching-on-testbeds.github.io/hello-chameleon/).

### First run only: Create object store buckets

At the beginning of your project, you will create buckets in Chameleon's object store, to hold datasets, metrics, and artifacts from experiment runs. Unlike data saved to the ephemeral local disk of the compute instance, this data will persist beyond the lifetime of the compute instance.

Inside the `chi` directory, run the notebook `0_create_buckets.ipynb` to create these buckets.

### Launching a compute instance

When you need to work on your project, you will launch a compute instance on Chameleon Cloud.

First, you will reserve an instance. Use your project name as a prefix for your lease name.

Then, to provision your server and configure it for your project, you will run:

- For NVIDIA: [`chi/1_create_server_nvidia.ipynb`](chi/1_create_server_nvidia.ipynb)
- For AMD:  [`chi/1_create_server_amd.ipynb`](chi/1_create_server_amd.ipynb)

---

### Configure and start your Jupyter environment

On your computer instance (SSH-ing from your local machine via shell), generate the `.env` file required for Docker Compose:
From your **home directory** (`~`), run:

```sh
 ./ReproGen/scripts/generate_env.sh
```

you will be prompted to enter your HuggingFace Token,after inputting.
you should see something like:

`✅ The .env file has been generated successfully at : /home/cc/.env`

---

From your **home directory** (`~`), run:

```sh
docker compose --env-file ~/.env -f ReproGen/docker/docker-compose.yml up -d --build
```

---

### Login to Jupyter Lab and MLFlow UI

1. Access your jupyter lab at:  `<HOST_IP>:8888` you can grab the token from running image using the command:

```sh
docker logs jupyter 2>&1 | grep -oE "http://127.0.0.1:8888[^ ]*token=[^ ]*"
```

- In the Jupyter terminal, log into GitHub using the CLI

```sh
gh auth login
```

Follow the intstructions to authenticate.

2. Access MLFlow UI at `<HOST_IP>:8000`

### Use the environment


### 5.5. Stop the Containerized Environment

If you’d like to pause your environment, you can stop the running containers with the command:

```sh
docker compose --env-file ~/.env -f ReproGen/docker/docker-compose.yml down
```

This will stop and remove the containers, but all your data in mounted volumes will remain safe.
When you want to restart later, simply run the docker compose up command again (see Step 4).

---

### 6. Clean Up Resources

When finished, delete your server to free up resources.

**In Chameleon JupyterHub, open and run:**

- [`chi/2_delete_resources.ipynb`](chi/2_delete_resources.ipynb)
