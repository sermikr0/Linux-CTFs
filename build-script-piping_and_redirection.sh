#!/bin/bash

# CTF 7.1 - Real-time Named Pipe Processing Challenge
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

echo -e "${YELLOW}[*]${NC} Initializing CTF 7.1 environment..."
sleep 0.3

# Cleanup old challenge
if [ -f /tmp/ctf_7_1_stream_pid.txt ]; then
    OLD_PID=$(cat /tmp/ctf_7_1_stream_pid.txt)
    kill $OLD_PID 2>/dev/null
    rm /tmp/ctf_7_1_stream_pid.txt
fi

echo -e "${YELLOW}[*]${NC} Creating named pipe (FIFO)..."
(
    # Remove old pipe if exists
    rm -f /tmp/ctf_stream_pipe
    
    # Create named pipe
    mkfifo /tmp/ctf_stream_pipe
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Named pipe created: /tmp/ctf_stream_pipe"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Creating data stream generator..."
(
    # Create Python script for streaming data
    cat > /tmp/stream_generator.py << 'PYCODE'
#!/usr/bin/env python3
import time
import random
import base64
import codecs
import sys

# Flag parts in different encodings
flag_parts = [
    ("FLAG{", "base64"),      # Part 0: base64
    ("real", "hex"),          # Part 1: hex
    ("time", "rot13"),        # Part 2: rot13
    ("_", "reverse"),         # Part 3: reverse
    ("pipe", "base64"),       # Part 4: base64
    ("_", "hex"),             # Part 5: hex
    ("mas", "rot13"),         # Part 6: rot13
    ("ter", "reverse"),       # Part 7: reverse
    ("}", "base64"),          # Part 8: base64
    ("END", "hex")            # Part 9: hex (marker)
]

def encode_text(text, method):
    if method == "base64":
        return base64.b64encode(text.encode()).decode()
    elif method == "hex":
        return text.encode().hex()
    elif method == "rot13":
        return codecs.encode(text, 'rot_13')
    elif method == "reverse":
        return text[::-1]
    return text

def generate_fake_log():
    fake_logs = [
        "ERROR: Connection timeout to server 192.168.1.{}".format(random.randint(1, 255)),
        "INFO: User login successful from IP {}".format('.'.join(map(str, (random.randint(0, 255) for _ in range(4))))),
        "WARN: High memory usage detected: {}%".format(random.randint(70, 95)),
        "DEBUG: Processing request ID: {}".format(random.randint(10000, 99999)),
        "TRACE: Function call stack depth: {}".format(random.randint(5, 50)),
        "CRITICAL: Database connection lost",
        "NOTICE: Service restarted successfully",
        "ALERT: Unusual traffic pattern detected",
        "INFO: Cache cleared, {} items removed".format(random.randint(100, 9999)),
        "ERROR: Failed to parse configuration file",
    ]
    return random.choice(fake_logs)

def stream_data():
    pipe_path = "/tmp/ctf_stream_pipe"
    
    try:
        with open(pipe_path, 'w') as pipe:
            print("[Stream Generator] Started streaming data...", file=sys.stderr)
            
            start_time = time.time()
            flag_sent = [False] * len(flag_parts)
            
            while time.time() - start_time < 15:  # Run for 15 seconds
                current_time = time.time() - start_time
                
                # Send flag parts at specific times (1 per second for 10 seconds)
                for i, (part, method) in enumerate(flag_parts):
                    if i < current_time and i < 10 and not flag_sent[i]:
                        encoded = encode_text(part, method)
                        flag_line = f"[FLAG_PART_{i}] [ENC:{method}] DATA: {encoded}"
                        pipe.write(flag_line + "\n")
                        pipe.flush()
                        flag_sent[i] = True
                        print(f"[Stream Generator] Sent flag part {i}: {method}", file=sys.stderr)
                
                # Generate fake logs (100 per 0.1 second = 1000 per second)
                for _ in range(100):
                    fake_log = f"[{time.time():.6f}] {generate_fake_log()}"
                    pipe.write(fake_log + "\n")
                    pipe.flush()
                
                time.sleep(0.1)
            
            # Send termination marker
            pipe.write("[STREAM_END]\n")
            pipe.flush()
            print("[Stream Generator] Stream ended.", file=sys.stderr)
    
    except BrokenPipeError:
        print("[Stream Generator] Pipe closed by reader.", file=sys.stderr)
    except Exception as e:
        print(f"[Stream Generator] Error: {e}", file=sys.stderr)

if __name__ == "__main__":
    stream_data()
PYCODE

    chmod +x /tmp/stream_generator.py
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Stream generator created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Preparing flag encryption layers..."
sleep 0.5
echo -e "${GREEN}[✓]${NC} 10 flag parts encoded with different methods"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Configuring high-speed data stream..."
sleep 0.4
echo -e "${GREEN}[✓]${NC} Stream configured: 1000+ entries/second"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Finalizing challenge setup..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Challenge ready!"
sleep 0.3

# Create solution hint script
cat > /tmp/solution_hint_7_1.py << 'PYHINT'
#!/usr/bin/env python3
"""
Solution hint for CTF 7.1

To solve this challenge:
1. Read from named pipe: /tmp/ctf_stream_pipe
2. Filter lines containing [FLAG_PART_X]
3. Extract encoding method and data
4. Decode based on method (base64, hex, rot13, reverse)
5. Combine all 10 parts in order (0-9)
6. Assemble the complete flag

Decoding functions needed:
- base64.b64decode()
- bytes.fromhex()
- codecs.decode(text, 'rot_13')
- text[::-1] for reverse
"""
PYHINT

chmod +x /tmp/solution_hint_7_1.py

# Create cleanup script
cat > /tmp/cleanup_ctf_7_1.sh << 'EOF'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}[*]${NC} Cleaning up CTF 7.1..."

# Kill stream generator if running
if [ -f /tmp/ctf_7_1_stream_pid.txt ]; then
    PID=$(cat /tmp/ctf_7_1_stream_pid.txt)
    kill $PID 2>/dev/null
    rm /tmp/ctf_7_1_stream_pid.txt
fi

# Remove pipe and scripts
rm -f /tmp/ctf_stream_pipe
rm -f /tmp/stream_generator.py
rm -f /tmp/solution_hint_7_1.py

echo -e "${GREEN}[✓]${NC} Cleanup complete!"
EOF
chmod +x /tmp/cleanup_ctf_7_1.sh

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}   CTF 7.1: ${MAGENTA}REAL-TIME PIPE PROCESSING${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📊 Difficulty:${NC}    ${RED}HARD${NC}"
echo -e "${YELLOW}⏱️  Est. Time:${NC}     30-45 minutes"
echo -e "${YELLOW}🎯 Category:${NC}      Piping and Real-time Processing"
echo -e "${YELLOW}📍 Pipe:${NC}          ${CYAN}/tmp/ctf_stream_pipe${NC}"
echo -e "${YELLOW}⚡ Speed:${NC}         ${RED}1000+ entries/second${NC}"
echo -e "${YELLOW}🎁 Flag Parts:${NC}    ${RED}10 parts, 10 encodings${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📖 CHALLENGE DESCRIPTION:${NC}"
echo ""
echo -e "  ${WHITE}A named pipe (FIFO) is streaming real-time log data at${NC}"
echo -e "  ${WHITE}high speed (1000+ entries per second). Hidden within this${NC}"
echo -e "  ${WHITE}flood of data are 10 flag parts, each encoded differently:${NC}"
echo ""
echo -e "  ${CYAN}  • Base64 encoding${NC}"
echo -e "  ${CYAN}  • Hexadecimal encoding${NC}"
echo -e "  ${CYAN}  • ROT13 cipher${NC}"
echo -e "  ${CYAN}  • Reverse string${NC}"
echo ""
echo -e "  ${WHITE}One flag part arrives each second for 10 seconds.${NC}"
echo -e "  ${WHITE}You must process the stream in real-time, decode each part,${NC}"
echo -e "  ${WHITE}and combine them to get the complete flag.${NC}"
echo ""
echo -e "  ${RED}⚠️  Challenge:${NC} Stream only runs for 15 seconds!"
echo -e "  ${RED}⚠️  Warning:${NC} Missing even one part means no flag!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🎯 YOUR MISSION:${NC}"
echo ""
echo -e "  ${GREEN}→${NC} Start the stream generator"
echo -e "  ${GREEN}→${NC} Read from the named pipe in real-time"
echo -e "  ${GREEN}→${NC} Filter flag parts from 1000+ log entries"
echo -e "  ${GREEN}→${NC} Identify encoding method for each part"
echo -e "  ${GREEN}→${NC} Decode each part correctly"
echo -e "  ${GREEN}→${NC} Combine all 10 parts in order"
echo -e "  ${GREEN}→${NC} Submit the complete flag"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 SKILLS REQUIRED:${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} Named pipes (FIFO) usage"
echo -e "  ${MAGENTA}•${NC} Real-time stream processing"
echo -e "  ${MAGENTA}•${NC} Pattern matching and filtering"
echo -e "  ${MAGENTA}•${NC} Multi-encoding decryption"
echo -e "  ${MAGENTA}•${NC} Python/Bash scripting"
echo -e "  ${MAGENTA}•${NC} Concurrent processing"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🛠️  TOOLS & LANGUAGES:${NC}"
echo ""
echo -e "  ${CYAN}Python: base64, codecs modules${NC}"
echo -e "  ${CYAN}Bash: grep, awk, sed, while read${NC}"
echo -e "  ${CYAN}Named Pipe: mkfifo, FIFO operations${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🚀 HOW TO START:${NC}"
echo ""
echo -e "  ${YELLOW}Step 1:${NC} Start the stream generator"
echo -e "  ${CYAN}$ python3 /tmp/stream_generator.py &${NC}"
echo ""
echo -e "  ${YELLOW}Step 2:${NC} Read and process the pipe"
echo -e "  ${CYAN}$ cat /tmp/ctf_stream_pipe | grep FLAG_PART${NC}"
echo ""
echo -e "  ${YELLOW}Step 3:${NC} Decode and combine parts"
echo -e "  ${CYAN}$ # Write your decoding script${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 HINTS:${NC}"
echo -e "  ${YELLOW}1. Flag parts are marked with [FLAG_PART_X]${NC}"
echo -e "  ${YELLOW}2. Encoding method is specified: [ENC:method]${NC}"
echo -e "  ${YELLOW}3. Use grep to filter noise${NC}"
echo -e "  ${YELLOW}4. Process parts in order (0-9)${NC}"
echo -e "  ${YELLOW}5. Python has built-in base64 and codecs modules${NC}"
echo -e "  ${YELLOW}6. Stream runs for 15 seconds total${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📋 EXAMPLE FLAG PART FORMAT:${NC}"
echo -e "  ${WHITE}[FLAG_PART_0] [ENC:base64] DATA: RkxBR3s=${NC}"
echo -e "  ${WHITE}[FLAG_PART_1] [ENC:hex] DATA: 7265616c${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Challenge is now READY!${NC}"
echo ""
echo -e "${YELLOW}📂 Pipe:${NC} ${CYAN}/tmp/ctf_stream_pipe${NC}"
echo -e "${YELLOW}🐍 Generator:${NC} ${CYAN}/tmp/stream_generator.py${NC}"
echo -e "${YELLOW}💡 Hint:${NC} ${CYAN}/tmp/solution_hint_7_1.py${NC}"
echo -e "${YELLOW}🧹 Cleanup:${NC} Run ${CYAN}/tmp/cleanup_ctf_7_1.sh${NC} when done"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${RED}    ⚡ PROCESS THE STREAM IN REAL-TIME! ⚡${NC}"
echo ""