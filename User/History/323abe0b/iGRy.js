/*-----------------------------------------
File    : app.js
Author  : za
Contact : za@e-vision.by
Date    : 05/05/2020

Description :
$Header: $
-----------------------------------------*/
'use strict';

/* eslint-disable */
agGrid.LicenseManager.setLicenseKey('CompanyName=ASBISc Enterprises,LicensedApplication=ASBIS,LicenseType=SingleApplication,LicensedConcurrentDeveloperCount=2,LicensedProductionInstancesCount=0,AssetReference=AG-017875,ExpiryDate=9_August_2022_[v2]_MTY1OTk5OTYwMDAwMA==8a3f7a004649f32c7fab51a5bbaf840a');
/* eslint-enable */
agGrid.initialiseAgGridWithAngular1(angular);
const app = angular.module('app', [ 'agGrid', 'ui.bootstrap', 'asb-common', 'ngModal', 'ui.router',
  'uib-dropdown-multiselect', 'ui.select', 'toExcel', 'toaster' ]);

app.config(($stateProvider, $urlRouterProvider) =>
{
  $urlRouterProvider.otherwise('');

  $stateProvider.state('root',
    {
      url: '',
      controller: 'listCtrl as vm',
      reloadOnSearch : false,
      templateUrl: './view/list.html'
    })
    .state('rootOne',
      {
        url: '/',
        controller: 'listCtrl as vm',
        reloadOnSearch : false,
        templateUrl: './view/list.html'
      })
    .state('tree',
      {
        url: '/:filter_id',
        controller: 'editCtrl as vm',
        reloadOnSearch : false,
        templateUrl: './view/edit.html'
      })
  ;
});
