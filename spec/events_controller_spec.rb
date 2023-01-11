require 'rails_helper'

RSpec.describe Api::V1::EventsController, type: :controller do
  before(:all) do
    Event.delete_all
  end

  describe 'POST#create' do
    let!(:event_params) do
      {
        name: 'Calendar',
        start_time: '2022/12/23 09:00:00',
        end_time: '2022/12/23 09:15:00',
        description: 'Meeting',
        daily: false,
        weekly: false,
        monthly: false
      }
    end

    it 'should return 201' do
      params = event_params.dup
      post :create, params: params
      expect(response.status).to eq(201)
    end

    it 'should return 1 event' do
      params = event_params.dup
      post :create, params: params
      expect(Event.all.count).to eq(1)
    end

    it 'monthly: should return 12 events in next 12 months' do
      params = event_params.dup
      params[:monthly] = true
      post :create, params: params
      event = JSON.parse(response.body)['event']
      events = Event.where('start_time BETWEEN ? AND ?', '2022/12/24 00:00:00'.to_datetime,
                           '2023/12/23 23:00:00'.to_datetime).all
      expect(events.last.parent_id).to eq(event['id'])
      expect(events.count).to eq(12)
    end

    it 'daily: should return 7 events in next week' do
      params = event_params.dup
      params[:daily] = true
      post :create, params: params
      event = JSON.parse(response.body)['event']
      events = Event.where('start_time BETWEEN ? AND ?', '2023/01/02 00:00:00'.to_datetime,
                           '2023/01/08 23:00:00'.to_datetime).all
      expect(events.first.parent_id).to eq(event['id'])
      expect(events.count).to eq(7)
    end

    it 'should return 422 with start_time is after end_time' do
      params = event_params.dup
      params[:start_time] = '2022/12/24 09:00:00'
      post :create, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422 when select both daily && weekly' do
      params = event_params.dup
      params[:daily] = true
      params[:weekly] = true
      post :create, params: params
      expect(response.status).to eq(422)
    end

    it 'should return 422 when select both daily && weekly && monthly' do
      params = event_params.dup
      params[:daily] = true
      params[:weekly] = true
      params[:monthly] = true
      post :create, params: params
      expect(response.status).to eq(422)
    end
  end
end
