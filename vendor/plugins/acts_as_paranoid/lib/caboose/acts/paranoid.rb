module Caboose #:nodoc:
  module Acts #:nodoc:
    # Overrides some basic methods for the current model so that calling #destroy sets a 'deleted_at' field to the current timestamp.
    # This assumes the table has a deleted_at date/time field.  Most normal model operations will work, but there will be some oddities.
    #
    #   class Widget < ActiveRecord::Base
    #     acts_as_paranoid
    #   end
    #
    #   Widget.find(:all)
    #   # SELECT * FROM widgets WHERE widgets.deleted_at IS NULL
    #
    #   Widget.find(:first, :conditions => ['title = ?', 'test'], :order => 'title')
    #   # SELECT * FROM widgets WHERE widgets.deleted_at IS NULL AND title = 'test' ORDER BY title LIMIT 1
    #
    #   Widget.find_with_deleted(:all)
    #   # SELECT * FROM widgets
    #
    #   Widget.find(:all, :with_deleted => true)
    #   # SELECT * FROM widgets
    #
    #   Widget.count
    #   # SELECT COUNT(*) FROM widgets WHERE widgets.deleted_at IS NULL
    #
    #   Widget.count ['title = ?', 'test']
    #   # SELECT COUNT(*) FROM widgets WHERE widgets.deleted_at IS NULL AND title = 'test'
    #
    #   Widget.count_with_deleted
    #   # SELECT COUNT(*) FROM widgets
    #
    #   Widget.delete_all
    #   # UPDATE widgets SET deleted_at = '2005-09-17 17:46:36'
    #
    #   Widget.delete_all!
    #   # DELETE FROM widgets
    #
    #   @widget.destroy
    #   # UPDATE widgets SET deleted_at = '2005-09-17 17:46:36' WHERE id = 1
    #
    #   @widget.destroy!
    #   # DELETE FROM widgets WHERE id = 1
    #
    module Paranoid
      def self.included(base) # :nodoc:
        base.extend ClassMethods
      end

      module ClassMethods
        def acts_as_paranoid(options = {})
          unless paranoid? # don't let AR call this twice
            class << self
              VALID_FIND_OPTIONS << :with_deleted unless VALID_FIND_OPTIONS.include?(:with_deleted)
            end
            cattr_accessor :deleted_attribute
            self.deleted_attribute = options[:with] || :deleted_at
            alias_method :destroy_without_callbacks!, :destroy_without_callbacks
            class << self
              alias_method :find_every_with_deleted,    :find_every
              alias_method :calculate_with_deleted,     :calculate
              alias_method :delete_all!,                :delete_all
            end
          end
          include InstanceMethods
        end

        def paranoid?
          self.included_modules.include?(InstanceMethods)
        end
      end

      module InstanceMethods #:nodoc:
        def self.included(base) # :nodoc:
          base.extend ClassMethods
        end

        module ClassMethods
          def find_with_deleted(*args)
            options = args.extract_options!
            validate_find_options(options)
            set_readonly_option!(options)
            options[:with_deleted] = true # yuck!

            case args.first
              when :first then find_initial(options)
              when :all   then find_every(options)
              else             find_from_ids(args, options)
            end
          end

          def count_with_deleted(*args)
#            calculate_with_deleted(:count, *construct_count_options_from_args(*args))
            calculate_with_deleted(:count, *construct_count_options_from_legacy_args(*args))
          end

          def count(*args)
            with_deleted_scope { count_with_deleted(*args) }
          end

          def calculate(*args)
            with_deleted_scope { calculate_with_deleted(*args) }
          end

          def delete_all(conditions = nil)
            self.update_all ["#{self.deleted_attribute} = ?", current_time], conditions
          end

          protected
            def current_time
              default_timezone == :utc ? Time.now.utc : Time.now
            end

            def with_deleted_scope(&block)
              with_scope({:find => { :conditions => ["#{table_name}.#{deleted_attribute} IS NULL OR #{table_name}.#{deleted_attribute} > ?", current_time] } }, :merge, &block)
            end

          private
            # all find calls lead here
            def find_every(options)
              options.delete(:with_deleted) ?
                find_every_with_deleted(options) :
                with_deleted_scope { find_every_with_deleted(options) }
            end
        end

        def destroy_without_callbacks
          unless new_record?
            self.class.update_all self.class.send(:sanitize_sql, ["#{self.class.deleted_attribute} = ?", self.class.send(:current_time)]), ["#{self.class.primary_key} = ?", id]
          end
          freeze
        end

        def destroy_with_callbacks!
          return false if callback(:before_destroy) == false
          result = destroy_without_callbacks!
          callback(:after_destroy)
          result
        end

        def destroy!
          transaction { destroy_with_callbacks! }
        end
      end
    end
  end
end
