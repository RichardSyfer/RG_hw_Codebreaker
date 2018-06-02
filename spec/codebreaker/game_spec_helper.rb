module Helper
  def cheking_code_algorithm(secret_code, guess)
    game.instance_variable_set(:@secret_code, secret_code.split('').map(&:to_i))
    game.code_check(guess)
  end
end
