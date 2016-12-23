# asana-omnifocus-sync
A simple node/Applescript script to import your assigned tasks from Asana into Omnifocus, and to sync changes to those tasks in either direction.

## Capabilities
This script syncs any tasks in your default Asana workspace that are assigned to you. Tasks assigned to you are copied from Asana into OmniFocus, and will be set to matching project names in OmniFocus if they exist. All Asana tasks will be added to a context named "Asana", and should stay in that context. Changes to the name, completed status, due date, or notes will be synced whether the change is made on Asana or OmniFocus. If the task is no longer assigned to you in Asana it will stop syncing.

## Requirements
OmniFocus 2, Node & NPM, Asana personal access token

## Installation

	npm install

## Configuration
You will need to create a personal access token in Asana. You can do this from the Developer App Management page when logged in.

Copy your access token and paste it into index.js as the value of `ASANA_ACCESS_TOKEN`:

	const ASANA_ACCESS_TOKEN = "0/ffffffffffffffffffffffffffffffff";

## Usage
To run once:

	./index.js

To run automatically, edit the plist file to point to the correct paths to node and this script, and enter your macOS username in the path under `WatchPaths`. Then copy the file to `~/Library/LaunchAgents` and load the job:

	cp com.github.nbolender.asana-omnifocus-sync.plist ~/Library/LaunchAgents/com.github.nbolender.asana-omnifocus-sync.plist
	launchctl load ~/Library/LaunchAgents/com.github.nbolender.asana-omnifocus-sync.plist

This will sync your tasks every 30 minutes when OmniFocus is running, or when your OmniFocus database changes.
