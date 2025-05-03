# Configure Active Model Serializers globally
ActiveModelSerializers.config.tap do |config|
  # Choose the JSON adapter
  # Options include:
  # - :json_api (recommended for JSON:API specification)
  # - :json (default JSON)
  # - :attributes (minimal serialization)
  config.adapter = :json_api

  # Control key transformations
  # Options: :unaltered, :camel_lower, :camel, :dash, :underscore
  config.key_transform = :camel_lower

  # Set default serializer for collections
  # config.collection_serializer = ActiveModel::Serializer::CollectionSerializer

  # Control rendering of null values
  config.json_key_format = :camel_lower

  # Optional: Set a default serializer for specific classes
  # config.default_serializer_for User, UserSerializer

  # Optional: Customize serialization of collections
  # config.collection_serializer = CustomCollectionSerializer

  # Control whether to include root keys
  # config.root_key_transform = :dash

  # Optional: Set a global pagination limit
  # config.page_size = 100

  # Optional: Custom serialization for specific types
  # config.serializer_lookup_enabled = true
end

# Optional: Add global serialization options
ActiveModel::Serializer.config.tap do |config|
  # Specify default includes
  # config.default_includes = '**'

  # Control serializer inheritance
  config.inheritance_enabled = true
end