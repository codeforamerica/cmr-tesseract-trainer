# cmr-tesseract-trainer

This is a script for training Tesseract 3, based on the tutorial found [here.](https://github.com/tesseract-ocr/tesseract/wiki/Training-Tesseract-3.03%E2%80%933.05)

## Prerequisites

Install Tesseract with training tools on OS X by running:
`brew install tesseract --with-training-tools`

## Usage

Run the script with `ruby train.rb`

The script generates Tesseract .traineddata file from inputs found in the inputs folder.

Intermediate generated files are stored in tempfiles directory. These are safe to delete, as they will be regenerated each time the script is run.

Output file will be found in traineddata folder; also, the script copies the file to your Tesseract installation, if it can be detected.

To specify the generated "rap" language, you will need to call Tesseract with `tesseract --lang rap`.

## Notes

Latin unicharset sourced from:
https://github.com/tesseract-ocr/langdata

