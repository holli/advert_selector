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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120925122858) do

  create_table "advert_selector_banners", :force => true do |t|
    t.string   "name",                                  :null => false
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "priority",           :default => 0,     :null => false
    t.integer  "target_view_count"
    t.integer  "running_view_count", :default => 0,     :null => false
    t.integer  "frequency"
    t.boolean  "fast_mode",          :default => false, :null => false
    t.text     "comment"
    t.boolean  "confirmed",          :default => false, :null => false
    t.integer  "placement_id",                          :null => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "advert_selector_placements", :force => true do |t|
    t.string   "name",                         :null => false
    t.text     "development_code"
    t.integer  "request_delay"
    t.text     "conflicting_placements_array"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

end
