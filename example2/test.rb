require 'tempfile'
require 'base64'

puts 'PDF generate start'

Tempfile.create(['pdf', '.pdf']) do |tempfile|
  # Generate PDF
  system("bundle exec asciidoctor-pdf -a pdf-fontsdir=templates/fonts -a pdf-themesdir=templates/themes -a pdf-theme=customised -o #{tempfile.path} templates/hourly.adoc")

  # Read the generated PDF and encode it using Base64
  pdf_content = File.read(tempfile.path)
  base64_encoded_pdf = Base64.strict_encode64(pdf_content)

  puts "Generated and Base64-encoded PDF content:"
  # use base64_encoded_pdf
  puts base64_encoded_pdf
end

puts 'PDF generate and Base64 encode complete'
