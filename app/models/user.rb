class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :omniauthable, :omniauth_providers => [:fitbit, :jawbone]
  #  devise :omniauthable, :omniauth_providers => [:jawbone]

  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable


  validates_presence_of :first_name, :last_name

  has_attached_file :avatar, :styles => { :medium => "400x400>", :thumb => "100x100#" }, :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :avatar, :content_type => /\Aimage\/.*\Z/

  geocoded_by :address, :latitude  => :lat, :longitude => :lng # ActiveRecord

  has_many :sent_invites, class_name: "Relationship", foreign_key: :inviting_id
  has_many :received_invites, class_name: "Relationship", foreign_key: :invited_id

  has_many :invited_users, through: :sent_invites, source: :invited_user
  has_many :inviting_users, through: :received_invites, source: :inviting_user

  has_and_belongs_to_many :circles
  has_many :maps

  has_many :data_objs
  has_many :comments

  has_one :service
  # has_many :trackers, :through => :service
  has_many :trackers

  # SCOPES
  scope :users_between_age, ->(age_from, age_to) {
    min_age = Date.today - age_from.to_i.years
    max_age = Date.today - age_to.to_i.years
    min_age = min_age.end_of_year
    max_age = max_age.beginning_of_year

    return User.where("date_of_birth > ? AND date_of_birth < ?", max_age.to_date, min_age.to_date)
  }


  def address
    [city, country].compact.join(', ')
  end


  def updateLocation(request)
    @location = request.location
    puts @location
    user = self

    if(@location.present?)
      user.lat = @location.latitude
      user.lng = @location.longitude
      user.city = @location.city
      user.country = @location.country
      user.save
      puts @location.city
      puts request.remote_ip()
    end
  end

  def calculate_age
    (Date.today - self.date_of_birth.to_date).to_i / 365
  end

  # Synchronize datas from user
  def sync_datas_process
    SyncDatas.sync(self)
    # user = self
  end

  def is_following(invited_user)
    return Relationship.exists?(inviting_id: self, invited_id: invited_user)
  end

  # Returns a hash that contain all supported metrics from all differents trackers
  def supported_metrics
    supported_metrics = Set.new
    self.trackers.all.each do |tracker|
      metrics = tracker.tracker_type.data_type
      metrics.each do |metric|
        supported_metrics.add?(metric)
      end
    end
    return supported_metrics
  end


  # Returns a hash that contain all metrics supported by a group of users
  def self.group_supported_metrics(users)
    supported_metrics = Array.new

    users.each do |user|
      user.trackers.all.each do |tracker|
        metrics = tracker.tracker_type.data_type
        metrics.each do |metric|
          supported_metrics.push(metric)
        end
      end
    end

    h = Hash.new(0)
    supported_metrics.each { | v | h.store(v, h[v]+1) }

    s = Set.new
    h.each do | k, v |
      if(v > 1)
        s.add?(k)
      end
    end

    return s
  end


  private

  def self.from_omniauth(auth)

    # Find Service type
    serviceType = ServiceType.where(name: auth.provider).first()
    # Find user service
    service = Service.where(service_type_id: serviceType, uid: auth.uid).first
    if(service.present?)
      return User.find(service.user_id)
    else
      return User.new
    end
  end

  def self.new_with_session(params, session)

    super.tap do |user|

      # FITBIT session creator
      if data = session["devise.fitbit_data"]
        full_name = data["info"]['full_name'].split(/ /)
        user.first_name = full_name[0] if user.first_name.blank?
        user.last_name = full_name[1] if user.last_name.blank?
        user.is_female = if (data["info"]['gender'] == 'MALE') then 0 else 1 end
        user.is_female = if (data["info"]['gender'] == 'MALE') then 0 else 1 end
        user.date_of_birth = data["info"]['dob'] if user.date_of_birth.blank?
        user.avatar = data['avatar']

        service = Service.new
        #service.name = data["provider"]
        service.uid = data["uid"]
        service.oauth_token = data["credentials"]['token']
        service.oauth_secret = data["credentials"]['secret']

        service.service_type = ServiceType.where(name: data["provider"]).first
        user.service = service

      end
    end
  end
end