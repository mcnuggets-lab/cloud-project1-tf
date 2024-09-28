version: 0.2

environment_variables:
  plaintext:
    HUGO_VERSION: "0.128.0"
    BUCKET_ID: "${bucket_id}"
    AWS_REGION: "${aws_region}"
    
phases:
  install:
    commands:                                                                 
      - cd /tmp
      - wget https://github.com/gohugoio/hugo/releases/download/v$${HUGO_VERSION}/hugo_extended_$${HUGO_VERSION}_Linux-64bit.tar.gz
      - tar -xzf hugo_extended_$${HUGO_VERSION}_Linux-64bit.tar.gz
      - mv hugo /usr/bin/hugo
      - cd - 
      - rm -rf /tmp/*
  build:
    commands:
      - rm -rf public
      - hugo
      - aws s3 sync public/ s3://$${BUCKET_ID}/ --region $${AWS_REGION} --delete
  post_build:
    commands:
      - echo Build completed on `date`