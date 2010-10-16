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
    if @block.nil?
      create_hash = {
        :user_id => 0,
        :x       => params[:x],
        :y       => params[:y],
        :north   => 1,
        :east    => 1,
        :south   => 1,
        :west    => 1,
      }
       [
        [ 0, 1, :north, :south],
        [ 1, 0,  :east,  :west],
        [ 0,-1, :south, :north],
        [-1, 0,  :west,  :east],
      ].each do |delta_x, delta_y, direction, reverse_direction|
#  Rails::logger.info('asgfsdfs3' + 'x' + delta_x.to_s + 'x' + delta_y.to_s + 'x' + direction.to_s + 'x' + reverse_direction.to_s)
        @block = Block.first(:conditions => { :x => params[:x].to_i+delta_x, :y => params[:y].to_i+delta_y })
        if !@block.nil? and @block.send(reverse_direction) == 0
          create_hash[direction] = 0
        end
      end

      @block = Block.new(create_hash)
      @block.save
    end
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
    if @block.nil?
      coordinate_get_item
    end

    ## TODO: Make sure opposite wall is also updated accordingly.
    ## Item_0 is the special "item" that's an empty space.
    if params[:item].to_i == 0
      if (params[:direction] == 'north')
        other_x = params[:x].to_i
        other_y = params[:y].to_i + 1
        other_direction = 'south'
      elsif (params[:direction] == 'east')
        other_x = params[:x].to_i + 1
        other_y = params[:y].to_i
        other_direction = 'west'
      elsif (params[:direction] == 'south')
        other_x = params[:x].to_i
        other_y = params[:y].to_i - 1
        other_direction = 'north'
      elsif (params[:direction] == 'west')
        other_x = params[:x].to_i - 1
        other_y = params[:y].to_i
        other_direction = 'east'
      else
        raise 'invalid directions'
      end
      @other_block = Block.first(:conditions => { :x => other_x, :y => other_y })
      unless @other_block.nil?
        @other_block.update_attributes(other_direction.to_sym => 0)
      end
    end
    respond_to do |format|
      if @block.update_attributes(params[:direction].to_sym => params[:item])
        flash[:notice] = 'Block was successfully updated.'
        format.html { redirect_to(@block) }
        format.xml { redirect_to(@block) }
        format.json { redirect_to(@block) }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @block.errors, :status => :unprocessable_entity }
        format.json  { render :json => @block.errors, :status => :unprocessable_entity }
      end
    end

  end
end
