# How to Open Your Projects in VS Code

The dotNetBench container mounts `~/projects` to `/projects` inside the container.

## Option 1: Open from Terminal (Recommended)
Once the container is running:

```bash
# Connect to the container
docker exec -it dotnet_bench zsh

# Navigate to projects and open VS Code
cd /projects
code .
```

Or open a specific project:
```bash
docker exec -it dotnet_bench zsh
cd /projects/YourProjectName
code .
```

## Option 2: Open Folder in VS Code UI
1. Container must be running first: `./setup.sh`
2. In VS Code: **File → Open Folder**
3. Navigate to `/projects` or `/projects/YourProjectName`
4. Click "Open"

## Option 3: Use VS Code Remote
1. Install "Remote - Containers" extension
2. Click the green "><" icon in bottom-left
3. Select "Attach to Running Container"
4. Choose `dotnet_bench`
5. File → Open Folder → `/projects`

## Current Working Directory
The container's default working directory is `/projects` (set in .env).
When you exec into the container, you'll start there automatically.
