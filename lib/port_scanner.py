import os
import socket
from concurrent.futures import ThreadPoolExecutor, as_completed
from datetime import datetime

from prettytable import PrettyTable
from tqdm import tqdm
from vulnerable_ports import vulnerable_ports
appVersion="1.0.0.0"

# Result folder
RESULT_FOLDER = "Portscan_Results"
os.makedirs(RESULT_FOLDER, exist_ok=True)  # create folder if not exists

# Common ports with services
COMMON_PORTS = {
    20: "FTP Data", 21: "FTP Control", 22: "SSH", 23: "Telnet", 25: "SMTP",
    53: "DNS", 67: "DHCP", 68: "DHCP", 69: "TFTP", 80: "HTTP",
    110: "POP3", 123: "NTP", 143: "IMAP", 161: "SNMP", 162: "SNMP Trap",
    389: "LDAP", 443: "HTTPS", 445: "SMB", 514: "Syslog", 993: "IMAPS",
    995: "POP3S", 3306: "MySQL", 3389: "RDP", 5900: "VNC", 8080: "HTTP-Alt"
}

tcp_open_ports = []
udp_open_ports = []

def scan_tcp_port(target_ip, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    sock.settimeout(0.5)
    try:
        if sock.connect_ex((target_ip, port)) == 0:
            tcp_open_ports.append(port)
    finally:
        sock.close()

def scan_udp_port(target_ip, port):
    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    sock.settimeout(0.5)
    try:
        sock.sendto(b'', (target_ip, port))
        udp_open_ports.append(port)
    finally:
        sock.close()

def scan_ports_with_progress(target_ip, port_list, threads, protocol):
    if protocol in ["TCP", "BOTH"]:
        print(f"Scanning TCP ports on {target_ip}...")
        with ThreadPoolExecutor(max_workers=threads) as executor:
            futures = [executor.submit(scan_tcp_port, target_ip, port) for port in port_list]
            for _ in tqdm(as_completed(futures), total=len(futures), desc="TCP Progress", unit="port"):
                pass

    if protocol in ["UDP", "BOTH"]:
        print(f"\nScanning UDP ports on {target_ip}...")
        with ThreadPoolExecutor(max_workers=threads) as executor:
            futures = [executor.submit(scan_udp_port, target_ip, port) for port in port_list]
            for _ in tqdm(as_completed(futures), total=len(futures), desc="UDP Progress", unit="port"):
                pass

def display_results(target_ip):
    GREEN = "\033[92m"
    RED = "\033[91m"
    RESET = "\033[0m"

    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")
    print(f"\nPort Scan Results for {target_ip} | Timestamp: {timestamp}\n")

    table = PrettyTable()
    table.field_names = ["Protocol", "Port", "Service"]
    table.align["Service"] = "l"

    if tcp_open_ports:
        for port in sorted(tcp_open_ports):
            service = COMMON_PORTS.get(port, "")
            table.add_row([f"{GREEN}TCP{RESET}", f"{GREEN}{port}{RESET}", f"{GREEN}{service}{RESET}"])
    else:
        table.add_row([f"{RED}TCP{RESET}", f"{RED}- {RESET}", f"{RED}No open ports detected!{RESET}"])

    if udp_open_ports:
        for port in sorted(udp_open_ports):
            service = COMMON_PORTS.get(port, "")
            table.add_row([f"{GREEN}UDP{RESET}", f"{GREEN}{port}{RESET}", f"{GREEN}{service}{RESET}"])
    else:
        table.add_row([f"{RED}UDP{RESET}", f"{RED}- {RESET}", f"{RED}No open ports detected!{RESET}"])

    print(table)

def save_results(target_ip, threads, protocol, port_list):
    ts = datetime.now().strftime("%Y%m%d_%H%M%S")
    filename = os.path.join(RESULT_FOLDER, f"port_scan_{ts}.txt")
    with open(filename, "w") as f:
        f.write(f"Port scan results for {target_ip}\n")
        f.write(f"Timestamp: {ts}\n")
        f.write(f"Protocol scan: {protocol}\n")
        f.write(f"Ports scanned: {min(port_list)}-{max(port_list)}\n")
        f.write(f"Threads: {threads}\n\n")
        f.write("TCP Open Ports:\n")
        if tcp_open_ports:
            for port in sorted(tcp_open_ports):
                service = COMMON_PORTS.get(port, "")
                f.write(f"{port} {service}\n")
        else:
            f.write("No open ports detected!\n")

        f.write("\nUDP Open Ports:\n")
        if udp_open_ports:
            for port in sorted(udp_open_ports):
                service = COMMON_PORTS.get(port, "")
                f.write(f"{port} {service}\n")
        else:
            f.write("No open ports detected!\n")
    print(f"\nResults saved to {filename}")

def select_open_ports():
    GREEN = "\033[92m"
    RED = "\033[91m"
    RESET = "\033[0m"

    # Combine TCP and UDP open ports with protocol labels
    combined_ports = []
    for port in sorted(tcp_open_ports):
        combined_ports.append(('TCP', port))
    for port in sorted(udp_open_ports):
        combined_ports.append(('UDP', port))

    if not combined_ports:
        print(f"{RED}No open ports available to select.{RESET}")
        return []

    print("\nOpen Ports Available for Selection:\n")

    table = PrettyTable()
    table.field_names = ["No.", "Protocol", "Port", "Service"]
    table.align["Service"] = "l"

    for idx, (proto, port) in enumerate(combined_ports, 1):
        service = COMMON_PORTS.get(port, "")
        table.add_row([f"{GREEN}{idx}{RESET}", f"{GREEN}{proto}{RESET}", f"{GREEN}{port}{RESET}", f"{GREEN}{service}{RESET}"])

    print(table)

    print("Enter the numbers of the ports you want to select separated by commas (e.g., 1,3,5):")
    user_input = input("Selection: ").strip()

    selected_ports = []
    try:
        selections = [int(x.strip()) for x in user_input.split(",") if x.strip()]
        for sel in selections:
            if 1 <= sel <= len(combined_ports):
                selected_ports.append(combined_ports[sel - 1])
            else:
                print(f"{RED}Ignoring invalid selection number: {sel}{RESET}")
    except ValueError:
        print(f"{RED}Invalid input. Please enter numbers separated by commas.{RESET}")
        return []

    if selected_ports:
        print("\nSelected Ports:\n")
        selected_table = PrettyTable()
        selected_table.field_names = ["Protocol", "Port", "Service"]
        selected_table.align["Service"] = "l"
        for proto, port in selected_ports:
            service = COMMON_PORTS.get(port, "")
            selected_table.add_row([f"{GREEN}{proto}{RESET}", f"{GREEN}{port}{RESET}", f"{GREEN}{service}{RESET}"])
        print(selected_table)
    else:
        print(f"{RED}No valid ports selected.{RESET}")

    return selected_ports

def validate_ip(ip_str):
    try:
        socket.inet_aton(ip_str)
        return True
    except socket.error:
        return False

if __name__ == "__main__":
    import argparse
    parser = argparse.ArgumentParser(description="Port Scanner with Timestamped Table and Result Folder")
    parser.add_argument("--threads", type=int, default=100, help="Number of threads (default 100)")
    parser.add_argument("--protocol", type=str, choices=["TCP", "UDP", "BOTH"], default="BOTH",
                        help="Protocol to scan: TCP, UDP, or BOTH (default BOTH)")
    parser.add_argument("--fullscan", action="store_true",
                        help="Scan full range 1-65535 after common ports (optional, slower)")
    args = parser.parse_args()

    # Prompt user for IP address with validation
    while True:
        target_ip = input("Enter target IP address to scan: ").strip()
        if validate_ip(target_ip):
            break
        else:
            print("Invalid IP address format. Please enter a valid IPv4 address.")

    # Initial common ports
    common_port_list = sorted(COMMON_PORTS.keys())
    scan_ports_with_progress(target_ip, common_port_list, args.threads, args.protocol)

    # Optional full scan
    if args.fullscan:
        full_port_list = list(range(1, 65536))
        scan_ports_with_progress(target_ip, full_port_list, args.threads, args.protocol)
        port_list_for_save = full_port_list
    else:
        port_list_for_save = common_port_list

    display_results(target_ip)
    save_results(target_ip, args.threads, args.protocol, port_list_for_save)

    # Prompt user to select from open ports
    select_open_ports()