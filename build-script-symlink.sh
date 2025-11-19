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

echo -e "${YELLOW}[*]${NC} Initializing CTF environment..."
sleep 0.3

(sudo rm -rf /dev/shm/.secrets 2>/dev/null) &
spinner $!
echo -e "${GREEN}[✓]${NC} Old environment cleaned"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Creating advanced maze structure..."
(
    sudo mkdir -p /dev/shm/.secrets/{level1,level2,level3,.hidden1,.hidden2,.hidden3}
    
    FLAG_PART1="FLAG{symlink_"
    FLAG_PART2="maze_master_"
    FLAG_PART3="survivor_2024}"
    
    cd /dev/shm/.secrets
    
    for i in {1..20}; do
        sudo touch "level1/decoy_$i.txt"
        echo "Wrong path $i" | sudo tee "level1/decoy_$i.txt" > /dev/null
    done
    
    echo "$FLAG_PART1" | sudo tee level1/.real_start.tmp > /dev/null
    
    cd level2
    for i in {1..15}; do
        sudo ln -s "../level1/decoy_$i.txt" "link_$i"
    done
    sudo ln -s "../level1/.real_start.tmp" ".secret_path"
    
    cd /dev/shm/.secrets
    
    cd level3
    sudo ln -s "../level2/link_5" "circular_1"
    sudo ln -s "circular_1" "circular_2"
    sudo ln -s "broken_target" "trap_link"
    sudo ln -s "../level2/.secret_path" ".next_clue"
    
    cd /dev/shm/.secrets
    
    cd .hidden1
    echo "$FLAG_PART2" | sudo tee .part2.dat > /dev/null
    sudo ln -s "../level3/.next_clue" "step1"
    
    cd /dev/shm/.secrets/.hidden2
    for i in {1..50}; do
        echo "Fake data $i" | sudo tee "data_$i.txt" > /dev/null
    done
    sudo ln -s "../.hidden1/.part2.dat" "....secret"
    
    cd /dev/shm/.secrets/.hidden3
    echo "$FLAG_PART3" | sudo tee .final.enc > /dev/null
    sudo ln -s "../.hidden2/....secret" " "  
    
    cd /dev/shm/.secrets
    echo "U3RhcnQgZnJvbTogbGV2ZWwyLy5zZWNyZXRfcGF0aA==" | sudo tee .clue.txt > /dev/null
    
    sudo find . -type f -exec touch -d "$(date -d "$((RANDOM%365)) days ago" '+%Y-%m-%d')" {} \;
    
    sudo chmod 000 level1/.real_start.tmp  
    sudo chmod 444 .hidden1/.part2.dat
    sudo chmod 400 .hidden3/.final.enc
    
    sudo setfattr -n user.hint -v "follow_the_dots" level2/.secret_path 2>/dev/null || true
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Advanced maze structure created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Deploying 50+ decoy files..."
sleep 0.5
echo -e "${GREEN}[✓]${NC} Decoys deployed"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Creating circular references..."
sleep 0.4
echo -e "${GREEN}[✓]${NC} Circular traps set"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Obfuscating flag parts..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Flag fragmented and hidden"
sleep 0.3

echo -e "${YELLOW}[*]${NC} Setting advanced permissions..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Challenge hardened!"
sleep 0.3

cat > /tmp/cleanup_ctf_1_1.sh << 'EOF'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'
echo -e "${RED}[*]${NC} Cleaning up CTF 1.1..."
sudo rm -rf /dev/shm/.secrets
echo -e "${GREEN}[✓]${NC} Cleanup complete!"
EOF
chmod +x /tmp/cleanup_ctf_1_1.sh

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}        CTF 1.1: ${MAGENTA}ADVANCED SYMLINK MAZE${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📊 Difficulty:${NC}    ${RED}EASY ⚠️${NC}"
echo -e "${YELLOW}⏱️  Est. Time:${NC}    20-30 minutes"
echo -e "${YELLOW}🎯 Category:${NC}      Linux Filesystem Advanced"
echo -e "${YELLOW}📍 Location:${NC}      ${CYAN}/dev/shm/.secrets/${NC}"
echo -e "${YELLOW}🎁 Flag Parts:${NC}    ${RED}3 fragments (must combine!)${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📖 CHALLENGE DESCRIPTION:${NC}"
echo ""
echo -e "  ${WHITE}The flag has been split into 3 parts and scattered across${NC}"
echo -e "  ${WHITE}a multi-level maze with 50+ decoy files, circular symlinks,${NC}"
echo -e "  ${WHITE}hidden directories, and obfuscated paths. Simple 'ls' and${NC}"
echo -e "  ${WHITE}'cat' won't be enough this time!${NC}"
echo ""
echo -e "  ${RED}⚠️  CHALLENGES:${NC}"
echo -e "  ${RED}  • Files with no read permissions${NC}"
echo -e "  ${RED}  • Symlinks pointing to symlinks (5+ levels deep)${NC}"
echo -e "  ${RED}  • Filenames with special characters (spaces, dots)${NC}"
echo -e "  ${RED}  • Base64 encoded clues${NC}"
echo -e "  ${RED}  • Extended attributes hiding hints${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🎯 YOUR MISSION:${NC}"
echo ""
echo -e "  ${GREEN}→${NC} Find the encoded clue in .clue.txt"
echo -e "  ${GREEN}→${NC} Navigate through 3 levels of maze"
echo -e "  ${GREEN}→${NC} Locate 3 flag fragments"
echo -e "  ${GREEN}→${NC} Bypass permission restrictions"
echo -e "  ${GREEN}→${NC} Combine all parts to get the complete flag"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 SKILLS REQUIRED:${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} Advanced symlink resolution"
echo -e "  ${MAGENTA}•${NC} Base64 decoding"
echo -e "  ${MAGENTA}•${NC} Permission manipulation"
echo -e "  ${MAGENTA}•${NC} Extended attributes (xattr)"
echo -e "  ${MAGENTA}•${NC} Special character handling"
echo -e "  ${MAGENTA}•${NC} Recursive directory traversal"
echo -e "  ${MAGENTA}•${NC} Pattern matching and filtering"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🛠️  USEFUL TOOLS:${NC}"
echo ""
echo -e "  ${CYAN}ls, find, readlink, file, stat, getfattr,${NC}"
echo -e "  ${CYAN}base64, grep, awk, chmod, sudo, cat${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Advanced challenge is now LIVE!${NC}"
echo ""
echo -e "${YELLOW}💡 First Step:${NC} Check ${CYAN}/dev/shm/.secrets/.clue.txt${NC}"
echo -e "${YELLOW}🧹 Cleanup:${NC} Run ${CYAN}/tmp/cleanup_ctf_1_1.sh${NC} when done"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${RED}         🔥 THIS IS THE REAL CHALLENGE! 🔥${NC}"
echo ""