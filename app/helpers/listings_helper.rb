module ListingsHelper
  def disabled_sort_options(sorts, index)
    used_dimensions = sorts.each_with_index.filter_map do |sort, position|
      sort.sub(/_(low|high)\z/, "") unless position == index
    end
    ListingsController::SORT_OPTIONS.select do |sort|
      used_dimensions.include?(sort.sub(/_(low|high)\z/, ""))
    end
  end
end
