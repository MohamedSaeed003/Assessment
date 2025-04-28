# Assessment
# Task 1(mygrep)

## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Installation](#installation)
- [Example](#example)
- [Reflective](#reflective)

## Overview

`mygrep` is a simplified Bash implementation of the classic `grep` command-line utility. This project demonstrates core text processing capabilities while maintaining a minimal and understandable codebase.

## Features

✅ Basic pattern matching in text files  
✅ Case-insensitive search  
✅ Line number display (`-n` option)  
✅ Inverted matching (`-v` option)  
✅ Combined short options (e.g., `-nv`)  
✅ Help documentation (`--help`)  

## Installation

### Basic Installation
```bash
git clone https://github.com/MohamedSaeed003/Assessment.git
cd Assessment
./mygrep.sh --help
```

## Example

![image](https://github.com/user-attachments/assets/9504b0f3-e83b-4c6e-9cd3-6efa6bb97111)

## Reflective

1. Argument and Option Handling:
My script first checks if the number of arguments is enough (at least 1) or if --help is requested.
It then enters a loop to process all options starting with -, such as -v, -n, or combined ones like -vn.
Each letter after - is checked individually:
-n enables showing line numbers.
-v enables inverting the match (show non-matching lines).
--help prints the usage information and exits.
After options are processed, the script expects two positional arguments:
The pattern to search for, and the file to search inside.
If the file does not exist, an error is shown.

2. Adding Support for Regex, -i, -c, -l:
To support regular expressions and new options like -i, -c, or -l, I would need to expand the option parsing part to recognize these new flags individually.
Changes needed:
- i (ignore case): I would add a flag to control case-sensitivity and adjust the grep command accordingly.
- c (count): Instead of printing matching lines, I would keep a counter variable and at the end, print the number of matches.
- l (list): If there is at least one match, I would just print the filename and stop reading further.


4. Hardest Part:
The hardest part was handling combined options like -vn or -nv.
Initially, my script only handled separate options like -v -n, but not when combined together.
I had to learn how to loop through each character individually inside a combined option string, and set the correct flags for each one.
Making the script flexible enough to handle all combinations correctly was challenging but very educational.

# Task 2 (Troubleshooting)
# 🛠️ Troubleshooting internal.example.com Reachability

## 1. Objective

Diagnose and resolve why the domain `internal.example.com` is unreachable.  
Document the process clearly and demonstrate applied troubleshooting and solutions.

---

## 2. Troubleshooting Steps

All troubleshooting steps are scripted in [`scripts/troubleshooting.sh`](Q2/troubleshooting.sh).

The main actions performed:

- Check system DNS resolver
- Test DNS resolution using system and external resolvers (8.8.8.8)
- Add a temporary nameserver if missing
- Resolve domain to IP address
- Check network connectivity to the resolved IP (ping, nc, curl)
- Verify firewall rules (UFW, iptables)
- Restart web server if necessary
- Add static entry in `/etc/hosts` if required

---

## 3. Trace the Issue – Potential Causes

| Layer    | Potential Cause                                    | How to Confirm                   |
|:---------|:---------------------------------------------------|:----------------------------------|
| DNS      | No resolver configured / DNS server failure        | `dig` command failures            |
| DNS      | Incorrect DNS entries or missing records           | `dig @8.8.8.8 internal.example.com` |
| Network  | Firewall blocking HTTP/HTTPS ports                 | `nc -vz` and `ufw`/`iptables` status |
| Service  | Web server down or misconfigured                   | `systemctl status apache2` |
| Hosts    | Missing or incorrect `/etc/hosts` entries (optional backup) | Ping after manual hosts update |

---

## 4. Proposed and Applied Fixes

### 🔧 4.1 Missing DNS Resolver

- **Root Cause Confirmation**:
  ```bash
  dig internal.example.com
  # Error: no servers could be reached
  ```
- **Fix Applied**:
   ```bash
   sudo nano /etc/resolv.conf
   nameserver 8.8.8.8
   ```
- **Verification**:
  ```bash
  dig internal.example.com
  ```   
### 🔧 4.2 Firewall Blocking HTTP/HTTPS
- **Root Cause Confirmation**
  ```bash
  nc -vz <resolved-IP> 80
  nc -vz <resolved-IP> 443
  sudo ufw status
  ```
- ** Fix Applied**:
  ```bash
  sudo ufw allow 80/tcp
  sudo ufw allow 443/tcp
  sudo systemctl reload ufw
  ```
  - **Verification**:
  ```bash
  nc -vz <resolved-IP> 80
  nc -vz <resolved-IP> 443
  ```
### 🔧 4.3 Web Server Restart (if service not responding)
- **Root Cause Confirmation**
  ```bash
  systemctl status apache2
  ```
- ** Fix Applied**:
  ```bash
  sudo systemctl restart apache2
  ```
  - **Verification**:
  ```bash
  systemctl status apache2
  ```  
  
