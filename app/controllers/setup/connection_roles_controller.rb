module Setup
  class ConnectionRolesController < Setup::BaseController
    before_action :find_connection_role, only: [:show, :update, :destroy]

    # GET /connection_roles.json
    def index
      @connection_roles = Setup::ConnectionRole.all
      render json: @connection_roles
    end

    # GET /connection_roles/1.json
    def show
      render json: @connection_role
    end

    # GET /connection_roles/new.json
    def new
      @connection_role = Setup::ConnectionRole.new
      render json: @connection_role
    end

    # POST /connection_roles.json
    def create	  
      @connection_role = Setup::ConnectionRole.new(permited_attributes)
      if @connection_role.save
        render json: @connection_role, status: :created, location: @connection_role
      else
        render json: @connection_role.errors, status: :unprocessable_entity
      end
    end

    # PUT /connection_roles/1.json
    def update
      if @connection_role.update_attributes(params[:connection_role])
        head :no_content
      else
        render json: @connection_role.errors, status: :unprocessable_entity
      end
    end

    # DELETE /connection_roles/1.json
    def destroy
      @connection_role.destroy
      head :no_content
    end
    
    protected
    def permited_attributes
      params[:connection_role].permit(:name, :webhooks_attributes, :connection_attributes )
    end  
    
    def find_connection_role
      @connection_role = Setup::ConnectionRole.find(params[:id])
    end

  end
end