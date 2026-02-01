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
      getDataPath: (data) => ctrl.buildPath(data.id),
      getRowNodeId: (params) => params.id,
    };

    Object.assign(gridOptions, rendererService.gridOptions);
    return gridOptions;
  };

  this.init = () =>
  {
    const nameCellRenderer  = ({ data, value }) =>
    {
      return data && !data.isTotal ?
        `<a href="javascript:void(0)" ng-click="vm.gotoTemplate('${data.id}')" title="Manage attribute group">${value}</a>` : value;
    };

    const linkCellRenderer = ({ data, value, valueFormatted, type, title,name }) =>
    {
      if (data && !data.isTotal)
      {
        if (Number(value) === 1 || Number(value) === 0)
          return data[ name ];
        return `<div class="text-right">
          <span class="text-primary qtip-count" ajax-qtip at="top left" my="top right"
          rel="/contentFc/template/dataHelper.jsp?dtType=linkHint&id=${data.id}&type=${type}&title=${title}">${value? value: '?'}</span>
          </div>`;
      }
      return value;
    };
    const actionCellRenderer = ({ data }) =>
    {
      let res = '<span class="text-primary">';
      const faElem = data.status === '0' ? 'fa-power-off text-success' : 'fa-power-off text-danger';
      if (!data || data.isTotal)
        return null;
      res = `
        <i class="pointer fa ${faElem}" ng-click="vm.changeStatus('${data.id}', 'PRODUCT_TEMPLATE', '${data.status}')"></i>
        <span class="l-5"?</span>
        <i class="pointer fa fa-pencil-alt text-primary" ng-click="vm.templateDlgOpen('${data.id}')" title="Edit Template"></i>
        `;
      res += '</span>';
      return res;
    };

    const columnDefs = [
      { headerName: 'ID', field: 'id', type: 'nameCol', width: 100, hide: true },
      { headerName: 'Template Name', field: 'name', type: 'nameCol', flex: 1, cellRenderer: nameCellRenderer },
      //{ headerName: 'Description', field: 'description', type: 'nameCol', flex: 1 },

      { headerName: 'Group', field: 'group_cnt', type: 'nameCol', width: 100,
        cellRenderer: linkCellRenderer, cellRendererParams: { type: 'GROUP', title: 'Group', name: 'group_name' }
      },
      { headerName: 'Product type', field: 'ptype_cnt', type: 'nameCol', width: 100,
        cellRenderer: linkCellRenderer, cellRendererParams: { type: 'PTYPE', title: 'Product type', name: 'ptype_name' }
      },
      //{ headerName: 'Brand', field: 'brand', type: 'nameCol', width: 100 },

      { headerName: 'Status', field: 'status', width: 70, type: 'nameCol', cellClass: [ 'text-center' ], cellRenderer: rendererService.statusCellRenderer },
      { headerName: 'Action', field: 'pos', width: 70, cellClass: [ 'text-center' ], cellRenderer: actionCellRenderer },
      { headerName: 'Edited', field: 'ch_edited', width: 90, type: 'dateCol' },
      { headerName: 'Editor', field: 'ch_editor', type: 'nameCol', width: 140 },
    ];

    calcService.setColumnDefs(columnDefs);
    return columnDefs;
  };
});
