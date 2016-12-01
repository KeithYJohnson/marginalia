require 'net/http'
require 'csv'
require 'pry-byebug'

class Admissions
  FILE_URI = 'http://www.calvin.edu/~stob/data/Berkeley.csv'

  attr_accessor :file, :csv, :total_females, :total_males, :males_rejected, :females_rejected, :males_admitted, :females_admitted

  def initialize
    self.total_males = 0
    self.total_females = 0
    self.females_rejected = 0
    self.males_rejected = 0
    self.males_admitted = 0
    self.females_admitted = 0
  end

  def perform
    get_file
    convert_to_csv
    do_stats
    puts_stats
  end

  def get_file
    uri = URI(FILE_URI)
    self.file = Net::HTTP.get(uri)
  end

  def convert_to_csv
    self.csv = CSV.parse(file, headers: true)
  end

  def do_stats
    csv.each do |row|
      if row['Admit'] == 'Admitted' && row['Gender'] == 'Male'
        self.total_males += row['Freq'].to_i
        self.males_admitted += row['Freq'].to_i
      end
      if row['Admit'] == 'Rejected' && row['Gender'] == 'Male'
        self.total_males += row['Freq'].to_i
        self.males_rejected += row['Freq'].to_i
      end
      if row['Admit'] == 'Rejected' && row['Gender'] == 'Female'
        self.total_females += row['Freq'].to_i
        self.females_rejected += row['Freq'].to_i
      end
      if row['Admit'] == 'Admitted' && row['Gender'] == 'Female'
        self.total_females += row['Freq'].to_i
        self.females_admitted += row['Freq'].to_i
      end
    end
  end

  def puts_stats
    puts "HEY"
    puts "f %: #{females_admitted.to_f/total_females.to_f}"
    puts "m %: #{males_admitted.to_f/total_males.to_f}"
  end
end

Admissions.new.perform
