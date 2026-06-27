# Datapack

Datapack serves as the central data registry for the **Datapack** application. It hosts the `tools.json` file, which manages the list of available tools, their metadata, icons, and direct download links for Debian-based packages.

## Structure
The core of this repository is the `tools.json` file, which follows this schema:

```json
[
  {
    "id": "string",
    "name": "string",
    "version": "string",
    "description": "string",
    "changelog": "string",
    "icon": "url_string",
    "deb_file": "url_string",
    "tags": ["string"]
  }
]
```

## Features

    Centralized Management: Updates to tool versions and descriptions are managed here.
    Lightweight Deployment: Designed for fast fetching via raw GitHub URLs.
    Cross-Compatible: Easily parsed by the Datapack Flutter client.

## Usage

The application consumes this data to dynamically update the UI and handle installation processes. To add or update a tool:

    Edit the tools.json file.
    Ensure the deb_file link points to a valid .deb package.
    Commit and push the changes.

Maintained by [DataistOS]