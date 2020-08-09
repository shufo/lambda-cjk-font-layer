# font layer
module "cjk_font_layer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "1.17.0"

  create_package = true
  create_layer   = true

  layer_name          = "cjk_font_layer"
  description         = "CJK Font layer"
  compatible_runtimes = ["nodejs10.x"]

  source_path = [
    {
        path = "../"
        command = ["make build-ttc-cache"]
        patterns = [
          "!fonts/example/.+",
        ],
        prefix_in_zip = "fonts"
    }
  ]
}

# headless chrome layer
module "chrome_aws_layer" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "1.17.0"

  create_package = true
  create_layer   = true

  layer_name          = "chrome_aws_layer"
  description         = "Headless chromium layer"
  compatible_runtimes = ["nodejs10.x"]

  source_path = [
    {
      path = "./chrome-aws-lambda"
      command = [
        "npm install lambdafs@~1.3.0 puppeteer-core@~5.1.0 --no-bin-links --no-optional --no-package-lock --no-save --no-shrinkwrap",
        "npm pack",
        "mkdir -p node_modules/chrome-aws-lambda",
        "tar --directory node_modules/chrome-aws-lambda/ --extract --file chrome-aws-lambda-*.tgz --strip-components=1"
      ]
      patterns = [
        "!nodejs/bin/.+",
        "nodejs/node_modules/.*",
      ],
      prefix_in_zip = "nodejs"
    }
  ]
}

# serverless pdf generator
module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "1.17.0"

  create_package = true
  create_function = true

  function_name = "pdf_generator"
  description   = "generate and returns pdf with base64 encode string"
  handler       = "index.handler"
  runtime       = "nodejs10.x"
  memory_size   = 512
  timeout       = 30
  publish       = true

  environment_variables = {
    HOME = "/opt/fonts"
  }

  layers = [
    module.chrome_aws_layer.this_lambda_layer_arn
    module.font_layer.this_lambda_layer_arn
  ]

  source_path = [{

    path = "${path.module}/lambda-pdf-generator"
    commands = [
        "npm install",
        ":zip",
    ]
  }
  ]
}
