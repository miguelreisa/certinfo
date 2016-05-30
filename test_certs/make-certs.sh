#!/usr/bin/env bash

# Key files generated by 'make-keys.sh'
ROOT1_KEY="root1.key.pem"
LEAF1_KEY="leaf1.key.pem"
LEAF2_KEY="leaf2.key.pem"
LEAF3_KEY="leaf3.key.pem"

# Certificate files
ROOT1_CERT="root1.cert.pem"
LEAF1_CERT="leaf1.cert.pem"
LEAF2_CERT="leaf2.cert.pem"
LEAF3_CERT="leaf3.cert.pem"

# OpenSSL configuration files
ROOT1_CFG="root1.cfg"
LEAF1_CFG="leaf1.cfg"
LEAF2_CFG="leaf2.cfg"
LEAF3_CFG="leaf3.cfg"

# Temporary files for using the OpenSSL 'ca' subcommand.
# These names must match the OpenSSL configuration file.
CA_TMP="./tmp"
CA_SERIAL=${CA_TMP}/serial.txt
CA_DB=${CA_TMP}/certdb.txt


# Create the test Certificate Authority
openssl req -new -config ${ROOT1_CFG} -key ${ROOT1_KEY} -out ${ROOT1_CERT}.csr
rm -rf ${CA_TMP}
mkdir ${CA_TMP}
echo "01" > ${CA_SERIAL}
touch ${CA_DB}
openssl ca -selfsign -batch -config ${ROOT1_CFG} -keyfile ${ROOT1_KEY} -extensions ca_root_extensions -in ${ROOT1_CERT}.csr -out ${ROOT1_CERT}
rm -f ${ROOT1_CERT}.csr

# Create a leaf RSA certificate
openssl req -new -config ${LEAF1_CFG} -key ${LEAF1_KEY} -out ${LEAF1_CERT}.csr
openssl ca -batch -config ${ROOT1_CFG} -keyfile ${ROOT1_KEY} -cert ${ROOT1_CERT} -extensions ca_leaf_extensions -in ${LEAF1_CERT}.csr -out ${LEAF1_CERT}
rm -f ${LEAF1_CERT}.csr

# Create a leaf DSA certificate
openssl req -new -config ${LEAF2_CFG} -key ${LEAF2_KEY} -out ${LEAF2_CERT}.csr
openssl ca -batch -config ${ROOT1_CFG} -keyfile ${ROOT1_KEY} -cert ${ROOT1_CERT} -extensions ca_leaf_extensions -in ${LEAF2_CERT}.csr -out ${LEAF2_CERT}
rm -f ${LEAF2_CERT}.csr

# Create a leaf ECDSA certificate
openssl req -new -config ${LEAF3_CFG} -key ${LEAF3_KEY} -out ${LEAF3_CERT}.csr
openssl ca -batch -config ${ROOT1_CFG} -keyfile ${ROOT1_KEY} -cert ${ROOT1_CERT} -extensions ca_leaf_extensions -in ${LEAF3_CERT}.csr -out ${LEAF3_CERT}
rm -f ${LEAF3_CERT}.csr

# Clean up all the garbage that 'openssl ca' left behind
rm -rf ${CA_TMP}
