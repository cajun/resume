require 'rubygems'
require 'prawn'
require 'prawn/layout' 

class PDFPrinter
  attr_accessor :resume
  
  def initialize(resume)
    self.resume = resume
  end
  
  def filename
    "#{self.resume.name}.pdf"
  end
      
  def print
    resume = self.resume
    Prawn::Document.generate filename do
      font "Helvetica"
      header margin_box.top_left do
        text resume.my_name, :align => :center, :size => 32
        text resume.print_contact, :align => :center
        stroke_horizontal_rule
      end
      move_down(50)
      if(resume.has_schools?)
        text "Education", :align => :right, :style => :bold_italic
        text resume.print_schools, :align => :left
        stroke_horizontal_rule
      end
      if(resume.has_jobs?)
        text "Employment", :align => :right, :style => :bold_italic
        text resume.print_jobs, :align => :left
        stroke_horizontal_rule
      end
      
      if(resume.has_applications?)
        text "Sites", :align => :right, :style => :bold_italic
        text resume.print_array(resume.applications), :align => :center
        stroke_horizontal_rule
      end
      
      if(resume.has_technologies?)
        text "Technologies", :align => :right, :style => :bold_italic
        text resume.print_array(resume.technologies), :align => :center
        stroke_horizontal_rule
      end
      
      if(resume.has_practices?)
        text "Practices", :align => :right, :style => :bold_italic
        text resume.print_array(resume.practices), :align => :center
        stroke_horizontal_rule
      end
      
      if(resume.has_story?)
        text resume.story_text
      end
      
      footer margin_box.bottom_left do
        font "Courier"
        fill_color "999999"
        
        text "gem install resume; resume #{$*}", :align => :center, :size => 8
      end
    end    
  end
end