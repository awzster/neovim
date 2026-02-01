/* -----------------------------------------
File    : list.controller.js
Author  : za
Contact : za@e-vision.by
Date    : 09/02/2021

Description :
$Header: $
-----------------------------------------*/
'use strict';


angular.module('app').controller('listCtrlGroup', [ '$scope', '$filter', '$location', '$timeout', '$q', 'mainService',
  'gridOptionsServiceGroup', 'utilsService', '$stateParams', '$state', 'commonService',
  function($scope, $filter, $location, $timeout, $q, mainService, gridOptionsServiceGroup,
    utilsService, $stateParams, $state, commonService)
  {
    this.compCode = $('#compCode').val();
    this.pageId = $('#pageId').val();
    this.userId = $('#userId').val();
    this.lang = $('#lang').val();

    this.load = () =>
    {
      return mainService.httpGet({ dtType: 'loadFileter' }).then(data =>
      {
        Object.assign(this, data);
      });
    };

    this.search = () =>
    {
      this.gridOptions.api.showLoadingOverlay();
      return mainService.httpGet({ dtType: 'loadGroup' }).then((data) =>
      {
        this.linesCount = data.lines.length;
        this.linesCountActive = data.lines.filter(el => { return el.status === '0'; }).length;
        this.linesCountNotActive = data.lines.filter(el => { return el.status === '1'; }).length;
        this.gridOptions.api.setRowData(data.lines);
        this.gridOptions.api.hideOverlay();
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

    this.groupDlgOpen = (id) =>
    {
      return mainService.httpGet({ dtType: 'getGroup', id: id }).then(data =>
      {
        Object.assign(this, data);
        if (!id)
        {
          this.group = { status: '0' };
          this.groupDlgShow = true;
        }
        else
        {
          this.group.unitGroup = this.unitGroupList.find(el => { return el.id === this.group.unit_group_id; });
          this.group.dataType = this.dataTypeList.find(el => { return el.id === this.group.data_type; });
          return this.loadUnitByGroup().then(() =>
          {
            console.log(1);
            this.group.unit = this.unitList.find(el => { return el.id === this.group.default_unit_id; });
            console.log(1);
            this.groupDlgShow = true;
          });
        }
      });
    };

    this.groupSubmit = () =>
    {
      if (this.groupForm.$invalid)
        return;

      const params = utilsService.prepareParams(this.group);
      Object.assign(params, { dtType: 'groupSubmit' });
      return mainService.httpPost(params).then(() =>
      {
        this.groupDlgShow = false;
        return this.search();
      });
    };

    this.loadUnitByGroup = () =>
    {
      return mainService.httpGet({ dtType: 'loadUnitByGroup', group: this.group.unitGroup.id, unit: null }).then(data =>
      {
        this.unitList = data;
      });
    };

    this.getDlgTitle = (id) =>
    {
      return id ? 'Edit' : 'Create';
    };
    this.getTitle = (status) =>
    {
      return status === '0' ? 'Deactivate' : 'Activate';
    };

    this.itemPathOpen = (id) =>
    {
      $location.path('/item/' + id);
    };

    this.changeStatus = (id, field, status) =>
    {
      return commonService.doChangeStatus(id, field, status).then(() =>
      {
        return this.search();
      });
    };

    this.gridOptions = gridOptionsServiceGroup.initGridOptions(this);
    this.load().then(() =>
    {
      this.search();
    });
  }
]);
