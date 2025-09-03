# About Datanorm

Datanorm is a German legacy file format for serialization of B2B product data (stock lists) optimized for floppy disks and monospace needle printers. Version 4 was published in 1994 and version 5 in 1999, since then there has been no change in the format. Earlier versions date back to 1986 and are practically extinct.

30 years later, it is still the de-facto standard used by German product suppliers (especially electricity and plumbing) to communicate to their business clients, which products can be bought at which price.

Disadvantages:

* One line of text (e.g. a product name or description) is limited to 40 characters. This is because of monospace fonts where a quotation or an invoice would have column limitations. There is no reliable way to convert this into flowing text (mostly because of bullet lists).

* One product can only have one price.
  So the suppliers will typically export multiple Datanorm files to their clients: one with list prices, one with discounted buying prices and one with recommended selling prices.

* The file encoding is not UTF-8 but `CP850`, common in DOS in Western Europe.

* There are cross-references between lines within a single Datanorm file, that make parsing very complicated and inefficient (Datanorm files are commonly between 1 MB and 3 GB large).

* Version 4, still most commonly used, has special quirks, such as only allowing a product quantity unit of 1, 10, 100 or 1000. So you cannot have a product sold in packs of, say 25.

* One line in the file for prices "P" in version 5 may actually be a set of prices for multiple different products, thus separated by new lines at seemingly random places in the data.

* Over the years, people started working around the standard to overcome its limitations. In other words, every company that exports Datanorm, uses data fields in different ways to communicate different things and many structure the content of the file differently. For example, one file for creating products, one for amending existing products and one for doing both. Another example is to use product descriptions and product category descriptions interchangeably, and using free text fields to override normalized values that are wrong.

If you were ever wondering why Germany has so much bureaucracy, it's because they like to cling on to things.

### File types

There are various files with various extensions, but the main ones are those that are called `DATANORM.001`, `DATANORM.002`, etc. They have this convention because those files used to be on one floppy disk each. Nowadays you only have `DATANORM.001`, which can be several GB large.

Other file types are `.RAB` (for discount groups) and `.WRG` (for product categories), but we don't support them.

### Main Datanorm file format

In Datanorm, *one line* in the file represents one record. The most common ones are:

* The very first line in the file is the header that identifies the Datanorm version (4 or 5) and a date (indicating when the prices are in effect). In V4 the fields are separated by fixed-length and in V5 they are separated by semicolon.

* Sometimes there is a `V` record as second line of the file, it is additional information such as the number of a printed catalogue.

* One `A` record represent one product. It is identified by a product ID that is usually unique per one supplier (and thus, it is unique within one Datanorm file of a supplier). So there is only one `A` record with a given ID in one file. This is the most important kind of record and holds product name, short description and price. It can be located anywhere in the file and can reference multiple other records (that is, lines anywhere else in the file), such as records with long text descriptions.

* The `B` record is mostly relevant in V4 and holds additional product data, such as an EAN code. In V5 it is used as a DELETE statement for a product (so that the supplier can tell the business client that this product is now or soon deprecated), but we don't support really that feature. The `B` record has the same ID as the `A` record, so you know that they belong together. There is only one `B` record per product and within a Datanorm file, the `B` record is usually located one line below the `A` record.

* The `D` record represents one line of the description of one product. So you have multiple `D` records where each of them has the same ID as the product. Additionally, each record holds one line number, so you know which of those records represents which line of the product description. To complicate things further, each `D` records has two text fields (of course each limited to 40 characters), so most people put two lines of text into one `D` record (say, records for line 1, 3, and 5, which in reality represent the product description lines 1-6). The `D` records are usually located below or above the `A` record.

* `T` records were originally meant to be long texts that similar products could reference to. So, in addition to the description `D` for one single product, each product could additionally reference one `T` text that it might share with other products. But in practice they are not shared and `T` is often used instead of `D`. In other words, sometimes every single product has one single set of `T` records just for that one product. What makes `T` records complicated, in terms of file processing, is that each set of `T` records has a unique ID that is not related to any product. Rather, a product will reference that (made-up) text record set ID to indicate that those `T` records hold the long text description for a product. But the `T` records could be anywhere else in the file, so it's hard to parse.

* Usually, one `A` record holds one price for that product. But there also exist so called `P` records (one for *multiple* products) that hold up to three product IDs and corresponding prices for those products. All these `P` price records are delivered in a separate file called `DATPREIS.001`, because you need fewer floppy disks if you only regularly update the prices rather than the entirety of all product details (given you already have imported them before). Sometimes you're dependent on those `P` records from another file, because the `A` record may specify a recommended selling price whereas the corresponding `P` may have discount details that tell you the purchase price.

* Only in V5 there exists a `C` record that specifies additional data for one product, such as public tender descriptions and how much work time it normally takes to physically install a product.

# About this Rubygem

What you find here is the minimal Ruby code required to parse and loop over the content of a Datanorm file and works with both version 4 and 5.

It does not cover all features that Datanorm has, but it supports everything to get you started with the most common data attributes.

If you encounter a parsing or price calculation bug, it's likely that I didn't encounter your Datanorm file yet. I appreciate your pull request in that case.

### Parsing technique

As explained above, there are cross-references within the Datanorm file, where one line may reference another, which is located at an arbitrary line position.

If you're lucky, the file only contains `A` and `D` records that are located closely to one another, which makes linear file parsing somewhat possible.

If you 're out of luck, there are a bunch of `T` records at the beginning of the file, then some `A` and `B` records, or the other way around.

You, as a Ruby developer, would most likely do something like this:

```ruby
Datanorm::Document.new(path:).each do |item|
  # Here you would have *one* Object that represents
  # *one* product and *all*  its attributes.
end
```

That's what we're doing. For that to work, however, we need to

* parse the entire file (may take many minutes for large files)
* remember, categorize and cache the data (on disk, because you don't want 3 GB in RAM)
* then enumerate over every product
* while doing so, gather the referenced attributes that belong to each product (sometimes referencing one part of one line, as in "P" record sets)
* wrap it all in a Ruby object and yield it as UTF-8 to you

I know there are smart ways to make this faster. But "being smart" was probably the reason that the file format grew in complexity in the first place.

I went for a parsing mechanism that works every time, with every file, at the expense of running a little bit longer than needed.

## Usage

If you have a `DATANORM.001` and also a `DATPREIS.001`, you must concatenate those two files into one file first (their versions need to be the same). The resulting, merged file is what you provide to this Rubygem.

If you want one product at a time, without having to deal with the complexities of Datanorm, you can use this:

```ruby
document = Datanorm::Document.new(path: 'datanorm.001')

puts document.header
puts document.version

document.each do |product, progress|
  # Once pre-processing is complete, you'll start to get products here
  puts product # <- can be nil in the beginning

  # You can always look at the progress to see what's going on.
  puts progress if progress.significant? # Throttling, so your STDOUT doesn't get spammed.
end
```

In case you want the raw Datanorm file one line at a time as Ruby Objects, you can use this:

```ruby
file = Datanorm::File.new(path: 'datanorm.001')

puts file.header
puts file.version
puts file.lines_count

file.each do |record, line_number|
  puts record
end
```

**Debugging**

You can set the ENV variable `DEBUG_DATANORM=1` for verbose logging output.
You can also inspect the denormalization cache located at `/tmp/datanorm_ruby`
(it won't be automatically deleted if you set the `DEBUG_DATANORM` flag).

## Development

Throughout the code, the following terms are used:

* `line` is one line of a Datanorm file in its raw format.
* `record` is one Ruby Object representing one of those `line`s.
* `product` is a product (article) and all its (immediate and referenced) attributes.

Run unit tests with `bin/tests`.

To get you started, you can run `bin/demo path/to/your/datanorm.001` to show its contents.

## Open Source Maintenance

This software is release under the MIT license (see LICENSE.md).

I already anticipate people sending me their various Datanorm files, thinking that I can fix their problems, but I really don't want to 😂.

Let me be clear: Nobody should use this data format. It's from the digital stone age. If you have to parse it in Ruby and need more features, I'll gladly welcome a pull request with proper test coverage.
