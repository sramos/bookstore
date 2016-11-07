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
      if item =~/\.epub$/
        ebook = Ebook.new()
        book = ebook.read_epub_meta(fullname)
        if book && book.save
	  ebook.book_id = book.id
	  ebook.ebook = File.open(fullname, 'rb')
          ebook.save
          puts "------> ERROR: Error guardando ebook: " + ebook.errors.inspect unless ebook.errors.empty?
        else
	  puts "------> ERROR: Error leyendo ebook: " + ebook.errors.inspect unless ebook.errors.empty?
	  puts "------> ERROR: Error generando book: " + book.errors.inspect unless book.nil? || book.errors.empty?
          puts "------> No se obtuvo ninguna info del ebook" unless book
        end
      end
    end
  end
end
