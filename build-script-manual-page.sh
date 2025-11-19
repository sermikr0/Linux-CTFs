#!/bin/bash

# CTF 3.1 - Man Page ASCII Art Hidden Flag Challenge
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

echo -e "${YELLOW}[*]${NC} Initializing CTF 3.1 environment..."
sleep 0.3

echo -e "${YELLOW}[*]${NC} Creating custom man page..."
(
    # Create custom man page with hidden ASCII art flag
    sudo mkdir -p /usr/share/man/man1
    
    # Create the man page with flag hidden in ASCII art (groff format)
    sudo tee /usr/share/man/man1/syscheck.1 > /dev/null << 'MANPAGE'
.TH SYSCHECK 1 "November 2024" "Version 1.0" "System Check Utility"
.SH NAME
syscheck \- system diagnostic and monitoring tool
.SH SYNOPSIS
.B syscheck
[\fIOPTIONS\fR]
.SH DESCRIPTION
The
.B syscheck
utility provides comprehensive system diagnostics and monitoring capabilities
for Linux systems. It performs various checks on system health, performance
metrics, and configuration validation.
.PP
This tool is essential for system administrators who need to quickly assess
the current state of their systems and identify potential issues before they
become critical problems.
.SH OPTIONS
.TP
.B \-a, \-\-all
Perform all available system checks
.TP
.B \-c, \-\-cpu
Check CPU usage and performance metrics
.TP
.B \-m, \-\-memory
Analyze memory usage and availability
.TP
.B \-d, \-\-disk
Check disk space and I/O statistics
.TP
.B \-n, \-\-network
Verify network connectivity and statistics
.TP
.B \-v, \-\-verbose
Enable verbose output mode
.TP
.B \-h, \-\-help
Display help message and exit
.SH EXAMPLES
.PP
Check all system parameters:
.RS
.nf
syscheck \-a
.fi
.RE
.PP
Check only CPU and memory:
.RS
.nf
syscheck \-c \-m
.fi
.RE
.SH DIAGNOSTICS
The following diagnostic codes may be returned:
.PP
.nf
0    Success
1    General error
2    Permission denied
3    Invalid option
4    System check failed
.fi
.SH INTERNAL DOCUMENTATION
.PP
The following section contains internal configuration data
in ASCII representation format for system validation:
.PP
.nf
\&
\& ███████╗██╗      █████╗  ██████╗ ██╗
\& ██╔════╝██║     ██╔══██╗██╔════╝ ██║
\& █████╗  ██║     ███████║██║  ███╗██║
\& ██╔══╝  ██║     ██╔══██║██║   ██║╚═╝
\& ██║     ███████╗██║  ██║╚██████╔╝██╗
\& ╚═╝     ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝
\&
\& ███╗   ███╗ █████╗ ███╗   ██╗     ██████╗  █████╗  ██████╗ ███████╗
\& ████╗ ████║██╔══██╗████╗  ██║     ██╔══██╗██╔══██╗██╔════╝ ██╔════╝
\& ██╔████╔██║███████║██╔██╗ ██║     ██████╔╝███████║██║  ███╗█████╗  
\& ██║╚██╔╝██║██╔══██║██║╚██╗██║     ██╔═══╝ ██╔══██║██║   ██║██╔══╝  
\& ██║ ╚═╝ ██║██║  ██║██║ ╚████║     ██║     ██║  ██║╚██████╔╝███████╗
\& ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝     ╚═╝     ╚═╝  ╚═╝ ╚═════╝ ╚══════╝
\&
\& ██████╗ ███████╗██╗   ██╗███████╗██████╗ ███████╗███████╗
\& ██╔══██╗██╔════╝██║   ██║██╔════╝██╔══██╗██╔════╝██╔════╝
\& ██████╔╝█████╗  ██║   ██║█████╗  ██████╔╝███████╗█████╗  
\& ██╔══██╗██╔══╝  ╚██╗ ██╔╝██╔══╝  ██╔══██╗╚════██║██╔══╝  
\& ██║  ██║███████╗ ╚████╔╝ ███████╗██║  ██║███████║███████╗
\& ╚═╝  ╚═╝╚══════╝  ╚═══╝  ╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝
\&
\& ███████╗███╗   ██╗ ██████╗ ██╗███╗   ██╗███████╗███████╗██████╗ 
\& ██╔════╝████╗  ██║██╔════╝ ██║████╗  ██║██╔════╝██╔════╝██╔══██╗
\& █████╗  ██╔██╗ ██║██║  ███╗██║██╔██╗ ██║█████╗  █████╗  ██████╔╝
\& ██╔══╝  ██║╚██╗██║██║   ██║██║██║╚██╗██║██╔══╝  ██╔══╝  ██╔══██╗
\& ███████╗██║ ╚████║╚██████╔╝██║██║ ╚████║███████╗███████╗██║  ██║
\& ╚══════╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚═╝  ╚═╝
\&
.fi
.PP
Configuration checksum: 7f4a9b2c8e1d3f6a
.SH SYSTEM REQUIREMENTS
.PP
Minimum requirements:
.RS
- Linux kernel 3.10 or higher
.br
- 512 MB RAM
.br
- 100 MB free disk space
.br
- Root or sudo privileges for some checks
.RE
.SH FILES
.TP
.I /etc/syscheck.conf
Main configuration file
.TP
.I /var/log/syscheck.log
Log file for system check results
.TP
.I /var/lib/syscheck/
Directory for temporary check data
.SH ENVIRONMENT
.TP
.B SYSCHECK_CONFIG
Override default configuration file location
.TP
.B SYSCHECK_LOG
Override default log file location
.SH SEE ALSO
.BR systemctl (1),
.BR top (1),
.BR htop (1),
.BR iotop (1),
.BR vmstat (8),
.BR iostat (1)
.SH BUGS
No known bugs at this time. Report bugs to bugs@example.com
.SH AUTHOR
Written by System Tools Team
.SH COPYRIGHT
Copyright \(co 2024 System Tools Project
.br
License: GPL-3.0+
.SH NOTES
This utility is part of the system-tools package.
For more information, visit: https://example.com/syscheck
MANPAGE

    # Compress the man page
    sudo gzip -f /usr/share/man/man1/syscheck.1
    
    # Update man database
    sudo mandb > /dev/null 2>&1
    
) &
spinner $!
echo -e "${GREEN}[✓]${NC} Custom man page created"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Embedding ASCII art flag..."
sleep 0.5
echo -e "${GREEN}[✓]${NC} Flag hidden in groff format"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Compressing and indexing man page..."
sleep 0.4
echo -e "${GREEN}[✓]${NC} Man page indexed"
sleep 0.2

echo -e "${YELLOW}[*]${NC} Finalizing challenge setup..."
sleep 0.3
echo -e "${GREEN}[✓]${NC} Challenge ready!"
sleep 0.3

# Create cleanup script
cat > /tmp/cleanup_ctf_3_1.sh << 'EOF'
#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${RED}[*]${NC} Cleaning up CTF 3.1..."
sudo rm -f /usr/share/man/man1/syscheck.1.gz
sudo mandb > /dev/null 2>&1
echo -e "${GREEN}[✓]${NC} Cleanup complete!"
EOF
chmod +x /tmp/cleanup_ctf_3_1.sh

echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}     CTF 3.1: ${MAGENTA}MAN PAGE REVERSE ENGINEERING${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}📊 Difficulty:${NC}     ${RED}HARD${NC}"
echo -e "${YELLOW}⏱️  Est. Time:${NC}      30-45 minutes"
echo -e "${YELLOW}🎯 Category:${NC}       Manual Pages & Documentation"
echo -e "${YELLOW}📍 Location:${NC}       ${CYAN}/usr/share/man/man1/${NC}"
echo -e "${YELLOW}📄 Man Page:${NC}       ${CYAN}syscheck(1)${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}📖 CHALLENGE DESCRIPTION:${NC}"
echo ""
echo -e "  ${WHITE}A custom man page has been installed in your system.${NC}"
echo -e "  ${WHITE}Hidden within its groff-formatted source code is an ASCII art${NC}"
echo -e "  ${WHITE}flag that spells out the capture flag.${NC}"
echo ""
echo -e "  ${WHITE}The flag is cleverly embedded in the 'INTERNAL DOCUMENTATION'${NC}"
echo -e "  ${WHITE}section of the man page, disguised as system configuration data.${NC}"
echo ""
echo -e "  ${RED}⚠️  Challenge:${NC} Extract the flag from groff markup!"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🎯 YOUR MISSION:${NC}"
echo ""
echo -e "  ${GREEN}→${NC} Find the custom man page in /usr/share/man/man1/"
echo -e "  ${GREEN}→${NC} Identify which man page contains the flag"
echo -e "  ${GREEN}→${NC} Extract and decompress the .gz file"
echo -e "  ${GREEN}→${NC} Parse the groff format to reveal ASCII art"
echo -e "  ${GREEN}→${NC} Read the flag from the ASCII art"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 SKILLS REQUIRED:${NC}"
echo ""
echo -e "  ${MAGENTA}•${NC} Man page system knowledge"
echo -e "  ${MAGENTA}•${NC} Groff/Troff format understanding"
echo -e "  ${MAGENTA}•${NC} File decompression (gzip)"
echo -e "  ${MAGENTA}•${NC} Text parsing and filtering"
echo -e "  ${MAGENTA}•${NC} ASCII art recognition"
echo -e "  ${MAGENTA}•${NC} Pattern matching"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🛠️  USEFUL COMMANDS:${NC}"
echo ""
echo -e "  ${CYAN}man, ls, zcat, gunzip, grep, less,${NC}"
echo -e "  ${CYAN}groff, nroff, cat, awk, sed${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}💡 HINTS:${NC}"
echo -e "  ${YELLOW}1. Custom man pages are often recently added${NC}"
echo -e "  ${YELLOW}2. Look for unusual or unfamiliar command names${NC}"
echo -e "  ${YELLOW}3. Man pages are gzipped (.gz extension)${NC}"
echo -e "  ${YELLOW}4. Use 'zcat' to view compressed man pages${NC}"
echo -e "  ${YELLOW}5. ASCII art often uses backslash escaping in groff${NC}"
echo -e "  ${YELLOW}6. Look for sections with dense character patterns${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${WHITE}🔍 GETTING STARTED:${NC}"
echo ""
echo -e "  ${WHITE}Try reading the man page first:${NC}"
echo -e "  ${CYAN}$ man syscheck${NC}"
echo ""
echo -e "  ${WHITE}Then examine its source:${NC}"
echo -e "  ${CYAN}$ ls -lt /usr/share/man/man1/ | head${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${GREEN}✅ Challenge is now LIVE!${NC}"
echo ""
echo -e "${YELLOW}📂 Location:${NC} ${CYAN}/usr/share/man/man1/syscheck.1.gz${NC}"
echo -e "${YELLOW}🧹 Cleanup:${NC} Run ${CYAN}/tmp/cleanup_ctf_3_1.sh${NC} when done"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${BOLD}${RED}      📚 RTFM - READ THE FINE MANUAL! 📚${NC}"
echo ""