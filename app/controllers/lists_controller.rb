class ListsController < ApplicationController
  def index
    @people= Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end

  end

  def courses
    if params[:list]

      @course_id = params[:course]

      output = MemberlistReport.new.to_pdf(@course_id)
      send_data output, :filename => "Teilnehmerliste.pdf", :type => "application/pdf"
    else
      @course_id = params[:course]

      output = EmailReport.new.to_pdf(@course_id)
      send_data output, :filename => "Email.pdf", :type => "application/pdf"

    end
  end

end
