require 'rails_helper'

RSpec.describe Project, type: :model do
  it 'has a valid factory' do
    user = create(:user)
    project = build(:project, user: user)
    expect(project).to be_valid
  end

  context 'Validations' do
    before(:each) do
      @user = create(:user)
      @project = build(:project, user: @user)
    end

    it 'should default status to open' do
      @project.save
      expect(@project.status).to eq('open')
    end
    it 'should be able to be set status to closed' do
      @project.status = 'closed'
      @project.save
      expect(@project.status).to eq('closed')
    end
    it 'should reject a status greater than 1' do
      expect { @project.status = 2 }.to raise_error(ArgumentError)
    end
    it 'should reject a status less than 0' do
      expect { @project.status = -1 }.to raise_error(ArgumentError)
    end
  end

  context 'Associations' do
    it 'should belong to a user' do
      assoc = Project.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end
    it 'should have one project detail' do
      assoc = Project.reflect_on_association(:project_detail)
      expect(assoc.macro).to eq(:has_one)
    end
    it 'should have many tickets' do
      assoc = Project.reflect_on_association(:tickets)
      expect(assoc.macro).to eq(:has_many)
    end
    it 'should have many project users' do
      assoc = Project.reflect_on_association(:project_users)
      expect(assoc.macro).to eq(:has_many)
    end
    it 'should be able to populate the project description table' do
      user = create(:user)
      project = build(:project, user: user, project_detail_attributes: {
                        project_name: 'test project',
                        description: 'test project description'
                      })
      project.save
      expect(project.project_detail.project_name).to eq('test project')
    end
  end

  context 'methods' do
    before(:each) do
      @user = create(:user)
      @project = build(:project, user: @user)
    end

    describe 'set_owner' do
      it 'should set the creating user as a project user' do
        @project.save
        expect(@project.project_users.first.user_id).to eq(@user.id)
      end
      it 'should set the creating user with role of owner' do
        @project.save
        expect(@project.project_users.first.role).to eq('owner')
      end
    end

    describe 'all_for_user' do
      before(:each) do
        3.times { create(:project, user: @user) }
        @projects = Project.all_for_user(@user.id)
      end

      it 'should return an array' do
        expect(@projects).to be_an_instance_of(Array)
      end
      it 'should return 3 items' do
        expect(@projects.length).to eq(3)
      end
      it 'should return unique items' do
        first_id = @projects[0].id
        expect(@projects[1].id).to eq(first_id + 1)
        expect(@projects[2].id).to eq(first_id + 2)
      end
    end

    describe 'build_project_object' do
      before(:each) do
        @project.project_detail_attributes = {
          project_name: 'test project',
          description: 'test project description'
        }
        @project.save
        @object = Project.build_project_object(@project, @user.id)
      end

      it 'should return the project details' do
        expect(@object[:project_detail].project_name).to eq('test project')
      end
      it 'should return an array of project users' do
        expect(@object[:project_users]).to be_an_instance_of(Array)
      end
      it 'should return each users username' do
        expect(@object[:project_users].first[:username]).to eq('useraccount')
      end
      it 'should return details of the current users role' do
        expect(@object[:current_role].first[:user_id]).to eq(@user.id)
        expect(@object[:current_role].first[:role]).to eq('owner')
      end
    end
  end
end
