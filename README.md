<h1>Tables Documentation</h1>

  <h2>Table: payment_type</h2>
  <p>
      <strong>Description:</strong> Contains various types of payment methods such as cash, bank transfer, or bitcoin.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>Name:</strong> NVARCHAR(50) NOT NULL<br>
      <strong>Description:</strong> NVARCHAR(255)
  </p>

  <h2>Table: currency</h2>
  <p>
      <strong>Description:</strong> Stores different currencies used in transactions, along with their symbols and identifiers.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>Name:</strong> NVARCHAR(100) NOT NULL<br>
      <strong>Symbol:</strong> NVARCHAR(10) NOT NULL<br>
      <strong>International Identifier:</strong> NVARCHAR(10) NOT NULL
  </p>

  <h2>Table: plan_Type</h2>
  <p>
      <strong>Description:</strong> Defines different subscription plans with varying limits on the number of product records allowed.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>Name:</strong> NVARCHAR(100) NOT NULL<br>
      <strong>Max Product Record Count:</strong> INT NOT NULL
  </p>

  <h2>Table: auth_user</h2>
  <p>
      <strong>Description:</strong> Manages user authentication with details like username, name, email, password, and account status.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>Username:</strong> NVARCHAR(150) NOT NULL UNIQUE<br>
      <strong>First Name:</strong> NVARCHAR(30) NOT NULL<br>
      <strong>Last Name:</strong> NVARCHAR(150) NOT NULL<br>
      <strong>Email:</strong> NVARCHAR(254) NOT NULL UNIQUE<br>
      <strong>Password:</strong> NVARCHAR(128) NOT NULL<br>
      <strong>Is Staff:</strong> BIT NOT NULL<br>
      <strong>Is Active:</strong> BIT NOT NULL<br>
      <strong>Date Joined:</strong> DATETIME NOT NULL
  </p>

  <!-- Include brief descriptions for the remaining tables -->

  <h2>Table: product_category</h2>
  <p>
      <strong>Description:</strong> Categorizes products into different groups for better organization and management.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>Name:</strong> NVARCHAR(100) NOT NULL<br>
      <strong>Icon Link:</strong> NVARCHAR(MAX)<br>
      <strong>Business ID:</strong> INT NOT NULL (Foreign Key: business(id))
  </p>

  <h2>Table: product</h2>
  <p>
      <strong>Description:</strong> Stores information about various products including their names, descriptions, prices, and inventory.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>Photo Link:</strong> NVARCHAR(MAX)<br>
      <strong>Name:</strong> NVARCHAR(255) NOT NULL<br>
      <strong>Description:</strong> NVARCHAR(MAX)<br>
      <strong>Stock:</strong> INT NOT NULL<br>
      <strong>Cost Price:</strong> DECIMAL(10, 2) NOT NULL<br>
      <strong>Sale Price:</strong> DECIMAL(10, 2) NOT NULL<br>
      <strong>Category ID:</strong> INT NOT NULL (Foreign Key: product_category(id))<br>
      <strong>Business ID:</strong> INT NOT NULL (Foreign Key: business(id))<br>
      <strong>With IVA:</strong> BIT NOT NULL
  </p>

  <h2>Table: supplier</h2>
  <p>
      <strong>Description:</strong> Contains details of suppliers providing products to the business such as names, contact information, and addresses.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>First Name:</strong> NVARCHAR(100) NOT NULL<br>
      <strong>Last Name:</strong> NVARCHAR(100) NOT NULL<br>
      <strong>Email:</strong> NVARCHAR(254) NOT NULL<br>
      <strong>Phone:</strong> NVARCHAR(20) NOT NULL<br>
      <strong>Address:</strong> NVARCHAR(254) NOT NULL<br>
      <strong>Business ID:</strong> INT NOT NULL (Foreign Key: business(id))
  </p>

  <h2>Table: customer</h2>
  <p>
      <strong>Description:</strong> Holds information about customers including their names, contact details, and addresses.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>First Name:</strong> NVARCHAR(100) NOT NULL<br>
      <strong>Last Name:</strong> NVARCHAR(100) NOT NULL<br>
      <strong>Email:</strong> NVARCHAR(254) NOT NULL<br>
      <strong>Phone:</strong> NVARCHAR(20) NOT NULL<br>
      <strong>Address:</strong> NVARCHAR(254) NOT NULL<br>
      <strong>Business ID:</strong> INT NOT NULL (Foreign Key: business(id))
  </p>

  <h2>Table: invoice</h2>
  <p>
      <strong>Description:</strong> Records details of invoices generated for transactions, including subtotal, taxes, and total amount.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>Invoice Number:</strong> NVARCHAR(50) NOT NULL<br>
      <strong>Invoice Date:</strong> DATETIME NOT NULL<br>
      <strong>Sub Total:</strong> DECIMAL(10, 2) NOT NULL<br>
      <strong>IVA:</strong> DECIMAL(10, 2) NOT NULL<br>
      <strong>Total:</strong> DECIMAL(10, 2) NOT NULL<br>
      <strong>Customer ID:</strong> INT NOT NULL (Foreign Key: customer(id))<br>
      <strong>Business ID:</strong> INT NOT NULL (Foreign Key: business(id))<br>
      <strong>Payment Type ID:</strong> INT NOT NULL (Foreign Key: payment_type(ID))
  </p>

  <h2>Table: sale</h2>
  <p>
      <strong>Description:</strong> Tracks individual sales transactions associated with specific invoices, products, and quantities sold.
  </p>
  <p>
      <strong>ID:</strong> INT (Primary Key, Identity)<br>
      <strong>Product ID:</strong> INT NOT NULL (Foreign Key: product(id))<br>
      <strong>Quantity:</strong> INT NOT NULL<br>
      <strong>Cost Price at Time:</strong> DECIMAL(10, 2) NOT NULL<br>
      <strong>Sale Price at Time:</strong> DECIMAL(10, 2) NOT NULL<br>
      <strong>Invoice ID:</strong> INT NOT NULL (Foreign Key: invoice(id))
  </p>
