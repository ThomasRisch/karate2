# encoding: utf-8
class GradesController < ApplicationController
  active_scaffold :grade do |conf|
    conf.columns = [:id, :name, :color, :sort_order, :next_grade]

    conf.columns[:sort_order].inplace_edit = true
    conf.columns[:next_grade].inplace_edit = true

    actions.exclude :search

    show.columns.exclude :id
    create.columns.exclude :id
    update.columns.exclude :id


    list.per_page = 50

  end
end 

