== TASK

Write a model (ActiveRecord-based) for storing global configuration settings. It will be used for storing single values, for example an email address to send error emails to, or a flag enable/disable a particular feature. The interface must be simple and convenient, it should be possible to read and write specific configuration items. It must be possible to store values of these 4 types: string, integer, float and boolean. The model should come with a unit test and a migration.
 
Bonus: add caching within the model so that values are cached in regular Rails cache to minimize db load.

=== WHAT I DID

I created the model Setting with two attributes: Name and Value. Name and value are required and name must be unique. 

I decided to let processing value types to the script not the user. So user just add name and value as a string("Some string", "34", "34.6", or "true").

I created a method find_or_set(name, default_value), which returns a value of searched setting.
For example we created a setting with name: 'test_setting' and value: '365.987':

    @test_setting = Setting.find_or_set('test_setting') 

and this returns proper Float value for this setting: 
    
    > @test_setting
    => 365.987

And when we want to be sure that we will have always setting's value set, we can set a default_value for our method.

    @test_setting = Setting.find_or_set('test_setting', 'true') 

If test_setting does not exist, this call create new Setting with a name 'test_setting' and set a value to 'true' and it returns proper Boolean value:

    > @test_setting
    => true

I decided to use a regex to convert String to proper Class:

    def convert_to_right_class(value)
      if /^[-]?[\d]+([\.,][\d]+){0,1}$/ === value
        if /[\.,]/ === value
          return Float(value.gsub(",","."))
        else
          return Integer(value)
        end
      else
        return nil if value.nil? 
        return true if value == "true"
        return false if value == "false"
        return value
      end
    end

I think it's a cleaner way and very comfortable for a user, that he just add what he wants and doesn't have to think about it.  

I added Rails default caching to find_or_set method, so it set a value for the first time and then it loads a value from the cache. Every time I update a value in a db, it deletes a value from the cache.

=== TESTING

For testing I used default Rails test with shoulda and factory girl for fixtures.     
I covered:
    * unit tests for Setting model
    * basic controller tests for Settings controller
    * integration tests for add, update and delete flow

=== END

This task took me about 3 hours. 

