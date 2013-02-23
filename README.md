# LAME Encoder Wrapper for Ruby

This is a copy of some old code for calling LAME from Ruby. The
original code is at http://lame-encoder.rubyforge.org/. I have made
some minor alterations, but all credit goes to the original
developers. Here's their description:

The Lame Encoder allows you to convert between mp3, ogg, wav, and aiff
files from the command line. You can also recode mp3s at different
bitrates, convert audio files to mono, and much more. This wrapper
allows you to control Lame from within your Ruby apps, with clear
methods to set the options. It should be refactorable and learnable,
due to it’s strong suite of rspec specifications.


## Original Code

The latest version will always be available in svn -

svn checkout svn://rubyforge.org//var/svn/lame-encoder
or of course you can grab the gem

sudo gem install lame_encoder
Visit the project’s RubyForge page for more options.

## History

The LAME (LAME Ain’t an Mp3 Encoder) Encoder has been around for a few
years, and I used it back in the PHP days to give Music For Dozens the
ability to transcode MP3 uploads to lower bitrates.


Now with this new Ruby wrapper, we can all use Lame in our projects.

The idea to build the wrapper came out of the Argon Express trip to
RailsConf, where Jeremy Voorhis and I decided to extend his
asset_compiler to work with audio as well. Before we could do that, we
needed an audio equivalent of RMagick. Hence the wrapper for Lame.


## Usage

TODO: Write usage instructions here

