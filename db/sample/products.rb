require 'find'
# make sure the product images directory exists
FileUtils.mkdir_p "#{Rails.root}/public/assets/products/"

# make product images available to the app
target = "#{Rails.root}/public/assets/products/"
source = "#{Rails.root}/lib/tasks/sample/products/"

Find.find(source) do |f|
  # omit hidden directories (SVN, etc.)
  if File.basename(f) =~ /^[.]/
    Find.prune
    next
  end

  src_path = source + f.sub(source, '')
  target_path = target + f.sub(source, '')

  if File.directory?(f)
    FileUtils.mkdir_p target_path
  else
    FileUtils.cp src_path, target_path
  end
end
