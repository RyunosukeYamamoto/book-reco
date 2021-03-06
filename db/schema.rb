# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_210_209_191_926) do
  create_table 'books', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'title'
    t.bigint 'user_id'
    t.string 'impression'
    t.integer 'nowpage'
    t.integer 'page'
    t.string 'status'
    t.string 'code'
    t.text 'img'
    t.date 'date'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_books_on_user_id'
  end

  create_table 'comments', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'content'
    t.bigint 'user_id'
    t.bigint 'book_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['book_id'], name: 'index_comments_on_book_id'
    t.index ['user_id'], name: 'index_comments_on_user_id'
  end

  create_table 'relationships', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.bigint 'user_id'
    t.bigint 'follow_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['follow_id'], name: 'index_relationships_on_follow_id'
    t.index %w[user_id follow_id], name: 'index_relationships_on_user_id_and_follow_id', unique: true
    t.index ['user_id'], name: 'index_relationships_on_user_id'
  end

  create_table 'users', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'password_digest'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  add_foreign_key 'books', 'users'
  add_foreign_key 'comments', 'books'
  add_foreign_key 'comments', 'users'
  add_foreign_key 'relationships', 'users'
  add_foreign_key 'relationships', 'users', column: 'follow_id'
end
