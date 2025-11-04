# Snowflake Private Key Authentication Setup

This guide walks through setting up private key authentication for Snowflake with dbt.

## Prerequisites

- OpenSSL installed on your system
- Snowflake account with appropriate permissions
- Access to Snowflake user administration

## Step 1: Generate RSA Key Pair

Generate a 2048-bit RSA private key:

```bash
# Generate private key (unencrypted)
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out rsa_key.p8 -nocrypt

# Generate private key (with passphrase - more secure)
openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out rsa_key.p8
```

Generate the corresponding public key:

```bash
openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub
```

## Step 2: Copy Public Key Value

Extract the public key value (without header/footer):

```bash
grep -v "BEGIN PUBLIC" rsa_key.pub | grep -v "END PUBLIC" | tr -d '\n'
```

Copy the output - you'll need this for Snowflake.

## Step 3: Assign Public Key to Snowflake User

In Snowflake, run the following SQL (replace `<public_key_value>` with the key from Step 2):

```sql
ALTER USER rohit SET RSA_PUBLIC_KEY='<public_key_value>';
```

Verify the key was set:

```sql
DESC USER rohit;
```

## Step 4: Store Private Key Securely

Move the private key to the standard dbt location:

```bash
mkdir -p ~/.dbt
mv rsa_key.p8 ~/.dbt/snowflake_key.p8
chmod 600 ~/.dbt/snowflake_key.p8
```

**Important:** Never commit the private key file to version control!

## Step 5: Configure Environment Variables

Set the required environment variables:

```bash
export SNOWFLAKE_PRIVATE_KEY_PATH="$HOME/.dbt/snowflake_key.p8"
export SNOWFLAKE_DATABASE="your_database"  # Optional, defaults to DEV
export SNOWFLAKE_SCHEMA="your_schema"      # Optional, defaults to PUBLIC
```

If you used a passphrase when generating the key:

```bash
export SNOWFLAKE_PRIVATE_KEY_PASSPHRASE="your_passphrase"
```

## Step 6: Test Connection

Test the dbt connection:

```bash
cd demo_finance
dbt debug
```

You should see:

```
Connection test: [OK connection ok]
```

## Troubleshooting

### JWT Token Errors

If you see "JWT token is invalid" errors:

- Ensure your system clock is synchronized with NTP
- Check for clock skew (Snowflake requires token to be received within 60 seconds of issue time)

### Permission Errors

Ensure your Snowflake user has:

- Appropriate role assigned (`SYSADMIN` or custom role)
- `USAGE` privilege on the warehouse
- Database and schema privileges

### Key Format Errors

The private key must be in PKCS#8 format (`.p8` file). If you have a PEM format key:

```bash
openssl pkcs8 -topk8 -inform PEM -in rsa_key.pem -out rsa_key.p8 -nocrypt
```

## Security Best Practices

1. **Use passphrase-protected keys** in production environments
2. **Rotate keys regularly** (every 90 days recommended)
3. **Never commit keys to git** - add to `.gitignore`:
   ```
   *.p8
   *.pem
   *_key.*
   ```
4. **Use restrictive file permissions**: `chmod 600` on private key files
5. **Use separate keys** for different environments (dev/staging/prod)

## References

- [Snowflake Key Pair Authentication Documentation](https://docs.snowflake.com/en/user-guide/key-pair-auth)
- [dbt Snowflake Setup Guide](https://docs.getdbt.com/docs/core/connect-data-platform/snowflake-setup)
