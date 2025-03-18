# Tenable Nessus STIG Scan Setup Guide

This guide walks you through creating and configuring a Windows 10 STIG Compliance Scan using Tenable Nessus.

---

## 1. Navigate to Tenable - Create Scan

- Click on **Scans** in the left-hand menu.

![Scan Menu](https://github.com/user-attachments/assets/30772fa5-9442-4ac4-b68d-1fd55cd1800b)

- Click **Create Scan** in the top right menu.

![Create Scan](https://github.com/user-attachments/assets/b43a8deb-8ad3-4bc2-93f4-6a0b96c20088)

---

## 2. Advanced Network Scan

- Select **Advanced Network Scan**.

![Advanced Network Scan](https://github.com/user-attachments/assets/cbe508db-537b-4381-88ab-ce51023d21bf)

---

## 3. Advanced Network Scan - Basic Settings

Configure these settings:

- **Name:** Enter a unique name (e.g., `Win10 STIG Scan - YourName`)
- **Scanner Type:** `Internal Scanner`
- **Scanner:** Select `LOCAL-SCAN-ENGINE-01`
- **Targets:** Your VM's **private IP address**

![Basic Settings](https://github.com/user-attachments/assets/23e00fd8-cfb9-4ff2-b53e-488a4f9e9390)

---

## 4. Add Credentials for Authenticated Scanning

- Go to the **Credentials** tab and click **"+"** next to Add Credentials.

![Add Credentials](https://github.com/user-attachments/assets/602ac437-fb8b-4901-aa82-03fdc19d891d)

- Click **Windows**.

![Windows Credentials](https://github.com/user-attachments/assets/049de146-3e14-4994-9498-89c1332c965c)

- Configure your credentials:
  - **Authentication Method:** Password
  - **Username:** Your VM username
  - **Password:** Your VM password (**IMPORTANT:** ensure accuracy)
  - Scan-wide Credential Type Settings: Enable all

![Enter Credentials](https://github.com/user-attachments/assets/138d7ca5-7bfe-4be2-967b-ab86ace0708d)

- Click **Save**.

![Save Credentials](https://github.com/user-attachments/assets/9e41ab78-1df6-4245-819f-931402a2078c)

---

## 5. Edit Newly Created Scan & Add Compliance Check

- Return to the **Scans** page.
- Click the **three dots (...)** beside your scan and select **Edit**.

![Edit Scan](https://github.com/user-attachments/assets/9c9ffecb-f30c-4ac8-8ae6-d7d6195e2590)

- Go to the **Compliance** tab and enable compliance checks (leave settings default).

![Add Compliance Check](https://github.com/user-attachments/assets/b5dac74c-a62d-4455-9cda-997087dd8636)

- Click **Save**.

![Compliance Settings](https://github.com/user-attachments/assets/ccee3d06-8b0d-4158-8236-ce6415fc93e0)

---

## 6. Enable Policy Compliance Plugin

- Navigate to the **Plugins** tab.
- Click **Disable All** to start with a clean state.

![Disable All Plugins](https://github.com/user-attachments/assets/7e30b689-8667-4adb-ac4c-c9c4e3834f41)

- Type `"policy"` in the search bar, ensuring "Policy Compliance Auditing" status is mixed (enable "Windows Compliance Checks").

![Search Policy Plugin](https://github.com/user-attachments/assets/81ecb2a5-d65a-426f-88ec-18f72b90482b)

- Click **policy**, search for `"Windows Compliance Checks"` plugin, and enable it.

![Enable Windows Compliance Checks](https://github.com/user-attachments/assets/89537a74-acef-443f-b630-5c192034374b)

- Verify status is **mixed**, then click **Save**.

![Mixed Status](https://github.com/user-attachments/assets/26430782-91f8-44ce-8eec-c3a447073c75)

---

## 7. Launch Initial Scan for your VM

- Click the **three dots (...)** next to your scan, and select **Launch**.
- Wait for scan completion (3–20+ minutes, depending on scanning load).

![Launch Scan](https://github.com/user-attachments/assets/91d378a4-d83d-458a-9150-af2f3c0422d3)

---

## 8. View Scan Results

![Screenshot 2025-03-17 at 6 39 57 PM](https://github.com/user-attachments/assets/4733ac47-06c0-493b-9fda-30597de28acd)


- Navigate to the completed scan's **Audits** tab to view results.
- **Note:** Initial numbers may differ based on previous remediations.
  
![Screenshot 2025-03-17 at 6 41 36 PM](https://github.com/user-attachments/assets/3d85ed29-b280-4eea-aae6-18e7481ce558)

---

## 9. Remediate STIG Issues

Review remediation strategies from my repo for ideas:  
[Win10 STIG Remediation Guide](https://github.com/Charlemagne-ai/Win10-STIG-Remediation)
