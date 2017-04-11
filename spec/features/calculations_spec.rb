require "rails_helper"

RSpec.describe "Calculation", type: :feature do
  feature "Word Count simple" do
    it "parrots back the submitted text",
      points: 1,
      hint: "This test should pass right away." do

      visit "/word_count/new"

      fill_in "Text",
        with: "the first draft is just you telling yourself the story"

      fill_in "Special Word (optional)",
        with: "the"

      click_button "Submit"

      expect(page).to have_css("dd#text", text: "the first draft is just you telling yourself the story")
    end

    it "displays the word count",
      points: 16,
      hint: "Any contiguous chunk of non-whitespace characters counts as a \"word\". \"Whitespace characters\" include newlines (`\\n`), tabs (`\\t`), carriage returns (`\\r`), etc.

`String` has a handy method called [split](https://apidock.com/ruby/String/split) that might help with all this; experiment with it in `rails console`!" do

      visit "/word_count/new"

      fill_in "Text",
        with: "the first draft is just you telling yourself the story"

      click_button "Submit"

      expect(page).to have_css("dd#word_count", text: 10)
    end

    it "displays the character count with spaces",
      points: 4,
      hint: "Don't count newlines (`\\n`) or carriage returns (`\\r`) at the end of the string (this is only an issue depending on certain users' browsers). [`String` has a `.chomp` method](https://apidock.com/ruby/String/chomp) that is perfect for taking care of these pesky trailing characters." do

      visit "/word_count/new"

      fill_in "Text",
        with: "the first draft is just you telling yourself the story"

      click_button "Submit"

      expect(page).to have_css("dd#character_count_with_spaces", text: 54)
    end

    it "displays the character count without spaces",
      points: 12,
      hint: "To remove characters that appear in places other than at the end of a `String`, `.chomp` won't do. Instead, try out the `.gsub` method in `rails console`:

```ruby
\"well hello!\".gsub(\"ll\", \"✌️\")
```

Don't forget to remove _all_ sorts of whitespace from the string, including newlines (`\\n`), tabs (`\\t`), and carriage returns (`\\r`)." do

      visit "/word_count/new"

      fill_in "Text",
        with: "the first draft is just you telling yourself the story"

      click_button "Submit"

      expect(page).to have_css("dd#character_count_without_spaces", text: 45)
    end

    it "displays count of the special word occurrences",
      points: 16,
      hint: "[Ruby Count vs Length vs Size](https://rubyinrails.com/2014/01/15/ruby-count-vs-length-vs-size/)" do

      visit "/word_count/new"

      fill_in "Text",
        with: "the first draft is just you telling yourself the story"

      fill_in "Special Word (optional)",
        with: "the"

      click_button "Submit"

      expect(page).to have_css("dd#occurrences", text: 2)
    end
  end

  feature "Word Count with mixed case" do
    it "displays the word count", points: 1 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you telling yourself the story"

      click_button "Submit"

      expect(page).to have_css("dd#word_count", text: 10)
    end

    it "displays the character count with spaces", points: 1 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you telling yourself the story"

      click_button "Submit"

      expect(page).to have_css("dd#character_count_with_spaces", text: 54)
    end

    it "displays the character count without spaces",
      points: 1,
      hint: "Eventually, `gsub`bing every possible whitespace character one by one becomes impractical. However, `gsub` can also accept a **regular expression** as its first argument.

[Regular expressions](https://regexone.com/), or \"regexes\", are a very powerful way to search for _patterns_ within strings, and are almost a whole programming language unto themselves. In Ruby, regexes are wrapped in forward slashes, the way strings are wrapped in quotes.

We don't need to spend time learning regexes right now, but if you ever find yourself needing to detect particular _patterns_ within strings, then let them ring a bell. For now, the regex `/\\s+/` matches one or more contiguous whitespace characters. So, try something like

```ruby
@text.gsub(/\\s+/, \"\")
```

to strip out all whitespace before doing your other processing." do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you telling yourself the story"

      click_button "Submit"

      expect(page).to have_css("dd#character_count_without_spaces", text: 45)
    end

    it "displays count of the special word occurrences", points: 4 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you telling yourself the story"

      fill_in "Special Word (optional)",
        with: "the"

      click_button "Submit"

      expect(page).to have_css("dd#occurrences", text: 2)
    end
  end

  feature "Word Count with punctuation" do
    it "displays the word count", points: 1 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you telling yourself the story."

      click_button "Submit"

      expect(page).to have_css("dd#word_count", text: 10)
    end

    it "displays the character count with spaces", points: 1 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you telling yourself the story."

      click_button "Submit"

      expect(page).to have_css("dd#character_count_with_spaces", text: 55)
    end

    it "displays the character count without spaces", points: 1 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you telling yourself the story."

      click_button "Submit"

      expect(page).to have_css("dd#character_count_without_spaces", text: 46)
    end

    it "displays count of the special word occurrences",
      points: 4,
      hint: "Eventually, `gsub`bing every possible punctuation character one by one becomes impractical. However, `gsub` can also accept a **regular expression** as its first argument.

[Regular expressions](https://regexone.com/), or \"regexes\", are a very powerful way to search for _patterns_ within strings, and are almost a whole programming language unto themselves. In Ruby, regexes are wrapped in forward slashes, the way strings are wrapped in quotes.

We don't need to spend time learning regexes right now, but if you ever find yourself needing to detect particular _patterns_ within strings, then let them ring a bell. For now, the regex `/[^a-z0-9\\s]/i` rejects any letter or digit. So, try something like

```ruby
@text.gsub(/[^a-z0-9\\s]/i, \"\")
```

to strip out all punctuation before doing your other processing." do

      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you telling yourself the story."

      fill_in "Special Word (optional)",
        with: "story"

      click_button "Submit"

      expect(page).to have_css("dd#occurrences", text: 1)
    end
  end

  describe "Word Count with newlines" do
    it "displays the word count", points: 1 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you\ntelling yourself the story.\n"

      fill_in "Special Word (optional)",
        with: "story"

      click_button "Submit"

      expect(page).to have_css("dd#word_count", text: 10)
    end

    it "displays the character count with spaces", points: 1 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you\rtelling yourself the story.\n"

      click_button "Submit"

      expect(page).to have_css("dd#character_count_with_spaces", text: 55)
    end

    it "displays the character count without spaces", points: 1 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you\ntelling yourself the story.\n"

      click_button "Submit"

      expect(page).to have_css("dd#character_count_without_spaces", text: 46)
    end

    it "displays count of the special word occurrences", points: 4 do
      visit "/word_count/new"

      fill_in "Text",
        with: "The first draft is just you\ntelling yourself the story.\n"

      fill_in "Special Word (optional)",
        with: "story"

      click_button "Submit"

      expect(page).to have_css("dd#occurrences", text: 1)
    end
  end

  describe "Loan Payment simple" do
    before do
      visit "/loan_payment/new"
      fill_in "annual_percentage_rate", with: 4.5
      fill_in "number_of_years", with: 30
      fill_in "principal_value", with: 50000
      click_button "Submit"
    end

    it "displays the submitted APR", points: 1 do
      expect(page).to have_content "4.5%"
    end

    it "displays the submitted number of years", points: 1 do
      expect(page).to have_content 30
    end

    it "displays the submitted principal", points: 1 do
      expect(page).to have_content "$50,000"
    end

    it "displays the calculated monthly payments", points: 32 do
      expect(page).to have_content "$253.34"
    end
  end

  describe "Time Between simple" do
    before do
      visit "/time_between/new"
      fill_in "starting_time", with: "04/16/2015 4:00 PM"
      fill_in "ending_time", with: "04/17/2015 4:02 PM"
      click_button "Submit"
    end

    it "displays the starting time", points: 1 do
      expect(page).to have_content "4:00pm"
      expect(page).to have_content "April 16, 2015"
    end

    it "displays the ending time", points: 1 do
      expect(page).to have_content "4:02pm"
      expect(page).to have_content "April 17, 2015"
    end

    it "displays the seconds between", points: 18 do
      expect(page).to have_content "86520"
    end

    it "displays the minutes between", points: 3 do
      expect(page).to have_content "1442"
    end

    it "displays the hours between", points: 3 do
      expect(page).to have_content "24.0333"
    end

    it "displays the days between", points: 3 do
      expect(page).to have_content "1.0013"
    end

    it "displays the weeks between", points: 3 do
      expect(page).to have_content "0.1430"
    end

    it "displays the years between", points: 3 do
      expect(page).to have_content "0.0027"
    end
  end

  describe "Descriptive Statistics simple" do
    before do
      visit "/descriptive_statistics/new"
      fill_in "list_of_numbers", with: "10 1 2 3 4 5 6 7 8 8 9"
      click_button "Submit"
    end

    it "parrots back the submitted numbers as an array", points: 1 do
      expect(page).to have_css("dd#numbers", text: [10.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 8.0, 9.0])
    end

    it "displays the numbers as a sorted array", points: 4 do
      expect(page).to have_css("dd#sorted_numbers", text: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 8.0, 9.0, 10.0])
    end

    it "displays the count of numbers", points: 4 do
      expect(page).to have_css("dd#count", text: 11)
    end

    it "displays the lowest number", points: 4 do
      expect(page).to have_css("dd#minimum", text: 1.0)
    end

    it "displays the highest number", points: 4 do
      expect(page).to have_css("dd#maximum", text: 10.0)
    end

    it "displays the range between the lowest and highest numbers", points: 8 do
      expect(page).to have_css("dd#range", text: 9.0)
    end

    it "displays the median of the numbers", points: 12 do
      expect(page).to have_css("dd#median", text: 6.0)
    end

    it "displays the sum of the numbers", points: 5 do
      expect(page).to have_css("dd#sum", text: 63.0)
    end

    it "displays the mean of the numbers", points: 8 do
      expect(page).to have_css("dd#mean", text: 5.72)
    end

    it "displays the variance of the numbers", points: 24 do
      expect(page).to have_css("dd#variance", text: 8.01)
    end

    it "displays the standard deviation of the numbers", points: 8 do
      expect(page).to have_css("dd#standard_deviation", text: 2.83)
    end

    it "displays the mode of the numbers", points: 8 do
      expect(page).to have_css("dd#mode", text: 8.0)
    end
  end

  describe "Descriptive Statistics with even number of elements" do
    before do
      visit "/descriptive_statistics/new"
      fill_in "list_of_numbers", with: "10 1 2 3 4 5 6 7 8 8"
      click_button "Submit"
    end

    it "displays the numbers as a sorted array", points: 1 do
      expect(page).to have_css("dd#sorted_numbers", text: [1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 8.0, 10.0])
    end

    it "displays the count of numbers", points: 1 do
      expect(page).to have_css("dd#count", text: 10)
    end

    it "displays the lowest number", points: 1 do
      expect(page).to have_css("dd#minimum", text: 1.0)
    end

    it "displays the highest number", points: 1 do
      expect(page).to have_css("dd#maximum", text: 10.0)
    end

    it "displays the range between the lowest and highest numbers", points: 1 do
      expect(page).to have_css("dd#range", text: 9.0)
    end

    it "displays the median of the numbers", points: 9 do
      expect(page).to have_css("dd#median", text: 5.5)
    end

    it "displays the sum of the numbers", points: 1 do
      expect(page).to have_css("dd#sum", text: 54.0)
    end

    it "displays the mean of the numbers", points: 1 do
      expect(page).to have_css("dd#mean", text: 5.4)
    end

    it "displays the variance of the numbers", points: 1 do
      expect(page).to have_css("dd#variance", text: 7.64)
    end

    it "displays the standard deviation of the numbers", points: 1 do
      expect(page).to have_css("dd#standard_deviation", text: 2.76)
    end

    it "displays the mode of the numbers", points: 5 do
      expect(page).to have_css("dd#mode", text: 8.0)
    end
  end
end
