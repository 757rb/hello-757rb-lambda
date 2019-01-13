require 'securerandom'

module MockResponseTestHelper
  private

  class LambdaContext
    def aws_request_id
      SecureRandom.uuid
    end

    def function_version
      '$LATEST'
    end
  end

  def mock_context
    LambdaContext.new
  end

  def mock_event
    {
      "resource": "/hello",
      "path": "/hello/",
      "httpMethod": "GET",
      "headers": {
        "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
        "accept-encoding": "br, gzip, deflate",
        "Accept-Language": "en-us",
        "CloudFront-Forwarded-Proto": "https",
        "CloudFront-Is-Desktop-Viewer": "true",
        "CloudFront-Is-Mobile-Viewer": "false",
        "CloudFront-Is-SmartTV-Viewer": "false",
        "CloudFront-Is-Tablet-Viewer": "false",
        "CloudFront-Viewer-Country": "US",
        "dnt": "1",
        "Host": "uv07vr9nu0.execute-api.us-east-1.amazonaws.com",
        "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15",
        "Via": "2.0 8bcdfe5c699ee9a81d92de5e160d9563.cloudfront.net (CloudFront)",
        "X-Amz-Cf-Id": "WG9SbaXg5CgZhAKYWCwElDLfeDihfzSpwqDt5FkBB-5a9S85q-aIJA==",
        "X-Amzn-Trace-Id": "Root=1-5c3b41de-13b7915882f41adb1f9f81f2",
        "X-Forwarded-For": "72.218.219.201, 54.182.230.8",
        "X-Forwarded-Port": "443",
        "X-Forwarded-Proto": "https"
      },
      "multiValueHeaders": {},
      "queryStringParameters": nil,
      "multiValueQueryStringParameters": nil,
      "pathParameters": nil,
      "stageVariables": nil,
      "requestContext": {
        "resourceId": "motxrc",
        "resourcePath": "/hello",
        "httpMethod": "GET",
        "extendedRequestId": "Tcc6xFFFoAMFxGQ=",
        "requestTime": "13/Jan/2019:13:49:18 +0000",
        "path": "/Prod/hello/",
        "accountId": "589405201853",
        "protocol": "HTTP/1.1",
        "stage": "Prod",
        "domainPrefix": "uv07vr9nu0",
        "requestTimeEpoch": 1547387358543,
        "requestId": "05dd1e50-173a-11e9-bb15-efe07a08d00f",
        "identity": {
          "cognitoIdentityPoolId": nil,
          "accountId": nil,
          "cognitoIdentityId": nil,
          "caller": nil,
          "sourceIp": "72.218.219.201",
          "accessKey": nil,
          "cognitoAuthenticationType": nil,
          "cognitoAuthenticationProvider": nil,
          "userArn": nil,
          "userAgent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_2) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/12.0.2 Safari/605.1.15",
          "user": nil
        },
        "domainName": "uv07vr9nu0.execute-api.us-east-1.amazonaws.com",
        "apiId": "uv07vr9nu0"
      },
      "body": nil,
      "isBase64Encoded": false
    }
  end

end
