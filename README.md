# 🔐 Linux CTF Challenges

**Offensive Security Training - Professional CTF Challenges**

![Difficulty](https://img.shields.io/badge/Difficulty-HARD-red)
![Category](https://img.shields.io/badge/Category-Linux%20Fundamentals-blue)
![License](https://img.shields.io/badge/License-MIT-green)
![Challenges](https://img.shields.io/badge/CTFs-9-orange)

---

## 📖 About

This repository contains **9 professional-grade CTF challenges** designed to test and develop critical Linux system administration and penetration testing skills. Each challenge focuses on real-world scenarios inspired by Offensive Security training materials.

**Perfect for:**
- 🎯 OSCP/PEN-100 exam preparation
- 💼 Linux system administrator skill development
- 🔒 Security researcher training
- 🎓 Cybersecurity students and professionals

---

## 🚀 Quick Start
```bash
# Clone the repository
git clone https://github.com/sermikr0/Linux-CTFs.git
cd Linux-CTFs

# Make all scripts executable
chmod +x *.sh

# Run your first challenge
./build-script-symlink.sh
```

---

## 📚 Challenge List

| # | Challenge Name | File | Difficulty | Skills |
|---|----------------|------|------------|--------|
| 1.1 | Symlink Maze | `build-script-symlink.sh` | ⭐⭐⭐⭐ | Symlinks, Navigation |
| 2.1 | Command Line Puzzle | `build-script-command-basics.sh` | ⭐⭐⭐⭐ | Bash Scripting, Loops |
| 2.2 | History Forensics | `build-script-history.sh` | ⭐⭐⭐⭐ | Decryption, Forensics |
| 3.1 | Man Page RE | `build-script-manual-page.sh` | ⭐⭐⭐⭐ | Documentation, Parsing |
| 4.1 | Memory Forensics | `build-script-filesystem.sh` | ⭐⭐⭐⭐⭐ | Process Memory, /proc |
| 7.1 | Real-time Pipes | `build-script-piping_and_redirection.sh` | ⭐⭐⭐⭐⭐ | FIFO, Streaming |
| 7.2 | File Descriptors | `build-script-piping_and_redirection_2.sh` | ⭐⭐⭐⭐⭐ | FD Manipulation |
| 8.1 | Advanced Regex | `build-script_searching_and_text_manipulation.sh` | ⭐⭐⭐⭐⭐ | Regex, 1GB File |
| 8.2 | Binary Manipulation | `build-script_searching_and_text_manipulation_2.sh` | ⭐⭐⭐⭐⭐ | Binary Analysis |

---

## 🎯 Detailed Challenges

### 🔗 CTF 1.1: Symlink Maze Challenge
Navigate through a complex maze of symbolic links with circular references and broken links.

**Flag:** `FLAG{symlink_maze_survivor}`  
**Time:** 30-45 minutes  
**Skills:** `ls`, `readlink`, `stat`, `find`

---

### 💻 CTF 2.1: Command Line Filename Puzzle
Extract flag from 1000 files where each character is hidden in the first letter of filenames.

**Flag:** `FLAG{cli_scripting_legend}`  
**Time:** 45-60 minutes  
**Skills:** Bash loops, `grep`, `awk`, `cut`, `sort`

---

### 📜 CTF 2.2: Bash History Forensics
Decode 3-layer obfuscated command (Base64 → Hex → ROT13) hidden in 10,000+ bash history entries.

**Flag:** `FLAG{history_forensics_expert}`  
**Time:** 30-60 minutes  
**Skills:** `base64`, `xxd`, `tr`, multi-layer decryption

---

### 📖 CTF 3.1: Man Page Reverse Engineering
Extract ASCII art flag from custom man page groff source code.

**Flag:** `FLAG{man_page_reverse_engineer}`  
**Time:** 30-45 minutes  
**Skills:** `man`, `zcat`, `groff`, text parsing

---

### 🧠 CTF 4.1: Process Memory Forensics
Extract flag from running process memory using `/proc` virtual filesystem.

**Flag:** `FLAG{proc_memory_forensics}`  
**Time:** 45-60 minutes  
**Skills:** `ps`, `/proc/[PID]/mem`, `strings`, memory analysis

---

### ⚡ CTF 7.1: Real-time Named Pipe Processing
Process 1000+ log entries per second through named pipe to decode 10 flag parts with different encodings.

**Flag:** `FLAG{realtime_pipe_master}`  
**Time:** 45-60 minutes  
**Skills:** `mkfifo`, Python, real-time processing, multi-encoding

---

### 🔢 CTF 7.2: File Descriptor Manipulation
Navigate 7 nested subshells with custom file descriptors (FD 3-20) to collect flag parts.

**Flag:** `FLAG{fd_manipulation_wizard}`  
**Time:** 45-60 minutes  
**Skills:** `exec`, FD manipulation, process substitution, nested subshells

---

### 🔍 CTF 8.1: Advanced Regex Master
Process 1GB log file with 50 flag parts using advanced regex patterns including lookahead, lookbehind, and backreferences.

**Flag:** `FLAG{advanced_regex_overlord}`  
**Time:** 60-90 minutes  
**Skills:** Python `re`, PCRE, lookahead/lookbehind, memory-efficient processing  
**⚠️ Requires 1GB+ disk space**

---

### 🔧 CTF 8.2: Binary Data Manipulation
Extract 5 flag parts from mixed binary file containing text, hex, base64, gzip, and XOR-encoded data.

**Flag:** `FLAG{text_binary_manipulation_deity}`  
**Time:** 45-60 minutes  
**Skills:** `xxd`, `dd`, `base64`, `gzip`, XOR decryption

---

## 🛠️ System Requirements

### Minimum Requirements
- **OS:** Linux (Kali Linux, Ubuntu, Debian)
- **Disk Space:** 2GB+ (1GB for CTF 8.1)
- **RAM:** 2GB minimum, 4GB recommended
- **Permissions:** `sudo` access required for some challenges

### Required Tools
Most tools are pre-installed on Kali Linux:
```bash
# Verify installations
which gcc python3 base64 gzip xxd sed awk grep

# Install if missing
sudo apt update
sudo apt install -y gcc python3 coreutils gzip xxd
```

---

## 📋 How to Use

### Step 1: Run a Challenge
```bash
# Example: Start CTF 1.1
./build-script-symlink.sh
```

The script will:
- Display challenge information
- Create the CTF environment
- Show starting location
- Provide optional hints

### Step 2: Solve the Challenge

Use your Linux skills to find the flag! Each challenge requires different techniques.

### Step 3: Cleanup
```bash
# Always run cleanup when finished
/tmp/cleanup_ctf_X_X.sh
```

---

## 💡 Solving Tips

### General Approach

✅ **DO:**
- Read challenge descriptions carefully
- Check starting locations first
- Use `man` pages for command help
- Take notes on your approach
- Experiment in isolated environments

❌ **DON'T:**
- Skip cleanup scripts (can fill disk space)
- Use excessive `sudo` without understanding
- Give up too quickly - struggle builds skills!
- Run unknown commands without reading them first

### Example Solutions

**CTF 1.1 - Symlink Maze:**
```bash
cd /dev/shm/.secrets/
ls -la
readlink link1
# Follow the chain to find the flag
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

## 🎓 Recommended Learning Path

### Beginner → Intermediate
Start with these to build foundational skills:

1. **CTF 1.1** - Symlink Maze
2. **CTF 2.1** - Command Line Puzzle
3. **CTF 3.1** - Man Page Reverse Engineering

### Intermediate → Advanced
Progress to more complex challenges:

4. **CTF 2.2** - History Forensics
5. **CTF 4.1** - Memory Forensics
6. **CTF 8.2** - Binary Manipulation

### Advanced → Expert
Master the most challenging scenarios:

7. **CTF 7.1** - Real-time Processing
8. **CTF 7.2** - File Descriptors
9. **CTF 8.1** - Advanced Regex (1GB)

---

## ⚠️ Troubleshooting

### Common Issues

**Problem:** Permission denied when running scripts
```bash
chmod +x build-script-*.sh
```

**Problem:** Command not found
```bash
sudo apt install -y <tool-name>
```

**Problem:** Out of disk space (CTF 8.1)
```bash
df -h /tmp
sudo apt clean
```

**Problem:** Challenge won't cleanup properly
```bash
# Manual cleanup
sudo rm -rf /tmp/ctf_*
sudo rm -rf /opt/challenge
sudo rm -rf /dev/shm/.secrets
```

**Problem:** Process still running after cleanup
```bash
ps aux | grep ctf
kill <PID>
```

---

## 📊 Challenge Progress Tracker

Track your completed challenges:

- [ ] CTF 1.1 - Symlink Maze
- [ ] CTF 2.1 - Command Line Basics
- [ ] CTF 2.2 - History Forensics
- [ ] CTF 3.1 - Man Page Reverse Engineering
- [ ] CTF 4.1 - Process Memory Forensics
- [ ] CTF 7.1 - Real-time Pipe Processing
- [ ] CTF 7.2 - File Descriptor Manipulation
- [ ] CTF 8.1 - Advanced Regex
- [ ] CTF 8.2 - Binary Manipulation

**🎉 Complete all 9 to become a Linux CTF Master!**

---

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### Ways to Contribute
- 🐛 Report bugs or issues
- 💡 Suggest new challenges
- 📝 Improve documentation
- 🔧 Submit bug fixes
- ⭐ Star the repository

### Contribution Process
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/new-challenge`)
3. Make your changes
4. Test thoroughly
5. Commit (`git commit -m 'Add new challenge'`)
6. Push (`git push origin feature/new-challenge`)
7. Open a Pull Request

---

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**TL;DR:** You can use, modify, and distribute this code freely. Just keep the license notice.

---

## 🙏 Acknowledgments

Special thanks to:
- **Offensive Security** - For PEN-100 course inspiration
- **Linux Community** - For amazing tools and documentation
- **CTF Community** - For challenge design patterns and ideas
- **Contributors** - Everyone who helps improve these challenges

---

## 📧 Contact & Support

**Author:** Sermikro CTF 

**Email:** saidakbarxonmaqsudxonov4@gmail.com
  
**Repository:** [github.com/sermikr0/Linux-CTFs](https://github.com/sermikr0/Linux-CTFs)

### Get Help
- 🐛 **Bug Reports:** [Open an Issue](https://github.com/sermikr0/Linux-CTFs/issues)
- 💬 **Questions:** Use GitHub Discussions
- 📧 **Email:** saidakbarxonmaqsudxonov4@gmail.com

---

## ⭐ Show Your Support

If you found these challenges helpful, please:
- ⭐ Star this repository
- 🔄 Share with others
- 🐛 Report issues
- 💡 Suggest improvements

---

## 🎯 Final Words

> **"The best way to learn is by doing. These challenges will push your limits - embrace the struggle!"**

**Remember:**
- 🔍 Read error messages carefully
- 📚 RTFM (Read The Fine Manual)
- 💡 Think creatively and outside the box
- 🧪 Experiment safely in isolated environments
- 🎓 Learn from every failure
- 🏆 Persistence beats resistance

---

**Version:** 1.0.0  
**Last Updated:** November 2025
**Status:** ✅ Production Ready

---

**Happy Hacking! 🎉**
