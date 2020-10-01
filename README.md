# Resume

Guide to Dockerize Wordpress in production.

# Development

Add Hosts:

```
192.168.56.10 APPNAME-app.captain.localhost
192.168.56.10 APPNAME-db-admin.captain.localhost
```

Build and Run:

```bash
make build
make start
```

phpMyAdmin:

| Host | User | Pass      |
| ---- | ---- | --------- |
| db   | root | wordpress |

Import Data:

`http://localhost:8000` > `wordpress` > Import > Browser > Select `.sql` file > Execute

Change Domain:

`http://localhost:8000` > `wordpress` > `wp_options` > Edit `siteurl` and `home` to `http://localhost:3000`

Change Password:

`http://localhost:8000` > `wordpress` > `wp_users` > Select a User > Edit > Edit `user_pass` field with `MD5` > Execute

Access Admin:

`http://localhost:3000/wp-admin`

Access Site:

`http://localhost:3000`

# Production

## 1. Check PHP Version

```bash
php --version
```

## 2. Check Wordpress Version

```bash
SITE_NAME="domain.com"

grep wp_version /usr/share/nginx/sites/${SITE_NAME}/www/wp-includes/version.php
```

## 3. Check Database Type and Version

```bash
mysql -V
```

## 4. Backup All

Enter Directory:

```bash
cd /usr/share/nginx
```

Do Backup:

```bash
DATE=$(date +%Y%m%d%H%m)

tar -czvf wp-sites-backup-${DATE}.tar.gz sites
mysqldump -u root -p --all-databases | gzip -c > wp-db-backup-${DATE}.gz
```

> Enter FPT client and copy backup files in `/usr/share/nginx/` to your localhost.

## 5. Edit `.sql` dump file

### 5.1. Remove all PREFIX table names

From `wp_PREFIX_table_name` to `wp_table_name`.

### 5.2. Change Database Name

From:

```sql
CREATE DATABASE `old_database_name`;

USE `old_database_name`;
```

To:

```sql
CREATE DATABASE `wordpress`;

USE `wordpress`;
```

# Migrate

## 1. [Setup VPS](https://github.com/junioregis/caprover-vps)

## 2. Copy files

Copy `wp-content` folders (`plugins`, `themes`, `uploads` and important folders inside) to `wp-content folder` in project.

Copy root important folders to `root folder` in project`.

## 3. Create `.tar` of project

## 4. Create Services

Apps > One-Click Apps/Databases > TEMPLATE > Paste `captain.template.yml` content > Next > Set App Name > Deploy

## 5. Import Data

Enter phpMyAdmin:

[http://APPNAME-db-admin.captain.domain.com](ttp://APPNAME-db-admin.captain.domain.com)

Connect to Database:

| Host                    | User | Pass      |
| ----------------------- | ---- | --------- |
| srv-captain--APPNAME-db | root | wordpress |

Import:

Select `wordpress` database > Import > Browser > Select `.sql` file > Execute

## 6. Change Wordpress Config

Change Domain:

`https://APPNAME-db-admin.domain.com` > Select `wordpress` database > Select `wp_options` table > Edit `siteurl` and `home` to `https://app.domain.com`

Change Password:

`https://APPNAME-db-admin.domain.com` > Select `wordpress` database > Select `wp_users` table > Select a User > Edit > Edit `user_pass` field with `MD5` > Execute

## 7. Setup Domain

Enable SSL and set domain to `APPNAME.domain.com`:

Apps > `APPNAME` > HTTP Settings > Enable HTTPS

## 8. Set NGinx Upload Limit

Enter NGinx conainer with name `captain-nginx.*`:

```bash
docker exec -it CONTAINER_ID bash
```

Edit `/etc/nginx/conf.d/captain-root.conf` and increase body size.

```
client_max_body_size 9999m;
```

Restart NGinx:

```bash
nginx -s reload
```

> The `client_max_body_size` will go to default on next reboot.

## 9. Deploy App

Apps > `APPNAME_app` > Deployment > Method 2: Tarball > Select `.tar` > Upload & Deploy

## 10. Return to Default Upload Size for NGinx (See step 9)

## 11. Change Permissions

Enter App Terminal:

```bash
docker exec -it CONTAINER_ID bash
```

Execute:

```bash
chown -R www-data:www-data /var/www/html/
```

## 12. Exclude phpMyAdmin Service

Apps > `APPNAME-db-admin` > Delete App

## 13. Setup Subdomain (Optional)

Add to DNS Registry:

| Name      | Type | Data      |
| --------- | ---- | --------- |
| subdomain | A    | SERVER_IP |

Config App:

Apps > `APPNAME` > HTTP Settings > Input `subdomain` > Connect New Domain and `Enable HTTPS`
