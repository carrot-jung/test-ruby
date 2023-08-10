require 'fileutils'
require 'aws-sdk-s3'

puts 'PDF generate start'

def delete_directory(absolute_path)
  if Dir.exist?(absolute_path)
    FileUtils.rm_rf(absolute_path)
    puts "Folder '#{absolute_path}' deleted."
  else
    puts "Folder '#{absolute_path}' does not exist."
  end
end

def create_folder_if_not_exists(folder_name)
  if Dir.exist?(folder_name)
    puts "Folder '#{folder_name}' already exists."
  else
    Dir.mkdir(folder_name)
    puts "Folder '#{folder_name}' created."
  end
end

def upload_file_to_s3(bucket_name, file_path, s3_key)
    s3 = Aws::S3::Resource.new(region: 'eu-west-1')
  
    bucket = s3.bucket(bucket_name)
    obj = bucket.object(s3_key)
    obj.upload_file(file_path)
    puts "File '#{file_path}' uploaded to '#{s3_path}'."
end

folder_name = 'tmp'
# create tmp folder
create_folder_if_not_exists(folder_name)
# absolute_path = File.expand_path(folder_name)
# puts "PDF generate start : #{absolute_path}"
# generate PDF 
system("bundle exec asciidoctor-pdf -a pdf-fontsdir=templates/fonts -a pdf-themesdir=templates/themes -a pdf-theme=customised -o #{folder_name}/hourly.pdf templates/hourly.adoc")

# upload to S3 
bucket_name = 'bucket-name'
s3_key = 'destination/hourly.pdf' 
upload_file_to_s3(bucket_name, "#{folder_name}/hourly.pdf", s3_key)
s3_path = "s3://#{bucket_name}/#{s3_key}"

# delete folder
delete_directory(folder_name)
