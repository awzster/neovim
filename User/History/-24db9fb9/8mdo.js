/* -----------------------------------------
File    : list.controller.js
Author  : za
Contact : za@e-vision.by
Date    : 09/02/2021

Description :
$Header: $
-----------------------------------------*/
'use strict';


angular.module('app').controller('listCtrl', [ '$scope', '$filter', '$location', '$timeout', '$q', 'mainService',
  'gridOptionsService', 'dtIntervalService', 'utilsService', '$stateParams', '$state', 'calcService',
  function($scope, $filter, $location, $timeout, $q, mainService, gridOptionsService, dtIntervalService,
    utilsService, $stateParams, $state, calcService)
  {
    this.compCode = $('#compCode').val();
    this.pageId = $('#pageId').val();
    this.userId = $('#userId').val();
    this.lang = $('#lang').val();

    this.filter = { is_load: '0', brand: null, pt: null, selLang: null, tree: null, article: '' };

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
        utilsService.restoreUiSelect(this.filter, this.brandList, filter, 'brand');
        utilsService.restoreUiSelect(this.filter, this.ptList, filter, 'pt');
        utilsService.restoreUiSelect(this.filter, this.treeList, filter, 'tree');
        utilsService.restoreUiSelect(this.filter, this.langList, filter, 'selLang');
      }
      return $q.when(true);
    };

    this.load = () =>
    {
      let filter = $location.search();
      filter = filter || {};
      if (filter.is_load == '1')
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
        this.gridApi.setRowData(data.lines);
        //this.filterChanged();
        this.gridOptions.api.hideOverlay();
      });
    };

    this.filterChanged = () =>
    {
      const total = calcService.calcTotal(this.gridOptions);
      this.gridOptions.api.setPinnedTopRowData(total);
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

    this.onCellEditingStopped = (params) =>
    {
      if (params.value != params.oldValue)
      {
        try
        {
          const updParams = utilsService.prepareParams(params.data);
          Object.assign(updParams, { dtType: 'update', selLang: this.filter.selLang?.id || '', tree: this.filter.tree?.id || '' });
          return mainService.httpPost(updParams).then((response) => 
          {
            params.node.setData(response);
            params.api.flashCells({ rowNodes: [ params.node ], columns: [ params.colDef.field ] });
          });
        }
        catch (e) 
        {
          console.warn('Error in update:', e);
        }
      }
    };

    this.onIsCustomChanged = (params, newVal, oldVal) =>
    {
      try
      {
        if (newVal === oldVal)
          return $q.when(true);

        const updParams = utilsService.prepareParams(this.filter);
        Object.assign(updParams, {
          dtType: 'update',
          id: params.data.id,
          is_custom: newVal,
          commercial_name: params.data.commercial_name,
          erp_name: params.data.erp_name,
        });

        return mainService.httpPost(updParams).then((response) =>
        {
          params.node.setData(response);
          params.api.flashCells({ rowNodes: [ params.node ], columns: [ 'is_custom' ] });
          return response;
        });
      }
      catch (e)
      {
        console.warn('Error in onIsCustomChanged:', e);
        return $q.reject(e);
      }
    };

    this.bulkSetIsCustomForSelected = (newVal, headerParams) =>
    {
      try
      {
        const nodes = headerParams.api.getSelectedNodes().filter((n) => n.data && !n.data.isTotal);
        if (nodes.length > 100)
          return new swal({ title: 'Error!', text: 'You can select up to 100 row only!', icon: 'error' });

        if (!nodes.length)
          return $q.when(true);

        const ids = nodes.map((n) => n.data.id);

        nodes.forEach((n) =>
        {
          n.setDataValue('is_custom', newVal);
        });

        const updParams = utilsService.prepareParams(this.filter);
        Object.assign(updParams, {
          dtType: 'bulkSetIsCustom',
          ids: ids.map(el => el).join(','),
          is_custom: newVal
        });

        return mainService.httpPost(updParams).then((response) =>
        {
          headerParams.api.flashCells({ rowNodes: nodes, columns: [ 'is_custom' ] });
          headerParams.api.refreshHeader();
          return this.search();
        });
      }
      catch (e)
      {
        return $q.reject(e);
      }
    };
    
    

    this.gridOptions = gridOptionsService.initGridOptions(this);
    this.loadFilter().then(() => 
    {
      this.load();
    });
  }
]);
