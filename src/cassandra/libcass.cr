module Cassandra
  {% if flag?(:static) %}
  @[Link("cassandra_static")]
  {% else %}
  @[Link("cassandra")]
  {% end %}
  lib LibCass
    VERSION_MAJOR = 2
    VERSION_MINOR = 11
    VERSION_PATCH = 0
    INET_V4_LENGTH = 4
    INET_V6_LENGTH = 16
    INET_STRING_LENGTH = 46
    UUID_STRING_LENGTH = 37
    LOG_MAX_MESSAGE_SIZE = 1024
    False = 0_i64
    True = 1_i64
    fun execution_profile_new = cass_execution_profile_new : CassExecProfile
    type CassExecProfile = Void*
    fun execution_profile_free = cass_execution_profile_free(profile : CassExecProfile)
    fun execution_profile_set_request_timeout = cass_execution_profile_set_request_timeout(profile : CassExecProfile, timeout_ms : Uint64T) : CassError
    alias Uint64T = LibC::ULongLong
    enum CassError
      Ok = 0
      ErrorLibBadParams = 16777217
      ErrorLibNoStreams = 16777218
      ErrorLibUnableToInit = 16777219
      ErrorLibMessageEncode = 16777220
      ErrorLibHostResolution = 16777221
      ErrorLibUnexpectedResponse = 16777222
      ErrorLibRequestQueueFull = 16777223
      ErrorLibNoAvailableIoThread = 16777224
      ErrorLibWriteError = 16777225
      ErrorLibNoHostsAvailable = 16777226
      ErrorLibIndexOutOfBounds = 16777227
      ErrorLibInvalidItemCount = 16777228
      ErrorLibInvalidValueType = 16777229
      ErrorLibRequestTimedOut = 16777230
      ErrorLibUnableToSetKeyspace = 16777231
      ErrorLibCallbackAlreadySet = 16777232
      ErrorLibInvalidStatementType = 16777233
      ErrorLibNameDoesNotExist = 16777234
      ErrorLibUnableToDetermineProtocol = 16777235
      ErrorLibNullValue = 16777236
      ErrorLibNotImplemented = 16777237
      ErrorLibUnableToConnect = 16777238
      ErrorLibUnableToClose = 16777239
      ErrorLibNoPagingState = 16777240
      ErrorLibParameterUnset = 16777241
      ErrorLibInvalidErrorResultType = 16777242
      ErrorLibInvalidFutureType = 16777243
      ErrorLibInternalError = 16777244
      ErrorLibInvalidCustomType = 16777245
      ErrorLibInvalidData = 16777246
      ErrorLibNotEnoughData = 16777247
      ErrorLibInvalidState = 16777248
      ErrorLibNoCustomPayload = 16777249
      ErrorLibExecutionProfileInvalid = 16777250
      ErrorLibNoTracingId = 16777251
      ErrorServerServerError = 33554432
      ErrorServerProtocolError = 33554442
      ErrorServerBadCredentials = 33554688
      ErrorServerUnavailable = 33558528
      ErrorServerOverloaded = 33558529
      ErrorServerIsBootstrapping = 33558530
      ErrorServerTruncateError = 33558531
      ErrorServerWriteTimeout = 33558784
      ErrorServerReadTimeout = 33559040
      ErrorServerReadFailure = 33559296
      ErrorServerFunctionFailure = 33559552
      ErrorServerWriteFailure = 33559808
      ErrorServerSyntaxError = 33562624
      ErrorServerUnauthorized = 33562880
      ErrorServerInvalidQuery = 33563136
      ErrorServerConfigError = 33563392
      ErrorServerAlreadyExists = 33563648
      ErrorServerUnprepared = 33563904
      ErrorSslInvalidCert = 50331649
      ErrorSslInvalidPrivateKey = 50331650
      ErrorSslNoPeerCert = 50331651
      ErrorSslInvalidPeerCert = 50331652
      ErrorSslIdentityMismatch = 50331653
      ErrorSslProtocolError = 50331654
      ErrorLastEntry = 50331655
    end
    fun execution_profile_set_consistency = cass_execution_profile_set_consistency(profile : CassExecProfile, consistency : CassConsistency) : CassError
    enum CassConsistency
      ConsistencyUnknown = 65535
      ConsistencyAny = 0
      ConsistencyOne = 1
      ConsistencyTwo = 2
      ConsistencyThree = 3
      ConsistencyQuorum = 4
      ConsistencyAll = 5
      ConsistencyLocalQuorum = 6
      ConsistencyEachQuorum = 7
      ConsistencySerial = 8
      ConsistencyLocalSerial = 9
      ConsistencyLocalOne = 10
    end
    fun execution_profile_set_serial_consistency = cass_execution_profile_set_serial_consistency(profile : CassExecProfile, serial_consistency : CassConsistency) : CassError
    fun execution_profile_set_load_balance_round_robin = cass_execution_profile_set_load_balance_round_robin(profile : CassExecProfile) : CassError
    fun execution_profile_set_load_balance_dc_aware = cass_execution_profile_set_load_balance_dc_aware(profile : CassExecProfile, local_dc : LibC::Char*, used_hosts_per_remote_dc : LibC::UInt, allow_remote_dcs_for_local_cl : BoolT) : CassError
    enum BoolT
      False = 0
      True = 1
    end
    fun execution_profile_set_load_balance_dc_aware_n = cass_execution_profile_set_load_balance_dc_aware_n(profile : CassExecProfile, local_dc : LibC::Char*, local_dc_length : LibC::SizeT, used_hosts_per_remote_dc : LibC::UInt, allow_remote_dcs_for_local_cl : BoolT) : CassError
    fun execution_profile_set_token_aware_routing = cass_execution_profile_set_token_aware_routing(profile : CassExecProfile, enabled : BoolT) : CassError
    fun execution_profile_set_token_aware_routing_shuffle_replicas = cass_execution_profile_set_token_aware_routing_shuffle_replicas(profile : CassExecProfile, enabled : BoolT) : CassError
    fun execution_profile_set_latency_aware_routing = cass_execution_profile_set_latency_aware_routing(profile : CassExecProfile, enabled : BoolT) : CassError
    fun execution_profile_set_latency_aware_routing_settings = cass_execution_profile_set_latency_aware_routing_settings(profile : CassExecProfile, exclusion_threshold : DoubleT, scale_ms : Uint64T, retry_period_ms : Uint64T, update_rate_ms : Uint64T, min_measured : Uint64T) : CassError
    alias DoubleT = LibC::Double
    fun execution_profile_set_whitelist_filtering = cass_execution_profile_set_whitelist_filtering(profile : CassExecProfile, hosts : LibC::Char*) : CassError
    fun execution_profile_set_whitelist_filtering_n = cass_execution_profile_set_whitelist_filtering_n(profile : CassExecProfile, hosts : LibC::Char*, hosts_length : LibC::SizeT) : CassError
    fun execution_profile_set_blacklist_filtering = cass_execution_profile_set_blacklist_filtering(profile : CassExecProfile, hosts : LibC::Char*) : CassError
    fun execution_profile_set_blacklist_filtering_n = cass_execution_profile_set_blacklist_filtering_n(profile : CassExecProfile, hosts : LibC::Char*, hosts_length : LibC::SizeT) : CassError
    fun execution_profile_set_whitelist_dc_filtering = cass_execution_profile_set_whitelist_dc_filtering(profile : CassExecProfile, dcs : LibC::Char*) : CassError
    fun execution_profile_set_whitelist_dc_filtering_n = cass_execution_profile_set_whitelist_dc_filtering_n(profile : CassExecProfile, dcs : LibC::Char*, dcs_length : LibC::SizeT) : CassError
    fun execution_profile_set_blacklist_dc_filtering = cass_execution_profile_set_blacklist_dc_filtering(profile : CassExecProfile, dcs : LibC::Char*) : CassError
    fun execution_profile_set_blacklist_dc_filtering_n = cass_execution_profile_set_blacklist_dc_filtering_n(profile : CassExecProfile, dcs : LibC::Char*, dcs_length : LibC::SizeT) : CassError
    fun execution_profile_set_retry_policy = cass_execution_profile_set_retry_policy(profile : CassExecProfile, retry_policy : CassRetryPolicy) : CassError
    type CassRetryPolicy = Void*
    fun execution_profile_set_constant_speculative_execution_policy = cass_execution_profile_set_constant_speculative_execution_policy(profile : CassExecProfile, constant_delay_ms : Int64T, max_speculative_executions : LibC::Int) : CassError
    alias Int64T = LibC::LongLong
    fun execution_profile_set_no_speculative_execution_policy = cass_execution_profile_set_no_speculative_execution_policy(profile : CassExecProfile) : CassError
    fun cluster_new = cass_cluster_new : CassCluster
    type CassCluster = Void*
    fun cluster_free = cass_cluster_free(cluster : CassCluster)
    fun cluster_set_contact_points = cass_cluster_set_contact_points(cluster : CassCluster, contact_points : LibC::Char*) : CassError
    fun cluster_set_contact_points_n = cass_cluster_set_contact_points_n(cluster : CassCluster, contact_points : LibC::Char*, contact_points_length : LibC::SizeT) : CassError
    fun cluster_set_port = cass_cluster_set_port(cluster : CassCluster, port : LibC::Int) : CassError
    fun cluster_set_local_address = cass_cluster_set_local_address(cluster : CassCluster, name : LibC::Char*) : CassError
    fun cluster_set_local_address_n = cass_cluster_set_local_address_n(cluster : CassCluster, name : LibC::Char*, name_length : LibC::SizeT) : CassError
    fun cluster_set_ssl = cass_cluster_set_ssl(cluster : CassCluster, ssl : CassSsl)
    type CassSsl = Void*
    fun cluster_set_authenticator_callbacks = cass_cluster_set_authenticator_callbacks(cluster : CassCluster, exchange_callbacks : CassAuthenticatorCallbacks*, cleanup_callback : CassAuthenticatorDataCleanupCallback, data : Void*) : CassError
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
    fun cluster_set_protocol_version = cass_cluster_set_protocol_version(cluster : CassCluster, protocol_version : LibC::Int) : CassError
    fun cluster_set_use_beta_protocol_version = cass_cluster_set_use_beta_protocol_version(cluster : CassCluster, enable : BoolT) : CassError
    fun cluster_set_consistency = cass_cluster_set_consistency(cluster : CassCluster, consistency : CassConsistency) : CassError
    fun cluster_set_serial_consistency = cass_cluster_set_serial_consistency(cluster : CassCluster, consistency : CassConsistency) : CassError
    fun cluster_set_num_threads_io = cass_cluster_set_num_threads_io(cluster : CassCluster, num_threads : LibC::UInt) : CassError
    fun cluster_set_queue_size_io = cass_cluster_set_queue_size_io(cluster : CassCluster, queue_size : LibC::UInt) : CassError
    fun cluster_set_queue_size_event = cass_cluster_set_queue_size_event(cluster : CassCluster, queue_size : LibC::UInt) : CassError
    fun cluster_set_core_connections_per_host = cass_cluster_set_core_connections_per_host(cluster : CassCluster, num_connections : LibC::UInt) : CassError
    fun cluster_set_max_connections_per_host = cass_cluster_set_max_connections_per_host(cluster : CassCluster, num_connections : LibC::UInt) : CassError
    fun cluster_set_reconnect_wait_time = cass_cluster_set_reconnect_wait_time(cluster : CassCluster, wait_time : LibC::UInt)
    fun cluster_set_coalesce_delay = cass_cluster_set_coalesce_delay(cluster : CassCluster, delay_us : Int64T) : CassError
    fun cluster_set_new_request_ratio = cass_cluster_set_new_request_ratio(cluster : CassCluster, ratio : Int32T) : CassError
    alias Int32T = LibC::Int
    fun cluster_set_max_concurrent_creation = cass_cluster_set_max_concurrent_creation(cluster : CassCluster, num_connections : LibC::UInt) : CassError
    fun cluster_set_max_concurrent_requests_threshold = cass_cluster_set_max_concurrent_requests_threshold(cluster : CassCluster, num_requests : LibC::UInt) : CassError
    fun cluster_set_max_requests_per_flush = cass_cluster_set_max_requests_per_flush(cluster : CassCluster, num_requests : LibC::UInt) : CassError
    fun cluster_set_write_bytes_high_water_mark = cass_cluster_set_write_bytes_high_water_mark(cluster : CassCluster, num_bytes : LibC::UInt) : CassError
    fun cluster_set_write_bytes_low_water_mark = cass_cluster_set_write_bytes_low_water_mark(cluster : CassCluster, num_bytes : LibC::UInt) : CassError
    fun cluster_set_pending_requests_high_water_mark = cass_cluster_set_pending_requests_high_water_mark(cluster : CassCluster, num_requests : LibC::UInt) : CassError
    fun cluster_set_pending_requests_low_water_mark = cass_cluster_set_pending_requests_low_water_mark(cluster : CassCluster, num_requests : LibC::UInt) : CassError
    fun cluster_set_connect_timeout = cass_cluster_set_connect_timeout(cluster : CassCluster, timeout_ms : LibC::UInt)
    fun cluster_set_request_timeout = cass_cluster_set_request_timeout(cluster : CassCluster, timeout_ms : LibC::UInt)
    fun cluster_set_resolve_timeout = cass_cluster_set_resolve_timeout(cluster : CassCluster, timeout_ms : LibC::UInt)
    fun cluster_set_max_schema_wait_time = cass_cluster_set_max_schema_wait_time(cluster : CassCluster, wait_time_ms : LibC::UInt)
    fun cluster_set_tracing_max_wait_time = cass_cluster_set_tracing_max_wait_time(cluster : CassCluster, max_wait_time_ms : LibC::UInt)
    fun cluster_set_tracing_retry_wait_time = cass_cluster_set_tracing_retry_wait_time(cluster : CassCluster, retry_wait_time_ms : LibC::UInt)
    fun cluster_set_tracing_consistency = cass_cluster_set_tracing_consistency(cluster : CassCluster, consistency : CassConsistency)
    fun cluster_set_credentials = cass_cluster_set_credentials(cluster : CassCluster, username : LibC::Char*, password : LibC::Char*)
    fun cluster_set_credentials_n = cass_cluster_set_credentials_n(cluster : CassCluster, username : LibC::Char*, username_length : LibC::SizeT, password : LibC::Char*, password_length : LibC::SizeT)
    fun cluster_set_load_balance_round_robin = cass_cluster_set_load_balance_round_robin(cluster : CassCluster)
    fun cluster_set_load_balance_dc_aware = cass_cluster_set_load_balance_dc_aware(cluster : CassCluster, local_dc : LibC::Char*, used_hosts_per_remote_dc : LibC::UInt, allow_remote_dcs_for_local_cl : BoolT) : CassError
    fun cluster_set_load_balance_dc_aware_n = cass_cluster_set_load_balance_dc_aware_n(cluster : CassCluster, local_dc : LibC::Char*, local_dc_length : LibC::SizeT, used_hosts_per_remote_dc : LibC::UInt, allow_remote_dcs_for_local_cl : BoolT) : CassError
    fun cluster_set_token_aware_routing = cass_cluster_set_token_aware_routing(cluster : CassCluster, enabled : BoolT)
    fun cluster_set_token_aware_routing_shuffle_replicas = cass_cluster_set_token_aware_routing_shuffle_replicas(cluster : CassCluster, enabled : BoolT)
    fun cluster_set_latency_aware_routing = cass_cluster_set_latency_aware_routing(cluster : CassCluster, enabled : BoolT)
    fun cluster_set_latency_aware_routing_settings = cass_cluster_set_latency_aware_routing_settings(cluster : CassCluster, exclusion_threshold : DoubleT, scale_ms : Uint64T, retry_period_ms : Uint64T, update_rate_ms : Uint64T, min_measured : Uint64T)
    fun cluster_set_whitelist_filtering = cass_cluster_set_whitelist_filtering(cluster : CassCluster, hosts : LibC::Char*)
    fun cluster_set_whitelist_filtering_n = cass_cluster_set_whitelist_filtering_n(cluster : CassCluster, hosts : LibC::Char*, hosts_length : LibC::SizeT)
    fun cluster_set_blacklist_filtering = cass_cluster_set_blacklist_filtering(cluster : CassCluster, hosts : LibC::Char*)
    fun cluster_set_blacklist_filtering_n = cass_cluster_set_blacklist_filtering_n(cluster : CassCluster, hosts : LibC::Char*, hosts_length : LibC::SizeT)
    fun cluster_set_whitelist_dc_filtering = cass_cluster_set_whitelist_dc_filtering(cluster : CassCluster, dcs : LibC::Char*)
    fun cluster_set_whitelist_dc_filtering_n = cass_cluster_set_whitelist_dc_filtering_n(cluster : CassCluster, dcs : LibC::Char*, dcs_length : LibC::SizeT)
    fun cluster_set_blacklist_dc_filtering = cass_cluster_set_blacklist_dc_filtering(cluster : CassCluster, dcs : LibC::Char*)
    fun cluster_set_blacklist_dc_filtering_n = cass_cluster_set_blacklist_dc_filtering_n(cluster : CassCluster, dcs : LibC::Char*, dcs_length : LibC::SizeT)
    fun cluster_set_tcp_nodelay = cass_cluster_set_tcp_nodelay(cluster : CassCluster, enabled : BoolT)
    fun cluster_set_tcp_keepalive = cass_cluster_set_tcp_keepalive(cluster : CassCluster, enabled : BoolT, delay_secs : LibC::UInt)
    fun cluster_set_timestamp_gen = cass_cluster_set_timestamp_gen(cluster : CassCluster, timestamp_gen : CassTimestampGen)
    type CassTimestampGen = Void*
    fun cluster_set_connection_heartbeat_interval = cass_cluster_set_connection_heartbeat_interval(cluster : CassCluster, interval_secs : LibC::UInt)
    fun cluster_set_connection_idle_timeout = cass_cluster_set_connection_idle_timeout(cluster : CassCluster, timeout_secs : LibC::UInt)
    fun cluster_set_retry_policy = cass_cluster_set_retry_policy(cluster : CassCluster, retry_policy : CassRetryPolicy)
    fun cluster_set_use_schema = cass_cluster_set_use_schema(cluster : CassCluster, enabled : BoolT)
    fun cluster_set_use_hostname_resolution = cass_cluster_set_use_hostname_resolution(cluster : CassCluster, enabled : BoolT) : CassError
    fun cluster_set_use_randomized_contact_points = cass_cluster_set_use_randomized_contact_points(cluster : CassCluster, enabled : BoolT) : CassError
    fun cluster_set_constant_speculative_execution_policy = cass_cluster_set_constant_speculative_execution_policy(cluster : CassCluster, constant_delay_ms : Int64T, max_speculative_executions : LibC::Int) : CassError
    fun cluster_set_no_speculative_execution_policy = cass_cluster_set_no_speculative_execution_policy(cluster : CassCluster) : CassError
    fun cluster_set_max_reusable_write_objects = cass_cluster_set_max_reusable_write_objects(cluster : CassCluster, num_objects : LibC::UInt) : CassError
    fun cluster_set_execution_profile = cass_cluster_set_execution_profile(cluster : CassCluster, name : LibC::Char*, profile : CassExecProfile) : CassError
    fun cluster_set_execution_profile_n = cass_cluster_set_execution_profile_n(cluster : CassCluster, name : LibC::Char*, name_length : LibC::SizeT, profile : CassExecProfile) : CassError
    fun cluster_set_prepare_on_all_hosts = cass_cluster_set_prepare_on_all_hosts(cluster : CassCluster, enabled : BoolT) : CassError
    fun cluster_set_prepare_on_up_or_add_host = cass_cluster_set_prepare_on_up_or_add_host(cluster : CassCluster, enabled : BoolT) : CassError
    fun cluster_set_no_compact = cass_cluster_set_no_compact(cluster : CassCluster, enabled : BoolT) : CassError
    fun cluster_set_host_listener_callback = cass_cluster_set_host_listener_callback(cluster : CassCluster, callback : CassHostListenerCallback, data : Void*) : CassError
    enum CassHostListenerEvent
      HostListenerEventUp = 0
      HostListenerEventDown = 1
      HostListenerEventAdd = 2
      HostListenerEventRemove = 3
    end
    struct CassInet
      address : Uint8T[16]
      address_length : Uint8T
    end
    alias CassHostListenerCallback = (CassHostListenerEvent, CassInet, Void* -> Void)
    alias Uint8T = UInt8
    fun session_new = cass_session_new : CassSession
    type CassSession = Void*
    fun session_free = cass_session_free(session : CassSession)
    fun session_connect = cass_session_connect(session : CassSession, cluster : CassCluster) : CassFuture
    type CassFuture = Void*
    fun session_connect_keyspace = cass_session_connect_keyspace(session : CassSession, cluster : CassCluster, keyspace : LibC::Char*) : CassFuture
    fun session_connect_keyspace_n = cass_session_connect_keyspace_n(session : CassSession, cluster : CassCluster, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassFuture
    fun session_close = cass_session_close(session : CassSession) : CassFuture
    fun session_prepare = cass_session_prepare(session : CassSession, query : LibC::Char*) : CassFuture
    fun session_prepare_n = cass_session_prepare_n(session : CassSession, query : LibC::Char*, query_length : LibC::SizeT) : CassFuture
    fun session_prepare_from_existing = cass_session_prepare_from_existing(session : CassSession, statement : CassStatement) : CassFuture
    type CassStatement = Void*
    fun session_execute = cass_session_execute(session : CassSession, statement : CassStatement) : CassFuture
    fun session_execute_batch = cass_session_execute_batch(session : CassSession, batch : CassBatch) : CassFuture
    type CassBatch = Void*
    fun session_get_schema_meta = cass_session_get_schema_meta(session : CassSession) : CassSchemaMeta
    type CassSchemaMeta = Void*
    fun session_get_metrics = cass_session_get_metrics(session : CassSession, output : CassMetrics*)
    struct CassMetrics
      requests : CassMetricsRequests
      stats : CassMetricsStats
      errors : CassMetricsErrors
    end
    struct CassMetricsRequests
      min : Uint64T
      max : Uint64T
      mean : Uint64T
      stddev : Uint64T
      median : Uint64T
      percentile_75th : Uint64T
      percentile_95th : Uint64T
      percentile_98th : Uint64T
      percentile_99th : Uint64T
      percentile_999th : Uint64T
      mean_rate : DoubleT
      one_minute_rate : DoubleT
      five_minute_rate : DoubleT
      fifteen_minute_rate : DoubleT
    end
    struct CassMetricsStats
      total_connections : Uint64T
      available_connections : Uint64T
      exceeded_pending_requests_water_mark : Uint64T
      exceeded_write_bytes_water_mark : Uint64T
    end
    struct CassMetricsErrors
      connection_timeouts : Uint64T
      pending_request_timeouts : Uint64T
      request_timeouts : Uint64T
    end
    fun session_get_speculative_execution_metrics = cass_session_get_speculative_execution_metrics(session : CassSession, output : CassSpeculativeExecutionMetrics*)
    struct CassSpeculativeExecutionMetrics
      min : Uint64T
      max : Uint64T
      mean : Uint64T
      stddev : Uint64T
      median : Uint64T
      percentile_75th : Uint64T
      percentile_95th : Uint64T
      percentile_98th : Uint64T
      percentile_99th : Uint64T
      percentile_999th : Uint64T
      count : Uint64T
      percentage : DoubleT
    end
    fun schema_meta_free = cass_schema_meta_free(schema_meta : CassSchemaMeta)
    fun schema_meta_snapshot_version = cass_schema_meta_snapshot_version(schema_meta : CassSchemaMeta) : Uint32T
    alias Uint32T = LibC::UInt
    fun schema_meta_version = cass_schema_meta_version(schema_meta : CassSchemaMeta) : CassVersion
    struct CassVersion
      major_version : LibC::Int
      minor_version : LibC::Int
      patch_version : LibC::Int
    end
    fun schema_meta_keyspace_by_name = cass_schema_meta_keyspace_by_name(schema_meta : CassSchemaMeta, keyspace : LibC::Char*) : CassKeyspaceMeta
    type CassKeyspaceMeta = Void*
    fun schema_meta_keyspace_by_name_n = cass_schema_meta_keyspace_by_name_n(schema_meta : CassSchemaMeta, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassKeyspaceMeta
    fun keyspace_meta_name = cass_keyspace_meta_name(keyspace_meta : CassKeyspaceMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun keyspace_meta_is_virtual = cass_keyspace_meta_is_virtual(keyspace_meta : CassKeyspaceMeta) : BoolT
    fun keyspace_meta_table_by_name = cass_keyspace_meta_table_by_name(keyspace_meta : CassKeyspaceMeta, table : LibC::Char*) : CassTableMeta
    type CassTableMeta = Void*
    fun keyspace_meta_table_by_name_n = cass_keyspace_meta_table_by_name_n(keyspace_meta : CassKeyspaceMeta, table : LibC::Char*, table_length : LibC::SizeT) : CassTableMeta
    fun keyspace_meta_materialized_view_by_name = cass_keyspace_meta_materialized_view_by_name(keyspace_meta : CassKeyspaceMeta, view : LibC::Char*) : CassMaterializedViewMeta
    type CassMaterializedViewMeta = Void*
    fun keyspace_meta_materialized_view_by_name_n = cass_keyspace_meta_materialized_view_by_name_n(keyspace_meta : CassKeyspaceMeta, view : LibC::Char*, view_length : LibC::SizeT) : CassMaterializedViewMeta
    fun keyspace_meta_user_type_by_name = cass_keyspace_meta_user_type_by_name(keyspace_meta : CassKeyspaceMeta, type : LibC::Char*) : CassDataType
    type CassDataType = Void*
    fun keyspace_meta_user_type_by_name_n = cass_keyspace_meta_user_type_by_name_n(keyspace_meta : CassKeyspaceMeta, type : LibC::Char*, type_length : LibC::SizeT) : CassDataType
    fun keyspace_meta_function_by_name = cass_keyspace_meta_function_by_name(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, arguments : LibC::Char*) : CassFunctionMeta
    type CassFunctionMeta = Void*
    fun keyspace_meta_function_by_name_n = cass_keyspace_meta_function_by_name_n(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, name_length : LibC::SizeT, arguments : LibC::Char*, arguments_length : LibC::SizeT) : CassFunctionMeta
    fun keyspace_meta_aggregate_by_name = cass_keyspace_meta_aggregate_by_name(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, arguments : LibC::Char*) : CassAggregateMeta
    type CassAggregateMeta = Void*
    fun keyspace_meta_aggregate_by_name_n = cass_keyspace_meta_aggregate_by_name_n(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, name_length : LibC::SizeT, arguments : LibC::Char*, arguments_length : LibC::SizeT) : CassAggregateMeta
    fun keyspace_meta_field_by_name = cass_keyspace_meta_field_by_name(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*) : CassValue
    type CassValue = Void*
    fun keyspace_meta_field_by_name_n = cass_keyspace_meta_field_by_name_n(keyspace_meta : CassKeyspaceMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun table_meta_name = cass_table_meta_name(table_meta : CassTableMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun table_meta_is_virtual = cass_table_meta_is_virtual(table_meta : CassTableMeta) : BoolT
    fun table_meta_column_by_name = cass_table_meta_column_by_name(table_meta : CassTableMeta, column : LibC::Char*) : CassColumnMeta
    type CassColumnMeta = Void*
    fun table_meta_column_by_name_n = cass_table_meta_column_by_name_n(table_meta : CassTableMeta, column : LibC::Char*, column_length : LibC::SizeT) : CassColumnMeta
    fun table_meta_column_count = cass_table_meta_column_count(table_meta : CassTableMeta) : LibC::SizeT
    fun table_meta_column = cass_table_meta_column(table_meta : CassTableMeta, index : LibC::SizeT) : CassColumnMeta
    fun table_meta_index_by_name = cass_table_meta_index_by_name(table_meta : CassTableMeta, index : LibC::Char*) : CassIndexMeta
    type CassIndexMeta = Void*
    fun table_meta_index_by_name_n = cass_table_meta_index_by_name_n(table_meta : CassTableMeta, index : LibC::Char*, index_length : LibC::SizeT) : CassIndexMeta
    fun table_meta_index_count = cass_table_meta_index_count(table_meta : CassTableMeta) : LibC::SizeT
    fun table_meta_index = cass_table_meta_index(table_meta : CassTableMeta, index : LibC::SizeT) : CassIndexMeta
    fun table_meta_materialized_view_by_name = cass_table_meta_materialized_view_by_name(table_meta : CassTableMeta, view : LibC::Char*) : CassMaterializedViewMeta
    fun table_meta_materialized_view_by_name_n = cass_table_meta_materialized_view_by_name_n(table_meta : CassTableMeta, view : LibC::Char*, view_length : LibC::SizeT) : CassMaterializedViewMeta
    fun table_meta_materialized_view_count = cass_table_meta_materialized_view_count(table_meta : CassTableMeta) : LibC::SizeT
    fun table_meta_materialized_view = cass_table_meta_materialized_view(table_meta : CassTableMeta, index : LibC::SizeT) : CassMaterializedViewMeta
    fun table_meta_partition_key_count = cass_table_meta_partition_key_count(table_meta : CassTableMeta) : LibC::SizeT
    fun table_meta_partition_key = cass_table_meta_partition_key(table_meta : CassTableMeta, index : LibC::SizeT) : CassColumnMeta
    fun table_meta_clustering_key_count = cass_table_meta_clustering_key_count(table_meta : CassTableMeta) : LibC::SizeT
    fun table_meta_clustering_key = cass_table_meta_clustering_key(table_meta : CassTableMeta, index : LibC::SizeT) : CassColumnMeta
    fun table_meta_clustering_key_order = cass_table_meta_clustering_key_order(table_meta : CassTableMeta, index : LibC::SizeT) : CassClusteringOrder
    enum CassClusteringOrder
      ClusteringOrderNone = 0
      ClusteringOrderAsc = 1
      ClusteringOrderDesc = 2
    end
    fun table_meta_field_by_name = cass_table_meta_field_by_name(table_meta : CassTableMeta, name : LibC::Char*) : CassValue
    fun table_meta_field_by_name_n = cass_table_meta_field_by_name_n(table_meta : CassTableMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun materialized_view_meta_column_by_name = cass_materialized_view_meta_column_by_name(view_meta : CassMaterializedViewMeta, column : LibC::Char*) : CassColumnMeta
    fun materialized_view_meta_column_by_name_n = cass_materialized_view_meta_column_by_name_n(view_meta : CassMaterializedViewMeta, column : LibC::Char*, column_length : LibC::SizeT) : CassColumnMeta
    fun materialized_view_meta_name = cass_materialized_view_meta_name(view_meta : CassMaterializedViewMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun materialized_view_meta_base_table = cass_materialized_view_meta_base_table(view_meta : CassMaterializedViewMeta) : CassTableMeta
    fun materialized_view_meta_column_count = cass_materialized_view_meta_column_count(view_meta : CassMaterializedViewMeta) : LibC::SizeT
    fun materialized_view_meta_column = cass_materialized_view_meta_column(view_meta : CassMaterializedViewMeta, index : LibC::SizeT) : CassColumnMeta
    fun materialized_view_meta_partition_key_count = cass_materialized_view_meta_partition_key_count(view_meta : CassMaterializedViewMeta) : LibC::SizeT
    fun materialized_view_meta_partition_key = cass_materialized_view_meta_partition_key(view_meta : CassMaterializedViewMeta, index : LibC::SizeT) : CassColumnMeta
    fun materialized_view_meta_clustering_key_count = cass_materialized_view_meta_clustering_key_count(view_meta : CassMaterializedViewMeta) : LibC::SizeT
    fun materialized_view_meta_clustering_key = cass_materialized_view_meta_clustering_key(view_meta : CassMaterializedViewMeta, index : LibC::SizeT) : CassColumnMeta
    fun materialized_view_meta_clustering_key_order = cass_materialized_view_meta_clustering_key_order(view_meta : CassMaterializedViewMeta, index : LibC::SizeT) : CassClusteringOrder
    fun materialized_view_meta_field_by_name = cass_materialized_view_meta_field_by_name(view_meta : CassMaterializedViewMeta, name : LibC::Char*) : CassValue
    fun materialized_view_meta_field_by_name_n = cass_materialized_view_meta_field_by_name_n(view_meta : CassMaterializedViewMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun column_meta_name = cass_column_meta_name(column_meta : CassColumnMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun column_meta_type = cass_column_meta_type(column_meta : CassColumnMeta) : CassColumnType
    enum CassColumnType
      ColumnTypeRegular = 0
      ColumnTypePartitionKey = 1
      ColumnTypeClusteringKey = 2
      ColumnTypeStatic = 3
      ColumnTypeCompactValue = 4
    end
    fun column_meta_data_type = cass_column_meta_data_type(column_meta : CassColumnMeta) : CassDataType
    fun column_meta_field_by_name = cass_column_meta_field_by_name(column_meta : CassColumnMeta, name : LibC::Char*) : CassValue
    fun column_meta_field_by_name_n = cass_column_meta_field_by_name_n(column_meta : CassColumnMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun index_meta_name = cass_index_meta_name(index_meta : CassIndexMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun index_meta_type = cass_index_meta_type(index_meta : CassIndexMeta) : CassIndexType
    enum CassIndexType
      IndexTypeUnknown = 0
      IndexTypeKeys = 1
      IndexTypeCustom = 2
      IndexTypeComposites = 3
    end
    fun index_meta_target = cass_index_meta_target(index_meta : CassIndexMeta, target : LibC::Char**, target_length : LibC::SizeT*)
    fun index_meta_options = cass_index_meta_options(index_meta : CassIndexMeta) : CassValue
    fun index_meta_field_by_name = cass_index_meta_field_by_name(index_meta : CassIndexMeta, name : LibC::Char*) : CassValue
    fun index_meta_field_by_name_n = cass_index_meta_field_by_name_n(index_meta : CassIndexMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun function_meta_name = cass_function_meta_name(function_meta : CassFunctionMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun function_meta_full_name = cass_function_meta_full_name(function_meta : CassFunctionMeta, full_name : LibC::Char**, full_name_length : LibC::SizeT*)
    fun function_meta_body = cass_function_meta_body(function_meta : CassFunctionMeta, body : LibC::Char**, body_length : LibC::SizeT*)
    fun function_meta_language = cass_function_meta_language(function_meta : CassFunctionMeta, language : LibC::Char**, language_length : LibC::SizeT*)
    fun function_meta_called_on_null_input = cass_function_meta_called_on_null_input(function_meta : CassFunctionMeta) : BoolT
    fun function_meta_argument_count = cass_function_meta_argument_count(function_meta : CassFunctionMeta) : LibC::SizeT
    fun function_meta_argument = cass_function_meta_argument(function_meta : CassFunctionMeta, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*, type : CassDataType*) : CassError
    fun function_meta_argument_type_by_name = cass_function_meta_argument_type_by_name(function_meta : CassFunctionMeta, name : LibC::Char*) : CassDataType
    fun function_meta_argument_type_by_name_n = cass_function_meta_argument_type_by_name_n(function_meta : CassFunctionMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassDataType
    fun function_meta_return_type = cass_function_meta_return_type(function_meta : CassFunctionMeta) : CassDataType
    fun function_meta_field_by_name = cass_function_meta_field_by_name(function_meta : CassFunctionMeta, name : LibC::Char*) : CassValue
    fun function_meta_field_by_name_n = cass_function_meta_field_by_name_n(function_meta : CassFunctionMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun aggregate_meta_name = cass_aggregate_meta_name(aggregate_meta : CassAggregateMeta, name : LibC::Char**, name_length : LibC::SizeT*)
    fun aggregate_meta_full_name = cass_aggregate_meta_full_name(aggregate_meta : CassAggregateMeta, full_name : LibC::Char**, full_name_length : LibC::SizeT*)
    fun aggregate_meta_argument_count = cass_aggregate_meta_argument_count(aggregate_meta : CassAggregateMeta) : LibC::SizeT
    fun aggregate_meta_argument_type = cass_aggregate_meta_argument_type(aggregate_meta : CassAggregateMeta, index : LibC::SizeT) : CassDataType
    fun aggregate_meta_return_type = cass_aggregate_meta_return_type(aggregate_meta : CassAggregateMeta) : CassDataType
    fun aggregate_meta_state_type = cass_aggregate_meta_state_type(aggregate_meta : CassAggregateMeta) : CassDataType
    fun aggregate_meta_state_func = cass_aggregate_meta_state_func(aggregate_meta : CassAggregateMeta) : CassFunctionMeta
    fun aggregate_meta_final_func = cass_aggregate_meta_final_func(aggregate_meta : CassAggregateMeta) : CassFunctionMeta
    fun aggregate_meta_init_cond = cass_aggregate_meta_init_cond(aggregate_meta : CassAggregateMeta) : CassValue
    fun aggregate_meta_field_by_name = cass_aggregate_meta_field_by_name(aggregate_meta : CassAggregateMeta, name : LibC::Char*) : CassValue
    fun aggregate_meta_field_by_name_n = cass_aggregate_meta_field_by_name_n(aggregate_meta : CassAggregateMeta, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun ssl_new = cass_ssl_new : CassSsl
    fun ssl_new_no_lib_init = cass_ssl_new_no_lib_init : CassSsl
    fun ssl_free = cass_ssl_free(ssl : CassSsl)
    fun ssl_add_trusted_cert = cass_ssl_add_trusted_cert(ssl : CassSsl, cert : LibC::Char*) : CassError
    fun ssl_add_trusted_cert_n = cass_ssl_add_trusted_cert_n(ssl : CassSsl, cert : LibC::Char*, cert_length : LibC::SizeT) : CassError
    fun ssl_set_verify_flags = cass_ssl_set_verify_flags(ssl : CassSsl, flags : LibC::Int)
    fun ssl_set_cert = cass_ssl_set_cert(ssl : CassSsl, cert : LibC::Char*) : CassError
    fun ssl_set_cert_n = cass_ssl_set_cert_n(ssl : CassSsl, cert : LibC::Char*, cert_length : LibC::SizeT) : CassError
    fun ssl_set_private_key = cass_ssl_set_private_key(ssl : CassSsl, key : LibC::Char*, password : LibC::Char*) : CassError
    fun ssl_set_private_key_n = cass_ssl_set_private_key_n(ssl : CassSsl, key : LibC::Char*, key_length : LibC::SizeT, password : LibC::Char*, password_length : LibC::SizeT) : CassError
    fun authenticator_address = cass_authenticator_address(auth : CassAuthenticator, address : CassInet*)
    fun authenticator_hostname = cass_authenticator_hostname(auth : CassAuthenticator, length : LibC::SizeT*) : LibC::Char*
    fun authenticator_class_name = cass_authenticator_class_name(auth : CassAuthenticator, length : LibC::SizeT*) : LibC::Char*
    fun authenticator_exchange_data = cass_authenticator_exchange_data(auth : CassAuthenticator) : Void*
    fun authenticator_set_exchange_data = cass_authenticator_set_exchange_data(auth : CassAuthenticator, exchange_data : Void*)
    fun authenticator_response = cass_authenticator_response(auth : CassAuthenticator, size : LibC::SizeT) : LibC::Char*
    fun authenticator_set_response = cass_authenticator_set_response(auth : CassAuthenticator, response : LibC::Char*, response_size : LibC::SizeT)
    fun authenticator_set_error = cass_authenticator_set_error(auth : CassAuthenticator, message : LibC::Char*)
    fun authenticator_set_error_n = cass_authenticator_set_error_n(auth : CassAuthenticator, message : LibC::Char*, message_length : LibC::SizeT)
    fun future_free = cass_future_free(future : CassFuture)
    fun future_set_callback = cass_future_set_callback(future : CassFuture, callback : CassFutureCallback, data : Void*) : CassError
    alias CassFutureCallback = (CassFuture, Void* -> Void)
    fun future_ready = cass_future_ready(future : CassFuture) : BoolT
    fun future_wait = cass_future_wait(future : CassFuture)
    fun future_wait_timed = cass_future_wait_timed(future : CassFuture, timeout_us : DurationT) : BoolT
    alias DurationT = Uint64T
    fun future_get_result = cass_future_get_result(future : CassFuture) : CassResult
    type CassResult = Void*
    fun future_get_error_result = cass_future_get_error_result(future : CassFuture) : CassErrorResult
    type CassErrorResult = Void*
    fun future_get_prepared = cass_future_get_prepared(future : CassFuture) : CassPrepared
    type CassPrepared = Void*
    fun future_error_code = cass_future_error_code(future : CassFuture) : CassError
    fun future_error_message = cass_future_error_message(future : CassFuture, message : LibC::Char**, message_length : LibC::SizeT*)
    fun future_tracing_id = cass_future_tracing_id(future : CassFuture, tracing_id : CassUuid*) : CassError
    struct CassUuid
      time_and_version : Uint64T
      clock_seq_and_node : Uint64T
    end
    fun future_custom_payload_item_count = cass_future_custom_payload_item_count(future : CassFuture) : LibC::SizeT
    fun future_custom_payload_item = cass_future_custom_payload_item(future : CassFuture, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*, value : ByteT**, value_size : LibC::SizeT*) : CassError
    alias ByteT = Uint8T
    fun statement_new = cass_statement_new(query : LibC::Char*, parameter_count : LibC::SizeT) : CassStatement
    fun statement_new_n = cass_statement_new_n(query : LibC::Char*, query_length : LibC::SizeT, parameter_count : LibC::SizeT) : CassStatement
    fun statement_reset_parameters = cass_statement_reset_parameters(statement : CassStatement, count : LibC::SizeT) : CassError
    fun statement_free = cass_statement_free(statement : CassStatement)
    fun statement_add_key_index = cass_statement_add_key_index(statement : CassStatement, index : LibC::SizeT) : CassError
    fun statement_set_keyspace = cass_statement_set_keyspace(statement : CassStatement, keyspace : LibC::Char*) : CassError
    fun statement_set_keyspace_n = cass_statement_set_keyspace_n(statement : CassStatement, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassError
    fun statement_set_consistency = cass_statement_set_consistency(statement : CassStatement, consistency : CassConsistency) : CassError
    fun statement_set_serial_consistency = cass_statement_set_serial_consistency(statement : CassStatement, serial_consistency : CassConsistency) : CassError
    fun statement_set_paging_size = cass_statement_set_paging_size(statement : CassStatement, page_size : LibC::Int) : CassError
    fun statement_set_paging_state = cass_statement_set_paging_state(statement : CassStatement, result : CassResult) : CassError
    fun statement_set_paging_state_token = cass_statement_set_paging_state_token(statement : CassStatement, paging_state : LibC::Char*, paging_state_size : LibC::SizeT) : CassError
    fun statement_set_timestamp = cass_statement_set_timestamp(statement : CassStatement, timestamp : Int64T) : CassError
    fun statement_set_request_timeout = cass_statement_set_request_timeout(statement : CassStatement, timeout_ms : Uint64T) : CassError
    fun statement_set_is_idempotent = cass_statement_set_is_idempotent(statement : CassStatement, is_idempotent : BoolT) : CassError
    fun statement_set_retry_policy = cass_statement_set_retry_policy(statement : CassStatement, retry_policy : CassRetryPolicy) : CassError
    fun statement_set_custom_payload = cass_statement_set_custom_payload(statement : CassStatement, payload : CassCustomPayload) : CassError
    type CassCustomPayload = Void*
    fun statement_set_execution_profile = cass_statement_set_execution_profile(statement : CassStatement, name : LibC::Char*) : CassError
    fun statement_set_execution_profile_n = cass_statement_set_execution_profile_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT) : CassError
    fun statement_set_tracing = cass_statement_set_tracing(statement : CassStatement, enabled : BoolT) : CassError
    fun statement_set_host = cass_statement_set_host(statement : CassStatement, host : LibC::Char*, port : LibC::Int) : CassError
    fun statement_set_host_n = cass_statement_set_host_n(statement : CassStatement, host : LibC::Char*, host_length : LibC::SizeT, port : LibC::Int) : CassError
    fun statement_set_host_inet = cass_statement_set_host_inet(statement : CassStatement, host : CassInet*, port : LibC::Int) : CassError
    fun statement_bind_null = cass_statement_bind_null(statement : CassStatement, index : LibC::SizeT) : CassError
    fun statement_bind_null_by_name = cass_statement_bind_null_by_name(statement : CassStatement, name : LibC::Char*) : CassError
    fun statement_bind_null_by_name_n = cass_statement_bind_null_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT) : CassError
    fun statement_bind_int8 = cass_statement_bind_int8(statement : CassStatement, index : LibC::SizeT, value : Int8T) : CassError
    alias Int8T = LibC::Char
    fun statement_bind_int8_by_name = cass_statement_bind_int8_by_name(statement : CassStatement, name : LibC::Char*, value : Int8T) : CassError
    fun statement_bind_int8_by_name_n = cass_statement_bind_int8_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : Int8T) : CassError
    fun statement_bind_int16 = cass_statement_bind_int16(statement : CassStatement, index : LibC::SizeT, value : Int16T) : CassError
    alias Int16T = LibC::Short
    fun statement_bind_int16_by_name = cass_statement_bind_int16_by_name(statement : CassStatement, name : LibC::Char*, value : Int16T) : CassError
    fun statement_bind_int16_by_name_n = cass_statement_bind_int16_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : Int16T) : CassError
    fun statement_bind_int32 = cass_statement_bind_int32(statement : CassStatement, index : LibC::SizeT, value : Int32T) : CassError
    fun statement_bind_int32_by_name = cass_statement_bind_int32_by_name(statement : CassStatement, name : LibC::Char*, value : Int32T) : CassError
    fun statement_bind_int32_by_name_n = cass_statement_bind_int32_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : Int32T) : CassError
    fun statement_bind_uint32 = cass_statement_bind_uint32(statement : CassStatement, index : LibC::SizeT, value : Uint32T) : CassError
    fun statement_bind_uint32_by_name = cass_statement_bind_uint32_by_name(statement : CassStatement, name : LibC::Char*, value : Uint32T) : CassError
    fun statement_bind_uint32_by_name_n = cass_statement_bind_uint32_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : Uint32T) : CassError
    fun statement_bind_int64 = cass_statement_bind_int64(statement : CassStatement, index : LibC::SizeT, value : Int64T) : CassError
    fun statement_bind_int64_by_name = cass_statement_bind_int64_by_name(statement : CassStatement, name : LibC::Char*, value : Int64T) : CassError
    fun statement_bind_int64_by_name_n = cass_statement_bind_int64_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : Int64T) : CassError
    fun statement_bind_float = cass_statement_bind_float(statement : CassStatement, index : LibC::SizeT, value : FloatT) : CassError
    alias FloatT = LibC::Float
    fun statement_bind_float_by_name = cass_statement_bind_float_by_name(statement : CassStatement, name : LibC::Char*, value : FloatT) : CassError
    fun statement_bind_float_by_name_n = cass_statement_bind_float_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : FloatT) : CassError
    fun statement_bind_double = cass_statement_bind_double(statement : CassStatement, index : LibC::SizeT, value : DoubleT) : CassError
    fun statement_bind_double_by_name = cass_statement_bind_double_by_name(statement : CassStatement, name : LibC::Char*, value : DoubleT) : CassError
    fun statement_bind_double_by_name_n = cass_statement_bind_double_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : DoubleT) : CassError
    fun statement_bind_bool = cass_statement_bind_bool(statement : CassStatement, index : LibC::SizeT, value : BoolT) : CassError
    fun statement_bind_bool_by_name = cass_statement_bind_bool_by_name(statement : CassStatement, name : LibC::Char*, value : BoolT) : CassError
    fun statement_bind_bool_by_name_n = cass_statement_bind_bool_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : BoolT) : CassError
    fun statement_bind_string = cass_statement_bind_string(statement : CassStatement, index : LibC::SizeT, value : LibC::Char*) : CassError
    fun statement_bind_string_n = cass_statement_bind_string_n(statement : CassStatement, index : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun statement_bind_string_by_name = cass_statement_bind_string_by_name(statement : CassStatement, name : LibC::Char*, value : LibC::Char*) : CassError
    fun statement_bind_string_by_name_n = cass_statement_bind_string_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun statement_bind_bytes = cass_statement_bind_bytes(statement : CassStatement, index : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun statement_bind_bytes_by_name = cass_statement_bind_bytes_by_name(statement : CassStatement, name : LibC::Char*, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun statement_bind_bytes_by_name_n = cass_statement_bind_bytes_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun statement_bind_custom = cass_statement_bind_custom(statement : CassStatement, index : LibC::SizeT, class_name : LibC::Char*, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun statement_bind_custom_n = cass_statement_bind_custom_n(statement : CassStatement, index : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun statement_bind_custom_by_name = cass_statement_bind_custom_by_name(statement : CassStatement, name : LibC::Char*, class_name : LibC::Char*, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun statement_bind_custom_by_name_n = cass_statement_bind_custom_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun statement_bind_uuid = cass_statement_bind_uuid(statement : CassStatement, index : LibC::SizeT, value : CassUuid) : CassError
    fun statement_bind_uuid_by_name = cass_statement_bind_uuid_by_name(statement : CassStatement, name : LibC::Char*, value : CassUuid) : CassError
    fun statement_bind_uuid_by_name_n = cass_statement_bind_uuid_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassUuid) : CassError
    fun statement_bind_inet = cass_statement_bind_inet(statement : CassStatement, index : LibC::SizeT, value : CassInet) : CassError
    fun statement_bind_inet_by_name = cass_statement_bind_inet_by_name(statement : CassStatement, name : LibC::Char*, value : CassInet) : CassError
    fun statement_bind_inet_by_name_n = cass_statement_bind_inet_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, value : CassInet) : CassError
    fun statement_bind_decimal = cass_statement_bind_decimal(statement : CassStatement, index : LibC::SizeT, varint : ByteT*, varint_size : LibC::SizeT, scale : Int32T) : CassError
    fun statement_bind_decimal_by_name = cass_statement_bind_decimal_by_name(statement : CassStatement, name : LibC::Char*, varint : ByteT*, varint_size : LibC::SizeT, scale : Int32T) : CassError
    fun statement_bind_decimal_by_name_n = cass_statement_bind_decimal_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, varint : ByteT*, varint_size : LibC::SizeT, scale : Int32T) : CassError
    fun statement_bind_duration = cass_statement_bind_duration(statement : CassStatement, index : LibC::SizeT, months : Int32T, days : Int32T, nanos : Int64T) : CassError
    fun statement_bind_duration_by_name = cass_statement_bind_duration_by_name(statement : CassStatement, name : LibC::Char*, months : Int32T, days : Int32T, nanos : Int64T) : CassError
    fun statement_bind_duration_by_name_n = cass_statement_bind_duration_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, months : Int32T, days : Int32T, nanos : Int64T) : CassError
    fun statement_bind_collection = cass_statement_bind_collection(statement : CassStatement, index : LibC::SizeT, collection : CassCollection) : CassError
    type CassCollection = Void*
    fun statement_bind_collection_by_name = cass_statement_bind_collection_by_name(statement : CassStatement, name : LibC::Char*, collection : CassCollection) : CassError
    fun statement_bind_collection_by_name_n = cass_statement_bind_collection_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, collection : CassCollection) : CassError
    fun statement_bind_tuple = cass_statement_bind_tuple(statement : CassStatement, index : LibC::SizeT, tuple : CassTuple) : CassError
    type CassTuple = Void*
    fun statement_bind_tuple_by_name = cass_statement_bind_tuple_by_name(statement : CassStatement, name : LibC::Char*, tuple : CassTuple) : CassError
    fun statement_bind_tuple_by_name_n = cass_statement_bind_tuple_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, tuple : CassTuple) : CassError
    fun statement_bind_user_type = cass_statement_bind_user_type(statement : CassStatement, index : LibC::SizeT, user_type : CassUserType) : CassError
    type CassUserType = Void*
    fun statement_bind_user_type_by_name = cass_statement_bind_user_type_by_name(statement : CassStatement, name : LibC::Char*, user_type : CassUserType) : CassError
    fun statement_bind_user_type_by_name_n = cass_statement_bind_user_type_by_name_n(statement : CassStatement, name : LibC::Char*, name_length : LibC::SizeT, user_type : CassUserType) : CassError
    fun prepared_free = cass_prepared_free(prepared : CassPrepared)
    fun prepared_bind = cass_prepared_bind(prepared : CassPrepared) : CassStatement
    fun prepared_parameter_name = cass_prepared_parameter_name(prepared : CassPrepared, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun prepared_parameter_data_type = cass_prepared_parameter_data_type(prepared : CassPrepared, index : LibC::SizeT) : CassDataType
    fun prepared_parameter_data_type_by_name = cass_prepared_parameter_data_type_by_name(prepared : CassPrepared, name : LibC::Char*) : CassDataType
    fun prepared_parameter_data_type_by_name_n = cass_prepared_parameter_data_type_by_name_n(prepared : CassPrepared, name : LibC::Char*, name_length : LibC::SizeT) : CassDataType
    fun batch_new = cass_batch_new(type : CassBatchType) : CassBatch
    enum CassBatchType
      BatchTypeLogged = 0
      BatchTypeUnlogged = 1
      BatchTypeCounter = 2
    end
    fun batch_free = cass_batch_free(batch : CassBatch)
    fun batch_set_keyspace = cass_batch_set_keyspace(batch : CassBatch, keyspace : LibC::Char*) : CassError
    fun batch_set_keyspace_n = cass_batch_set_keyspace_n(batch : CassBatch, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassError
    fun batch_set_consistency = cass_batch_set_consistency(batch : CassBatch, consistency : CassConsistency) : CassError
    fun batch_set_serial_consistency = cass_batch_set_serial_consistency(batch : CassBatch, serial_consistency : CassConsistency) : CassError
    fun batch_set_timestamp = cass_batch_set_timestamp(batch : CassBatch, timestamp : Int64T) : CassError
    fun batch_set_request_timeout = cass_batch_set_request_timeout(batch : CassBatch, timeout_ms : Uint64T) : CassError
    fun batch_set_is_idempotent = cass_batch_set_is_idempotent(batch : CassBatch, is_idempotent : BoolT) : CassError
    fun batch_set_retry_policy = cass_batch_set_retry_policy(batch : CassBatch, retry_policy : CassRetryPolicy) : CassError
    fun batch_set_custom_payload = cass_batch_set_custom_payload(batch : CassBatch, payload : CassCustomPayload) : CassError
    fun batch_set_tracing = cass_batch_set_tracing(batch : CassBatch, enabled : BoolT) : CassError
    fun batch_add_statement = cass_batch_add_statement(batch : CassBatch, statement : CassStatement) : CassError
    fun batch_set_execution_profile = cass_batch_set_execution_profile(batch : CassBatch, name : LibC::Char*) : CassError
    fun batch_set_execution_profile_n = cass_batch_set_execution_profile_n(batch : CassBatch, name : LibC::Char*, name_length : LibC::SizeT) : CassError
    fun data_type_new = cass_data_type_new(type : CassValueType) : CassDataType
    enum CassValueType
      ValueTypeUnknown = 65535
      ValueTypeCustom = 0
      ValueTypeAscii = 1
      ValueTypeBigint = 2
      ValueTypeBlob = 3
      ValueTypeBoolean = 4
      ValueTypeCounter = 5
      ValueTypeDecimal = 6
      ValueTypeDouble = 7
      ValueTypeFloat = 8
      ValueTypeInt = 9
      ValueTypeText = 10
      ValueTypeTimestamp = 11
      ValueTypeUuid = 12
      ValueTypeVarchar = 13
      ValueTypeVarint = 14
      ValueTypeTimeuuid = 15
      ValueTypeInet = 16
      ValueTypeDate = 17
      ValueTypeTime = 18
      ValueTypeSmallInt = 19
      ValueTypeTinyInt = 20
      ValueTypeDuration = 21
      ValueTypeList = 32
      ValueTypeMap = 33
      ValueTypeSet = 34
      ValueTypeUdt = 48
      ValueTypeTuple = 49
      ValueTypeLastEntry = 50
    end
    fun data_type_new_from_existing = cass_data_type_new_from_existing(data_type : CassDataType) : CassDataType
    fun data_type_new_tuple = cass_data_type_new_tuple(item_count : LibC::SizeT) : CassDataType
    fun data_type_new_udt = cass_data_type_new_udt(field_count : LibC::SizeT) : CassDataType
    fun data_type_free = cass_data_type_free(data_type : CassDataType)
    fun data_type_type = cass_data_type_type(data_type : CassDataType) : CassValueType
    fun data_type_is_frozen = cass_data_type_is_frozen(data_type : CassDataType) : BoolT
    fun data_type_type_name = cass_data_type_type_name(data_type : CassDataType, type_name : LibC::Char**, type_name_length : LibC::SizeT*) : CassError
    fun data_type_set_type_name = cass_data_type_set_type_name(data_type : CassDataType, type_name : LibC::Char*) : CassError
    fun data_type_set_type_name_n = cass_data_type_set_type_name_n(data_type : CassDataType, type_name : LibC::Char*, type_name_length : LibC::SizeT) : CassError
    fun data_type_keyspace = cass_data_type_keyspace(data_type : CassDataType, keyspace : LibC::Char**, keyspace_length : LibC::SizeT*) : CassError
    fun data_type_set_keyspace = cass_data_type_set_keyspace(data_type : CassDataType, keyspace : LibC::Char*) : CassError
    fun data_type_set_keyspace_n = cass_data_type_set_keyspace_n(data_type : CassDataType, keyspace : LibC::Char*, keyspace_length : LibC::SizeT) : CassError
    fun data_type_class_name = cass_data_type_class_name(data_type : CassDataType, class_name : LibC::Char**, class_name_length : LibC::SizeT*) : CassError
    fun data_type_set_class_name = cass_data_type_set_class_name(data_type : CassDataType, class_name : LibC::Char*) : CassError
    fun data_type_set_class_name_n = cass_data_type_set_class_name_n(data_type : CassDataType, class_name : LibC::Char*, class_name_length : LibC::SizeT) : CassError
    fun data_type_sub_type_count = cass_data_type_sub_type_count(data_type : CassDataType) : LibC::SizeT
    fun data_sub_type_count = cass_data_sub_type_count(data_type : CassDataType) : LibC::SizeT
    fun data_type_sub_data_type = cass_data_type_sub_data_type(data_type : CassDataType, index : LibC::SizeT) : CassDataType
    fun data_type_sub_data_type_by_name = cass_data_type_sub_data_type_by_name(data_type : CassDataType, name : LibC::Char*) : CassDataType
    fun data_type_sub_data_type_by_name_n = cass_data_type_sub_data_type_by_name_n(data_type : CassDataType, name : LibC::Char*, name_length : LibC::SizeT) : CassDataType
    fun data_type_sub_type_name = cass_data_type_sub_type_name(data_type : CassDataType, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun data_type_add_sub_type = cass_data_type_add_sub_type(data_type : CassDataType, sub_data_type : CassDataType) : CassError
    fun data_type_add_sub_type_by_name = cass_data_type_add_sub_type_by_name(data_type : CassDataType, name : LibC::Char*, sub_data_type : CassDataType) : CassError
    fun data_type_add_sub_type_by_name_n = cass_data_type_add_sub_type_by_name_n(data_type : CassDataType, name : LibC::Char*, name_length : LibC::SizeT, sub_data_type : CassDataType) : CassError
    fun data_type_add_sub_value_type = cass_data_type_add_sub_value_type(data_type : CassDataType, sub_value_type : CassValueType) : CassError
    fun data_type_add_sub_value_type_by_name = cass_data_type_add_sub_value_type_by_name(data_type : CassDataType, name : LibC::Char*, sub_value_type : CassValueType) : CassError
    fun data_type_add_sub_value_type_by_name_n = cass_data_type_add_sub_value_type_by_name_n(data_type : CassDataType, name : LibC::Char*, name_length : LibC::SizeT, sub_value_type : CassValueType) : CassError
    fun collection_new = cass_collection_new(type : CassCollectionType, item_count : LibC::SizeT) : CassCollection
    enum CassCollectionType
      CollectionTypeList = 32
      CollectionTypeMap = 33
      CollectionTypeSet = 34
    end
    fun collection_new_from_data_type = cass_collection_new_from_data_type(data_type : CassDataType, item_count : LibC::SizeT) : CassCollection
    fun collection_free = cass_collection_free(collection : CassCollection)
    fun collection_data_type = cass_collection_data_type(collection : CassCollection) : CassDataType
    fun collection_append_int8 = cass_collection_append_int8(collection : CassCollection, value : Int8T) : CassError
    fun collection_append_int16 = cass_collection_append_int16(collection : CassCollection, value : Int16T) : CassError
    fun collection_append_int32 = cass_collection_append_int32(collection : CassCollection, value : Int32T) : CassError
    fun collection_append_uint32 = cass_collection_append_uint32(collection : CassCollection, value : Uint32T) : CassError
    fun collection_append_int64 = cass_collection_append_int64(collection : CassCollection, value : Int64T) : CassError
    fun collection_append_float = cass_collection_append_float(collection : CassCollection, value : FloatT) : CassError
    fun collection_append_double = cass_collection_append_double(collection : CassCollection, value : DoubleT) : CassError
    fun collection_append_bool = cass_collection_append_bool(collection : CassCollection, value : BoolT) : CassError
    fun collection_append_string = cass_collection_append_string(collection : CassCollection, value : LibC::Char*) : CassError
    fun collection_append_string_n = cass_collection_append_string_n(collection : CassCollection, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun collection_append_bytes = cass_collection_append_bytes(collection : CassCollection, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun collection_append_custom = cass_collection_append_custom(collection : CassCollection, class_name : LibC::Char*, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun collection_append_custom_n = cass_collection_append_custom_n(collection : CassCollection, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun collection_append_uuid = cass_collection_append_uuid(collection : CassCollection, value : CassUuid) : CassError
    fun collection_append_inet = cass_collection_append_inet(collection : CassCollection, value : CassInet) : CassError
    fun collection_append_decimal = cass_collection_append_decimal(collection : CassCollection, varint : ByteT*, varint_size : LibC::SizeT, scale : Int32T) : CassError
    fun collection_append_duration = cass_collection_append_duration(collection : CassCollection, months : Int32T, days : Int32T, nanos : Int64T) : CassError
    fun collection_append_collection = cass_collection_append_collection(collection : CassCollection, value : CassCollection) : CassError
    fun collection_append_tuple = cass_collection_append_tuple(collection : CassCollection, value : CassTuple) : CassError
    fun collection_append_user_type = cass_collection_append_user_type(collection : CassCollection, value : CassUserType) : CassError
    fun tuple_new = cass_tuple_new(item_count : LibC::SizeT) : CassTuple
    fun tuple_new_from_data_type = cass_tuple_new_from_data_type(data_type : CassDataType) : CassTuple
    fun tuple_free = cass_tuple_free(tuple : CassTuple)
    fun tuple_data_type = cass_tuple_data_type(tuple : CassTuple) : CassDataType
    fun tuple_set_null = cass_tuple_set_null(tuple : CassTuple, index : LibC::SizeT) : CassError
    fun tuple_set_int8 = cass_tuple_set_int8(tuple : CassTuple, index : LibC::SizeT, value : Int8T) : CassError
    fun tuple_set_int16 = cass_tuple_set_int16(tuple : CassTuple, index : LibC::SizeT, value : Int16T) : CassError
    fun tuple_set_int32 = cass_tuple_set_int32(tuple : CassTuple, index : LibC::SizeT, value : Int32T) : CassError
    fun tuple_set_uint32 = cass_tuple_set_uint32(tuple : CassTuple, index : LibC::SizeT, value : Uint32T) : CassError
    fun tuple_set_int64 = cass_tuple_set_int64(tuple : CassTuple, index : LibC::SizeT, value : Int64T) : CassError
    fun tuple_set_float = cass_tuple_set_float(tuple : CassTuple, index : LibC::SizeT, value : FloatT) : CassError
    fun tuple_set_double = cass_tuple_set_double(tuple : CassTuple, index : LibC::SizeT, value : DoubleT) : CassError
    fun tuple_set_bool = cass_tuple_set_bool(tuple : CassTuple, index : LibC::SizeT, value : BoolT) : CassError
    fun tuple_set_string = cass_tuple_set_string(tuple : CassTuple, index : LibC::SizeT, value : LibC::Char*) : CassError
    fun tuple_set_string_n = cass_tuple_set_string_n(tuple : CassTuple, index : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun tuple_set_bytes = cass_tuple_set_bytes(tuple : CassTuple, index : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun tuple_set_custom = cass_tuple_set_custom(tuple : CassTuple, index : LibC::SizeT, class_name : LibC::Char*, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun tuple_set_custom_n = cass_tuple_set_custom_n(tuple : CassTuple, index : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun tuple_set_uuid = cass_tuple_set_uuid(tuple : CassTuple, index : LibC::SizeT, value : CassUuid) : CassError
    fun tuple_set_inet = cass_tuple_set_inet(tuple : CassTuple, index : LibC::SizeT, value : CassInet) : CassError
    fun tuple_set_decimal = cass_tuple_set_decimal(tuple : CassTuple, index : LibC::SizeT, varint : ByteT*, varint_size : LibC::SizeT, scale : Int32T) : CassError
    fun tuple_set_duration = cass_tuple_set_duration(tuple : CassTuple, index : LibC::SizeT, months : Int32T, days : Int32T, nanos : Int64T) : CassError
    fun tuple_set_collection = cass_tuple_set_collection(tuple : CassTuple, index : LibC::SizeT, value : CassCollection) : CassError
    fun tuple_set_tuple = cass_tuple_set_tuple(tuple : CassTuple, index : LibC::SizeT, value : CassTuple) : CassError
    fun tuple_set_user_type = cass_tuple_set_user_type(tuple : CassTuple, index : LibC::SizeT, value : CassUserType) : CassError
    fun user_type_new_from_data_type = cass_user_type_new_from_data_type(data_type : CassDataType) : CassUserType
    fun user_type_free = cass_user_type_free(user_type : CassUserType)
    fun user_type_data_type = cass_user_type_data_type(user_type : CassUserType) : CassDataType
    fun user_type_set_null = cass_user_type_set_null(user_type : CassUserType, index : LibC::SizeT) : CassError
    fun user_type_set_null_by_name = cass_user_type_set_null_by_name(user_type : CassUserType, name : LibC::Char*) : CassError
    fun user_type_set_null_by_name_n = cass_user_type_set_null_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT) : CassError
    fun user_type_set_int8 = cass_user_type_set_int8(user_type : CassUserType, index : LibC::SizeT, value : Int8T) : CassError
    fun user_type_set_int8_by_name = cass_user_type_set_int8_by_name(user_type : CassUserType, name : LibC::Char*, value : Int8T) : CassError
    fun user_type_set_int8_by_name_n = cass_user_type_set_int8_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : Int8T) : CassError
    fun user_type_set_int16 = cass_user_type_set_int16(user_type : CassUserType, index : LibC::SizeT, value : Int16T) : CassError
    fun user_type_set_int16_by_name = cass_user_type_set_int16_by_name(user_type : CassUserType, name : LibC::Char*, value : Int16T) : CassError
    fun user_type_set_int16_by_name_n = cass_user_type_set_int16_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : Int16T) : CassError
    fun user_type_set_int32 = cass_user_type_set_int32(user_type : CassUserType, index : LibC::SizeT, value : Int32T) : CassError
    fun user_type_set_int32_by_name = cass_user_type_set_int32_by_name(user_type : CassUserType, name : LibC::Char*, value : Int32T) : CassError
    fun user_type_set_int32_by_name_n = cass_user_type_set_int32_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : Int32T) : CassError
    fun user_type_set_uint32 = cass_user_type_set_uint32(user_type : CassUserType, index : LibC::SizeT, value : Uint32T) : CassError
    fun user_type_set_uint32_by_name = cass_user_type_set_uint32_by_name(user_type : CassUserType, name : LibC::Char*, value : Uint32T) : CassError
    fun user_type_set_uint32_by_name_n = cass_user_type_set_uint32_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : Uint32T) : CassError
    fun user_type_set_int64 = cass_user_type_set_int64(user_type : CassUserType, index : LibC::SizeT, value : Int64T) : CassError
    fun user_type_set_int64_by_name = cass_user_type_set_int64_by_name(user_type : CassUserType, name : LibC::Char*, value : Int64T) : CassError
    fun user_type_set_int64_by_name_n = cass_user_type_set_int64_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : Int64T) : CassError
    fun user_type_set_float = cass_user_type_set_float(user_type : CassUserType, index : LibC::SizeT, value : FloatT) : CassError
    fun user_type_set_float_by_name = cass_user_type_set_float_by_name(user_type : CassUserType, name : LibC::Char*, value : FloatT) : CassError
    fun user_type_set_float_by_name_n = cass_user_type_set_float_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : FloatT) : CassError
    fun user_type_set_double = cass_user_type_set_double(user_type : CassUserType, index : LibC::SizeT, value : DoubleT) : CassError
    fun user_type_set_double_by_name = cass_user_type_set_double_by_name(user_type : CassUserType, name : LibC::Char*, value : DoubleT) : CassError
    fun user_type_set_double_by_name_n = cass_user_type_set_double_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : DoubleT) : CassError
    fun user_type_set_bool = cass_user_type_set_bool(user_type : CassUserType, index : LibC::SizeT, value : BoolT) : CassError
    fun user_type_set_bool_by_name = cass_user_type_set_bool_by_name(user_type : CassUserType, name : LibC::Char*, value : BoolT) : CassError
    fun user_type_set_bool_by_name_n = cass_user_type_set_bool_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : BoolT) : CassError
    fun user_type_set_string = cass_user_type_set_string(user_type : CassUserType, index : LibC::SizeT, value : LibC::Char*) : CassError
    fun user_type_set_string_n = cass_user_type_set_string_n(user_type : CassUserType, index : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun user_type_set_string_by_name = cass_user_type_set_string_by_name(user_type : CassUserType, name : LibC::Char*, value : LibC::Char*) : CassError
    fun user_type_set_string_by_name_n = cass_user_type_set_string_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : LibC::Char*, value_length : LibC::SizeT) : CassError
    fun user_type_set_bytes = cass_user_type_set_bytes(user_type : CassUserType, index : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun user_type_set_bytes_by_name = cass_user_type_set_bytes_by_name(user_type : CassUserType, name : LibC::Char*, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun user_type_set_bytes_by_name_n = cass_user_type_set_bytes_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun user_type_set_custom = cass_user_type_set_custom(user_type : CassUserType, index : LibC::SizeT, class_name : LibC::Char*, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun user_type_set_custom_n = cass_user_type_set_custom_n(user_type : CassUserType, index : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun user_type_set_custom_by_name = cass_user_type_set_custom_by_name(user_type : CassUserType, name : LibC::Char*, class_name : LibC::Char*, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun user_type_set_custom_by_name_n = cass_user_type_set_custom_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, class_name : LibC::Char*, class_name_length : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT) : CassError
    fun user_type_set_uuid = cass_user_type_set_uuid(user_type : CassUserType, index : LibC::SizeT, value : CassUuid) : CassError
    fun user_type_set_uuid_by_name = cass_user_type_set_uuid_by_name(user_type : CassUserType, name : LibC::Char*, value : CassUuid) : CassError
    fun user_type_set_uuid_by_name_n = cass_user_type_set_uuid_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassUuid) : CassError
    fun user_type_set_inet = cass_user_type_set_inet(user_type : CassUserType, index : LibC::SizeT, value : CassInet) : CassError
    fun user_type_set_inet_by_name = cass_user_type_set_inet_by_name(user_type : CassUserType, name : LibC::Char*, value : CassInet) : CassError
    fun user_type_set_inet_by_name_n = cass_user_type_set_inet_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassInet) : CassError
    fun user_type_set_decimal = cass_user_type_set_decimal(user_type : CassUserType, index : LibC::SizeT, varint : ByteT*, varint_size : LibC::SizeT, scale : LibC::Int) : CassError
    fun user_type_set_decimal_by_name = cass_user_type_set_decimal_by_name(user_type : CassUserType, name : LibC::Char*, varint : ByteT*, varint_size : LibC::SizeT, scale : LibC::Int) : CassError
    fun user_type_set_decimal_by_name_n = cass_user_type_set_decimal_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, varint : ByteT*, varint_size : LibC::SizeT, scale : LibC::Int) : CassError
    fun user_type_set_duration = cass_user_type_set_duration(user_type : CassUserType, index : LibC::SizeT, months : Int32T, days : Int32T, nanos : Int64T) : CassError
    fun user_type_set_duration_by_name = cass_user_type_set_duration_by_name(user_type : CassUserType, name : LibC::Char*, months : Int32T, days : Int32T, nanos : Int64T) : CassError
    fun user_type_set_duration_by_name_n = cass_user_type_set_duration_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, months : Int32T, days : Int32T, nanos : Int64T) : CassError
    fun user_type_set_collection = cass_user_type_set_collection(user_type : CassUserType, index : LibC::SizeT, value : CassCollection) : CassError
    fun user_type_set_collection_by_name = cass_user_type_set_collection_by_name(user_type : CassUserType, name : LibC::Char*, value : CassCollection) : CassError
    fun user_type_set_collection_by_name_n = cass_user_type_set_collection_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassCollection) : CassError
    fun user_type_set_tuple = cass_user_type_set_tuple(user_type : CassUserType, index : LibC::SizeT, value : CassTuple) : CassError
    fun user_type_set_tuple_by_name = cass_user_type_set_tuple_by_name(user_type : CassUserType, name : LibC::Char*, value : CassTuple) : CassError
    fun user_type_set_tuple_by_name_n = cass_user_type_set_tuple_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassTuple) : CassError
    fun user_type_set_user_type = cass_user_type_set_user_type(user_type : CassUserType, index : LibC::SizeT, value : CassUserType) : CassError
    fun user_type_set_user_type_by_name = cass_user_type_set_user_type_by_name(user_type : CassUserType, name : LibC::Char*, value : CassUserType) : CassError
    fun user_type_set_user_type_by_name_n = cass_user_type_set_user_type_by_name_n(user_type : CassUserType, name : LibC::Char*, name_length : LibC::SizeT, value : CassUserType) : CassError
    fun result_free = cass_result_free(result : CassResult)
    fun result_row_count = cass_result_row_count(result : CassResult) : LibC::SizeT
    fun result_column_count = cass_result_column_count(result : CassResult) : LibC::SizeT
    fun result_column_name = cass_result_column_name(result : CassResult, index : LibC::SizeT, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun result_column_type = cass_result_column_type(result : CassResult, index : LibC::SizeT) : CassValueType
    fun result_column_data_type = cass_result_column_data_type(result : CassResult, index : LibC::SizeT) : CassDataType
    fun result_first_row = cass_result_first_row(result : CassResult) : CassRow
    type CassRow = Void*
    fun result_has_more_pages = cass_result_has_more_pages(result : CassResult) : BoolT
    fun result_paging_state_token = cass_result_paging_state_token(result : CassResult, paging_state : LibC::Char**, paging_state_size : LibC::SizeT*) : CassError
    fun error_result_free = cass_error_result_free(error_result : CassErrorResult)
    fun error_result_code = cass_error_result_code(error_result : CassErrorResult) : CassError
    fun error_result_consistency = cass_error_result_consistency(error_result : CassErrorResult) : CassConsistency
    fun error_result_responses_received = cass_error_result_responses_received(error_result : CassErrorResult) : Int32T
    fun error_result_responses_required = cass_error_result_responses_required(error_result : CassErrorResult) : Int32T
    fun error_result_num_failures = cass_error_result_num_failures(error_result : CassErrorResult) : Int32T
    fun error_result_data_present = cass_error_result_data_present(error_result : CassErrorResult) : BoolT
    fun error_result_write_type = cass_error_result_write_type(error_result : CassErrorResult) : CassWriteType
    enum CassWriteType
      WriteTypeUnknown = 0
      WriteTypeSimple = 1
      WriteTypeBatch = 2
      WriteTypeUnloggedBatch = 3
      WriteTypeCounter = 4
      WriteTypeBatchLog = 5
      WriteTypeCas = 6
      WriteTypeView = 7
      WriteTypeCdc = 8
    end
    fun error_result_keyspace = cass_error_result_keyspace(error_result : CassErrorResult, keyspace : LibC::Char**, keyspace_length : LibC::SizeT*) : CassError
    fun error_result_table = cass_error_result_table(error_result : CassErrorResult, table : LibC::Char**, table_length : LibC::SizeT*) : CassError
    fun error_result_function = cass_error_result_function(error_result : CassErrorResult, function : LibC::Char**, function_length : LibC::SizeT*) : CassError
    fun error_num_arg_types = cass_error_num_arg_types(error_result : CassErrorResult) : LibC::SizeT
    fun error_result_arg_type = cass_error_result_arg_type(error_result : CassErrorResult, index : LibC::SizeT, arg_type : LibC::Char**, arg_type_length : LibC::SizeT*) : CassError
    fun iterator_free = cass_iterator_free(iterator : CassIterator)
    type CassIterator = Void*
    fun iterator_type = cass_iterator_type(iterator : CassIterator) : CassIteratorType
    enum CassIteratorType
      IteratorTypeResult = 0
      IteratorTypeRow = 1
      IteratorTypeCollection = 2
      IteratorTypeMap = 3
      IteratorTypeTuple = 4
      IteratorTypeUserTypeField = 5
      IteratorTypeMetaField = 6
      IteratorTypeKeyspaceMeta = 7
      IteratorTypeTableMeta = 8
      IteratorTypeTypeMeta = 9
      IteratorTypeFunctionMeta = 10
      IteratorTypeAggregateMeta = 11
      IteratorTypeColumnMeta = 12
      IteratorTypeIndexMeta = 13
      IteratorTypeMaterializedViewMeta = 14
    end
    fun iterator_from_result = cass_iterator_from_result(result : CassResult) : CassIterator
    fun iterator_from_row = cass_iterator_from_row(row : CassRow) : CassIterator
    fun iterator_from_collection = cass_iterator_from_collection(value : CassValue) : CassIterator
    fun iterator_from_map = cass_iterator_from_map(value : CassValue) : CassIterator
    fun iterator_from_tuple = cass_iterator_from_tuple(value : CassValue) : CassIterator
    fun iterator_fields_from_user_type = cass_iterator_fields_from_user_type(value : CassValue) : CassIterator
    fun iterator_keyspaces_from_schema_meta = cass_iterator_keyspaces_from_schema_meta(schema_meta : CassSchemaMeta) : CassIterator
    fun iterator_tables_from_keyspace_meta = cass_iterator_tables_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun iterator_materialized_views_from_keyspace_meta = cass_iterator_materialized_views_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun iterator_user_types_from_keyspace_meta = cass_iterator_user_types_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun iterator_functions_from_keyspace_meta = cass_iterator_functions_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun iterator_aggregates_from_keyspace_meta = cass_iterator_aggregates_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun iterator_fields_from_keyspace_meta = cass_iterator_fields_from_keyspace_meta(keyspace_meta : CassKeyspaceMeta) : CassIterator
    fun iterator_columns_from_table_meta = cass_iterator_columns_from_table_meta(table_meta : CassTableMeta) : CassIterator
    fun iterator_indexes_from_table_meta = cass_iterator_indexes_from_table_meta(table_meta : CassTableMeta) : CassIterator
    fun iterator_materialized_views_from_table_meta = cass_iterator_materialized_views_from_table_meta(table_meta : CassTableMeta) : CassIterator
    fun iterator_fields_from_table_meta = cass_iterator_fields_from_table_meta(table_meta : CassTableMeta) : CassIterator
    fun iterator_columns_from_materialized_view_meta = cass_iterator_columns_from_materialized_view_meta(view_meta : CassMaterializedViewMeta) : CassIterator
    fun iterator_fields_from_materialized_view_meta = cass_iterator_fields_from_materialized_view_meta(view_meta : CassMaterializedViewMeta) : CassIterator
    fun iterator_fields_from_column_meta = cass_iterator_fields_from_column_meta(column_meta : CassColumnMeta) : CassIterator
    fun iterator_fields_from_index_meta = cass_iterator_fields_from_index_meta(index_meta : CassIndexMeta) : CassIterator
    fun iterator_fields_from_function_meta = cass_iterator_fields_from_function_meta(function_meta : CassFunctionMeta) : CassIterator
    fun iterator_fields_from_aggregate_meta = cass_iterator_fields_from_aggregate_meta(aggregate_meta : CassAggregateMeta) : CassIterator
    fun iterator_next = cass_iterator_next(iterator : CassIterator) : BoolT
    fun iterator_get_row = cass_iterator_get_row(iterator : CassIterator) : CassRow
    fun iterator_get_column = cass_iterator_get_column(iterator : CassIterator) : CassValue
    fun iterator_get_value = cass_iterator_get_value(iterator : CassIterator) : CassValue
    fun iterator_get_map_key = cass_iterator_get_map_key(iterator : CassIterator) : CassValue
    fun iterator_get_map_value = cass_iterator_get_map_value(iterator : CassIterator) : CassValue
    fun iterator_get_user_type_field_name = cass_iterator_get_user_type_field_name(iterator : CassIterator, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun iterator_get_user_type_field_value = cass_iterator_get_user_type_field_value(iterator : CassIterator) : CassValue
    fun iterator_get_keyspace_meta = cass_iterator_get_keyspace_meta(iterator : CassIterator) : CassKeyspaceMeta
    fun iterator_get_table_meta = cass_iterator_get_table_meta(iterator : CassIterator) : CassTableMeta
    fun iterator_get_materialized_view_meta = cass_iterator_get_materialized_view_meta(iterator : CassIterator) : CassMaterializedViewMeta
    fun iterator_get_user_type = cass_iterator_get_user_type(iterator : CassIterator) : CassDataType
    fun iterator_get_function_meta = cass_iterator_get_function_meta(iterator : CassIterator) : CassFunctionMeta
    fun iterator_get_aggregate_meta = cass_iterator_get_aggregate_meta(iterator : CassIterator) : CassAggregateMeta
    fun iterator_get_column_meta = cass_iterator_get_column_meta(iterator : CassIterator) : CassColumnMeta
    fun iterator_get_index_meta = cass_iterator_get_index_meta(iterator : CassIterator) : CassIndexMeta
    fun iterator_get_meta_field_name = cass_iterator_get_meta_field_name(iterator : CassIterator, name : LibC::Char**, name_length : LibC::SizeT*) : CassError
    fun iterator_get_meta_field_value = cass_iterator_get_meta_field_value(iterator : CassIterator) : CassValue
    fun row_get_column = cass_row_get_column(row : CassRow, index : LibC::SizeT) : CassValue
    fun row_get_column_by_name = cass_row_get_column_by_name(row : CassRow, name : LibC::Char*) : CassValue
    fun row_get_column_by_name_n = cass_row_get_column_by_name_n(row : CassRow, name : LibC::Char*, name_length : LibC::SizeT) : CassValue
    fun value_data_type = cass_value_data_type(value : CassValue) : CassDataType
    fun value_get_int8 = cass_value_get_int8(value : CassValue, output : Int8T*) : CassError
    fun value_get_int16 = cass_value_get_int16(value : CassValue, output : Int16T*) : CassError
    fun value_get_int32 = cass_value_get_int32(value : CassValue, output : Int32T*) : CassError
    fun value_get_uint32 = cass_value_get_uint32(value : CassValue, output : Uint32T*) : CassError
    fun value_get_int64 = cass_value_get_int64(value : CassValue, output : Int64T*) : CassError
    fun value_get_float = cass_value_get_float(value : CassValue, output : FloatT*) : CassError
    fun value_get_double = cass_value_get_double(value : CassValue, output : DoubleT*) : CassError
    fun value_get_bool = cass_value_get_bool(value : CassValue, output : BoolT*) : CassError
    fun value_get_uuid = cass_value_get_uuid(value : CassValue, output : CassUuid*) : CassError
    fun value_get_inet = cass_value_get_inet(value : CassValue, output : CassInet*) : CassError
    fun value_get_string = cass_value_get_string(value : CassValue, output : LibC::Char**, output_size : LibC::SizeT*) : CassError
    fun value_get_bytes = cass_value_get_bytes(value : CassValue, output : ByteT**, output_size : LibC::SizeT*) : CassError
    fun value_get_decimal = cass_value_get_decimal(value : CassValue, varint : ByteT**, varint_size : LibC::SizeT*, scale : Int32T*) : CassError
    fun value_get_duration = cass_value_get_duration(value : CassValue, months : Int32T*, days : Int32T*, nanos : Int64T*) : CassError
    fun value_type = cass_value_type(value : CassValue) : CassValueType
    fun value_is_null = cass_value_is_null(value : CassValue) : BoolT
    fun value_is_collection = cass_value_is_collection(value : CassValue) : BoolT
    fun value_is_duration = cass_value_is_duration(value : CassValue) : BoolT
    fun value_item_count = cass_value_item_count(collection : CassValue) : LibC::SizeT
    fun value_primary_sub_type = cass_value_primary_sub_type(collection : CassValue) : CassValueType
    fun value_secondary_sub_type = cass_value_secondary_sub_type(collection : CassValue) : CassValueType
    fun uuid_gen_new = cass_uuid_gen_new : CassUuidGen
    type CassUuidGen = Void*
    fun uuid_gen_new_with_node = cass_uuid_gen_new_with_node(node : Uint64T) : CassUuidGen
    fun uuid_gen_free = cass_uuid_gen_free(uuid_gen : CassUuidGen)
    fun uuid_gen_time = cass_uuid_gen_time(uuid_gen : CassUuidGen, output : CassUuid*)
    fun uuid_gen_random = cass_uuid_gen_random(uuid_gen : CassUuidGen, output : CassUuid*)
    fun uuid_gen_from_time = cass_uuid_gen_from_time(uuid_gen : CassUuidGen, timestamp : Uint64T, output : CassUuid*)
    fun uuid_min_from_time = cass_uuid_min_from_time(time : Uint64T, output : CassUuid*)
    fun uuid_max_from_time = cass_uuid_max_from_time(time : Uint64T, output : CassUuid*)
    fun uuid_timestamp = cass_uuid_timestamp(uuid : CassUuid) : Uint64T
    fun uuid_version = cass_uuid_version(uuid : CassUuid) : Uint8T
    fun uuid_string = cass_uuid_string(uuid : CassUuid, output : LibC::Char*)
    fun uuid_from_string = cass_uuid_from_string(str : LibC::Char*, output : CassUuid*) : CassError
    fun uuid_from_string_n = cass_uuid_from_string_n(str : LibC::Char*, str_length : LibC::SizeT, output : CassUuid*) : CassError
    fun timestamp_gen_server_side_new = cass_timestamp_gen_server_side_new : CassTimestampGen
    fun timestamp_gen_monotonic_new = cass_timestamp_gen_monotonic_new : CassTimestampGen
    fun timestamp_gen_monotonic_new_with_settings = cass_timestamp_gen_monotonic_new_with_settings(warning_threshold_us : Int64T, warning_interval_ms : Int64T) : CassTimestampGen
    fun timestamp_gen_free = cass_timestamp_gen_free(timestamp_gen : CassTimestampGen)
    fun retry_policy_default_new = cass_retry_policy_default_new : CassRetryPolicy
    fun retry_policy_downgrading_consistency_new = cass_retry_policy_downgrading_consistency_new : CassRetryPolicy
    fun retry_policy_fallthrough_new = cass_retry_policy_fallthrough_new : CassRetryPolicy
    fun retry_policy_logging_new = cass_retry_policy_logging_new(child_retry_policy : CassRetryPolicy) : CassRetryPolicy
    fun retry_policy_free = cass_retry_policy_free(policy : CassRetryPolicy)
    fun custom_payload_new = cass_custom_payload_new : CassCustomPayload
    fun custom_payload_free = cass_custom_payload_free(payload : CassCustomPayload)
    fun custom_payload_set = cass_custom_payload_set(payload : CassCustomPayload, name : LibC::Char*, value : ByteT*, value_size : LibC::SizeT)
    fun custom_payload_set_n = cass_custom_payload_set_n(payload : CassCustomPayload, name : LibC::Char*, name_length : LibC::SizeT, value : ByteT*, value_size : LibC::SizeT)
    fun custom_payload_remove = cass_custom_payload_remove(payload : CassCustomPayload, name : LibC::Char*)
    fun custom_payload_remove_n = cass_custom_payload_remove_n(payload : CassCustomPayload, name : LibC::Char*, name_length : LibC::SizeT)
    fun consistency_string = cass_consistency_string(consistency : CassConsistency) : LibC::Char*
    fun write_type_string = cass_write_type_string(write_type : CassWriteType) : LibC::Char*
    fun error_desc = cass_error_desc(error : CassError) : LibC::Char*
    fun log_cleanup = cass_log_cleanup
    fun log_set_level = cass_log_set_level(log_level : CassLogLevel)
    enum CassLogLevel
      LogDisabled = 0
      LogCritical = 1
      LogError = 2
      LogWarn = 3
      LogInfo = 4
      LogDebug = 5
      LogTrace = 6
      LogLastEntry = 7
    end
    fun log_set_callback = cass_log_set_callback(callback : CassLogCallback, data : Void*)
    struct CassLogMessage
      time_ms : Uint64T
      severity : CassLogLevel
      file : LibC::Char*
      line : LibC::Int
      function : LibC::Char*
      message : LibC::Char[1024]
    end
    alias CassLogCallback = (CassLogMessage*, Void* -> Void)
    fun log_set_queue_size = cass_log_set_queue_size(queue_size : LibC::SizeT)
    fun log_level_string = cass_log_level_string(log_level : CassLogLevel) : LibC::Char*
    fun inet_init_v4 = cass_inet_init_v4(address : Uint8T*) : CassInet
    fun inet_init_v6 = cass_inet_init_v6(address : Uint8T*) : CassInet
    fun inet_string = cass_inet_string(inet : CassInet, output : LibC::Char*)
    fun inet_from_string = cass_inet_from_string(str : LibC::Char*, output : CassInet*) : CassError
    fun inet_from_string_n = cass_inet_from_string_n(str : LibC::Char*, str_length : LibC::SizeT, output : CassInet*) : CassError
    fun date_from_epoch = cass_date_from_epoch(epoch_secs : Int64T) : Uint32T
    fun time_from_epoch = cass_time_from_epoch(epoch_secs : Int64T) : Int64T
    fun date_time_to_epoch = cass_date_time_to_epoch(date : Uint32T, time : Int64T) : Int64T
    fun alloc_set_functions = cass_alloc_set_functions(malloc_func : CassMallocFunction, realloc_func : CassReallocFunction, free_func : CassFreeFunction)
    alias CassMallocFunction = (LibC::SizeT -> Void*)
    alias CassReallocFunction = (Void*, LibC::SizeT -> Void*)
    alias CassFreeFunction = (Void* -> Void)
  end
end
