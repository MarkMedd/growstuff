require 'rails_helper'

describe 'notifier/notify.html.haml', type: "view" do
  before do
    @notification = FactoryBot.create(:notification)
    @reply_link = "http://example.com"
    @signed_message = "EncryptedMessage"
    assign(:reply_link, @reply_link)
    render
  end

  it 'says that you have a message' do
    rendered.should have_content 'You have received a message'
  end

  it 'includes notification metadata' do
    rendered.should have_content @notification.sender.login_name
    rendered.should have_content @notification.post.subject
  end

  it 'includes a reply link' do
    assert_select "a[href='#{@reply_link}']", text: /Reply/
  end

  it 'contains a link to your inbox' do
    assert_select "a[href*='notifications']"
  end

  it 'has fully qualified URLs' do
    # lots of lovely fully qualified URLs
    assert_select "a[href^='http']", minimum: 4
    # no relative URLs starting with /
    assert_select "a[href^='/']", count: 0
  end
end
