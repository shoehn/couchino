require 'helper'

class TestCouchinoPusher < Test::Unit::TestCase

  context "macro plugin" do
    setup do
      @pusher = Couchino::Pusher.new(@test_app_dir)
      @sammy = File.read("#{@test_app_dir}/js/vendor/sammy-0.5.4.js")
      @views = "#{@test_app_dir}/db/views/"
      @pusher.push!
    end

    should "replace !code macros with file contents" do
      assert @pusher.document['views']['recent'].all?{|part| part[1].include?(@sammy)}
    end

    should "keep the original code" do
      parts = ['map','reduce'].inject({}){|res,part| res[part] = File.read("#{@views}/recent/#{part}.js").split("\n");res}
      parts.each do |part,lines|
        assert contain_lines(part,lines)
      end
    end

    should "be able to process views with map only" do
      lines  = File.read("#{@views}/only_map/map.js").split("\n")
      assert contain_lines('map',lines)
    end
  end

  def contain_lines(part,lines)
    lines.delete('  // !code js/vendor/sammy-0.5.4.js')
    lines.all? { |line| @pusher.document['views']['recent'][part].include?(line)}
  end

end
