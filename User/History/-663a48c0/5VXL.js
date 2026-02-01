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
        headerName: 'Group',
        field: 'name',
        flex: 1,
        cellRenderer: 'agGroupCellRenderer',
      },
      onGridReady:  params => { ctrl.gridApi = params.api; },
      getRowNodeId: (params) => params.id,
    };

    Object.assign(gridOptions, rendererService.gridOptions);
    return gridOptions;
  };

  this.init = () =>
  {
    const actionCellRenderer = ({ data }) =>
    {
      let res = '<span class="text-primary">';
      const faElem = data.status === '0' ? 'fa-power-off text-success' : 'fa-power-off text-danger';
      res += `
          <i class="pointer fa ${faElem}" ng-click="vm.changeStatus('${data.id}', 'TREE', '${data.status}')"
        title="{{vm.getTitle('${data.status}')}}"></i>
          <span class="l-5"></span>
          <i class="pointer fa fa-pencil-alt text-primary" ng-click="vm.treeDlgOpen('${data.id}')" title="Edit Tree"></i>
          `
      ;
      res += '</span>';
      return res;
    };

    const nameCellRenderer = ({ data, value }) =>
    {
      return data && !data.isTotal ?
        `<a href="javascript:void(0)" ng-click="vm.openTree('${data.id}')">${value}</a>` : value;
    };

    const columnDefs = [
      { headerName: 'Filter Name', field: 'name', type: 'nameCol', flex: 1, cellRenderer: nameCellRenderer },
      { headerName: 'Type', field: 'of_type_name', type: 'nameCol', width: 100 },
      { headerName: 'Childs', field: 'node_count', type: 'numCol', width: 80 },
      { headerName: 'Status', field: 'status', width: 70, type: 'nameCol', cellClass: [ 'text-center' ], cellRenderer: rendererService.statusCellRenderer },
      { headerName: 'Action', field: 'pos', width: 100, cellClass: [ 'text-left', 'l-15' ], cellRenderer: actionCellRenderer },
      { headerName: 'Edited', field: 'ch_edited', width: 90, type: 'dateCol' },
      { headerName: 'Editor', field: 'ch_editor', type: 'nameCol', width: 140 },
    ];

    calcService.setColumnDefs(columnDefs);
    return columnDefs;
  };
});
