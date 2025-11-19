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

echo -e "${YELLOW}[*]${NC} Initializing CTF 2.1 environment..."
sleep 0.3


(sudo rm -rf /opt/challenge 2>/dev/null) &
spinner $!
echo -e "${GREEN}[✓]${NC} Old environment cleaned"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Creating challenge directory..."
(
    sudo mkdir -p /opt/challenge
    cd /opt/challenge
    sudo touch "F001_random.txt"
    sudo touch "L002_data.doc"
    sudo touch "A003_file.pdf"
    sudo touch "G004_test.xls"
    sudo touch "{005_info.dat"
    sudo touch "c006_code.py"
    sudo touch "l007_script.sh"
    sudo touch "i008_main.c"
    sudo touch "_009_temp.log"
    

    sudo touch "s010_build.txt"
    sudo touch "c011_deploy.doc"
    sudo touch "r012_config.cfg"
    sudo touch "i013_setup.ini"
    sudo touch "p014_system.sys"
    sudo touch "t015_kernel.ko"
    sudo touch "i016_module.mod"
    sudo touch "n017_driver.drv"
    sudo touch "g018_service.svc"
    sudo touch "_019_daemon.pid"
    
    sudo touch "l020_legend.txt"
    sudo touch "e021_epic.doc"
    sudo touch "g022_great.pdf"
    sudo touch "e023_elite.xls"
    sudo touch "n024_ninja.cpp"
    sudo touch "d025_data.h"
    sudo touch "}026_end.txt"
    
    DECOY_CHARS=("a" "b" "d" "f" "h" "j" "k" "m" "o" "q" "u" "v" "w" "x" "y" "z" "A" "B" "C" "D" "E" "H" "I" "J" "K" "M" "N" "O" "P" "Q" "R" "S" "T" "U" "V" "W" "X" "Y" "Z" "0" "1" "2" "3" "4" "5" "6" "7" "8" "9")
    EXTENSIONS=("txt" "doc" "pdf" "xls" "csv" "log" "dat" "bin" "tmp" "bak" "old" "cfg" "ini" "conf")
    
    for i in {027..999}; do
        RAND_CHAR=${DECOY_CHARS[$RANDOM % ${#DECOY_CHARS[@]}]}
        RAND_EXT=${EXTENSIONS[$RANDOM % ${#EXTENSIONS[@]}]}
        RAND_NAME=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1)
        sudo touch "${RAND_CHAR}${i}_${RAND_NAME}.${RAND_EXT}"
    done
    
    for file in *.txt *.doc *.pdf; do
        echo "Decoy content $RANDOM" | sudo tee "$file" > /dev/null 2>&1
    done
    
    sudo find . -type f -exec touch -d "$(date -d "$((RANDOM%365)) days ago" '+%Y-%m-%d')" {} \;
    
    sudo chmod 644 /opt/challenge/*
    sudo chmod 755 /opt/challenge
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Challenge directory created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Generating 1000 files with hidden flag..."
sleep 1
echo -e "${GREEN}[✓]${NC} 1000 files generated"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Hiding flag in filename patterns..."
sleep 0.5
echo -e "${GREEN}[✓]${NC} Flag hidden in first characters"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Adding decoy files..."
sleep 0.4
echo -e "${GREEN}[✓]${NC} 973 decoy files added"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Finalizing challenge setup..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Challenge ready!"
sleep 0.3

cat > /tmp/cleanup_ctf_2_1.sh << 'EOF'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
echo -e "${RED}[*]${NC} Cleaning up CTF 2.1..."
sudo rm -rf /opt/challenge
echo -e "${GREEN}[✓]${NC} Cleanup complete!"
EOF
chmod +x /tmp/cleanup_ctf_2_1.sh

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}     CTF 2.1: ${MAGENTA}FILENAME CHARACTER PUZZLE${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📊 Difficulty:${NC}    ${RED}EASY${NC}"
echo -e "${YELLOW}⏱️  Est. Time:${NC}    20-30 minutes"
echo -e "${YELLOW}🎯 Category:${NC}      Command Line Scripting"
echo -e "${YELLOW}📍 Location:${NC}      ${CYAN}/opt/challenge/${NC}"
echo -e "${YELLOW}📁 Total Files:${NC}   ${RED}1000 files${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📖 CHALLENGE DESCRIPTION:${NC}"
echo ""
echo -e "  ${WHITE}A directory contains exactly 1000 files with random names.${NC}"
echo -e "  ${WHITE}The flag is split into 3 parts, hidden in the FIRST CHARACTER${NC}"
echo -e "  ${WHITE}of specific filenames. Files are numbered sequentially (001-999).${NC}"
echo ""
echo -e "  ${YELLOW}Example pattern:${NC}"
echo -e "  ${CYAN}  F001_random.txt${NC}  → First char: ${GREEN}F${NC}"
echo -e "  ${CYAN}  L002_data.doc${NC}    → First char: ${GREEN}L${NC}"
echo -e "  ${CYAN}  A003_file.pdf${NC}    → First char: ${GREEN}A${NC}"
echo -e "  ${CYAN}  G004_test.xls${NC}    → First char: ${GREEN}G${NC}"
echo ""
echo -e "  ${RED}⚠️  Challenge:${NC} Extract first characters in correct order!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🎯 YOUR MISSION:${NC}"
echo ""
echo -e "  ${GREEN}→${NC} Navigate to /opt/challenge/"
echo -e "  ${GREEN}→${NC} Identify the pattern in filenames"
echo -e "  ${GREEN}→${NC} Extract first characters from files 001-026"
echo -e "  ${GREEN}→${NC} Use bash scripting to automate extraction"
echo -e "  ${GREEN}→${NC} Combine characters to reveal the flag"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 SKILLS REQUIRED:${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} Bash scripting and loops"
echo -e "  ${MAGENTA}•${NC} Pattern matching and regex"
echo -e "  ${MAGENTA}•${NC} String manipulation"
echo -e "  ${MAGENTA}•${NC} File sorting and filtering"
echo -e "  ${MAGENTA}•${NC} Command chaining (pipes)"
echo -e "  ${MAGENTA}•${NC} Text processing (cut, awk, sed)"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🛠️  USEFUL COMMANDS:${NC}"
echo ""
echo -e "  ${CYAN}ls, sort, grep, cut, awk, sed, tr,${NC}"
echo -e "  ${CYAN}for loops, while loops, basename${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 HINT:${NC}"
echo -e "  ${YELLOW}Files are numbered! Sort them by number, not alphabetically.${NC}"
echo -e "  ${YELLOW}The flag format is: FLAG{...}${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Challenge is now LIVE!${NC}"
echo ""
echo -e "${YELLOW}🧹 Cleanup:${NC} Run ${CYAN}/tmp/cleanup_ctf_2_1.sh${NC} when done"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${RED}         🔥 MASTER BASH SCRIPTING! 🔥${NC}"
echo ""