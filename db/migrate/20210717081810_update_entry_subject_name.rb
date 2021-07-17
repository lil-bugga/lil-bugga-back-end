class UpdateEntrySubjectName < ActiveRecord::Migration[6.1]
  def change
    rename_column :entries, :subject_string, :subject
  end
end
