require "spec_helper"

describe String do
  describe "#colorize" do

    # unprivatzie colorize
    class String
      def _colorize(color_code)
        self.send(:colorize, color_code)
      end
    end

    it "should print the proper control sequence introducer" do
      string = "foo"
      string._colorize(31).split(string).each do |e|
        e[0].should  == "\e"
        e[1].should  == "["
        e[-1].should == "m"
      end
    end

    it "should contain the original string" do
      string = "this a a pretty great string.\nwith a newline too!"
      string._colorize(30).include? string
    end

  end
end