#!/bin/bash
# Build script for Layer 2: .NET Bench Image
# Creates: dotnet-bench:$USERNAME

set -e

echo "=========================================="
echo "Building Layer 2: .NET Bench"
echo "=========================================="
echo ""

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Go to parent directory where Dockerfile.layer2 is located
cd "$SCRIPT_DIR/.."

# Parse arguments
USERNAME=${1:-$(whoami)}
if [ "$USERNAME" = "--user" ]; then
    USERNAME="${2:-$(whoami)}"
fi

echo "Configuration:"
echo "  Username: $USERNAME"
echo "  Base image: devbench-base:$USERNAME"
echo ""

# Check if Layer 1 exists
if ! docker image inspect "devbench-base:$USERNAME" >/dev/null 2>&1; then
    echo "❌ Error: Layer 1 (devbench-base:$USERNAME) not found!"
    echo ""
    echo "Please build Layer 1 first:"
    echo "  cd ../base-image"
    echo "  ./build.sh --user $USERNAME"
    exit 1
fi

# Build the image
echo "Building dotnet-bench:$USERNAME..."
docker build \
    --build-arg BASE_IMAGE="devbench-base:$USERNAME" \
    --build-arg USERNAME="$USERNAME" \
    -f Dockerfile.layer2 \
    -t "dotnet-bench:$USERNAME" \
    .

echo ""
echo "✓ Layer 2 (.NET) built successfully!"
echo "  Image: dotnet-bench:$USERNAME"
echo ""
echo "Next step: Use this image in your workspace"
echo "  The docker-compose.yml should reference:"
echo "    image: dotnet-bench:$USERNAME"
