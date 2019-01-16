module Myenv
  def stage
    ENV['STAGE']
  end

  def dev?
    stage == 'dev'
  end

  def test?
    stage == 'test'
  end

  def prod?
    stage == 'prod'
  end

  def staging?
    stage == 'staging'
  end

  extend self
end
