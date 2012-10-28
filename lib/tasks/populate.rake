namespace :db do
  desc "It's time for new adventure!"
  task :populate => :environment do
    require 'populator'
    require 'faker'
    
    [Category, Thing].each do |tbl|
        tbl.delete_all
        ActiveRecord::Base.connection.reset_pk_sequence!(tbl.table_name)
      end
    
    Category.populate 5 do |category|
      category.name = Populator.words(1..2).titleize
      Thing.populate 10..100 do |thing|
        thing.category_id = category.id
        thing.name = Populator.words(1..3).titleize
        thing.about = Populator.sentences(2..10)
        thing.cost = (1..1000).to_a
        thing.created_at = 2.years.ago..Time.now
      end
    end
    

  end
end