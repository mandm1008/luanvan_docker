# luanvan_docker

# Moodle Docker Image Builder (For Cloud Deploy)

This project provides a simple shell script (`build.sh`) to automate the process of building and pushing a Docker image of a Moodle installation to Google Container Registry (GCR).

## 🚀 What It Does

- Optionally copies a specified Moodle source directory into the local `./moodle` folder.
- Builds a Docker image for Moodle using the local `Dockerfile`.
- Tags the image as `gcr.io/[PROJECT-ID]/moodle:latest` (or a specified project).
- Pushes the image to GCR.

---

## 🛠️ Prerequisites

- Docker installed and running
- Logged in to `gcloud` with permissions to push to GCR
- Google Cloud project and billing enabled

---

## 📦 Usage

```bash
./build.sh [--moodle-dir=PATH] [--project-id=PROJECT_ID]
```

## 📦 Options

| Option              | Description                                                                   |
| ------------------- | ----------------------------------------------------------------------------- |
| `--moodle-dir PATH` | _(Optional)_ Path to your Moodle source code. Will be copied into `./moodle`. |
| `--project-id ID`   | _(Optional)_ Google Cloud project ID. Default: `neural-period-460315-p7`      |
| `--help`, `-h`      | Show help message.                                                            |

## 📁 Folder Structure

```bash
.
├── build.sh                # Main build + push script
├── Dockerfile              # Defines PHP-FPM + Nginx + Moodle stack
├── config.php              # Moodle config file (dynamic via env)
├── entrypoint.sh           # Executes on container startup
├── init-env.sh             # Exports container env vars to /.env.local
├── moodle.ini              # Custom PHP settings
├── nginx/
│   └── default.conf        # Nginx server config
├── moodle/                 # Moodle source directory (copied or preexisting)
```

---

#### 🔍 File Explanations

```markdown
## 🔍 File Explanations

| File                 | Purpose                                                                            |
| -------------------- | ---------------------------------------------------------------------------------- |
| `build.sh`           | Shell script to build and push the Docker image.                                   |
| `Dockerfile`         | Defines the PHP-FPM, Moodle code, and Nginx base image.                            |
| `config.php`         | Moodle's config file that reads environment variables from `/.env.local`.          |
| `entrypoint.sh`      | Shell script executed at container start — runs `init-env.sh`, upgrade CLI, etc.   |
| `init-env.sh`        | Reads container environment variables and writes them to `/.env.local` for Moodle. |
| `moodle.ini`         | Custom PHP configuration (memory limits, file upload size, etc.).                  |
| `nginx/default.conf` | Nginx virtual host config routing traffic to PHP-FPM.                              |
```
