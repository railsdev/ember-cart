EmberCart.CartItem = DS.Model.extend
  cartable_id: DS.attr('number')
  cartable_type: DS.attr('string')
  name: DS.attr('string')
  image_url: DS.attr('string')
  price: DS.attr('money')
  quantity: DS.attr('number')
  cart: DS.belongsTo('EmberCart.Cart')
  parent: DS.belongsTo('EmberCart.CartItem')
  children: DS.hasMany('EmberCart.CartItem', key: 'child_ids')

  formattedPrice: Ember.computed( ->
    round(@get('price'), 2)
  ).property('price')

  increase: ->
    @set('quantity', @get('quantity') + 1)
    @get('children').forEach (c) ->
      c.increase()

  createChildren: (attrs) ->
    @get('children').createRecord(attrs)

  didCreate: ->
    @get('parent.children').pushObject(@) if @get('parent')
