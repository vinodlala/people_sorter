require 'date'

class PeopleSorter

  class << self

    def sort_by_gender_asc_last_name_asc(input_directory, output_file_name)
      main_array = read_all_files(input_directory)
      output_file = File.open(output_file_name, "w")
      gender_last_name_asc_array = main_array.sort_by { |hsh| [hsh[:gender], hsh[:last_name]] }
      gender_last_name_asc_array.each do |hsh|
        output_file.puts [hsh[:last_name],
                          hsh[:first_name],
                          hsh[:gender],
                          hsh[:birth_date].strftime("%-m/%-d/%Y"),
                          hsh[:favorite_color]].join(" ")
      end
      output_file.close
    end

    def sort_by_birth_date_asc(input_directory, output_file_name)
      main_array = read_all_files(input_directory)
      output_file = File.open(output_file_name, "w")
      birth_date_asc_array = main_array.sort_by { |hsh| [hsh[:birth_date], hsh[:last_name]] }
      birth_date_asc_array.each do |hsh|
        output_file.puts [hsh[:last_name],
                          hsh[:first_name],
                          hsh[:gender],
                          hsh[:birth_date].strftime("%-m/%-d/%Y"),
                          hsh[:favorite_color]].join(" ")
      end
      output_file.close
    end

    def sort_by_last_name_desc(input_directory, output_file_name)
      main_array = read_all_files(input_directory)
      output_file = File.open(output_file_name, "w")
      last_name_desc_array = main_array.sort_by { |hsh| hsh[:last_name] }.reverse
      last_name_desc_array.each do |hsh|
        output_file.puts [hsh[:last_name],
                          hsh[:first_name],
                          hsh[:gender],
                          hsh[:birth_date].strftime("%-m/%-d/%Y"),
                          hsh[:favorite_color]].join(" ")
      end
      output_file.close
    end

    def read_all_files(input_directory)
      main_array = []
      %w(comma pipe space).each do |delimiter|
        eval("read_#{delimiter}_delimited(main_array, '#{input_directory}/#{delimiter}_delimited.txt')")
      end
      main_array
    end

    def read_comma_delimited(main_array, file_name)
      File.open(file_name).readlines.each do |line|
        arr = line.split(", ")
        hsh = {}
        hsh[:last_name] = arr[0]
        hsh[:first_name] = arr[1]
        hsh[:gender] = determine_gender(arr[2])
        hsh[:favorite_color] = arr[3]
        date_array = arr[4].split("/")
        hsh[:birth_date] = create_date_object(date_array)
        main_array << hsh
      end
      main_array
    end

    def read_pipe_delimited(main_array, file_name)
      File.open(file_name).readlines.each do |line|
        arr = line.split(" | ")
        hsh = {}
        hsh[:last_name] = arr[0]
        hsh[:first_name] = arr[1]
        hsh[:gender] = determine_gender(arr[3])
        hsh[:favorite_color] = arr[4]
        date_array = arr[5].split("-")
        hsh[:birth_date] = create_date_object(date_array)
        main_array << hsh
      end
      main_array
    end

    def read_space_delimited(main_array, file_name)
      File.open(file_name).readlines.each do |line|
        arr = line.split(" ")
        hsh = {}
        hsh[:last_name] = arr[0]
        hsh[:first_name] = arr[1]
        hsh[:gender] = determine_gender(arr[3])
        hsh[:favorite_color] = arr[5]
        date_array = arr[4].split("-")
        date_month = date_array[0].to_i
        date_day = date_array[1].to_i
        date_year = date_array[2].to_i
        hsh[:birth_date] = Date.new(date_year, date_month, date_day)
        main_array << hsh
      end
      main_array
    end

    def determine_gender(gender)
      (gender == 'M' || gender == 'Male') ? 'Male' : 'Female'
    end

    def create_date_object(date_array)
      date_month = date_array[0].to_i
      date_day = date_array[1].to_i
      date_year = date_array[2].to_i
      Date.new(date_year, date_month, date_day)
    end

  end

end

describe PeopleSorter do

  before (:all) do

    ["./actual_files/actual_gender_asc_last_name_asc.txt",
     './actual_files/actual_birth_date_asc.txt',
     './actual_files/actual_last_name_desc.txt'].each do |f|
      FileUtils.rm(f) if File.exists?(f)
    end

    # puts "Dir.exist?('./actual_files/') is"
    # puts Dir.exist?('./actual_files/')
    unless Dir.exist?('./actual_files/')
      FileUtils.mkdir_p('./actual_files/')
    end
    # puts "Dir.exist?('./actual_files/') is"
    # puts Dir.exist?('./actual_files/')

  end


  it "should sort people by gender ascending (female then male), then by last name ascending" do
    PeopleSorter.sort_by_gender_asc_last_name_asc("./input_files", "./actual_files/actual_gender_asc_last_name_asc.txt")
    actual_output_file = File.open("./actual_files/actual_gender_asc_last_name_asc.txt", "r")
    actual_output_contents = actual_output_file.read
    expected_output_file = File.open("./expected_files/expected_gender_asc_last_name_asc.txt", "r")
    expected_output_contents = expected_output_file.read
    actual_output_contents.should == expected_output_contents
  end

  it "should sort people by birth date ascending" do
    PeopleSorter.sort_by_birth_date_asc("./input_files", "./actual_files/actual_birth_date_asc.txt")
    actual_output_file = File.open("./actual_files/actual_birth_date_asc.txt", "r")
    actual_output_contents = actual_output_file.read
    expected_output_file = File.open("./expected_files/expected_birth_date_asc.txt", "r")
    expected_output_contents = expected_output_file.read
    actual_output_contents.should == expected_output_contents
  end

  it "should sort people by last name descending" do
    PeopleSorter.sort_by_last_name_desc("./input_files", "./actual_files/actual_last_name_desc.txt")
    actual_output_file = File.open("./actual_files/actual_last_name_desc.txt", "r")
    actual_output_contents = actual_output_file.read
    expected_output_file = File.open("./expected_files/expected_last_name_desc.txt", "r")
    expected_output_contents = expected_output_file.read
    actual_output_contents.should == expected_output_contents
  end

end
