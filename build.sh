#!/bin/bash

# Default values
MOODLE_DIR=""
PROJECT_ID="neural-period-460315-p7"
IMAGE_NAME="moodle"
TAG="latest"

# Help message
print_help() {
  echo "Usage: ./build.sh [--moodle-dir=PATH | --moodle-dir PATH] [--project-id=ID | --project-id ID]"
  echo ""
  echo "Options:"
  echo "  --moodle-dir PATH     Path to your Moodle source directory."
  echo "                        Can also be written as --moodle-dir=PATH."
  echo "                        If provided, its contents will replace ./moodle before building."
  echo "  --project-id ID       Google Cloud project ID to use (default: $PROJECT_ID)."
  echo "                        Can also be written as --project-id=ID."
  echo "  --help, -h            Show this help message."
  echo ""
  echo "Examples:"
  echo "  ./build.sh --moodle-dir ../moodle-custom"
  echo "  ./build.sh --moodle-dir=../moodle-custom --project-id=my-gcp-project"
  echo "  ./build.sh"
}

# Parse arguments (support --key value and --key=value)
while [[ $# -gt 0 ]]; do
  case "$1" in
    --moodle-dir)
      MOODLE_DIR="$2"
      shift 2
      ;;
    --moodle-dir=*)
      MOODLE_DIR="${1#*=}"
      shift
      ;;
    --project-id)
      PROJECT_ID="$2"
      shift 2
      ;;
    --project-id=*)
      PROJECT_ID="${1#*=}"
      shift
      ;;
    --help|-h)
      print_help
      exit 0
      ;;
    *)
      echo "❌ Unknown option: $1"
      echo "Use --help to view available options."
      exit 1
      ;;
  esac
done

# If moodle-dir is set
if [ -n "$MOODLE_DIR" ]; then
  echo "📁 Using Moodle directory from: $MOODLE_DIR"

  if [ ! -d "$MOODLE_DIR" ]; then
    echo "❌ Error: Directory '$MOODLE_DIR' does not exist."
    exit 1
  fi

  if [ -d "./moodle" ]; then
    echo "🧹 Removing existing ./moodle directory..."
    sudo rm -rf ./moodle
  fi

  echo "📥 Copying contents from '$MOODLE_DIR' into ./moodle..."
  sudo cp -r "$MOODLE_DIR" ./moodle
  sudo chmod -R 755 ./moodle
else
  if [ ! -d "./moodle" ]; then
    echo "❌ Error: No --moodle-dir provided and ./moodle directory does not exist."
    echo "→ Please specify a Moodle source directory or ensure ./moodle exists."
    exit 1
  fi
  echo "📁 Using existing ./moodle directory."
fi

# Compose full image name
IMAGE="gcr.io/$PROJECT_ID/$IMAGE_NAME:$TAG"

# Authenticate Docker with GCR
echo "🔐 Authenticating Docker with GCR..."
gcloud auth configure-docker gcr.io --quiet

# Build and push
echo "🐳 Building Docker image: $IMAGE"
docker build -t "$IMAGE" .

echo "📤 Pushing Docker image to GCR..."
docker push "$IMAGE"

echo "✅ Done. Image pushed: $IMAGE"
