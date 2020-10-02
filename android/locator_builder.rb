require 'xpath'

module Android
  module Locator
    class LocatorBuilder
      def initialize
        @strategies = []
        reset_current_strategy
      end

      def id(id = nil)
        @current_strategy[:attributes] << :id

        if id
          resolve_current_strategy_with(value: [id])
        end
        self
      end

      def class(clazz)
        @strategies << { by: :class, value: clazz }
        self
      end

      def content_desc(desc = nil)
        @current_strategy[:attributes] << :content_desc

        if desc
          resolve_current_strategy_with(value: [desc])
        end
        self
      end

      def text(text = nil)
        @current_strategy[:attributes] << :text

        if text
          resolve_current_strategy_with(value: [text])
        end
        self
      end

      def last
        @strategies << { by: :last }
        self
      end

      def index(index)
        @strategies << { by: :index, value: index }
        self
      end

      def descendant
        @strategies << { by: :descendant }
        self
      end

      def child
        @strategies << { by: :child }
        self
      end

      def sibling
        @strategies << { by: :sibling }
        self
      end

      def parent
        @strategies << { by: :parent }
        self
      end

      def contains(text)
        raise('Invalid use of contains in builder. There should be proceeding attribute') if @current_strategy[:attributes] == []

        @current_strategy[:predicate] = :contains
        resolve_current_strategy_with(value: [text])
        self
      end

      def contains_one_of(values)
        raise('Invalid use of contains_one_of in builder. There should be proceeding attribute') if @current_strategy[:attributes] == []

        resolve_current_strategy_with(value: [*values])
        self
      end

      def one_of(values)
        raise('Invalid use of one_of in builder. There should be proceeding attribute') if @current_strategy[:attributes] == []

        resolve_current_strategy_with(value: [*values])
        self
      end

      def begins_with(text)
        raise('Invalid use of contains in builder. There should be proceeding attribute') if @current_strategy[:attributes] == []

        @current_strategy[:predicate] = :begins_with
        resolve_current_strategy_with(value: [text])
        self
      end

      def ends_with(text)
        raise('Invalid use of contains in builder. There should be proceeding attribute') if @current_strategy[:attributes] == []

        @current_strategy[:predicate] = :ends_with
        resolve_current_strategy_with(value: [text])
        self
      end

      def matches(text)
        raise('Invalid use of contains in builder. There should be proceeding attribute') if @current_strategy[:attributes] == []

        resolve_current_strategy_with(value: [text])
        self
      end

      def or
        raise('Invalid use of or operator in builder. There should be proceeding attribute') if @current_strategy[:attributes] == []

        @current_strategy[:operator] = :or
        self
      end

      private

      def reset_current_strategy
        @current_strategy = { by: :attributes, attributes: [], predicate: :equals }
      end

      def resolve_current_strategy_with(value:)
        @current_strategy[:value] = value
        @strategies << @current_strategy
        reset_current_strategy
      end
    end

    class CalabashLocatorBuilder < LocatorBuilder
      PLACEHOLDER = '%s'
      attr_accessor :locator

      def last(_text)
        raise(NotImplementedError, 'Please implement the method last defined in base class and add support in build method')
      end

      def initialize
        @wildcard = true
        super
      end

      def all
        @strategies << { by: :all }
        self
      end

      def inner_locator(value)
        @strategies << { by: :inner_locator, value: value }
        self
      end

      def placeholder
        @strategies << { by: :placeholder }
        self
      end

      def one_of(values)
        @current_strategy[:predicate] = :like
        super
      end

      def contains_one_of(values)
        @current_strategy[:predicate] = :like_contains
        super
      end

      def matches(text)
        @current_strategy[:predicate] = :like
        super
      end

      def wildcard?
        @wildcard
      end

      def reset_wildcard
        @wildcard = false
      end

      def set_wildcard
        @wildcard = true
      end

      def build
        locators = []
        @strategies.each do |strategy|
          case strategy[:by]
            when :class
              locators << strategy[:value]
              reset_wildcard
            when :attributes
              locators << '*' if wildcard?
              locators << locator_for_strategy(strategy)
              reset_wildcard
            when :index
              locators << '*' if wildcard?
              locators << "index:#{strategy[:value]}"
              reset_wildcard
            when :descendant
              locators << '*' if wildcard?
              locators << 'descendant'
              set_wildcard
            when :child
              locators << '*' if wildcard?
              locators << 'child'
              set_wildcard
            when :sibling
              locators << '*' if wildcard?
              locators << 'sibling'
              set_wildcard
            when :parent
              locators << '*' if wildcard?
              locators << 'parent'
              set_wildcard
            when :all
              locators.insert(0, 'all')
              set_wildcard
            when :placeholder
              locators << PLACEHOLDER
            when :inner_locator
              locators << strategy[:value]
              reset_wildcard
            else
              raise("Strategy by #{strategy[:by]} is not yet supported")
          end
        end

        locators.join(' ')
      end

      private

      def locator_for_strategy(strategy)
        if strategy[:operator] == :or
          strategy[:attributes].each do |attr|
            unless [:id, :content_desc, :text].include?(attr)
              raise('For now only id, content_desc and text attributes are supported for "or" strategy in Calabash')
            end
          end

          strategy[:attributes] = [:marked]
        end

        attribute = strategy[:attributes].first
        value = value_for_predicate(strategy)

        case strategy[:predicate]
          when :begins_with
            "{#{attribute_name_from_key(attribute)} BEGINSWITH #{value}}"
          when :ends_with
            "{#{attribute_name_from_key(attribute)} ENDSWITH #{value}}"
          when :contains
            "{#{attribute_name_from_key(attribute)} CONTAINS #{value}}"
          when :like, :like_contains
            "{#{attribute_name_from_key(attribute)} LIKE #{value}}"
          when :equals
            "#{attribute_name_from_key(attribute)}:#{value}"
          else
            raise("Invalid predicate: #{strategy[:predicate]}")
        end
      end

      def value_for_predicate(strategy)
        values = strategy[:value]
        last_value = values.pop
        return "'#{last_value}'" if values == []

        last_value = "*#{last_value}*" if strategy[:predicate] == :like_contains
        expr = ''
        values&.each do |val|
          val = "*#{val}*" if strategy[:predicate] == :like_contains
          expr += "'#{val}'" + '|'
        end

        '(' + expr + "'#{last_value}')"
      end

      def attribute_name_from_key(key)
        case key
          when :content_desc
            :contentDescription
          else
            key
        end
      end
    end

    class AppiumLocatorBuilder < LocatorBuilder
      def initialize
        @xpath = XPath.anywhere
        reset_current_strategy
        super
      end

      def package(pack = nil)
        @current_strategy[:attributes] << :package

        if pack
          resolve_current_strategy_with(value: [pack])
        end
        self
      end

      # @deprecated Please use two separated methods "text" and "contains" instead
      def text_contains(text)
        BadooLogger.log.warn('Method "text_contains" is deprecated for Bumble, please use two separated methods "text" and "contains"')
        self.text.contains(text)
        self
      end

      def equals_ignore_case(text)
        raise('Invalid use of contains in builder. There should be proceeding attribute') if @current_strategy[:attributes] == []

        @current_strategy[:predicate] = :equals_ignore_case
        resolve_current_strategy_with(value: [text])
        self
      end

      def index(index)
        super(index + 1)
      end

      def one_of(values)
        @current_strategy[:operator] = :or
        super
      end

      def contains_one_of(values)
        @current_strategy[:predicate] = :contains
        @current_strategy[:operator] = :or
        super
      end

      def matches(_text)
        raise(NotImplementedError, 'Please implement the method matches defined in base class and add support in build method')
        # @current_strategy[:predicate] = :matches
        # super
      end

      def build
        if single_id_or_class_attribute?
          attribute = @strategies.first[:attributes].first
          value = @strategies.first[:value].first
          return { attribute => value }
        end

        @strategies.each do |strategy|
          case strategy[:by]
            when :attributes
              @xpath = @xpath[inner_bit_of_xpath_for_strategy(strategy)]
            when :class
              @xpath = @xpath[XPath.attr(:class) == strategy[:value]]
            when :last
              @xpath = @xpath[XPath.last]
            when :index
              @xpath = @xpath[strategy[:value]]
            when :descendant
              @xpath = @xpath.descendant
            when :child
              @xpath = @xpath.child
            when :parent
              @xpath = @xpath.parent
            else
              raise("Strategy by #{strategy[:by]} is not yet supported")
          end
        end

        { xpath: @xpath.to_xpath }
      end

      private

      def single_id_or_class_attribute?
        attributes = @strategies.first[:attributes]
        values = @strategies.first[:value]
        predicate = @strategies.first[:predicate]
        @strategies.count == 1 && attributes&.count == 1 && values&.count == 1 && [:id, :class].include?(attributes.first) && predicate == :equals
      end

      def attribute_name_from_key(key)
        case key
          when :id
            :'resource-id'
          when :content_desc
            :'content-desc'
          else
            key
        end
      end

      def inner_bit_of_xpath_for_strategy(strategy)
        predicate = strategy[:predicate]
        xpath_bits = []

        strategy[:attributes].each do |attribute|
          strategy[:value].each do |value|
            xpath_bits << xpath_bit(attribute: attribute, value: value, predicate: predicate)
          end
        end

        return xpath_bits.first if xpath_bits.size == 1

        unless strategy[:operator] == :or
          raise('For now only :or operator is supported')
        end

        first_two = xpath_bits.shift(2)
        seed = first_two[0].or(first_two[1])

        return seed if xpath_bits.empty?

        xpath_bits.inject(seed) do |s, n|
          s.or(n)
        end
      end

      def xpath_bit(attribute:, value:, predicate:)
        value_for_attribute = if attribute == :id && !value.include?('/') && predicate != :contains
                                "app:id/#{value}"
                              else
                                value
                              end

        case predicate
          when :begins_with
            XPath.attr(attribute_name_from_key(attribute)).starts_with(value_for_attribute)
          when :ends_with
            XPath.attr(attribute_name_from_key(attribute)).ends_with(value_for_attribute)
          when :contains
            XPath.attr(attribute_name_from_key(attribute)).contains(value_for_attribute)
          when :equals
            XPath.attr(attribute_name_from_key(attribute)) == value_for_attribute
          when :equals_ignore_case
            XPath.attr(attribute_name_from_key(attribute)).lowercase == value_for_attribute.downcase
          else
            raise("Invalid predicate: #{predicate}")
        end
      end
    end

    class << self
      def builder
        case SystemUnderTest.automation_engine
          when 'calabash'
            CalabashLocatorBuilder.new
          when 'appium'
            AppiumLocatorBuilder.new
          else
            raise('Invalid framework_type')
        end
      end

      def by_platform(locator_hash)
        locator_hash[RunContext::Infra.framework_type]
      end
    end
  end
end

World(Android)
