/* -----------------------------------------
File    : list.controller.js
Author  : za
Contact : za@e-vision.by
Date    : 09/02/2021

Description :
$Header: $
-----------------------------------------*/
'use strict';


angular.module('app').controller('editCtrl', [ '$scope', '$location', '$stateParams', '$timeout', '$q', '$filter', 'mainService',
  'gridOptionsTreeService', 'utilsService', 'calcService', 'commonService', 'NotifierService',
  function($scope, $location, $stateParams, $timeout, $q, $filter, mainService, gridOptionsTreeService, utilsService, calcService, commonService, NotifierService)
  {
    this.compCode = $('#compCode').val();
    this.pageId = $('#pageId').val();
    this.userId = $('#userId').val();
    this.lang = $('#lang').val();

    this.filter = { is_load: '0', pt: null };
    this.tree_id = $stateParams.tree_id;

    this.loadFilter = () =>
    {
      return mainService.httpGet({ dtType: 'getTree', tree_id: this.tree_id }).then(data =>
      {
        this.tree = data;
      });
    };

    this.search = () =>
    {
      this.saveState();
      const params = { dtType: 'loadTree', tree_id: this.tree_id };
      this.gridOptions.api.showLoadingOverlay();
      return mainService.httpGet(params).then((data) =>
      {
        this.linesCount = data.length;
        this.gridOptions.api.setRowData(data);
        this.gridOptions.api.hideOverlay();
        this.restoreState();
      });
    };

    this.changeStatus = (id, field, status) =>
    {
      return commonService.doChangeStatus(id, field, status).then(() =>
      {
        return this.search();
      });
    };

    this.filterDlgOpen = (parent_id, id) =>
    {
      if (id)
      {
        return mainService.httpGet({ dtType: 'nodeGet', id: id, parent_id: parent_id, tree_id: this.tree_id }).then(data =>
        {
          this.node = data;
          this.nodeDlgShow = true;
        });
      }
      else
      {
        this.node = { parent_id: parent_id, id: null, name: '', has_products: '0' };
        this.nodeDlgShow = true;
      }
    };

    this.submit = () =>
    {
      const params = utilsService.prepareParams(this.node);
      Object.assign(params, { dtType: 'submit', tree_id: this.tree_id });
      return mainService.httpPost(params).then(() =>
      {
        NotifierService.showSuccess('The data has been saved!');
        this.nodeDlgShow = false;
        return this.search();
      });
    };

    this.moveDlgOpen = (id) =>
    {
      this.node = this.gridOptions.api.getRowNode(id).data;
      return mainService.httpGet({ dtType: 'nodeList', tree_id: this.tree_id, node_id: id }).then(data =>
      {
        this.nodeList = data;
        this.moveDlgShow = true;
      });
    };

    this.moveSubmit = () =>
    {
      if (!this.targetNode)
        return new swal({ title: 'Error!', text: 'Select the target node!', icon: 'error' });

      const params =  { dtType: 'moveSubmit', target: this.targetNode?.id, source: this.node.id, tree_id: this.tree_id };
      return mainService.httpPost(params).then(() =>
      {
        NotifierService.showSuccess('The node has been moved!');
        this.moveDlgShow = false;
        return this.search();
      });
    };

    this.doSort = (id, type) =>
    {
      const params = { dtType: 'doSort', type: type, id: id };
      return mainService.httpPost(params).then(() =>
      {
        NotifierService.showSuccess('The sort has been done!');
        return this.search();
      });
    };

    this.back = () =>
    {
      $location.path('/');
    };

    this.setQuickFilter = () =>
    {
      this.gridOptions.api.setQuickFilter(this.quickfilterText);
    };
    this.resetQuickfilter = () =>
    {
      this.quickfilterText = '';
      this.gridOptions.api.setQuickFilter('');
    };
    this.getTitle = (status) =>
    {
      return status === '0' ? 'Deactivate' : 'Activate';
    };
    this.saveState = () =>
    {
      if (!this.gridOptions.api)
        return null;

      this.expandedNodes = [];
      this.gridOptions.api.forEachNode((node) =>
      {
        if (node.expanded)
          this.expandedNodes.push(node.key);
      });
    };

    this.restoreState = () =>
    {
      this.gridOptions.api.forEachNode((node) =>
      {
        if (this.expandedNodes.indexOf(node.key) !== -1)
          this.gridOptions.api.setRowNodeExpanded(node, true);
      });
    };

    this.gridOptions = gridOptionsTreeService.initGridOptions(this);
    this.loadFilter().then(() =>
    {
      try
      {
        $q.all([ this.loadFilter(), this.search() ]);
      }
      catch (e)
      {
        console.warn('Error in load:', e);
      }
    });
  }
]);

