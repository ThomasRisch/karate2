# encoding: utf-8
class GradingsController < ApplicationController

  active_scaffold :grading do |conf|

    conf.columns = [:grade_id, :grade, :trainings, :grading_date, :comment, :positive, :negative]
    columns[:grade].label = 'Grad'
    columns[:grading_date].label = 'Prüfungsdatum'
#    columns[:grading_date].sort = false
    columns[:trainings].label = 'Trainings'
    columns[:comment].label = 'Kommentar'
    columns[:comment].sort = false
    columns[:comment].options = {:cols => "75", :rows => "6"}
    columns[:positive].label = 'Positiv'
    columns[:positive].sort = false
    columns[:positive].options = {:cols => "75", :rows => "6"}
    columns[:negative].label = 'Negativ'
    columns[:negative].sort = false
    columns[:negative].options = {:cols => "75", :rows => "6"}

    create.link.label = 'Neue Prüfung'
    create.label = 'Neue Prüfung'
    create.columns.exclude :grade, :grade_id

    columns.exclude :grade_id
    list.sorting =  { :grading_date => :desc }

    list.label = "Prüfungen"
    columns[:trainings].inplace_edit = true
    

    action_links.add 'print', :action => "print", 
      :label => "Urkunde", :type => :member, :page => true
    action_links.add 'details', :action => "details",
      :label => "Details", :type => :collection, :page => true


    update.link.label = 'Ändern'
    update.label = 'Ändern'

    show.link.label = 'Details'
    show.label = 'Details'

    delete.link.label = 'Löschen'

  end

  # only available in main form
  def search_ignore?(record = nil)
    nested?
  end

  # only available in subform
  def delete_ignore?(record = nil)
    !nested?
  end

  def update_ignore?(record = nil)
    !nested?
  end
  
  def show_ignore?(record = nil)
    !nested?
  end

  def create_ignore?
    !nested?
  end


  def print
    # need to retrieve array (with :all) otherwise to_pdf method doesn't work
    grading = Grading.find(:first, :conditions => ["id = ?", params[:id]])
    person = Person.find(:first, :conditions => ["id = ?", grading.person_id.to_s])
    grade = Grade.find(:first, :conditions => ["id = ?", grading.grade_id.to_s])

    # gsub strips comma from name
    #filename = "Rechnung " + records[0].name.gsub(/\,/,"") + ".pdf"
    filename = "Urkunde"

    output = UrkundeReport.new.to_pdf(person.lastname, person.firstname, grading.grading_date, grade.name, grade.color)
    send_data output, :filename => filename, :type => "application/pdf"

  end

  def details

      p = params[:person_id]
      output = GradingReport.new.to_pdf(p)
      send_data output, :filename => "Prüfungsdetails.pdf", :type => "application/pdf"

  end



  def before_create_save(record)
    # Get new grade
    next_grade = get_new_grade(record.person_id)
    record.grade_id = next_grade.id
  end

  # ----------------------------------------------------------------------------------
  # Additional methods
  
  def get_new_grade person_id
    current_grading = Grading.find(:last, :conditions => "person_id = '" + person_id.to_s + "'")
    if current_grading.nil?
      next_grade = Grade.order("sort_order").find(:first) 
    else
      current_grade = Grade.find(current_grading.grade_id)
      next_grade = Grade.find(current_grade.next_grade)
    end
    return next_grade
  end
end 
