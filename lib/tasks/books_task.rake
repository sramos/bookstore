# encoding: UTF-8

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
      read_epub fullname if item =~ /\.epub$/
    end
  end
end

def read_epub file
  book = EPUB::Parser.parse(file)
  puts "------> TITLE: " + book.metadata.title
  puts "------> LANG: " + book.metadata.languages.first.content
  puts "------> AUTHORS: " + book.metadata.creators.collect{|c| c.content}.inspect
  puts "------> DESCRIPTION: " + book.metadata.description
  puts "------> PUBLISHERS: " + book.metadata.publishers.collect{|p| p.content}.inspect
  #puts "------> META: " + book.metadata.inspect
end
