require 'rails_helper'

feature Page do

  let!(:page)  { build(:page) }

  describe "link_xor_content" do

    before do
      page.link = "http://www.external-link.com"
      page.content = "Lorem ipsum"
    end

    it 'should return error when both filled' do
      expect(page).not_to be_valid
      expect(page.errors).to include (:link)
      expect(page.errors.messages[:link]).to include ("no puede crear una página que contenga un enlace externo y contenido. Rellene sólo uno de los dos campos.")
    end
  end

  describe "shpold have link or content on depth 3 nodes" do

    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1) }
    let!(:page3)  { create(:page, parent: page2) }
    let!(:page4)  { build(:page, parent: page3) }

    it 'should return error when both filled' do
      expect(page4).not_to be_valid
      expect(page4.errors).to include (:link)
      expect(page4.errors.messages[:link]).to include ("tiene que añadir un enlace externo o contenido a la página. Rellene uno de los dos campos.")
    end
  end

  describe "link" do

    before do
      page.link = "badlink"
    end

    it 'should not be valid with wrong link url' do
      expect(page).not_to be_valid
      expect(page.errors).to include (:link)
      expect(page.errors.messages[:link]).to include ("el enlace introducido no es válido")
    end
  end  

  describe "level" do
    let!(:page1)  { create(:page) }
    let!(:page2)  { create(:page, parent: page1) }
    let!(:page3)  { create(:page, parent: page2) }
    let!(:page4)  { create(:page, parent: page3, link: "http://www.external-link.com") }

    it 'should return 1 for root nodes' do
      expect(page1.level).to eq(1)
    end

    it 'should return 2 for root nodes' do
      expect(page2.level).to eq(2)
    end 

    it 'should return 3 for root nodes' do
      expect(page3.level).to eq(3)
    end 

    it 'should return 4 for root nodes' do
      expect(page4.level).to eq(4)
    end             
  end 

end