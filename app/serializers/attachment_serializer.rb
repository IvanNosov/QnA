class AttachmentSerializer < ActiveModel::Serializer
  attributes :attachment_url

  def attachment_url
    object.file.url
  end
end
