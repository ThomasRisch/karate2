# encoding: utf-8

class CoursesController < ApplicationController
  active_scaffold :course do |conf|

    conf.columns = [:course_name, :course_desc, :course_start, :course_end, :course_amount]

    # Labels all columns
    columns[:course_name].label = 'Kursname'
    columns[:course_desc].label = 'Rechnungstext'
    columns[:course_start].label = 'Startdatum'
    columns[:course_end].label = 'Enddatum'
    columns[:course_amount].label = 'Kurskosten'

    actions.exclude :search
   
    create.link.label = 'Neuer Kurs' 
    update.link.label = 'Ändern'
    delete.link.label = 'Löschen'
    show.link.label = 'Details'
    list.label = "Kurse"
    list.per_page = 50

    nested.add_link :people, :label => "Teilnehmer"


  end

  def create_ignore?
    super || nested?
  end
  def delete_ignore?(record = nil)
    nested?
  end
  def update_ignore?(record = nil)
    nested?
  end


end 
