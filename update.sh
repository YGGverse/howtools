#!/bin/bash

# Download latest howto database to destination directory
# Features:
# - check for valid SHA-256
# - skip download on remote data match local version (up to date)

# =========================================================================
# Configuration
# =========================================================================

ThisDir="/home/bdoku/howtools"
DataDir="/home/bdoku/howto-db"

RemoteHost="http://[222:a8e4:50cd:55c:788e:b0a5:4e2f:a92c]"
RemoteVersion=$(date -d "$date -1 days" +"%F")-23-30

RemoteDataURL="${RemoteHost}/howto-wiki_${RemoteVersion}.tar.gz"
RemoteSHA256URL="${RemoteHost}/howto-wiki_${RemoteVersion}.tar.gz.sha-256"

RemoteSHA256TMP="${ThisDir}/tmp/remote.sha-256"
LocalSHA256TMP="${ThisDir}/tmp/local.sha-256"
LocalDataTMP="${ThisDir}/tmp/data.tar.gz"

# =========================================================================
# Compare versions
# =========================================================================

# Get remote SHA-256
wget $RemoteSHA256URL -O $RemoteSHA256TMP

# Remote SHA-256 valid
RemoteSHA256=$(<$RemoteSHA256TMP)

if ! [[ ${RemoteSHA256:0:64} =~ ^([0-9a-f]{64})$ ]]; then
  echo Invalid remote SHA-256
  exit
fi

# Get local SHA-256
if [[ -f $LocalSHA256TMP ]]; then
  LocalSHA256=$(<$LocalSHA256TMP)
else
  LocalSHA256=""
fi

# Compare versions
if [[ ${LocalSHA256:0:64} == ${RemoteSHA256:0:64} ]]; then
  echo "DB is up to date!"
  exit
fi

# =========================================================================
# SHA-256 versions mismatch, begin update
# =========================================================================

echo "Begin update..."

wget $RemoteDataURL -O $LocalDataTMP

# Generate SHA-256
sha256sum $LocalDataTMP > $LocalSHA256TMP

if [[ -f $LocalSHA256TMP ]]; then
  LocalSHA256=$(<$LocalSHA256TMP)
else
  LocalSHA256=""
fi

# Check for download contain valid SHA-256
if ! [[ ${LocalSHA256:0:64} =~ ^([0-9a-f]{64})$ ]]; then
  echo Invalid local SHA-256
  exit
fi

# Check for download match remote SHA-256
if ! [[ ${LocalSHA256:0:64} == ${RemoteSHA256:0:64} ]]; then
  echo "SHA-256 mismatch!"
  exit
fi

# Begin update
echo "Unpack downloaded data to destination..."

tar -xvf $LocalDataTMP -C $DataDir

echo "Update completed!"
