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
  'gridOptionsService', 'utilsService', 'calcService',
  function($scope, $location, $timeout, $q, $filter, mainService, gridOptionsService, utilsService, calcService)
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

    this.setupFilters = (filter) =>
    {
      if (filter)
      {
        utilsService.restoreFilter(this.filter, filter);
        utilsService.restoreUiSelect(this.filter, this.ptList, filter, 'pt');
      }
      return $q.when(true);
    };

    this.load = () =>
    {
      let filter = $location.search();
      filter = filter || {};
      return this.setupFilters(filter).then(() =>
      {
        return this.search();
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
        this.linesCount = data.lines.length;
        this.gridOptions.api.setRowData(data.lines);
        this.gridOptions.api.hideOverlay();
      });
    };

    this.filterChanged = () =>
    {
      try
      {
        const total = calcService.calcTotal(this.gridOptions);
      }
      catch (e)
      {
        console.warn('Error in filterChanged:', e);
      }
otal);
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

