```markdown
# 🔐 Sermikro CTF Portal - Linux Basics I

**Advanced Capture The Flag Challenges for Offensive Security Training**

![Difficulty](https://img.shields.io/badge/Difficulty-HARD-red)
![Category](https://img.shields.io/badge/Category-Linux%20Fundamentals-blue)
![License](https://img.shields.io/badge/License-MIT-green)

---

## 📋 Overview

This repository contains **9 advanced CTF challenges** designed to test and develop critical Linux system administration and penetration testing skills. Each challenge focuses on core Linux concepts covered in **Offensive Security PEN-100** training material.

### 🎯 Learning Objectives

- Master Linux filesystem navigation and manipulation
- Understand process memory forensics
- Develop advanced regex and text processing skills
- Learn file descriptor manipulation
- Practice real-time data stream processing
- Work with binary data and mixed encodings

---

## 📚 Challenge Categories

### 1. **Introduction to Linux** (CTF 1.1)
**File:** `build-script-symlink.sh`

**Challenge:** Navigate through a complex maze of symbolic links to find the hidden flag.

**Skills:**
- Symlink analysis and resolution
- File system navigation
- Link chain following
- Metadata inspection

**Difficulty:** ⭐⭐⭐⭐ HARD

**Flag:** `FLAG{symlink_maze_survivor}`

---

### 2. **Command Line Basics** (CTF 2.1)
**File:** `build-script-command-basics.sh`

**Challenge:** Extract flag from 1000 files where each character is hidden in the first letter of filenames.

**Skills:**
- Bash scripting and loops
- Pattern matching
- String manipulation
- File sorting and filtering

**Difficulty:** ⭐⭐⭐⭐ HARD

**Flag:** `FLAG{cli_scripting_legend}`

---

### 3. **Command Line Basics** (CTF 2.2)
**File:** `build-script-history.sh`

**Challenge:** Find obfuscated command in 10,000+ line bash history with 3-layer encoding (Base64 → Hex → ROT13).

**Skills:**
- Bash history forensics
- Multi-layer decryption
- Base64, Hex, ROT13 decoding
- Large file processing

**Difficulty:** ⭐⭐⭐⭐ HARD

**Flag:** `FLAG{history_forensics_expert}`

---

### 4. **Manuals and Help** (CTF 3.1)
**File:** `build-script-manual-page.sh`

**Challenge:** Extract ASCII art flag from custom man page groff source code.

**Skills:**
- Man page system knowledge
- Groff/Troff format parsing
- File decompression
- ASCII art recognition

**Difficulty:** ⭐⭐⭐⭐ HARD

**Flag:** `FLAG{man_page_reverse_engineer}`

---

### 5. **The Linux Filesystem** (CTF 4.1)
**File:** `build-script-filesystem.sh`

**Challenge:** Extract flag from running process memory using /proc filesystem.

**Skills:**
- /proc virtual filesystem
- Process memory analysis
- Memory mapping
- Binary data extraction

**Difficulty:** ⭐⭐⭐⭐⭐ HARD

**Flag:** `FLAG{proc_memory_forensics}`

---

### 6. **Piping and Redirection** (CTF 7.1)
**File:** `build-script-piping_and_redirection.sh`

**Challenge:** Process real-time data stream (1000+ entries/sec) and decode 10 flag parts with different encodings.

**Skills:**
- Named pipes (FIFO)
- Real-time stream processing
- Multi-encoding decryption
- Time-critical processing

**Difficulty:** ⭐⭐⭐⭐⭐ HARD

**Flag:** `FLAG{realtime_pipe_master}`

---

### 7. **Piping and Redirection** (CTF 7.2)
**File:** `build-script-piping_and_redirection_2.sh`

**Challenge:** Navigate 7 nested subshells with custom file descriptors (FD 3-20) to collect flag parts.

**Skills:**
- File descriptor manipulation
- Nested subshells
- Process substitution
- Advanced bash scripting

**Difficulty:** ⭐⭐⭐⭐⭐ HARD

**Flag:** `FLAG{fd_manipulation_wizard}`

---

### 8. **Searching and Text Manipulation** (CTF 8.1)
**File:** `build-script_searching_and_text_manipulation.sh`

**Challenge:** Process 1GB log file with 50 flag parts using advanced regex patterns (lookahead/lookbehind/backreferences).

**Skills:**
- Advanced regex (PCRE)
- Lookahead/lookbehind assertions
- Memory-efficient processing
- Base64 decoding

**Difficulty:** ⭐⭐⭐⭐⭐ VERY HARD

**Flag:** `FLAG{advanced_regex_overlord}`

**⚠️ Warning:** Creates 1GB file!

---

### 9. **Searching and Text Manipulation** (CTF 8.2)
**File:** `build-script_searching_and_text_manipulation_2.sh`

**Challenge:** Extract 5 flag parts from mixed binary file (text, hex, base64, gzip, XOR).

**Skills:**
- Binary file analysis
- Multi-format decoding
- sed, awk, xxd, dd usage
- XOR cipher decryption

**Difficulty:** ⭐⭐⭐⭐⭐ HARD

**Flag:** `FLAG{text_binary_manipulation_deity}`

---

## 🚀 Quick Start

### Prerequisites

```bash
# Required tools (most are pre-installed on Kali Linux)
sudo apt update
sudo apt install -y gcc python3 base64 gzip xxd

# Verify installations
which gcc python3 base64 gzip xxd
```

### Installation

```bash
# Clone the repository
git clone https://github.com/yourusername/linux-basics-ctf.git
cd linux-basics-ctf

# Make all scripts executable
chmod +x *.sh

# List available challenges
ls -lh build-script-*.sh
```

---

## 🎮 Usage

### Running a Challenge

```bash
# Example: Run CTF 1.1 (Symlink Maze)
./build-script-symlink.sh

# The script will:
# 1. Display challenge information
# 2. Create the CTF environment
# 3. Provide hints and starting points
```

### Challenge Workflow

1. **Build** - Run the build script to create the challenge
2. **Solve** - Use your Linux skills to find the flag
3. **Cleanup** - Run the cleanup script when finished

```bash
# Each challenge creates a cleanup script
/tmp/cleanup_ctf_X_X.sh
```

---

## 📖 Challenge Structure

Each build script follows this format:

```bash
./build-script-*.sh
# ↓
# Creates challenge environment
# ↓
# Displays:
#   - Challenge description
#   - Difficulty level
#   - Required skills
#   - Starting location
#   - Hints (optional)
# ↓
# Challenge is LIVE
# ↓
# Solve it!
# ↓
# Run cleanup script
```

---

## 🛠️ Solution Approach

### General Tips

1. **Read the Challenge Description** - Understand what's being asked
2. **Check Starting Location** - Navigate to the specified directory
3. **Use Hints Wisely** - Hints are provided but try solving first
4. **Explore Tools** - Each challenge lists required tools
5. **Think Like a Pentester** - These are real-world scenarios

### Example Solutions

**CTF 1.1 - Symlink Maze:**
```bash
cd /dev/shm/.secrets/
ls -la
readlink link1
# Follow the chain...
```

**CTF 2.1 - Command Line:**
```bash
cd /opt/challenge/
for i in {001..026}; do 
    ls | grep "^.${i}_" | cut -c1
done | tr -d '\n'
```

**CTF 4.1 - Process Memory:**
```bash
ps aux | grep secret_daemon
PID=<found_pid>
sudo strings /proc/$PID/mem | grep FLAG
```

---

## 📊 Difficulty Levels

| Level | Stars | Description |
|-------|-------|-------------|
| HARD | ⭐⭐⭐⭐ | Requires solid Linux knowledge |
| VERY HARD | ⭐⭐⭐⭐⭐ | Advanced techniques needed |

---

## ⚠️ Important Notes

### Resource Requirements

- **Disk Space:** Most challenges use <100MB except:
  - CTF 8.1: Requires ~1GB free space
- **RAM:** Minimum 2GB recommended
- **Time:** Each challenge takes 30-90 minutes

### Cleanup

**Always run cleanup scripts when finished:**

```bash
/tmp/cleanup_ctf_1_1.sh
/tmp/cleanup_ctf_2_1.sh
# etc...
```

### Permissions

Some challenges require `sudo` access:
- CTF 4.1 (Process Memory)
- CTF 3.1 (Man Page)

---

## 🎓 Learning Path

### Beginner → Intermediate
1. CTF 1.1 (Symlinks)
2. CTF 2.1 (Command Line)
3. CTF 3.1 (Man Pages)

### Intermediate → Advanced
4. CTF 2.2 (History Forensics)
5. CTF 4.1 (Memory Forensics)
6. CTF 8.2 (Binary Manipulation)

### Advanced → Expert
7. CTF 7.1 (Real-time Processing)
8. CTF 7.2 (File Descriptors)
9. CTF 8.1 (Regex Master)

---

## 🔧 Troubleshooting

### Common Issues

**Problem:** Script fails with "permission denied"
```bash
chmod +x build-script-*.sh
```

**Problem:** "Command not found"
```bash
# Install missing tools
sudo apt install -y <missing-tool>
```

**Problem:** Challenge won't cleanup
```bash
# Manual cleanup
sudo rm -rf /tmp/ctf_*
sudo rm -rf /opt/challenge
sudo rm -rf /dev/shm/.secrets
```

**Problem:** Out of disk space (CTF 8.1)
```bash
# Check available space
df -h /tmp

# Free up space if needed
sudo apt clean
```

---

## 📝 Challenge Checklist

Track your progress:

- [ ] CTF 1.1 - Symlink Maze
- [ ] CTF 2.1 - Command Line Basics
- [ ] CTF 2.2 - History Forensics
- [ ] CTF 3.1 - Man Page Reverse Engineering
- [ ] CTF 4.1 - Process Memory Forensics
- [ ] CTF 7.1 - Real-time Pipe Processing
- [ ] CTF 7.2 - File Descriptor Manipulation
- [ ] CTF 8.1 - Advanced Regex
- [ ] CTF 8.2 - Binary Manipulation

---

## 🤝 Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

### Adding New Challenges

1. Follow the existing naming convention
2. Include detailed challenge description
3. Provide cleanup script
4. Test thoroughly
5. Update README

---

## 📜 License

This project is licensed under the MIT License - see the LICENSE file for details.

---

## 🙏 Acknowledgments

- **Offensive Security** - For PEN-100 course inspiration
- **Linux Community** - For amazing tools and documentation
- **CTF Community** - For challenge design patterns

---

## 📧 Contact

**Author:** Sermikro CTF Team  
**GitHub:** [github.com/yourusername/linux-basics-ctf](https://github.com/yourusername/linux-basics-ctf)  
**Issues:** Report bugs or request features via GitHub Issues

---

## 🎯 Final Notes

These challenges are designed to be **educational** and **challenging**. Don't get discouraged if you get stuck - that's part of the learning process!

**Remember:**
- 🔍 Read error messages carefully
- 📚 Use man pages and documentation
- 💡 Think creatively
- 🧪 Experiment safely
- 🎓 Learn from mistakes

---

**Good luck, hacker! May your skills be sharp and your flags plentiful! 🚀**

```
 ____                      _ _              
/ ___|  ___ _ __ _ __ ___ (_) | ___ __ ___  
\___ \ / _ \ '__| '_ ` _ \| | |/ / '__/ _ \ 
 ___) |  __/ |  | | | | | | |   <| | | (_) |
|____/ \___|_|  |_| |_| |_|_|_|\_\_|  \___/ 
                                             
 ____ _____ _____   ____            _        _ 
/ ___|_   _|  ___| |  _ \ ___  _ __| |_ __ _| |
\___ \ | | | |_    | |_) / _ \| '__| __/ _` | |
 ___) || | |  _|   |  __/ (_) | |  | || (_| | |
|____/ |_| |_|     |_|   \___/|_|   \__\__,_|_|
```

---

**Version:** 1.0.0  
**Last Updated:** November 2024  
**Status:** ✅ Production Ready
```