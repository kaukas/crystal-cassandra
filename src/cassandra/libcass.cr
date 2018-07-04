module Cassandra
  @[Link("cassandra")]
  lib LibCass
    CassFalse = 0
    CassTrue = 1
    fun cass_cluster_new : CassCluster
    type CassCluster = Void*
    fun cass_cluster_free(cluster : CassCluster)
    fun cass_cluster_set_contact_points(cluster : CassCluster, contact_points : LibC::Char*) : CassError
    enum CassError
      CassOk = 0
      CassErrorLibBadParams = 16777217
      CassErrorLibNoStreams = 16777218
      CassErrorLibUnableToInit = 16777219
      CassErrorLibMessageEncode = 16777220
      CassErrorLibHostResolution = 16777221
      CassErrorLibUnexpectedResponse = 16777222
      CassErrorLibRequestQueueFull = 16777223
      CassErrorLibNoAvailableIoThread = 16777224
      CassErrorLibWriteError = 16777225
      CassErrorLibNoHostsAvailable = 16777226
      CassErrorLibIndexOutOfBounds = 16777227
      CassErrorLibInvalidItemCount = 16777228
      CassErrorLibInvalidValueType = 16777229
      CassErrorLibRequestTimedOut = 16777230
      CassErrorLibUnableToSetKeyspace = 16777231
      CassErrorLibCallbackAlreadySet = 16777232
      CassErrorLibInvalidStatementType = 16777233
      CassErrorLibNameDoesNotExist = 16777234
      CassErrorLibUnableToDetermineProtocol = 16777235
      CassErrorLibNullValue = 16777236
      CassErrorLibNotImplemented = 16777237
      CassErrorLibUnableToConnect = 16777238
      CassErrorLibUnableToClose = 16777239
      CassErrorLibNoPagingState = 16777240
      CassErrorLibParameterUnset = 16777241
      CassErrorLibInvalidErrorResultType = 16777242
      CassErrorLibInvalidFutureType = 16777243
      CassErrorLibInternalError = 16777244
      CassErrorLibInvalidCustomType = 16777245
      CassErrorLibInvalidData = 16777246
      CassErrorLibNotEnoughData = 16777247
      CassErrorLibInvalidState = 16777248
      CassErrorLibNoCustomPayload = 16777249
      CassErrorServerServerError = 33554432
      CassErrorServerProtocolError = 33554442
      CassErrorServerBadCredentials = 33554688
      CassErrorServerUnavailable = 33558528
      CassErrorServerOverloaded = 33558529
      CassErrorServerIsBootstrapping = 33558530
      CassErrorServerTruncateError = 33558531
      CassErrorServerWriteTimeout = 33558784
      CassErrorServerReadTimeout = 33559040
      CassErrorServerReadFailure = 33559296
      CassErrorServerFunctionFailure = 33559552
      CassErrorServerWriteFailure = 33559808
      CassErrorServerSyntaxError = 33562624
      CassErrorServerUnauthorized = 33562880
      CassErrorServerInvalidQuery = 33563136
      CassErrorServerConfigError = 33563392
      CassErrorServerAlreadyExists = 33563648
      CassErrorServerUnprepared = 33563904
      CassErrorSslInvalidCert = 50331649
      CassErrorSslInvalidPrivateKey = 50331650
      CassErrorSslNoPeerCert = 50331651
      CassErrorSslInvalidPeerCert = 50331652
      CassErrorSslIdentityMismatch = 50331653
      CassErrorSslProtocolError = 50331654
      CassErrorLastEntry = 50331655
    end
    fun cass_cluster_set_contact_points_n(cluster : CassCluster, contact_points : LibC::Char*, contact_points_length : LibC::SizeT) : CassError
    fun cass_cluster_set_port(cluster : CassCluster, port : LibC::Int) : CassError
    fun cass_cluster_set_local_address(cluster : CassCluster, name : LibC::Char*) : CassError
    fun cass_cluster_set_local_address_n(cluster : CassCluster, name : LibC::Char*, name_length : LibC::SizeT) : CassError
    fun cass_cluster_set_ssl(cluster : CassCluster, ssl : CassSsl)
    type CassSsl = Void*
    fun cass_cluster_set_authenticator_callbacks(cluster : CassCluster, exchange_callbacks : CassAuthenticatorCallbacks*, cleanup_callback : CassAuthenticatorDataCleanupCallback, data : Void*) : CassError
    struct CassAuthenticatorCallbacks
      initial_callback : CassAuthenticatorInitialCallback
      challenge_callback : CassAuthenticatorChallengeCallback
      success_callback : CassAuthenticatorSuccessCallback
      cleanup_callback : CassAuthenticatorCleanupCallback
    end
    type CassAuthenticator = Void*
    alias CassAuthenticatorInitialCallback = (CassAuthenticator, Void* -> Void)
    alias CassAuthenticatorChallengeCallback = (CassAuthenticator, Void*, LibC::Char*, LibC::SizeT -> Void)
    alias CassAuthenticatorSuccessCallback = (CassAuthenticator, Void*, LibC::Char*, LibC::SizeT -> Void)
    alias CassAuthenticatorCleanupCallback = (CassAuthenticator, Void* -> Void)
    alias CassAuthenticatorDataCleanupCallback = (Void* -> Void)
    fun cass_cluster_set_protocol_version(cluster : CassCluster, protocol_version : LibC::Int) : CassError
    fun cass_cluster_set_use_beta_protocol_version(cluster : CassCluster, enable : CassBoolT) : CassError
    enum CassBoolT
      CassFalse = 0
      CassTrue = 1
    end
    fun cass_cluster_set_consistency(cluster : CassCluster, consistency : CassConsistency) : CassError
    enum CassConsistency
      CassConsistencyUnknown = 65535
      CassConsistencyAny = 0
      CassConsistencyOne = 1
      CassConsistencyTwo = 2
      CassConsistencyThree = 3
      CassConsistencyQuorum = 4
      CassConsistencyAll = 5
      CassConsistencyLocalQuorum = 6
      CassConsistencyEachQuorum = 7
      CassConsistencySerial = 8
      CassConsistencyLocalSerial = 9
      CassConsistencyLocalOne = 10
    end
    fun cass_cluster_set_serial_consistency(cluster : CassCluster, consistency : CassConsistency) : CassError
    fun cass_cluster_set_num_threads_io(cluster : CassCluster, num_threads : LibC::UInt) : CassError
    fun cass_cluster_set_queue_size_io(cluster : CassCluster, queue_size : LibC::UInt) : CassError
    fun cass_cluster_set_queue_size_event(cluster : CassCluster, queue_size : LibC::UInt) : CassError
    fun cass_cluster_set_core_connections_per_host(cluster : CassCluster, num_connections : LibC::UInt) : CassError
    fun cass_cluster_set_max_connections_per_host(cluster : CassCluster, num_connections : LibC::UInt) : CassError
    fun cass_cluster_set_reconnect_wait_time(cluster : CassCluster, wait_time : LibC::UInt)
    fun cass_cluster_set_max_concurrent_creation(cluster : CassCluster, num_connections : LibC::UInt) : CassError
    fun cass_cluster_set_max_concurrent_requests_threshold(cluster : CassCluster, num_requests : LibC::UInt) : CassError
    fun cass_cluster_set_max_requests_per_flush(cluster : CassCluster, num_requests : LibC::UInt) : CassError
    fun cass_cluster_set_write_bytes_high_water_mark(cluster : CassCluster, num_bytes : LibC::UInt) : CassError
    fun cass_cluster_set_write_bytes_low_water_mark(cluster : CassCluster, num_bytes : LibC::UInt) : CassError
    fun cass_cluster_set_pending_requests_high_water_mark(cluster : CassCluster, num_requests : LibC::UInt) : CassError
    fun cass_cluster_set_pending_requests_low_water_mark(cluster : CassCluster, num_requests : LibC::UInt) : CassError
    fun cass_cluster_set_connect_timeout(cluster : CassCluster, timeout_ms : LibC::UInt)
    fun cass_cluster_set_request_timeout(cluster : CassCluster, timeout_ms : LibC::UInt)
    fun cass_cluster_set_resolve_timeout(cluster : CassCluster, timeout_ms : LibC::UInt)
    fun cass_cluster_set_credentials(cluster : CassCluster, username : LibC::Char*, password : LibC::Char*)
    fun cass_cluster_set_credentials_n(cluster : CassCluster, username : LibC::Char*, username_length : LibC::SizeT, password : LibC::Char*, password_length : LibC::SizeT)
    fun cass_cluster_set_load_balance_round_robin(cluster : CassCluster)
    fun cass_cluster_set_load_balance_dc_aware(cluster : CassCluster, local_dc : LibC::Char*, used_hosts_per_remote_dc : LibC::UInt, allow_remote_dcs_for_local_cl : CassBoolT) : CassError
    fun cass_cluster_set_load_balance_dc_aware_n(cluster : CassCluster, local_dc : LibC::Char*, local_dc_length : LibC::SizeT, used_hosts_per_remote_dc : LibC::UInt, allow_remote_dcs_for_local_cl : CassBoolT) : CassError
    fun cass_cluster_set_token_aware_routing(cluster : CassCluster, enabled : CassBoolT)
    fun cass_cluster_set_latency_aware_routing(cluster : CassCluster, enabled : CassBoolT)
    fun cass_cluster_set_latency_aware_routing_settings(cluster : CassCluster, exclusion_threshold : CassDoubleT, scale_ms : CassUint64T, retry_period_ms : CassUint64T, update_rate_ms : CassUint64T, min_measured : CassUint64T)
    alias CassDoubleT = LibC::Double
    alias CassUint64T = LibC::ULongLong
    fun cass_cluster_set_whitelist_filtering(cluster : CassCluster, hosts : LibC::Char*)
    fun cass_cluster_set_whitelist_filtering_n(cluster : CassCluster, hosts : LibC::Char*, hosts_length : LibC::SizeT)
    fun cass_cluster_set_blacklist_filtering(cluster : CassCluster, hosts : LibC::Char*)
    fun cass_cluster_set_blacklist_filtering_n(cluster : CassCluster, hosts : LibC::Char*, hosts_length : LibC::SizeT)
    fun cass_cluster_set_whitelist_dc_filtering(cluster : CassCluster, dcs : LibC::Char*)
    fun cass_cluster_set_whitelist_dc_filtering_n(cluster : CassCluster, dcs : LibC::Char*, dcs_length : LibC::SizeT)
    fun cass_cluster_set_blacklist_dc_filtering(cluster : CassCluster, dcs : LibC::Char*)
    fun cass_cluster_set_blacklist_dc_filtering_n(cluster : CassCluster, dcs : LibC::Char*, dcs_length : LibC::SizeT)
    fun cass_cluster_set_tcp_nodelay(cluster : CassCluster, enabled : CassBoolT)
    fun cass_cluster_set_tcp_keepalive(cluster : CassCluster, enabled : CassBoolT, delay_secs : LibC::UInt)
    fun cass_cluster_set_timestamp_gen(cluster : CassCluster, timestamp_gen : CassTimestampGen)
    type CassTimestampGen = Void*
    fun cass_cluster_set_connection_heartbeat_interval(cluster : CassCluster, interval_secs : LibC::UInt)
    fun cass_cluster_set_connection_idle_timeout(cluster : CassCluster, timeout_secs : LibC::UInt)
    fun cass_cluster_set_retry_policy(cluster : CassCluster, retry_policy : CassRetryPolicy)
    type CassRetryPolicy = Void*
    fun cass_cluster_set_use_schema(cluster : CassCluster, enabled : CassBoolT)
    fun cass_cluster_set_use_hostname_resolution(cluster : CassCluster, enabled : CassBoolT) : CassError
    fun cass_cluster_set_use_randomized_contact_points(cluster : CassCluster, enabled : CassBoolT) : CassError
    fun cass_cluster_set_constant_speculative_execution_policy(cluster : CassCluster, constant_delay_ms : CassInt64T, max_speculative_executions : LibC::Int) : CassError
    alias CassInt64T = LibC::LongLong
    fun cass_cluster_set_no_speculative_execution_policy(cluster : CassCluster) : CassError
    fun cass_cluster_set_prepare_on_all_hosts(cluster : CassCluster, enabled : CassBoolT) : CassError
    fun cass_cluster_set_prepare_on_up_or_add_host(cluster : CassCluster, enabled : CassBoolT) : CassError
    fun cass_cluster_set_no_compact(cluster : CassCluster, enabled : CassBoolT) : CassError
    fun cass_session_new : CassSession
    type CassSession = Void*
    fun cass_session_free(session : CassSession)
    fun cass_session_connect(session : CassSession, cluster : CassCluster) : CassFuture
    type CassFuture = Void*
    fun cass_session_connect_keyspace(session : CassSession, cluster : CassCluster, keyspace : LibC::Char*) : CassFuture
    fun cass_session_connect_keyspace_n(session : CassSession, cluster : CassCluster, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassFuture
    fun cass_session_close(session : CassSession) : CassFuture
    fun cass_session_prepare(session : CassSession, query : LibC::Char*) : CassFuture
    fun cass_session_prepare_n(session : CassSession, query : LibC::Char*, query_length : LibC::SizeT) : CassFuture
    fun cass_session_prepare_from_existing(session : CassSession, statement : CassStatement) : CassFuture
    type CassStatement = Void*
    fun cass_session_execute(session : CassSession, statement : CassStatement) : CassFuture
    fun cass_session_execute_batch(session : CassSession, batch : CassBatch) : CassFuture
    type CassBatch = Void*
    fun cass_session_get_schema_meta(session : CassSession) : CassSchemaMeta
    type CassSchemaMeta = Void*
    fun cass_session_get_metrics(session : CassSession, output : CassMetrics*)
    struct CassMetrics
      requests : CassMetricsRequests
      stats : CassMetricsStats
      errors : CassMetricsErrors
    end
    struct CassMetricsRequests
      min : CassUint64T
      max : CassUint64T
      mean : CassUint64T
      stddev : CassUint64T
      median : CassUint64T
      percentile_75th : CassUint64T
      percentile_95th : CassUint64T
      percentile_98th : CassUint64T
      percentile_99th : CassUint64T
      percentile_999th : CassUint64T
      mean_rate : CassDoubleT
      one_minute_rate : CassDoubleT
      five_minute_rate : CassDoubleT
      fifteen_minute_rate : CassDoubleT
    end
    struct CassMetricsStats
      total_connections : CassUint64T
      available_connections : CassUint64T
      exceeded_pending_requests_water_mark : CassUint64T
      exceeded_write_bytes_water_mark : CassUint64T
    end
    struct CassMetricsErrors
      connection_timeouts : CassUint64T
      pending_request_timeouts : CassUint64T
      request_timeouts : CassUint64T
    end
    fun cass_schema_meta_free(schema_meta : CassSchemaMeta)
    fun cass_schema_meta_snapshot_version(schema_meta : CassSchemaMeta) : CassUint32T
    alias CassUint32T = LibC::UInt
    fun cass_schema_meta_version(schema_meta : CassSchemaMeta) : CassVersion
    struct CassVersion
      major_version : LibC::Int
      minor_version : LibC::Int
      patch_version : LibC::Int
    end
    fun cass_schema_meta_keyspace_by_name(schema_meta : CassSchemaMeta, keyspace : LibC::Char*) : CassKeyspaceMeta
    type CassKeyspaceMeta = Void*
    fun cass_schema_meta_keyspace_by_name_n(schema_meta : CassSchemaMeta, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassKeyspaceMeta
    fun cass_keyspace_meta_name(keyspace_meta : CassKeyspaceMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun cass_keyspace_meta_table_by_name(keyspace_meta : CassKeyspaceMeta, table : LibC::Char*) : CassTableMeta
    type CassTableMeta = Void*
    fun cass_keyspace_meta_table_by_name_n(keyspace_meta : CassKeyspaceMeta, table : LibC::Char*, table_length : LibC::SizeT) : CassTableMeta
    fun cass_keyspace_meta_materialized_view_by_name(keyspace_meta : CassKeyspaceMeta, view : LibC::Char*) : CassMaterializedViewMeta
    type CassMaterializedViewMeta = Void*
    fun cass_keyspace_meta_materialized_view_by_name_n(keyspace_meta : CassKeyspaceMeta, view : LibC::Char*, view_length : LibC::SizeT) : CassMaterializedViewMeta
    fun cass_keyspace_meta_user_type_by_name(keyspace_meta : CassKeyspaceMeta, type : LibC::Char*) : CassDataType
    type CassDataType = Void*
    fun cass_keyspace_meta_user_type_by_name_n(keyspace_meta : CassKeyspaceMeta, type : LibC::Char*, type_length : LibC::SizeT) : CassDataType
    fun cass_keyspace_meta_function_by_name(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, arguments : LibC::Char*) : CassFunctionMeta
    type CassFunctionMeta = Void*
    fun cass_keyspace_meta_function_by_name_n(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, name_length : LibC::SizeT, arguments : LibC::Char*, arguments_length : LibC::SizeT) : CassFunctionMeta
    fun cass_keyspace_meta_aggregate_by_name(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, arguments : LibC::Char*) : CassAggregateMeta
    type CassAggregateMeta = Void*
    fun cass_keyspace_meta_aggregate_by_name_n(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, name_length : LibC::SizeT, arguments : LibC::Char*, arguments_length : LibC::SizeT) : CassAggregateMeta
    fun cass_keyspace_meta_field_by_name(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*) : CassValue
    type CassValue = Void*
    fun cass_keyspace_meta_field_by_name_n(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun cass_table_meta_name(table_meta : CassTableMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun cass_table_meta_column_by_name(table_meta : CassTableMeta, column : LibC::Char*) : CassColumnMeta
    type CassColumnMeta = Void*
    fun cass_table_meta_column_by_name_n(table_meta : CassTableMeta, column : LibC::Char*, column_length : LibC::SizeT) : CassColumnMeta
    fun cass_table_meta_column_count(table_meta : CassTableMeta) : LibC::SizeT
    fun cass_table_meta_column(table_meta : CassTableMeta, index : LibC::SizeT) : CassColumnMeta
    fun cass_table_meta_index_by_name(table_meta : CassTableMeta, index : LibC::Char*) : CassIndexMeta
    type CassIndexMeta = Void*
    fun cass_table_meta_index_by_name_n(table_meta : CassTableMeta, index : LibC::Char*, index_length : LibC::SizeT) : CassIndexMeta
    fun cass_table_meta_index_count(table_meta : CassTableMeta) : LibC::SizeT
    fun cass_table_meta_index(table_meta : CassTableMeta, index : LibC::SizeT) : CassIndexMeta
    fun cass_table_meta_materialized_view_by_name(table_meta : CassTableMeta, view : LibC::Char*) : CassMaterializedViewMeta
    fun cass_table_meta_materialized_view_by_name_n(table_meta : CassTableMeta, view : LibC::Char*, view_length : LibC::SizeT) : CassMaterializedViewMeta
    fun cass_table_meta_materialized_view_count(table_meta : CassTableMeta) : LibC::SizeT
    fun cass_table_meta_materialized_view(table_meta : CassTableMeta, index : LibC::SizeT) : CassMaterializedViewMeta
    fun cass_table_meta_partition_key_count(table_meta : CassTableMeta) : LibC::SizeT
    fun cass_table_meta_partition_key(table_meta : CassTableMeta, index : LibC::SizeT) : CassColumnMeta
    fun cass_table_meta_clustering_key_count(table_meta : CassTableMeta) : LibC::SizeT
    fun cass_table_meta_clustering_key(table_meta : CassTableMeta, index : LibC::SizeT) : CassColumnMeta
    fun cass_table_meta_clustering_key_order(table_meta : CassTableMeta, index : LibC::SizeT) : CassClusteringOrder
    enum CassClusteringOrder
      CassClusteringOrderNone = 0
      CassClusteringOrderAsc = 1
      CassClusteringOrderDesc = 2
    end
    fun cass_table_meta_field_by_name(table_meta : CassTableMeta, name : LibC::Char*) : CassValue
    fun cass_table_meta_field_by_name_n(table_meta : CassTableMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun cass_materialized_view_meta_column_by_name(view_meta : CassMaterializedViewMeta, column : LibC::Char*) : CassColumnMeta
    fun cass_materialized_view_meta_column_by_name_n(view_meta : CassMaterializedViewMeta, column : LibC::Char*, column_length : LibC::SizeT) : CassColumnMeta
    fun cass_materialized_view_meta_name(view_meta : CassMaterializedViewMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun cass_materialized_view_meta_base_table(view_meta : CassMaterializedViewMeta) : CassTableMeta
    fun cass_materialized_view_meta_column_count(view_meta : CassMaterializedViewMeta) : LibC::SizeT
    fun cass_materialized_view_meta_column(view_meta : CassMaterializedViewMeta, index : LibC::SizeT) : CassColumnMeta
    fun cass_materialized_view_meta_partition_key_count(view_meta : CassMaterializedViewMeta) : LibC::SizeT
    fun cass_materialized_view_meta_partition_key(view_meta : CassMaterializedViewMeta, index : LibC::SizeT) : CassColumnMeta
    fun cass_materialized_view_meta_clustering_key_count(view_meta : CassMaterializedViewMeta) : LibC::SizeT
    fun cass_materialized_view_meta_clustering_key(view_meta : CassMaterializedViewMeta, index : LibC::SizeT) : CassColumnMeta
    fun cass_materialized_view_meta_clustering_key_order(view_meta : CassMaterializedViewMeta, index : LibC::SizeT) : CassClusteringOrder
    fun cass_materialized_view_meta_field_by_name(view_meta : CassMaterializedViewMeta, name : LibC::Char*) : CassValue
    fun cass_materialized_view_meta_field_by_name_n(view_meta : CassMaterializedViewMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun cass_column_meta_name(column_meta : CassColumnMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun cass_column_meta_type(column_meta : CassColumnMeta) : CassColumnType
    enum CassColumnType
      CassColumnTypeRegular = 0
      CassColumnTypePartitionKey = 1
      CassColumnTypeClusteringKey = 2
      CassColumnTypeStatic = 3
      CassColumnTypeCompactValue = 4
    end
    fun cass_column_meta_data_type(column_meta : CassColumnMeta) : CassDataType
    fun cass_column_meta_field_by_name(column_meta : CassColumnMeta, name : LibC::Char*) : CassValue
    fun cass_column_meta_field_by_name_n(column_meta : CassColumnMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun cass_index_meta_name(index_meta : CassIndexMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun cass_index_meta_type(index_meta : CassIndexMeta) : CassIndexType
    enum CassIndexType
      CassIndexTypeUnknown = 0
      CassIndexTypeKeys = 1
      CassIndexTypeCustom = 2
      CassIndexTypeComposites = 3
    end
    fun cass_index_meta_target(index_meta : CassIndexMeta, target : LibC::Char**, target_length : LibC::SizeT*)
    fun cass_index_meta_options(index_meta : CassIndexMeta) : CassValue
    fun cass_index_meta_field_by_name(index_meta : CassIndexMeta, name : LibC::Char*) : CassValue
    fun cass_index_meta_field_by_name_n(index_meta : CassIndexMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun cass_function_meta_name(function_meta : CassFunctionMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun cass_function_meta_full_name(function_meta : CassFunctionMeta, full_name : LibC::Char**, full_name_length : LibC::SizeT*)
    fun cass_function_meta_body(function_meta : CassFunctionMeta, body : LibC::Char**, body_length : LibC::SizeT*)
    fun cass_function_meta_language(function_meta : CassFunctionMeta, language : LibC::Char**, language_length : LibC::SizeT*)
    fun cass_function_meta_called_on_null_input(function_meta : CassFunctionMeta) : CassBoolT
    fun cass_function_meta_argument_count(function_meta : CassFunctionMeta) : LibC::SizeT
    fun cass_function_meta_argument(function_meta : CassFunctionMeta, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*, type : CassDataType*) : CassError
    fun cass_function_meta_argument_type_by_name(function_meta : CassFunctionMeta, name : LibC::Char*) : CassDataType
    fun cass_function_meta_argument_type_by_name_n(function_meta : CassFunctionMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassDataType
    fun cass_function_meta_return_type(function_meta : CassFunctionMeta) : CassDataType
    fun cass_function_meta_field_by_name(function_meta : CassFunctionMeta, name : LibC::Char*) : CassValue
    fun cass_function_meta_field_by_name_n(function_meta : CassFunctionMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun cass_aggregate_meta_name(aggregate_meta : CassAggregateMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun cass_aggregate_meta_full_name(aggregate_meta : CassAggregateMeta, full_name : LibC::Char**, full_name_length : LibC::SizeT*)
    fun cass_aggregate_meta_argument_count(aggregate_meta : CassAggregateMeta) : LibC::SizeT
    fun cass_aggregate_meta_argument_type(aggregate_meta : CassAggregateMeta, index : LibC::SizeT) : CassDataType
    fun cass_aggregate_meta_return_type(aggregate_meta : CassAggregateMeta) : CassDataType
    fun cass_aggregate_meta_state_type(aggregate_meta : CassAggregateMeta) : CassDataType
    fun cass_aggregate_meta_state_func(aggregate_meta : CassAggregateMeta) : CassFunctionMeta
    fun cass_aggregate_meta_final_func(aggregate_meta : CassAggregateMeta) : CassFunctionMeta
    fun cass_aggregate_meta_init_cond(aggregate_meta : CassAggregateMeta) : CassValue
    fun cass_aggregate_meta_field_by_name(aggregate_meta : CassAggregateMeta, name : LibC::Char*) : CassValue
    fun cass_aggregate_meta_field_by_name_n(aggregate_meta : CassAggregateMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun cass_ssl_new : CassSsl
    fun cass_ssl_new_no_lib_init : CassSsl
    fun cass_ssl_free(ssl : CassSsl)
    fun cass_ssl_add_trusted_cert(ssl : CassSsl, cert : LibC::Char*) : CassError
    fun cass_ssl_add_trusted_cert_n(ssl : CassSsl, cert : LibC::Char*, cert_length : LibC::SizeT) : CassError
    fun cass_ssl_set_verify_flags(ssl : CassSsl, flags : LibC::Int)
    fun cass_ssl_set_cert(ssl : CassSsl, cert : LibC::Char*) : CassError
    fun cass_ssl_set_cert_n(ssl : CassSsl, cert : LibC::Char*, cert_length : LibC::SizeT) : CassError
    fun cass_ssl_set_private_key(ssl : CassSsl, key : LibC::Char*, password : LibC::Char*) : CassError
    fun cass_ssl_set_private_key_n(ssl : CassSsl, key : LibC::Char*, key_length : LibC::SizeT, password : LibC::Char*, password_length : LibC::SizeT) : CassError
    fun cass_authenticator_address(auth : CassAuthenticator, address : CassInet*)
    struct CassInet
      address : CassUint8T[16]
      address_length : CassUint8T
    end
    alias CassUint8T = UInt8
    fun cass_authenticator_hostname(auth : CassAuthenticator, length : LibC::SizeT*) : LibC::Char*
    fun cass_authenticator_class_name(auth : CassAuthenticator, length : LibC::SizeT*) : LibC::Char*
    fun cass_authenticator_exchange_data(auth : CassAuthenticator) : Void*
    fun cass_authenticator_set_exchange_data(auth : CassAuthenticator, exchange_data : Void*)
    fun cass_authenticator_response(auth : CassAuthenticator, size : LibC::SizeT) : LibC::Char*
    fun cass_authenticator_set_response(auth : CassAuthenticator, response : LibC::Char*, response_size : LibC::SizeT)
    fun cass_authenticator_set_error(auth : CassAuthenticator, message : LibC::Char*)
    fun cass_authenticator_set_error_n(auth : CassAuthenticator, message : LibC::Char*, message_length : LibC::SizeT)
    fun cass_future_free(future : CassFuture)
    fun cass_future_set_callback(future : CassFuture, callback : CassFutureCallback, data : Void*) : CassError
    alias CassFutureCallback = (CassFuture, Void* -> Void)
    fun cass_future_ready(future : CassFuture) : CassBoolT
    fun cass_future_wait(future : CassFuture)
    fun cass_future_wait_timed(future : CassFuture, timeout_us : CassDurationT) : CassBoolT
    alias CassDurationT = CassUint64T
    fun cass_future_get_result(future : CassFuture) : CassResult
    type CassResult = Void*
    fun cass_future_get_error_result(future : CassFuture) : CassErrorResult
    type CassErrorResult = Void*
    fun cass_future_get_prepared(future : CassFuture) : CassPrepared
    type CassPrepared = Void*
    fun cass_future_error_code(future : CassFuture) : CassError
    fun cass_future_error_message(future : CassFuture, message : LibC::Char**, message_length : LibC::SizeT*)
    fun cass_future_custom_payload_item_count(future : CassFuture) : LibC::SizeT
    fun cass_future_custom_payload_item(future : CassFuture, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*, value : CassByteT**, value_size : LibC::SizeT*) : CassError
    alias CassByteT = CassUint8T
    fun cass_statement_new(query : LibC::Char*, parameter_count : LibC::SizeT) : CassStatement
    fun cass_statement_new_n(query : LibC::Char*, query_length : LibC::SizeT, parameter_count : LibC::SizeT) : CassStatement
    fun cass_statement_reset_parameters(statement : CassStatement, count : LibC::SizeT) : CassError
    fun cass_statement_free(statement : CassStatement)
    fun cass_statement_add_key_index(statement : CassStatement, index : LibC::SizeT) : CassError
    fun cass_statement_set_keyspace(statement : CassStatement, keyspace : LibC::Char*) : CassError
    fun cass_statement_set_keyspace_n(statement : CassStatement, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassError
    fun cass_statement_set_consistency(statement : CassStatement, consistency : CassConsistency) : CassError
    fun cass_statement_set_serial_consistency(statement : CassStatement, serial_consistency : CassConsistency) : CassError
    fun cass_statement_set_paging_size(statement : CassStatement, page_size : LibC::Int) : CassError
    fun cass_statement_set_paging_state(statement : CassStatement, result : CassResult) : CassError
    fun cass_statement_set_paging_state_token(statement : CassStatement, paging_state : LibC::Char*, paging_state_size : LibC::SizeT) : CassError
    fun cass_statement_set_timestamp(statement : CassStatement, timestamp : CassInt64T) : CassError
    fun cass_statement_set_request_timeout(statement : CassStatement, timeout_ms : CassUint64T) : CassError
    fun cass_statement_set_is_idempotent(statement : CassStatement, is_idempotent : CassBoolT) : CassError
    fun cass_statement_set_retry_policy(statement : CassStatement, retry_policy : CassRetryPolicy) : CassError
    fun cass_statement_set_custom_payload(statement : CassStatement, payload : CassCustomPayload) : CassError
    type CassCustomPayload = Void*
    fun cass_statement_bind_null(statement : CassStatement, index : LibC::SizeT) : CassError
    fun cass_statement_bind_null_by_name(statement : CassStatement, name : LibC::Char*) : CassError
    fun cass_statement_bind_null_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT) : CassError
    fun cass_statement_bind_int8(statement : CassStatement, index : LibC::SizeT, value : CassInt8T) : CassError
    alias CassInt8T = LibC::Char
    fun cass_statement_bind_int8_by_name(statement : CassStatement, name : LibC::Char*, value : CassInt8T) : CassError
    fun cass_statement_bind_int8_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassInt8T) : CassError
    fun cass_statement_bind_int16(statement : CassStatement, index : LibC::SizeT, value : CassInt16T) : CassError
    alias CassInt16T = LibC::Short
    fun cass_statement_bind_int16_by_name(statement : CassStatement, name : LibC::Char*, value : CassInt16T) : CassError
    fun cass_statement_bind_int16_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassInt16T) : CassError
    fun cass_statement_bind_int32(statement : CassStatement, index : LibC::SizeT, value : CassInt32T) : CassError
    alias CassInt32T = LibC::Int
    fun cass_statement_bind_int32_by_name(statement : CassStatement, name : LibC::Char*, value : CassInt32T) : CassError
    fun cass_statement_bind_int32_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassInt32T) : CassError
    fun cass_statement_bind_uint32(statement : CassStatement, index : LibC::SizeT, value : CassUint32T) : CassError
    fun cass_statement_bind_uint32_by_name(statement : CassStatement, name : LibC::Char*, value : CassUint32T) : CassError
    fun cass_statement_bind_uint32_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassUint32T) : CassError
    fun cass_statement_bind_int64(statement : CassStatement, index : LibC::SizeT, value : CassInt64T) : CassError
    fun cass_statement_bind_int64_by_name(statement : CassStatement, name : LibC::Char*, value : CassInt64T) : CassError
    fun cass_statement_bind_int64_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassInt64T) : CassError
    fun cass_statement_bind_float(statement : CassStatement, index : LibC::SizeT, value : CassFloatT) : CassError
    alias CassFloatT = LibC::Float
    fun cass_statement_bind_float_by_name(statement : CassStatement, name : LibC::Char*, value : CassFloatT) : CassError
    fun cass_statement_bind_float_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassFloatT) : CassError
    fun cass_statement_bind_double(statement : CassStatement, index : LibC::SizeT, value : CassDoubleT) : CassError
    fun cass_statement_bind_double_by_name(statement : CassStatement, name : LibC::Char*, value : CassDoubleT) : CassError
    fun cass_statement_bind_double_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassDoubleT) : CassError
    fun cass_statement_bind_bool(statement : CassStatement, index : LibC::SizeT, value : CassBoolT) : CassError
    fun cass_statement_bind_bool_by_name(statement : CassStatement, name : LibC::Char*, value : CassBoolT) : CassError
    fun cass_statement_bind_bool_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassBoolT) : CassError
    fun cass_statement_bind_string(statement : CassStatement, index : LibC::SizeT, value : LibC::Char*) : CassError
    fun cass_statement_bind_string_n(statement : CassStatement, index : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun cass_statement_bind_string_by_name(statement : CassStatement, name : LibC::Char*, value : LibC::Char*) : CassError
    fun cass_statement_bind_string_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun cass_statement_bind_bytes(statement : CassStatement, index : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_statement_bind_bytes_by_name(statement : CassStatement, name : LibC::Char*, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_statement_bind_bytes_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_statement_bind_custom(statement : CassStatement, index : LibC::SizeT, class_name : LibC::Char*, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_statement_bind_custom_n(statement : CassStatement, index : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_statement_bind_custom_by_name(statement : CassStatement, name : LibC::Char*, class_name : LibC::Char*, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_statement_bind_custom_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_statement_bind_uuid(statement : CassStatement, index : LibC::SizeT, value : CassUuid) : CassError
    struct CassUuid
      time_and_version : CassUint64T
      clock_seq_and_node : CassUint64T
    end
    fun cass_statement_bind_uuid_by_name(statement : CassStatement, name : LibC::Char*, value : CassUuid) : CassError
    fun cass_statement_bind_uuid_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassUuid) : CassError
    fun cass_statement_bind_inet(statement : CassStatement, index : LibC::SizeT, value : CassInet) : CassError
    fun cass_statement_bind_inet_by_name(statement : CassStatement, name : LibC::Char*, value : CassInet) : CassError
    fun cass_statement_bind_inet_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassInet) : CassError
    fun cass_statement_bind_decimal(statement : CassStatement, index : LibC::SizeT, varint : CassByteT*, varint_size : LibC::SizeT, scale : CassInt32T) : CassError
    fun cass_statement_bind_decimal_by_name(statement : CassStatement, name : LibC::Char*, varint : CassByteT*, varint_size : LibC::SizeT, scale : CassInt32T) : CassError
    fun cass_statement_bind_decimal_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, varint : CassByteT*, varint_size : LibC::SizeT, scale : CassInt32T) : CassError
    fun cass_statement_bind_duration(statement : CassStatement, index : LibC::SizeT, months : CassInt32T, days : CassInt32T, nanos : CassInt64T) : CassError
    fun cass_statement_bind_duration_by_name(statement : CassStatement, name : LibC::Char*, months : CassInt32T, days : CassInt32T, nanos : CassInt64T) : CassError
    fun cass_statement_bind_duration_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, months : CassInt32T, days : CassInt32T, nanos : CassInt64T) : CassError
    fun cass_statement_bind_collection(statement : CassStatement, index : LibC::SizeT, collection : CassCollection) : CassError
    type CassCollection = Void*
    fun cass_statement_bind_collection_by_name(statement : CassStatement, name : LibC::Char*, collection : CassCollection) : CassError
    fun cass_statement_bind_collection_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, collection : CassCollection) : CassError
    fun cass_statement_bind_tuple(statement : CassStatement, index : LibC::SizeT, tuple : CassTuple) : CassError
    type CassTuple = Void*
    fun cass_statement_bind_tuple_by_name(statement : CassStatement, name : LibC::Char*, tuple : CassTuple) : CassError
    fun cass_statement_bind_tuple_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, tuple : CassTuple) : CassError
    fun cass_statement_bind_user_type(statement : CassStatement, index : LibC::SizeT, user_type : CassUserType) : CassError
    type CassUserType = Void*
    fun cass_statement_bind_user_type_by_name(statement : CassStatement, name : LibC::Char*, user_type : CassUserType) : CassError
    fun cass_statement_bind_user_type_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, user_type : CassUserType) : CassError
    fun cass_prepared_free(prepared : CassPrepared)
    fun cass_prepared_bind(prepared : CassPrepared) : CassStatement
    fun cass_prepared_parameter_name(prepared : CassPrepared, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun cass_prepared_parameter_data_type(prepared : CassPrepared, index : LibC::SizeT) : CassDataType
    fun cass_prepared_parameter_data_type_by_name(prepared : CassPrepared, name : LibC::Char*) : CassDataType
    fun cass_prepared_parameter_data_type_by_name_n(prepared : CassPrepared, name : LibC::Char*, name_length : LibC::SizeT) : CassDataType
    fun cass_batch_new(type : CassBatchType) : CassBatch
    enum CassBatchType
      CassBatchTypeLogged = 0
      CassBatchTypeUnlogged = 1
      CassBatchTypeCounter = 2
    end
    fun cass_batch_free(batch : CassBatch)
    fun cass_batch_set_keyspace(batch : CassBatch, keyspace : LibC::Char*) : CassError
    fun cass_batch_set_keyspace_n(batch : CassBatch, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassError
    fun cass_batch_set_consistency(batch : CassBatch, consistency : CassConsistency) : CassError
    fun cass_batch_set_serial_consistency(batch : CassBatch, serial_consistency : CassConsistency) : CassError
    fun cass_batch_set_timestamp(batch : CassBatch, timestamp : CassInt64T) : CassError
    fun cass_batch_set_request_timeout(batch : CassBatch, timeout_ms : CassUint64T) : CassError
    fun cass_batch_set_is_idempotent(batch : CassBatch, is_idempotent : CassBoolT) : CassError
    fun cass_batch_set_retry_policy(batch : CassBatch, retry_policy : CassRetryPolicy) : CassError
    fun cass_batch_set_custom_payload(batch : CassBatch, payload : CassCustomPayload) : CassError
    fun cass_batch_add_statement(batch : CassBatch, statement : CassStatement) : CassError
    fun cass_data_type_new(type : CassValueType) : CassDataType
    enum CassValueType
      CassValueTypeUnknown = 65535
      CassValueTypeCustom = 0
      CassValueTypeAscii = 1
      CassValueTypeBigint = 2
      CassValueTypeBlob = 3
      CassValueTypeBoolean = 4
      CassValueTypeCounter = 5
      CassValueTypeDecimal = 6
      CassValueTypeDouble = 7
      CassValueTypeFloat = 8
      CassValueTypeInt = 9
      CassValueTypeText = 10
      CassValueTypeTimestamp = 11
      CassValueTypeUuid = 12
      CassValueTypeVarchar = 13
      CassValueTypeVarint = 14
      CassValueTypeTimeuuid = 15
      CassValueTypeInet = 16
      CassValueTypeDate = 17
      CassValueTypeTime = 18
      CassValueTypeSmallInt = 19
      CassValueTypeTinyInt = 20
      CassValueTypeDuration = 21
      CassValueTypeList = 32
      CassValueTypeMap = 33
      CassValueTypeSet = 34
      CassValueTypeUdt = 48
      CassValueTypeTuple = 49
      CassValueTypeLastEntry = 50
    end
    fun cass_data_type_new_from_existing(data_type : CassDataType) : CassDataType
    fun cass_data_type_new_tuple(item_count : LibC::SizeT) : CassDataType
    fun cass_data_type_new_udt(field_count : LibC::SizeT) : CassDataType
    fun cass_data_type_free(data_type : CassDataType)
    fun cass_data_type_type(data_type : CassDataType) : CassValueType
    fun cass_data_type_is_frozen(data_type : CassDataType) : CassBoolT
    fun cass_data_type_type_name(data_type : CassDataType, type_name : LibC::Char**, type_name_length : LibC::SizeT*) : CassError
    fun cass_data_type_set_type_name(data_type : CassDataType, type_name : LibC::Char*) : CassError
    fun cass_data_type_set_type_name_n(data_type : CassDataType, type_name : LibC::Char*, type_name_length : LibC::SizeT) : CassError
    fun cass_data_type_keyspace(data_type : CassDataType, keyspace : LibC::Char**, keyspace_length : LibC::SizeT*) : CassError
    fun cass_data_type_set_keyspace(data_type : CassDataType, keyspace : LibC::Char*) : CassError
    fun cass_data_type_set_keyspace_n(data_type : CassDataType, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassError
    fun cass_data_type_class_name(data_type : CassDataType, class_name : LibC::Char**, class_name_length : LibC::SizeT*) : CassError
    fun cass_data_type_set_class_name(data_type : CassDataType, class_name : LibC::Char*) : CassError
    fun cass_data_type_set_class_name_n(data_type : CassDataType, class_name : LibC::Char*, class_name_length : LibC::SizeT) : CassError
    fun cass_data_type_sub_type_count(data_type : CassDataType) : LibC::SizeT
    fun cass_data_sub_type_count(data_type : CassDataType) : LibC::SizeT
    fun cass_data_type_sub_data_type(data_type : CassDataType, index : LibC::SizeT) : CassDataType
    fun cass_data_type_sub_data_type_by_name(data_type : CassDataType, name : LibC::Char*) : CassDataType
    fun cass_data_type_sub_data_type_by_name_n(data_type : CassDataType, name : LibC::Char*, name_length : LibC::SizeT) : CassDataType
    fun cass_data_type_sub_type_name(data_type : CassDataType, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun cass_data_type_add_sub_type(data_type : CassDataType, sub_data_type : CassDataType) : CassError
    fun cass_data_type_add_sub_type_by_name(data_type : CassDataType, name : LibC::Char*, sub_data_type : CassDataType) : CassError
    fun cass_data_type_add_sub_type_by_name_n(data_type : CassDataType, name : LibC::Char*, name_length : LibC::SizeT, sub_data_type : CassDataType) : CassError
    fun cass_data_type_add_sub_value_type(data_type : CassDataType, sub_value_type : CassValueType) : CassError
    fun cass_data_type_add_sub_value_type_by_name(data_type : CassDataType, name : LibC::Char*, sub_value_type : CassValueType) : CassError
    fun cass_data_type_add_sub_value_type_by_name_n(data_type : CassDataType, name : LibC::Char*, name_length : LibC::SizeT, sub_value_type : CassValueType) : CassError
    fun cass_collection_new(type : CassCollectionType, item_count : LibC::SizeT) : CassCollection
    enum CassCollectionType
      CassCollectionTypeList = 32
      CassCollectionTypeMap = 33
      CassCollectionTypeSet = 34
    end
    fun cass_collection_new_from_data_type(data_type : CassDataType, item_count : LibC::SizeT) : CassCollection
    fun cass_collection_free(collection : CassCollection)
    fun cass_collection_data_type(collection : CassCollection) : CassDataType
    fun cass_collection_append_int8(collection : CassCollection, value : CassInt8T) : CassError
    fun cass_collection_append_int16(collection : CassCollection, value : CassInt16T) : CassError
    fun cass_collection_append_int32(collection : CassCollection, value : CassInt32T) : CassError
    fun cass_collection_append_uint32(collection : CassCollection, value : CassUint32T) : CassError
    fun cass_collection_append_int64(collection : CassCollection, value : CassInt64T) : CassError
    fun cass_collection_append_float(collection : CassCollection, value : CassFloatT) : CassError
    fun cass_collection_append_double(collection : CassCollection, value : CassDoubleT) : CassError
    fun cass_collection_append_bool(collection : CassCollection, value : CassBoolT) : CassError
    fun cass_collection_append_string(collection : CassCollection, value : LibC::Char*) : CassError
    fun cass_collection_append_string_n(collection : CassCollection, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun cass_collection_append_bytes(collection : CassCollection, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_collection_append_custom(collection : CassCollection, class_name : LibC::Char*, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_collection_append_custom_n(collection : CassCollection, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_collection_append_uuid(collection : CassCollection, value : CassUuid) : CassError
    fun cass_collection_append_inet(collection : CassCollection, value : CassInet) : CassError
    fun cass_collection_append_decimal(collection : CassCollection, varint : CassByteT*, varint_size : LibC::SizeT, scale : CassInt32T) : CassError
    fun cass_collection_append_duration(collection : CassCollection, months : CassInt32T, days : CassInt32T, nanos : CassInt64T) : CassError
    fun cass_collection_append_collection(collection : CassCollection, value : CassCollection) : CassError
    fun cass_collection_append_tuple(collection : CassCollection, value : CassTuple) : CassError
    fun cass_collection_append_user_type(collection : CassCollection, value : CassUserType) : CassError
    fun cass_tuple_new(item_count : LibC::SizeT) : CassTuple
    fun cass_tuple_new_from_data_type(data_type : CassDataType) : CassTuple
    fun cass_tuple_free(tuple : CassTuple)
    fun cass_tuple_data_type(tuple : CassTuple) : CassDataType
    fun cass_tuple_set_null(tuple : CassTuple, index : LibC::SizeT) : CassError
    fun cass_tuple_set_int8(tuple : CassTuple, index : LibC::SizeT, value : CassInt8T) : CassError
    fun cass_tuple_set_int16(tuple : CassTuple, index : LibC::SizeT, value : CassInt16T) : CassError
    fun cass_tuple_set_int32(tuple : CassTuple, index : LibC::SizeT, value : CassInt32T) : CassError
    fun cass_tuple_set_uint32(tuple : CassTuple, index : LibC::SizeT, value : CassUint32T) : CassError
    fun cass_tuple_set_int64(tuple : CassTuple, index : LibC::SizeT, value : CassInt64T) : CassError
    fun cass_tuple_set_float(tuple : CassTuple, index : LibC::SizeT, value : CassFloatT) : CassError
    fun cass_tuple_set_double(tuple : CassTuple, index : LibC::SizeT, value : CassDoubleT) : CassError
    fun cass_tuple_set_bool(tuple : CassTuple, index : LibC::SizeT, value : CassBoolT) : CassError
    fun cass_tuple_set_string(tuple : CassTuple, index : LibC::SizeT, value : LibC::Char*) : CassError
    fun cass_tuple_set_string_n(tuple : CassTuple, index : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun cass_tuple_set_bytes(tuple : CassTuple, index : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_tuple_set_custom(tuple : CassTuple, index : LibC::SizeT, class_name : LibC::Char*, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_tuple_set_custom_n(tuple : CassTuple, index : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_tuple_set_uuid(tuple : CassTuple, index : LibC::SizeT, value : CassUuid) : CassError
    fun cass_tuple_set_inet(tuple : CassTuple, index : LibC::SizeT, value : CassInet) : CassError
    fun cass_tuple_set_decimal(tuple : CassTuple, index : LibC::SizeT, varint : CassByteT*, varint_size : LibC::SizeT, scale : CassInt32T) : CassError
    fun cass_tuple_set_duration(tuple : CassTuple, index : LibC::SizeT, months : CassInt32T, days : CassInt32T, nanos : CassInt64T) : CassError
    fun cass_tuple_set_collection(tuple : CassTuple, index : LibC::SizeT, value : CassCollection) : CassError
    fun cass_tuple_set_tuple(tuple : CassTuple, index : LibC::SizeT, value : CassTuple) : CassError
    fun cass_tuple_set_user_type(tuple : CassTuple, index : LibC::SizeT, value : CassUserType) : CassError
    fun cass_user_type_new_from_data_type(data_type : CassDataType) : CassUserType
    fun cass_user_type_free(user_type : CassUserType)
    fun cass_user_type_data_type(user_type : CassUserType) : CassDataType
    fun cass_user_type_set_null(user_type : CassUserType, index : LibC::SizeT) : CassError
    fun cass_user_type_set_null_by_name(user_type : CassUserType, name : LibC::Char*) : CassError
    fun cass_user_type_set_null_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT) : CassError
    fun cass_user_type_set_int8(user_type : CassUserType, index : LibC::SizeT, value : CassInt8T) : CassError
    fun cass_user_type_set_int8_by_name(user_type : CassUserType, name : LibC::Char*, value : CassInt8T) : CassError
    fun cass_user_type_set_int8_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassInt8T) : CassError
    fun cass_user_type_set_int16(user_type : CassUserType, index : LibC::SizeT, value : CassInt16T) : CassError
    fun cass_user_type_set_int16_by_name(user_type : CassUserType, name : LibC::Char*, value : CassInt16T) : CassError
    fun cass_user_type_set_int16_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassInt16T) : CassError
    fun cass_user_type_set_int32(user_type : CassUserType, index : LibC::SizeT, value : CassInt32T) : CassError
    fun cass_user_type_set_int32_by_name(user_type : CassUserType, name : LibC::Char*, value : CassInt32T) : CassError
    fun cass_user_type_set_int32_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassInt32T) : CassError
    fun cass_user_type_set_uint32(user_type : CassUserType, index : LibC::SizeT, value : CassUint32T) : CassError
    fun cass_user_type_set_uint32_by_name(user_type : CassUserType, name : LibC::Char*, value : CassUint32T) : CassError
    fun cass_user_type_set_uint32_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassUint32T) : CassError
    fun cass_user_type_set_int64(user_type : CassUserType, index : LibC::SizeT, value : CassInt64T) : CassError
    fun cass_user_type_set_int64_by_name(user_type : CassUserType, name : LibC::Char*, value : CassInt64T) : CassError
    fun cass_user_type_set_int64_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassInt64T) : CassError
    fun cass_user_type_set_float(user_type : CassUserType, index : LibC::SizeT, value : CassFloatT) : CassError
    fun cass_user_type_set_float_by_name(user_type : CassUserType, name : LibC::Char*, value : CassFloatT) : CassError
    fun cass_user_type_set_float_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassFloatT) : CassError
    fun cass_user_type_set_double(user_type : CassUserType, index : LibC::SizeT, value : CassDoubleT) : CassError
    fun cass_user_type_set_double_by_name(user_type : CassUserType, name : LibC::Char*, value : CassDoubleT) : CassError
    fun cass_user_type_set_double_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassDoubleT) : CassError
    fun cass_user_type_set_bool(user_type : CassUserType, index : LibC::SizeT, value : CassBoolT) : CassError
    fun cass_user_type_set_bool_by_name(user_type : CassUserType, name : LibC::Char*, value : CassBoolT) : CassError
    fun cass_user_type_set_bool_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassBoolT) : CassError
    fun cass_user_type_set_string(user_type : CassUserType, index : LibC::SizeT, value : LibC::Char*) : CassError
    fun cass_user_type_set_string_n(user_type : CassUserType, index : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun cass_user_type_set_string_by_name(user_type : CassUserType, name : LibC::Char*, value : LibC::Char*) : CassError
    fun cass_user_type_set_string_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun cass_user_type_set_bytes(user_type : CassUserType, index : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_user_type_set_bytes_by_name(user_type : CassUserType, name : LibC::Char*, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_user_type_set_bytes_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_user_type_set_custom(user_type : CassUserType, index : LibC::SizeT, class_name : LibC::Char*, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_user_type_set_custom_n(user_type : CassUserType, index : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_user_type_set_custom_by_name(user_type : CassUserType, name : LibC::Char*, class_name : LibC::Char*, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_user_type_set_custom_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT) : CassError
    fun cass_user_type_set_uuid(user_type : CassUserType, index : LibC::SizeT, value : CassUuid) : CassError
    fun cass_user_type_set_uuid_by_name(user_type : CassUserType, name : LibC::Char*, value : CassUuid) : CassError
    fun cass_user_type_set_uuid_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassUuid) : CassError
    fun cass_user_type_set_inet(user_type : CassUserType, index : LibC::SizeT, value : CassInet) : CassError
    fun cass_user_type_set_inet_by_name(user_type : CassUserType, name : LibC::Char*, value : CassInet) : CassError
    fun cass_user_type_set_inet_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassInet) : CassError
    fun cass_user_type_set_decimal(user_type : CassUserType, index : LibC::SizeT, varint : CassByteT*, varint_size : LibC::SizeT, scale : LibC::Int) : CassError
    fun cass_user_type_set_decimal_by_name(user_type : CassUserType, name : LibC::Char*, varint : CassByteT*, varint_size : LibC::SizeT, scale : LibC::Int) : CassError
    fun cass_user_type_set_decimal_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, varint : CassByteT*, varint_size : LibC::SizeT, scale : LibC::Int) : CassError
    fun cass_user_type_set_duration(user_type : CassUserType, index : LibC::SizeT, months : CassInt32T, days : CassInt32T, nanos : CassInt64T) : CassError
    fun cass_user_type_set_duration_by_name(user_type : CassUserType, name : LibC::Char*, months : CassInt32T, days : CassInt32T, nanos : CassInt64T) : CassError
    fun cass_user_type_set_duration_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, months : CassInt32T, days : CassInt32T, nanos : CassInt64T) : CassError
    fun cass_user_type_set_collection(user_type : CassUserType, index : LibC::SizeT, value : CassCollection) : CassError
    fun cass_user_type_set_collection_by_name(user_type : CassUserType, name : LibC::Char*, value : CassCollection) : CassError
    fun cass_user_type_set_collection_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassCollection) : CassError
    fun cass_user_type_set_tuple(user_type : CassUserType, index : LibC::SizeT, value : CassTuple) : CassError
    fun cass_user_type_set_tuple_by_name(user_type : CassUserType, name : LibC::Char*, value : CassTuple) : CassError
    fun cass_user_type_set_tuple_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassTuple) : CassError
    fun cass_user_type_set_user_type(user_type : CassUserType, index : LibC::SizeT, value : CassUserType) : CassError
    fun cass_user_type_set_user_type_by_name(user_type : CassUserType, name : LibC::Char*, value : CassUserType) : CassError
    fun cass_user_type_set_user_type_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassUserType) : CassError
    fun cass_result_free(result : CassResult)
    fun cass_result_row_count(result : CassResult) : LibC::SizeT
    fun cass_result_column_count(result : CassResult) : LibC::SizeT
    fun cass_result_column_name(result : CassResult, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun cass_result_column_type(result : CassResult, index : LibC::SizeT) : CassValueType
    fun cass_result_column_data_type(result : CassResult, index : LibC::SizeT) : CassDataType
    fun cass_result_first_row(result : CassResult) : CassRow
    type CassRow = Void*
    fun cass_result_has_more_pages(result : CassResult) : CassBoolT
    fun cass_result_paging_state_token(result : CassResult, paging_state : LibC::Char**, paging_state_size : LibC::SizeT*) : CassError
    fun cass_error_result_free(error_result : CassErrorResult)
    fun cass_error_result_code(error_result : CassErrorResult) : CassError
    fun cass_error_result_consistency(error_result : CassErrorResult) : CassConsistency
    fun cass_error_result_responses_received(error_result : CassErrorResult) : CassInt32T
    fun cass_error_result_responses_required(error_result : CassErrorResult) : CassInt32T
    fun cass_error_result_num_failures(error_result : CassErrorResult) : CassInt32T
    fun cass_error_result_data_present(error_result : CassErrorResult) : CassBoolT
    fun cass_error_result_write_type(error_result : CassErrorResult) : CassWriteType
    enum CassWriteType
      CassWriteTypeUnknown = 0
      CassWriteTypeSimple = 1
      CassWriteTypeBatch = 2
      CassWriteTypeUnloggedBatch = 3
      CassWriteTypeCounter = 4
      CassWriteTypeBatchLog = 5
      CassWriteTypeCas = 6
      CassWriteTypeView = 7
      CassWriteTypeCdc = 8
    end
    fun cass_error_result_keyspace(error_result : CassErrorResult, keyspace : LibC::Char**, keyspace_length : LibC::SizeT*) : CassError
    fun cass_error_result_table(error_result : CassErrorResult, table : LibC::Char**, table_length : LibC::SizeT*) : CassError
    fun cass_error_result_function(error_result : CassErrorResult, function : LibC::Char**, function_length : LibC::SizeT*) : CassError
    fun cass_error_num_arg_types(error_result : CassErrorResult) : LibC::SizeT
    fun cass_error_result_arg_type(error_result : CassErrorResult, index : LibC::SizeT, arg_type : LibC::Char**, arg_type_length : LibC::SizeT*) : CassError
    fun cass_iterator_free(iterator : CassIterator)
    type CassIterator = Void*
    fun cass_iterator_type(iterator : CassIterator) : CassIteratorType
    enum CassIteratorType
      CassIteratorTypeResult = 0
      CassIteratorTypeRow = 1
      CassIteratorTypeCollection = 2
      CassIteratorTypeMap = 3
      CassIteratorTypeTuple = 4
      CassIteratorTypeUserTypeField = 5
      CassIteratorTypeMetaField = 6
      CassIteratorTypeKeyspaceMeta = 7
      CassIteratorTypeTableMeta = 8
      CassIteratorTypeTypeMeta = 9
      CassIteratorTypeFunctionMeta = 10
      CassIteratorTypeAggregateMeta = 11
      CassIteratorTypeColumnMeta = 12
      CassIteratorTypeIndexMeta = 13
      CassIteratorTypeMaterializedViewMeta = 14
    end
    fun cass_iterator_from_result(result : CassResult) : CassIterator
    fun cass_iterator_from_row(row : CassRow) : CassIterator
    fun cass_iterator_from_collection(value : CassValue) : CassIterator
    fun cass_iterator_from_map(value : CassValue) : CassIterator
    fun cass_iterator_from_tuple(value : CassValue) : CassIterator
    fun cass_iterator_fields_from_user_type(value : CassValue) : CassIterator
    fun cass_iterator_keyspaces_from_schema_meta(schema_meta : CassSchemaMeta) : CassIterator
    fun cass_iterator_tables_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun cass_iterator_materialized_views_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun cass_iterator_user_types_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun cass_iterator_functions_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun cass_iterator_aggregates_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun cass_iterator_fields_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun cass_iterator_columns_from_table_meta(table_meta : CassTableMeta) : CassIterator
    fun cass_iterator_indexes_from_table_meta(table_meta : CassTableMeta) : CassIterator
    fun cass_iterator_materialized_views_from_table_meta(table_meta : CassTableMeta) : CassIterator
    fun cass_iterator_fields_from_table_meta(table_meta : CassTableMeta) : CassIterator
    fun cass_iterator_columns_from_materialized_view_meta(view_meta : CassMaterializedViewMeta) : CassIterator
    fun cass_iterator_fields_from_materialized_view_meta(view_meta : CassMaterializedViewMeta) : CassIterator
    fun cass_iterator_fields_from_column_meta(column_meta : CassColumnMeta) : CassIterator
    fun cass_iterator_fields_from_index_meta(index_meta : CassIndexMeta) : CassIterator
    fun cass_iterator_fields_from_function_meta(function_meta : CassFunctionMeta) : CassIterator
    fun cass_iterator_fields_from_aggregate_meta(aggregate_meta : CassAggregateMeta) : CassIterator
    fun cass_iterator_next(iterator : CassIterator) : CassBoolT
    fun cass_iterator_get_row(iterator : CassIterator) : CassRow
    fun cass_iterator_get_column(iterator : CassIterator) : CassValue
    fun cass_iterator_get_value(iterator : CassIterator) : CassValue
    fun cass_iterator_get_map_key(iterator : CassIterator) : CassValue
    fun cass_iterator_get_map_value(iterator : CassIterator) : CassValue
    fun cass_iterator_get_user_type_field_name(iterator : CassIterator, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun cass_iterator_get_user_type_field_value(iterator : CassIterator) : CassValue
    fun cass_iterator_get_keyspace_meta(iterator : CassIterator) : CassKeyspaceMeta
    fun cass_iterator_get_table_meta(iterator : CassIterator) : CassTableMeta
    fun cass_iterator_get_materialized_view_meta(iterator : CassIterator) : CassMaterializedViewMeta
    fun cass_iterator_get_user_type(iterator : CassIterator) : CassDataType
    fun cass_iterator_get_function_meta(iterator : CassIterator) : CassFunctionMeta
    fun cass_iterator_get_aggregate_meta(iterator : CassIterator) : CassAggregateMeta
    fun cass_iterator_get_column_meta(iterator : CassIterator) : CassColumnMeta
    fun cass_iterator_get_index_meta(iterator : CassIterator) : CassIndexMeta
    fun cass_iterator_get_meta_field_name(iterator : CassIterator, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun cass_iterator_get_meta_field_value(iterator : CassIterator) : CassValue
    fun cass_row_get_column(row : CassRow, index : LibC::SizeT) : CassValue
    fun cass_row_get_column_by_name(row : CassRow, name : LibC::Char*) : CassValue
    fun cass_row_get_column_by_name_n(row : CassRow, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun cass_value_data_type(value : CassValue) : CassDataType
    fun cass_value_get_int8(value : CassValue, output : CassInt8T*) : CassError
    fun cass_value_get_int16(value : CassValue, output : CassInt16T*) : CassError
    fun cass_value_get_int32(value : CassValue, output : CassInt32T*) : CassError
    fun cass_value_get_uint32(value : CassValue, output : CassUint32T*) : CassError
    fun cass_value_get_int64(value : CassValue, output : CassInt64T*) : CassError
    fun cass_value_get_float(value : CassValue, output : CassFloatT*) : CassError
    fun cass_value_get_double(value : CassValue, output : CassDoubleT*) : CassError
    fun cass_value_get_bool(value : CassValue, output : CassBoolT*) : CassError
    fun cass_value_get_uuid(value : CassValue, output : CassUuid*) : CassError
    fun cass_value_get_inet(value : CassValue, output : CassInet*) : CassError
    fun cass_value_get_string(value : CassValue, output : LibC::Char**, output_size : LibC::SizeT*) : CassError
    fun cass_value_get_bytes(value : CassValue, output : CassByteT**, output_size : LibC::SizeT*) : CassError
    fun cass_value_get_decimal(value : CassValue, varint : CassByteT**, varint_size : LibC::SizeT*, scale : CassInt32T*) : CassError
    fun cass_value_get_duration(value : CassValue, months : CassInt32T*, days : CassInt32T*, nanos : CassInt64T*) : CassError
    fun cass_value_type(value : CassValue) : CassValueType
    fun cass_value_is_null(value : CassValue) : CassBoolT
    fun cass_value_is_collection(value : CassValue) : CassBoolT
    fun cass_value_is_duration(value : CassValue) : CassBoolT
    fun cass_value_item_count(collection : CassValue) : LibC::SizeT
    fun cass_value_primary_sub_type(collection : CassValue) : CassValueType
    fun cass_value_secondary_sub_type(collection : CassValue) : CassValueType
    fun cass_uuid_gen_new : CassUuidGen
    type CassUuidGen = Void*
    fun cass_uuid_gen_new_with_node(node : CassUint64T) : CassUuidGen
    fun cass_uuid_gen_free(uuid_gen : CassUuidGen)
    fun cass_uuid_gen_time(uuid_gen : CassUuidGen, output : CassUuid*)
    fun cass_uuid_gen_random(uuid_gen : CassUuidGen, output : CassUuid*)
    fun cass_uuid_gen_from_time(uuid_gen : CassUuidGen, timestamp : CassUint64T, output : CassUuid*)
    fun cass_uuid_min_from_time(time : CassUint64T, output : CassUuid*)
    fun cass_uuid_max_from_time(time : CassUint64T, output : CassUuid*)
    fun cass_uuid_timestamp(uuid : CassUuid) : CassUint64T
    fun cass_uuid_version(uuid : CassUuid) : CassUint8T
    fun cass_uuid_string(uuid : CassUuid, output : LibC::Char*)
    fun cass_uuid_from_string(str : LibC::Char*, output : CassUuid*) : CassError
    fun cass_uuid_from_string_n(str : LibC::Char*, str_length : LibC::SizeT, output : CassUuid*) : CassError
    fun cass_timestamp_gen_server_side_new : CassTimestampGen
    fun cass_timestamp_gen_monotonic_new : CassTimestampGen
    fun cass_timestamp_gen_monotonic_new_with_settings(warning_threshold_us : CassInt64T, warning_interval_ms : CassInt64T) : CassTimestampGen
    fun cass_timestamp_gen_free(timestamp_gen : CassTimestampGen)
    fun cass_retry_policy_default_new : CassRetryPolicy
    fun cass_retry_policy_downgrading_consistency_new : CassRetryPolicy
    fun cass_retry_policy_fallthrough_new : CassRetryPolicy
    fun cass_retry_policy_logging_new(child_retry_policy : CassRetryPolicy) : CassRetryPolicy
    fun cass_retry_policy_free(policy : CassRetryPolicy)
    fun cass_custom_payload_new : CassCustomPayload
    fun cass_custom_payload_free(payload : CassCustomPayload)
    fun cass_custom_payload_set(payload : CassCustomPayload, name : LibC::Char*, value : CassByteT*, value_size : LibC::SizeT)
    fun cass_custom_payload_set_n(payload : CassCustomPayload, name : LibC::Char*, name_length : LibC::SizeT, value : CassByteT*, value_size : LibC::SizeT)
    fun cass_custom_payload_remove(payload : CassCustomPayload, name : LibC::Char*)
    fun cass_custom_payload_remove_n(payload : CassCustomPayload, name : LibC::Char*, name_length : LibC::SizeT)
    fun cass_consistency_string(consistency : CassConsistency) : LibC::Char*
    fun cass_write_type_string(write_type : CassWriteType) : LibC::Char*
    fun cass_error_desc(error : CassError) : LibC::Char*
    fun cass_log_cleanup
    fun cass_log_set_level(log_level : CassLogLevel)
    enum CassLogLevel
      CassLogDisabled = 0
      CassLogCritical = 1
      CassLogError = 2
      CassLogWarn = 3
      CassLogInfo = 4
      CassLogDebug = 5
      CassLogTrace = 6
      CassLogLastEntry = 7
    end
    fun cass_log_set_callback(callback : CassLogCallback, data : Void*)
    struct CassLogMessage
      time_ms : CassUint64T
      severity : CassLogLevel
      file : LibC::Char*
      line : LibC::Int
      function : LibC::Char*
      message : LibC::Char[1024]
    end
    alias CassLogCallback = (CassLogMessage*, Void* -> Void)
    fun cass_log_set_queue_size(queue_size : LibC::SizeT)
    fun cass_log_level_string(log_level : CassLogLevel) : LibC::Char*
    fun cass_inet_init_v4(address : CassUint8T*) : CassInet
    fun cass_inet_init_v6(address : CassUint8T*) : CassInet
    fun cass_inet_string(inet : CassInet, output : LibC::Char*)
    fun cass_inet_from_string(str : LibC::Char*, output : CassInet*) : CassError
    fun cass_inet_from_string_n(str : LibC::Char*, str_length : LibC::SizeT, output : CassInet*) : CassError
    fun cass_date_from_epoch(epoch_secs : CassInt64T) : CassUint32T
    fun cass_time_from_epoch(epoch_secs : CassInt64T) : CassInt64T
    fun cass_date_time_to_epoch(date : CassUint32T, time : CassInt64T) : CassInt64T
  end
end
