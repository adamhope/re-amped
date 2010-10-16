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

  def map
    #params[:x]
    #params[:y]
    #params[:direction]
    @blocks = Block.all
    min_x = 0
    min_y = 0
    max_x = 0
    max_y = 0
    @blocks.each do |block|
      min_x = block.x.to_i if min_x.nil? or block.x.to_i < min_x
      min_y = block.y.to_i if min_y.nil? or block.y.to_i < min_y
      max_x = block.x.to_i if max_x.nil? or block.x.to_i > max_x
      max_y = block.y.to_i if max_y.nil? or block.y.to_i > max_y
    end
    length_x = max_x - min_x ## one minus the total x length
    length_y = max_y - min_y ## one minus the total y length
    @ascii_map = []
    (0..length_x).each do |x|
      @ascii_map[x] = []
      (0..length_y).each do |y|
        @ascii_map[x][y] = '#'
      end
    end

    Rails::logger.info "MINX = #{min_x}\tMAXX = #{max_x}\tMINY = #{min_y}\tMAXY = #{max_y}\n\n"
    Rails::logger.info "LENGTHX = #{length_x}\tLENGTHY = #{length_y}\t\n\n"
    Rails::logger.info ""
    Rails::logger.info "##################"
    Rails::logger.info @ascii_map.to_s
    Rails::logger.info "##################"
    @blocks.each do |block|
      Rails::logger.info "BLOCK.X = #{block.x}\tBLOCK.Y = #{block.y}\n"
      
      #Rails::logger.info block.as_json
      @ascii_map[block.x.to_i-min_x][block.y.to_i-min_y] = '.'
      #@ascii_map[0][0] = ' '
    end
    if params[:direction] = 'north'
      @ascii_map[params[:x].to_i-min_x][params[:y].to_i-min_y] = '^'
    elsif params[:direction] = 'east'
      @ascii_map[params[:x].to_i-min_x][params[:y].to_i-min_y] = '>'
    elsif params[:direction] = 'south'
      @ascii_map[params[:x].to_i-min_x][params[:y].to_i-min_y] = 'v'
    elsif params[:direction] = 'west'
      @ascii_map[params[:x].to_i-min_x][params[:y].to_i-min_y] = '<'
    end

    top_bottom = ""
    (length_x + 3).times do
      top_bottom = top_bottom + "#"
    end
    @output = top_bottom + "<br />"
    (0..length_y).each do |y|
      @output += "#"
      (0..length_x).each do |x|
        @output += @ascii_map[x][length_y-y]
      end
#      @output += "<br />"
      @output += "#<br />"
    end
    @output += top_bottom  + "<br />"

    # @output = '"' + @output + '"'
    @output_map = [@output]
    
    Rails::logger.info "##################"
    Rails::logger.info @output
    Rails::logger.info "##################"

    Rails::logger.info "##################"
    Rails::logger.info @ascii_map.to_s
    Rails::logger.info "##################"

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @output_map }
      format.json  { render :json => @output_map }
    end
  end



#  def map3
#    @blocks = Block.all
#    y_row = ["X","X","X"]
#
#    map = [
#           ["X","X","X"],
#           ["X","0","X"],
#           ["X","X","X"]
#    ]
#    x = 1
#    y = 1
#    @blocks.each do |block|
#      y = y - 1 if block.north == 0
#      y = y + 1 if block.south == 0
#
#      x = x - 1 if block.west == 0
#      x = x + 1 if block.west == 0
#    end
#
#    map[x][y] = 0
#
#    # Add outside row to grid if we've reached the edge.
#    if y==0
#      map.unshift(y_row)
#      y = y + 1
#    end
#    if y == map.length
#      map.push(y_row)
#      y = y - 1
#    end
#
#
#
#
#    end
#  end

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
