#!/bin/bash

# CTF 4.1 - Process Memory Forensics Challenge
# Sermikro CTF Portal
# Difficulty: HARD

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
MAGENTA='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m'
BOLD='\033[1m'

# Animation function
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

# Banner
clear
echo -e "${CYAN}"
echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║           🔐  SERMIKRO CTF PORTAL  🔐                     ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo -e "${NC}"
sleep 0.5

echo -e "${YELLOW}[*]${NC} Initializing CTF 4.1 environment..."
sleep 0.3

# Check if previous challenge process is running
if [ -f /tmp/ctf_4_1_pid.txt ]; then
    OLD_PID=$(cat /tmp/ctf_4_1_pid.txt)
    kill $OLD_PID 2>/dev/null
    rm /tmp/ctf_4_1_pid.txt
fi

echo -e "${YELLOW}[*]${NC} Creating hidden process with flag in memory..."
(
    # Create a C program that holds flag in memory
    cat > /tmp/secret_daemon.c << 'CCODE'
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <signal.h>

volatile int keep_running = 1;

void sigterm_handler(int signum) {
    keep_running = 0;
}

int main() {
    // Flag hidden in memory
    char secret_flag[] = "FLAG{proc_memory_forensics}";
    char decoy1[] = "FAKE{not_the_real_flag}";
    char decoy2[] = "TEST{this_is_wrong}";
    char decoy3[] = "WRONG{try_again}";
    
    // Additional decoy data
    char buffer[1024];
    sprintf(buffer, "Process ID: %d | Status: Running | Uptime: calculating...", getpid());
    
    // Set up signal handler
    signal(SIGTERM, sigterm_handler);
    signal(SIGINT, sigterm_handler);
    
    // Daemon-like behavior
    printf("System Monitor Service [PID: %d] - Started\n", getpid());
    fflush(stdout);
    
    // Keep the process running and memory allocated
    while(keep_running) {
        // Do some fake work to look like a real daemon
        usleep(500000); // Sleep 0.5 seconds
        
        // Touch the memory to keep it allocated
        volatile int checksum = 0;
        for(int i = 0; i < strlen(secret_flag); i++) {
            checksum += secret_flag[i];
        }
    }
    
    printf("System Monitor Service - Shutting down\n");
    return 0;
}
CCODE

    # Compile the program
    gcc -o /tmp/secret_daemon /tmp/secret_daemon.c 2>/dev/null
    
    if [ $? -ne 0 ]; then
        echo "Compilation failed, installing gcc..."
        sudo apt-get update -qq > /dev/null 2>&1
        sudo apt-get install -y gcc -qq > /dev/null 2>&1
        gcc -o /tmp/secret_daemon /tmp/secret_daemon.c
    fi
    
    # Run the daemon in background
    /tmp/secret_daemon > /tmp/secret_daemon.log 2>&1 &
    DAEMON_PID=$!
    
    # Save PID for later cleanup
    echo $DAEMON_PID > /tmp/ctf_4_1_pid.txt
    
    # Give it a second to start
    sleep 1
    
    # Verify it's running
    if ps -p $DAEMON_PID > /dev/null; then
        echo $DAEMON_PID > /tmp/ctf_4_1_target_pid.txt
    fi
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Hidden process created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Loading flag into process memory..."
sleep 0.5
echo -e "${GREEN}[✓]${NC} Flag loaded in memory space"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Creating decoy processes..."
(
    # Create some decoy processes to make it harder
    for i in {1..5}; do
        sleep 3600 &
        echo $! >> /tmp/ctf_4_1_decoys.txt
    done
    
    python3 -c "import time; time.sleep(3600)" &
    echo $! >> /tmp/ctf_4_1_decoys.txt
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Decoy processes deployed"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Finalizing challenge setup..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Challenge ready!"
sleep 0.3

# Get the actual PID
if [ -f /tmp/ctf_4_1_target_pid.txt ]; then
    TARGET_PID=$(cat /tmp/ctf_4_1_target_pid.txt)
else
    TARGET_PID="unknown"
fi

# Create cleanup script
cat > /tmp/cleanup_ctf_4_1.sh << 'EOF'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}[*]${NC} Cleaning up CTF 4.1..."

# Kill main process
if [ -f /tmp/ctf_4_1_pid.txt ]; then
    PID=$(cat /tmp/ctf_4_1_pid.txt)
    kill $PID 2>/dev/null
    rm /tmp/ctf_4_1_pid.txt
fi

# Kill decoy processes
if [ -f /tmp/ctf_4_1_decoys.txt ]; then
    while read pid; do
        kill $pid 2>/dev/null
    done < /tmp/ctf_4_1_decoys.txt
    rm /tmp/ctf_4_1_decoys.txt
fi

# Remove temporary files
rm -f /tmp/secret_daemon.c
rm -f /tmp/secret_daemon
rm -f /tmp/secret_daemon.log
rm -f /tmp/ctf_4_1_target_pid.txt

echo -e "${GREEN}[✓]${NC} Cleanup complete!"
EOF
chmod +x /tmp/cleanup_ctf_4_1.sh

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}     CTF 4.1: ${MAGENTA}PROCESS MEMORY FORENSICS${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📊 Difficulty:${NC}     ${RED}HARD${NC}"
echo -e "${YELLOW}⏱️  Est. Time:${NC}     45-60 minutes"
echo -e "${YELLOW}🎯 Category:${NC}       Linux Filesystem & Process Analysis"
echo -e "${YELLOW}📍 Location:${NC}       ${CYAN}/proc/ virtual filesystem${NC}"
echo -e "${YELLOW}🔍 Target PID:${NC}     ${RED}??? (you must find it!)${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📖 CHALLENGE DESCRIPTION:${NC}"
echo ""
echo -e "  ${WHITE}A daemon process is running on your system with a flag${NC}"
echo -e "  ${WHITE}stored in its memory space. The flag is NOT in any file,${NC}"
echo -e "  ${WHITE}NOT in environment variables, but in the process's active${NC}"
echo -e "  ${WHITE}memory allocation.${NC}"
echo ""
echo -e "  ${WHITE}You must use Linux's /proc virtual filesystem to:${NC}"
echo -e "  ${WHITE}  1. Identify which process contains the flag${NC}"
echo -e "  ${WHITE}  2. Analyze its memory mappings${NC}"
echo -e "  ${WHITE}  3. Extract the flag from process memory${NC}"
echo ""
echo -e "  ${RED}⚠️  Challenge:${NC} Multiple decoy processes are running!"
echo -e "  ${RED}⚠️  Warning:${NC} Process memory is protected - need proper access!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🎯 YOUR MISSION:${NC}"
echo ""
echo -e "  ${GREEN}→${NC} List all running processes on the system"
echo -e "  ${GREEN}→${NC} Identify suspicious or unusual processes"
echo -e "  ${GREEN}→${NC} Examine /proc/[PID]/maps for memory layout"
echo -e "  ${GREEN}→${NC} Search process memory using /proc/[PID]/mem"
echo -e "  ${GREEN}→${NC} Extract the flag from memory"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 SKILLS REQUIRED:${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} /proc filesystem knowledge"
echo -e "  ${MAGENTA}•${NC} Process memory analysis"
echo -e "  ${MAGENTA}•${NC} Memory mapping understanding"
echo -e "  ${MAGENTA}•${NC} Binary data extraction"
echo -e "  ${MAGENTA}•${NC} String searching in memory"
echo -e "  ${MAGENTA}•${NC} Linux process management"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🛠️  USEFUL COMMANDS:${NC}"
echo ""
echo -e "  ${CYAN}ps, pgrep, grep, cat, strings, gdb,${NC}"
echo -e "  ${CYAN}dd, xxd, hexdump, sudo${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 HINTS:${NC}"
echo -e "  ${YELLOW}1. Look for recently started processes${NC}"
echo -e "  ${YELLOW}2. Process name might contain 'daemon' or 'service'${NC}"
echo -e "  ${YELLOW}3. Check /proc/[PID]/cmdline for process info${NC}"
echo -e "  ${YELLOW}4. Use 'strings' command on /proc/[PID]/mem${NC}"
echo -e "  ${YELLOW}5. You may need sudo/root access for memory reading${NC}"
echo -e "  ${YELLOW}6. Memory mappings show readable regions${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🔍 GETTING STARTED:${NC}"
echo ""
echo -e "  ${WHITE}List all processes:${NC}"
echo -e "  ${CYAN}$ ps aux${NC}"
echo ""
echo -e "  ${WHITE}Find recent processes:${NC}"
echo -e "  ${CYAN}$ ps aux --sort=-start_time | head -20${NC}"
echo ""
echo -e "  ${WHITE}Check process info:${NC}"
echo -e "  ${CYAN}$ cat /proc/[PID]/cmdline${NC}"
echo -e "  ${CYAN}$ cat /proc/[PID]/maps${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Challenge is now LIVE!${NC}"
echo ""
echo -e "${YELLOW}🎯 Target:${NC} Find the daemon process with flag in memory"
echo -e "${YELLOW}🧹 Cleanup:${NC} Run ${CYAN}/tmp/cleanup_ctf_4_1.sh${NC} when done"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${RED}      🧠 MASTER MEMORY FORENSICS! 🧠${NC}"
echo ""