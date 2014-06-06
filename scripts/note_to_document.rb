# coding: utf-8
require File.expand_path("../../config/env",__FILE__)
require File.expand_path("../../lib/models/note",__FILE__)

module DocumentsStore
  Note.all.each_with_index do |note, index|
    record = Document.new

    puts "正在迁移第#{index + 1}个记录.."
    record.versionless do |doc|
      doc.title          = note.title
      doc.content        = note.content
      doc.creator_id     = note.creator_id
      doc.timeless.save

      doc.version        = note.version
      doc.last_editor_id = note.last_editor_id
      doc.updated_at     = note.updated_at
      doc.created_at     = note.created_at

      note.versions.each do |nver|
        ver_rec = doc.versions.new

        ver_rec.versionless do |dver|
          dver.id             = nil
          dver.title          = nver.title
          dver.content        = nver.content
          dver.creator_id     = nver.creator_id
          dver.versionless.timeless.save

          dver.version        = nver.version
          dver.last_editor_id = nver.last_editor_id
          dver.updated_at     = nver.updated_at
          dver.created_at     = nver.created_at

          criteria = note.versions.where(:updated_at.lt => nver.updated_at)
          dver.editor_ids = (dver.editor_ids + criteria.map(&:last_editor_id)).uniq
          dver.timeless.save
        end
      end

      doc.editor_ids = (doc.editor_ids + doc.versions.map(&:last_editor_id)).uniq
      doc.timeless.save
      puts "第#{index + 1}个记录迁移完毕\n\n"
    end
  end
end

puts "全部迁移完毕!"
