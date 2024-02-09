#!/bin/bash

# Sync local database with howto-db repository

# =========================================================================
# Configuration
# =========================================================================

cd /home/bdoku/howto-db

CommitMessage=$(date -d "$date -1 days" +"%F")-23-30

# =========================================================================
# Begin upgrade
# =========================================================================

git add .

git commit -m $CommitMessage

git push
