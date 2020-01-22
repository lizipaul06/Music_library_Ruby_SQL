require("pry")
require_relative("../models/album.rb")
require_relative("../models/artist.rb")


artist1 = Artist.new({'name' => 'Britney'})
artist1.save()


album1 = Album.new({
 'artist_id' => artist1.id,
 'name' => 'Baby One More Time',
 'genre' => 'pop',
  })


album1.save()

artist1.artist()

binding.pry
nil
