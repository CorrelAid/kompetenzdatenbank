from python_tools.io import get_host
from python_tools.ssh import create_ssh_client, transfer_folder_via_ssh, run_command_via_ssh
from python_tools.helpers import dev_base_url,prod_base_url, dev_admin_access_token, prod_admin_access_token
import mimetypes
import requests
import json

# This script uploads the current local schema and uploads it to the prod server

host = get_host("../ansible/hosts", 1)
hostname = host["host"]
port = 22
username = host["user"]

ssh_client = create_ssh_client(hostname, port, username)

# Transfer a file from the remote server to the local machine
local_path = '../schema-sync'
remote_path = f'/home/{username}/directus/schema-sync'

transfer_folder_via_ssh(ssh_client, local_path, remote_path, direction='put')

run_command_via_ssh(ssh_client, 'docker exec directus npx directus schema-sync import')

ssh_client.close()

#transfer files
with open('../schema-sync/data/directus_files.json', 'r') as f:
    files = json.load(f)

for i,file in enumerate(files):
    print(f"Uploading {file['filename_disk']} ({i+1}/{len(files)})")
    # download file
    url = f'{dev_base_url()}/assets/{file["id"]}?download'
    headers = { "Authorization": f"Bearer {dev_admin_access_token()}" }
    response = requests.get(url, headers=headers)
    response.raise_for_status()

    mime_type, _ = mimetypes.guess_type(file["filename_disk"])
    if mime_type is None:
        mime_type = 'application/octet-stream'  # Default MIME type
    
    url = f'{dev_base_url()}/assets/{file["id"]}'
    headers = { "Authorization": f"Bearer {prod_admin_access_token()}" }

    # Exclude filename_disk and filename_download from the file object
    filtered_file = {k: v for k, v in file.items() if k not in ['filename_disk', 'filename_download']}

    # Construct the files payload with the correct MIME type
    files_payload = {
        'file': (file["filename_disk"], response.content, mime_type)
    }


    response = requests.patch(f"{prod_base_url()}/files/{file['id']}", headers=headers, files=files_payload)
    response.raise_for_status()

