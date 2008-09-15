/* spree YUI support stuffs */
spree.YUI = {
  registered_trees: {},

  move_node: function() { 
	var target = spree.YUI.current_tree.current_target;
	alert("move node: " + target.id); 
  },

  new_node: function() { 
	//var target = spree.YUI.current_tree.current_target;
	//  alert("new node: " + target.id); 

	var taxonomy_id = spree.YUI.current_tree.id;
	var taxon_id = spree.YUI.current_tree.current_target.id;

	var url = '/admin/taxonomies/new_taxon';
	var message = 'new_taxon[parent_id]=' + taxon_id + '&new_taxon[taxonomy_id]=' + taxonomy_id;

	spree.YUI.AJAX.simple_updater('new-taxon', url, message);

	spree.YUI.reset_current_target();
  },

  edit_node: function() { 
	var tree = spree.YUI.current_tree;
	var target = spree.YUI.current_tree.current_target;
	
	window.location.href=target.data.edit_url + '/edit';
  },

  delete_node: function() { 
	//var target = spree.YUI.current_tree.current_target;
	//alert("delete node: " + target.id); 

	var taxon_id = spree.YUI.current_tree.current_target.id;
	
	var url = spree.YUI.current_tree.current_target.data	.object_url;
	var message = 'id=' + taxon_id;

	if (confirm('Are you sure that you want to delete this taxon?')){
	  new Ajax.Request(url, {
	  	method: 'post',
	  	parameters: {_method: 'delete'},
		onSuccess: function(transport){
		      var response = transport.responseText || "no response text";
		      alert("Success! \n\n" + response);
		    },
	  	onFailure: function(){ alert('Something went wrong...') }
	  });
	}

	spree.YUI.reset_current_target(); 
  },

  /*
  manage_products: function() { 
	var target = spree.YUI.current_tree.current_target;
	alert("manage products: " + target.id); 

	var taxon_id = spree.YUI.current_tree.current_target.id;

	var url = '/admin/taxonomies/manage_products';
	var message = 'id=' + taxon_id;

	spree.YUI.AJAX.simple_updater('manage-products', url, message);
	spree.YUI.reset_current_target(); 
  },
  */

  onTriggerContextMenu: function(p_sType, p_Args) { 
	var event = p_Args[0]; 
	var target = YAHOO.util.Event.getTarget(event);

	// find the target which is a tree node 
	target = YAHOO.util.Dom.hasClass(target, 'ygtvhtml') 
	? target 
	: YAHOO.util.Dom.getAncestorByClassName(target, 'ygtvhtml'); 
 
	if (target) { 
	  var tree = spree.YUI.set_current_target(target);	
	  //	alert('triggered the context menu for target: ' + target + ', class: ' + target.className);
	  if (target == tree.root) {
		spree.YUI.reset_current_target();
		this.cancel();
	  }
	} 
	else { 
	  // Cancel the display of the ContextMenu instance.
	  this.cancel(); 
	} 
  },
  
  build_tree: function(container_element_id, tree_data) {
	var tree = spree.YUI.registered_trees[container_element_id];
	if (tree) {
	  spree.YUI.destroy_tree(tree);
	}

	tree = {};
	spree.YUI.register_tree(tree, container_element_id, "taxonomy_tree");

	tree.tree_view = new YAHOO.widget.TreeView(container_element_id);
	tree.node_map = {};

	for (var i = 0; i < tree_data.length; i++) {
	  spree.YUI.initialize_node(tree, tree_data[i]);
	}
	
	var menu_items = [ 
					  //	  { text: "Move", onclick: { fn: spree.YUI.move_node } }, 
	  { text: "New", onclick: { fn: spree.YUI.new_node } }, 
	  { text: "Edit", onclick: { fn: spree.YUI.edit_node } },
	  { text: "Delete", onclick: { fn: spree.YUI.delete_node } }, ];

	  //{ text: "Products", onclick: { fn: spree.YUI.manage_products } } ];
	
	// This hack does not make me happy
	var rand_no = Math.ceil(1000000 * Math.random());
	tree.context_menu = new YAHOO.widget.ContextMenu("cm_" + container_element_id + '_' + rand_no, 
													 { trigger: container_element_id, 
														 lazyload: true,  
														 itemdata: menu_items }); 
	
	tree.context_menu.subscribe("triggerContextMenu", spree.YUI.onTriggerContextMenu ); 

	return tree;
  },

  initialize_node: function(tree, node) {
	var parent_node = node.parent_id == null 
	? tree.tree_view.getRoot() 
	: tree.node_map[node.parent_id];
	
	tree.node_map[node.id] = new YAHOO.widget.HTMLNode(node, parent_node, false, true);
	if (node.parent_id == null) tree.root = tree.node_map[node.id];

  },

  set_current_target: function(target) {
	//  alert('looking for target: ' + target);
	var tree = spree.YUI.find_tree_by_element(target); 
	var spree_target = YAHOO.util.Dom.getElementsByClassName('spree-YUI-tree-node','span',target)

	tree.current_target = tree.node_map[spree_target[0].id];
	spree.YUI.current_tree = tree;
	return tree;
  },

  reset_current_target: function(target) {
	spree.YUI.current_tree = null;
  },

  find_tree_by_element: function(el) {
	var container = YAHOO.util.Dom.getAncestorByClassName(el, 'spree-YUI-tree-container');
	var tree = spree.YUI.registered_trees[container.id];
	return tree;
  },

  register_tree: function(tree, id, type) {
	var container = YAHOO.util.Dom.get(id);
	tree.id = id;
	YAHOO.util.Dom.addClass(id, 'spree-YUI-tree-container');

	spree.YUI.registered_trees[id] = tree;
	//  spree.YUI.registered_trees[type] = new Array();
	//  spree.YUI.registered_trees[type].push(tree);
  },

  destroy_tree: function(tree) {
	// uninitialize nodes
	for (var i=0; i<tree.node_map.length; i++) {
	  delete tree.node_map[i];
	}
	delete tree.node_map;

	// unsubscribe menu
	tree.context_menu.unsubscribe("triggerContextMenu", spree.YUI.onTriggerContextMenu);
	delete tree.context_menu;

	// unregister tree
	delete spree.YUI.registered_trees[tree.id];

	// destroy tree view
	delete tree.tree_view;
  },

  onload: function() {
  }

}; // end spree.YUI namespace


