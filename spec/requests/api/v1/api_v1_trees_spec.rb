require 'spec_helper'

describe "Api::V1::Trees" do
  describe "GET /api_v1_trees" do
    it "should require authentication" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      
      get api_v1_trees_path

      response.status.should be(401)

      json = JSON.parse(response.body)
      json["error"].should be_present
      # pp json["error"]
    end

    describe "authenticated users" do
      before :each do
        @user = FactoryGirl.create(:user)
        @admin = FactoryGirl.create(:admin)

        @user_tree = FactoryGirl.create(:tree, name: "User tree", user_id: @user._id)
        @admin_tree = FactoryGirl.create(:tree, name: "Admin tree", user_id: @admin._id)

        params = { email: @user[:email], password: 'abcdefg'}
        post api_v1_user_session_path, params.to_json, { 'CONTENT_TYPE' => 'application/json' }

        json = JSON.parse(response.body)
        @user_auth_token = json["authentication_token"]
      end

      it "should fetch this users' trees" do
        get api_v1_trees_path, auth_token: @user_auth_token

        response.status.should be 200

        json = JSON.parse(response.body)

        expect(json["trees"].length).to eq 1
        expect(json["trees"][0]["name"]).to eq "User tree"
        expect(json["trees"][0]["user_id"].to_s).to eq @user._id.to_s
      end

      it "should create a new tree for this user" do
        # post api_v1_trees_path
        
        params = { name: "My new tree", description: "testing", auth_token: @user_auth_token }
        post api_v1_trees_path, params.to_json, { 'CONTENT_TYPE' => 'application/json' }

        response.status.should be 201

        json = JSON.parse(response.body)
        expect(json["tree"]["name"]).to eq "My new tree"
        expect(json["tree"]["user_id"].to_s).to eq @user._id.to_s
        
        # puts response
      end

      it "should not access another user's tree" do
        get api_v1_tree_path(@admin_tree._id), auth_token: @user_auth_token

        response.status.should be 200

        json = JSON.parse(response.body)
        expect(json["tree"]).to be_nil
        
        #puts json
      end

      it "should update the tree's meta data" do
        # put api_v1_tree_path
        
        params = { tree: { name: "Updated tree name" }, auth_token: @user_auth_token }
        put api_v1_tree_path(@user_tree._id), params.to_json, { 'CONTENT_TYPE' => 'application/json' }

        response.status.should be 202

        json = JSON.parse(response.body)
        expect(json["tree"]["_id"]).to eq @user_tree._id.to_s
        expect(json["tree"]["name"]).to eq "Updated tree name"

        @user_tree.reload
        expect(@user_tree[:name]).to eq "Updated tree name"
        
        # puts JSON.parse(response.body)
        # puts response.status
        # puts @user_tree.to_json
      end

      it "should not update another users's tree" do
        params = { tree: { name: "Updated a stranger's tree!" }, auth_token: @user_auth_token }
        put api_v1_tree_path(@admin_tree._id), params.to_json, { 'CONTENT_TYPE' => 'application/json' }

        response.status.should be 400

        @admin_tree.reload
        expect(@admin_tree[:name]).to_not be "Updated a stranger's tree!"

        #puts JSON.parse(response.body)
      end

      it "should delete the tree" do
        # delete api_v1_tree_path
        
        delete api_v1_tree_path(@user_tree._id), auth_token: @user_auth_token

        response.status.should be 204
        Tree.where(_id: @user_tree._id).count.should be 0
      end

      it "should not delete another user's tree" do
        # delete api_v1_tree_path
        
        delete api_v1_tree_path(@admin_tree._id), auth_token: @user_auth_token

        response.status.should be 400
      end

      # note: this is the only admin function tested currently
      # all other behaviors will be at the user role
      it "should fetch all trees for admins" do
        params = { email: @admin[:email], password: 'abcdefg'}
        post api_v1_user_session_path, params.to_json, { 'CONTENT_TYPE' => 'application/json' }

        json = JSON.parse(response.body)
        admin_auth_token = json["authentication_token"]

        get api_v1_trees_path, auth_token: admin_auth_token

        response.status.should be 200

        json = JSON.parse(response.body)
        expect(json["trees"].length).to eq 2
      end
    end

  end
end
