class Ebook < ActiveRecord::Base
  require 'zip'
  belongs_to :book
  has_attached_file :ebook, url: '/:class/:id/download/:style.:extension',
                            path: ':rails_root/private/:class/:attachment/:id_partition/:style/:filename'

  validates_attachment_content_type :ebook, content_type: ["application/vnd.amazon.ebook",
							   "application/x-mobipocket-ebook",
							   "application/epub+zip",
                                                           "application/pdf", "text/plain"]
  validates :book_id, presence: true

  # Read epub ebook meta and update book info
  def read_epub_meta ebook_file=nil
    meta = nil
    mybook = self.book
    file = ebook_file
    begin
      Zip::File.open(file) do |zf|
        container = Nokogiri::XML(zf.read("META-INF/container.xml")).remove_namespaces! if zf.find_entry("META-INF/container.xml")
        opf_file = container.xpath('//rootfile').first.attributes['full-path'].value if container
        meta = Nokogiri::XML(zf.read(opf_file)) if opf_file && zf.find_entry(opf_file)
        meta.remove_namespaces! if meta
        if meta
          mybook ||= Book.new
          # Pilla los datos basicos (identificativos) del libro
          mybook.title = meta.xpath('//title').text
          mybook.description = meta.xpath('//description').text
          meta.xpath('//creator').to_a.each do |author|
            mybook.authors << Author.find_or_create_by(name: Author.get_name(author.text))
          end
	  meta.xpath('//subject').to_a.each do |genre|
            mybook.genres << Genre.find_or_create_by(name: Genre.get_name(genre.text))
	  end
          # Another book data 
	  #mybook.lang = meta.xpath('//language').text
          #puts "------> LANG: " + meta.xpath('//language').text
          #puts "------> PUBLISHERS: " + meta.xpath('//publisher').to_a.collect {|c| c.text}.inspect
          # Get book cover
          cover_name = "cover-image"
          meta.xpath("//meta[@name='cover']").each do |meta_values|
            cover_name = meta_values.attributes["content"] if meta_values.attributes["name"].to_s == "cover"
          end
          cover = meta.xpath("//item[@id ='" + cover_name + "']").first if meta
          image = cover.attributes["href"].value if cover && cover.attributes["href"]
          if image
            # Copy cover from epub
            tmp_cover = Tempfile.new("cover")
            File.open(tmp_cover, "wb") { |f| f.write(zf.read((File.dirname(opf_file) + "/" + image).gsub("./",""))) }
            # Upload cover to book
            mybook.cover = File.open(tmp_cover, 'rb')
          end
        end
      end
    rescue => e
      errors.add :base, "#{e.class.name} : #{e.message}"
    end
    return mybook
  end
end
