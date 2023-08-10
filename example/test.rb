require 'fileutils'
require 'aws-sdk-s3'
require 'tempfile'

puts 'PDF generate start'

def create_folder_if_not_exists(folder_name)
  if Dir.exist?(folder_name)
    puts "Folder '#{folder_name}' already exists."
  else
    Dir.mkdir(folder_name)
    puts "Folder '#{folder_name}' created."
  end
end

def upload_file_to_s3(bucket_name, local_file_path, s3_key)
  s3 = Aws::S3::Resource.new(region: 'eu-west-1')
  
  bucket = s3.bucket(bucket_name)
  obj = bucket.object(s3_key)
  obj.upload_file(local_file_path)
  puts "File '#{local_file_path}' uploaded to '#{s3_key}'."
end

def generate_pdf(temp_dir)
  pdf_path = File.join(temp_dir, 'hourly.pdf')
  system("bundle exec asciidoctor-pdf -a pdf-fontsdir=templates/fonts -a pdf-themesdir=templates/themes -a pdf-theme=customised -o #{pdf_path} templates/hourly.adoc")
  pdf_path
end

folder_name = 'tmp'
# Create tmp folder
create_folder_if_not_exists(folder_name)

# Use Tempfile to create a temporary directory
temp_dir = Dir.mktmpdir(nil, folder_name)

begin
  # Generate PDF
  pdf_path = generate_pdf(temp_dir)

  # Upload to S3
  bucket_name = 'bucket-name'
  s3_key = 'destination/hourly.pdf' 
  upload_file_to_s3(bucket_name, pdf_path, s3_key)
  s3_path = "s3://#{bucket_name}/#{s3_key}"
ensure
  # Clean up: delete the temporary directory
  FileUtils.remove_entry(temp_dir)
end

puts "PDF generate complete and uploaded to '#{s3_path}'."
