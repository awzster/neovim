/* -----------------------------------------
File    : list.controller.js
Author  : za
Contact : za@e-vision.by
Date    : 09/02/2021

Description :
$Header: $
-----------------------------------------*/
'use strict';


angular.module('app').controller('listCtrl', [ '$scope', '$location', '$timeout', '$q', 'mainService', 'gridOptionsService',
  'utilsService', 'calcService', 'NotifierService',
  function($scope, $location, $timeout, $q, mainService, gridOptionsService, utilsService, calcService, NotifierService)
  {
    this.compCode = $('#compCode').val();
    this.pageId = $('#pageId').val();
    this.userId = $('#userId').val();
    this.lang = $('#lang').val();

    this.filter = { is_load: '0', sourceLang: null, translateLang: null, type: null };

    this.loadFilter = () =>
    {
      return mainService.httpGet({ dtType: 'loadFilter', compCode: this.compCode, pageId: this.pageId }).then((data) => 
      {
        Object.assign(this, data);
        this.filter.sourceLang = this.langList.find(el => { return el.id === 'en_en'; });
        this.filter.translateLang = this.langList.find(el => { return el.id === this.lang; });
      });
    };

    this.setupFilters = (filter) =>
    {
      if (filter)
      {
        utilsService.restoreFilter(this.filter, filter);
        utilsService.restoreUiSelect(this.filter, this.langList, filter, 'sourceLang');
        utilsService.restoreUiSelect(this.filter, this.langList, filter, 'translateLang');
        utilsService.restoreUiSelect(this.filter, this.typeList, filter, 'type');
        return this.onSelectType().then(() => 
        {
          utilsService.restoreUiSelect(this.filter, this.parentList, filter, 'parent');
        });
      }
      return $q.when(true);
    };

    this.load = () =>
    {
      try
      {
        let filter = $location.search();
        filter = filter || {};
        if (filter.is_load == '1')
          return this.setupFilters(filter).then(() => 
          {
            $timeout(() => 
            {
              return this.search();
            }, 500);
          });
      }
      catch (e) 
      {
        console.warn('Error in load:', e);
      }
    };

    this.search = () =>
    {
      if (this.searchForm.$invalid) 
        return;

      try
      {
        const params = utilsService.prepareParams(this.filter);
        Object.assign(params, { is_load: '1', dtType: 'load' });
        $location.search(params);
        this.gridOptions.api.showLoadingOverlay();
        return mainService.httpGet(params).then((data) => 
        {
          this.linesCount = data.lines.length;
          this.gridApi.setRowData(data.lines);
          this.filterChanged();
          this.gridOptions.api.hideOverlay();
        });
      }
      catch (e) 
      {
        console.warn('Error in search:', e);
      }
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
      try
      {
        if (params.node.data.name_translate === '')
        {
          params.node.setDataValue('name_translate', params.oldValue);
          return $q.when(true);
        }
        if (params.value != params.oldValue)
        {
          const updParams = utilsService.prepareParams(this.filter);
          Object.assign(updParams, { dtType: 'doTranslate', id: params.data.id, name_translate: params.data.name_translate });
          return mainService.httpPost(updParams).then((response) => 
          {
            //NotifierService.showSuccess('The data has been changed!');
            params.node.setData(response);
            params.api.flashCells({ rowNodes: [ params.node ], columns: [ params.colDef.field ] });
          });
        }
      }
      catch (e) 
      {
        console.warn('Error in onCellEditingStopped:', e);
      }
    };

    this.doCopy = (pos) =>
    {
      const node = this.gridOptions.api.getRowNode(pos);
      const updParams = utilsService.prepareParams(this.filter);
      Object.assign(updParams, { dtType: 'doTranslate', id: node.data.id, name_translate: node.data.name_source });
      return mainService.httpPost(updParams).then((response) => 
      {
        NotifierService.showSuccess('The data has been changed!');
        node.setData(response);
        this.gridOptions.api.flashCells({ rowNodes: [ node ], columns: [ 'name_translate' ] });
      });
    };

    this.onSelectType = () =>
    {
      return mainService.httpGet({ dtType: 'loadParent', type: this.filter.type?.id || '' }).then(data => 
      {
        this.parentList = data;
        this.filter.parent = null;
      });
    };

    this.gridOptions = gridOptionsService.initGridOptions(this);
    this.loadFilter().then(() => 
    {
      this.load();
    });
  }
]);

