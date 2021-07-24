require 'rails_helper'

RSpec.describe ProjectDetail, type: :model do
  it 'has a valid factory' do
    user = create(:user)
    project = create(:project, user: user)
    project_detail = build(:project_detail, project: project)
    expect(project_detail).to be_valid
  end

  context 'Validations' do
    before(:each) do
    @user = create(:user)
    @project = create(:project, user: @user)
    @project_detail = build(:project_detail, project: @project)
    end
    it 'requires a project name' do
      @project_detail.project_name = nil
      expect(@project_detail).not_to be_valid
    end
    it 'requires a unique name' do
      @project_detail.save
      project_two = build(:project_detail, project: @project)
      expect(project_two).not_to be_valid
    end
    it 'allows a description ot be set' do
      @project_detail.description = "test description"
      @project_detail.save
      expect(@project_detail.description).to eq('test description')
    end
    it 'sets a default description if none provided' do
      @project_detail.save
      expect(@project_detail.description).to eq('No description available')
    end
  end

end
