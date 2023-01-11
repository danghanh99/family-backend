require 'securerandom'
class Api::V1::EventsController < ApplicationController
  def index
    if params[:start_time].nil?
      render json: {
               error: 'start_time cannot be null'
             },
             status: :unprocessable_entity
      return
    end
    if params[:end_time].nil?
      render json: {
               error: 'end_time cannot be null'
             },
             status: :unprocessable_entity
      return
    end
    if params[:start_time].to_datetime > params[:end_time].to_datetime
      render json: {
               error: 'start_time mustbe before end_time'
             },
             status: :unprocessable_entity
      return
    end
    list_event = @current_user.events
    events = list_event.where('start_time BETWEEN ? AND ?', params[:start_time].to_datetime,
                              params[:end_time].to_datetime).all
    difference = (params[:end_time].to_datetime - params[:start_time].to_datetime).to_i
    list_events = {}
    if difference < 1
      list_events = list_event.where('DATE(start_time) = ?', params[:start_time].to_date)
    else
      start_time = params[:start_time].to_date
      (0..difference).each do |diff|
        list = list_event.where('DATE(start_time) = ?', (start_time + diff.days).to_date)
        list = list.map { |item| EventSerializer.new(item) } if list.count.positive?
        # list_events << { "#{start_time + diff.days}": list }
        list_events[:"#{start_time + diff.days}"] = list
      end
    end

    render json: {
      data: list_events
    },
    status: :ok
  end

  def create
    true_numbers = [event_params[:daily], event_params[:weekly], event_params[:monthly]].count('true')
    if true_numbers >= 2
      render json: {
               error: 'You can only choose one of the options: daily/weekly/monthly'
             },
             status: :unprocessable_entity
      return
    end
    if event_params[:start_time].to_datetime >= event_params[:end_time].to_datetime
      render json: {
               error: 'start_time mustbe before end_time'
             },
             status: :unprocessable_entity
      return
    end

    event = Event.new event_params
    event.user_id = @current_user.id
    if event.save
      create_daily_events(event) if event.daily
      create_weekly_events(event) if event.weekly
      create_monthly_events(event) if event.monthly
      render_resource event, :created, EventSerializer
    else
      render json: {
               error: event.errors
             },
             status: :unprocessable_entity
    end
  end

  def update
    true_numbers = [event_params[:daily], event_params[:weekly], event_params[:monthly]].count('true')
    if true_numbers >= 2
      render json: {
               error: 'You can only choose one of the options: daily/weekly/monthly'
             },
             status: :unprocessable_entity
      return
    end
    if event_params[:start_time].to_datetime >= event_params[:end_time].to_datetime
      render json: {
               error: 'start_time mustbe before end_time'
             },
             status: :unprocessable_entity
      return
    end

    event = Event.find(params[:id])
    event.update(event_params)
    if event.save
      childs = Event.where(parent_id: event.id) if event.present?
      childs.each do |child|
        child.update(event_params)
      end
      render json: {
        event: event,
        childs: childs
      }, status: :ok
    else
      render json: {
               error: event.errors
             },
             status: :unprocessable_entity
    end
  rescue StandardError => e
    render json: {
             error: e.message
           },
           status: :bad_request
  end

  def show
    event = Event.find(params[:id])
    childs = Event.where(parent_id: event.id) if event.present?
    render json: {
      event: event,
      childs: childs
    }, status: :ok
  rescue StandardError => e
    render json: {
             error: e.message
           },
           status: :bad_request
  end

  def destroy
    event = Event.find(params[:id])
    childs = Event.where(parent_id: event.id) if event.present?
    parent = Event.find(event.parent_id) if event.present?
    parent.destroy
    event.destroy
    childs.delete_all
    render json: {}, status: :no_content
  rescue StandardError => e
    render json: {
             error: e.message
           },
           status: :bad_request
  end
end

  private

def event_params
  params.permit :name, :start_time, :end_time, :description, :daily, :weekly, :monthly
end

def create_daily_events(event)
  (1..365).each do |duration|
    Event.create(
      name: event.name,
      start_time: event.start_time + duration.days,
      end_time: event.end_time + duration.days,
      description: event.description,
      daily: event.daily,
      weekly: event.weekly,
      monthly: event.monthly,
      is_cancelled: false,
      parent_id: event.id
    )
  end
end

def create_weekly_events(event)
  duration = 7
  while duration <= 365
    Event.create(
      name: event.name,
      start_time: event.start_time + duration.days,
      end_time: event.end_time + duration.days,
      description: event.description,
      daily: event.daily,
      weekly: event.weekly,
      monthly: event.monthly,
      is_cancelled: false,
      parent_id: event.id
    )
    duration += 7
  end
end

def create_monthly_events(event)
  (1..12).each do |duration|
    Event.create(
      name: event.name,
      start_time: event.start_time + duration.months,
      end_time: event.end_time + duration.months,
      description: event.description,
      daily: event.daily,
      weekly: event.weekly,
      monthly: event.monthly,
      is_cancelled: false,
      parent_id: event.id
    )
  end
end
