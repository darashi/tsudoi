require File.join(File.dirname(__FILE__), 'test_helper')

class Widget < ActiveRecord::Base
  acts_as_paranoid
  has_many :categories, :dependent => :destroy
  has_and_belongs_to_many :habtm_categories, :class_name => 'Category'
  has_one :category
  belongs_to :parent_category, :class_name => 'Category'
end

class Category < ActiveRecord::Base
  belongs_to :widget
  belongs_to :any_widget, :class_name => 'Widget', :foreign_key => 'widget_id', :with_deleted => true
  acts_as_paranoid

  def self.search(name, options = {})
    find :all, options.merge(:conditions => ['LOWER(title) LIKE ?', "%#{name.to_s.downcase}%"])
  end

  def self.search_with_deleted(name, options = {})
    find_with_deleted :all, options.merge(:conditions => ['LOWER(title) LIKE ?', "%#{name.to_s.downcase}%"])
  end
end

class NonParanoidAndroid < ActiveRecord::Base
end

class ParanoidTest < Test::Unit::TestCase
  fixtures :widgets, :categories, :categories_widgets

  def test_should_count_with_deleted
    assert_equal 1, Widget.count
    assert_equal 2, Widget.count_with_deleted
    assert_equal 2, Widget.calculate_with_deleted(:count, :all)
  end

  def test_should_set_deleted_at
    assert_equal 1, Widget.count
    assert_equal 1, Category.count
    widgets(:widget_1).destroy
    assert_equal 0, Widget.count
    assert_equal 0, Category.count
    assert_equal 2, Widget.calculate_with_deleted(:count, :all)
    assert_equal 4, Category.calculate_with_deleted(:count, :all)
  end
  
  def test_should_destroy
    assert_equal 1, Widget.count
    assert_equal 1, Category.count
    widgets(:widget_1).destroy!
    assert_equal 0, Widget.count
    assert_equal 0, Category.count
    assert_equal 1, Widget.calculate_with_deleted(:count, :all)
    # Category doesn't get destroyed because the dependent before_destroy callback uses #destroy
    assert_equal 4, Category.calculate_with_deleted(:count, :all)
  end
  
  def test_should_delete_all
    assert_equal 1, Widget.count
    assert_equal 2, Widget.calculate_with_deleted(:count, :all)
    assert_equal 1, Category.count
    Widget.delete_all
    assert_equal 0, Widget.count
    # delete_all doesn't call #destroy, so the dependent callback never fires
    assert_equal 1, Category.count
    assert_equal 2, Widget.calculate_with_deleted(:count, :all)
  end
  
  def test_should_delete_all_with_conditions
    assert_equal 1, Widget.count
    assert_equal 2, Widget.calculate_with_deleted(:count, :all)
    Widget.delete_all("id < 3")
    assert_equal 0, Widget.count
    assert_equal 2, Widget.calculate_with_deleted(:count, :all)
  end
  
  def test_should_delete_all2
    assert_equal 1, Category.count
    assert_equal 4, Category.calculate_with_deleted(:count, :all)
    Category.delete_all!
    assert_equal 0, Category.count
    assert_equal 0, Category.calculate_with_deleted(:count, :all)
  end
  
  def test_should_delete_all_with_conditions2
    assert_equal 1, Category.count
    assert_equal 4, Category.calculate_with_deleted(:count, :all)
    Category.delete_all!("id < 3")
    assert_equal 0, Category.count
    assert_equal 2, Category.calculate_with_deleted(:count, :all)    
  end
  
  def test_should_not_count_deleted
    assert_equal 1, Widget.count
    assert_equal 1, Widget.count(:all, :conditions => ['title=?', 'widget 1'])
    assert_equal 2, Widget.calculate_with_deleted(:count, :all)
  end
  
  def test_should_not_find_deleted
    assert_equal [widgets(:widget_1)], Widget.find(:all)
    assert_equal [1, 2], Widget.find_with_deleted(:all, :order => 'id').collect { |w| w.id }
  end
  
  def test_should_not_find_deleted_has_many_associations
    assert_equal 1, widgets(:widget_1).categories.size
    assert_equal [categories(:category_1)], widgets(:widget_1).categories
  end
  
  def test_should_not_find_deleted_habtm_associations
    assert_equal 1, widgets(:widget_1).habtm_categories.size
    assert_equal [categories(:category_1)], widgets(:widget_1).habtm_categories
  end
  
  def test_should_not_find_deleted_belongs_to_associations
    assert_nil Category.find_with_deleted(3).widget
  end

  def test_should_find_belongs_to_assocation_with_deleted
    assert_equal Widget.find_with_deleted(2), Category.find_with_deleted(3).any_widget
  end

  def test_should_find_first_with_deleted
    assert_equal widgets(:widget_1), Widget.find(:first)
    assert_equal 2, Widget.find_with_deleted(:first, :order => 'id desc').id
  end
  
  def test_should_find_single_id
    assert Widget.find(1)
    assert Widget.find_with_deleted(2)
    assert_raises(ActiveRecord::RecordNotFound) { Widget.find(2) }
  end
  
  def test_should_find_multiple_ids
    assert_equal [1,2], Widget.find_with_deleted(1,2).sort_by { |w| w.id }.collect { |w| w.id }
    assert_equal [1,2], Widget.find_with_deleted([1,2]).sort_by { |w| w.id }.collect { |w| w.id }
    assert_raises(ActiveRecord::RecordNotFound) { Widget.find(1,2) }
  end
  
  def test_should_ignore_multiple_includes
    Widget.class_eval { acts_as_paranoid }
    assert Widget.find(1)
  end

  def test_should_not_override_scopes_when_counting
    assert_equal 1, Widget.send(:with_scope, :find => { :conditions => "title = 'widget 1'" }) { Widget.count }
    assert_equal 0, Widget.send(:with_scope, :find => { :conditions => "title = 'deleted widget 2'" }) { Widget.count }
    assert_equal 1, Widget.send(:with_scope, :find => { :conditions => "title = 'deleted widget 2'" }) { Widget.calculate_with_deleted(:count, :all) }
  end

  def test_should_not_override_scopes_when_finding
    assert_equal [1], Widget.send(:with_scope, :find => { :conditions => "title = 'widget 1'" }) { Widget.find(:all) }.ids
    assert_equal [],  Widget.send(:with_scope, :find => { :conditions => "title = 'deleted widget 2'" }) { Widget.find(:all) }.ids
    assert_equal [2], Widget.send(:with_scope, :find => { :conditions => "title = 'deleted widget 2'" }) { Widget.find_with_deleted(:all) }.ids
  end

  def test_should_allow_multiple_scoped_calls_when_finding
    Widget.send(:with_scope, :find => { :conditions => "title = 'deleted widget 2'" }) do
      assert_equal [2], Widget.find_with_deleted(:all).ids
      assert_equal [2], Widget.find_with_deleted(:all).ids, "clobbers the constrain on the unmodified find"
      assert_equal [], Widget.find(:all).ids
      assert_equal [], Widget.find(:all).ids, 'clobbers the constrain on a paranoid find'
    end
  end

  def test_should_allow_multiple_scoped_calls_when_counting
    Widget.send(:with_scope, :find => { :conditions => "title = 'deleted widget 2'" }) do
      assert_equal 1, Widget.calculate_with_deleted(:count, :all)
      assert_equal 1, Widget.calculate_with_deleted(:count, :all), "clobbers the constrain on the unmodified find"
      assert_equal 0, Widget.count
      assert_equal 0, Widget.count, 'clobbers the constrain on a paranoid find'
    end
  end

  def test_should_give_paranoid_status
    assert Widget.paranoid?
    assert !NonParanoidAndroid.paranoid?
  end

  def test_should_find_deleted_has_many_assocations_on_deleted_records_by_default
    w = Widget.find_with_deleted 2
    assert_equal 2, w.categories.find_with_deleted(:all).length
    assert_equal 2, w.categories.find_with_deleted(:all).size
  end
  
  def test_should_find_deleted_habtm_assocations_on_deleted_records_by_default
    w = Widget.find_with_deleted 2
    assert_equal 2, w.habtm_categories.find_with_deleted(:all).length
    assert_equal 2, w.habtm_categories.find_with_deleted(:all).size
  end

  def test_dynamic_finders
    assert     Widget.find_by_id(1)
    assert_nil Widget.find_by_id(2)
  end

  def test_custom_finder_methods
    w = Widget.find_with_deleted(:all).inject({}) { |all, w| all.merge(w.id => w) }
    assert_equal [1],       Category.search('c').ids
    assert_equal [1,2,3,4], Category.search_with_deleted('c', :order => 'id').ids
    assert_equal [1],       widgets(:widget_1).categories.search('c').collect(&:id)
    assert_equal [1,2],     widgets(:widget_1).categories.search_with_deleted('c').ids
    assert_equal [],        w[2].categories.search('c').ids
    assert_equal [3,4],     w[2].categories.search_with_deleted('c').ids
  end
end

class Array
  def ids
    collect &:id
  end
end