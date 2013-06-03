# encoding: utf-8
class GradingsController < ApplicationController
  active_scaffold :grading do |conf|

    conf.columns = [:grade, :grade_id, :grading_date, :comment, :positive, :negative]
    columns[:grade].label = 'Grad'
    columns[:grading_date].label = 'Prüfungsdatum'
    columns[:grading_date].sort = false
    columns[:comment].label = 'Kommentar'
    columns[:comment].sort = false
    columns[:positive].label = 'Positiv'
    columns[:positive].sort = false
    columns[:negative].label = 'Negativ'
    columns[:negative].sort = false

    conf.actions.exclude :search

    create.link.label = 'Neue Prüfung'
    create.label = 'Neue Prüfung'
    create.columns.exclude :grade, :grade_id

    # This adds default sorting on the (hidden) column grade_id.
    # Required because sorting on virtual column :grade does not work.
    columns.exclude :grade_id
    list.sorting =  { :grade_id => :desc }
    # This adds sort capability to virtual column, but we don't need this.
#    columns[:grade].sort_by :sql => 'gradings.grade_id'

    list.label = "Prüfungen"

    update.link.label = 'Ändern'
    update.label = 'Ändern'
    
    show.link.label = 'Details'
    show.label = 'Details'

    delete.link.label = 'Löschen'

  end

  def before_create_save(record)
    # Get new grade
    next_grade = get_new_grade(record.person_id)
    record.grade_id = next_grade.id
  end

  # ----------------------------------------------------------------------------------
  # Additional methods
  
  def get_new_grade person_id
    current_grading = Grading.find(:first, :conditions => "person_id = '" + person_id.to_s + "'", :order => "grade_id desc")
    if current_grading.nil?
      next_grade = Grade.find(2)
    else
      next_grade = Grade.find(current_grading.grade_id + 1)
    end
    return next_grade
  end
end 
