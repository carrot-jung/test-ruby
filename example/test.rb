require 'aws-sdk-s3'
require 'tempfile'

puts 'PDF generate start'

def upload_file_to_s3(bucket_name, local_file_path, s3_key)
  s3 = Aws::S3::Resource.new(region: 'eu-west-1')
  
  bucket = s3.bucket(bucket_name)
  obj = bucket.object(s3_key)
  obj.upload_file(local_file_path)
  puts "File '#{local_file_path}' uploaded to '#{s3_key}'."
end

Tempfile.create(['pdf', '.pdf']) do |tempfile|
  # Generate PDF
  puts "tempfile : #{tempfile}"
  system("bundle exec asciidoctor-pdf -a pdf-fontsdir=templates/fonts -a pdf-themesdir=templates/themes -a pdf-theme=customised -o #{tempfile.path} templates/hourly.adoc")

  # Upload to S3
  bucket_name = 'bucket-name'
  s3_key = 'destination/hourly.pdf'
  upload_file_to_s3(bucket_name, tempfile.path, s3_key)
  s3_path = "s3://#{bucket_name}/#{s3_key}"

  puts "File uploaded to '#{s3_path}'."
end

puts 'PDF generate complete'
