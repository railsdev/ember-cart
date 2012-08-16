EmberCart.Cart = DS.Model.extend
  name: DS.attr('string')
  image_url: DS.attr('string')
  current: DS.attr('boolean')
  cart_items: DS.hasMany('EmberCart.CartItem', key: 'cart_item_ids')

  cartItemsCount: Ember.computed( ->
    count = 0
    @get("cart_items").forEach (i) ->
      count += i.get('quantity')

    count
  ).property("cart_items.@each.quantity")

  total: Ember.computed( ->
    total = 0
    @get('cart_items').forEach (i) ->
      total += i.get('price') * i.get('quantity')

    round(total, 2)
  ).property("cart_items.@each.price", "cart_items.@each.quantity")

  addCartItem: (attrs) ->
    attrs.cart_id = @get('id')

    return @createCartItem(attrs) if attrs.mergable == false

    cartItem = @findCartItemByCartable(attrs.cartable_type, attrs.cartable_id)

    if cartItem
      cartItem.increase()
      return cartItem

    @createCartItem(attrs)

  removeCartItem: (cartItem) ->
    cartItem.deleteRecord()

  # @private
  createCartItem: (attrs) ->
    children = attrs.children || []

    cartItem = @get('cart_items').createRecord(attrs)

    cartItem.createChildren(c) for c in children

    cartItem

  # @private
  findCartItemByCartable: (type, id) ->
    @get('cart_items').filter((i) ->
      return true if i.get('cartable_type') == type && i.get('cartable_id') == id
    ).get('firstObject')

