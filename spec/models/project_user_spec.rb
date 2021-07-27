require 'rails_helper'

RSpec.describe ProjectUser, type: :model do
  it 'has a valid factory' do
    project_owner = create(:user, email: 'owner@address.com')
    user = create(:user, email: 'user@address.com')
    project = create(:project, user: project_owner)
    project_user = build(:project_user, user: user, project: project)
    expect(project_user).to be_valid
  end

  context 'Associations' do
    it 'should have one project' do
      assoc = ProjectUser.reflect_on_association(:project)
      expect(assoc.macro).to eq(:belongs_to)
    end
    it 'should have one user' do
      assoc = ProjectUser.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end
  end

  context 'Validations' do
    before(:each) do
      @project_owner = create(:user, email: 'owner@address.com')
      @user = create(:user, email: 'user@address.com')
      @project = create(:project, user: @project_owner)
      @project_user = build(:project_user, user: @user, project: @project)
    end

    it 'should require a user' do
      @project_user.user = nil
      expect(@project_user).not_to be_valid
    end
    it 'should only allow a user to have one entry per project' do
      project2 = create(:project, user: @project_owner)
      @project_user.save
      project_user_invalid = build(:project_user, user: @user, project: @project)
      project_user_valid = build(:project_user, user: @user, project: project2)
      expect(@project_user).to be_valid
      expect(project_user_valid).to be_valid
      expect(project_user_invalid).not_to be_valid
    end
    it 'should require a project' do
      @project_user.project = nil
      expect(@project_user).not_to be_valid
    end
    it 'should set the role of "client" if not otherwise configured' do
      @project_user.save
      expect(@project_user.role).to eq('client')
    end
    it 'should allow the role of "client" to be set' do
      @project_user.role = 0
      @project_user.save
      expect(@project_user.role).to eq('client')
    end
    it 'should allow the role of "developer" to be set' do
      @project_user.role = 1
      @project_user.save
      expect(@project_user.role).to eq('developer')
    end
    it 'should allow the role of "admin" to be set' do
      @project_user.role = 2
      @project_user.save
      expect(@project_user.role).to eq('admin')
    end
    it 'should allow the role of "owner" to be set' do
      @project_user.role = 3
      @project_user.save
      expect(@project_user.role).to eq('owner')
    end
    it 'should reject a role greater than 3' do
      expect { @project.status = 4 }.to raise_error(ArgumentError)
    end
    it 'should reject a role smaller than 0' do
      expect { @project.status = -1 }.to raise_error(ArgumentError)
    end

    context 'Methods' do
      before(:each) do
        @project_owner = create(:user, email: 'owner@method.com')
        @user = create(:user, email: 'user@method.com')
        @project = create(:project, user: @project_owner)
        @project_user = build(:project_user, user: @user, project: @project)
      end

      describe 'find_user_in_project' do
        it 'should a projectuser object' do
          lookup = ProjectUser.find_user_in_project(@project_owner, @project)
          expect(lookup[0]).to be_an_instance_of(ProjectUser)
        end
      end

      describe 'verify_role' do
      end
    end
  end
end
