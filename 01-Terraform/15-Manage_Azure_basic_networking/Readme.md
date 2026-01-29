# FrogTech Azure Secure Network – Terraform

This project implements a **secure Azure Hub–Spoke architecture** using **Terraform**, following best practices for private networking and access control.

---

## 🏗️ Architecture Overview
![alt text](image-1.png)

- **Hub VNet**
  - Public subnet
  - Linux VM with Public IP
  - NSG allowing SSH (22) only from the developer’s public IP

- **Spoke VNet**
  - Private subnet
  - Azure Linux Web App
  - Private Endpoint
  - No public access

- **Connectivity**
  - VNet Peering between Hub and Spoke
  - Private DNS Zone linked to both VNets

---

## ✅ Requirements Implemented

1. Deploy all components defined in the architecture diagram  
2. Web App is **private** and **not publicly accessible**  
3. Web App is accessed only via **Private Endpoint**  
4. Private DNS resolves Web App hostname to **Private IP**  
5. Spoke subnet is private  
6. VM deployed in a public subnet  
7. SSH access allowed **only from developer IP**  
8. Hub ↔ Spoke VNet peering configured  

---

## 🔐 Security Design

- `public_network_access_enabled = false` on Web App
- Private Endpoint used for internal access
- NSG rules strictly limited:
  - SSH (22) → developer IP only
- No inbound public traffic to the Web App

---

## 🌐 DNS Configuration

A Private DNS Zone is created:

privatelink.azurewebsites.net


Linked to:
- Hub VNet
- Spoke VNet

This ensures correct DNS resolution of the Web App to its **Private Endpoint IP** across peered VNets.

---

## 🚀 How to Deploy

### 1️⃣ Login to Azure
```bash
az login

2️⃣ Initialize Terraform
terraform init

3️⃣ Apply Configuration
terraform apply

🧪 Validation Steps

From the VM:

nslookup frogtech-private-webapp.azurewebsites.net


✔ Resolves to a private IP

curl https://frogtech-private-webapp.azurewebsites.net


✔ Web App responds successfully

From local machine:

curl https://frogtech-private-webapp.azurewebsites.net


❌ Access denied (as expected)