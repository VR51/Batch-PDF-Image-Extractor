# Batch-PDF-Image-Extractor
Extract images from PDF documents. Works on multiple and single PDF files. Requires BASH.

# Instructions
- Copy batch-pdf-image-extractor.sh to a directory that contains PDF files
- Make batch-pdf-image-extractor.sh executable. Either right-click to edit file properties or run `chmod +x batch-pdf-image-extractor.sh`
- Run the script with `bash batch-pdf-image-extractor.sh` or just click the file 'batch-pdf-image-extractor.sh'

# What Will Happen
- The script will look for PDF files in the active directory.
- The files will then be processed to extract any images.
- The images will be extracted
- Extracted images will be converted to PNG format
- Images will be moved into an 'images' directory
- PDF files will be moved into a 'pdf' directory

# Configs
Three optional configuration variables exist. These control image conversion and whether processed files are moved or copied. The default settings suit most workflows (i.e process PDF(s), convert images to PNG, then move files).

The configs are at the top of the script file:

```
##
#
# Configs
#
##

extensions=( tiff tif pmb ppm ) # List the output image extensions that should be converted to a different format
format='png' # State the format images with $extensions should be converted to.
organize='move' # 'copy' or 'move' all files into subdirectories organised by extension type. Leave empty for no organization.

## END Configs
```

# Requirements
This script reqires pdfimages to be installed. The script will check for pdfimages and prompt for its installation if not found.
# Known Issues
Any issues with pdfimages will also be evident in Batch PDF Image Extractor.
Images fail to extract from some PDF files. I don't know why this is. Will look into it when I get time.
# Donations
I give a lot to the open source community. All donations are welcome. Please send donations to https://paypal.me/vr51
