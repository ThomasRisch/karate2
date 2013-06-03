# encoding: UTF-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
    Grade.delete_all
    Grade.create :name => "9.Kyu", :color => "Weissgurt"
    Grade.create :name => "8.Kyu", :color => "Gelbgurt"
    Grade.create :name => "7.Kyu", :color => "Orangegurt"
    Grade.create :name => "6.Kyu", :color => "Grüngurt"
    Grade.create :name => "5.Kyu", :color => "Blaugurt"
    Grade.create :name => "4.Kyu", :color => "Violettgurt"
    Grade.create :name => "3.Kyu", :color => "Braungurt"
    Grade.create :name => "2.Kyu", :color => "Braungurt"
    Grade.create :name => "1.Kyu", :color => "Braungurt"
    Grade.create :name => "1.Dan", :color => "Schwarzgurt"
    Grade.create :name => "2.Dan", :color => "Schwarzgurt"
    Grade.create :name => "3.Dan", :color => "Schwarzgurt"
    Grade.create :name => "4.Dan", :color => "Schwarzgurt"
    Grade.create :name => "5.Dan", :color => "Schwarzgurt"

    Course.delete_all
    Course.create :course_name => "Jugend/Erwachsene", :course_desc => "Di und Do 20:00 - 21:00" 
    Course.create :course_name => "Oberstufe", :course_desc => "Di und Do 19:00 - 20:00"
    Course.create :course_name => "Unterstufe", :course_desc => "Di und Do 18:00 - 19:00"
    Course.create :course_name => "Mini Sa 9:15", :course_desc => "1. Semester 2013", :course_start => "1.1.2013", :course_end => "31.7.2013"
    Course.create :course_name => "Mini Sa 11:45", :course_desc => "1. Semester 2013", :course_start => "1.1.2013", :course_end => "31.7.2013"
    Course.create :course_name => "Bonsai Sa 10:05", :course_desc => "1. Semester 2013", :course_start => "1.1.2013", :course_end => "31.7.2013"
    Course.create :course_name => "Bonsai Sa 10:55", :course_desc => "1. Semester 2013", :course_start => "1.1.2013", :course_end => "31.7.2013"
    Course.create :course_name => "Bonsai Do 9:00", :course_desc => "1. Semester 2013", :course_start => "1.1.2013", :course_end => "31.7.2013"
    Course.create :course_name => "Best Age", :course_desc => "2. Semester 2010", :course_start => "1.8.2010", :course_end => "31.12.2010"


     
