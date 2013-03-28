#UFC FIT OAuth Provider API (v1.0)

UFC FIT OAuth Provider provides a single sign on solution for accounts in multiple applications of UFC FIT. This application will be centralizing User and its Membership information and will provide REST APIs for authentication and accessing of User and Membership information.

##Setup

###Registering your client application

Please contact the authors of UFC Fit Project to get your application registered for production environments.

Test information:

Site: http://ufcfit-oauth-provider-staging.herokuapp.com/

Client key: e7hkacg16w1mhavvuk41axz0ffw4imd

Client secret: h062zgkoyl8b43x0jjjpcvx2ya6sqx8

Redirect URI: http://localhost:3000/

##Authentication

UFC FIT OAuth Provider offers client applications the ability to issue authenticated requests on behalf of client application or on behalf of specified user.

The implementation of authentication on behalf of client application is based on [Client Credentials Grant](http://tools.ietf.org/html/rfc6749#section-4.4) flow of the [OAuth 2.0 specification](http://tools.ietf.org/html/rfc6749).

The implementation of authentication on behalf of specified user is based on [Resource Owner Password Credentials Grant](http://tools.ietf.org/html/rfc6749#section-4.3) flow of [OAuth 2.0 specification](http://tools.ietf.org/html/rfc6749).

###Application based authentication

This can be used to create a new user, reset password and destroy user.

The application-only auth flow follows these steps:

####Step 1: Encode Consumer key and secret

The steps to encode an application's consumer key and secret into a set of credentials to obtain a bearer token are:

* URL encode the consumer key and the consumer secret according to RFC 1738. Note that at the time of writing, this will not actually change the consumer key and secret, but this step should still be performed in case the format of those values changes in the future.
* Concatenate the encoded consumer key, a colon character ":", and the encoded consumer secret into a single string.
* Base64 encode the string from the previous step.


####Step 2: Obtain an access/bearer token using key and secret

An application makes a request to the [POST oauth2/token]() endpoint to exchange these credentials for a bearer token

Example request (Header has been wrapped):

    POST /oauth/token HTTP/1.1
    Host: accounts.ufcfit.com
    User-Agent: UFC Fit US App v1.0
    Authorization: Basic eHZ6MWV2RlM0d0VFUFRHRUZQSEJvZzpMOHFxOVBaeVJn
                     NmllS0dFS2hab2xHQzB2SldMdzhpRUo4OERSZHlPZw==
    Content-Type: application/x-www-form-urlencoded;charset=UTF-8
    Content-Length: 29
    Accept-Encoding: gzip

    grant_type=client_credentials

Example response:

    HTTP/1.1 200 OK
    Status: 200 OK
    Content-Type: application/json; charset=utf-8
    ...
    Content-Encoding: gzip
    Content-Length: 140
    
    {"token_type":"bearer","access_token":"BLABLABLABLABLABLABLABLABLABLABLABLABLABLABLA"}

####Step 3: Authenticate API requests with the bearer/access token

When accessing the REST API, the application uses the bearer token to authenticate.

The bearer token may be used to issue requests to API endpoints which support application-only auth. To use the bearer token, construct a normal HTTPS request and include an Authorization header with the value of Bearer (base64 bearer token value from step 2). Signing is not required.

Example request (Header has been wrapped):

    GET /api/v1/users/new.json
    HTTP/1.1
    Host: accounts.ufcfit.com
    User-Agent: UFC Fit US App v1.0
    Authorization: Bearer BLABLABLABLABLABLABLABLABLABLABLABLABLABLABLA
    Accept-Encoding: gzip



###User based authentication

This is used to access API endpoints in which sign in is required e.g. /api/v1/users/:id

User based authentication flow follows these steps:

####Step 1: Encode Consumer key and secret

This is done using the same way as done for application based authentication flow.

####Step 2: Obtain an access/bearer token using username and password

An application makes a request to the [POST oauth2/token]() endpoint to exchange these credentials for a bearer token

Example request (Header has been wrapped):

    POST /oauth/token HTTP/1.1
    Host: accounts.ufcfit.com
    User-Agent: UFC Fit US App v1.0
    Authorization: Basic eHZ6MWV2RlM0d0VFUFRHRUZQSEJvZzpMOHFxOVBaeVJn
                     NmllS0dFS2hab2xHQzB2SldMdzhpRUo4OERSZHlPZw==
    Content-Type: application/x-www-form-urlencoded;charset=UTF-8
    Content-Length: 29
    Accept-Encoding: gzip

    grant_type=password&username=johndoe&password=A3ddj3w

Example response:

    HTTP/1.1 200 OK
    Status: 200 OK
    Content-Type: application/json; charset=utf-8
    ...
    Content-Encoding: gzip
    Content-Length: 140
    
    {"token_type":"bearer","access_token":"BLABLABLABLABLABLABLABLABLABLABLABLABLABLABLA"}

####Step 3: Authenticate API requests with the bearer/access token

When accessing the REST API, the application uses the bearer token to authenticate.

The bearer token may be used to issue requests to API endpoints which support application-only auth. To use the bearer token, construct a normal HTTPS request and include an Authorization header with the value of Bearer (base64 bearer token value from step 2). The user who is signed in must be owner of the resource which is to be accessed through APIs.

Example request (Header has been wrapped):

    GET /api/v1/users/123.json
    HTTP/1.1
    Host: accounts.ufcfit.com
    User-Agent: UFC Fit US App v1.0
    Authorization: Bearer BLABLABLABLABLABLABLABLABLABLABLABLABLABLABLA
    Accept-Encoding: gzip


###Using OAuth2 Ruby Gem for Authentication

Getting an access token and making API calls is really easy with [OAuth2 gem](https://github.com/intridea/oauth2).

    client = OAuth2::Client.new(consumer_key, consumer_secret)

    # application based authentication
    token = client.client_credentials.get_token

    # create new user
    response = token.post('/api/v1/users/', :body => {:user => {:email => "bla@bla.com", :password => "blabla"}})

    # user based authentication
    token = client.password.get_token("bla@bla.com", "blabla")

    # get user information
    response = token.get('/api/v1/me', :params => {:email => "bla@bla.com"})

##Errors

* 200 OK - Everything worked as expected.
* 400 Bad Request - Often missing a required parameter.
* 401 Unauthorized - No valid API key provided.
* 402 Request Failed - Parameters were valid but request failed.
* 403 Forbidden - Access denied
* 404 Not Found - The requested item doesn't exist.
* 500, 502, 503, 504 Server errors - something went wrong on OAuth Provider's end.

##Rate Limiting

To be implemented

##User API Endpoints

###GET /api/v1/users/user-id

Get the basic information of User.

https://accounts.ufcfit.com/api/v1/users/12345/?access_token=ACCESS-TOKEN

Access token to be used for authorization should obtained using User based Authentication.

Response:

    {
      "user": {
        "id": 123,
        "email": "abc@def.com",
        "created_at": ,
        "updated_at":
      }
    }

With Ruby OAuth2 gem:

    # get token from password grant of user 123 and then call
    response = token.get('/api/v1/users/123')


###POST /api/v1/users/?access_token=ACCESS-TOKEN

Create a new user.

Access token is to be obtained using Application based Authentication.

Params

    {
      "user": {
        "email": "bla@bla.com",
        "password": "blablabla"
      }
    }

Response

    {
      "user": {
        "id": 123,
        "email": "abc@def.com",
        "created_at": ,
        "updated_at":
      }
    }

With Ruby OAuth2 gem:

    # get token from client credentials grant and call
    response = token.post('/api/v1/users/', :body => {:user => {:email => "bla@bla.com", :password => "blabla"}})

###PUT /api/v1/users/user-id/?access_token=ACCESS-TOKEN

Update user email and/or password.

Access token to be used for authorization should obtained using User based Authentication.

Params

    {
      "user": {
        "email": "bla@bla.com",
        "password": "blablabla"
      }
    }

Response

    {
      "user": {
        "id": 123,
        "email": "abc@def.com",
        "created_at": ,
        "updated_at":
      }
    }

With Ruby OAuth2 gem:

    # get token from password grant of user 123 and then call
    response = token.put('/api/v1/users/123/', :body => {:user => {:password => "blablabla"}})

###DELETE /api/v1/users/user-id/?access_token=ACCESS-TOKEN

De-activate a user.

Access token to be used for authorization should obtained using User based Authentication.

Response

    {
      "user": {
        "id": 123,
        "email": "abc@def.com",
        "created_at": ,
        "updated_at":
      }
    }

With Ruby OAuth2 gem:

    # get token from password grant of user 123 and then call
    response = token.delete('/api/v1/users/123/')

##Membership/Subscription API Endpoints

To be implemented
