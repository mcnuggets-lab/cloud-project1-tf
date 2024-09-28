---
title: AWS Lambda deployment of flask webapp
description: AWS Lambda deployment of flask webapp project description
date: "2024-07-09T15:57:58+08:00"
publishDate: "2024-07-09T15:57:58+08:00"
---

# 1. Introduction

You can play with the webapp [here](https://d44w85u9f6yan.cloudfront.net/).

Source code is available in https://github.com/mcnuggets-lab/cloud-project2.

This is a very simple Q&A model based on the very small [BERT-Tiny](https://huggingface.co/mrm8488/bert-tiny-5-finetuned-squadv2). To use this model, you need to provide **both the question and the context**. The model will answer the question according to the context only. For example, if

```python
question = "What is my name?"
context = "I'm Kit-Ho Mak. I come from Hong Kong."
```

Then the model will answer

```python
Kit-Ho Mak
```

which is correct in this case. As this model is very small (24MB), it is extremely weak, and cannot even guarantee a correct answer to even the simplest question. For example, if we change the middle full-stop into a comma, and add a conjuction like this

```python
question = "What is my name?"
context = "I'm Kit-Ho Mak, and I come from Hong Kong."
```

Then the model will answer "Hong Kong" :melting_face:

This webapp uses very different technology from the blog that you are currently reading, since hosting a model requires a server, we cannot just build a static website to get the job done. There are many ways to build a server in AWS (like firing an EC2) or hosting a webapp (AWS Elastic Beanstalk), but we choose a way that is free (at least when the website has only very little traffic).

# 2. Architecture

We end up using AWS Lambda to run a container that contains the webapp written in flask. To trigger the lambda function, we use an API gateway to accept requests, and broadcasted the API by CloudFront.

To simplify the deployment, we use [Serverless](https://www.serverless.com/) to generate a CloudFormation stack that automate most of the steps. This also gives me a first taste of Infrastructure as Code (IaC).

The architecture looks like this.

![cloud-project2-architecture](https://github.com/mcnuggets-lab/cloud-project2/assets/16054484/e30696f5-dc28-46a3-84b8-f9d8af15b017)

# 3. An outline of the steps required

A very brief outline of what I did:

1. Select a small enough model and download it from [HuggingFace](https://huggingface.co/).
2. Code up the flask webapp. I am not the best web designer in the world, so the webapp is very raw (only has very few inline CSS). The webapp has only 2 APIs:

   - An index page that provide a very simple UI for sending the requests with correct parameters,
   - An endpoint to process the request.
<br/><br/>
3. To deploy in AWS Lambda, we need a handler function, thus we cannot use flask's default development server (or maybe I don't know how to do that). So we need to make our flask webapp Lambda-compatible. This can be easily achieved by the simple-to-use `serverless-wsgi` package.
4. Write a `Dockerfile` to define how an image would be built. You don't need to build the image yourself, since Serverless will take care of that. You could build one to test if your container is working properly if you like. See docuemntation from Serverless on how to trigger the lambda function in a container locally.
5. Write a `serverless.yml` file to specify how to provision the stack. There are a lot of tutorials online on how to do this.
6. Give enough permission to the AWS user to perform everything in the stack. The specific permission required depends on what resources is needed. A good starting point is [this one](https://dav009.medium.com/serverless-framework-minimal-iam-role-permissions-ba34bec0154e).
7. Deploy your stack using `serverless deploy`.
8. Set up CloudFront to broadcast your API gateway.

# 4. Things that I end up not doing

These are paths I did not choose for deploying the webapp (because there is a cost), but most of them are standard ways of doing so.

- Use an EC2 to host the server.
- Package the webapp into a container, then use Amazon Elastic Cloud Service (ECS). There are a few deployment options from there.
- Use AWS Elastic Beanstalk. This is a simple and fast way to deploy a webapp, and make the webapp easily scalable.

I also did not:

- Use a larger model. My 24MB model already gives me a 490MB container, and the free tier limit for the private ECR is 500MB :disappointed: 
- Use a database to store the queries, answers, or anything. I rate data privacy higher than playing with Dynamo DB. There is no point for me to stalk on my users.

# 5. Drawback of the current approach

You may notice that the loading time for the webapp is very slow for the first few times you interact with the webapp, but performance improves after. This is due to the famous **cold start problem**.

The Lambda is turned off after inactive for a certain period, and it takes a few seconds to turn it on again. For a low-usage webapp with non-trivial overhead (loading the model in our case), this translates to a lot of cold start time. That several seconds of cold start could even make the API Gateway timed out :yawning_face:

There are some ways to combat the cold start. Apart from paying money, I can optimize the webapp a bit by serving the index page first and load the model in the background. This takes out the model loading time from the first response, but that's pretty much it.
