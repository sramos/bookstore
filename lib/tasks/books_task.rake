# encoding: UTF-8

require 'zip'

namespace :books do
  desc "Carga todos los libros de un path indicado"
  task parser: :environment do
    base_path = '/Volumes/videos/Libros'
    read_path base_path 
  end
end

def read_path folder 
  Dir.entries(folder).each do |item|
    fullname = File.join(folder, item)
    if File.directory?(fullname)
      read_path(fullname) unless item == "." || item == ".."
    else
      puts "Procesando: " + fullname
      if item =~/\.epub$/
        read_meta_epub fullname
      end
    end
  end
end

def read_meta_epub file
  meta = nil
  begin
    Zip::File.open(file) do |zf|
      container = Nokogiri::XML(zf.read("META-INF/container.xml")).remove_namespaces! if zf.find_entry("META-INF/container.xml")
      opf_file = container.xpath('//rootfile').first.attributes['full-path'].value if container
      meta = Nokogiri::XML(zf.read(opf_file)) if opf_file && zf.find_entry(opf_file)
      meta.remove_namespaces! if meta
      if meta
        # Pilla los datos basicos (identificativos) del libro
        puts "------> TITLE: " + meta.xpath('//title').text
        puts "------> DESCRIPTION: " + meta.xpath('//description').text
        authors = meta.xpath('//creator').to_a.collect {|c| c.text}
        puts "------> AUTHORS: " + authors.inspect
        # Pilla el resto de los datos
        puts "------> LANG: " + meta.xpath('//language').text
	puts "------> PUBLISHERS: " + meta.xpath('//publisher').to_a.collect {|c| c.text}.inspect
        cover_name = "cover-image"
        meta.xpath("//meta[@name='cover']").each do |meta_values|
          cover_name = meta_values.attributes["content"] if meta_values.attributes["name"].to_s == "cover"
        end
        cover = meta.xpath("//item[@id ='" + cover_name + "']").first if meta
        image = cover.attributes["href"].value if cover && cover.attributes["href"]
	puts "------> COVER: " + (File.dirname(opf_file) + "/" + image).gsub("./","")
        #File.open(covername(true), "wb") { |f| f.write(zf.read((File.dirname(opf_file) + "/" + image).gsub("./",""))) } if image
        #mybook.image_url = "/cover/" + digest if File.exists?(covername(true))
        #puts "---------------------> " + mybook.image_url
      end
    end
  rescue => e
    puts "*** ERROR #{e.class.name} : #{e.message}"
  end
end

