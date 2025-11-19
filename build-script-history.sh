#!/bin/bash


RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='⠋⠙⠹⠸⠼⠴⠦⠧⠇⠏'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " ${CYAN}[%c]${NC}  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

clear
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║           🔐  SERMIKRO CTF PORTAL  🔐                     ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 0.5

echo -e "${YELLOW}[*]${NC} Initializing CTF 2.2 environment..."
sleep 0.3

# Backup original bash_history
if [ -f ~/.bash_history ]; then
    cp ~/.bash_history ~/.bash_history.backup.$(date +%s)
    echo -e "${GREEN}[✓]${NC} Original history backed up"
fi

echo -e "${YELLOW}[*]${NC} Generating obfuscated command..."
(
    # The command that reveals the flag
    # Original: echo "FLAG{history_forensics_expert}"
    ORIGINAL_CMD='echo "FLAG{history_forensics_expert}"'
    
    # Step 1: ROT13 encode
    ROT13=$(echo "$ORIGINAL_CMD" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
    
    # Step 2: Convert to HEX
    HEX=$(echo -n "$ROT13" | xxd -p | tr -d '\n')
    
    # Step 3: Base64 encode
    BASE64=$(echo -n "$HEX" | base64 -w 0)
    
    # Create the obfuscated command (this is what will be hidden)
    OBFUSCATED="$BASE64"
    
) &
spinner $!
sleep 0.2

echo -e "${YELLOW}[*]${NC} Creating fake bash history with 10000+ entries..."
(
    # Create temporary history file
    TEMP_HISTORY=$(mktemp)
    
    # Generate 10000+ fake commands
    FAKE_CMDS=(
        "ls -la"
        "cd /home"
        "cat file.txt"
        "vim script.sh"
        "chmod +x run.sh"
        "grep 'pattern' log.txt"
        "find . -name '*.txt'"
        "ps aux | grep process"
        "sudo apt update"
        "git clone repo"
        "wget http://example.com"
        "curl -X GET api.example.com"
        "python3 script.py"
        "gcc -o program main.c"
        "make install"
        "docker run -it ubuntu"
        "ssh user@server"
        "scp file.txt user@host:/path"
        "tar -xzf archive.tar.gz"
        "zip -r backup.zip folder/"
        "unzip file.zip"
        "rm -rf /tmp/cache"
        "mkdir -p /opt/project"
        "touch newfile.txt"
        "nano config.conf"
        "systemctl status service"
        "journalctl -xe"
        "netstat -tuln"
        "ifconfig eth0"
        "ping google.com"
        "traceroute 8.8.8.8"
        "nmap -sV target"
        "tcpdump -i eth0"
        "iptables -L"
        "ufw status"
        "df -h"
        "du -sh *"
        "top"
        "htop"
        "free -m"
        "uptime"
        "whoami"
        "id"
        "sudo -l"
        "passwd"
        "useradd newuser"
        "usermod -aG sudo user"
        "chown user:group file"
        "mount /dev/sda1 /mnt"
        "umount /mnt"
    )
    
    # Generate 5000 random commands
    for i in {1..5000}; do
        RAND_CMD=${FAKE_CMDS[$RANDOM % ${#FAKE_CMDS[@]}]}
        echo "$RAND_CMD" >> "$TEMP_HISTORY"
    done
    
    # The command that reveals the flag
    ORIGINAL_CMD='echo "FLAG{history_forensics_expert}"'
    
    # Step 1: ROT13 encode
    ROT13=$(echo "$ORIGINAL_CMD" | tr 'A-Za-z' 'N-ZA-Mn-za-m')
    
    # Step 2: Convert to HEX
    HEX=$(echo -n "$ROT13" | xxd -p | tr -d '\n')
    
    # Step 3: Base64 encode
    BASE64=$(echo -n "$HEX" | base64 -w 0)
    
    # Add some hints (obfuscated comments) around line 7500
    for i in {5001..7499}; do
        RAND_CMD=${FAKE_CMDS[$RANDOM % ${#FAKE_CMDS[@]}]}
        echo "$RAND_CMD" >> "$TEMP_HISTORY"
    done
    
    # Insert the obfuscated command at line 7500
    echo "# decode: echo $BASE64 | base64 -d | xxd -r -p | tr 'A-Za-z' 'N-ZA-Mn-za-m' | bash" >> "$TEMP_HISTORY"
    
    # Add more fake commands after
    for i in {7501..10000}; do
        RAND_CMD=${FAKE_CMDS[$RANDOM % ${#FAKE_CMDS[@]}]}
        echo "$RAND_CMD" >> "$TEMP_HISTORY"
    done
    
    # Add some red herrings with similar patterns
    sed -i '3000i# encoded_data: RkxBR3toZXJyaW5nfQ==' "$TEMP_HISTORY"
    sed -i '6000i# secret: ZWNobyAiZmFrZV9mbGFnIg==' "$TEMP_HISTORY"
    sed -i '9000i# hint: check line 7500' "$TEMP_HISTORY"
    
    # Copy to actual bash_history
    cat "$TEMP_HISTORY" > ~/.bash_history
    rm "$TEMP_HISTORY"
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Bash history generated with 10000+ entries"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Hiding obfuscated command in history..."
sleep 0.5
echo -e "${GREEN}[✓]${NC} Command hidden at line ~7500"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Adding red herring entries..."
sleep 0.4
echo -e "${GREEN}[✓]${NC} Multiple fake encoded strings added"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Finalizing challenge setup..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Challenge ready!"
sleep 0.3

# Create cleanup script
cat > /tmp/cleanup_ctf_2_2.sh << 'EOF'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}[*]${NC} Cleaning up CTF 2.2..."

# Find and restore backup
BACKUP=$(ls -t ~/.bash_history.backup.* 2>/dev/null | head -1)
if [ -f "$BACKUP" ]; then
    mv "$BACKUP" ~/.bash_history
    echo -e "${GREEN}[✓]${NC} Original history restored from backup"
else
    echo -e "${YELLOW}[!]${NC} No backup found, clearing challenge history"
    > ~/.bash_history
fi

# Remove other backups
rm -f ~/.bash_history.backup.* 2>/dev/null

echo -e "${GREEN}[✓]${NC} Cleanup complete!"
EOF
chmod +x /tmp/cleanup_ctf_2_2.sh

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}     CTF 2.2: ${MAGENTA}BASH HISTORY FORENSICS${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📊 Difficulty:${NC}    ${RED}MEDIUM${NC}"
echo -e "${YELLOW}⏱️  Est. Time:${NC}     30-60 minutes"
echo -e "${YELLOW}🎯 Category:${NC}      Command Line Forensics"
echo -e "${YELLOW}📍 Location:${NC}      ${CYAN}~/.bash_history${NC}"
echo -e "${YELLOW}📝 Total Lines:${NC}   ${RED}10000+${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📖 CHALLENGE DESCRIPTION:${NC}"
echo ""
echo -e "  ${WHITE}Your bash history file has been filled with 10000+ commands.${NC}"
echo -e "  ${WHITE}Somewhere hidden in this massive file is an obfuscated command${NC}"
echo -e "  ${WHITE}that has been encoded THREE times:${NC}"
echo ""
echo -e "  ${CYAN}  Layer 1:${NC} ${YELLOW}Base64 encoding${NC}"
echo -e "  ${CYAN}  Layer 2:${NC} ${YELLOW}Hexadecimal encoding${NC}"
echo -e "  ${CYAN}  Layer 3:${NC} ${YELLOW}ROT13 cipher${NC}"
echo ""
echo -e "  ${WHITE}When properly decoded and executed, it reveals the flag.${NC}"
echo ""
echo -e "  ${RED}⚠️  WARNING:${NC} Multiple fake encoded strings are present!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🎯 YOUR MISSION:${NC}"
echo ""
echo -e "  ${GREEN}→${NC} Search through 10000+ lines in ~/.bash_history"
echo -e "  ${GREEN}→${NC} Identify the obfuscated command"
echo -e "  ${GREEN}→${NC} Decode Base64 → Hex → ROT13"
echo -e "  ${GREEN}→${NC} Execute the decoded command"
echo -e "  ${GREEN}→${NC} Capture the flag!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 SKILLS REQUIRED:${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} File searching and filtering (grep, awk, sed)"
echo -e "  ${MAGENTA}•${NC} Base64 decoding"
echo -e "  ${MAGENTA}•${NC} Hexadecimal conversion"
echo -e "  ${MAGENTA}•${NC} ROT13 cipher decryption"
echo -e "  ${MAGENTA}•${NC} Pattern recognition"
echo -e "  ${MAGENTA}•${NC} Bash command execution"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🛠️  USEFUL TOOLS:${NC}"
echo ""
echo -e "  ${CYAN}grep, awk, sed, base64, xxd, tr,${NC}"
echo -e "  ${CYAN}cat, less, head, tail, wc${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 HINTS:${NC}"
echo -e "  ${YELLOW}1. Look for comments starting with '# decode:'${NC}"
echo -e "  ${YELLOW}2. The real command is around line 7500${NC}"
echo -e "  ${YELLOW}3. Check line 9000 for another clue${NC}"
echo -e "  ${YELLOW}4. Decode order: base64 → hex → rot13${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Challenge is now LIVE!${NC}"
echo ""
echo -e "${YELLOW}📂 File:${NC} ${CYAN}~/.bash_history${NC} (10000+ lines)"
echo -e "${YELLOW}🧹 Cleanup:${NC} Run ${CYAN}/tmp/cleanup_ctf_2_2.sh${NC} to restore original history"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${RED}      🔍 BECOME A FORENSICS EXPERT! 🔍${NC}"
echo ""