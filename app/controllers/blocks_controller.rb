class BlocksController < ApplicationController
  # GET /blocks
  # GET /blocks.xml
  def index
    @blocks = Block.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @blocks }
      format.json  { render :json => @blocks }
    end
  end

  # GET /blocks/1
  # GET /blocks/1.xml
  def show
    @block = Block.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @block }
      format.json  { render :json => @block }
    end
  end

  # GET /blocks/new
  # GET /blocks/new.xml
  def new
    @block = Block.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @block }
      format.json  { render :json => @block }
    end
  end

  # GET /blocks/1/edit
  def edit
    @block = Block.find(params[:id])
  end

  # POST /blocks
  # POST /blocks.xml
  def create
    @block = Block.new(params[:block])

    respond_to do |format|
      if @block.save
        flash[:notice] = 'Block was successfully created.'
        format.html { redirect_to(@block) }
        format.xml  { render :xml => @block, :status => :created, :location => @block }
        format.json  { render :json => @block, :status => :created, :location => @block }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
        format.json  { render :json => @block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /blocks/1
  # PUT /blocks/1.xml
  def update
    @block = Block.find(params[:id])

    respond_to do |format|
      if @block.update_attributes(params[:block])
        flash[:notice] = 'Block was successfully updated.'
        format.html { redirect_to(@block) }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
        format.json  { render :json => @block.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /blocks/1
  # DELETE /blocks/1.xml
  def destroy
    @block = Block.find(params[:id])
    @block.destroy

    respond_to do |format|
      format.html { redirect_to(blocks_url) }
      format.xml  { head :ok }
      format.json  { head :ok }
    end
  end

  def coordinate_get_items
    @block = Block.first(:conditions => { :x => params[:x], :y => params[:y] })
    @items = {
        :north => @block.north,
        :east => @block.east,
        :south => @block.south,
        :west => @block.west,
    }

    respond_to do |format|
      format.html # coordinate_get_items.html.erb
      format.xml  { render :xml => @items }
      format.json  { render :json => @items }
    end

  end
  def coordinate_set_item
#    $stderr.puts 'SET PARAMS = ' + params.to_s
#    require 'ruby-debug'; debugger
    @block = Block.first(:conditions => { :x => params[:x], :y => params[:y] })
#    if @block.nil?
#      ## Need to create with blank defaults...unless we're coming from a direction with blank walls
#      [
#        { 0, 1, 'north'},
#        { 1, 0, 'east'},
#        { 0,-1, 'south'},
#        {-1, 0, 'west'}
#      ].each do |delta_x, delta_y, direction|
#      Block.first(:conditions => { :x => params[:x]+delta_x, :y => params[:y]+delta_y })
#      if 
#      end
#    end

    ## TODO: Make sure opposite wall is also updated accordingly.
    ## Item_0 is the special "item" that's an empty space.
    if params[:item] == 0
      if (params[:direction] == 'north')
        other_x = params[:x]
        other_y = params[:y] + 1
        other_direction = 'south'
      elsif (params[:direction] == 'east')
        other_x = params[:x] + 1
        other_y = params[:y]
        other_direction = 'west'
      elsif (params[:direction] == 'south')
        other_x = params[:x]
        other_y = params[:y] - 1
        other_direction = 'north'
      elsif (params[:direction] == 'west')
        other_x = params[:x] - 1
        other_y = params[:y]
        other_direction = 'east'
      else
        raise 'invalid directions'
      end
      @other_block = Block.first(:conditions => { :x => other_x, :y => other_y }})
      unless @other_block.nil?
        @other_block.update_attributes(other_direction.to_sym => 0)
      end
    end
    respond_to do |format|
      if @block.update_attributes(params[:direction].to_sym => params[:item])
        flash[:notice] = 'Block was successfully updated.'
        format.html { redirect_to(@block) }
        format.xml  { head :ok }
        format.json  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
        format.json  { render :json => @block.errors, :status => :unprocessable_entity }
      end
    end

  end
end
