class CreateMicroposts < ActiveRecord::Migration


  # the generate command produces a migration
  # that creates a microposts table over here.
  # Due to the use of references , user_id column (index & foreign key)
  # is assigned which creates a relation between a user and a micropost.


  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end

    # To retrieve all microposts associated with a user-id in reverse
    # order of creation, the line below adds an index on the user_id
    # and created_at columns. By doing this both the user_id & created_at
    # columns as an array, we arrange for Rails to create a multiple key index,
    # which means that Active Record uses both keys at the same time.

    add_index :microposts, [:user_id, :created_at]
  end
end
