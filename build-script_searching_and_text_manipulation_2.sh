#!/bin/bash

# CTF 8.2 - Binary Mixed Data Extraction Challenge
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

echo -e "${YELLOW}[*]${NC} Initializing CTF 8.2 environment..."
sleep 0.3

echo -e "${YELLOW}[*]${NC} Creating binary data generator..."
(
    # Create Python script to generate mixed binary file
    cat > /tmp/generate_mixed_binary.py << 'PYBINARY'
#!/usr/bin/env python3
import os
import random
import base64
import gzip
import struct

output_file = "/tmp/ctf_mixed_data.bin"

# Flag parts in different formats
flag_parts = {
    "part1": "FLAG{",           # Plain text
    "part2": "text_",           # Base64 encoded
    "part3": "binary_",         # Hex encoded
    "part4": "manipulation_",   # Gzip compressed
    "part5": "deity}"           # XOR encoded with key
}

def generate_random_bytes(size):
    """Generate random binary data"""
    return bytes([random.randint(0, 255) for _ in range(size)])

def create_text_chunk(text):
    """Create a text chunk with markers"""
    marker_start = b"<<<TEXT_START>>>"
    marker_end = b"<<<TEXT_END>>>"
    return marker_start + text.encode() + marker_end

def create_base64_chunk(text):
    """Create base64 encoded chunk with markers"""
    marker_start = b"<<<BASE64_START>>>"
    marker_end = b"<<<BASE64_END>>>"
    encoded = base64.b64encode(text.encode())
    return marker_start + encoded + marker_end

def create_hex_chunk(text):
    """Create hex encoded chunk with markers"""
    marker_start = b"<<<HEX_START>>>"
    marker_end = b"<<<HEX_END>>>"
    hex_data = text.encode().hex().encode()
    return marker_start + hex_data + marker_end

def create_gzip_chunk(text):
    """Create gzip compressed chunk with markers"""
    marker_start = b"<<<GZIP_START>>>"
    marker_end = b"<<<GZIP_END>>>"
    compressed = gzip.compress(text.encode())
    return marker_start + compressed + marker_end

def create_xor_chunk(text, key=0x42):
    """Create XOR encoded chunk with markers"""
    marker_start = b"<<<XOR_START>>>"
    marker_end = b"<<<XOR_END>>>"
    xor_data = bytes([ord(c) ^ key for c in text])
    return marker_start + xor_data + marker_end

def create_fake_chunks():
    """Create fake data chunks to confuse"""
    chunks = []
    
    # Fake text chunks
    for _ in range(10):
        fake_text = f"FAKE_{random.randint(1000, 9999)}"
        chunks.append(create_text_chunk(fake_text))
    
    # Fake base64 chunks
    for _ in range(10):
        fake_text = f"DECOY_{random.randint(1000, 9999)}"
        chunks.append(create_base64_chunk(fake_text))
    
    # Random binary data
    for _ in range(20):
        chunks.append(generate_random_bytes(random.randint(50, 200)))
    
    return chunks

def main():
    print("[*] Generating mixed binary file...")
    
    with open(output_file, 'wb') as f:
        # Add some initial random data
        f.write(generate_random_bytes(500))
        
        # Part 1: Plain text
        f.write(create_text_chunk(flag_parts["part1"]))
        f.write(generate_random_bytes(300))
        
        # Add fake chunks
        fake_chunks = create_fake_chunks()
        for i in range(5):
            f.write(fake_chunks[i])
            f.write(generate_random_bytes(100))
        
        # Part 2: Base64
        f.write(create_base64_chunk(flag_parts["part2"]))
        f.write(generate_random_bytes(400))
        
        # More fake chunks
        for i in range(5, 10):
            f.write(fake_chunks[i])
            f.write(generate_random_bytes(100))
        
        # Part 3: Hex encoded
        f.write(create_hex_chunk(flag_parts["part3"]))
        f.write(generate_random_bytes(350))
        
        # More fake chunks
        for i in range(10, 15):
            f.write(fake_chunks[i])
            f.write(generate_random_bytes(100))
        
        # Part 4: Gzip compressed
        f.write(create_gzip_chunk(flag_parts["part4"]))
        f.write(generate_random_bytes(450))
        
        # More fake chunks
        for i in range(15, 20):
            f.write(fake_chunks[i])
            f.write(generate_random_bytes(100))
        
        # Part 5: XOR encoded
        f.write(create_xor_chunk(flag_parts["part5"], key=0x42))
        f.write(generate_random_bytes(500))
        
        # Add more random data at the end
        f.write(generate_random_bytes(1000))
    
    file_size = os.path.getsize(output_file)
    print(f"[+] Binary file created: {output_file}")
    print(f"[+] File size: {file_size} bytes ({file_size/1024:.2f} KB)")
    print(f"[+] Flag parts hidden in different formats:")
    print(f"    Part 1: Plain text")
    print(f"    Part 2: Base64 encoded")
    print(f"    Part 3: Hex encoded")
    print(f"    Part 4: Gzip compressed")
    print(f"    Part 5: XOR encoded (key: 0x42)")

if __name__ == "__main__":
    main()
PYBINARY

    chmod +x /tmp/generate_mixed_binary.py
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Binary generator created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Generating mixed binary file..."
python3 /tmp/generate_mixed_binary.py

if [ -f /tmp/ctf_mixed_data.bin ]; then
    echo -e "${GREEN}[✓]${NC} Binary file generated successfully"
    FILE_SIZE=$(du -h /tmp/ctf_mixed_data.bin | cut -f1)
    echo -e "${GREEN}    Size: $FILE_SIZE${NC}"
else
    echo -e "${RED}[✗]${NC} Failed to generate binary file"
    exit 1
fi

sleep 0.2

echo -e "${YELLOW}[*]${NC} Creating solution scripts..."
(
    # Create solution hint
    cat > /tmp/binary_solution_hint.sh << 'SOLHINT'
#!/bin/bash

echo "=== CTF 8.2 Solution Hints ==="
echo ""
echo "The binary file contains 5 flag parts in different formats:"
echo ""
echo "1. Plain Text (marked with <<<TEXT_START>>> and <<<TEXT_END>>>)"
echo "   Extract with: strings or grep"
echo ""
echo "2. Base64 Encoded (marked with <<<BASE64_START>>> and <<<BASE64_END>>>)"
echo "   Extract markers, then base64 -d"
echo ""
echo "3. Hex Encoded (marked with <<<HEX_START>>> and <<<HEX_END>>>)"
echo "   Extract markers, then xxd -r -p"
echo ""
echo "4. Gzip Compressed (marked with <<<GZIP_START>>> and <<<GZIP_END>>>)"
echo "   Extract chunk, save to file, then gunzip"
echo ""
echo "5. XOR Encoded (marked with <<<XOR_START>>> and <<<XOR_END>>>)"
echo "   Extract chunk, XOR each byte with key 0x42"
echo ""
echo "Tools needed:"
echo "  - strings, grep, awk, sed"
echo "  - xxd (hex dump/reverse)"
echo "  - dd (byte extraction)"
echo "  - base64, gzip"
echo "  - python/perl for XOR"
SOLHINT

    # Create full solution script
    cat > /tmp/binary_full_solution.sh << 'FULLSOL'
#!/bin/bash

echo "=== CTF 8.2 Full Solution ==="
echo ""

BINARY_FILE="/tmp/ctf_mixed_data.bin"

# Part 1: Extract plain text
echo "[*] Part 1: Extracting plain text..."
PART1=$(strings "$BINARY_FILE" | grep -A1 "TEXT_START" | tail -1 | sed 's/<<<TEXT_END>>>.*//')
echo "    Part 1: $PART1"

# Part 2: Extract and decode base64
echo "[*] Part 2: Extracting base64 data..."
BASE64_DATA=$(strings "$BINARY_FILE" | grep -A1 "BASE64_START" | tail -1 | sed 's/<<<BASE64_END>>>.*//')
PART2=$(echo "$BASE64_DATA" | base64 -d 2>/dev/null)
echo "    Part 2: $PART2"

# Part 3: Extract and decode hex
echo "[*] Part 3: Extracting hex data..."
HEX_DATA=$(strings "$BINARY_FILE" | grep -A1 "HEX_START" | tail -1 | sed 's/<<<HEX_END>>>.*//')
PART3=$(echo "$HEX_DATA" | xxd -r -p 2>/dev/null)
echo "    Part 3: $PART3"

# Part 4: Extract and decompress gzip
echo "[*] Part 4: Extracting gzip compressed data..."
# This is more complex - need to extract binary chunk
python3 << 'PYEOF'
import re
import gzip

with open('/tmp/ctf_mixed_data.bin', 'rb') as f:
    data = f.read()
    
# Find gzip chunk
start_marker = b'<<<GZIP_START>>>'
end_marker = b'<<<GZIP_END>>>'

start_pos = data.find(start_marker)
end_pos = data.find(end_marker, start_pos)

if start_pos != -1 and end_pos != -1:
    gzip_data = data[start_pos + len(start_marker):end_pos]
    try:
        decompressed = gzip.decompress(gzip_data)
        print(decompressed.decode())
    except:
        print("Failed to decompress")
PYEOF
PART4=$(python3 -c "
import gzip
with open('$BINARY_FILE', 'rb') as f:
    data = f.read()
    start_marker = b'<<<GZIP_START>>>'
    end_marker = b'<<<GZIP_END>>>'
    start_pos = data.find(start_marker)
    end_pos = data.find(end_marker, start_pos)
    if start_pos != -1 and end_pos != -1:
        gzip_data = data[start_pos + len(start_marker):end_pos]
        try:
            print(gzip.decompress(gzip_data).decode(), end='')
        except:
            pass
")
echo "    Part 4: $PART4"

# Part 5: Extract and XOR decode
echo "[*] Part 5: Extracting XOR encoded data..."
PART5=$(python3 << 'PYEOF'
with open('/tmp/ctf_mixed_data.bin', 'rb') as f:
    data = f.read()
    
start_marker = b'<<<XOR_START>>>'
end_marker = b'<<<XOR_END>>>'

start_pos = data.find(start_marker)
end_pos = data.find(end_marker, start_pos)

if start_pos != -1 and end_pos != -1:
    xor_data = data[start_pos + len(start_marker):end_pos]
    key = 0x42
    decoded = ''.join(chr(b ^ key) for b in xor_data)
    print(decoded, end='')
PYEOF
)
echo "    Part 5: $PART5"

# Combine all parts
echo ""
echo "=" | tr '=' '='| head -c 50; echo
FLAG="${PART1}${PART2}${PART3}${PART4}${PART5}"
echo "🎯 FLAG: $FLAG"
echo "=" | tr '=' '='| head -c 50; echo
FULLSOL

    chmod +x /tmp/binary_solution_hint.sh
    chmod +x /tmp/binary_full_solution.sh
    
    # Create Python solution (cleaner)
    cat > /tmp/binary_python_solution.py << 'PYSOL'
#!/usr/bin/env python3
import re
import base64
import gzip

print("=== CTF 8.2 Python Solution ===\n")

binary_file = "/tmp/ctf_mixed_data.bin"

with open(binary_file, 'rb') as f:
    data = f.read()

def extract_between_markers(data, start_marker, end_marker):
    """Extract data between two markers"""
    start_pos = data.find(start_marker)
    end_pos = data.find(end_marker, start_pos)
    if start_pos != -1 and end_pos != -1:
        return data[start_pos + len(start_marker):end_pos]
    return None

# Part 1: Plain text
print("[*] Part 1: Plain text")
part1_data = extract_between_markers(data, b'<<<TEXT_START>>>', b'<<<TEXT_END>>>')
part1 = part1_data.decode() if part1_data else ""
print(f"    {part1}")

# Part 2: Base64
print("[*] Part 2: Base64 encoded")
part2_data = extract_between_markers(data, b'<<<BASE64_START>>>', b'<<<BASE64_END>>>')
part2 = base64.b64decode(part2_data).decode() if part2_data else ""
print(f"    {part2}")

# Part 3: Hex
print("[*] Part 3: Hex encoded")
part3_data = extract_between_markers(data, b'<<<HEX_START>>>', b'<<<HEX_END>>>')
part3 = bytes.fromhex(part3_data.decode()).decode() if part3_data else ""
print(f"    {part3}")

# Part 4: Gzip compressed
print("[*] Part 4: Gzip compressed")
part4_data = extract_between_markers(data, b'<<<GZIP_START>>>', b'<<<GZIP_END>>>')
part4 = gzip.decompress(part4_data).decode() if part4_data else ""
print(f"    {part4}")

# Part 5: XOR encoded (key: 0x42)
print("[*] Part 5: XOR encoded")
part5_data = extract_between_markers(data, b'<<<XOR_START>>>', b'<<<XOR_END>>>')
part5 = ''.join(chr(b ^ 0x42) for b in part5_data) if part5_data else ""
print(f"    {part5}")

# Combine all parts
flag = part1 + part2 + part3 + part4 + part5
print("\n" + "="*50)
print(f"🎯 FLAG: {flag}")
print("="*50)
PYSOL

    chmod +x /tmp/binary_python_solution.py
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Solution scripts created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Finalizing challenge setup..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Challenge ready!"
sleep 0.3

# Create cleanup script
cat > /tmp/cleanup_ctf_8_2.sh << 'EOF'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}[*]${NC} Cleaning up CTF 8.2..."

rm -f /tmp/ctf_mixed_data.bin
rm -f /tmp/generate_mixed_binary.py
rm -f /tmp/binary_solution_hint.sh
rm -f /tmp/binary_full_solution.sh
rm -f /tmp/binary_python_solution.py

echo -e "${GREEN}[✓]${NC} Cleanup complete!"
EOF
chmod +x /tmp/cleanup_ctf_8_2.sh

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}   CTF 8.2: ${MAGENTA}BINARY DATA MANIPULATION${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📊 Difficulty:${NC}     ${RED}HARD${NC}"
echo -e "${YELLOW}⏱️  Est. Time:${NC}      45-60 minutes"
echo -e "${YELLOW}🎯 Category:${NC}       Binary/Text Manipulation"
echo -e "${YELLOW}📁 File Size:${NC}     ${RED}~20 KB (mixed binary)${NC}"
echo -e "${YELLOW}🎁 Flag Parts:${NC}     ${RED}5 parts, 5 different formats${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📖 CHALLENGE DESCRIPTION:${NC}"
echo ""
echo -e "  ${WHITE}A binary file contains mixed data in multiple formats:${NC}"
echo ""
echo -e "  ${CYAN}Part 1:${NC} Plain text"
echo -e "  ${CYAN}Part 2:${NC} Base64 encoded"
echo -e "  ${CYAN}Part 3:${NC} Hexadecimal encoded"
echo -e "  ${CYAN}Part 4:${NC} Gzip compressed"
echo -e "  ${CYAN}Part 5:${NC} XOR cipher (key: 0x42)"
echo ""
echo -e "  ${WHITE}Each part is marked with specific delimiters:${NC}"
echo -e "  ${WHITE}  <<<TEXT_START>>> ... <<<TEXT_END>>>${NC}"
echo -e "  ${WHITE}  <<<BASE64_START>>> ... <<<BASE64_END>>>${NC}"
echo -e "  ${WHITE}  <<<HEX_START>>> ... <<<HEX_END>>>${NC}"
echo -e "  ${WHITE}  <<<GZIP_START>>> ... <<<GZIP_END>>>${NC}"
echo -e "  ${WHITE}  <<<XOR_START>>> ... <<<XOR_END>>>${NC}"
echo ""
echo -e "  ${RED}⚠️  Challenge:${NC} File has 20+ fake chunks!"
echo -e "  ${RED}⚠️  Warning:${NC} Must extract exact byte ranges!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🎯 YOUR MISSION:${NC}"
echo ""
echo -e "  ${GREEN}→${NC} Analyze the binary file structure"
echo -e "  ${GREEN}→${NC} Locate marker delimiters"
echo -e "  ${GREEN}→${NC} Extract data between markers"
echo -e "  ${GREEN}→${NC} Decode/decompress each part correctly"
echo -e "  ${GREEN}→${NC} Combine all 5 parts to get the flag"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 SKILLS REQUIRED:${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} Binary file analysis"
echo -e "  ${MAGENTA}•${NC} sed, awk, grep for text processing"
echo -e "  ${MAGENTA}•${NC} xxd for hex operations"
echo -e "  ${MAGENTA}•${NC} dd for byte extraction"
echo -e "  ${MAGENTA}•${NC} base64 encoding/decoding"
echo -e "  ${MAGENTA}•${NC} gzip compression/decompression"
echo -e "  ${MAGENTA}•${NC} XOR cipher decryption"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🛠️  USEFUL TOOLS:${NC}"
echo ""
echo -e "  ${CYAN}strings  - Extract text from binary${NC}"
echo -e "  ${CYAN}xxd      - Hex dump and reverse${NC}"
echo -e "  ${CYAN}dd       - Byte-level extraction${NC}"
echo -e "  ${CYAN}base64   - Base64 decode${NC}"
echo -e "  ${CYAN}gzip     - Decompress${NC}"
echo -e "  ${CYAN}python3  - For XOR and complex ops${NC}"

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 HINTS:${NC}"
echo -e "  ${YELLOW}1. Use 'strings' to see text markers${NC}"
echo -e "  ${YELLOW}2. Markers define data boundaries${NC}"
echo -e "  ${YELLOW}3. Python is easiest for XOR${NC}"
echo -e "  ${YELLOW}4. Gzip data is binary - use dd or Python${NC}"
echo -e "  ${YELLOW}5. Combine parts in order (1-5)${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Challenge is now READY!${NC}"
echo ""
echo -e "${YELLOW}📂 Binary:${NC} ${CYAN}/tmp/ctf_mixed_data.bin${NC} ($(du -h /tmp/ctf_mixed_data.bin 2>/dev/null | cut -f1))"
echo -e "${YELLOW}💡 Hint:${NC} ${CYAN}/tmp/binary_solution_hint.sh${NC}"
echo -e "${YELLOW}🎯 Bash Solution:${NC} ${CYAN}/tmp/binary_full_solution.sh${NC}"
echo -e "${YELLOW}🐍 Python Solution:${NC} ${CYAN}/tmp/binary_python_solution.py${NC}"
echo -e "${YELLOW}🧹 Cleanup:${NC} Run ${CYAN}/tmp/cleanup_ctf_8_2.sh${NC} when done"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${RED}    🔧 MASTER BINARY MANIPULATION! 🔧${NC}"
echo ""