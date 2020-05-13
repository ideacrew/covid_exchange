puts FatFreeCrm::Permissions.inspect
puts FatFreeCrm::CommentExtensions.inspect
puts FatFreeCrm::Fields.inspect
puts FatFreeCrm::Exportable.inspect
puts FatFreeCrm::Sortable.inspect

module EncryptedFieldDecorator
  class Engine < ::Rails::Engine
    paths["app/models"] << "app/models/fields/"
    FatFreeCrm::Field.register(:as => 'encrypted_field', :klass => 'EncryptedField', :type => 'string')
  end
end

module EncryptedFieldAccessors
  extend ActiveSupport::Concern

  included do
    if ActiveRecord::Base.connection.table_exists? 'fat_free_crm_fields'
      FatFreeCrm::Field.joins(:field_group).where(as: 'encrypted_field' , fat_free_crm_field_groups: { klass_name: name }).each do |field|
        define_method "#{field.name}=" do |value|
          write_attribute field.name, SymmetricEncryption.encrypt(value)
        end

        define_method field.name do
          SymmetricEncryption.decrypt(read_attribute(field.name))&.gsub(/.(?=.{4})/,'*')
        end
      end
    end
  end
end

class FatFreeCrm::Account
  include EncryptedFieldAccessors
end

class FatFreeCrm::Campaign
  include EncryptedFieldAccessors
end

class FatFreeCrm::Contact
  include EncryptedFieldAccessors
end

class FatFreeCrm::Lead
  include EncryptedFieldAccessors
end

class FatFreeCrm::Opportunity
  include EncryptedFieldAccessors
end
