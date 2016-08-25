module ApplicationHelper

  def render_as_link options={}
    options[:document] # the original document
    options[:field] # the field to render
    options[:value] # the value of the field

    links = []
    options[:value].each {  |link|
      links.append(link_to "#{link}", "#{link}")
    }

    links.join('<br/>').html_safe
  end


  def render_citation options={}
    citations = []
    options[:value].each {  |citation|
      citations.append("<p>" + citation + "</p>")
    }
    citations.join(' ').html_safe
  end

  def render_search_per_line options={}
    options[:value].each {  |link|
      links.append(link_to "#{link}", "#{link}")
    }
    links.join('<br/>').html_safe
  end

  def cds_info_url(id)
    cds = Rails.application.config_for(:cds)
    "http://#{cds['host']}/info/repository/YCBA/object/#{id}/type/2"
  end

  def display_rights(document)
    rights_text = document['rights_txt']
    rights_text = rights_text[0] if rights_text
    rights_text ||= 'Unknown'
    rights_statement_url = document['rightsURL_ss']
    rights_statement_url = rights_statement_url[0] if rights_statement_url

    if rights_text
        if rights_statement_url
          html = link_to( rights_text, "#{rights_statement_url}", target: "_blank", rel: "nofollow")
        else
          html = rights_text
        end
    end
    html
  end

  def image_request_link(document)
    url = "http://britishart.yale.edu/request-images?"
    url += "id=#{document['recordID_ss'][0]}&"
    url += "num=#{document['callnumber_txt'][0]}&"
    url += "collection=#{document['collection_txt'][0]}&"
    url += "creator=#{document['author_ss'][0]}&"
    url += "title=#{document['title_txt'][0]}&"
    url += "url=#{document['url_txt'][0]}"
    url
  end

  def information_link_subject(document)
    subject = "[Online Collection] #{document['callnumber_txt'][0]}, #{document['title_txt'][0]}, #{document['author_ss'][0]} "
  end

end
