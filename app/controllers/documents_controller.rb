# encoding: utf-8
class DocumentsController < ApplicationController
  active_scaffold :document do |conf|
    conf.columns = [:doctype, :filename, :comment]
    columns[:doctype].label = 'Typ'
    columns[:filename].label = 'Filename'
    columns[:comment].label = 'Kommentar'    
    actions.exclude :search   

    columns[:doctype].form_ui = :select
    columns[:doctype].options = {:options => ["", "Vertrag", "Kündigung", "Kündigungsbestätigung", "sonstiges"]}

    list.label = "Dokumente"

    create.link.label = 'Neues Dokument'
    create.label = 'Neues Dokument'
    
    update.link.label = 'Ändern'
    update.label = 'Ändern'
    
    show.link.label = 'Details'
    show.label = 'Details'

    delete.link.label = 'Löschen'

  end
end 
