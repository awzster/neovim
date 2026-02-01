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

    const path = [];
    let current = this.idMap.get(line_id);
    while (current) {
      path.unshift(current.line_id);
      current = current.parent_id ? this.idMap.get(current.parent_id) : null;
    }
    return path;
  };

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
      getRowNodeId: (params) => params.id,
    };

    Object.assign(gridOptions, rendererService.gridOptions);
    return gridOptions;
  };

  this.init = () =>
  {

    const columnDefs = [
      { headerName: 'Template Name', field: 'name', type: 'nameCol', flex: 1 },
      { headerName: 'Status', field: 'status', width: 70, type: 'nameCol', cellClass: [ 'text-center' ] },
      { headerName: 'Action', field: 'pos', width: 70, cellClass: [ 'text-center' ] },
      { headerName: 'Edited', field: 'ch_edited', width: 90, type: 'dateCol' },
      { headerName: 'Editor', field: 'ch_editor', type: 'nameCol', width: 140 },
    ];

    calcService.setColumnDefs(columnDefs);
    return columnDefs;
  };
});
