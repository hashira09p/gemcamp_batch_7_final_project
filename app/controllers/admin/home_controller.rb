class Admin::HomeController < AdminApplicationController
    require 'csv'

    def index
        @clients = User.client.all.page(params[:page]).per(10)
        @all_clients = User.client.all

        respond_to do |format|
            format.html
            format.csv do
                csv_string = CSV.generate do |csv|
                    csv << [
                      User.client.human_attribute_name(:parent),
                      User.client.human_attribute_name(:email),
                      User.client.human_attribute_name(:total_deposit),
                      User.client.human_attribute_name(:member_total_deposit),
                      User.client.human_attribute_name(:children_members),
                      User.client.human_attribute_name(:phone_number)
                    ]

                    @all_clients.each do |client|
                        csv << [
                          client.parent&.email,
                          client.email,
                          client.total_deposit,
                          client.children.present? ? client.children.sum { |child| child.total_deposit || 0 } : 0,
                          client.children_members,
                          client.phone_number
                        ]
                    end
                end

                render plain: csv_string
            end
        end
    end
end
