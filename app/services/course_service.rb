class CourseService
  include HTTParty
  base_uri 'content.osu.edu/v2/classes/'

  def self.fetch_classes(search_params = {})
    courses = []
    default_params = { q: 'cse', client: 'class-search-ui', campus: 'col', term: '1244', academic_career: 'ugrad', subject: 'cse', class_attribute: 'ge2' }
    query_params = default_params.merge(search_params)

    response = get('/search', query: query_params)
    return handle_error(response) unless response.success?

    data = JSON.parse(response.body)['data']
    data['courses'].each do |course_data|
      course = create_or_find_course(course_data['course'])
      courses << course
      create_sections(course.id, course_data['sections'])
    end

    { courses: courses }
  end

  def self.create_or_find_course(course_data)
    Course.find_or_create_by(
      term: course_data['term'],
      title: course_data['title'],
      description: course_data['description'],
      subject: course_data['subject'],
      catalog_number: course_data['catalogNumber'],
      campus: course_data['campus'],
      course_id: course_data['courseId']
    )
  end

  def self.create_sections(course_id, sections_data)
    sections_data.each do |section_data|
      meeting_data = section_data['meetings'].first
      section_attributes = {
        section_number: section_data['classNumber'].to_i,
        component: section_data['component'],
        instruction_mode: section_data['instructionMode'],
        building_description: meeting_data['buildingDescription'],
        start_time: meeting_data['startTime'],
        end_time: meeting_data['endTime'],
        start_date: section_data['startDate'],
        end_date: section_data['endDate'],
        monday: false,
        tuesday: false,
        wednesday: false,
        thursday: false,
        friday: false,
        saturday: false,
        sunday: false,
        required_graders: 1,
        course_id: course_id
      }

      section_data['meetings'].each do |meeting|
        %w[monday tuesday wednesday thursday friday saturday sunday].each do |day|
          section_attributes[day] ||= meeting[day]
        end
      end

      Section.create(section_attributes)
    end
  end

  def self.handle_error(response)
    puts "Error: #{response.code} - #{response.message}"
    { error: "Error: #{response.code} - #{response.message}" }
  end
end
