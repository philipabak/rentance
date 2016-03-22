class Geolocation < ActiveRecord::Base
  has_many :listings, dependent: :destroy

  validates :latitude, presence: true, numericality: true
  validates :longitude, presence: true, numericality: true

  strip_attributes

  before_save :before_save

  CLUSTER_LEVELS = [[6, 12], [3, 3], [3, 3], [3, 3], [3, 3], [3, 3], [3, 3], [3, 3], [3, 3]]

  def direction_url; "//maps.google.com/?daddr=#{self.latitude},#{self.longitude}" end

  def self.geomarkers(params)
    opts = {}
    conditions = []
    group_by = cluster = 'geo.id'

    if params[:age].present?
      opts[:from_date] = Time.now - params[:age].to_i.day
      conditions << 'listing.published_at >= :from_date'
    end

    if params[:zoom].present?
      cluster_level = zoom_to_cluster_level(params[:zoom])

      if params[:bounds_lat].present? && params[:bounds_lng].present?
        clustered_lat, clustered_lng = clustered_bounds(
            params[:bounds_lat].map{ |l| l.to_f },
            params[:bounds_lng].map{ |l| l.to_f },
            cluster_level
        )

        if clustered_lat
          opts[:bounds_lat_0], opts[:bounds_lat_1] = clustered_lat
          if opts[:bounds_lat_0]
            conditions << ':bounds_lat_0 <= geo.latitude'
          end
          if opts[:bounds_lat_1]
            conditions << 'geo.latitude < :bounds_lat_1'
          end
        end
        if clustered_lng
          opts[:bounds_lng_0], opts[:bounds_lng_1] = clustered_lng
          if opts[:bounds_lng_0] <= opts[:bounds_lng_1]
            conditions << ':bounds_lng_0 <= geo.longitude AND geo.longitude < :bounds_lng_1'
          else
            conditions << '(:bounds_lng_0 - 360.0 <= geo.longitude AND geo.longitude < :bounds_lng_1 OR
            :bounds_lng_0 <= geo.longitude AND geo.longitude < :bounds_lng_1 + 360.0)'
          end
        end
      end

      if cluster_level <= CLUSTER_LEVELS.count
        group_by = (1..cluster_level).to_a.map{ |i| "geo.cluster_level_#{i}" }.join(',')
        cluster = "CONCAT('_',#{group_by})"
      end
    end

    if params[:q].present? && params[:q].length >= Listing::SPHINX_MIN_QUERY_LENGTH
      opts[:listing_ids] = Listing.search_for_ids(
          params[:q],
          max_matches: Listing::SPHINX_MAX_MATCHES,
          per_page: Listing::SPHINX_MAX_MATCHES
      )
      conditions << 'listing.id IN (:listing_ids)'
    end

    query = "
        SELECT #{cluster} AS cluster, AVG(geo.latitude) AS latitude, AVG(geo.longitude) AS longitude, COUNT(listing.id) AS listings_count
        FROM #{table_name} geo
            JOIN #{Listing.table_name} listing ON listing.geolocation_id = geo.id
        #{conditions.present? ? "WHERE #{conditions.join(' AND ')}" : ''}
        GROUP BY #{group_by}"

    sql = send(:sanitize_sql_array, [query, opts])
    connection.select_all(sql)
  end

  def self.degrees_to_radians(degrees)
    degrees * Math::PI / 180
  end

  def self.zoom_to_cluster_level(zoom)
    [(zoom.to_i / 1.6).to_i, 1].max
  end

  private

  def before_save
    set_cluster_levels  if self.changed? || (1..CLUSTER_LEVELS.count).to_a.any?{ |i| self["cluster_level_#{i}".to_sym].blank? }
  end

  def set_cluster_levels
    lat = self.latitude + 90.0          # 0.0..180.0
    lng = self.longitude + 180.0        # 0.0..360.0
    max_lat, max_lng = [180.0, 360.0]

    CLUSTER_LEVELS.each_with_index do |cell_count, i|
      max_lat /= cell_count[0]
      max_lng /= cell_count[1]
      lat_cell = (lat / max_lat).to_i
      lng_cell = (lng / max_lng).to_i
      lat -= lat_cell * max_lat
      lng -= lng_cell * max_lng
      num = lat_cell * cell_count[1] + lng_cell

      self["cluster_level_#{i + 1}".to_sym] =
          if num < 29
            (num + 65).chr
          elsif num < 58
            (num + 68).chr
          else
            (num - 16).chr
          end
    end
  end

  def self.clustered_bounds(bounds_lat, bounds_lng, cluster_level)
    if cluster_level > CLUSTER_LEVELS.count
      clustered_lat, clustered_lng = [bounds_lat, bounds_lng]
    else
      lat_cell_count, lng_cell_count =
          CLUSTER_LEVELS.first(cluster_level).inject([1, 1]) do |arr, l|
            [arr[0] * l[0], arr[1] * l[1]]
          end
      lat_cell_size = 180.0 / lat_cell_count
      lng_cell_size = 360.0 / lng_cell_count
      clustered_lat = [
          (bounds_lat[0] / lat_cell_size).floor * lat_cell_size,
          (bounds_lat[1] / lat_cell_size).ceil * lat_cell_size
      ]
      clustered_lng = [
          (bounds_lng[0] / lng_cell_size).floor * lng_cell_size,
          (bounds_lng[1] / lng_cell_size).ceil * lng_cell_size
      ]
    end

    if clustered_lat[0] <= -89 && clustered_lat[1] >= 89
      clustered_lat = nil
    elsif clustered_lat[0] <= -89
      clustered_lat[0] = nil
    elsif clustered_lat[1] >= 89
      clustered_lat[1] = nil
    end

    if (clustered_lng[1] - clustered_lng[0]) * (bounds_lng[1] - bounds_lng[0]) <= 0 ||
        (clustered_lng[0] == -180 && clustered_lng[1] == 180)
      clustered_lng = nil
    end
    [clustered_lat, clustered_lng]
  end
end
