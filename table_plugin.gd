# table_plugin.gd
# This file is part of I, Voyager
# https://ivoyager.dev
# *****************************************************************************
# Copyright 2017-2023 Charlie Whitfield
# I, Voyager is a registered trademark of Charlie Whitfield in the US
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# *****************************************************************************
@tool
extends EditorPlugin

# Adds a custom resource, an EditorImportPlugin, and an autoload singleton.
# All user interface is through singleton 'IVTableData' (table_data.gd).
#
# Note: There is talk in Godot issues of depreciating 'add_custom_type()'.
# We prefer this method over file 'class_name' because it does not involve
# .godot/global_script_class_cache.cfg, which is buggy as of Godot 4.1.1 (fails
# to update changes outside of editor; we'll open an issue soon!).

const TableResource := preload("table_resource.gd")
const TableImporter := preload("table_importer.gd")

var table_importer: EditorImportPlugin


func _enter_tree():
	var config := ConfigFile.new()
	config.load("res://addons/ivoyager_table_importer/plugin.cfg")
	var version: String = config.get_value("plugin", "version")
	print("I, Voyager - Table Importer (plugin) v%s - https://ivoyager.dev" % version)
	var editor_gui := get_editor_interface().get_base_control()
	var table_res_icon := editor_gui.get_theme_icon("Grid", "EditorIcons")
	add_custom_type("IVTableResource", "Resource", TableResource, table_res_icon)
	table_importer = TableImporter.new()
	add_import_plugin(table_importer)
	add_autoload_singleton("IVTableData", "table_data.gd")


func _exit_tree():
	print("Removing I, Voyager - Table Importer (plugin)")
	remove_custom_type("IVTableResource")
	remove_import_plugin(table_importer)
	table_importer = null
	remove_autoload_singleton("IVTableData")

