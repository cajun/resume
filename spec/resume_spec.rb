require File.join(File.dirname(__FILE__), '../lib/resume')

describe Resume do
  before(:each) do
    @empty = EmptyResume
    @resume = DummyResume
    @alternate = AlternateDummyResume
  end
  
  it "should do the simplest thing possible" do
    @resume.should_not be_nil
  end
  
  it "should have a name based on the class its included in" do
    @resume.my_name.should == "Dummy Resume"
  end
  
  it "should even do middle names and more" do
    @alternate.my_name.should == "Alternate Dummy Resume"
  end

  describe "schools" do
    it "should have no schools if there are none" do
      @empty.schools.should be_empty
    end

    it "should say its got no schools if there are none" do
      @empty.has_schools?.should be_false
    end

    it "should include a school if there is one" do
      @resume.schools.first[:name].should == "XYZU"
    end

    it "should say it has schools if it does" do
      @resume.has_schools?.should be_true
    end

    it "should include year if supplied" do
      @resume.schools.first[:graduated].should == "1999"
    end

    it "should include degree if supplied" do
      @resume.schools.first[:degree].should == "PHD"
    end
    
    it "should include curriculum if supplied" do
      @resume.schools.first[:curriculum].should == "Basket Weaving"
    end

    it "should have 1 school if said school is supplied" do
      @resume.schools.size == 1
    end
    
    it "should have 2 schools if said schools are supplied" do
      @alternate.schools.size == 2
    end
  end

  describe "jobs" do
    it "should have no jobs if there are none" do
      @empty.jobs.should be_empty
    end
    
    it "should say it has not jobs if there are none" do
      @empty.has_jobs?.should be_false
    end
    
    it "should include a job if there is one" do
      @resume.jobs.first[:company].should == "Acme, Inc."
    end
    
    it "should say it has jobs if there are some" do
      @resume.has_jobs?.should be_true
    end 
    
    it "should include a description if there is one" do
      @resume.jobs.first[:description].should == "bored out of skull"
    end
    
    it "should include a position if there is one" do
      @resume.jobs.first[:position].should == "Monkey"
    end
    
    it "should include a tenure if there is one" do
      @resume.jobs.first[:tenure].should == 2008
    end
  end
  
  describe "applications" do
    it "should have no applications if there are none" do
      @empty.applications.should be_empty
    end
    
    it "should say it has not apps if there are none" do
      @empty.has_applications?.should be_false
    end
    
    it "should have applications if there are some" do
      @resume.applications.should == ["foo.com", "bar.net", "baz.org"]
    end
    
    it "should say it has apps if there are some" do
      @resume.has_applications?.should be_true
    end
    
    it "should also add applications if there are multiples" do
      @alternate.applications.should == ["biz.gov", "buzz.biz"]
    end
  end

  describe "technologies" do
    it "should have no technologies if there are none" do
      @empty.technologies.should be_empty
    end
    
    it "should say it has no tech if there is none" do
      @empty.has_technologies?.should be_false
    end
    
    it "should have technologies if there are some" do
      @resume.technologies.should == ["countin", "readin", "spellin", "typin"]
    end

    it "should say it has tech if there is some" do
      @resume.has_technologies?.should be_true
    end

    
    it "should also add technologies if there are multiples" do
      @alternate.technologies.should == ["countin", "readin"]
    end    
  end
  
  describe "practices" do
    it "should have no practices if there are none" do
      @empty.practices.should be_empty
    end
    
    it "should say it has no practices if there is none" do
      @empty.has_practices?.should be_false
    end
    
    it "should have practices if there are some" do
      @resume.practices.should == ["law", "surgery", "juggling", "golf"]
    end
    
    it "should say it has practices if there are some" do
      @resume.has_practices?.should be_true
    end    
    
    it "should also add practices if there are multiples" do
      @alternate.practices.should == ["law", "surgery"]
    end    
  end  
  
  describe "contact" do
    it "should include email" do
      @resume.contact_info[:email].should == "foo@bar.com"
    end
   
    it "should say it has contact_info if there are some" do
      @resume.has_contact_info?.should be_true
    end

    it "should include phone" do
      @resume.contact_info[:phone].should == "800.444.3333"
    end
  end
  
  describe "story" do
    it "should include a story" do
      @resume.story_text.should == "some story that this resume has and it does too"
    end
    
    it "should say there is a story" do
      @resume.has_story?.should be_true
    end
    
    it "should not include a story if there isn't one" do
      @empty.story_text.should be_empty
    end
    
    it "should not say there is a story" do
      @empty.has_story?.should be_false
    end    
  end
  
  describe "pretty_print" do
    before(:each) do
      @print = ""
      @resume.pretty_print(@print)
      @alt_print = ""
      @alternate.pretty_print(@alt_print)
    end
    
    it "should have a line" do
      @resume.line.length.should == @resume.width
    end

    it "should use the name" do
      @print.should match(/Dummy Resume/)
    end
    
    it "should use with a line" do
      @print.should be_include(@resume.line)
    end
    
    it "should use the email" do
      @print.should match(/foo@bar.com/)
    end
  
    it "should use the phone" do
      @print.should match(/800.444.3333/)
    end
    
    it "should print schools out" do
      @alt_print.should match(/Bachelor's/)
      @alt_print.should match(/PHD/)
    end
    
    it "should print jobs" do
      @print.should match(/Acme, Inc./)
      @print.should match(/bored out of skull/)
      @print.should match(/Monkey/)
      @print.should match(/2008/)
    end
    
    it "should print websites" do
      @print.should match(/foo.com/)
      @print.should match(/bar.net/)
      @print.should match(/baz.org/)
    end
    
    it "should print the story" do
      @print.should match(/some story that this resume has and it does too/)
    end
  end
end

class EmptyResume
  include Resume
end

class DummyResume 
  include Resume
  contact :email => %w(foo bar com), :phone => %w(800 444 3333)
  attended "XYZU", :in => "Basket Weaving", :with => "PHD", :graduated => "1999"
  worked :at => "Acme, Inc.", :description => "bored out of skull", :position => "Monkey", :tenure => 2008
  built %w(foo.com bar.net baz.org)
  using %w(countin readin spellin typin)
  practicing %w(law surgery juggling golf)
  story %w(some story that this resume has and it does too)
end

class AlternateDummyResume
  include Resume
  attended "XYZU", :in => "Basket Weaving", :with => "Bachelor's", :graduated => "1908"
  attended "XYZU", :in => "Basket Weaving", :with => "PHD", :graduated => "1999"
  worked :at => "Acme, Inc.", :description => "bored out of skull", :position => "Monkey", :tenure => 2008
  worked :at => "Backnecorp", :description => "bored out of back", :position => "Picker", :tenure => 2004

  built "biz.gov"
  built "buzz.biz"
  using "countin"
  using "readin"
  practicing "law"
  practicing "surgery"
end

