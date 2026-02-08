#!/bin/bash

# Get current user info
export USER_UID=$(id -u)
export USER_GID=$(id -g) 
export USER=$(whoami)

echo "🚀 Starting the .NET DevBench Monster Container"
echo "   User: $USER (UID: $USER_UID, GID: $USER_GID)"

# Validate we have the required info
if [ -z "$USER" ] || [ -z "$USER_UID" ] || [ -z "$USER_GID" ]; then
    echo "❌ Error: Could not determine user info"
    echo "   USER=$USER, UID=$USER_UID, GID=$USER_GID"
    exit 1
fi

echo "🔧 Building container with user mapping..."

# Start the container with proper user mapping
docker-compose -f .devcontainer/docker-compose.yml up -d --build

if [ $? -eq 0 ]; then
    echo "✅ Container started successfully!"
    echo ""
    echo "🎯 Next steps:"
    echo "   - Open VS Code and select 'Reopen in Container'"
    echo "   - Or run: docker exec -it dot_net_bench zsh"
    echo ""
    echo "🔍 To check container status:"
    echo "   docker ps | grep dot_net_bench"
else
    echo "❌ Container failed to start. Check Docker logs:"
    echo "   docker-compose -f .devcontainer/docker-compose.yml logs"
fi