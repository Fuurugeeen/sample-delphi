# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Delphi VCL Windows application project targeting Win32/Win64 platforms. The project is built using RAD Studio/Delphi development environment.

**Current Structure:**
- `Project1.dpr` - Main project file and entry point
- `Unit1.pas` - Main form unit containing TForm1 class  
- `Unit1.dfm` - Form definition file for TForm1
- `Project1.dproj` - MSBuild project configuration file

## Build and Development

**Build Configuration:**
- Debug builds output to `Win32\Debug\` directory
- Release builds configured for Win32/Win64 platforms
- Project uses VCL framework with standard Windows components

**Build Commands:**
Since this is a Delphi project, building typically requires RAD Studio IDE or command line compiler (dcc32.exe/dcc64.exe). Standard build commands are IDE-dependent.

## Architecture

**Application Structure:**
- Single-form VCL application using standard Windows API
- Main form (`TForm1`) serves as the primary user interface
- Standard Delphi event-driven architecture
- Uses VCL components for UI rendering

**Dependencies:**
- Standard VCL units (Vcl.Forms, Vcl.Controls, etc.)
- Windows API through Winapi units
- System runtime libraries

**Development Notes:**
- Form files (.dfm) contain visual component definitions
- Unit files (.pas) contain the Pascal source code
- The project currently has minimal functionality (empty form)