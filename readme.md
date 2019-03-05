# Instructions

### To create a self-signed SAN certificate with multiple subject alternate names, complete the following procedure:

- Run the `ca/ca.sh` shell script to create a valid CA certificate.
- Copy the OpenSSL configuration file `request.example.conf` to a file named `request.conf` at the root of the project.
- Edit the OpenSSL configuration file `request.conf` and supply your own fields for the certificate request.
    
```conf
[ req ] 
default_bits = 2048
default_keyfile = domain.key
default_md = sha256
encrypt_key = no
utf8 = yes
prompt = no
distinguished_name = my_req_distinguished_name
req_extensions = my_extensions

# Alter these (CN must be a valid domain name)
[ my_req_distinguished_name ]
C = GR
ST = Northern Greece
L = Thessaloniki
O = Localhost
OU = Web Developers
CN = localhost.dev

[ my_extensions ]
# --- cut --- # Do not remove comment!!!
basicConstraints=CA:FALSE
subjectAltName=@my_subject_alt_names
subjectKeyIdentifier = hash

# Alter these (add or remove)
[ my_subject_alt_names ]
DNS.1 = api.localhost.dev
DNS.2 = localhost
```

- After editing the `[ my_req_distinguished_name ]` and `[ my_subject_alt_names ]` sections  
run the `generate.sh` script providing a domain name to be used as a filename and a folder name.

### You are done

 All you need to do is retrieve your private key file and certificate file or bundle from the `domains` folder.

-----------------------------------------------------------

To avoid the self-signed certificate warning:
- Import `ca.crt` into your browser's Trusted CA store.
- For chrome users go to [chrome://settings/certificates](chrome://settings/certificates) and click IMPORT on the AUTHORITIES tab.  
Check every checkbox and click ok.

Good luck!  
Ignatios
