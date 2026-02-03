class ContextsController < ApplicationController
  before_action :set_context, only: %i[ show edit update destroy ]

  # GET /contexts or /contexts.json
  def index
    @contexts = Context.all
  end

  # GET /contexts/1 or /contexts/1.json
  def show
  end

  # GET /contexts/new
  def new
    @context = Context.new
  end

  # GET /contexts/1/edit
  def edit
  end

  # POST /contexts or /contexts.json
  def create
    @context = Context.new(context_params)

    respond_to do |format|
      if @context.save
        format.html { redirect_to @context, notice: "Context was successfully created." }
        format.json { render :show, status: :created, location: @context }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @context.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contexts/1 or /contexts/1.json
  def update
    respond_to do |format|
      if @context.update(context_params)
        format.html { redirect_to @context, notice: "Context was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @context }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @context.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contexts/1 or /contexts/1.json
  def destroy
    @context.destroy!

    respond_to do |format|
      format.html { redirect_to contexts_path, notice: "Context was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_context
      @context = Context.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def context_params
      params.expect(context: [ :user_id, :name ])
    end
end
