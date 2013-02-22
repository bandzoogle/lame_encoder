require 'spec_helper'

def has_lame?
  `which lame` != ""
end

describe Lame::Encoder do
  context "created" do
    before(:each) do
      @la = Lame::Encoder.new
    end
    
    specify "has a blank argument list" do
      @la.argument_list.should be_empty
    end
    
    specify "records valid bitrates" do
      @la.bitrate 128
      @la.options[:bitrate].should eql "-b 128"
    end

    specify "records valid sample rate" do
      @la.sample_rate 44.1
      @la.options[:sample_rate].should eql "--resample 44.1"
    end

    specify "records valid VBR quality" do
      @la.vbr_quality 5
      @la.options[:vbr_quality].should eql "-V 5"
      @la.options[:vbr].should eql "-v"
    end

    specify "records valid quality" do
      @la.encode_quality 1
      @la.options[:encode_quality].should eql "-q 1"
    end

    specify "records valid quality" do
      @la.encode_quality 5
      @la.options[:encode_quality].should eql "-q 5"
    end

    specify "records valid quality shortcut" do
      @la.encode_quality :high
      @la.options[:encode_quality].should eql "-q 2"
      @la.encode_quality :fast
      @la.options[:encode_quality].should eql "-q 7"
    end

    specify "balks at invalid bitrate" do
      lambda {@la.bitrate 113}.should raise_error ArgumentError
    end

    specify "balks at invalid sample rate" do
      lambda {@la.sample_rate 113}.should raise_error ArgumentError
    end

    specify "balks at invalid VBR quality" do
      lambda {@la.vbr_quality 113}.should raise_error ArgumentError
    end

    specify "balks at invalid encode quality" do
      lambda {@la.encode_quality 113}.should raise_error ArgumentError
    end

    specify "sets mode to stereo or mono" do
      {:stereo => '-m s', :mono => '-m m', :joint => '-m j'}.each do |option, setting|
        @la.mode option
        @la.options[:mode].should eql setting
      end
    end

    specify "sets mode to nil on bad option" do
      @la.mode :bugz
      @la.options[:mode].should be nil
    end

    specify "decodes mp3s" do
      @la.decode_mp3!
      @la.options[:decode_mp3].should eql "--decode"
    end

    specify "decodes mp3s without other options" do
      @la.vbr_quality 4
      @la.decode_mp3!
      @la.options.length.should eql 1
    end

    specify "accepts flag that input is mp3" do
      @la.input_mp3!
      @la.options[:input_mp3].should eql "--mp3input"
    end

    specify "accepts an input filename" do
      @la.input_file "/Path/to/my/audio_file.wav"
      @la.command_line.should eql "lame /Path/to/my/audio_file.wav 2>&1"
    end

    specify "accepts replygain options" do
      {:accurate => "--replaygain-accurate",
        :fast => "--replaygain-fast",
        :none => "--noreplaygain",
        :clip_detect => "--clipdetect",
        :default => nil
      }.each do |option, setting|
        @la.replay_gain option
        @la.options[:replay_gain].should eql setting
      end
    end

    specify "accepts raw PCM files" do
      @la.input_raw 44.1
      @la.options[:input_raw].should eql "-r -s 44.1"
      @la.input_raw 32, true
      @la.options[:input_raw].should eql "-r -s 32 -x"
    end

    specify "marks as copy when requested" do
      @la.mark_as_copy!
      @la.options[:copy].should eql "-o"
    end
    specify "marks as copy when starting from a file ending in .mp3" do
      @la.input_file "/Path/to/my/audio_file.mp3"
      @la.options[:copy].should eql "-o"
    end
    specify "marks as copy when starting from an mp3 file" do
      @la.input_mp3!
      @la.options[:copy].should eql "-o"
    end
    specify "does not mark as copy when starting from a file not ending in .mp3" do
      @la.input_file "/Path/to/my/audio_file.aif"
      @la.options[:copy].should be_nil
    end

    specify "outputs ogg files when requested" do
      @la.output_ogg!
      @la.options[:output_ogg].should eql "--ogg"
    end
  end

  context "A high-quality VBR encoder without a file" do
    before(:each) do
      @la = Lame::Encoder.new
      @la.vbr_quality 4
      @la.sample_rate 44.1
    end

    specify "ouputs the correct command line options" do
      [ /-v/,/-V 4/,/--resample 44\.1/].each do |match|
        @la.argument_list.should match match
      end
    end

    specify "balks at returning the command line" do
      lambda {@la.command_line}.should raise_error ArgumentError
    end

    specify "balks at running the conversion" do
      lambda {@la.convert!}.should raise_error ArgumentError
    end

  end

  describe "An encoder with a file specified" do

    before(:each) do
      @la = Lame::Encoder.new
      @la.input_file "/Path/to/my/audio_file.wav"
    end

    specify "provides the right command line" do
      @la.command_line.should eql "lame /Path/to/my/audio_file.wav 2>&1"
    end

  end

  describe "An encoder with options and an input and output file specified" do

    before(:each) do
      @la = Lame::Encoder.new
      @la.encode_quality :high
      @la.input_file "/Path/to/my/audio_file.wav"
      @la.output_file "/Path/to/my/audio_file.mp3"
    end

    specify "provides the right command line" do
      @la.command_line.should eql "lame -q 2 /Path/to/my/audio_file.wav /Path/to/my/audio_file.mp3 2>&1"
    end

  end

  describe "An encoder sent various id3 information" do

    before(:each) do
      @la = Lame::Encoder.new
    end

    specify "sets the title" do
      @la.id3 :title => "The All-Knowning Mind of Minolta"
      @la.id3_options[:title].should eql "The All-Knowning Mind of Minolta"
      @la.id3_arguments.should eql "--tt The All-Knowning Mind of Minolta"
    end

    specify "sets multiple values" do
      @la.id3 :title => "The All-Knowning Mind of Minolta"
      @la.id3 :artist => "Tin Man Shuffler"
      @la.id3_options[:title].should eql "The All-Knowning Mind of Minolta"
      @la.id3_options[:artist].should eql "Tin Man Shuffler"
      @la.id3_arguments.should match /--tt The All-Knowning Mind of Minolta/
      @la.id3_arguments.should match /--ta Tin Man Shuffler/
    end

    specify "sets title, artist, album, year, comment, track number, and genre" do
      @la.id3 :title => 'title', :artist => 'artist', :album => 'album',
      :year => 1998, :comment => 'comment', :track_number => 1,
      :genre => 'genre'
      [/--tt title/,/--ta artist/, /--tl album/,/--ty 1998/,/--tc comment/,/--tn 1/,/--tg genre/].each do |match|
        @la.id3_arguments.should match match
      end
    end

    specify "ignores nonsense values" do
      @la.id3 :bugz => "Not Real"
      @la.id3_arguments.should_not match /Real/
      @la.id3 :title => "Coolbeans"
      @la.id3_arguments.should match /Coolbeans/
    end

    specify "adds v1 or v2 id3 tags as requested" do
      2.times do |n|
        @la.id3_version_only n
        @la.options[:id3_version].should eql "--id3v#{n}-only"
      end
    end

    specify "allows adding v2 tags on top of default behaviour" do
      @la.id3_add_v2!
      @la.options[:id3_version].should eql "--add-id3v2"
    end

    specify "does not output id3_version unless tags are set" do
      @la.id3_version_only 1
      @la.argument_list.should eql ""
    end

    context "An encoder with id3 options and an input file" do
      before(:each) do
        @la = Lame::Encoder.new
        @la.id3 :title => 'title', :artist => 'artist', :album => 'album',
        :year => 1998, :comment => 'comment', :track_number => 1,
        :genre => 'genre'

        @input = File.join( File.dirname( __FILE__ ), 'track.mp3' )
        @la.input_file @input
      end

      specify "outputs those options to the command line" do
        [/--tt title/,/--ta artist/, /--tl album/,/--ty 1998/,/--tc comment/,/--tn 1/,/--tg genre/].each do |match|
          @la.command_line.should match match
        end
      end
    end

    context "An encoder starting with an mp3 file" do
      before(:each) do
        @output = "#{Tempfile.new("lame-mp3").path}.mp3"

        if File.exist?(@output)
          File.delete @output
        end

        @la = Lame::Encoder.new
        @input = File.join( File.dirname( __FILE__ ), 'track.mp3' )
        @la.input_file @input
        @la.output_file @output
        @la.input_mp3!
      end

      specify "provides the right command line" do
        ['lame','--mp3input', '-o','track.mp3',@output].each do |match|
          @la.command_line.should include match
        end
      end

      if has_lame?
        specify "successfully outputs a low bitrate version" do
          @la.bitrate 32
          @la.mode :mono

          File.should_not exist @output
          
          @la.convert!
          File.should exist @output
        end
      else
        pending "LAME not installed, skipping output test"
      end
    end

    # context "The runtime environment" do
    #   specify "should have lame version 3.98 installed" do
    #     version = `lame --help`
    #     version.should match /LAME/
    #     version.should match /3\.98/
    #   end
    # end

  end
end
