module ApplicationHelper

  def render_as_link options={}
    options[:document] # the original document
    options[:field] # the field to render
    options[:value] # the value of the field

    links = []
    options[:value].each {  |link|
      links.append(link_to "#{link}", "#{link}", target: '_blank')
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

  def cds_info_url(id, type = 2)
    cds = Rails.application.config_for(:cds)
    "http://#{cds['host']}/info/repository/YCBA/object/#{id}/type/#{type}"
  end

  def cds_thumbnail_url(id, type = 2)
    cds = Rails.application.config_for(:cds)
    "http://#{cds['host']}/content/repository/YCBA/object/#{id}/type/#{type}/format/1"
  end

  def display_rights(document)
    rights_text = document['rights_txt']
    rights_text = rights_text[0] if rights_text

    rights_statement_url = document['rightsURL_ss']
    if rights_statement_url
      rights_text ||= 'Unknown'
      rights_statement_url = rights_statement_url[0]
    end

    if rights_text
        if rights_statement_url
          html = link_to( rights_text, "#{rights_statement_url}", target: "_blank", rel: "nofollow")
        elsif rights_text
          html = rights_text
        end
    end
    html
  end

  def image_request_link(document)
    url = "http://britishart.yale.edu/request-images?"
    url += "id=#{field_value(document,'recordID_ss')}&"
    url += "num=#{field_value(document,'callnumber_txt')}&"
    url += "collection=#{field_value(document,'collection_txt')}&"
    url += "creator=#{field_value(document,'author_ss')}&"
    url += "title=#{field_value(document,'title_txt')}&"
    url += "url=#{field_value(document,'url_txt')}"
    url
  end

  def information_link_subject(document)
    subject = "[Online Collection] #{field_value(document,'callnumber_txt')}, #{field_value(document,'title_txt')}, #{field_value(document,'author_ss')} "
  end

  private

  def field_value(document, field)
    value = document[field][0] if document[field]
    value ||= ''
  end

end
