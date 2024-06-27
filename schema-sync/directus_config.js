/**
 * This file contains the default configuration for the schema exporter.
 * 
 * Some possibly sensitive collections are commented out, remove the comments and add filters if needed
 * 
 * Uncomment the collection you want to export.
 * 
 * These are just some sensible settings, but you might not want to export everything
 * 
 * Add custom collections to the syncCustomCollections object in the config.js file.
 */
export const syncDirectusCollections = {
	directus_roles: {
		watch: ['roles'],
		query: {
			filter: {
				name: { _neq: "Administrator" },
			}
		},
	},
	directus_folders: {
		watch: ['folders'],
		excludeFields: [],
		query: {
			sort: ['parent', 'id'],
		},
	},
	directus_files: {
		watch: ['files'],
		excludeFields: ["modified_by", "uploaded_by"],
		query: {
			filter: { folder: { id: { _eq: "d169b6d9-9e72-4adc-aaca-548fa22aeab5" } } },
		},
	},
	directus_permissions: {
		watch: ['permissions', 'collections', 'fields'],
		excludeFields: ['id'],
		getKey: (o) => `${o.role ?? 'public'}-${o.collection}--${o.action}`,
		query: {
			sort: ['role', 'collection', 'action'],
		},
	},
	directus_settings: {
		watch: ['settings'],
		excludeFields: [
			'project_url',
			// always keep these 3 excluded
			'mv_hash', 'mv_ts', 'mv_locked',
		],
	},
	directus_dashboards: {
		watch: ['dashboards'],
		excludeFields: ['user_created', 'panels'],
	},
	directus_panels: {
		watch: ['panels'],
		excludeFields: ['user_created'],
	},
	directus_presets: {
		watch: ['presets'],
		excludeFields: ['id'],
		getKey: (o) => `${o.role ?? 'all'}-${o.collection}-${o.bookmark || 'default'}`,
		query: {
			filter: {
				user: { _null: true }
			}
		}
	},
	directus_flows: {
		watch: ['flows'],
		excludeFields: ['operations', 'user_created'],
	},
	directus_operations: {
		watch: ['operations'],
		excludeFields: ['user_created'],
		linkedFields: ['resolve', 'reject'],
	},
	directus_translations: {
		watch: ['translations'],
		excludeFields: ['id'],
		getKey: (o) => `${o.key}-${o.language}`,
		query: {
			sort: ['key', 'language'],
		},
	},
	directus_webhooks: {
		watch: ['webhooks'],
		excludeFields: ['url'],
	},

	// These are already exported via schema, so you might not need them
	/*directus_collections: {
		watch: ['relations'],
		query: {
			sort: ['collection'],
		},
	},*/
	/*directus_fields: {
		watch: ['fields', 'collections'],
		excludeFields: ['id'],
		getKey: (o) => `${o.collection}-${o.field}`,
		query: {
			sort: ['collection', 'field'],
		},
	},*/
	/*directus_relations: {
		watch: ['relations'],
		excludeFields: ['id'],
		getKey: (o) => `${o.many_collection}-${o.many_field}`,
		query: {
			sort: ['many_collection', 'many_field'],
		},
	},*/
};




