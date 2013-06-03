# encoding: utf-8
class NotesController < ApplicationController
  active_scaffold :note do |conf|

    columns[:note_text].label = 'Notitz'
    columns[:created_at].label = 'Erstellt'
    columns[:updated_at].label = 'Geändert'

    list.label = "Notitzen"

    create.link.label = 'Neue Notitz'
    create.label = 'Neues Notitz'
    
    update.link.label = 'Ändern'
    update.label = 'Ändern'
    
    show.link.label = 'Details'
    show.label = 'Details'

    delete.link.label = 'Löschen'

    actions.exclude :search


  end
end 
