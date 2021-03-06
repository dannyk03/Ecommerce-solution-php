<?php
/**
 * @package Grey Suit Retail
 * @page Products > Add
 *
 * Declare the variables we have available from other sources
 * @var Resources $resources
 * @var Template $template
 * @var User $user
 * @var int $product_count
 * @var Category[] $categories
 * @var Brand[] $brands
 */

nonce::field( 'autocomplete', '_autocomplete' );
nonce::field( 'sku_exists', '_sku_exists' );
nonce::field( 'request', '_request' );

?>
<div class="row-fluid">
    <div class="col-lg-12">
        <section class="panel">
            <header class="panel-heading">
                Add Products
                <a class="btn btn-sm btn-primary pull-right">Add Bulk Products</a>
            </header>

            <div class="panel-body">

                <form action="/products/search/" class="form-inline" id="product-search" role="form">
                    <fieldset>
                        <div class="form-group">
                            <select class="form-control" id="sCategory">
                                <option value="">-- Select Category --</option>
                                <?php foreach ( $categories as $category ): ?>
                                    <option value="<?php echo $category->id; ?>"><?php echo str_repeat( '&nbsp;', $category->depth * 5 ); echo $category->name; ?></option>
                                <?php endforeach; ?>
                            </select>
                        </div>
                        <div class="form-group">
                            <select class="form-control" id="sAutoComplete" name="s">
                                <option value="sku">SKU</option>
                                <option value="product">Product Name</option>
                                <option value="brand">Brand</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <input type="text" class="form-control" id="tAutoComplete" placeholder="Search..." name="v" />
                        </div>
                        <input type="hidden" name="p" value="1" />
                        <input type="hidden" name="n" value="20" />
                        <button type="submit" class="btn btn-primary" id="sSearch">Search</button>
                    </fieldset>

                </form>

            </div>
        </section>
    </div>
</div>

<div class="row-fluid">
    <div class="col-lg-9">
        <section class="panel">
            <header class="panel-heading">
                Search Results
            </header>
            <div class="panel-body">

                <div class="adv-table">
                    <table id="product-search-results" class="dt manual display table table-bordered table-striped" perPage="30,50,100" data-hide-filter="1">
                        <thead>
                            <th sort="1">Name</th>
                            <th>Brand</th>
                            <th>SKU</th>
                        </thead>
                    </table>
                </div>
            </div>
        </section>
    </div>

    <div class="col-lg-3">
        <section class="panel">
            <header class="panel-heading">
                Selected Products
            </header>
            <div class="panel-body">
                <p>Product usage: <span id="product-usage"><?php echo number_format($product_count) ?></span> / <?php echo number_format($user->account->products) ?></p>

                <form id="add-product-form" method="post" role="form">

                    <ul id="product-list">
                        <li id="add-product-template" class="hidden">
                            <a href="javascript:;" class="remove pull-right"><i class="fa fa-trash-o"></i></a>
                            <input type="hidden" name="products[]" />
                        </li>
                    </ul>

                    <p class="text-right">
                        <?php echo nonce::field( 'add' ) ?>
                        <button type="submit" class="btn btn-primary" disabled>Add</button>
                    </p>
                </form>
            </div>
        </section>

        <section class="panel">
            <header class="panel-heading">
                Request a Product
            </header>
            <div class="panel-body">
                <p>Don't see a product you want? <br/> Request a Product and we will add it for you</p>
                <p class="text-right">
                    <button type="button" class="btn btn-default" data-toggle="modal" data-target="#request-a-product-modal">Request a Product</button>
                </p>
            </div>
        </section>
    </div>
</div>

<div class="modal fade" id="request-a-product-modal" tabindex="-1" role="dialog" aria-labelledby="request-a-product-modal-label" aria-hidden="true" >
    <form id="fRequestAProduct" action="/products/request/" method="post" role="form">
        <?php nonce::field( 'create' )?>
        <!-- Modal -->
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title" id="support-modal-label">Request A Product</h4>
                </div>
                <div class="modal-body">

                    <div class="form-group">
                        <label for="sRequestBrand">Brand:</label>
                        <select class="form-control" id="sRequestBrand">
                            <option value="">-- Select a Brand --</option>
                            <?php foreach ( $brands as $brand ) : ?>
                                <option value="<?php echo $brand->id; ?>"><?php echo $brand->name; ?></option>
                            <?php endforeach; ?>
                        </select>
                    </div>

                    <div class="form-group">
                        <label for="tRequestSKU">SKU:</label>
                        <input type="text" class="form-control" id="tRequestSKU" />
                    </div>

                    <div class="form-group">
                        <label for="tCollection">Collections/Product:</label>
                        <input type="text" class="form-control" id="tCollection" />
                    </div>

                    <p>
                        <button type="button" class="btn btn-default btn-sm" id="add-request">Add Request</button>
                    </p>

                    <div id="request-list"></div>

                    <?php nonce::field( 'request' ) ?>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                    <button type="submit" class="btn btn-primary">Save changes</button>
                </div>
            </div>
        </div>
    </form>
</div>

<div class="request hidden" id="request-template">
    <p>
        <span class="title"></span>
        <input type="hidden" name="requests[]" />
        <a class="text-right remove"><i class="fa fa-trash-o"></i></a>
    </p>
</div>