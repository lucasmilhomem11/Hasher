# 🛡️ Hasher.sh - File Hash Checker

## 📌 Overview
Hasher.sh is a simple yet powerful Bash script designed to compute file hashes and optionally check them against online threat intelligence databases like VirusTotal. This tool is particularly useful for cybersecurity analysts and researchers to identify potentially malicious files, this will help saving some time.

## 🚀 Features
✅ Computes **MD5** and **SHA1** hashes for a given file.  
✅ Option to check file hashes against online malware databases.  
✅ Supports **VirusTotal CLI** for quick threat intelligence analysis.  
✅ Simple and intuitive command-line interface.  

## 🔧 Prerequisites
Ensure you have the following installed before running `hasher.sh`:
- 🐧 **Bash** (default on most Linux/macOS systems)
- 🔍 `md5sum` and `sha1sum` (usually pre-installed)
- 🌐 [VirusTotal CLI](https://github.com/VirusTotal/vt-cli) (optional, for online checks)

## 📥 Installation
Clone or download the script and make it executable:
```bash
chmod +x hasher.sh
```

## 🎯 Usage
Run the script with the file you want to check:
```bash
./hasher.sh <file_path>
```

### 💡 Example:
```bash
./hasher.sh sample.exe
```
**Output:**
```
🔎 This application will check the file hashes and crosscheck with databases online to see if it is malicious or not.
🛠️ Checking hashes...
------------------------
🔹 MD5: d41d8cd98f00b204e9800998ecf8427e
🔹 SHA1: da39a3ee5e6b4b0d3255bfef95601890afd80709
------------------------
❓ Do you want to check this file online? (y/n): 
```

## 🌍 Online Check (VirusTotal)
If you choose **y**, the script will use VirusTotal CLI to check the file hash:
```bash
vt file report <hash>
```
📌 *Ensure you have VirusTotal CLI set up with an API key before using this feature.*

## 🔮 Future Improvements  
🔹 Integrate additional threat intelligence platforms (e.g., **AbuseIPDB, HybridAnalysis**).  
🔹 Improve error handling and add logging capabilities.  

## 📜 License
This script is **open-source** and free to use. Modify and improve as needed! 🎉

