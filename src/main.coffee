###
  tinypager - a small library for pager
  @version 0.9.0
###

class TinyPager

    PANEL_CLASS = 'tiny-pager'
    PAGE_CLASS = 'page'
    PREV_CLASS = 'prev'
    NEXT_CLASS = 'next'
    ELLIPSIS_CLASS = 'ellipsis'
    SELECTED_CLASS = 'selected'
    DISABLED_CLASS = 'disabled'
    
    _currentPage: 1
    _totalPage: 20
    _displayPage: 5
    _fixedPage: 1
    _prevDisplay: 'prev'
    _nextDisplay: 'next'
    _ellipsisDisplay: '...'

    _$roots: []
    _listeners: {}

    constructor: ->

    current: (position) ->
        @_currentPage = position
        @

    total: (size) ->
        @_totalPage = size
        @

    display: (size) ->
        @_displayPage = size
        @

    fixed: (size) ->
        @_fixedPage = size
        @

    prevDisplay: (display) ->
        @_prevDisplay = display
        @

    nextDisplay: (display) ->
        @_nextDisplay = display
        @

    ellipsisDisplay: (display) ->
        @_ellipsisDisplay = display
        @

    onPrev: (action) ->
        @_listeners['prev-click'] = action
        @

    onNext: (action) ->
        @_listeners['next-click'] = action
        @

    onPage: (action) ->
        @_listeners['page-click'] = action
        @

    draw: (rootNode) ->
        @_validateParams()
        @_$roots.push rootNode
        $panel = @_buildPanel()
        rootNode.appendChild $panel
        @

    destroy: -> 
        @_$roots.forEach ($root) =>
            $root.removeChild $root.lastChild
        @

    _redraw: ->
        @_$roots.forEach ($root) =>
            $root.removeChild $root.lastChild
            $panel = @_buildPanel()
            $root.appendChild $panel

    _applyDafaultStyle: ->

    _emit: (event) ->
        @_listeners[event] && @_listeners[event].apply null, [].slice.call arguments, 1

    _buildPanel: ->
        $panel = @_newPanel()
        $prev = @_newPrev @_currentPage is 1
        $next = @_newNext @_currentPage is @_totalPage
        $pages = @_newPages()
        $pages.unshift $prev
        $pages.push $next
        $pages.forEach ($page) -> $panel.appendChild $page
        $panel

    _newPanel: ->
        $panel = document.createElement 'ul'
        $panel.setAttribute 'style', 'font-size: 0; list-style: none;'
        $panel.classList.add PANEL_CLASS
        $panel

    _getStartDisplayPage: ->
        @_currentPage - if isEven @_displayPage
            @_displayPage / 2
        else
            Math.floor @_displayPage / 2

    _getEndDisplayPage: ->
        @_currentPage + if isEven @_displayPage
            @_displayPage / 2 - 1
        else
            Math.floor @_displayPage / 2

    _newPages: ->

        range = @_getDisplayPageRange()

        $pages = []

        if range.from isnt 1
            $pages.push @_newPage num for num in [1..@_fixedPage]
            $pages.push @_newEllipsis()
        
        $pages.push @_newPage num, @_currentPage is num for num in [range.from..range.to]
        
        if range.to isnt @_totalPage
            $pages.push @_newEllipsis()
            $pages.push @_newPage num for num in [@_totalPage - (@_fixedPage - 1)..@_totalPage]

        $pages

    _getDisplayPageRange: ->

        startEllipsisPoint = @_fixedPage + 2
        endEllipsisPoint = @_totalPage - startEllipsisPoint
        startDisplayPage = @_getStartDisplayPage()
        endDisplayPage = @_getEndDisplayPage()
        
        if startDisplayPage <= startEllipsisPoint and endEllipsisPoint < endDisplayPage
            from: 1
            to: @_totalPage

        else if startDisplayPage < 1 and endDisplayPage < endEllipsisPoint
            from: 1
            to: @_displayPage

        else if startDisplayPage <= startEllipsisPoint and endDisplayPage <= endEllipsisPoint
            from: 1
            to: endDisplayPage
        
        else if startEllipsisPoint < startDisplayPage and @_totalPage <= endDisplayPage
            from: @_totalPage - @_displayPage + 1
            to: @_totalPage

        else if startEllipsisPoint < startDisplayPage and endEllipsisPoint < endDisplayPage
            from: startDisplayPage
            to: @_totalPage

        else
            from: startDisplayPage
            to: endDisplayPage

    _newPrev: (disabled) ->
        prev = document.createElement 'li'
        prev.classList.add PREV_CLASS
        prev.setAttribute 'style', 'display: inline-block; font-size: 12px; width: 20px; margin: 10px;'
        if disabled
            prev.classList.add DISABLED_CLASS
        else
            prev.addEventListener 'click', => @_prevClick prev
            #prev.addEventListener 'mouseover', => @_prevMouseover prev
            #prev.addEventListener 'mouseout', => @_prevMouseout prev
        text = document.createElement 'span'
        text.innerHTML = @_prevDisplay
        prev.appendChild text
        prev

    _newNext: (disabled) ->
        next = document.createElement 'li'
        next.classList.add NEXT_CLASS
        next.setAttribute 'style', 'display: inline-block; font-size: 12px; width: 20px; margin: 10px;'
        if disabled
            next.classList.add DISABLED_CLASS
        else
            next.addEventListener 'click', => @_nextClick next
            #next.addEventListener 'mouseover', => @_prevMouseover next
            #next.addEventListener 'mouseout', => @_prevMouseout next
        text = document.createElement 'span'
        text.innerHTML = @_nextDisplay
        next.appendChild text
        next

    _newPage: (number, selected) ->
        page = document.createElement 'li'
        page.setAttribute 'data-number', number
        page.classList.add PAGE_CLASS
        if selected
            page.classList.add SELECTED_CLASS
            page.setAttribute 'style','font-weight: bold; display: inline-block; font-size: 12px; width: 20px; margin: 10px;'
        else
            page.setAttribute 'style', 'display: inline-block; font-size: 12px; width: 20px; margin: 10px;'
            page.addEventListener 'click', => @_pageClick page
            page.addEventListener 'mouseover', => @_pageMouseover page
            page.addEventListener 'mouseout', => @_pageMouseout page
        text = document.createElement 'span'
        text.innerHTML = number
        page.appendChild text
        page

    _newEllipsis: (disabled) ->
        ellipsis = document.createElement 'li'
        ellipsis.classList.add ELLIPSIS_CLASS
        ellipsis.setAttribute 'style', 'display: inline-block; font-size: 12px; width: 20px; margin: 10px;'
        if disabled then ellipsis.classList.add DISABLED_CLASS
        text = document.createElement 'span'
        text.innerHTML = @_ellipsisDisplay
        ellipsis.appendChild text
        ellipsis

    _prevClick:  ->
        @_currentPage--
        @_redraw()
        @_emit 'prev-click', @_currentPage

    _nextClick: ->
        @_currentPage++
        @_redraw()
        @_emit 'next-click', @_currentPage

    _pageClick: (e) ->
        @_currentPage = Number e.getAttribute 'data-number'
        @_redraw()
        @_emit 'page-click', @_currentPage

    _pageMouseover: (e) ->
        @_emit 'mouse-over', Number e.getAttribute 'data-number'

    _pageMouseout: (e) ->
        @_emit 'mouse-out', Number e.getAttribute 'data-number'

    _validateParams: ->
        invalid = if @_totalPages <= 0
            page: 'Total'
            value: @_totalPages
        else if @_currentPage <= 0
            page: 'Current'
            value: @_currentPage
        else if @_displayPage <= 0
            page: 'Display'
            value: @_currentPage
        else if @_fixedPage < 0
            page: 'Fixed'
            value: @_currentPage
        if invalid then throw new Error 'Illegal Argments Error: #{invalid.page} is unsupported value: #{invalid.value}'

        invalid = if @_totalPages < @_displayPages
            page: 'display'
        else if @_totalPages < @_currentPage
            page: 'current'
        else if @_totalPages < @_fixedPage
            page: 'fixed'
        if invalid then throw new Error 'Illegal Argments Error: More than #{invalid.page} is total page.'

    isEven = (number) ->
        number % 2 is 0

    $ = (selector) ->
        window.document.querySelectorAll selector

module.exports = TinyPager
