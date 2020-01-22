require('pg')
require_relative('../db/sql_runner.rb')

class Album
  attr_accessor :id, :name, :genre, :artist_id

  def initialize(options)
    @id = options['id'].to_i if options['id']
    @name = options['name']
    @genre = options['genre']
    @artist_id  = options['artist_id'].to_i
  end


  def save()

    sql = "INSERT INTO albums
    ( name, genre, artist_id ) VALUES  (  $1, $2, $3)
    RETURNING id"
    values = [ @name, @genre, @artist_id]
    @id = SqlRunner.run(sql, values)
  end

  def self.delete_all()
    sql = "DELETE * FROM albums;"
    result = SqlRunner.run(sql)
  end

  def self.delete(id)
    sql = "DELETE FROM albums WHERE id = #{id}"
  SqlRunner.run(sql)
end

  def self.all()
    sql = "SELECT * FROM albums;"
    albums = SqlRunner.run(sql)
    return albums.map{|album| Album.new(album)}
  end

  def self.artist(name)
    sql = "SELECT * FROM albums INNER JOIN artists on artists.id = albums.artist_id WHERE albums.name = '#{name}'"
    results = SqlRunner.run(sql)
    artists = results.map{|artist| Artist.new(artist)}
    return artists
  end

  def self.find(id) # READ
    sql = "SELECT * FROM albums WHERE id = $1"
    values = [id]
    results_array = SqlRunner.run(sql, values)
    return nil if results_array.first() == nil
    album_hash = results_array[0]
    found_album = Album.new(album_hash)
    return found_album
  end

  def update(name, id) # UPDATE
    sql = "UPDATE albums SET name =  '#{name}'  WHERE id = #{id}"
    return  SqlRunner.run(sql)

  end

end
