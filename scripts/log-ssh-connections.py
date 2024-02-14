import requests
import time

slack_webhook_url = "https://hooks.slack.com/services/XXXXXXX/XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"

def send_slack_notification(message):
    payload = {
        "text": message
    }
    response = requests.post(slack_webhook_url, json=payload)

    if response.status_code == 200:
        print("Notification sent successfully")
    else:
        print("Failed to send notification")

def monitor_ssh_logs():
    log_file = "/var/log/auth.log"  # Chemin vers le fichier journal SSH
    known_connections = set()       # Pour stocker les connexions déjà signalées

    while True:
        with open(log_file, "r") as f:
            lines = f.readlines()

            for line in reversed(lines):
                if "sshd" in line and "Accepted" in line:
                    if line not in known_connections:
                        known_connections.add(line)

                        # Analyser la ligne pour extraire les informations
                        ip_address = line.split(" ")[10]
                        username = line.split(" ")[8]
                        date_time = " ".join(line.split(" ")[0:3])

                        new_connection_info = f"New SSH connection from {ip_address} by {username} at {date_time}"
                        send_slack_notification(new_connection_info)

        time.sleep(60)  # Attendre 1 minute avant de vérifier à nouveau

if __name__ == "__main__":
    monitor_ssh_logs()

