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

end
