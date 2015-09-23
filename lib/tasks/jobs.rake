require 'open-uri'
require 'active_support'

class Nokogiri::XML::Node
  # Naive implementation; assumes found elements will share the same parent
  def content_between( start_xpath, stop_xpath=nil )
    node = at_xpath(start_xpath).next_element
    stop = stop_xpath && at_xpath(stop_xpath)
    [].tap do |content|
      while node && node!=stop
        content << node
        node = node.next_element
      end
    end
  end
end


namespace :jobs do

  desc "get jobs information from ruby Taiwan"
  task sync_rubytw: :environment do
    job_array = []

    doc = Nokogiri::HTML(open("http://jobs.ruby.tw/"))

    doc.css('.joblist').css('tbody').css('tr').css('a').each do |job|
      web_address = "http://jobs.ruby.tw#{job['href']}"
      job_array << web_address
    end
    # job = job_array.first
    job_array.reverse.last(3).each do | job |
      job_page = Nokogiri::HTML(open(job))

      jobfield_count = job_page.css('.field').count

      type          = job_page.css('.field')[0].try(:children).try(:last).text.strip
      company_name  = job_page.css('.field')[2].try(:children).try(:last).text.strip
      location      = job_page.css('.field')[3].try(:children).try(:last).text.strip
      
      if jobfield_count == 6
        company_url   = job_page.css('.field')[4].css("a").attr('href') 
      else
        company_url   = "#"
      end

      title         = job_page.css('.jobtitle').text
      apply_info    = job_page.css('.apply-information').css('.description').text

      if type == "Full-time"
        job_type = "Full-time"
      elsif type == "Part-time"
        job_type = "Part-time"
      elsif type == "Internship"
        job_type = "Internship"
      else
        job_type = "Other"
      end

      salary_high   = 0
      salary_low    = 0
      description   = job_page.css('.description').text

      params = {
        title:title,job_type:job_type,
        location:location,salary_high:salary_high,salary_low:salary_low,
        company_name:company_name,company_url:company_url,description: description,
        from:"Ruby Jobs in Taiwan" ,from_url:job,
        apply_info:apply_info ,begginer:false,user_id:1
      }
      # puts params[:company_url]
      puts title
      Job.create(params)
    end
  end


  desc "get jobs information from Inside Job Board"
  task sync_inside: :environment do
    job_array = []

    doc = Nokogiri::HTML(open("https://jobs.inside.com.tw/jobs/index?c=&k=rails+ruby&p=1"))
    jobInfoArea = doc.css('.list-group')[0]

    jobInfoArea.css('a').css('.list-group-item').each do |d|
      job_array << d['href']
    end

    job_array.reverse.each do | job |
      job_page = Nokogiri::HTML(open(job))
      body = job_page.css('div').css('.panel-body')

      company_name  = job_page.css('h1').css('.panel-title').text
      company_url   = body.css('p')[0].css('a').text.gsub(' ','')
      title         = body.css('h1')[0].text.split("\n")[1]
      type          = body.css('h1')[0].text.split("\n")[2]

      if type == "全職"
        job_type = "Full-time"
      elsif type == "兼職"
        job_type = "Part-time"
      elsif type == "實習"
        job_type = "Internship"
      else
        job_type = "Other"
      end

      location      = body.css('.row').css('p')[1].text.split("：").last
      date          = body.css('.row').css('p')[3].text.split("：").last
      p_date = Date.parse(date) 

      salary        = body.css('.row').css('p')[2].text.split("：").last.to_s.split(" ")
      salary_high   = salary[4].gsub(/\D/,'').to_i
      salary_low    = salary[1].gsub(/\D/,'').to_i
      description   = job_page.content_between('//hr[2]','//a[@name="apply"]').map { |e| e.to_s.gsub("\n"," ") }
      des   = description.join("\r\n")
      # puts description
      params = {
        title:title,job_type:job_type,
        location:location,salary_high:salary_high,salary_low:salary_low,
        company_name:company_name,company_url:company_url,description:des,
        from:"Inside Jobs" ,from_url:job,
        apply_info:nil,begginer:false,user_id:1
      }
      puts title
      Job.create(params)
    end

  end
end
