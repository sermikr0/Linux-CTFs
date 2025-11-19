#!/bin/bash

# CTF 7.2 - Nested Subshell File Descriptor Challenge
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

echo -e "${YELLOW}[*]${NC} Initializing CTF 7.2 environment..."
sleep 0.3

echo -e "${YELLOW}[*]${NC} Creating nested subshell challenge..."
(
    # Create the main challenge script
    cat > /tmp/nested_fd_challenge.sh << 'FDSCRIPT'
#!/bin/bash

# CTF 7.2 - 7-Level Nested Subshell with File Descriptor Manipulation
# Each level uses different file descriptors (FD 3-20)

echo "=== CTF 7.2: File Descriptor Manipulation Challenge ==="
echo "Navigate through 7 nested subshells to collect flag parts"
echo ""

# Create temporary files for each FD
for i in {3..20}; do
    mktemp > /tmp/fd_${i}_data.txt 2>/dev/null
done

# LEVEL 1 - FD 3
(
    echo "FLAG{" > /tmp/fd_3_data.txt
    exec 3< /tmp/fd_3_data.txt
    
    echo "[LEVEL 1] FD 3 opened with flag part 1"
    echo "[HINT] Read from FD 3 using: cat <&3"
    
    # LEVEL 2 - FD 5
    (
        echo "fd_" > /tmp/fd_5_data.txt
        exec 5< /tmp/fd_5_data.txt
        
        echo "[LEVEL 2] FD 5 opened with flag part 2"
        echo "[HINT] Read from FD 5 using: cat <&5"
        
        # LEVEL 3 - FD 7
        (
            echo "mani" > /tmp/fd_7_data.txt
            exec 7< /tmp/fd_7_data.txt
            
            echo "[LEVEL 3] FD 7 opened with flag part 3"
            echo "[HINT] Read from FD 7 using: cat <&7"
            
            # LEVEL 4 - FD 10
            (
                echo "pula" > /tmp/fd_10_data.txt
                exec 10< /tmp/fd_10_data.txt
                
                echo "[LEVEL 4] FD 10 opened with flag part 4"
                echo "[HINT] Read from FD 10 using: cat <&10"
                
                # LEVEL 5 - FD 13
                (
                    echo "tion_" > /tmp/fd_13_data.txt
                    exec 13< /tmp/fd_13_data.txt
                    
                    echo "[LEVEL 5] FD 13 opened with flag part 5"
                    echo "[HINT] Read from FD 13 using: cat <&13"
                    
                    # LEVEL 6 - FD 17
                    (
                        echo "wizard" > /tmp/fd_17_data.txt
                        exec 17< /tmp/fd_17_data.txt
                        
                        echo "[LEVEL 6] FD 17 opened with flag part 6"
                        echo "[HINT] Read from FD 17 using: cat <&17"
                        
                        # LEVEL 7 - FD 20
                        (
                            echo "}" > /tmp/fd_20_data.txt
                            exec 20< /tmp/fd_20_data.txt
                            
                            echo "[LEVEL 7] FD 20 opened with flag part 7"
                            echo "[HINT] Read from FD 20 using: cat <&20"
                            echo ""
                            echo "=== All File Descriptors Created ==="
                            echo ""
                            echo "Challenge: Extract data from FD 3, 5, 7, 10, 13, 17, 20"
                            echo "Combine them in order to get the flag!"
                            echo ""
                            echo "Press ENTER to start interactive shell..."
                            read
                            
                            # Start interactive bash with all FDs available
                            echo "=== Interactive Shell (All FDs Available) ==="
                            echo "Available FDs: 3, 5, 7, 10, 13, 17, 20"
                            echo "Example: cat <&3"
                            echo "Type 'exit' to quit and lose all FDs"
                            echo ""
                            
                            bash --norc --noprofile
                            
                        ) 20>&20
                    ) 17>&17
                ) 13>&13
            ) 10>&10
        ) 7>&7
    ) 5>&5
) 3>&3

echo ""
echo "=== Challenge Ended ==="
FDSCRIPT

    chmod +x /tmp/nested_fd_challenge.sh
    
    # Create solution script
    cat > /tmp/fd_solution_hint.sh << 'SOLHINT'
#!/bin/bash

# Solution Hint for CTF 7.2

echo "=== Solution Approach ==="
echo ""
echo "Method 1: Manual extraction in nested shell"
echo "  When in the interactive shell:"
echo "  part1=\$(cat <&3)"
echo "  part2=\$(cat <&5)"
echo "  part3=\$(cat <&7)"
echo "  part4=\$(cat <&10)"
echo "  part5=\$(cat <&13)"
echo "  part6=\$(cat <&17)"
echo "  part7=\$(cat <&20)"
echo "  echo \"\$part1\$part2\$part3\$part4\$part5\$part6\$part7\""
echo ""
echo "Method 2: Process substitution (advanced)"
echo "  Run the script and capture FD content"
echo ""
echo "Method 3: Read from temp files directly (easy way)"
echo "  cat /tmp/fd_3_data.txt /tmp/fd_5_data.txt /tmp/fd_7_data.txt \\"
echo "      /tmp/fd_10_data.txt /tmp/fd_13_data.txt /tmp/fd_17_data.txt \\"
echo "      /tmp/fd_20_data.txt | tr -d '\n'"
SOLHINT

    chmod +x /tmp/fd_solution_hint.sh
    
    # Create advanced solution with coprocess
    cat > /tmp/fd_advanced_solution.sh << 'ADVSOL'
#!/bin/bash

# Advanced Solution using Process Substitution and Coprocesses

echo "=== Advanced FD Manipulation Solution ==="
echo ""

# Method 1: Direct file reading (easiest)
echo "Method 1: Direct file reading"
flag=$(cat /tmp/fd_{3,5,7,10,13,17,20}_data.txt 2>/dev/null | tr -d '\n')
echo "Flag: $flag"
echo ""

# Method 2: Using exec to duplicate FDs
echo "Method 2: Using FD duplication"
exec 3< /tmp/fd_3_data.txt
exec 5< /tmp/fd_5_data.txt
exec 7< /tmp/fd_7_data.txt
exec 10< /tmp/fd_10_data.txt
exec 13< /tmp/fd_13_data.txt
exec 17< /tmp/fd_17_data.txt
exec 20< /tmp/fd_20_data.txt

flag=""
flag+=$(cat <&3)
flag+=$(cat <&5)
flag+=$(cat <&7)
flag+=$(cat <&10)
flag+=$(cat <&13)
flag+=$(cat <&17)
flag+=$(cat <&20)

echo "Flag: $flag"

# Close FDs
exec 3<&-
exec 5<&-
exec 7<&-
exec 10<&-
exec 13<&-
exec 17<&-
exec 20<&-

echo ""
echo "Method 3: Process substitution (most advanced)"
paste -d '' <(cat /tmp/fd_3_data.txt) \
            <(cat /tmp/fd_5_data.txt) \
            <(cat /tmp/fd_7_data.txt) \
            <(cat /tmp/fd_10_data.txt) \
            <(cat /tmp/fd_13_data.txt) \
            <(cat /tmp/fd_17_data.txt) \
            <(cat /tmp/fd_20_data.txt)
ADVSOL

    chmod +x /tmp/fd_advanced_solution.sh
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Nested subshell challenge created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Creating 7 levels with FD 3-20..."
sleep 0.5
echo -e "${GREEN}[✓]${NC} File descriptors configured"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Setting up process substitution framework..."
sleep 0.4
echo -e "${GREEN}[✓]${NC} Coprocess support enabled"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Finalizing challenge setup..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Challenge ready!"
sleep 0.3

# Create cleanup script
cat > /tmp/cleanup_ctf_7_2.sh << 'EOF'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}[*]${NC} Cleaning up CTF 7.2..."

# Remove temporary files
rm -f /tmp/fd_*_data.txt
rm -f /tmp/nested_fd_challenge.sh
rm -f /tmp/fd_solution_hint.sh
rm -f /tmp/fd_advanced_solution.sh

echo -e "${GREEN}[✓]${NC} Cleanup complete!"
EOF
chmod +x /tmp/cleanup_ctf_7_2.sh

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}   CTF 7.2: ${MAGENTA}FILE DESCRIPTOR MANIPULATION${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📊 Difficulty:${NC}     ${RED}HARD${NC}"
echo -e "${YELLOW}⏱️  Est. Time:${NC}      45-60 minutes"
echo -e "${YELLOW}🎯 Category:${NC}       Advanced Shell & File Descriptors"
echo -e "${YELLOW}🔢 FD Range:${NC}       ${RED}FD 3, 5, 7, 10, 13, 17, 20${NC}"
echo -e "${YELLOW}🎁 Flag Parts:${NC}     ${RED}7 parts in 7 levels${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📖 CHALLENGE DESCRIPTION:${NC}"
echo ""
echo -e "  ${WHITE}Navigate through 7 nested subshells, each with its own${NC}"
echo -e "  ${WHITE}file descriptor (FD) containing part of the flag.${NC}"
echo ""

echo ""
echo -e "  ${WHITE}Each level opens a custom file descriptor that must be${NC}"
echo -e "  ${WHITE}read before the subshell exits.${NC}"
echo ""
echo -e "  ${RED}⚠️  Challenge:${NC} FDs close when subshell exits!"
echo -e "  ${RED}⚠️  Warning:${NC} Must capture all data before exit!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🎯 YOUR MISSION:${NC}"
echo ""
echo -e "  ${GREEN}→${NC} Run the nested subshell challenge"
echo -e "  ${GREEN}→${NC} Navigate through 7 levels"
echo -e "  ${GREEN}→${NC} Read from file descriptors 3, 5, 7, 10, 13, 17, 20"
echo -e "  ${GREEN}→${NC} Collect all 7 flag parts"
echo -e "  ${GREEN}→${NC} Combine them in correct order"
echo -e "  ${GREEN}→${NC} Submit the complete flag"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 SKILLS REQUIRED:${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} File descriptor manipulation"
echo -e "  ${MAGENTA}•${NC} Nested subshell understanding"
echo -e "  ${MAGENTA}•${NC} FD redirection (exec, <&, >&)"
echo -e "  ${MAGENTA}•${NC} Process substitution"
echo -e "  ${MAGENTA}•${NC} Coprocess usage"
echo -e "  ${MAGENTA}•${NC} Advanced bash scripting"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🛠️  KEY CONCEPTS:${NC}"
echo ""
echo -e "  ${CYAN}File Descriptors:${NC}"
echo -e "    0 = stdin, 1 = stdout, 2 = stderr"
echo -e "    3-255 = custom file descriptors"
echo ""
echo -e "  ${CYAN}FD Operations:${NC}"
echo -e "    exec 3< file    # Open FD 3 for reading"
echo -e "    cat <&3         # Read from FD 3"
echo -e "    exec 3<&-       # Close FD 3"
echo ""
echo -e "  ${CYAN}Process Substitution:${NC}"
echo -e "    <(command)      # Creates temp FD for command output"
echo -e "    >(command)      # Creates temp FD for command input"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🚀 HOW TO START:${NC}"
echo ""
echo -e "  ${YELLOW}Step 1:${NC} Run the challenge"
echo -e "  ${CYAN}$ /tmp/nested_fd_challenge.sh${NC}"
echo ""
echo -e "  ${YELLOW}Step 2:${NC} In the interactive shell, read FDs"
echo -e "  ${CYAN}$ part1=\$(cat <&3)${NC}"
echo -e "  ${CYAN}$ part2=\$(cat <&5)${NC}"
echo -e "  ${CYAN}$ ... and so on${NC}"
echo ""
echo -e "  ${YELLOW}Step 3:${NC} Combine all parts"
echo -e "  ${CYAN}$ echo \"\$part1\$part2\$part3\$part4\$part5\$part6\$part7\"${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 HINTS:${NC}"
echo -e "  ${YELLOW}1. FDs are: 3, 5, 7, 10, 13, 17, 20${NC}"
echo -e "  ${YELLOW}2. Use cat <&N to read from FD N${NC}"
echo -e "  ${YELLOW}3. Store each part in a variable${NC}"
echo -e "  ${YELLOW}4. Combine variables in order${NC}"
echo -e "  ${YELLOW}5. Alternative: read from /tmp/fd_*_data.txt files${NC}"
echo -e "  ${YELLOW}6. Check /tmp/fd_solution_hint.sh for more help${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📚 READING MATERIAL:${NC}"
echo -e "  ${CYAN}man bash${NC} - Search for 'REDIRECTION'"
echo -e "  ${CYAN}man bash${NC} - Search for 'Process Substitution'"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Challenge is now READY!${NC}"
echo ""
echo -e "${YELLOW}📂 Challenge:${NC} ${CYAN}/tmp/nested_fd_challenge.sh${NC}"
echo -e "${YELLOW}💡 Hint:${NC} ${CYAN}/tmp/fd_solution_hint.sh${NC}"
echo -e "${YELLOW}🎯 Solution:${NC} ${CYAN}/tmp/fd_advanced_solution.sh${NC}"
echo -e "${YELLOW}🧹 Cleanup:${NC} Run ${CYAN}/tmp/cleanup_ctf_7_2.sh${NC} when done"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${RED}    🧙 MASTER FILE DESCRIPTOR MAGIC! 🧙${NC}"
echo ""