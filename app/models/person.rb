class Person < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  include ParseDataRows

  belongs_to :party

  has_many :assets_declarations, dependent: :destroy
  has_many :activities_declarations, dependent: :destroy

  validates :name,   presence: true
  validates :role,   presence: true

  scope :sorted_for_display, -> { order(:councillor_code) }
  scope :councillors, -> { where.not(councillor_code: nil) }

  after_initialize :initialize_profile

  def councillor?
    councillor_code.present?
  end

  def studies
    parse_data_rows(profile, :studies)
  end

  def studies_comment
    profile['studies_comment']
  end

  def studies_comment=(comment)
    profile['studies_comment'] = comment
  end

  def courses
    parse_data_rows(profile, :courses)
  end

  def courses_comment
    profile['courses_comment']
  end

  def courses_comment=(comment)
    profile['courses_comment'] = comment
  end

  def languages
    parse_data_rows(profile, :languages)
  end

  def public_jobs
    parse_data_rows(profile, :public_jobs)
  end

  def private_jobs
    parse_data_rows(profile, :private_jobs)
  end

  def career_comment
    profile['career_comment']
  end

  def career_comment=(comment)
    profile['career_comment']= comment
  end

  def political_posts
    parse_data_rows(profile, :political_posts)
  end

  def political_posts_comment
    profile['political_posts_comment']
  end

  def political_posts_comment=(comment)
    profile['political_posts_comment']= comment
  end

  def publications
    profile['publications']
  end

  def publications=(pub)
    profile['publications']=pub
  end

  def special_mentions
    profile['special_mentions']
  end

  def special_mentions=(mentions)
    profile['special_mentions']= mentions
  end

  def teaching_activity
    profile['teaching_activity']
  end

  def teaching_activity=(activity)
    profile['teaching_activity']=activity
  end

  def other
    profile['other']
  end

  def other=(o)
    profile['other']= o
  end

  def add_study(description, entity, start_year, end_year)
    add_item('studies', description, entity, start_year, end_year)
  end

  def add_course(description, entity, start_year, end_year)
    add_item('courses', description, entity, start_year, end_year)
  end

  def add_public_job(description, entity, start_year, end_year)
    add_item('public_jobs', description, entity, start_year, end_year)
  end

  def add_private_job(description, entity, start_year, end_year)
    add_item('private_jobs', description, entity, start_year, end_year)
  end

  private

    def initialize_profile
      self.profile ||= {}
    end

    def add_item(collection, description, entity, start_year, end_year)
      return unless description.present?
      self.profile[collection] ||= []
      self.profile[collection] << {description: description, entity: entity, start_year: start_year, end_year: end_year}
    end


end
