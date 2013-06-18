#encoding: utf-8
require 'selenium-webdriver'
require 'watir-webdriver' 
require 'headless'


module Browser
    def browser name = :firefox
        return @browser if @browser

		if name == :ie or name == :internet_explorer
			#I'm hardcoding version for this sample
			caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer(:version => '8')
        	@browser = Watir::Browser.new :remote, :url => 'http://[ip]:4444/wd/hub' , :desired_capabilities => caps
		else
			@headless = Headless.new
			@headless.start
			@browser = Watir::Browser.new name.to_s
		end
    end
    def frame index = 1
        return self.browser.frame(:index => index).body
    end
    def on_screen? strings
        strings = [ strings ] if strings.class == String
        puts self.browser.text
        strings.each do |string|
            return false unless self.browser.text.include? string
        end
        return true
    end
    def close
        @browser.close
        @headless.destroy if @headless
        return true
    end
end

class Sample_IE
	include Browser
end

class Sample_FF
	include Browser
end
t = SAMPLE_IE.new
t.browser(:ie).goto 'http://google.com'
puts t.browser.html

t = SAMPLE_FF.new
t.browser.goto 'http://google.com'
puts t.browser.html
