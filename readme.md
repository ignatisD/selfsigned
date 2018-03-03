# Instructions

### To create a self-signed SAN certificate with multiple subject alternate names, complete the following procedure:

- Edit the `ca/ca.request.conf` and run the `ca.sh` to generate a self-signed Certificate Authority certificate.
- Edit the OpenSSL configuration file `request.conf`. Supply your own fields for `[my_req_distinguished_name]` and `[my_subject_alt_names]`.
    
```conf
[req] 
default_bits = 2048
default_keyfile = domain.key
default_md = sha256
encrypt_key = no
utf8 = yes
prompt = no
distinguished_name = my_req_distinguished_name
req_extensions = my_extensions

[my_req_distinguished_name]
C = GR
ST = Thessaloniki
L = Thessaloniki
O = Exampe.ltd
OU = Devs Examples.ltd
CN = example.com

[ my_extensions ]
# --- cut --- # Do not remove comment!!!
basicConstraints=CA:FALSE
subjectAltName=@my_subject_alt_names
subjectKeyIdentifier = hash

# Alter these
[my_subject_alt_names]
DNS.1 = www.example.com
DNS.2 = api.example.com
DNS.3 = localhost
```

- After editing the `[ my_req_distinguished_name ]` and `[ my_subject_alt_names ]` sections  
run the `generate.sh` script providing a domain name to be used as a filename and a folder name.

### You are done

- All you need to do is retrieve your certificate from the `domains/[example.tld]` folder and import `ca/ca.crt` into your browser
- For chrome users go to [chrome://settings/certificates](chrome://settings/certificates) and click IMPORT on the AUTHORITIES tab.  
Check every checkbox and click ok.
