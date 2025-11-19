#!/bin/bash

# CTF 8.1 - Advanced Regex Pattern Matching Challenge
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

echo -e "${YELLOW}[*]${NC} Initializing CTF 8.1 environment..."
sleep 0.3

echo -e "${YELLOW}[*]${NC} This will create a 1GB log file. Continue? (y/n)"
read -r response
if [[ ! "$response" =~ ^[Yy]$ ]]; then
    echo "Challenge creation cancelled."
    exit 0
fi

echo -e "${YELLOW}[*]${NC} Creating log file generator..."
(
    # Create Python script to generate 1GB log file
    cat > /tmp/generate_huge_log.py << 'PYGEN'
#!/usr/bin/env python3
import random
import string
import sys
import base64
import re

# Flag parts (50 characters)
flag = "FLAG{advanced_regex_overlord}"
flag_chars = list(flag)

# Regex patterns (encoded in log file)
patterns = [
    r"(?<=USER:)([A-Z])",           # F - lookbehind
    r"(?<!ERROR)([L])\w{3}",        # L - negative lookbehind  
    r"(\w)\1{2}",                   # A - backreference (AAA)
    r"(?=.*STATUS)G",               # G - lookahead
    r"\{(?=[^}]*$)",                # { - lookahead with negation
    r"(?<=ID:)\d{3}([a-z])",        # a - lookbehind with capture
    r"(\w)(?=\d{3})",               # d - lookahead
    r"(?<!START)v",                 # v - negative lookbehind
    r"(?<=::)([a-z])\1",            # a - backreference after lookbehind
    r"n(?=ced)",                    # n - lookahead
]

def generate_fake_log():
    templates = [
        "ERROR: Connection timeout to {ip}",
        "INFO: User {user} logged in from {ip}",
        "WARN: Memory usage at {percent}%",
        "DEBUG: Processing request #{id}",
        "TRACE: Function {func} called",
        "CRITICAL: Database connection lost",
        "NOTICE: Service restarted",
        "ALERT: Suspicious activity detected",
    ]
    
    template = random.choice(templates)
    log = template.format(
        ip='.'.join(str(random.randint(0,255)) for _ in range(4)),
        user=''.join(random.choices(string.ascii_lowercase, k=8)),
        percent=random.randint(50,99),
        id=random.randint(10000,99999),
        func=''.join(random.choices(string.ascii_lowercase, k=10))
    )
    return log

def generate_pattern_hint(idx, pattern):
    """Generate encoded pattern hints in log"""
    encoded = base64.b64encode(pattern.encode()).decode()
    return f"[PATTERN_HINT_{idx:02d}] REGEX: {encoded}"

def generate_flag_line(char, pattern_idx):
    """Generate a log line that matches specific pattern and contains flag char"""
    
    templates = {
        0: f"USER:{char}rank_{random.randint(1000,9999)}",
        1: f"INFO: {char}ogin successful for user",
        2: f"AAA{char}123 status check",
        3: f"REQUEST {char}ET /api STATUS:200",
        4: f"CONFIG: enabled{char} timestamp",
        5: f"ID:{random.randint(100,999)}{char}min_session",
        6: f"{char}123 packets received",
        7: f"RUNNING:{char}ersion check",
        8: f"TRACE::{char}{char} buffer",
        9: f"[INFO] adva{char}ced logging enabled",
    }
    
    # Cycle through templates
    template_idx = pattern_idx % len(templates)
    return templates.get(template_idx, f"DATA: {char}_line_{random.randint(1,9999)}")

def main():
    output_file = "/tmp/ctf_huge_log.txt"
    target_size = 1 * 1024 * 1024 * 1024  # 1 GB
    
    print(f"[*] Generating 1GB log file: {output_file}", file=sys.stderr)
    print(f"[*] This may take several minutes...", file=sys.stderr)
    
    current_size = 0
    lines_written = 0
    flag_lines_inserted = 0
    pattern_hints_inserted = 0
    
    with open(output_file, 'w') as f:
        # Insert pattern hints first (encoded)
        for idx, pattern in enumerate(patterns):
            hint = generate_pattern_hint(idx, pattern)
            f.write(hint + '\n')
            current_size += len(hint) + 1
            pattern_hints_inserted += 1
        
        # Calculate approximate lines needed
        avg_line_size = 80
        total_lines = target_size // avg_line_size
        
        # Distribute flag characters across the file
        flag_positions = sorted(random.sample(range(1000, total_lines - 1000), len(flag_chars)))
        
        flag_idx = 0
        
        for line_num in range(total_lines):
            # Check if we need to insert a flag character
            if flag_idx < len(flag_chars) and line_num == flag_positions[flag_idx]:
                pattern_idx = flag_idx % len(patterns)
                line = generate_flag_line(flag_chars[flag_idx], pattern_idx)
                flag_lines_inserted += 1
                flag_idx += 1
            else:
                line = generate_fake_log()
            
            f.write(line + '\n')
            current_size += len(line) + 1
            lines_written += 1
            
            # Progress indicator
            if lines_written % 100000 == 0:
                progress = (current_size / target_size) * 100
                print(f"[*] Progress: {progress:.1f}% ({lines_written:,} lines)", file=sys.stderr)
            
            # Stop if we reached target size
            if current_size >= target_size:
                break
    
    print(f"[+] Log file generated!", file=sys.stderr)
    print(f"[+] Size: {current_size / (1024*1024):.2f} MB", file=sys.stderr)
    print(f"[+] Total lines: {lines_written:,}", file=sys.stderr)
    print(f"[+] Flag characters hidden: {flag_lines_inserted}", file=sys.stderr)
    print(f"[+] Pattern hints: {pattern_hints_inserted}", file=sys.stderr)

if __name__ == "__main__":
    main()
PYGEN

    chmod +x /tmp/generate_huge_log.py
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Log generator created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Generating 1GB log file (this will take 3-5 minutes)..."
echo -e "${CYAN}    Please wait...${NC}"

python3 /tmp/generate_huge_log.py

if [ -f /tmp/ctf_huge_log.txt ]; then
    echo -e "${GREEN}[✓]${NC} Log file generated successfully"
    FILE_SIZE=$(du -h /tmp/ctf_huge_log.txt | cut -f1)
    echo -e "${GREEN}    Size: $FILE_SIZE${NC}"
else
    echo -e "${RED}[✗]${NC} Failed to generate log file"
    exit 1
fi

sleep 0.2

echo -e "${YELLOW}[*]${NC} Creating solution scripts..."
(
    # Create solution hint
    cat > /tmp/regex_solution_hint.py << 'SOLHINT'
#!/usr/bin/env python3
"""
Solution Hint for CTF 8.1

Steps:
1. Extract encoded regex patterns from log file
   - Lines starting with [PATTERN_HINT_XX]
   - Decode base64 to get actual patterns

2. Apply each pattern to find matching lines
   - Use memory-efficient line-by-line processing
   - Don't load entire 1GB file into memory!

3. Extract flag characters from matched lines
   - Each pattern reveals one character
   - Combine characters in order

Example:
    import re, base64
    
    # Read patterns
    patterns = []
    with open('/tmp/ctf_huge_log.txt', 'r') as f:
        for line in f:
            if 'PATTERN_HINT' in line:
                encoded = line.split('REGEX: ')[1].strip()
                pattern = base64.b64decode(encoded).decode()
                patterns.append(pattern)
    
    # Find flag characters
    flag_chars = []
    for pattern in patterns:
        with open('/tmp/ctf_huge_log.txt', 'r') as f:
            for line in f:
                match = re.search(pattern, line)
                if match:
                    # Extract character
                    # ...
                    break
    
    flag = ''.join(flag_chars)
"""
SOLHINT

    # Create full solution
    cat > /tmp/regex_full_solution.py << 'FULLSOL'
#!/usr/bin/env python3
import re
import base64

print("=== CTF 8.1 Solution ===")
print("[*] Processing 1GB log file...")

log_file = '/tmp/ctf_huge_log.txt'

# Step 1: Extract patterns
print("[*] Step 1: Extracting regex patterns...")
patterns = []

with open(log_file, 'r') as f:
    for line in f:
        if 'PATTERN_HINT' in line:
            try:
                encoded = line.split('REGEX: ')[1].strip()
                pattern = base64.b64decode(encoded).decode()
                patterns.append(pattern)
                print(f"    Pattern {len(patterns)}: {pattern}")
            except:
                pass

print(f"[+] Found {len(patterns)} patterns")

# Step 2: Find flag characters (memory efficient)
print("[*] Step 2: Searching for flag characters...")
flag_chars = ['?'] * len(patterns)  # Placeholder

for idx, pattern in enumerate(patterns):
    print(f"    Searching with pattern {idx}: {pattern}")
    
    with open(log_file, 'r') as f:
        for line_num, line in enumerate(f):
            if 'PATTERN_HINT' in line:
                continue  # Skip pattern hints
            
            try:
                match = re.search(pattern, line)
                if match:
                    # Try to extract character
                    if match.groups():
                        char = match.group(1)[0] if match.group(1) else match.group(0)[0]
                    else:
                        char = match.group(0)[0]
                    
                    flag_chars[idx] = char
                    print(f"    ✓ Found: '{char}' at line {line_num}")
                    break
            except:
                pass

# Step 3: Combine flag
flag = ''.join(flag_chars)
print()
print("=" * 50)
print(f"🎯 FLAG: {flag}")
print("=" * 50)
FULLSOL

    chmod +x /tmp/regex_solution_hint.py
    chmod +x /tmp/regex_full_solution.py
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Solution scripts created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Finalizing challenge setup..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Challenge ready!"
sleep 0.3

# Create cleanup script
cat > /tmp/cleanup_ctf_8_1.sh << 'EOF'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${RED}[*]${NC} Cleaning up CTF 8.1..."
echo -e "${YELLOW}[!]${NC} This will delete the 1GB log file"
read -p "Continue? (y/n) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -f /tmp/ctf_huge_log.txt
    rm -f /tmp/generate_huge_log.py
    rm -f /tmp/regex_solution_hint.py
    rm -f /tmp/regex_full_solution.py
    echo -e "${GREEN}[✓]${NC} Cleanup complete!"
else
    echo -e "${YELLOW}[!]${NC} Cleanup cancelled"
fi
EOF
chmod +x /tmp/cleanup_ctf_8_1.sh

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}   CTF 8.1: ${MAGENTA}ADVANCED REGEX OVERLORD${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📊 Difficulty:${NC}     ${RED}HARD${NC}"
echo -e "${YELLOW}⏱️  Est. Time:${NC}      60-90 minutes"
echo -e "${YELLOW}🎯 Category:${NC}       Advanced Regex & Text Processing"
echo -e "${YELLOW}📁 File Size:${NC}      ${RED}1 GB${NC}"
echo -e "${YELLOW}📝 Total Lines:${NC}   ${RED}~13 million${NC}"
echo -e "${YELLOW}🎁 Flag Parts:${NC}     ${RED}Hidden in 50 non-contiguous lines${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📖 CHALLENGE DESCRIPTION:${NC}"
echo ""
echo -e "  ${WHITE}A massive 1GB log file contains flag characters scattered${NC}"
echo -e "  ${WHITE}across 50 different lines. Each character requires a unique${NC}"
echo -e "  ${WHITE}regex pattern to locate it.${NC}"
echo ""
echo -e "  ${RED}Advanced Regex Required:${NC}"
echo -e "  ${CYAN}  • Positive lookahead:${NC}     (?=pattern)"
echo -e "  ${CYAN}  • Positive lookbehind:${NC}    (?<=pattern)"
echo -e "  ${CYAN}  • Negative lookahead:${NC}     (?!pattern)"
echo -e "  ${CYAN}  • Negative lookbehind:${NC}    (?<!pattern)"
echo -e "  ${CYAN}  • Backreferences:${NC}         \\1, \\2, etc."
echo -e "  ${CYAN}  • Nested groups:${NC}          ((group))"
echo ""
echo -e "  ${WHITE}The regex patterns themselves are encoded (base64) and${NC}"
echo -e "  ${WHITE}hidden within the log file. You must:${NC}"
echo -e "  ${WHITE}  1. Extract and decode the patterns${NC}"
echo -e "  ${WHITE}  2. Apply each pattern to find matching lines${NC}"
echo -e "  ${WHITE}  3. Extract flag characters from matches${NC}"
echo -e "  ${WHITE}  4. Combine characters in correct order${NC}"
echo ""
echo -e "  ${RED}⚠️  Challenge:${NC} File is too large for grep/sed!"
echo -e "  ${RED}⚠️  Warning:${NC} Must use memory-efficient processing!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🎯 YOUR MISSION:${NC}"
echo ""
echo -e "  ${GREEN}→${NC} Process 1GB log file efficiently"
echo -e "  ${GREEN}→${NC} Extract base64-encoded regex patterns"
echo -e "  ${GREEN}→${NC} Decode patterns to get actual regex"
echo -e "  ${GREEN}→${NC} Apply complex regex (lookahead/behind/backrefs)"
echo -e "  ${GREEN}→${NC} Find 50 flag characters"
echo -e "  ${GREEN}→${NC} Assemble complete flag"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 SKILLS REQUIRED:${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} Advanced regex (PCRE/Python re)"
echo -e "  ${MAGENTA}•${NC} Lookahead/lookbehind assertions"
echo -e "  ${MAGENTA}•${NC} Backreferences and capture groups"
echo -e "  ${MAGENTA}•${NC} Memory-efficient file processing"
echo -e "  ${MAGENTA}•${NC} Base64 decoding"
echo -e "  ${MAGENTA}•${NC} Python/Perl scripting"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🛠️  RECOMMENDED TOOLS:${NC}"
echo ""
echo -e "  ${CYAN}Python: re module, base64 module${NC}"
echo -e "  ${CYAN}Streaming: line-by-line processing${NC}"
echo -e "  ${CYAN}DON'T use: grep -r (too slow), cat file (OOM)${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 HINTS:${NC}"
echo -e "  ${YELLOW}1. Don't load entire file into memory${NC}"
echo -e "  ${YELLOW}2. Process line-by-line with 'for line in file'${NC}"
echo -e "  ${YELLOW}3. Pattern hints start with [PATTERN_HINT_XX]${NC}"
echo -e "  ${YELLOW}4. Patterns are base64 encoded${NC}"
echo -e "  ${YELLOW}5. Each pattern finds one character${NC}"
echo -e "  ${YELLOW}6. Flag format: FLAG{...}${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Challenge is now READY!${NC}"
echo ""
echo -e "${YELLOW}📂 Log File:${NC} ${CYAN}/tmp/ctf_huge_log.txt${NC} ($(du -h /tmp/ctf_huge_log.txt 2>/dev/null | cut -f1))"
echo -e "${YELLOW}💡 Hint:${NC} ${CYAN}/tmp/regex_solution_hint.py${NC}"
echo -e "${YELLOW}🎯 Solution:${NC} ${CYAN}/tmp/regex_full_solution.py${NC}"
echo -e "${YELLOW}🧹 Cleanup:${NC} Run ${CYAN}/tmp/cleanup_ctf_8_1.sh${NC} when done"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${RED}    🧙‍♂️ BECOME A REGEX WIZARD! 🧙‍♂️${NC}"
echo ""