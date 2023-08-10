require 'json'

def print(out_file:)
  `echo "This is the PDF content" > #{out_file}`
  # `bundle exec asciidoctor-pdf -a pdf-fontsdir=templates/fonts -a pdf-themesdir=templates/themes -a pdf-theme=customised -o /tmp/hourly.pdf templates/hourly.adoc`


def lambda_handler(event:, context:)
  # Tasks
  # 1. Create a temporary file (for PDF output)
  # 2. Call print method to generate PDF file
  # 3. Upload the generated PDF file to S3 bucket
  # 4. Delete the temporary file
  # 5. Return the S3 URL of the PDF file

  {
    statusCode: 200,
    body: {
      message: "Happy coding!!!",
    }.to_json
  }
end
