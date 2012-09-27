module AdvertSelectorHelper

  def advert_selector_targeting_age?(age_string)
    age_string == 'adult'
    #age_string == 'senior'
  end

  def advert_selector_raise_error(placement)
    1/0
  end

  def advert_selector_leaderboard_testing(placement)
    content_for(:content_test) do
      "advert_selector_leaderboard_testing_content"
    end
    return true
  end

  def advert_selector_always_false(placement)
    return false
  end

end
