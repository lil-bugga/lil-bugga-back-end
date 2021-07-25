require 'rails_helper'

RSpec.describe Ticket, type: :model do
  it 'has a valid factory' do
    user = create(:user)
    project = create(:project, user: user)
    ticket = build(:ticket, user: user, project: project)
    expect(ticket).to be_valid
  end

  context 'Validations' do
    before(:each) do
      @user = create(:user)
      @project = create(:project, user: @user)
      @ticket = build(:ticket, user: @user, project: @project)
    end

    it 'should default status to open' do
      @ticket.save
      expect(@ticket.status).to eq('open')
    end
    it 'should allow status to be set to todo' do
      @ticket.status = 'todo'
      @ticket.save
      expect(@ticket.status).to eq('todo')
    end
    it 'should allow status to be set to in_progress' do
      @ticket.status = 'in_progress'
      @ticket.save
      expect(@ticket.status).to eq('in_progress')
    end
    it 'should allow status to be set to complete' do
      @ticket.status = 'complete'
      @ticket.save
      expect(@ticket.status).to eq('complete')
    end
    it 'should allow status to be set to closed' do
      @ticket.status = 'closed'
      @ticket.save
      expect(@ticket.status).to eq('closed')
    end
    it 'should reject a status greater than 4' do
      expect { @project.status = 5 }.to raise_error(ArgumentError)
    end
    it 'should reject a status less than 0' do
      expect { @project.status = -1 }.to raise_error(ArgumentError)
    end
  end

  context 'Associations' do
    it 'should have one project' do
      assoc = Ticket.reflect_on_association(:project)
      expect(assoc.macro).to eq(:belongs_to)
    end
    it 'should have one user' do
      assoc = Ticket.reflect_on_association(:user)
      expect(assoc.macro).to eq(:belongs_to)
    end
    it 'should have many entries' do
      assoc = Ticket.reflect_on_association(:entries)
      expect(assoc.macro).to eq(:has_many)
    end
  end

  context 'Methods' do
    before(:each) do
      @user = create(:user)
      @project = create(:project, user: @user)
      @ticket = create(:ticket, user: @user, project: @project)
      @project2 = build(:project, user: @user, project_detail_attributes: {
                          project_name: 'test project'
                        })
      @project2.save
      2.times { create(:ticket, user: @user, project: @project2) }
      @subject = 'project_name'
      @project2.tickets.first.entries.create(subject: @subject, body: 'text', user_id: @user.id)
    end
    describe 'build_ticket_object_array' do
      before(:each) { @object = Ticket.build_ticket_object_array(@project2.tickets) }

      it 'should return an array' do
        expect(@object).to be_an_instance_of(Array)
      end
      it 'each array item should represent a ticket item' do
        id = @project2.tickets.first.id
        expect(@object.first['id']).to eq(id)
      end
      it 'each array item should return its projects details' do
        pending 'tests fails to get associated details, however works in production'
        project_name = @project2.project_detail.project_name
        expect(@object.first[:project_detail][:project_name]).to eq(project_name)
      end
      it 'each array item should return the details of its first entry' do
        expect(@object.first[:first_entry][:subject]).to eq(@subject)
      end
    end
    describe 'build_ticket_object' do
      before(:each) { @object = Ticket.build_ticket_object(@ticket, @user.id) }
    end
    it 'should return the users role in the project' do
      pending 'tests fails to get associated details, however works in production'
      role = @project.project_users.first
      expect(@object[:current_role]).to eq(role)
    end
    describe 'all_for_project' do
      pending `this is a simple where lookup and gateway to above methods, pending resolution to described issues`
    end
    describe 'all_for_user' do
      pending `this is a simple where lookup and gateway to above methods, pending resolution to described issues`
    end
    describe 'all_tickets' do
      pending `this is a simple .all lookup and gateway to above methods, pending resolution to described issues`
    end
  end
end
