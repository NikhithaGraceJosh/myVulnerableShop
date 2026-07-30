# frozen_string_literal: true

# This migration comes from acts_as_taggable_on_engine (originally 2)
class AddMissingUniqueIndices < ActiveRecord::Migration[6.0]
  def self.up
    unless index_exists?(ActsAsTaggableOn.tags_table, :name, unique: true)
      add_index ActsAsTaggableOn.tags_table, :name, unique: true
    end

    # MySQL requires the tag_id index for the foreign key.
    # Only remove it if it is NOT backing a foreign key.
    if index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
      unless foreign_key_exists?(ActsAsTaggableOn.taggings_table, ActsAsTaggableOn.tags_table)
        remove_index ActsAsTaggableOn.taggings_table, :tag_id
      end
    end

    if index_exists?(
         ActsAsTaggableOn.taggings_table,
         [:taggable_id, :taggable_type, :context],
         name: "taggings_taggable_context_idx"
       )
      remove_index ActsAsTaggableOn.taggings_table, name: "taggings_taggable_context_idx"
    end

    unless index_exists?(
             ActsAsTaggableOn.taggings_table,
             [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
             name: "taggings_idx",
             unique: true
           )
      add_index ActsAsTaggableOn.taggings_table,
                [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
                unique: true,
                name: "taggings_idx"
    end
  end

  def self.down
    if index_exists?(
         ActsAsTaggableOn.taggings_table,
         [:tag_id, :taggable_id, :taggable_type, :context, :tagger_id, :tagger_type],
         name: "taggings_idx"
       )
      remove_index ActsAsTaggableOn.taggings_table, name: "taggings_idx"
    end

    unless index_exists?(ActsAsTaggableOn.taggings_table, :tag_id)
      add_index ActsAsTaggableOn.taggings_table, :tag_id
    end

    unless index_exists?(
             ActsAsTaggableOn.taggings_table,
             [:taggable_id, :taggable_type, :context],
             name: "taggings_taggable_context_idx"
           )
      add_index ActsAsTaggableOn.taggings_table,
                [:taggable_id, :taggable_type, :context],
                name: "taggings_taggable_context_idx"
    end

    if index_exists?(ActsAsTaggableOn.tags_table, :name)
      remove_index ActsAsTaggableOn.tags_table, :name
    end
  end
end
