# Currently, this only handles determining what month a song will run upon creation.
# Ex: If a song is added April 12, it is assumed it will run in May.
# (We can't assume it's the next month always though -- May 2024's first post date is May 6, so if we add a song May 1, that's still a May song.)
# If we go to a more frequent posting schedule this concern will do more.

require "active_support/concern"

module Schedulable
  extend ActiveSupport::Concern
  
  # default argument is for test purposes
  def self.current_posting_month(today = Date.today)
    # todo: see whether ActiveSupport can simplify this mess more
    second_monday = self.first_monday_of_month(today).next_week
    posting_month = today >= second_monday ? today.next_month : today
    posting_year = today.month == 12 && posting_month.month == 1 ? today.next_year.year : today.year
    self.month_name(posting_month) + " " + posting_year.to_s
  end

  def self.next_posting_month(today = Date.today)
    first_monday = self.first_monday_of_month(today)
    posting_month = today > first_monday ? today.next_month : today
    posting_year = today.month == 12 && posting_month.month == 1 ? today.next_year.year : today.year
    self.month_name(posting_month) + " " + posting_year.to_s
  end
  
  private
  
  def self.first_monday_of_month(day)
    day_one = day.beginning_of_month
    day_one += 1.days until day_one.wday == 1
    day_one
  end
  
  def self.month_name(date)
    Date::MONTHNAMES[date.month]
  end

end