/* -----------------------------------------
File    : list.controller.js
Author  : za
Contact : za@e-vision.by
Date    : 09/02/2021

Description :
$Header: $
-----------------------------------------*/
'use strict';


angular.module('app').controller('listCtrl', [ '$scope', '$location', '$timeout', '$q', '$filter', 'mainService',
  'gridOptionsService', 'utilsService', 'calcService', 'NotifierService', 'commonService',
  function($scope, $location, $timeout, $q, $filter, mainService, gridOptionsService, utilsService, calcService, NotifierService, commonService)
  {
    this.compCode = $('#compCode').val();
    this.pageId = $('#pageId').val();
    this.userId = $('#userId').val();
    this.lang = $('#lang').val();

    this.filter = { is_load: '0', pt: null };

    this.loadFilter = () =>
    {
      return mainService.httpGet({ dtType: 'loadFilter', compCode: this.compCode, pageId: this.pageId }).then((data) =>
      {
        Object.assign(this, data);
      });
    };

    this.search = () =>
    {
      const params = utilsService.prepareParams(this.filter);
      Object.assign(params, { is_load: '1', dtType: 'load' });
      $location.search(params);
      this.gridOptions.api.showLoadingOverlay();
      return mainService.httpGet(params).then((data) =>
      {
        this.linesCount = data.length;
        this.gridOptions.api.setRowData(data);
        this.gridOptions.api.hideOverlay();
      });
    };

    this.treeDlgOpen = (id) =>
    {
      if (id)
      {
        return mainService.httpGet({ dtType: 'getTree', tree_id: id }).then(data =>
        {
          this.tree =  data;
          this.tree.typeOf = { id: this.tree.of_type };
          this.treeDlgShow = true;
        });
      }
      this.tree = { name: '' };
      this.treeDlgShow = true;
    };

    this.treeSubmit = () =>
    {
      const params = utilsService.prepareParams(this.tree);
      Object.assign(params, { dtType: 'treeSubmit' });
      return mainService.httpPost(params).then(() =>
      {
        NotifierService.showSuccess('The data has been saved.');
        this.treeDlgShow = false;
        return this.search();
      });
    };

    this.changeStatus = (id, field, status) =>
    {
      return commonService.doChangeStatus(id, field, status).then(() =>
      {
        return this.search();
      });
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

    this.openTree = (id) =>
    {
      $location.path(`/${id}`);
    };

    this.gridOptions = gridOptionsService.initGridOptions(this);
    this.loadFilter().then(() =>
    {
      this.load();
    });
  }
]);

