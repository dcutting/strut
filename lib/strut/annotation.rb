module Strut
  ANNOTATION_OK = :ok
  ANNOTATION_FAIL = :fail
  ANNOTATION_EXCEPTION = :exception

  Annotation = Struct.new(:type, :message)
end
