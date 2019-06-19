class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, :address, presence: true #只要有值驗證就過了
  validates :phone, format: {with: /\A\d{10}\z/, message: "only allow 10 digits phone number"}
  validates :is_admin, inclusion: { in: [true, false]} #值要是array裡的東西驗證才會過

  has_many :carts, dependent: :destroy
  has_many :orders, dependent: :nullify

  after_create :create_carts

  def buy_now_cart #要讓controller簡化，就要在model裡面定義多一點method幫助，而且比較好測試
    carts.buy_now.first
  end

  def buy_now_cart_items
    buy_now_cart.cart_items
  end

  def buy_next_time_cart
    carts.buy_next_time.first
  end

  def buy_next_time_cart_items
    buy_next_time_cart.cart_items
  end

  private

  def create_carts
  	if carts.blank?
  		Cart.buy_now.create(user: self)
  		Cart.buy_next_time.create(user: self)
  	end
  end
end
