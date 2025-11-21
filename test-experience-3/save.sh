#!/bin/bash
# Simple save script for frequent saving
# Usage: ./save.sh [optional commit message]

message="$1"
if [ -z "$message" ]; then
  timestamp=$(date "+%Y-%m-%d %H:%M:%S")
  message="wip: save at $timestamp"
fi

echo "Adding files..."
git add .

echo "Committing with message: '$message'..."
git commit -m "$message"

echo "Pushing to GitHub..."
git push origin main

echo "✅ Saved to GitHub!"
