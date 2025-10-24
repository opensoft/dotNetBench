#!/bin/bash

# ====================================
# .NET/Multi-Repo Project Update Script
# ====================================
# Updates multi-component projects that contain .NET services
# This script handles projects like Dartwing that have multiple repositories
#
# Usage: ./update-dotNet-project.sh [project-path]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m' # No Color

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
FLUTTER_SCRIPT="/home/brett/projects/workBenches/devBenches/flutterBench/scripts/update-dartwing-project.sh"

# ====================================
# Utility Functions
# ====================================

log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

log_section() {
    echo ""
    echo -e "${CYAN}🔄 $1${NC}"
    echo "$(printf '=%.0s' {1..50})"
}

# ====================================
# Multi-Repo Project Detection
# ====================================

detect_project_type() {
    local project_path="$1"
    
    log_section "Analyzing Multi-Repo Project Structure"
    
    cd "$project_path"
    
    # Check for Dartwing orchestrator pattern
    if [[ -f "setup-dartwing-project.sh" && -f "CLAUDE.md" && -f "arch.md" ]]; then
        log_success "Detected: Dartwing Project Orchestrator"
        log_info "Components found:"
        
        if [ -d "app" ]; then
            log_info "  • app/ - Flutter mobile application"
        fi
        
        if [ -d "gatekeeper" ]; then
            log_info "  • gatekeeper/ - .NET backend service"
        fi
        
        if [ -d "lib" ]; then
            log_info "  • lib/ - Shared Flutter library"
        fi
        
        return 0
    fi
    
    # Check for standard .NET project
    if [[ -f "*.csproj" || -f "*.sln" ]]; then
        log_success "Detected: Standard .NET Project"
        return 1
    fi
    
    log_warning "Unknown project structure - treating as generic multi-repo project"
    return 2
}

# ====================================
# Dartwing Orchestrator Update
# ====================================

update_dartwing_orchestrator() {
    local project_path="$1"
    
    log_section "Updating Dartwing Project Orchestrator"
    
    cd "$project_path"
    
    # Check for Flutter app component
    if [ -d "app" ] && [ -f "app/pubspec.yaml" ]; then
        log_info "Found Flutter app component - delegating to Dartwing Flutter script"
        
        if [ -f "$FLUTTER_SCRIPT" ]; then
            log_info "Executing: $FLUTTER_SCRIPT"
            bash "$FLUTTER_SCRIPT" "./app"
            
            if [ $? -eq 0 ]; then
                log_success "Flutter app component updated successfully"
            else
                log_error "Flutter app component update failed"
                return 1
            fi
        else
            log_error "Dartwing Flutter update script not found: $FLUTTER_SCRIPT"
            return 1
        fi
    else
        log_warning "No Flutter app component found (app/pubspec.yaml missing)"
    fi
    
    # Check for .NET gatekeeper component
    if [ -d "gatekeeper" ]; then
        log_info "Found .NET gatekeeper component"
        
        cd gatekeeper
        if ls *.csproj >/dev/null 2>&1; then
            log_info ".NET project files found in gatekeeper/"
            log_info "Note: .NET component update not yet implemented"
            log_info "The gatekeeper service uses its own devcontainer configuration"
        else
            log_warning "No .NET project files found in gatekeeper/"
        fi
        cd ..
    else
        log_info "No .NET gatekeeper component found"
    fi
    
    # Check for shared library component
    if [ -d "lib" ]; then
        log_info "Found shared library component"
        log_info "Note: Library component typically shares configuration with app component"
    fi
    
    log_success "Dartwing orchestrator analysis complete"
}

# ====================================
# Standard .NET Project Update
# ====================================

update_standard_dotnet() {
    local project_path="$1"
    
    log_section "Updating Standard .NET Project"
    
    cd "$project_path"
    
    log_warning "Standard .NET project update not yet implemented"
    log_info "This would typically:"
    log_info "  • Update .devcontainer configuration"
    log_info "  • Update NuGet packages"
    log_info "  • Apply .NET project templates"
    log_info "  • Configure debugging and launch settings"
    
    log_info "For now, please update manually or create specific .NET update logic"
}

# ====================================
# Main Function
# ====================================

main() {
    local project_path="${1:-$(pwd)}"
    
    echo -e "${BLUE}.NET/Multi-Repo Project Update Script${NC}"
    echo "==============================================="
    echo ""
    
    if [ ! -d "$project_path" ]; then
        log_error "Project directory not found: $project_path"
        exit 1
    fi
    
    log_info "Project path: $project_path"
    log_info "Project name: $(basename "$project_path")"
    
    # Detect project type
    detect_project_type "$project_path"
    project_type=$?
    
    case $project_type in
        0)  # Dartwing orchestrator
            update_dartwing_orchestrator "$project_path"
            ;;
        1)  # Standard .NET project
            update_standard_dotnet "$project_path"
            ;;
        2)  # Unknown/generic
            log_error "Unable to determine how to update this project"
            log_info "Please use a more specific update script or add support for this project type"
            exit 1
            ;;
    esac
    
    log_success "Project update completed"
    echo ""
}

# ====================================
# Help Display
# ====================================

if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
    echo "Usage: $0 [project-path]"
    echo ""
    echo "Updates .NET and multi-repo projects with the latest configurations."
    echo ""
    echo "Supported project types:"
    echo "  • Dartwing Project Orchestrator (Flutter app + .NET gatekeeper + shared lib)"
    echo "  • Standard .NET projects (*.csproj, *.sln files)"
    echo ""
    echo "Arguments:"
    echo "  project-path    Path to project directory (default: current directory)"
    echo ""
    echo "For Dartwing orchestrators, this script will:"
    echo "  1. Detect the multi-repo structure"
    echo "  2. Update the Flutter app component using update-dartwing-project.sh"
    echo "  3. Analyze the .NET gatekeeper component"
    echo "  4. Provide guidance for manual updates where needed"
    echo ""
    exit 0
fi

# ====================================
# Script Execution
# ====================================

main "$@"