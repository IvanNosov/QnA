class AttachmentsController < ApplicationController
  before_action :set_attachment
  load_and_authorize_resource
  def destroy
    @attachment.destroy
    redirect_back(fallback_location: root_path, notice: 'Successfully destroyed.')
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
