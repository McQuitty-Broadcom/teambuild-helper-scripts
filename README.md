# TeamBuild Helper Scripts

This repository contains a collection of utility scripts designed to enhance and simplify workflows within the TeamBuild environment. These scripts automate common tasks, reduce manual configuration, and improve developer productivity by integrating with existing tools and configurations.

## Overview

TeamBuild is a build and deployment system that often requires interaction with various tools like Syncz and Exportz. The scripts in this collection address specific pain points, such as path resolution and parameter extraction, to make these interactions more seamless.

## Scripts

### Sync-up

**Purpose:** Addresses a limitation in Syncz where it does not automatically search up the directory tree to locate `syncz.yaml` configuration files.

**Description:** This script performs an upward directory search starting from the current working directory to find the nearest `syncz.yaml` file. Once located, it executes Syncz in the appropriate folder, allowing you to run synchronization commands from within subdirectories without manually navigating to the root folder.

**Benefits:**
- Eliminates the need to change directories before running Syncz.
- Ensures the correct configuration file is used based on the project structure.
- Particularly useful in large projects with nested working directories.

**Usage Example:**
```bash
# From any subdirectory in your project
sync-up
```

### Exportz-Zowe

**Purpose:** Simplifies the use of Exportz by automatically extracting parameters from existing Zowe configuration files.

**Description:** Exportz often requires manual specification of various parameters for data export operations. This wrapper script reads the `zowe.config.json` file (if present) and uses its stored parameters to populate the Exportz command, avoiding the need to re-enter configuration details manually.

**Benefits:**
- Reduces errors from manual parameter entry.
- Ensures consistency with existing Zowe setups.
- Speeds up export operations by leveraging pre-configured settings.

**Usage Example:**
```bash
# Assumes zowe.config.json is in the current or parent directory
exportz-zowe --dataset-hlq xxx.teambuild
```

## Prerequisites

- **Syncz:** Ensure Syncz is installed and configured in your environment. Refer to the official Syncz documentation for setup instructions.
- **Zowe CLI:** Required for the Exportz-Zowe script. 
- **Permissions:** Ensure you have the necessary permissions to execute the scripts and access the required directories/files.

## Installation

1. Clone this repository to your local machine:
   ```bash
   git clone <repository-url>
   cd teambuild-helper-scripts
   ```

2. Make the scripts executable:
   ```bash
   chmod +x sync-up exportz-zowe
   ```

3. Optionally, add the scripts directory to your PATH for global access.  I use $HOME/bin, which is also wher syncz and exportz are installed.

## Configuration

- For **Sync-up:** Ensure `syncz.yaml` files are properly configured in your project root or relevant directories.
- For **Exportz-Zowe:** Verify that `zowe.config.json` contains the necessary parameters for your export operations.

## Troubleshooting

- **Sync-up not finding config:** Check that `syncz.yaml` exists in the current or parent directories.
- **Exportz-Zowe errors:** Ensure `zowe.config.json` is valid and accessible.
- **Permission issues:** Run with appropriate user permissions or use `sudo` if necessary.

## Contributing

Contributions are welcome! Please submit issues or pull requests for improvements, bug fixes, or new scripts.

## License

MIT License

Copyright (c) [2026]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

