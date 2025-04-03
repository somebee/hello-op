#!/usr/bin/env bash

username="hello_op"
dbname="hello_op"
password="hello_op"
skip_confirmation=false
nuke_mode=false

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Parse arguments
for arg in "$@"; do
  case $arg in
    --yes)
      skip_confirmation=true
      ;;
    --nuke)
      nuke_mode=true
      ;;
  esac
done

# Check if PostgreSQL is installed
if ! command_exists psql; then
    echo "Error: PostgreSQL is not installed or not in PATH"
    echo "Please install PostgreSQL first:"
    echo "  - For macOS: brew install postgresql"
    echo "  - For Ubuntu/Debian: sudo apt-get install postgresql"
    echo "  - For Fedora/RHEL: sudo dnf install postgresql-server"
    echo "  - For Windows: Download from https://www.postgresql.org/download/windows/"
    echo "After installation, make sure PostgreSQL service is running and try again."
    exit 1
fi

# Check if PostgreSQL server is running
if ! pg_isready -q -h localhost -p 5432; then
    echo "Error: PostgreSQL server is not running"
    echo "Please start PostgreSQL service:"
    echo "  - For macOS: brew services start postgresql"
    echo "  - For Linux (systemd): sudo systemctl start postgresql"
    echo "  - For Windows: Start service from Services panel"
    echo "After starting the service, run this script again."
    exit 1
fi

# Handle nuke mode
if [ "$nuke_mode" = true ]; then
    proceed=false
    
    if [ "$skip_confirmation" = true ]; then
        proceed=true
    else
        echo "WARNING: You are about to delete the database '$dbname' and user '$username'."
        read -p "Are you sure you want to continue? (y/n): " confirm
        if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
            proceed=true
        else
            echo "Operation cancelled."
        fi
    fi
    
    if [ "$proceed" = true ]; then
        echo "Dropping database $dbname..."
        psql -p 5432 -c "DROP DATABASE IF EXISTS $dbname;"
        
        echo "Dropping user $username..."
        psql -p 5432 -c "DROP USER IF EXISTS $username;"
        
        echo "Database and user have been deleted."
    fi
    exit 0
fi

# If not in nuke mode, proceed with regular setup
echo "PostgreSQL is installed and running. Proceeding with database setup..."

# Check if user exists
if ! psql -p 5432 -tAc "SELECT 1 FROM pg_roles WHERE rolname='$username'" | grep -q 1; then
    echo "Creating user $username..."
    psql -p 5432 -c "create user $username with password '$password';"
    psql -p 5432 -c "alter user $username with superuser;"
else
    echo "User $username already exists, skipping creation."
fi

# Check if database exists
if ! psql -p 5432 -lqt | cut -d \| -f 1 | grep -qw "$dbname"; then
    echo "Creating database $dbname..."
    psql -p 5432 -c "create database $dbname;"
else
    echo "Database $dbname already exists, skipping creation."
fi

echo "Database setup completed successfully!"