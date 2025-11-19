```markdown
# 🔐 Linux CTF Challenges - Offensive Security Training

**Professional Capture The Flag challenges designed for penetration testers and system administrators**

[![Difficulty](https://img.shields.io/badge/Difficulty-HARD-red)](https://github.com/sermikr0/Linux-CTFs)
[![Category](https://img.shields.io/badge/Category-Linux%20Fundamentals-blue)](https://github.com/sermikr0/Linux-CTFs)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)
[![CTF Count](https://img.shields.io/badge/Challenges-9-orange)](https://github.com/sermikr0/Linux-CTFs)

---

## 📖 About

This repository contains **9 professional-grade CTF challenges** covering advanced Linux concepts from filesystem manipulation to process memory forensics. Each challenge is inspired by real-world penetration testing scenarios and Offensive Security training materials.

Perfect for:
- 🎯 OSCP/PEN-100 exam preparation
- 💼 Linux system administrator skill development
- 🔒 Security researcher training
- 🎓 Cybersecurity students and professionals

---

## 🚀 Quick Start

```bash
# Clone repository
git clone https://github.com/sermikr0/Linux-CTFs.git
cd Linux-CTFs

# Make scripts executable
chmod +x *.sh

# Run your first challenge
./build-script-symlink.sh
```

---

## 📚 Challenges Overview

| # | Challenge | File | Difficulty | Flag |
|---|-----------|------|------------|------|
| 1.1 | Symlink Maze | `build-script-symlink.sh` | ⭐⭐⭐⭐ | `FLAG{symlink_maze_survivor}` |
| 2.1 | Command Line Puzzle | `build-script-command-basics.sh` | ⭐⭐⭐⭐ | `FLAG{cli_scripting_legend}` |
| 2.2 | History Forensics | `build-script-history.sh` | ⭐⭐⭐⭐ | `FLAG{history_forensics_expert}` |
| 3.1 | Man Page RE | `build-script-manual-page.sh` | ⭐⭐⭐⭐ | `FLAG{man_page_reverse_engineer}` |
| 4.1 | Memory Forensics | `build-script-filesystem.sh` | ⭐⭐⭐⭐⭐ | `FLAG{proc_memory_forensics}` |
| 7.1 | Real-time Pipes | `build-script-piping_and_redirection.sh` | ⭐⭐⭐⭐⭐ | `FLAG{realtime_pipe_master}` |
| 7.2 | File Descriptors | `build-script-piping_and_redirection_2.sh` | ⭐⭐⭐⭐⭐ | `FLAG{fd_manipulation_wizard}` |
| 8.1 | Advanced Regex | `build-script_searching_and_text_manipulation.sh` | ⭐⭐⭐⭐⭐ | `FLAG{advanced_regex_overlord}` |
| 8.2 | Binary Manipulation | `build-script_searching_and_text_manipulation_2.sh` | ⭐⭐⭐⭐⭐ | `FLAG{text_binary_manipulation_deity}` |

---

## 🎯 Challenge Details

### 🔗 CTF 1.1: Symlink Maze
Navigate through nested symbolic links with circular references and broken links.

**Topics:** Symlinks, filesystem navigation, link resolution  
**Time:** 30-45 minutes  
**Skills:** `ls`, `readlink`, `stat`, `find`

---

### 💻 CTF 2.1: Command Line Puzzle
Extract flag characters from 1000 files based on filename patterns.

**Topics:** Bash loops, pattern matching, string manipulation  
**Time:** 45-60 minutes  
**Skills:** `bash`, `grep`, `awk`, `cut`, `sort`

---

### 📜 CTF 2.2: History Forensics
Decode a 3-layer obfuscated command (Base64 → Hex → ROT13) hidden in 10,000+ bash history entries.

**Topics:** Forensics, multi-layer decryption, large file processing  
**Time:** 30-60 minutes  
**Skills:** `base64`, `xxd`, `tr`, bash scripting

---

### 📖 CTF 3.1: Man Page Reverse Engineering
Extract ASCII art flag from a custom man page's groff source code.

**Topics:** Man pages, groff format, documentation systems  
**Time:** 30-45 minutes  
**Skills:** `man`, `zcat`, `groff`, text parsing

---

### 🧠 CTF 4.1: Process Memory Forensics
Extract flag from running process memory using `/proc` filesystem.

**Topics:** Process memory, `/proc` filesystem, forensics  
**Time:** 45-60 minutes  
**Skills:** `ps`, `/proc/[PID]/mem`, `strings`, memory analysis

---

### ⚡ CTF 7.1: Real-time Pipe Processing
Process 1000+ log entries/second through named pipe to decode 10 flag parts.

**Topics:** Named pipes (FIFO), stream processing, encoding  
**Time:** 45-60 minutes  
**Skills:** `mkfifo`, Python, real-time processing, multi-encoding

---

### 🔢 CTF 7.2: File Descriptor Manipulation
Navigate 7 nested subshells with custom file descriptors (FD 3-20).

**Topics:** File descriptors, subshells, redirection  
**Time:** 45-60 minutes  
**Skills:** `exec`, FD manipulation, process substitution

---

### 🔍 CTF 8.1: Advanced Regex
Process 1GB log file with 50 flag parts using lookahead/lookbehind patterns.

**Topics:** Advanced regex, lookahead/lookbehind, memory efficiency  
**Time:** 60-90 minutes  
**Skills:** Python `re`, PCRE, pattern matching  
**⚠️ Requires 1GB+ disk space**

---

### 🔧 CTF 8.2: Binary Manipulation
Extract 5 flag parts from mixed binary file (text, hex, base64, gzip, XOR).

**Topics:** Binary analysis, multi-format decoding  
**Time:** 45-60 minutes  
**Skills:** `xxd`, `dd`, `base64`, `gzip`, XOR decryption

---

## 🛠️ Requirements

### System Requirements
- **OS:** Linux (tested on Kali Linux, Ubuntu)
- **Disk Space:** 2GB+ (1GB for CTF 8.1)
- **RAM:** 2GB minimum
- **Permissions:** `sudo` access for some challenges

### Tools Required
Most tools are pre-installed on Kali Linux:
```bash
gcc python3 base64 gzip xxd sed awk grep
```

---

## 📋 Usage Guide

### 1️⃣ Run a Challenge
```bash
# Example: Start CTF 1.1
./build-script-symlink.sh
```

The script will:
- Display challenge information
- Create the CTF environment
- Provide starting location and hints

### 2️⃣ Solve the Challenge
Use your Linux skills to find the flag!

### 3️⃣ Cleanup
```bash
# Each challenge creates a cleanup script
/tmp/cleanup_ctf_X_X.sh
```

---

## 💡 Tips & Best Practices

✅ **DO:**
- Read challenge descriptions carefully
- Use man pages for commands
- Experiment in isolated environments
- Take notes on your approach

❌ **DON'T:**
- Skip cleanup scripts (can fill disk)
- Use excessive `sudo` without understanding
- Give up too quickly - struggle builds skill!

---

## 🎓 Learning Path

**Recommended Order:**

**Beginner → Intermediate**
1. CTF 1.1 → Symlink Maze
2. CTF 2.1 → Command Line
3. CTF 3.1 → Man Pages

**Intermediate → Advanced**
4. CTF 2.2 → History Forensics
5. CTF 4.1 → Memory Forensics
6. CTF 8.2 → Binary Manipulation

**Advanced → Expert**
7. CTF 7.1 → Real-time Processing
8. CTF 7.2 → File Descriptors
9. CTF 8.1 → Regex Master

---

## ⚠️ Common Issues

**Permission denied?**
```bash
chmod +x build-script-*.sh
```

**Command not found?**
```bash
sudo apt install -y <tool-name>
```

**Out of disk space (CTF 8.1)?**
```bash
df -h
sudo apt clean
```

**Challenge won't cleanup?**
```bash
sudo rm -rf /tmp/ctf_* /opt/challenge /dev/shm/.secrets
```

---

## 🤝 Contributing

Contributions welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test thoroughly
4. Submit a pull request

---

## 📜 License

MIT License - see [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

- **Offensive Security** - PEN-100 course inspiration
- **Linux Community** - Amazing tools and documentation
- **CTF Community** - Challenge design patterns

---

## 📧 Contact

**Repository:** [github.com/sermikr0/Linux-CTFs](https://github.com/sermikr0/Linux-CTFs)  
**Issues:** [Report bugs or request features](https://github.com/sermikr0/Linux-CTFs/issues)  
**Email:** studentx349@tuit.uz

---

## 🎯 Final Words

> *"The best way to learn is by doing. These challenges will push your limits - embrace the struggle!"*

**Remember:**
- 🔍 Read error messages carefully
- 📚 RTFM (Read The Fine Manual)
- 💡 Think creatively
- 🧪 Experiment safely
- 🎓 Learn from failures

---

**🚀 Ready to hack? Start with `./build-script-symlink.sh`**
**Version 1.0.0** | **November 2025** | **Production Ready ✅**
```

Bu yangilangan README ancha professional va o'qishga oson! 🎯
