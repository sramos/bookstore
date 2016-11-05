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
  begin
    book = EPUB::Parser.parse(file)
    puts "------> TITLE: " + book.metadata.title
    puts "------> ISBN: " + book.metadata.identifiers.select{|i| i.scheme == "ISBN"}.collect{|i| i.content}.join(", ") 
    puts "------> LANG: " + book.metadata.languages.collect{|l| l.content}.join(", ")
    puts "------> AUTHORS: " + book.metadata.creators.collect{|c| c.content}.inspect
    puts "------> SUBJECTS: " + book.metadata.subjects.collect{|s| s.content}.inspect
    puts "------> DESCRIPTION: " + book.metadata.description
    puts "------> PUBLISHERS: " + book.metadata.publishers.collect{|p| p.content}.inspect
    puts "**************** TENEMOS COVER!!!: " + book.metadata.coverages.inspect unless book.metadata.coverages.blank?
    #puts "------> META: " + book.metadata.inspect
  rescue Archive::Zip::EntryError => e
    puts "*** ERROR #{e.class.name} : #{e.message}" 
  end
end
