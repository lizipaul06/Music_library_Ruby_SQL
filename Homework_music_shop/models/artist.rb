require('pg')
require_relative('../db/sql_runner.rb')



class Artist

  attr_accessor :name, :id

  def initialize(options)
    @name = options['name']
    @id = options['id'].to_i if options['id']
  end

  def save()

    sql = "INSERT INTO artists( name) VALUES  ($1)  RETURNING id"
    values = [ @name]
    result = SqlRunner.run(sql, values)
    @id = result[0]["id"].to_i
  end

  def self.delete_all()
    sql = "DELETE FROM artists;"
    result = SqlRunner.run(sql)
  end

  def self.all()
    sql = "SELECT * FROM artists;"
    artists = SqlRunner.run(sql)
    return artists.map{|artist| Artist.new(artist)}
  end

  def artist()
    sql = "SELECT * FROM artists WHERE id = $1"
    values = [@id]
    results = SqlRunner.run(sql, values)
    artist_data = results.first
    artist = Artist.new(artist_data)
    return artist
  end

  def self.albums(name)
    sql = "SELECT * FROM artists INNER JOIN albums on artists.id = albums.artist_id WHERE artists.name = '#{name}'"
    results = SqlRunner.run(sql)
    albums = results.map{|album| Album.new(album)}
    return albums
  end

  def update(name, id) # UPDATE
    sql = "UPDATE artists SET name =  '#{name}'  WHERE id = #{id}"
  return  SqlRunner.run(sql)

  end

  def Artist.find(id) # READ
        sql = "SELECT * FROM artists WHERE id = $1"
        values = [id]
        results_array = SqlRunner.run(sql, values)
        return nil if results_array.first() == nil
        artist_hash = results_array[0]
        found_artist = Artist.new(artist_hash)
        return found_artist
      end

      def self.delete(id)
        sql = "DELETE FROM artists WHERE id = #{id}"
      SqlRunner.run(sql)
    end

end
