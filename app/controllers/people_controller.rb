# encoding: utf-8
class PeopleController < ApplicationController
  active_scaffold :person do |config|


    # Explicitly adds all columns we need, in specific order
    config.columns = [:name, :firstname, :lastname, :street, :zipcity, :birthday, :entry_date, :leave_date, :email, :phone, :mobile, :birthday, :image,
                      :amount, :discount, :is_yearly, :salutation, :bill_name, :bill_firstname, :bill_lastname, :bill_street, :bill_zipcity, :bill_email,
                      :gradex, :notex, :docx, :coursex]
    
    # Labels all columns
    columns[:name].label = 'Name, Vorname'
    columns[:lastname].label = 'Nachname'
    columns[:firstname].label = 'Vorname'
    columns[:street].label = 'Strasse'
    columns[:zipcity].label = 'PLZ Ort'
    columns[:email].label = 'E-Mail'
    columns[:phone].label = 'Telefon'
    columns[:mobile].label = 'Mobile'
    columns[:birthday].label = 'Geburtstag'
    columns[:entry_date].label = 'Eintritt'
    columns[:leave_date].label = 'Austritt'
    columns[:image].label = 'Bild'

    columns[:salutation].label = 'Anrede'
    columns[:bill_name].label = 'Name, Vorname'
    columns[:bill_lastname].label = 'Nachname'
    columns[:bill_firstname].label = 'Vorname'
    columns[:bill_street].label = 'Strasse'
    columns[:bill_zipcity].label = 'PLZ Ort'
    columns[:bill_email].label = 'E-Mail'

    columns[:amount].label = 'Rechnungsbetrag'
    columns[:discount].label = 'Rabatt'
    columns[:is_yearly].label = 'Jahresrechnung'

    columns[:gradex].label = 'Graduierung'
    columns[:notex].label = 'Not.'
    columns[:docx].label = 'Dok.'
    columns[:coursex].label = 'Kurse'

    # Prepares List, we want to see only few col's here therefore explicit assignment
    list.columns = [:name, :gradex, :notex, :docx, :coursex]    
    list.sorting = [{:lastname => :asc}, {:firstname => :asc}] # initial sort of list    
    columns[:name].sort_by :sql => 'lastname||firstname' # adds sorting capability on virtual column
    list.always_show_search = true

    # Prepares Show, we dopn't want to see single attributes if there are combined, and we want to see groups
    show.columns.exclude :firstname, :lastname, :bill_firstname, :bill_lastname, :gradex, :notex, :docx, :coursex
    show.columns.add_subgroup "Rechnungsdetails" do |bill_details|
      bill_details.add :amount, :discount, :is_yearly
    end
    show.columns.add_subgroup "Rechnungsadresse" do |bill_group|
      bill_group.add :salutation, :bill_name, :bill_street, :bill_zipcity, :bill_email
    end


    # Prepares Create
    # We don't want to have a leave date when we create a person
    # We want to see grouping
    create.columns.exclude :leave_date, :gradex, :notex, :docx, :coursex
    create.columns.add_subgroup "Rechnungsdetails" do |bill_details|
      bill_details.add :amount, :discount, :is_yearly
    end
    create.columns.add_subgroup "Rechnungsadresse" do |bill_group|
      bill_group.add :salutation, :bill_name, :bill_street, :bill_zipcity, :bill_email
    end

    update.columns.exclude :gradex, :notex, :docx, :coursex
    update.columns.add_subgroup "Rechnungsdetails" do |bill_details|
      bill_details.add :amount, :discount, :is_yearly
    end
    update.columns.add_subgroup "Rechnungsadresse" do |bill_group|
      bill_group.add :salutation, :bill_name, :bill_street, :bill_zipcity, :bill_email
    end

    columns[:birthday].description = "YYYY-mm-dd"
    columns[:entry_date].description = "YYYY-mm-dd"
    columns[:leave_date].description = "YYYY-mm-dd"

    # Headings
    list.label = 'Personen'
    search.link.label = 'Suchen'
    search.columns = [:lastname, :firstname]
    create.link.label = 'Neue Person'

    # Columns
    nested.add_link :notes, :label => "Notitzen"
    nested.add_link :bills, :label => "Rechnungen"
    nested.add_link :documents, :label => "Dokumente"
    nested.add_link :gradings, :label => "Prüfungen"   
    nested.add_link :courses, :label => "Kurse"
    update.link.label = 'Ändern'
    delete.link.label = 'Löschen'
    show.link.label = 'Details'
    show.label = 'Details'

  end

end 
