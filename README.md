# lambda-cjk-font-layer

A script to produce lambda layer including cjk fonts

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