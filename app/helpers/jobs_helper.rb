module JobsHelper
  def type_label_selector(type)
    case type
    when "Full-time"
      content_tag( :div, "Full-time", :class=>"job-label full-time")
    when "Part-time"
      content_tag( :div, "Part-time", :class=>"job-label part-time")
    when "Intership"
      content_tag( :div, "Internship", :class=>"job-label internship")
    when "Internship"
      content_tag( :div, "Internship", :class=>"job-label internship")
    when "Other"
      content_tag( :div, "Other", :class=>"job-label other")
    end
    
  end
end
