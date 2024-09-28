{
	"Version": "2008-10-17",
	"Id": "PolicyForCloudFrontPrivateContent",
	"Statement": [
		{
			"Sid": "AllowCloudFrontServicePrincipal",
			"Effect": "Allow",
			"Principal": {
				"Service": "cloudfront.amazonaws.com"
			},
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::${s3_bucket_name}/*",
			"Condition": {
				"StringEquals": {
					"AWS:SourceArn": "arn:aws:cloudfront::770901818073:distribution/E3K98LZUDMNE32"
				}
			}
		},
		{
			"Sid": "AllowCloudFrontServiceOAI",
			"Effect": "Allow",
			"Principal": {
				"AWS": "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity E3SXQL793D1PZN"
			},
			"Action": "s3:GetObject",
			"Resource": "arn:aws:s3:::${s3_bucket_name}/*"
		}
	]
}