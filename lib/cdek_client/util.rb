require 'nokogiri'

module CdekClient
  module Util

    extend self

    def xml_to_hash(xml_io)
      result = Nokogiri::XML xml_io
      return { result.root.name.to_sym => xml_node_to_hash(result.root)}
    end

    def hash_to_xml(hash)
      root_key = hash.keys.first
      Nokogiri::XML::Builder.new do |xml|
        process_hash_to_xml(root_key, hash[root_key], xml)          
      end.to_xml
    end

    def deep_symbolize_keys(data)
      case data
      when Hash
        result = {}
        data.each do |key, value|
          result[key.to_sym] = deep_symbolize_keys value
        end
        return result
      when Array
        result = []
        data.each do |value|
          result.push deep_symbolize_keys(value)
        end
        return result
      else
        return data
      end
    end

    def hash_value_at_keypath(hash, keypath)
      if keypath.length == 0 || !hash.is_a?(Hash)
        return nil
      elsif keypath.length == 1
        return hash[keypath[0]]
      else
        return hash_value_at_keypath hash[keypath[0]], keypath[1..-1]        
      end
    end

    def array_wrap(value)
      if value.is_a? Array
        return value
      elsif value.nil?
        return []
      else
        return [value]
      end
    end

    def blank?(value)
      value.nil? || 
      (value.is_a?(String) && value.strip == '') ||
      ((value.is_a?(Array) || (value.is_a?(Hash))) && value.empty?)
    end

    private

    def xml_node_to_hash(node)
      # If we are at the root of the document, start the hash 
      if node.element?
        result_hash = {}
        if node.attributes != {}
          attributes = {}
          node.attributes.keys.each do |key|
            attributes[node.attributes[key].name.to_sym] = node.attributes[key].value
          end
        end
        if node.children.size > 0
          node.children.each do |child|
            result = xml_node_to_hash(child)

            if child.name == "text"
              unless child.next_sibling || child.previous_sibling
                return result unless attributes
                result_hash[child.name.to_sym] = result
              end
            elsif result_hash[child.name.to_sym]

              if result_hash[child.name.to_sym].is_a?(Object::Array)
                 result_hash[child.name.to_sym] << result
              else
                 result_hash[child.name.to_sym] = [result_hash[child.name.to_sym]] << result
              end
            else
              result_hash[child.name.to_sym] = result
            end
          end
          if attributes
             #add code to remove non-data attributes e.g. xml schema, namespace here
             #if there is a collision then node content supersets attributes
             result_hash = attributes.merge(result_hash)
          end
          return result_hash
        else
          return attributes
        end
      else
        return node.content.to_s
      end
    end

    def process_hash_to_xml(label, value, xml)
      if value.is_a? Hash
        children, attributes = value.partition{ |k, v| v.is_a?(Array) || v.is_a?(Hash) }
        xml.send(label, Hash[attributes]) do
          children.each{ |k, v| process_hash_to_xml k, v, xml }
        end
      elsif value.is_a? Array
        value.each do |v|
          process_hash_to_xml label, v, xml
        end
      end
    end
    
  end
end