module UsersHelper

  # The Rails framework provides a large number of helpers for
  # working with assets, dates, forms, numbers and model objects,
  # to name a few. These helpers are available to all templates
  # by default.

  # In addition to using the standard template helpers provided,
  # creating custom helpers to extract complicated logic or reusable
  # functionality is strongly encouraged. By default, each controller
  # will include all helpers. These helpers are only accessible on
  # the controller through #helpers

  # Use helpers if you're working in a view (template) and you need to
  # build a complex bit of HTML such as a <table>. Or, if you want to
  # change some presentation data that's not connected to the database.
  # Use models when you're working with database objects, and you want to
  # simplify the business logic.


  # Returns the Gravatar for the given user.
  def gravatar_for(user, options = { size: 80 })
    gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    size = options[:size]
    gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    image_tag(gravatar_url, alt: user.name, class: "gravatar")
  end
end