## main component
1.	Resource Owner
2.	Authorization Server
3.	Resource Server
4.	Client

Facebook using the Implicit grant type	
		for public clients and run directly on web browers
直接在浏览器端获取token，一般带在callback url 的hash上获取

1.	注册应用	through The Authorization Provider
	register client_id, client_secret
	
	auth_endpoint = "https://www.facebook.com/v2.9/dialog/oauth"
	response_type = 'token';
	client_id = "1948923582021549"
	redirect_uri = "http://localhost:8080/callback"
	scope = "public_profile user_friends"
	
	var request_endpoint = auth_endpoint + "?" +
		"response_type=" + response_type + "&" +
		"client_id=" + client_id + "&" +
		"redirect_uri=" + encodeURI(redirect_uri) + "&" +
		"scope=" + encodeURI(scope);

Reading the user's contacts from Facebook on the server side
	using The Authorization code grant type
	
Protecting resources using the Authorization Code grant type


@EnableResourceServer
OAuth2AuthenticationProcessingFilter
FilterChain
AuthorizationServerEndpointsConfiguration
AuthorizationServerEndpointsConfigurer
AuthorizationEndpoint
TokenEndpoint
CheckTokenEndpoint

AuthorizationServerSecurityConfiguration

---
## 一、support Authorization Code grant type

1.	
	@EnableAuthorizationServer	
	extends AuthorizationServerConfigurerAdapter
	configure(ClientDetailsServiceConfigurer clients){
		clients.inMemory()
            .withClient("clientapp")
            .secret("123456")
            .redirectUris("http://localhost:9000/callback")
            .authorizedGrantTypes("authorization_code")
            .scopes("read_profile", "read_contacts");
	}

2.
	@EnableResourceServer
	extends ResourceServerConfigurerAdapter
	configure(HttpSecurity http){
		http.authorizeRequests()
            .anyRequest()
            .authenticated()
        .and()
            .requestMatchers()
            .antMatchers("/api/**");
	}


resource api
	http://localhost:8080/api/profile

1.

http://localhost:8080/oauth/authorize?client_id=clientapp&redirect_uri=http
://localhost:9000/callback&response_type=code&scope=read_profile

2.

http://localhost:9000/callback?code=EuJoND

3.
post http://localhost:8080/oauth/token

header
	'Content-type' : 'application/x-www-urlencoded'
	'authorization': 'basic ' + base64(client_id + ':' + client_secret)
body
	code=
	grant_type=authorization_code
	redirect_uri=
	scope=

response
	{
		"access_token": "12c02d41-0da4-4278-a0d2-5e1a5da4f0b1",
		"token_type": "bearer",
		"expires_in": 43199,
		"scope": "read_profile"
	}

4.	
	
get	http://localhost:8080/api/profile

header
	'Authorization': 'Bearer' + access_token 
	
response
	{
		"name": "zhong",
		"email": "zhong@mailinator.com"
	}

---
## 二、support the Implicit Grant type
	适用于web 浏览器端运行的程序
	
2.	
get http://localhost:8080/oauth/authorize?
		client_id=clientappimplicit&
		redirect_uri=http://localhost:9000/callback&
		response_type=token&
		scope=read_profile&
		state=xyz

response
	http://localhost:9000/callback#
		access_token=bd6ae0ac-4858-485a-802f-8b1fab7c0c19&
		token_type=bearer&
		state=xyz&
		expires_in=120


---
## 三、Using the Resource Owner Password Credentials grant type

1.

post http://localhost:8080/oauth/token

header
	'Content-type' : 'application/x-www-urlencoded'
	'authorization': 'basic ' + base64(client_id + ':' + client_secret)

body
	grant_type=password
	username=
	password=
	redirect_uri=
	scope=
	
response
	{
		"access_token": "3e35e5c8-aac8-44f5-8428-66a1d57e299a",
		"token_type": "bearer",
		"expires_in": 119,
		"scope": "read_profile"
	}

---
## 四、using the Client Credentials grant type
	获取客户端自己的资源，而不是每一个用户的资源

post	http://localhost:8080/oauth/token

header
	'Content-type' : 'application/x-www-urlencoded'
	'authorization': 'basic ' + base64(client_id + ':' + client_secret)

body
	grant_type=password
	username=
	password=
	redirect_uri=
	scope=


---
## 五、adding support for refresh token, using refresh token grant type

1.

post http://localhost:8080/oauth/token

header
	'Content-type' : 'application/x-www-urlencoded'
	'authorization': 'basic ' + base64(client_id + ':' + client_secret)

body
	grant_type=password
	username=
	password=
	redirect_uri=
	scope=
	
response
	{
        "access_token": "9bcf18d9-6346-4871-9521-cd48bc4cf63e",
        "token_type": "bearer",
        "refresh_token": "b11387ef-cc7b-42fc-920a-73d50ab36a28",
        "expires_in": 119,
        "scope": "read_profile"
    }   

2.  get access_token using refresh_token

post http://localhost:8080/oauth/token

header
	'Content-type' : 'application/x-www-urlencoded'
	'authorization': 'basic ' + base64(client_id + ':' + client_secret)

body
	grant_type=refresh_token
	refresh_token=
	scope=

---
## Using a relational database to store the tokens and client details

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
```
### store access tokens
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
```
create table oauth_approvals (
    userId VARCHAR(256),
    clientId VARCHAR(256),
    scope VARCHAR(256),
    status VARCHAR(10),
    expiresAt TIMESTAMP,
    lastModifiedAt TIMESTAMP
);
create table oauth_refresh_token (
    token_id VARCHAR(256),
    token LONG VARBINARY,
    authentication LONG VARBINARY
);
```
---
## Using Redis as a token store





























