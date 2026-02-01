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
      
      singleClickEdit: true,
      context: { ctrl: ctrl },
      onCellEditingStopped: ctrl.onCellEditingStopped,
      autoGroupColumnDef: {
        headerName: 'Group / Attribute',
        field: 'name',
        flex: 1,
        cellRenderer: 'agGroupCellRenderer',
      },
      onGridReady:  params => { ctrl.gridApi = params.api; },
      getRowNodeId: (params) => params.id,
    };

    Object.assign(gridOptions, rendererService.gridOptions);
    gridOptions.headerHeight = 52;
    return gridOptions;
  };

  this.init = (ctrl) =>
  {
    function IsCustomHeader()
    {
    }

    IsCustomHeader.prototype.init = function(params)
    {
      this.params = params;

      const eGui = document.createElement('div');
      eGui.className = 'override-header';

      const title = document.createElement('div');
      title.className = 'override-title';
      title.innerHTML = 'Override<br/>description';

      const controls = document.createElement('div');
      controls.className = 'override-controls';

      const btnOn = document.createElement('button');
      btnOn.type = 'button';
      btnOn.className = 'btn-link glyphicon glyphicon-ok text-primary';

      const btnOff = document.createElement('button');
      btnOff.type = 'button';
      btnOff.className = 'btn-link glyphicon glyphicon-remove text-danger';

      const updateDisabled = function()
      {
        const hasSelected = params.api.getSelectedNodes().some(function(n)
        {
          return n.data && !n.data.isTotal;
        });

        btnOn.disabled = !hasSelected;
        btnOff.disabled = !hasSelected;
      };

      btnOn.addEventListener('click', function(e)
      {
        e.stopPropagation();
        params.context.ctrl
          .bulkSetIsCustomForSelected(1, params)
          .finally(updateDisabled);
      });

      btnOff.addEventListener('click', function(e)
      {
        e.stopPropagation();
        params.context.ctrl
          .bulkSetIsCustomForSelected(0, params)
          .finally(updateDisabled);
      });

      controls.appendChild(btnOn);
      controls.appendChild(btnOff);

      eGui.appendChild(title);
      eGui.appendChild(controls);

      this.eGui = eGui;
      this.updateDisabled = updateDisabled;

      params.api.addEventListener('selectionChanged', updateDisabled);
      updateDisabled();
    };

    IsCustomHeader.prototype.getGui = function()
    {
      return this.eGui;
    };

    IsCustomHeader.prototype.destroy = function()
    {
      this.params.api.removeEventListener('selectionChanged', this.updateDisabled);
    };

    const artCellRenderer = ({ data, value }) =>
    {
      return data && !data.isTotal ?
        `<a href="#" target="_blank">${value}</a>` : value;
    };

    const isCustomCellRenderer = (params) =>
    {
      if (!params.data || params.data.isTotal)
      {
        return '';
      }

      const input = document.createElement('input');
      input.type = 'checkbox';
      input.checked = (params.value === '1');

      input.addEventListener('click', function(e)
      {
        e.stopPropagation();
      });

      input.addEventListener('change', function()
      {
        const oldVal = params.value;                 // 0/1
        const newVal = input.checked ? 1 : 0;

        params.node.setDataValue('is_custom', newVal);
        input.disabled = true;

        const p = ctrl.onIsCustomChanged(params, newVal, oldVal);

        if (!p || !p.then)
        {
          input.disabled = false;
          return;
        }

        p.then(function()
        {
          input.disabled = false;
          params.api.flashCells({ rowNodes: [ params.node ], columns: [ 'is_custom' ] });
        })
          .catch(function()
          {
            params.node.setDataValue('is_custom', oldVal);
            input.checked = (oldVal === 1);
            input.disabled = false;
          });
      });
      return input;
    };
    
    const isCellEditable = ({ data }) =>
    {
      return (data && data.is_custom == '1');
    }

    const columnDefs = [
      { headerName: 'Article', field: 'code', flex: 1, type: 'nameCol', cellRenderer: artCellRenderer },

      {
        headerName: 'Custom description', 
        field: 'is_custom', 
        type: 'nameCol',
        suppressMenu: true,
        cellRenderer: isCustomCellRenderer,
        cellClass: [ 'text-center' ],
        width: 60,
        headerComponent: IsCustomHeader,
      },

      { headerName: 'Commercial Description', field: 'erp_name', flex: 2, type: 'nameCol', editable: isCellEditable, cellClass: [ 'editable-cell' ] },
      { headerName: 'ERP Description', field: 'commercial_name', flex: 2, type: 'nameCol', editable: isCellEditable, isCellEditable: [ 'editable-cell' ] },

      {
        headerName: '', field: 'checker', type: 'nameCol',
        checkboxSelection: params => params.data && !params.data.isTotal,
        headerCheckboxSelection: true, headerCheckboxSelectionFilteredOnly: true,
        suppressMenu: true, width: 20,
      },

    ];

    calcService.setColumnDefs(columnDefs);
    return columnDefs;
  };
});
