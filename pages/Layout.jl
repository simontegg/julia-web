module Layout

  export page

  function page(content)
    return """
      <html>
        <head>
          <title>Julia Web App</title>
          <link rel="stylesheet" href="https://unpkg.com/tachyons@4.8.1/css/tachyons.min.css"/>
        </head>
        <body>
          $content
        </body>
      </html>
    """
  end

end
