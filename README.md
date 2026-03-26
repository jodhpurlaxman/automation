
# DevOps Automation Toolkit

Collection of automation scripts for DevOps, SysAdmin, and Security tasks.

## Structure

- malware/ → malware scanning & alerts
- ssl/ → SSL utilities
- cpanel/ → cPanel tools
- backup/ → backup/restore
- system/ → system monitoring
- utils/ → misc scripts

## Setup

cp .env.example .env

## Example Usage

Run malware scan:
bash malware/malware_scan_and_trigger.sh

## Cron Example

0 2 * * * /root/utilities/malware_scan_and_trigger.sh

## Requirements

- Linux
- jq
- curl
- sendmail
- Imunify360

## Security

No secrets stored. Use .env file.
