#!/bin/bash

# Download latest β-Doku codebase and upgrade composer dependencies

# =========================================================================
# Configuration
# =========================================================================

cd /home/bdoku/bdoku

# =========================================================================
# Begin upgrade
# =========================================================================

git pull

composer update
