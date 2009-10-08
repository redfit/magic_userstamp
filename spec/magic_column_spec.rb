# -*- coding: utf-8 -*-
require File.join(File.dirname(__FILE__), 'spec_helper')

describe Userstamp do
  
#   Userstamp.setup_magic_columns do |config|
#     config.with_options(:stamper_class_name => 'User', :stampable_class_names => %w(User Person)) do |c|
#       c.column(:creator_id, :on => :create)
#       c.column(:updater_id, :on => :update)
#       c.column(:deleter_id, :on => :destroy)
#     end

#     config.with_options(:stamper_class_name => 'Person', :stampable_class_names => %w(Post)) do |c|
#       c.column(:creator_id, :on => :create)
#       c.column(:updater_id, :on => :update)
#       c.column(:deleter_id, :on => :destroy)
#     end

#     config.with_options(:stamper_class_name => 'Person', :stampable_class_names => %w(Comment)) do |c|
#       c.column(:creator_by, :on => :create)
#       c.column(:updater_by, :on => :update)
#       c.column(:deleter_by, :on => :destroy)
#     end

#     config.with_options(:stamper_class_name => 'Person', :stamp_attr_name => :name, :stampable_class_names => %w(Ping)) do |c|
#       c.column(:creator_name, :on => :create)
#       c.column(:updater_name, :on => :update)
#       c.column(:deleter_name, :on => :destroy)
#     end
#   end

#   class User < ActiveRecord::Base
#     # model_stamper
#   end

#   class Person < ActiveRecord::Base
#     # model_stamper
#   end  

#   class Post < ActiveRecord::Base
#     # stampable :stamper_class_name => :person
#     has_many :comments
#   end

#   class Comment < ActiveRecord::Base
#     # stampable :stamper_class_name => :person
#     belongs_to :post
#   end

#   class Ping < ActiveRecord::Base
#     # stampable :stamper_class_name => :person
#     belongs_to :post
#   end

#   after(:all) do
#     Userstamp.clear_magic_columns_settings
#   end
  
  fixtures :users, :people, :posts
  
  before(:each) do
    @zeus = users(:zeus)
    @hera = users(:hera)
    @delynn = people(:delynn)
    @nicole = people(:nicole)
    @first_post = posts(:first_post)
    @second_post = posts(:second_post)
    User.stamper = @zeus
    Person.stamper = @delynn
  end

  it "person_creation_with_stamped_object" do
    User.stamper.should == @zeus.id
    
    person = Person.create(:name => "David")
    person.creator_id.should == @zeus.id
    person.updater_id.should == @zeus.id
    person.creator.should == @zeus
    person.updater.should == @zeus
  end

  it "person_creation_with_stamped_integer" do
    User.stamper = 2
    User.stamper.should == 2

    person = Person.create(:name => "Daniel")
    person.creator_id.should ==  @hera.id 
    person.updater_id.should ==  @hera.id 
    person.creator.should ==     @hera 
    person.updater.should ==     @hera 
  end

  it "post_creation_with_stamped_object" do
    Person.stamper.should == @delynn.id

    post = Post.create(:title => "Test Post - 1")
    post.creator_id.should == @delynn.id
    post.updater_id.should ==  @delynn.id
    post.creator.should ==     @delynn
    post.updater.should ==     @delynn
  end

  it "post_creation_with_stamped_integer" do
    Person.stamper = 2
    Person.stamper.should == 2

    post = Post.create(:title => "Test Post - 2")
    post.creator_id.should == @nicole.id
    post.updater_id.should == @nicole.id
    post.creator.should ==    @nicole
    post.updater.should ==    @nicole
  end

  it "person_updating_with_stamped_object" do
    User.stamper = @hera
    User.stamper.should == @hera.id

    @delynn.name << " Berry"
    @delynn.save
    @delynn.reload
    @delynn.creator.should ==    @zeus
    @delynn.updater.should ==    @hera
    @delynn.creator_id.should == @zeus.id
    @delynn.updater_id.should == @hera.id
  end

  it "person_updating_with_stamped_integer" do
    User.stamper = 2
    User.stamper.should == 2

    @delynn.name << " Berry"
    @delynn.save
    @delynn.reload
    @delynn.creator_id.should == @zeus.id
    @delynn.updater_id.should == @hera.id
    @delynn.creator.should ==    @zeus
    @delynn.updater.should ==    @hera
  end

  it "post_updating_with_stamped_object" do
    Person.stamper = @nicole
    Person.stamper.should == @nicole.id

    @first_post.title << " - Updated"
    @first_post.save
    @first_post.reload
    @first_post.creator_id.should == @delynn.id
    @first_post.updater_id.should == @nicole.id
    @first_post.creator.should ==    @delynn
    @first_post.updater.should ==    @nicole
  end

  it "post_updating_with_stamped_integer" do
    Person.stamper = 2
    Person.stamper.should == 2

    @first_post.title << " - Updated"
    @first_post.save
    @first_post.reload
    @first_post.creator_id.should == @delynn.id
    @first_post.updater_id.should == @nicole.id
    @first_post.creator.should ==    @delynn
    @first_post.updater.should ==    @nicole
  end

end

