require 'rubygems'
require 'gosu'
require './input_functions'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)

module ZOrder
  BACKGROUND, PLAYER, UI = *0..2
end

module Genre
  POP, CLASSIC, JAZZ, ROCK = *1..4
end

$GENRE_NAMES = ['Pop', 'Classic', 'Jazz', 'Rock']

class Album
    # NB: you will need to add tracks to the following and the initialize()
    attr_accessor :title, :artist, :genre, :songs
  
    def initialize (title, artist, genre, songs)
        # insert lines here
        @title = title
        @artist = artist
        @genre = genre
        @songs = songs
    end
end

class Song
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

#Takes in a music file and reads in how many albums there are and populates the albums information
def readAlbums(a_musicFile)

    File.open(a_musicFile)

    _numOfAlbums = Array.new(a_musicFile.gets.chomp().to_i)

    @_albums = Array.new

    index = 0
    while index < _numOfAlbums.length

    _albumArtist = a_musicFile.gets.chomp()
    _albumTitle = a_musicFile.gets.chomp()
    _albumGenre = a_musicFile.gets.chomp()

    songs = readSongs(a_musicFile)

    _album = Album.new(_albumTitle, _albumArtist, _albumGenre, songs)

    @_albums << _album

    index += 1
    end

    readSong(a_musicFile)

    return @albums
end

def albumSelection(a_album)

  puts("Please select which Album you would like to see!")

  index = 0
  while index < a_album.length

  puts("#{index} - #{a_album[index].title} by #{a_album[index].artist}")

  index += 1

  end

  _albumSelection = read_integer_in_range("Option Selection: ", 0, 4)

  return _albumSelection

end

#Takes in the Music File and reads the song into an array of Songs
def readSongs(a_musicFile)

  _count = a_musicFile.gets.chomp()
  _songs = Array.new

  index = 0
  while index < _count.to_i
      _song = readSong(a_musicFile)
      _songs << _song
      index += 1
  end

  return _songs
end

#Reads in a singular song from the music file and assigns its name and location
def readSong(a_musicFile)

  _songName = a_musicFile.gets.chomp()
  _songLocation = a_musicFile.gets.chomp()

  song = Song.new(_songName, _songLocation)

  return song
end

#Prints out the Albums information
def printAlbums(a_index)

  puts("Album Information:")
  puts("Album ID - #{a_index}")
  puts("Album Title - #{@_albums[a_index].title} ")
  puts("Album Artist - #{@_albums[a_index].artist} ")
  #puts("Genre - #{$genreNames[@_albums[a_index].genre.to_i]}")
  printSongs(@_albums[a_index].songs)

end

#Prints out the Songs information
def printSongs(a_songs)

  puts("Album Songs:")
  index = 0
  while index < a_songs.length
  puts("Song #{index} - " + a_songs[index].name)
  index += 1
  end

end

#Displays the sub-menu for the albums
def displayAlbumsInfo(a_album)

  #_terminated = false

  #begin

  #puts("1 - Display full Album")
  #puts("2 - Display album Songs")
  #puts("3 - Display album Genre")
  #puts("4 - Exit")

  #_selection = read_integer_in_range("Option Selection: ", 1, 4)

  #case _selection
  #when 1
  #printAlbums(albumSelection(a_album))
  printAlbums(0)
  #when 2
  #printSongs(a_album[songSelection(a_album)].songs)
  #when 3
  #printGenre(a_album[genreSelection(a_album)])
  #when 4
  #_terminated = true
  #end
  #end until _terminated

end

class ArtWork
	attr_accessor :img

	def initialize (file)
		@img = Gosu::Image.new(file)
	end
end

def numberofSongs(a_album)

  #index = 0
  #while index < a_album.songs.length
    #index += 1
  #end 

  #return index
end

# Put your record definitions here
class MusicPlayerMain < Gosu::Window

	def initialize
      @WIDTH = 720
      @HEIGHT = 1080
	    super(@WIDTH, @HEIGHT, false)
	    self.caption = "Music Player"


    @_selectionSquare = Gosu::Color::WHITE

		# Reads in an array of albums from a file and then prints all the albums in the
    @_musicFile = File.new("albums/albums.txt", "r")

    readAlbums(@_musicFile)

    #Text Images
    @_songText = Gosu::Font.new(self, "Song", 20)

    # array to the terminal
    #displayAlbumsInfo(@_albums)

    #Album Cover Image
    @_coverImage = ArtWork.new("albums/cover/Neil_Diamond_Greatest_Hits_Cover.jpg")

    @info_font = Gosu::Font.new(50)
	end

  # Put in your code here to load albums and tracks
  # Draws the artwork on the screen for all the albums
  def draw_albums(albums)
    # complete this code

    @_coverImage.img.draw(15, 45, ZOrder::BACKGROUND, 1, 1)

    drawSongs(@_albums[0].songs)

  end

  def drawSongs(a_songs)

    Gosu::Font.new(self, "Song 1", 20)

    _songsText = Array.new()
    _songsText << a_songs

    index = 0
    while index < a_songs.length
      _songsText[index] = Gosu::Font.new(self, "Song - #{index}", 30)
      _songsText[index].draw_text("#{a_songs[index].name}", 450, 50 + index * 60, ZOrder::UI, 1.0, 1.0, Gosu::Color::GREEN)
      index += 1
    end

  end

  # Takes a String title and an Integer ypos
  # You may want to use the following:
  def display_track(title, ypos)
  	@track_font.draw(title, TrackLeftX, ypos, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::BLACK)
  end


  # Takes a track index and an Album and plays the Track from the Album
  def playTrack(track, album)
  	 # complete the missing code
  			@song = Gosu::Song.new(album.tracks[track].location)
  			@song.play(false)
    # Uncomment the following and indent correctly:
  	#	end
  	# end
  end

# Draw a coloured background using TOP_COLOR and BOTTOM_COLOR

	def draw_background
    #Top Background
    Gosu.draw_rect(0, 0, @WIDTH, 30, TOP_COLOR, ZOrder::BACKGROUND, mode=:default)

    #Bottom Background
    Gosu.draw_rect(0, 30, @WIDTH, @HEIGHT, BOTTOM_COLOR, ZOrder::BACKGROUND, mode=:default)

    #Right Background
    Gosu.draw_rect(@WIDTH - 30, 0, @WIDTH, @HEIGHT, TOP_COLOR, ZOrder::BACKGROUND, mode=:default)

    if mouseOverSelection(mouse_x, mouse_y)
      Gosu.draw_rect(500, 500, @WIDTH, 200, @_selectionSquare, ZOrder::BACKGROUND, mode=:default)
    end
	end

# Not used? Everything depends on mouse actions.

	def update
	end

 # Draws the album images and the track list for the selected album
	def draw

    @info_font.draw_text("mouse_x: #{mouse_x}", 0, 500, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
    # Draw the mouse_y position
    @info_font.draw_text("mouse_y: #{mouse_y}", 0, 700, ZOrder::UI, 1.0, 1.0, Gosu::Color::RED)
		# Complete the missing code
		draw_background
    draw_albums(@albums)
	end

 	def needs_cursor?; true; end

  # Detects if a 'mouse sensitive' area has been clicked on
  # i.e either an album or a track. returns true or false

  def area_clicked(leftX, topY, rightX, bottomY)
    # complete this code
  end

  def mouseOverSelection(mouse_x, mouse_y)

    if ((mouse_x > 50 and mouse_x < 150) and (mouse_y > 50 and mouse_y < 100))
      true
    else
      false
    end

  end

	def button_down(id)
		case id
	    when Gosu::MsLeft
	    	# What should happen here?
        if mouseOverSelection(mouse_x, mouse_y)
          @_selectionSquare = Gosu::Color::YELLOW
        else
          @_selectionSquare = Gosu::Color::WHITE
        end
      when Gosu::KB_ESCAPE
      close
      end
	end

end

# Show is a method that loops through update and draw
MusicPlayerMain.new.show if __FILE__ == $0