class AttachmentsController < ApplicationController
  before_action :set_attachment
  before_action :author?

  def destroy
    @attachment.destroy
    redirect_back(fallback_location: root_path, notice: 'Successfully destroyed.')
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end

  def author?
    return nil if @attachment.attachable.author? current_user
  end
end
