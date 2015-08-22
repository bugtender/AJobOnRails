require 'open-uri'

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
  desc "get jobs information from other website"
  task sync_inside: :environment do
    job_array = []

    doc = Nokogiri::HTML(open("https://jobs.inside.com.tw/jobs/index?c=&k=rails+ruby&p=1"))
    jobInfoArea = doc.css('.list-group')[0]

    jobInfoArea.css('a').css('.list-group-item').each do |d|
      job_array << d['href']
    end

    job_array.each do | job |
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
        job_type = "Intership"
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
      puts description
      params = {
        title:title,description:des,job_type:job_type,
        location:location,salary_high:salary_high,salary_low:salary_low,
        company_name:company_name,company_url:company_url,
        apply_info:nil,begginer:false,user_id:1
      }
      puts params
      Job.create(params)
    end

  end
end
