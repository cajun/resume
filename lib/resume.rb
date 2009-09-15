require 'rubygems'
require 'facets/ansicode'
module Resume

  def self.included(base)
      base.extend(ANSICode)
      base.extend(ClassMethods)
      (base.methods - Object.methods).each do |method|
        base.send(method, Array.new) if method =~ /=$/           
      end
      base.contact_info = Hash.new
      base.width = 80 # default width
  end

  module ClassMethods
    attr_accessor :contact_info, :schools, :jobs, :applications, :technologies, :practices, :width, :story_text
    
    def my_name
      self.to_s.gsub(/([A-Z]+)([A-Z][a-z])/,'\1 \2').gsub(/([a-z\d])([A-Z])/,'\1 \2')
    end
    
    def contact(opts = {}) 
      if(email = opts[:email])
        self.contact_info[:email] = email.is_a?(Array) ? email.to_email : (raise Exception.new('Please use an array to define your email address'))
      end

      if(phone = opts[:phone])
        self.contact_info[:phone] = phone.is_a?(Array) ? phone.to_phone : (raise Exception.new('Please use an array to define your phone number'))
      end

    end
    
    def story(story)
      self.story_text = story.join(" ")
    end

    # attended "XYZU", :in => "Basket Weaving", :with => "PHD", :graduated => "1999"
    def attended(school, opts = {})
      self.schools << {:name => school, :curriculum => opts[:in], :degree => opts[:with], :graduated => opts[:graduated]}
    end

    # worked :at => "Acme, Inc.", :description => "bored out of skull", :position => "Monkey", :tenure => 2008    
    def worked(opts = {})
      self.jobs << {:company => opts[:at], :description => opts[:description], :position => opts[:position], :tenure => opts[:tenure]}
    end
    
    {"built" => "applications", "using" => "technologies", "practicing" => "practices"}.each do |name, accessor|
      class_eval <<-EOV
        def #{name}(args)
          self.#{accessor} = self.#{accessor} + (args.is_a?(Array) ? args : [args])
        end
      EOV
    end
    
    def line(width = @width)
      "-".center(width, "-")
    end
    
    def pretty_print(out = $>, width = @width)
      print(my_name, out, width, :center)
      print_contact(out, width)
      print(line, out, width)
      print(line, out, width) if print_schools(out, width)
      print(line, out, width) if print_jobs(out, width)
      print(line, out, width) if print_array(applications, "Sites", out, width)
      print(line, out, width) if print_array(technologies, "Technologies", out, width)
      print(line, out, width) if print_array(practices, "Practices", out, width)
      print(story_text, out, width)
      out << "\n"
    end
    
    def has_contact_info?
      !contact_info[:email].nil? or !contact_info[:phone].nil?
    end
    
    def has_story?
      self.story_text and !self.story_text.empty?
    end
    
    %w(schools jobs applications technologies practices story_).each do |name|
      class_eval <<-EOV
        def has_#{name}?
          self.#{name} and !self.#{name}.empty?
        end
      EOV
    end
    
    def print_contact(out = "", width = @width)
      row = ""
      row << contact_info[:email] if contact_info[:email]
      row << "   " if contact_info[:email] and contact_info[:phone]
      row << contact_info[:phone] if contact_info[:phone]
      print(row, out, width, :center) 
    end
    
    def print_schools(out = "", width = @width)
      schools.collect { |s|
        row = ""
        row << "Attended #{s[:name]}" if s[:name]
        row << " #{s[:curriculum]}" if s[:curriculum]
        row << " for #{s[:degree]}" if s[:degree]
        row << "; Graduated #{s[:graduated]}" if s[:graduated]
        print(row, out, width, :right) 
      }.join("\n")
    end
    
    def print_jobs(out = "", width = @width)
      jobs.collect { |j|
        row = ""
        row << "Worked at #{j[:company]}" if j[:company]
        row << " as a #{j[:position]}" if j[:position]
        row << " (#{j[:tenure]})" if j[:tenure]
        result = print(row, out, width, :right)
        result += "\n     " + print(j[:description], out, width) if j[:description]
      }.join("\n\n")
    end
    
    def print_array(array, title = "", out = "", width = @width)
      unless(array.empty?)
        print(title, out, width, :right)
        print(array.join(" - "), out, width) 
      end
    end    
    
    def print(str, out, width, justify = :left)
      if(str.length > width)
        i = str.rindex(' ', width)
        print(str[0, i], out, width, justify) + ' ' +print(str[i+1, str.length], out, width, justify)
      elsif(!str.empty?)
        line = str.justify(width, justify)
        out << "\n#{line}"
        line.strip
      end
    end
  end
end

class String
  def justify(width, justify)
    case justify
    when :center: center(width)
    when :left: ljust(width)
    when :right: rjust(width)
    end
  end
end

class Array
  def to_email
    "#{self.first}@#{self[1,size].join('.')}"
  end
  
  def to_phone(delimiter = ".")
    self.join(delimiter)
  end
end