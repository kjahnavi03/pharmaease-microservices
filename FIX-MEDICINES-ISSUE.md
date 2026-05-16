# Fix Medicines Not Showing Issue

## Problem
Your Docker application shows "0 medicines found" even though you had 25+ medicines in your local MySQL database.

## Root Causes
1. **Docker created a fresh MySQL database** - When you started Docker for the first time, it created a new empty MySQL database. Your local MySQL medicines are not automatically copied.
2. **Nginx proxy configuration issue** - The frontend's nginx was not correctly forwarding API requests to the gateway service (FIXED).

## Solution Steps

### Step 1: Fix Nginx Configuration (ALREADY DONE ✓)
The nginx.conf file has been updated to correctly proxy API requests.

### Step 2: Rebuild Frontend Container
Run this command to rebuild the frontend with the fixed nginx configuration:

```bash
rebuild-frontend.bat
```

**What this does:**
- Stops the frontend container
- Removes the old container
- Rebuilds the frontend Docker image with the fixed nginx.conf
- Starts the new frontend container

**Expected output:**
```
Frontend Rebuild Complete!
Frontend is now running at: http://localhost:4200
```

### Step 3: Export Medicines from Local MySQL
Run this command to export your 25+ medicines from local MySQL:

```bash
export-local-medicines.bat
```

**What this does:**
- Connects to your local MySQL (localhost:3306)
- Exports all medicines from catalog_db.medicines table
- Saves them to: `local-medicines-export.sql`

**Requirements:**
- Your local MySQL must be running
- Password: Janu@0307

### Step 4: Import Medicines to Docker MySQL
Run this command to import your medicines into Docker:

```bash
import-medicines-to-docker.bat
```

**What this does:**
- Connects to Docker MySQL container (pharmacy-mysql)
- Imports all medicines from local-medicines-export.sql
- Adds them to the catalog_db database in Docker

**Requirements:**
- Docker containers must be running
- local-medicines-export.sql must exist (from Step 3)

### Step 5: Verify Medicines Are Showing
1. Open your browser: http://localhost:4200
2. Click on "Medicines" in the navigation
3. You should now see all your 25+ medicines!

## Alternative: Manual Import Using Docker Desktop

If the scripts don't work, you can manually import using Docker Desktop:

1. **Export from local MySQL:**
   ```bash
   mysqldump -u root -p"Janu@0307" --no-create-info --skip-triggers --complete-insert catalog_db medicines > local-medicines-export.sql
   ```

2. **Copy file to Docker container:**
   ```bash
   docker cp local-medicines-export.sql pharmacy-mysql:/tmp/medicines.sql
   ```

3. **Import into Docker MySQL:**
   ```bash
   docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "source /tmp/medicines.sql"
   ```

## Verify Import Success

Check how many medicines are in Docker MySQL:

```bash
docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SELECT COUNT(*) FROM medicines;"
```

**Expected output:**
```
+----------+
| COUNT(*) |
+----------+
|       25 |  (or however many you had)
+----------+
```

## Troubleshooting

### Issue: "mysqldump command not found"
**Solution:** Add MySQL bin folder to your PATH:
- Default location: `C:\Program Files\MySQL\MySQL Server 8.0\bin`
- Or use full path: `"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysqldump.exe"`

### Issue: "Can't connect to local MySQL"
**Solution:** 
- Make sure your local MySQL is running
- Check if it's on port 3306 (not 3307)
- Verify password: Janu@0307

### Issue: "Docker container not found"
**Solution:**
```bash
docker-compose up -d
```

### Issue: Medicines still not showing after import
**Solution:**
1. Check if medicines are in database:
   ```bash
   docker exec -it pharmacy-mysql mysql -uroot -p"Janu@0307" catalog_db -e "SELECT id, name, price FROM medicines LIMIT 5;"
   ```

2. Check catalog-service logs:
   ```bash
   docker logs catalog-service
   ```

3. Restart catalog-service:
   ```bash
   docker-compose restart catalog-service
   ```

4. Check frontend logs:
   ```bash
   docker logs pharma-frontend
   ```

## Summary

**Quick Fix (4 commands):**
```bash
# 1. Rebuild frontend with fixed nginx
rebuild-frontend.bat

# 2. Export from local MySQL
export-local-medicines.bat

# 3. Import to Docker MySQL
import-medicines-to-docker.bat

# 4. Open browser and check
start http://localhost:4200
```

After these steps, your 25+ medicines should be visible in the Docker application!
