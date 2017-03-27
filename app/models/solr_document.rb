# frozen_string_literal: true
class SolrDocument
  include Blacklight::Solr::Document

  # self.unique_key = 'id'


  #Bibliographic
  def physical_description
    self['physical_txt']
  end

  def publisher
    value = self['publisher_ss']
    pub_date = self['publishDate_txt']
    value.push(pub_date) unless value.nil? or value.empty? or pub_date.nil? or pub_date.empty?
    (value.nil? or value.empty?) ? nil : value.join(' ')
  end

  def orbis_link
    self['url_txt']
  end

  def callnumber
    self['callnumber_txt']
  end

  def note
    self['description_txt']
  end

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)
end
