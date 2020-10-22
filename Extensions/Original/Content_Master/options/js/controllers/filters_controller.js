
angular.module('CMOptionsApp').controller('filtersController', ['$scope', '$http', '$interval', '$rootScope',
	function ($scope, $http, $interval, $rootScope) {

		var getSelectedParserName = function () {
			var currentParserName;
			angular.forEach($scope.selectedUser.Parsers, function (parser, parserName) {
				if (parser === $scope.selectedParser) {
					currentParserName = parserName;
				};
			});
			return currentParserName;
		};
		
		$scope.selectUser = function (user) {
			if (user) $scope.selectedUser = user;
		};

		$scope.$watch('selectedUser', function (newUser, oldUser) {
			if (!angular.isDefined(newUser)) {
				return;
			};
			var oldParserName = 'AdBlockPlus';
			if (angular.isDefined(oldUser)) {
				angular.forEach(oldUser.Parsers, function (parser, parserName) {
					if (parser === $scope.selectedParser) {
						oldParserName = parserName;
					};
				});
			};
			$scope.selectParser(newUser.Parsers[oldParserName]);
		});

		$scope.selectParser = function (selectedParser) {
			$scope.selectedParser = selectedParser;
		};
		
		$scope.removeFile = function (index) {
			var currentParserName = getSelectedParserName();
			var url = $scope.selectedParser.Files[index].URL;
			$rootScope.options.fromUsersALL.Parsers[currentParserName].Files.splice(index, 1);
			angular.forEach($rootScope.users, function (user) {
				user.Parsers[currentParserName].Files.splice(index, 1);
			});
			angular.forEach($rootScope.options.fromUsersALL.Sources, function (source, i) {
				if (currentParserName == source.Parser && url == source.URL) {
					$rootScope.options.fromUsersALL.Sources.splice(i, 1);
				};
			});
		};

		$scope.clearNewSourceData = function () {
			this.hideAddFile = true;
			this.newSourceName = "";
			this.newSourceURL = "";
		};
		
		$scope.addNewSource = function () {
			if (!this.AddNewSourceForm.NameInput.$valid) {
				return;
			};
			if (this.newSourceName && this.newSourceName!="" && this.newSourceURL && this.newSourceURL!="") {
				var isInList;
				var currentParserName = getSelectedParserName();
				var newSourceURL = this.newSourceURL;
				var newSourceName = this.newSourceName;
				angular.forEach($rootScope.options.fromUsersALL.Sources, function (existedSource) {
					if (currentParserName == existedSource.Parser && (newSourceURL == existedSource.URL || newSourceName == existedSource.Name)) {
						isInList = true;
					};
				});
				if (!isInList) {
					this.hideAddFile = true;
					$rootScope.options.fromUsersALL.Sources.push({
						"Name" : newSourceName,
						"URL" : newSourceURL,
						"Parser" : currentParserName,
						"Comment" : this.newSourceComment
					});
					$rootScope.options.fromUsersALL.Parsers[currentParserName].Files.push({
						"URL" : newSourceURL,
						"On" : true
					});
					angular.forEach($rootScope.users, function (user) {
						user.Parsers[currentParserName].Files.push({
							"URL" : newSourceURL,
							"On" : true
						});
					});
					this.newSourceName = "";
					this.newSourceURL = "";
				};
			};
		};
		
		$scope.editSourceFile = function (url) {
			var source = $rootScope.getSourceByURL(url);
			if (source.Parser == 'ContentMaster') {
				$rootScope.$broadcast('selectEditorFile', source.Name);
				$rootScope.gotoPage('editor');
			} else {
				return $http.get('cmd_EditSource/?file=' + url, { "headers":{ "Editor": $rootScope.options.fromUsersALL.Editor } })
					.success(function (data) {
					})
					.error(function (data, status) {
						console.info(status)
					});
			};
		};

		$scope.isEditable = function (url) {
			return $rootScope.isLocalUser || $rootScope.getSourceByURL(url).Parser=='ContentMatser'
		};
		
		$scope.update = function (obj) {
			if (obj != 'Sources') {
				return $http.get('cmd_UpdateCM')
					.success(function () {
						if (obj != 'CM') {
							return $http.get('cmd_UpdateSources')
								.success(function () {
									$scope.saveOptions();
								})
								.error(function (data, status) {
									console.info(status)
								});
						} else {
							$scope.saveOptions();
						};
					})
					.error(function (data, status) {
						console.info(status)
					});
			} else {
				return $http.get('cmd_UpdateSources')
					.success(function () {
						$scope.saveOptions();
					})
					.error(function (data, status) {
						console.info(status)
					});
			};
		};
		
	}
])
