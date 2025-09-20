import os
import requests
import time
import psutil
import logging
import ctypes
import tempfile
import shutil
import scapy.all as scapy
import matplotlib.pyplot as plt
import numpy as np
import nmap
import socket
from datetime import datetime
import json
from IPy import IP
appVersion="1.0.0.0"
print("Starting Identify. . . ")

from geopy.geocoders import Nominatim
from psutil._common import bytes2human
import datetime

import pandas as pd
from streamlit.elements.lib.utils import save_for_app_testing

# Set up logging

temp_dir = tempfile.gettempdir()


def menu():
    print("\n [1] Resource Monitor\n [2] Cleanup\n [3] Identify \n \n")
    opt = input("Please select your option: ")
    if opt == "1":
        logging.basicConfig(filename='system_monitor.log', level=logging.INFO)
        output_list = []
        monitor_system_setup()
    if opt == "2":
        system_cleanup()
    if opt == "3":
        identify_system_info()

def identify_system_info():
    identifyList = ["[0] System Information", "[1] example"]
    print(f"Available commands: \033[92m{identifyList}\033[0m\n")
    select = input("Please enter cmd index num (or type 'return'): ")

    if select == "0":
        get_system_information()
    if select == "1":
        system_process_killer()
    if select == "return":
        menu()

def get_system_information():
    opt = input("Save results to txt file? [y/n]:")
    if opt == "y":
        desktopDir = os.path.join(os.environ["USERPROFILE"], "Desktop")
        save_path = os.path.join(desktopDir, "system_monitor.txt")
        print(f"[INFO] Save location : {save_path}")
        import platform
        my_system = platform.uname()
        print(f"System: \033[92m{my_system.system}\033[0m")
        print(f"Node Name: \033[92m{my_system.node}\033[0m")
        print(f"Release: \033[92m{my_system.release}\033[0m")
        print(f"Version: \033[92m{my_system.version}\033[0m")
        print(f"Machine: \033[92m{my_system.machine}\033[0m")
        print(f"Processor: \033[92m{my_system.processor}\033[0m")
        print("\033[94m+--+--+--+--+--+WMI_MODULE+--+--+--+--+--+--\033[0m\n")
        import wmi
        c = wmi.WMI()
        my_wmi_system = c.Win32_ComputerSystem()[0]
        print(f"Manufacturer : \033[92m{my_wmi_system.Manufacturer}\033[0m")
        print(f"Model : \033[92m{my_wmi_system.Model}\033[0m")
        print(f"Name : \033[92m{my_wmi_system.Name}\033[0m")
        print(f"SystemType : \033[92m{my_wmi_system.SystemType}\033[0m")
        print(f"SystemFamily : \033[92m{my_wmi_system.SystemFamily}\033[0m")
        time.sleep(10)

def system_cleanup():
    toolList = ["[0] ram_cleaner", "[1] process_killer", "[2] delete_temp", "[3] Vulnerability Mapper"]
    print(f"Available tools: \033[92m{toolList}\033[0m\n")
    select = input("Please enter tool name or index num (or 'return'): ")

    if select == "ram_cleaner" or select == "0":
        system_ram_cleanup(pid=os.getpid())
    if select == "process_killer" or select == "1":
        system_process_killer()
    if select == "delete_temp" or select == "2":
        system_delete_temp(temp_dir)
    if select == "Vulnerability Mapper" or select == "3":
        system_vulnerability_mapper()
    if select == "return":
        menu()
    elif "mapper2":
        system_vulnerability_mapper_2()

def system_vulnerability_mapper():
    openPortNum = 0
    s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
    s.connect(('8.8.8.8', 1))  # connect() for UDP doesn't send packets
    local_ip_address = s.getsockname()[0]
    nmScan = nmap.PortScanner()
    ip = local_ip_address  # Replace with your target IP
    start_time = time.monotonic()
    print(f"[\033[94mi\033[0m] Establishing IP address. . . :\033[92m{ip}\033[0m")
    print("[\033[94mi\033[0m] Number of ports scammed :\n     [1=\033[92m1-600,\033[0m\n    2=\033[92m1-1200,\033[0m\n   3=\033[92m1-2800\033[0m]")
    scanIntensity = input("[\033[95m?\033[0m] Please choose scan intensity:")
    if "1" in scanIntensity:
        options = "-sS -sV -O -A -p 1-600"
    elif "2" in scanIntensity:
        options = "-sS -sV -O -A -p 1-1300"
    elif "3" in scanIntensity:
        options ="-sS -sV -O -A -p 1-3000"
    else:
        print(f"[\033[91mERROR\033[0m] Setting [{scanIntensity}] was not recognized, returning in 5 seconds...")
        time.sleep(5)
        system_vulnerability_mapper()
    print(f"[\033[96mi\033[0m] Starting NMAP scan on localhost. . .")
    nmScan.scan(ip, arguments=options)
    # run a loop to print all the found result about the ports
    for host in nmScan.all_hosts():
        print('Hostname : \033[92m%s %s\033[0m' % (host, nmScan[host].hostname()))
        print('Host state : \033[92m%s\033[0m' % nmScan[host].state())
        for proto in nmScan[host].all_protocols():
            print('[\033[96mi\033[0m] Protocol NMAP scan. . . : \033[92m%s\033[0m' % proto)
            lport = nmScan[host][proto].keys()
            fport = sorted(lport)
            print("\033[94m+--+--+--+--+--+Open Ports+--+--+--+--+--+--\033[0m\n")
            for port in fport:
                print ('Port ID :\033[92m%s\t\033[0mstate:\033[92m%s\033[0m' % (port, nmScan[host][proto][port]['state']))
                openPortNum +=1
                continue
            else:
                print("\033[94m+--+--+--+--+--+Open Ports+--+--+--+--+--+--\033[0m\n")
                end_time = time.monotonic()
                print(f"[\033[96mi\033[0m] NMAP Scan competed on \033[92m{ip}\033[0m\n[\033[96mi\033[0m] Num of open ports found. . .  :\033[92m{openPortNum}\033[0m")
                scantime = end_time - start_time
                scantime = int(scantime)
                print(f'[\033[96mi\033[0m] NMAP Scan Duration . . . :\033[92m{scantime}s\033[0m\n')
                continueScript = input("Do you want to continue assesment?[y/n]")
                if continueScript == "y":
                    system_vulnerability_mapper_2()
                else:
                    system_cleanup()


def system_vulnerability_mapper_2():
    print("[\033[96mi\033[0m] 2nd Phase of Mapping: Starting Scapy. . .")
    # Send an ICMP echo request to a target host
    request = scapy.ARP()
    request.pdst = '{ip}'
    broadcast = scapy.Ether()

    broadcast.dst = 'ff:ff:ff:ff:ff:ff'

    request_broadcast = broadcast / request
    clients = scapy.srp(request_broadcast, timeout=1)[0]
    for element in clients:
        print(element[1].psrc + "      " + element[1].hwsrc)
    time.sleep(500)

def system_ram_cleanup(pid):
    memory = psutil.virtual_memory()
    process_handle = ctypes.windll.kernel32.OpenProcess(0x1F0FFF, False, pid)
    ctypes.windll.psapi.EmptyWorkingSet(process_handle)
    ctypes.windll.kernel32.CloseHandle(process_handle)
    preMem = memory.percent
    print(f"Current RAM Usage in %. . . : {memory.percent}")
    time.sleep(1)
    system_ram_result(preMem)

    for proc in psutil.process_iter():
        try:
            system_ram_cleanup(proc.pid)
        except Exception:
            break

def system_ram_result(preMem):
    afterMem = psutil.virtual_memory()
    print("\033[94m+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--\033[0m\nTOOL:ram_cleaner\n")
    print(f"Pre-dump memory. . . : \033[92m{preMem}\033[0m --->\nAfter memory dump. . . : \033[92m{afterMem.percent}\033[0m")
    time.sleep(10)
    menu()


def system_process_killer():
    processlist = list()
    for process in psutil.process_iter():
        processlist.append(process.name())
    print(processlist)
    time.sleep(10)

def system_delete_temp(temp_dir):
    unlink_status = [0, 0, 0]
    tempSize = os.path.getsize(temp_dir)
    print(f"Calculating temp dir size. . . :{tempSize}")
    clean_temp(unlink_status, folder=temp_dir)

def clean_temp(unlink_status, folder):
    for filename in os.listdir(folder):
        file_path = os.path.join(folder, filename)
        try:
            if os.path.isfile(file_path) or os.path.islink(file_path):
                os.unlink(file_path)
                unlink_status[0] += 1
                print(f" \033[96mi\033[0m] Currently removing/unlinking file. . .: {file_path}")
            elif os.path.isdir(file_path):
                shutil.rmtree(file_path)
                unlink_status[1] += 1
                print(f" \033[96mi\033[0m] Currently removing/unlinking folder. . .: {file_path}")
        except Exception as e:
            print(f"[\033[93m!\033[0m] Could not delete {file_path}: {e}")
            unlink_status[2] += 1
        finally:
            clean_temp_status(unlink_status)


def clean_temp_status(unlink_status):
    print(
        f"Files unlinked ..\033[93m{unlink_status[0]}\033[0m // Folders removed ..\033[93m{unlink_status[1]}\033[0m // Errors encountered ..\033[93m{unlink_status[2]}\033[0m")
    time.sleep(5)
    menu()


def monitor_system_setup():
    old_result = [0.0, 0.0, 0.0, 0, 0]
    calc_diff = 0.0
    result = []
    print("(1 Loop runtime : 5sec\nRecommended loop num : 5-10)")
    total_loop_amount = int(input("Please enter the amount of loops for Analysis: "))
    # Initialize an empty list to store data
    data = []
    # returns the time in seconds since the boot
    last_reboot = int(psutil.boot_time())
    print(f"[i] Gathererd PC Last boot time : {last_reboot}")
    loop_amount = 1
    monitor_system(old_result, calc_diff, total_loop_amount, loop_amount, result)


# Main system resource monitor
def monitor_system(old_result, calc_diff, total_loop_amount, loop_amount, result):
    for loop in range(total_loop_amount):
        old_result = list(map(int, old_result))
        print(f"[\033[96mi\033[0m] Currently on loop {loop_amount}/{total_loop_amount}")
        print("\033[94m+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--+--\033[0m\nSystem Monitor Tool start!\n")
        # CPU usage in %
        cpu_usage = psutil.cpu_percent(interval=1)
        calc_diff = cpu_usage - old_result[0]
        old_result[0] = cpu_usage

        logging.info(f"CPU Usage in %. . . : {cpu_usage}")
        print(f"Combined CPU Usage in %. . . : \033[92m{cpu_usage}%\033[0m (\033[95m{calc_diff}%\033[0m)")
        for i, percentage in enumerate(psutil.cpu_percent(interval=1, percpu=True)):
            print(f" -CPU Core #{i}. . :\033[92m{percentage}%\033[0m")
        # Memory usage in %
        print("---RAM")
        values = psutil.virtual_memory()
        calc_diff2 = values.percent - old_result[1]
        logging.info(f"Memory Usage: {values.percent}%")
        total = values.total >> 20
        memory_free = values.free >> 20
        #memoryMB = values / 1048576
        #freeMemMB = values.free / 1048576
        print(f"Total RAM Memory Usage. . . :\033[92m{total}mb/{memory_free}mb\033[0m")
        print(f"RAM Usage in %. . . : \033[92m{values.percent}%\033[0m (\033[95m{calc_diff2}%\033[0m)")
        old_result[1] = values.percent

        # Disk usage in %
        print("---DISK")
        disk_usage = psutil.disk_usage('/')
        calc_diff3 = disk_usage.percent - old_result[2]
        logging.info(f"Disk Usage: {disk_usage.percent}%")
        print(f"Disk Usage in %. . . : \033[92m{disk_usage.percent}%\033[0m (\033[95m{calc_diff3}%\033[0m)")
        old_result[2] = disk_usage.percent
        # Network usage
        print("---NETWORK")
        network = psutil.net_io_counters()
        sentInMB = int(network.bytes_sent / 1024 / 1024)
        recvInMB = int(network.bytes_recv / 1024 / 1024)
        calc_diff4 = sentInMB - old_result[3]
        calc_diff5 = recvInMB - old_result[4]

        print(f"Network data sent . . . : \033[92m{sentInMB}MB\033[0m ({calc_diff4})")
        print(f"Network data recv . . . : \033[92m{recvInMB}MB\033[0m ({calc_diff5})")
        old_result[3] = network.bytes_sent
        old_result[4] = network.bytes_recv

        logging.info(f"Bytes Sent: {network.bytes_sent} (MB:{sentInMB}), Bytes Received: {network.bytes_recv}")

        # create a list

        # Wait for a few seconds before the next update
        if loop_amount == total_loop_amount:
            os.system('cls')
            time.sleep(3)
            monitor_summary(loop_amount, total_loop_amount)
        loop_amount += 1
        continue


def monitor_summary(loop_amount, total_loop_amount, result):
    print(f"[i] System analyzation is complete ...{loop_amount}/{total_loop_amount}")
    time.sleep(1)
    print(f"{result}")



if __name__ == '__main__':
    menu()

