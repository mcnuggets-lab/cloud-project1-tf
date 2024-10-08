baseURL = "${cloudfront_url_endpoint}"
languageCode = "en-us"
title = "My New Hugo Site via AWS"
theme = "personal-web"
copyright="© Kit-Ho Mak"
googleAnalytics = ""
enableEmoji=true
enableRobotsTXT=true
pygmentsUseClasses=true
pygmentsCodeFences=true

[[deployment.targets]]
name = "awsbucket"
URL = "s3://${bucket_id}/?region=${aws_region}"

[params.intro]
  main = "Hi, I'm Kit-Ho Mak :wave:"
  sub = "I'm a Data Scientist learning MLOps"

[params.main]
  latestPublishHeader = "My Latest Posts"

[taxonomies]
  design = "designs"
  tech = "techs"

[blackfriday]
  hrefTargetBlank = true

[params]
  breadcrumb = true
  accentColor = "#FD3519"
  mainSections = ['post'] # values: ['post', 'portfolio'] only accept one section, to be displayed bellow 404
  rendererSafe = false # set to true if wish to remove the unsafe renderer setting below (recommended). Titles will not be run through markdownify

[params.notFound]
  gopher = "/images/gopher.png" # checkout https://gopherize.me/
  h1 = 'Bummer!'
  p = "It seems that this page doesn't exist."

[params.sections]
  # Define how your sections will be called
  # when automatically pulled. For instance in the 404 page
  post = "article"
  portfolio = "project"

[params.sidebar]
  backgroundImage = '' # header background image - default "/images/default_sidebar.jpg" - Photo by Tim Marshall on Unsplash
  gradientOverlay = '' # default: rgba(0,0,0,0.4),rgba(0,0,0,0.4)
  logo = "/images/profile_pic.jpg"
[params.assets]
  favicon = ""
  customCSS = ""

[params.social]
github = "https://github.com/mcnuggets-lab"
#   twitter = "https://twitter.com/"
linkedin = "https://www.linkedin.com/in/kit-ho-mak-3077b3101/"
#   medium = "https://medium.com/"
#   codepen = "https://codepen.io/"
#   facebook = "https://www.facebook.com/"
#   youtube = "https://www.youtube.com/"
#   instagram = "https://www.instagram.com/"
#   gitlab = "https://gitlab.com/"
#   keybase = "https://keybase.io/"

[params.contact]
  email = ""
  text= "" # text of the contact link in the sidebar. If email params.contact.email is defined


[menu]

[[menu.main]]
  identifier = "about"
  name = "About"
  title = "About section"
  url = "/about/"
  weight = -120

[[menu.main]]
  identifier = "blog"
  name = "Post"
  title = "Blog section"
  url = "/post/"
  weight = -100

[sitemap]
  changefreq = "monthly"
  filename = "sitemap.xml"
  priority = 0.5

[privacy]
  [privacy.googleAnalytics]
    anonymizeIP = true
    disable = true
    respectDoNotTrack = true
    useSessionStorage = false
  [privacy.twitter]
    disable = false
    enableDNT = true
    simple = false

[markup]
  [markup.goldmark]
    [markup.goldmark.renderer]
      unsafe = true
