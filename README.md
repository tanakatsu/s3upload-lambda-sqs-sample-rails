# S3Upload-Lambda-SQS-sample (Rails)

### S3 bucket Configuration

###### CORS設定
Properties > Permissions > Edit CORS Configuration

```
<CORSConfiguration>
    <CORSRule>
        <AllowedOrigin>*</AllowedOrigin>
        <AllowedMethod>GET</AllowedMethod>
        <AllowedMethod>POST</AllowedMethod>
        <AllowedMethod>DELETE</AllowedMethod>
        <MaxAgeSeconds>3000</MaxAgeSeconds>
        <AllowedHeader>*</AllowedHeader>
    </CORSRule>
</CORSConfiguration>
```

###### Events設定
Properties > Events

```
Name: InvokeLambdaForDevelopment
Events: Post
Prefix: development/image_original/
Suffix: .jpg
SendTo: Lambda function
Lambda function: CreateThumbsWithMessaging
```

* Change values depending on your environment
* You may have to create settings for each environment

### Get started (development)

1. create S3 bucket
1. edit S3 bucket CORS settings
1. edit S3 bucket Events settings
1. deploy Lambda function
1. create SQS Queue
1. edit env_sample.sh
1. ```$ source env_sample.sh```
1. ```$ rails s```

### Related project

[https://github.com/tanakatsu/s3upload-lambda-sqs-sample-function](https://github.com/tanakatsu/s3upload-lambda-sqs-sample-function)