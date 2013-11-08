require "roo"

module Rseed
  class RooAdapter < Rseed::Adapter
    attr_accessor :file

    def preprocess
      return false unless file
      logger.info "Preprocessing Excel file: #{file.to_s.yellow}"

      @excelx = false
      case File.extname(file).downcase
        when ".xls"
          @roo = ::Roo::Excel.new(file)
        when ".xlsx"
          @excelx = true
          @roo = ::Roo::Excelx.new(file)
      end

      result = find_excel_header_row

      if result.nil?
        logger.error "Could not find header row.".red
        return false
      end

      @roo.default_sheet = result[:sheet]
      @header_row = result[:row]
      @headers = result[:headers]

      true
    end

    def process &block
      # Loop through the data
      logger.info "Reading data from row #{@header_row + 1} to #{@roo.last_row}"
      @estimated_rows =@roo.last_row - @header_row;
      row_number = 0
      (@header_row + 1).upto(@roo.last_row) do |row|
        row_number += 1
        import_row = {}
        @headers.each_pair do |name, column|
          if @excelx
            value = @roo.cell(row, column).to_s
          else
            value = @roo.cell(row, column).to_s
          end
          import_row[name] = value
        end
        yield import_row, record_count: row_number, total_records: @estimated_rows
      end
    end

    def all_headers_found(headers)
      @missing_headers_mandatory = []
      @missing_headers_optional = []
      found_at_least_one = false

      converter_attributes.each do |attribute|
        if headers[attribute.name].nil?
          unless mapping[:optional]
            @missing_headers_mandatory << attribute.name
          else
            @missing_headers_optional << attribute.name
          end
        else
          found_at_least_one = true
        end
      end
      if found_at_least_one
        logger.warning "Missing optional headers: #{@missing_headers_optional.join(',')}".yellow unless @missing_headers_optional.empty?
        logger.warning "Missing mandatory headers: #{@missing_headers_mandatory.join(',')}".red unless @missing_headers_mandatory.empty?
      end
      return false unless @missing_headers_mandatory.empty?
      true
    end

    def find_excel_header_row
      @roo.sheets.each do |sheet|
        logger.info "Looking for the header row in sheet #{sheet}".cyan
        @roo.default_sheet = sheet
        @roo.first_row.upto(@roo.last_row) do |row|
          headers = {}
          (@roo.first_column..@roo.last_column).each do |column|
            converter_attributes.each do |attribute|

              if attribute.matches? @roo.cell(row, column).to_s
                logger.info "Found header for #{attribute.name.to_s.green} at column #{column} at row #{row}"
                if (headers[attribute.name].nil?)
                  headers[attribute.name] = column
                else
                  logger.warn "Found duplicate header '#{attribute.name.to_s.red}' on columns #{column} and #{headers[attribute.name]}."
                end
              end
            end
          end

          if all_headers_found(headers)
            logger.info "All headers found on row #{row}".green
            return {:row => row, :sheet => sheet, :headers => headers}
          end
        end
      end
      return nil
    end
  end
end
