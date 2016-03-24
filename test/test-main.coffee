assert = require 'power-assert'
TinyPager = require '../src/main'

$ = (selector) ->
  window.document.querySelectorAll selector

describe "main", ->

  if global.mocha
    global.mocha.globals ['*']

  before ->


  after ->


  beforeEach (done) ->
    global.root1 = document.createElement 'div'
    global.root1.setAttribute 'class', 'root1'
    document.body.appendChild root1
    global.root2 = document.createElement 'div'
    global.root2.setAttribute 'class', 'root2'
    document.body.appendChild root2
    global.tinypager = new TinyPager()
    tinypager
      .total(50)
      .display(10)
      .fixed(1)
      .current(4)
      .draw($('.root1')[0])
      .draw($('.root2')[0])
    done()

  afterEach (done) ->
    document.body.removeChild global.root1
    document.body.removeChild global.root2
    global.tinypager = null
    done()

  it "can be click page", (done) ->
    for index in [0..7]
      $(".root1 .tiny-pager .page")[index].click()
      assert $(".root1 .tiny-pager .page")[index].classList.contains('selected')
      assert $(".root2 .tiny-pager .page")[index].classList.contains('selected')
    $(".root1 .tiny-pager .page")[8].click()
    assert $(".root1 .tiny-pager .page")[8 - 2].classList.contains('selected')
    assert $(".root2 .tiny-pager .page")[8 - 2].classList.contains('selected')    
    done()

  it "can not be click selected page", (done) ->
    $(".root1 .tiny-pager .page")[2].click()
    assert $(".root1 .tiny-pager .page")[2].classList.contains('selected')
    assert $(".root2 .tiny-pager .page")[2].classList.contains('selected')
    done()

  it "can be click prev", (done) ->
    $(".root1 .tiny-pager .prev")[0].click()
    assert $(".root1 .tiny-pager .page.selected").length is 1
    assert $(".root1 .tiny-pager .page")[2].classList.contains('selected')
    assert $(".root2 .tiny-pager .page")[2].classList.contains('selected')
    $(".root1 .tiny-pager .prev")[0].click()
    assert $(".root1 .tiny-pager .page.selected").length is 1
    assert $(".root1 .tiny-pager .page")[1].classList.contains('selected')
    assert $(".root2 .tiny-pager .page")[1].classList.contains('selected')
    $(".root1 .tiny-pager .prev")[0].click()
    assert $(".root1 .tiny-pager .page.selected").length is 1
    assert $(".root1 .tiny-pager .page")[0].classList.contains('selected')
    assert $(".root2 .tiny-pager .page")[0].classList.contains('selected')
    done()

  it "can not be click prev", (done) ->
    $(".root1 .tiny-pager .prev")[0].click()
    $(".root1 .tiny-pager .prev")[0].classList.contains('desabled')
    $(".root2 .tiny-pager .prev")[0].classList.contains('desabled')
    done()

  it "can be click next", (done) ->
    $(".root1 .tiny-pager .next")[0].click()
    assert $(".root1 .tiny-pager .page.selected").length is 1
    assert $(".root1 .tiny-pager .page")[4].classList.contains('selected')
    assert $(".root2 .tiny-pager .page")[4].classList.contains('selected')
    $(".root1 .tiny-pager .next")[0].click()
    assert $(".root1 .tiny-pager .page.selected").length is 1
    assert $(".root1 .tiny-pager .page")[5].classList.contains('selected')
    assert $(".root2 .tiny-pager .page")[5].classList.contains('selected')
    $(".root1 .tiny-pager .next")[0].click()
    assert $(".root1 .tiny-pager .page.selected").length is 1
    assert $(".root1 .tiny-pager .page")[6].classList.contains('selected')
    assert $(".root2 .tiny-pager .page")[6].classList.contains('selected')
    done()

  it "can not be click next", (done) ->
    $(".root1 .tiny-pager .next")[0].click()
    $(".root1 .tiny-pager .next")[0].classList.contains('desabled')
    $(".root2 .tiny-pager .next")[0].classList.contains('desabled')
    done()