/* -----------------------------------------
File    : gridOptionsApi.js
Author  : za
Contact : za@e-vision.by
Date    : 09/02/2021

Description : api gridOptions
$Header: $
-----------------------------------------*/
'use strict';
angular.module('app').service('gridOptionsService', function($http, $q, $timeout, $filter, calcService, rendererService)
{
  this.compCode = $('#compCode').val();
  this.pageId = $('#pageId').val();
  this.gridApi = null;

  this.initGridOptions = (ctrl) =>
  {
    const gridOptions = {
      columnDefs: this.init(ctrl),
      autoGroupColumnDef: {
        headerName: 'Group / Attribute',
        field: 'name',
        flex: 1,
        cellRenderer: 'agGroupCellRenderer',
      },
      getDataPath: (data) => buildPath(data.id),
        onGridReady:  params => { ctrl.gridApi = params.api; },
      getRowNodeId: (params) => params.id,
    };

    Object.assign(gridOptions, rendererService.gridOptions);
    return gridOptions;
  };

  this.init = () =>
  {

    const nameCellRenderer = ({ data, value }) =>
    {
      return data && !data.isTotal ?
      `<a href="javascript:void(0)" ng-click="vm.openTree('${data.id}')">${value}</a>` : value;
    }

    const columnDefs = [
      { headerName: 'Template Name', field: 'name', type: 'nameCol', flex: 1, cellREnderer: nameCellRenderer },
      { headerName: 'Status', field: 'status', width: 70, type: 'nameCol', cellClass: [ 'text-center' ] },
      { headerName: 'Action', field: 'pos', width: 70, cellClass: [ 'text-center' ] },
      { headerName: 'Edited', field: 'ch_edited', width: 90, type: 'dateCol' },
      { headerName: 'Editor', field: 'ch_editor', type: 'nameCol', width: 140 },
    ];

    calcService.setColumnDefs(columnDefs);
    return columnDefs;
  };
});
