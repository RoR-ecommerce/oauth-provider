class Api::V1::UsersController < Api::V1::ApiController

  def me
    verify_access(nil) do |user|
      # the code will go here
      puts user.inspect
    end
  end

end
