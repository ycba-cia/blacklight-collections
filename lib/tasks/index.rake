require 'rubygems'
require 'rsolr'
require 'rexml/document'

include REXML

namespace :index do
  desc "Copy index from CCD Solr to Blacklight Solr"
  task copy: :environment do

    SOLR_CONFIG = Rails.application.config_for(:blacklight)
    start=0
    stop=false
    solr = RSolr.connect :url => 'http://127.0.0.1:8380/solr/biblio'
    target_solr = RSolr.connect :url => SOLR_CONFIG['url']

    while stop!=true
      # send a request to /select
      response = solr.post 'select', :params => {
          :q=>'recordtype:"lido"',
          :sort=>'id asc',
          :start=>start,
          :rows=>100
      }
      documents = Array.new

      stop = true if response['response']['docs'].length == 0

      response["response"]["docs"].each{|doc|

        doc.delete("title_fullStr")
        doc.delete("callnumber_txt")
        doc.delete("author_additionalStr")
        spell=doc.delete("spelling")
        doc["spell"] = spell if spell
        if doc["type_standard"] and doc["type_parent"]
          doc["type_facet"][0]=doc["type_parent"][0]
          doc["type_facet"][1]=doc["type_parent"][0]+":"+doc["type_standard"][0]
        end
        docClone=doc.clone

        if doc['fullrecord']
          xml = REXML::Document.new(doc['fullrecord'])
          #puts xml
          ort = XPath.first(xml, '//lido:rightsWorkSet/lido:rightsType/lido:conceptID[@lido:type="object copyright"]')
          rightsURL = XPath.first(xml, '//lido:legalBodyID[@lido:type="URL"]')
          ort = ort.text if ort
          rightsURL = rightsURL.text if rightsURL

          videos = []
          videoURL = XPath.each(xml, '//lido:linkResource[@lido:formatResource="video"]') { |video|
            videos.append(video.text)
          }

          citations = []
          XPath.each(xml, '//lido:relatedWorkSet/lido:relatedWork/lido:object/lido:objectNote') { |citation|
            citations.append(citation.text)
          }

          doc['ort_ss'] = ort
          doc['rightsURL_ss'] = rightsURL
          doc['videoURL_ss'] = videos
          doc['citation'] = citations
        end

        docClone.each do |key, array|
          if key!="id" and !key.end_with?("_facet")
            value=doc.delete(key)
            doc[key+"_ss"] = value if value and key != 'fullrecord'
            doc[key+"_txt"] = value if value
          end
        end

        puts doc["id"]
        documents.push(doc)

      }
      puts start
      target_solr.add documents
      target_solr.commit
      start +=100
      sleep(1)  #be kind to others :)
    end
    target_solr.optimize
  end

  desc 'Clear the index.  Deletes all documents in the index'
  task clear: :environment do
    SOLR_CONFIG = Rails.application.config_for(:blacklight)
    solr = RSolr.connect :url => SOLR_CONFIG['url']
    solr.delete_by_query "id:*"
    solr.commit
    solr.optimize
  end

end
