# lambda-cjk-font-layer

A script to produce lambda layer including cjk fonts

Below is font rendering example in pdf generated with [lambda-pdf-generator](https://github.com/shufo/lambda-pdf-generator)

![image](https://user-images.githubusercontent.com/1641039/89757459-474ebb80-db20-11ea-811f-707f37e74661.png)
![image](https://user-images.githubusercontent.com/1641039/89757536-8715a300-db20-11ea-8c5f-d452febbbc0f.png)
![image](https://user-images.githubusercontent.com/1641039/89757595-af9d9d00-db20-11ea-97d6-b5ecd41d7e6e.png)

## build

To build CJK font layer, executing

```bash
make build 
```

will produces below layer package.

```bash
noto_cjk_font_layer.zip
```

It includes all JP, KR, SC, TC fonts


## Installation

Upload zip package to your lambda layers and specify layer from your lambda.

It introduce below directory into your lambda environment

- `/opt/fonts/.fonts`
- `/opt/fonts/.fontconfig`

If you are using headless chrome on lambda by [chrome-aws-lambda](https://github.com/alixaxel/chrome-aws-lambda),
you can set `HOME` environment variable as `/opt/fonts` and headless chrome will refers fonts as expected.


## Example

see `example/main.tf`

## Language specific layer

you can build language, and weight specific layers.

### JP
```bash
# Regular weight layer
make build-noto jp Regular
```

including

- NotoSansCJKjp Regular
- NotoSerifCJKjp Regular

or you can specify other weights

```bash
# Bold weight layer
make build-noto jp Bold
```

including

- NotoSansCJKjp Bold
- NotoSerifCJKjp Bold

```bash
make build-ipa
```

including

- IPA Gothic
- IPA P Gothic
- IPA Mincho
- IPA P Mincho


### KR

```bash
make build-noto kr Regular
```

including

- NotoSansCJKkr Regular
- NotoSerifCJKkr Regular

### SC

```bash
make build-noto sc Regular
```

including

- NotoSansCJKsc Regular
- NotoSerifCJKsc Regular

### TC

```bash
make build-noto tc Regular
```

including

- NotoSansCJKtc Regular
- NotoSerifCJKtc Regular