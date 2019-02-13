# Using a relational database to store tokens and client details

## 创建mysql数据库
```
create database oauth2provider;
create user 'oauth2provider'@'localhost' identified by '123456'
grant all privileges on oauth2provider.* To 'oauth2provider'@'localhost' 
```

### 创建client registration相关的表
```
create table oauth_client_details (
  client_id VARCHAR(256) PRIMARY KEY,
  resource_ids VARCHAR(256),
  client_secret VARCHAR(256),
  scope VARCHAR(256),
  authorized_grant_types VARCHAR(256),
  web_server_redirect_uri VARCHAR(256),
  authorities VARCHAR(256),
  access_token_validity INTEGER,
  refresh_token_validity INTEGER,
  additional_information VARCHAR(4096),
  autoapprove VARCHAR(256)
);
```
- authorities   
- autoapprove
- authorized_grant_types    (autorization_code, refresh_token,password,client_credentials)
- 

### 存储client token的表
```
create table oauth_client_token (
  token_id VARCHAR(256),
  token LONG VARBINARY,
  authentication_id VARCHAR(256) PRIMARY KEY,
  user_name VARCHAR(256),
  client_id VARCHAR(256)
);
```

### 存储access token
```
create table oauth_access_token (
  token_id VARCHAR(256),
  token LONG VARBINARY,
  authentication_id VARCHAR(256) PRIMARY KEY,
  user_name VARCHAR(256),
  client_id VARCHAR(256),
  authentication LONG VARBINARY,
  refresh_token VARCHAR(256)
);
```

### 存储refresh token
```
create table oauth_refresh_token (
  token_id VARCHAR(256),
  token LONG VARBINARY,
  authentication LONG VARBINARY
);
```

### 存储oauth_code
```
create table oauth_code (
  code VARCHAR(256), authentication LONG VARBINARY
);
```

### 存储approval信息
```
create table oauth_approvals (
    userId VARCHAR(256),
    clientId VARCHAR(256),
    scope VARCHAR(256),
    status VARCHAR(10),
    expiresAt TIMESTAMP,
    lastModifiedAt TIMESTAMP
);
```

### 插入一条client信息
```
INSERT INTO oauth_client_details
    (client_id, resource_ids, client_secret, scope, authorized_grant_types,
    web_server_redirect_uri, authorities, access_token_validity, refresh_token_validity,
    additional_information, autoapprove)
VALUES
    ('clientapp', null, '123456',
    'read_profile,read_posts', 'authorization_code',
    'http://localhost:9000/callback',
    null, 3000, -1, null, 'false');
```

# create oauth client

client type:
- authorization code grant type
- implicit grant type
- resource owner password grant type
- client credentials grant type
- manage refresh token
- access an oauth api with RestTemplate





















