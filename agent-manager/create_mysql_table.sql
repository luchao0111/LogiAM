SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

drop database IF EXISTS logi_agent_manager;
create database logi_agent_manager;
use logi_agent_manager;

-- ----------------------------
-- Table structure for auv_job
-- ----------------------------
DROP TABLE IF EXISTS `auv_job`;
CREATE TABLE `auv_job` (
                           `id` bigint NOT NULL AUTO_INCREMENT,
                           `code` varchar(100) NOT NULL DEFAULT '' COMMENT 'task code',
                           `task_code` varchar(255) NOT NULL DEFAULT '' COMMENT '任务code',
                           `class_name` varchar(255) NOT NULL DEFAULT '' COMMENT '类的全限定名',
                           `try_times` int NOT NULL DEFAULT '0' COMMENT '第几次重试',
                           `worker_code` varchar(200) NOT NULL DEFAULT '' COMMENT '执行机器',
                           `start_time` datetime DEFAULT '1971-01-01 00:00:00' COMMENT '开始时间',
                           `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                           `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                           PRIMARY KEY (`id`),
                           UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='正在执行的job信息';

-- ----------------------------
-- Table structure for auv_job_log
-- ----------------------------
DROP TABLE IF EXISTS `auv_job_log`;
CREATE TABLE `auv_job_log` (
                               `id` bigint NOT NULL AUTO_INCREMENT,
                               `job_code` varchar(100) NOT NULL DEFAULT '' COMMENT 'job code',
                               `task_code` varchar(255) NOT NULL DEFAULT '' COMMENT '任务code',
                               `class_name` varchar(255) NOT NULL DEFAULT '' COMMENT '类的全限定名',
                               `try_times` int NOT NULL DEFAULT '0' COMMENT '第几次重试',
                               `worker_code` varchar(200) NOT NULL DEFAULT '' COMMENT '执行机器',
                               `start_time` datetime DEFAULT '1971-01-01 00:00:00' COMMENT '开始时间',
                               `end_time` datetime DEFAULT '1971-01-01 00:00:00' COMMENT '结束时间',
                               `status` tinyint NOT NULL DEFAULT '0' COMMENT '执行结果 1成功 2失败 3取消',
                               `error` text NOT NULL COMMENT '错误信息',
                               `result` text NOT NULL COMMENT '执行结果',
                               `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                               `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                               PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='job执行历史日志';

-- ----------------------------
-- Table structure for auv_task
-- ----------------------------
DROP TABLE IF EXISTS `auv_task`;
CREATE TABLE `auv_task` (
                            `id` bigint NOT NULL AUTO_INCREMENT,
                            `code` varchar(100) NOT NULL DEFAULT '' COMMENT 'task code',
                            `name` varchar(255) NOT NULL DEFAULT '' COMMENT '名称',
                            `description` varchar(1000) NOT NULL DEFAULT '' COMMENT '任务描述',
                            `cron` varchar(100) NOT NULL DEFAULT '' COMMENT 'cron 表达式',
                            `class_name` varchar(255) NOT NULL DEFAULT '' COMMENT '类的全限定名',
                            `params` varchar(1000) NOT NULL DEFAULT '' COMMENT '执行参数 map 形式{key1:value1,key2:value2}',
                            `retry_times` int NOT NULL DEFAULT '0' COMMENT '允许重试次数',
                            `last_fire_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '上次执行时间 [Deprecated]',
                            `timeout` bigint NOT NULL DEFAULT '0' COMMENT '超时 毫秒',
                            `status` tinyint NOT NULL DEFAULT '0' COMMENT '1等待 2运行中 3暂停 [Deprecated]',
                            `sub_task_codes` varchar(1000) NOT NULL DEFAULT '' COMMENT '子任务code列表,逗号分隔',
                            `consensual` varchar(200) NOT NULL DEFAULT '' COMMENT '执行策略',
                            `task_worker_str` varchar(1000) NOT NULL DEFAULT '' COMMENT '机器执行信息',
                            `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                            PRIMARY KEY (`id`),
                            UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='任务信息';

-- ----------------------------
-- Table structure for auv_task_lock
-- ----------------------------
DROP TABLE IF EXISTS `auv_task_lock`;
CREATE TABLE `auv_task_lock` (
                                 `id` bigint NOT NULL AUTO_INCREMENT,
                                 `task_code` varchar(100) NOT NULL DEFAULT '' COMMENT 'task code',
                                 `worker_code` varchar(100) NOT NULL DEFAULT '' COMMENT 'worker code',
                                 `expire_time` bigint NOT NULL DEFAULT '0' COMMENT '过期时间',
                                 `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                 `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                 PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='任务锁';

-- ----------------------------
-- Table structure for auv_worker
-- ----------------------------
DROP TABLE IF EXISTS `auv_worker`;
CREATE TABLE `auv_worker` (
                              `id` bigint NOT NULL AUTO_INCREMENT,
                              `code` varchar(100) NOT NULL DEFAULT '' COMMENT 'worker code',
                              `name` varchar(100) NOT NULL DEFAULT '' COMMENT 'worker名',
                              `cpu` int NOT NULL DEFAULT '0' COMMENT 'cpu数量',
                              `cpu_used` double NOT NULL DEFAULT '0' COMMENT 'cpu使用率',
                              `memory` double NOT NULL DEFAULT '0' COMMENT '内存,以M为单位',
                              `memory_used` double NOT NULL DEFAULT '0' COMMENT '内存使用率',
                              `jvm_memory` double NOT NULL DEFAULT '0' COMMENT 'jvm堆大小，以M为单位',
                              `jvm_memory_used` double NOT NULL DEFAULT '0' COMMENT 'jvm堆使用率',
                              `job_num` int NOT NULL DEFAULT '0' COMMENT '正在执行job数',
                              `heartbeat` datetime DEFAULT '1971-01-01 00:00:00' COMMENT '心跳时间',
                              `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                              PRIMARY KEY (`id`),
                              UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB AUTO_INCREMENT=198 DEFAULT CHARSET=utf8mb3 COMMENT='worker信息';

-- ----------------------------
-- Table structure for auv_worker_blacklist
-- ----------------------------
DROP TABLE IF EXISTS `auv_worker_blacklist`;
CREATE TABLE `auv_worker_blacklist` (
                                        `id` bigint NOT NULL AUTO_INCREMENT,
                                        `worker_code` varchar(100) NOT NULL DEFAULT '' COMMENT 'worker code',
                                        `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                        `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
                                        PRIMARY KEY (`id`),
                                        UNIQUE KEY `code` (`worker_code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='worker黑名单列表';

-- ----------------------------
-- Table structure for error_log
-- ----------------------------
DROP TABLE IF EXISTS `error_log`;
CREATE TABLE `error_log` (
                             `id` bigint NOT NULL AUTO_INCREMENT,
                             `heartbeat_time` bigint NOT NULL DEFAULT '0',
                             `hostname` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
                             `host_ip` char(32) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
                             `log_code` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
                             `throwable` varchar(2048) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
                             `count` int NOT NULL DEFAULT '0',
                             `log_msg` varchar(256) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
                             `operator` varchar(64) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL DEFAULT '',
                             `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
                             `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                             PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for operate_record
-- ----------------------------
DROP TABLE IF EXISTS `operate_record`;
CREATE TABLE `operate_record` (
                                  `id` int unsigned NOT NULL AUTO_INCREMENT COMMENT '主键 自增',
                                  `module_id` int NOT NULL DEFAULT '-1' COMMENT '模块id',
                                  `operate_id` int NOT NULL DEFAULT '-1' COMMENT '操作id',
                                  `biz_id` varchar(100) NOT NULL DEFAULT '' COMMENT '业务id string类型',
                                  `business_id` int NOT NULL DEFAULT '-1' COMMENT '业务id',
                                  `content` text COMMENT '操作内容',
                                  `operator` varchar(50) NOT NULL DEFAULT '' COMMENT '操作人',
                                  `operate_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '操作时间',
                                  PRIMARY KEY (`id`),
                                  KEY `idx_module_business` (`module_id`,`business_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for tb_agent
-- ----------------------------
DROP TABLE IF EXISTS `tb_agent`;
CREATE TABLE `tb_agent` (
                            `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                            `host_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'Agent宿主机名',
                            `ip` varchar(64) NOT NULL DEFAULT '' COMMENT 'Agent宿主机ip',
                            `collect_type` tinyint NOT NULL DEFAULT '0' COMMENT '采集方式：\n0：采集宿主机日志\n1：采集宿主机所有容器日志\n2：采集宿主机日志 & 宿主机所有容器日志\n',
                            `cpu_limit_threshold` int DEFAULT '0' COMMENT '采集端限流 cpu 阈值',
                            `byte_limit_threshold` bigint DEFAULT '0' COMMENT '采集端限流流量阈值 单位：字节',
                            `agent_version_id` bigint NOT NULL DEFAULT '0' COMMENT 'Agent版本id',
                            `advanced_configuration_json_string` varchar(4096) DEFAULT '' COMMENT 'Agent高级配置项集，为json形式字符串',
                            `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                            `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                            `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                            `configuration_version` int NOT NULL DEFAULT '0' COMMENT 'Agent 配置版本号',
                            `metrics_send_topic` varchar(255) DEFAULT NULL COMMENT 'Agent指标信息发往的topic名',
                            `metrics_send_receiver_id` bigint DEFAULT NULL COMMENT 'Agent指标信息发往的接收端id',
                            `error_logs_send_topic` varchar(255) DEFAULT NULL COMMENT 'Agent错误日志信息发往的topic名',
                            `error_logs_send_receiver_id` bigint DEFAULT NULL COMMENT 'Agent错误日志信息发往的接收端id',
                            `metrics_producer_configuration` varchar(256) DEFAULT '',
                            `error_logs_producer_configuration` varchar(256) DEFAULT '',
                            PRIMARY KEY (`id`) USING BTREE,
                            UNIQUE KEY `uniq_host_name` (`host_name`) COMMENT '主机名唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='采集端表：表示一个部署在某host上的采集端';

-- ----------------------------
-- Table structure for tb_agent_health
-- ----------------------------
DROP TABLE IF EXISTS `tb_agent_health`;
CREATE TABLE `tb_agent_health` (
                                   `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                   `agent_id` bigint NOT NULL COMMENT '表tb_agent主键',
                                   `agent_health_level` tinyint NOT NULL COMMENT ' agent健康等级',
                                   `agent_health_description` varchar(1024) NOT NULL DEFAULT '' COMMENT ' agent健康描述信息',
                                   `lastest_error_logs_exists_check_healthy_time` bigint NOT NULL COMMENT ' 近一次“错误日志存在健康检查”为健康时的时间点',
                                   `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                   `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                   `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                   `agent_startup_time` bigint DEFAULT NULL COMMENT ' agent启动时间',
                                   `agent_startup_time_last_time` bigint DEFAULT NULL COMMENT ' agent上一次启动时间',
                                   PRIMARY KEY (`id`) USING BTREE,
                                   KEY `idx_agent_id` (`agent_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for tb_agent_operation_sub_task
-- ----------------------------
DROP TABLE IF EXISTS `tb_agent_operation_sub_task`;
CREATE TABLE `tb_agent_operation_sub_task` (
                                               `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                               `agent_operation_task_id` bigint NOT NULL DEFAULT '-1' COMMENT '表tb_agent_operation_task主键 id',
                                               `host_name` varchar(128) NOT NULL DEFAULT '' COMMENT '主机名',
                                               `ip` varchar(64) NOT NULL,
                                               `container` tinyint NOT NULL DEFAULT '0' COMMENT '标识是否为容器节点\n0：否\n1：是\n',
                                               `source_agent_version_id` bigint DEFAULT NULL COMMENT '原 agent_version id',
                                               `task_start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '该主机任务开始执行时间',
                                               `task_end_time` timestamp NULL DEFAULT NULL COMMENT '该主机任务执行结束时间',
                                               `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                               `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                               `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                               `execute_status` tinyint DEFAULT NULL COMMENT '执行状态：见枚举类 AgentOperationTaskSubStateEnum\n\n',
                                               PRIMARY KEY (`id`) USING BTREE,
                                               KEY `idx_agent_operation_task_id` (`agent_operation_task_id`) USING BTREE,
                                               KEY `idx_hostname_start_time` (`host_name`,`task_start_time`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='采集端操作任务 & 主机名关联关系表：表示采集端操作任务 &主机名的关联关系，agentOperationTask： hostName 一对多关联关系';

-- ----------------------------
-- Table structure for tb_agent_operation_task
-- ----------------------------
DROP TABLE IF EXISTS `tb_agent_operation_task`;
CREATE TABLE `tb_agent_operation_task` (
                                           `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                           `task_name` varchar(128) NOT NULL DEFAULT '' COMMENT '任务名',
                                           `task_status` tinyint NOT NULL DEFAULT '-1' COMMENT '任务状态 30：执行中 100：已完成',
                                           `task_type` tinyint NOT NULL DEFAULT '0' COMMENT '任务类型：0：安装 1：卸载 2：升级',
                                           `hosts_number` int NOT NULL COMMENT '任务涉及主机数量',
                                           `source_agent_version_id` bigint DEFAULT '0' COMMENT '安装任务时：无须传入；卸载任务时：无须传入；升级任务时：表示agent升级前agent对应agent_version id',
                                           `target_agent_version_id` bigint DEFAULT NULL COMMENT '安装任务时：表示待安装 agent 对应 agent version id；卸载任务时：无须传入；升级任务时：表示agent升级后agent对应agent_version id',
                                           `external_agent_task_id` bigint NOT NULL DEFAULT '-1' COMMENT '外部对应 agent 执行任务 id，如宙斯系统的 agent 任务 id',
                                           `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                           `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                           `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                           `task_start_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '任务开始执行时间',
                                           `task_end_time` timestamp NULL DEFAULT NULL COMMENT '任务执行结束时间',
                                           PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='采集端操作任务表：表示针对某个host上的agent部署、卸载操作计划任务';

-- ----------------------------
-- Table structure for tb_agent_version
-- ----------------------------
DROP TABLE IF EXISTS `tb_agent_version`;
CREATE TABLE `tb_agent_version` (
                                    `id` bigint NOT NULL AUTO_INCREMENT COMMENT ' pk',
                                    `file_name` varchar(128) NOT NULL DEFAULT '' COMMENT '文件名',
                                    `file_md5` varchar(256) NOT NULL DEFAULT '' COMMENT '文件md5',
                                    `file_type` tinyint NOT NULL DEFAULT '0' COMMENT '0：agent安装压缩包 1：agent配置文件',
                                    `description` varchar(4096) DEFAULT '' COMMENT '备注信息',
                                    `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                    `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                    `version` varchar(255) NOT NULL DEFAULT '' COMMENT 'agent 安装包版本号',
                                    PRIMARY KEY (`id`) USING BTREE,
                                    UNIQUE KEY `unq_idx_version` (`version`) USING BTREE,
                                    UNIQUE KEY `unq_idx_file_md5` (`file_md5`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for tb_collect_delay_monitor_black_list
-- ----------------------------
DROP TABLE IF EXISTS `tb_collect_delay_monitor_black_list`;
CREATE TABLE `tb_collect_delay_monitor_black_list` (
                                                       `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                                       `collect_delay_monitor_black_list_type` tinyint NOT NULL DEFAULT '0' COMMENT '采集延迟检查黑名单类型：\n\n0：表示主机\n\n1：表示采集任务\n\n2：表示主机 + 采集任务',
                                                       `host_name` varchar(128) NOT NULL DEFAULT '' COMMENT '主机名',
                                                       `log_collector_task_id` bigint NOT NULL COMMENT '表tb_log_collect_task 主键 id',
                                                       `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                                       `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                                       `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                                       PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='采集延迟检查黑名单信息表：表示一个采集延迟检查黑名单信息';

-- ----------------------------
-- Table structure for tb_directory_log_collect_path
-- ----------------------------
DROP TABLE IF EXISTS `tb_directory_log_collect_path`;
CREATE TABLE `tb_directory_log_collect_path` (
                                                 `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                                 `log_collect_task_id` bigint NOT NULL COMMENT '表tb_log_collect_task主键',
                                                 `path` varchar(255) NOT NULL DEFAULT '' COMMENT '待采集路径',
                                                 `collect_files_filter_regular_pipeline_json_string` varchar(4096) NOT NULL DEFAULT '' COMMENT '采集文件筛选正则集 pipeline json 形式字符串，集合中每一项为一个过滤正则项< filterRegular , type >，filterRegular表示过滤正则内容，type表示黑/白名单类型0：白名单 1：黑名单\n\n注：FilterRegular 须有序存储，过滤时按集合顺序进行过滤计算',
                                                 `directory_collect_depth` int NOT NULL DEFAULT '1' COMMENT '目录采集深度',
                                                 `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                                 `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                                 `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT ' 修改时间',
                                                 PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='目录类型日志采集路径表：表示一个目录类型日志采集路径，DirectoryLogCollectPath：LogCollectorTask 多对一关联关系';

-- ----------------------------
-- Table structure for tb_file_log_collect_path
-- ----------------------------
DROP TABLE IF EXISTS `tb_file_log_collect_path`;
CREATE TABLE `tb_file_log_collect_path` (
                                            `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                            `log_collect_task_id` bigint NOT NULL COMMENT '表tb_log_collect_task主键',
                                            `path` varchar(255) NOT NULL DEFAULT '' COMMENT '待采集路径',
                                            `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                            `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                            `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                            PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='文件类型日志采集路径表：表示一个文件类型日志采集路径，FileLogCollectPath：LogCollectorTask 多对一关联关系';

-- ----------------------------
-- Table structure for tb_global_config
-- ----------------------------
DROP TABLE IF EXISTS `tb_global_config`;
CREATE TABLE `tb_global_config` (
                                    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                    `key` varchar(255) NOT NULL DEFAULT '' COMMENT '键',
                                    `value` varchar(4096) NOT NULL DEFAULT '' COMMENT '值',
                                    `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                    `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='全局配置信息表：表示一个全局配置信息';

-- ----------------------------
-- Table structure for tb_host
-- ----------------------------
DROP TABLE IF EXISTS `tb_host`;
CREATE TABLE `tb_host` (
                           `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                           `host_name` varchar(128) NOT NULL DEFAULT '' COMMENT '主机名',
                           `ip` varchar(64) NOT NULL DEFAULT '' COMMENT '主机IP',
                           `container` tinyint NOT NULL DEFAULT '0' COMMENT '标识是否为容器节点\n0：否\n1：是\n',
                           `parent_host_name` varchar(128) NOT NULL DEFAULT '-1' COMMENT '针对容器场景，表示容器对应宿主机id',
                           `machine_zone` varchar(64) DEFAULT '' COMMENT '主机所属机器单元',
                           `department` varchar(64) DEFAULT '' COMMENT '机器所属部门',
                           `external_id` bigint NOT NULL DEFAULT '0' COMMENT '外部id',
                           `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                           `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                           `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                           `extend_field` varchar(4096) DEFAULT '' COMMENT '扩展字段，json格式',
                           PRIMARY KEY (`id`),
                           UNIQUE KEY `uniq_host_name` (`host_name`) COMMENT '主机名唯一索引',
                           KEY `idx_ip` (`ip`) USING BTREE COMMENT '主机 ip 索引',
                           KEY `idx_container` (`container`) USING BTREE COMMENT '主机类型索引',
                           KEY `idx_parent_host_name` (`parent_host_name`) USING BTREE COMMENT '宿主机名索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='主机表：表示一台主机，可表示物理机、虚拟机、容器';

-- ----------------------------
-- Table structure for tb_k8s_pod
-- ----------------------------
DROP TABLE IF EXISTS `tb_k8s_pod`;
CREATE TABLE `tb_k8s_pod` (
                              `id` bigint NOT NULL AUTO_INCREMENT,
                              `uuid` varchar(255) DEFAULT '' COMMENT ' pod 实例唯一键',
                              `name` varchar(255) DEFAULT '' COMMENT 'pod名称',
                              `namespace` varchar(255) DEFAULT '' COMMENT 'pod的namespace',
                              `pod_ip` varchar(255) DEFAULT '' COMMENT ' pod ip 地址',
                              `service_name` varchar(255) DEFAULT '' COMMENT ' pod 所属服务对应服务名',
                              `log_mount_path` varchar(255) DEFAULT '' COMMENT ' 容器内路径',
                              `log_host_path` varchar(255) DEFAULT '' COMMENT ' 主机对应真实路径',
                              `node_name` varchar(255) DEFAULT '' COMMENT 'pod 对应宿主机名',
                              `node_ip` varchar(255) DEFAULT '' COMMENT 'pod 对应宿主机 ip',
                              `container_names` varchar(2048) DEFAULT '' COMMENT ' pod 包含容器名集',
                              `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                              `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                              PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for tb_k8s_pod_host
-- ----------------------------
DROP TABLE IF EXISTS `tb_k8s_pod_host`;
CREATE TABLE `tb_k8s_pod_host` (
                                   `id` bigint NOT NULL AUTO_INCREMENT COMMENT ' 主键 id',
                                   `k8s_pod_id` bigint NOT NULL COMMENT ' 表 tb_k8s_pod 主键 id',
                                   `host_id` bigint NOT NULL COMMENT ' 表 tb_host 主键 id',
                                   PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

-- ----------------------------
-- Table structure for tb_kafka_cluster
-- ----------------------------
DROP TABLE IF EXISTS `tb_kafka_cluster`;
CREATE TABLE `tb_kafka_cluster` (
                                    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                    `kafka_cluster_name` varchar(128) NOT NULL DEFAULT '' COMMENT 'kafka 集群名',
                                    `kafka_cluster_broker_configuration` varchar(1024) NOT NULL DEFAULT '' COMMENT 'kafka 集群 broker 配置',
                                    `kafka_cluster_producer_init_configuration` varchar(4096) DEFAULT '' COMMENT 'kafka 集群对应生产端初始化配置',
                                    `kafka_cluster_id` bigint DEFAULT NULL COMMENT '外部kafka集群表id字段',
                                    `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                    `agent_metrics_send_topic` varchar(255) DEFAULT '' COMMENT 'Agent指标信息发往的topic名',
                                    `agent_error_logs_send_topic` varchar(255) DEFAULT '' COMMENT 'Agent错误日志信息发往的topic名',
                                    `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                    `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                    PRIMARY KEY (`id`) USING BTREE,
                                    UNIQUE KEY `unq_kafka_cluster_name` (`kafka_cluster_name`) USING BTREE,
                                    KEY `idx_kafka_cluster_id` (`kafka_cluster_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='Kafka集群信息表：表示一个 kafka 集群信息，KafkaCluster：LogCollectorTask 一对多关联关系';

-- ----------------------------
-- Table structure for tb_log_collect_task
-- ----------------------------
DROP TABLE IF EXISTS `tb_log_collect_task`;
CREATE TABLE `tb_log_collect_task` (
                                       `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                       `log_collect_task_name` varchar(255) NOT NULL DEFAULT '' COMMENT '采集任务名',
                                       `log_collect_task_remark` varchar(1024) DEFAULT '' COMMENT '采集任务备注',
                                       `log_collect_task_type` tinyint NOT NULL DEFAULT '0' COMMENT '采集任务类型 0：常规流式采集 1：按指定时间范围采集',
                                       `collect_start_time_business` bigint DEFAULT '0' COMMENT '采集任务对应采集开始业务时间\n\n注：针对 logCollectTaskType = 1 情况，该值必填；logCollectTaskType = 0 情况，该值不填',
                                       `collect_end_time_business` bigint DEFAULT '0' COMMENT '采集任务对应采集结束业务时间\n\n注：针对 logCollectTaskType = 1 情况，该值必填；logCollectTaskType = 0 情况，该值不填',
                                       `limit_priority` tinyint NOT NULL DEFAULT '0' COMMENT '采集任务限流保障优先级 0：高 1：中 2：低',
                                       `log_collect_task_status` tinyint NOT NULL DEFAULT '0' COMMENT '日志采集任务状态 0：暂停 1：运行 2：已完成（状态2仅针对 "按指定时间范围采集" 类型）',
                                       `send_topic` varchar(256) NOT NULL DEFAULT '' COMMENT '采集任务采集的日志需要发往的topic名',
                                       `kafka_cluster_id` bigint NOT NULL COMMENT '表tb_kafka_cluster主键',
                                       `host_filter_rule_logic_json_string` varchar(4096) NOT NULL COMMENT '主机过滤规则信息（存储 BaseHostFilterRuleLogic 某具体实现类的 json 化形式）',
                                       `advanced_configuration_json_string` varchar(4096) DEFAULT '' COMMENT '采集任务高级配置项集，为json形式字符串',
                                       `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                       `configuration_version` int NOT NULL DEFAULT '0' COMMENT '日志采集任务配置版本号',
                                       `old_data_filter_type` tinyint NOT NULL COMMENT '历史数据过滤 0：不过滤 1：从当前时间开始采集 2：从自定义时间开始采集，自定义时间取collectStartBusinessTime属性值',
                                       `log_collect_task_execute_timeout_ms` bigint DEFAULT NULL COMMENT '日志采集任务执行超时时间，注意：该字段仅在日志采集任务类型为类型"按指定时间范围采集"时才存在值',
                                       `log_content_filter_rule_logic_json_string` varchar(255) DEFAULT NULL COMMENT '日志内容过滤规则信息（存储 BaseLogContentFilterRuleLogic 某具体实现类的 json 化形式）',
                                       `log_collect_task_finish_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '日志采集任务执行完成时间\n注：仅日志采集任务为时间范围采集类型时',
                                       `kafka_producer_configuration` varchar(1024) DEFAULT '' COMMENT '日志采集任务对应kafka生产端属性',
                                       `log_content_slice_rule_logic_json_string` varchar(1024) NOT NULL DEFAULT '' COMMENT '日志内容切片规则信息（存储 BaseLogContentSliceRuleLogic 某具体实现类的 json 化形式）',
                                       `file_name_suffix_match_rule_logic_json_string` varchar(1024) NOT NULL DEFAULT '' COMMENT '待采集文件后缀匹配规则信息（存储 BaseCollectFileSuffixMatchRuleLogic 某具体实现类的 json 化形式）',
                                       `collect_delay_threshold_ms` bigint NOT NULL COMMENT '该路径的日志对应采集延迟监控阈值 单位：ms，该阈值表示：该采集路径对应到所有待采集主机上正在采集的业务时间最小值 ~ 当前时间间隔',
                                       `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                       `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                       PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='日志采集任务表：表示一个待运行在agent的采集任务';

-- ----------------------------
-- Table structure for tb_log_collect_task_health
-- ----------------------------
DROP TABLE IF EXISTS `tb_log_collect_task_health`;
CREATE TABLE `tb_log_collect_task_health` (
                                              `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                              `log_collect_task_id` bigint NOT NULL COMMENT '表tb_log_collect_task主键',
                                              `log_collect_task_health_level` tinyint NOT NULL DEFAULT '0' COMMENT '采集任务健康等级\n\n0：绿色 表示：采集任务很健康，对业务没有任何影响，且运行该采集任务的 Agent 也健康\n\n1：黄色 表示：采集任务存在风险，该采集任务有对应错误日志输出\n\n2：红色 表示：采集任务不健康，对业务有影响，该采集任务需要做采集延迟监控但乱序输出，或该采集任务需要做采集延迟监控但延迟时间超过指定阈值、该采集任务对应 kafka 集群信息不存在 待维护',
                                              `log_collect_task_health_description` varchar(1024) NOT NULL COMMENT '日志采集任务健康描述信息',
                                              `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                              `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                              `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                              PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='日志采集任务健康度信息表：表示一个日志采集任务健康度信息，LogCollectorTaskHealth：LogCollectorTask 一对一关联关系';

-- ----------------------------
-- Table structure for tb_log_collect_task_health_detail
-- ----------------------------
DROP TABLE IF EXISTS `tb_log_collect_task_health_detail`;
CREATE TABLE `tb_log_collect_task_health_detail` (
                                                     `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                                                     `log_collect_task_id` bigint DEFAULT NULL COMMENT '表tb_log_collect_task主键',
                                                     `path_id` bigint DEFAULT NULL COMMENT '表tb_file_log_collect_path主键',
                                                     `host_name` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '主机名',
                                                     `collect_dquality_time` bigint DEFAULT NULL COMMENT '完整性时间',
                                                     `too_large_truncate_check_healthy_heartbeat_time` bigint DEFAULT NULL COMMENT '“日志过长截断健康检查”为健康时的时间点',
                                                     `file_path_exists_check_healthy_heartbeat_time` bigint DEFAULT NULL COMMENT '“文件路径是否存在健康检查”为健康时的时间点',
                                                     `file_disorder_check_healthy_heartbeat_time` bigint DEFAULT NULL COMMENT '“文件乱序健康检查”为健康时的时间点',
                                                     `log_slice_check_healthy_heartbeat_time` bigint DEFAULT NULL COMMENT ' “日志切片健康检查”为健康时的时间点',
                                                     PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_log_collect_task_service
-- ----------------------------
DROP TABLE IF EXISTS `tb_log_collect_task_service`;
CREATE TABLE `tb_log_collect_task_service` (
                                               `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                               `log_collector_task_id` bigint NOT NULL COMMENT '表tb_log_collect_task 主键 id',
                                               `service_id` bigint NOT NULL COMMENT '表 tb_service 主键 id',
                                               PRIMARY KEY (`id`),
                                               KEY `idx_service_id` (`service_id`),
                                               KEY `idx_logcollecttask_id` (`log_collector_task_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='日志采集任务 & 服务关联关系表：表示服务 & 日志采集任务的关联关系，Service：LogCollectorTask 多对多关联关系';

-- ----------------------------
-- Table structure for tb_meta_table_version
-- ----------------------------
DROP TABLE IF EXISTS `tb_meta_table_version`;
CREATE TABLE `tb_meta_table_version` (
                                         `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                                         `table_name` varchar(255) NOT NULL DEFAULT '' COMMENT '表名',
                                         `table_version` bigint NOT NULL DEFAULT '1' COMMENT '表对应版本号，该变每一次变更，其版本号+1',
                                         `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                                         `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                                         `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                                         PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='表版本号信息表：表示一个表当前版本号信息（ps：该表发生变动操作，其对应版本号 +1）';

-- ----------------------------
-- Table structure for tb_metrics_agent
-- ----------------------------
DROP TABLE IF EXISTS `tb_metrics_agent`;
CREATE TABLE `tb_metrics_agent` (
                                    `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                                    `hostName` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'agent所在宿主机主机名',
                                    `limitTps` bigint DEFAULT '0' COMMENT '当前限流阈值 单位：byte',
                                    `cpuLimit` double DEFAULT '0' COMMENT 'cpu 限流阈值',
                                    `agentVersion` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'agent版本号',
                                    `readBytes` bigint DEFAULT NULL COMMENT '采样周期内入口采集流量 单位：bytes',
                                    `readCount` bigint DEFAULT NULL COMMENT '采样周期内入口采集条数 单位：条',
                                    `writeBytes` bigint DEFAULT NULL COMMENT '采样周期内出口采集流量 单位：bytes',
                                    `writeCount` bigint DEFAULT NULL COMMENT '采样周期内出口采集条数 单位：条',
                                    `errorLogsCount` bigint DEFAULT NULL COMMENT '采样周期内错误日志输出条数，当前值',
                                    `normalCollectThreadNumMax` int DEFAULT NULL COMMENT '流式采集线程池可容纳的最大线程数，当前值',
                                    `normalCollectThreadNumSize` int DEFAULT NULL COMMENT '流式采集线程池实际运行线程数，当前值',
                                    `normalCollectThreadQueueMax` int DEFAULT NULL COMMENT '流式采集线程池任务队列最大容量，当前值',
                                    `normalCollectThreadQueueSize` int DEFAULT NULL COMMENT '流式采集线程池任务队列实际数量，当前值',
                                    `temporaryCollectThreadNumMax` int DEFAULT NULL COMMENT '临时采集线程池可容纳的最大线程数，当前值',
                                    `temporaryCollectThreadNumSize` int DEFAULT NULL COMMENT '临时采集线程池实际运行线程数，当前值',
                                    `temporaryCollectThreadQueueMax` int DEFAULT NULL COMMENT '临时采集线程池任务队列最大容量，当前值',
                                    `temporaryCollectThreadQueueSize` int DEFAULT NULL COMMENT '临时采集线程池任务队列实际数量，当前值',
                                    `collectTaskNum` int DEFAULT NULL COMMENT '采集任务数，当前值',
                                    `runningCollectTaskNum` int DEFAULT NULL COMMENT '运行状态采集任务数，当前值',
                                    `pauseCollectTaskNum` int DEFAULT NULL COMMENT '停止状态采集任务数，当前值',
                                    `collectPathNum` int DEFAULT NULL COMMENT '采集路径数，当前值',
                                    `runningCollectPathNum` int DEFAULT NULL COMMENT '运行状态采集路径数，当前值',
                                    `pauseCollectPathNum` int DEFAULT NULL COMMENT '停止状态采集路径数，当前值',
                                    `heartbeatTime` bigint DEFAULT '0' COMMENT '心跳时间',
                                    `heartbeatTimeMinute` bigint DEFAULT '0' COMMENT '心跳时间 精度：分钟',
                                    `heartbeatTimeHour` bigint DEFAULT '0' COMMENT '心跳时间 精度：小时',
                                    PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_metrics_disk
-- ----------------------------
DROP TABLE IF EXISTS `tb_metrics_disk`;
CREATE TABLE `tb_metrics_disk` (
                                   `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                                   `hostName` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '主机名',
                                   `systemDiskPath` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '磁盘路径',
                                   `systemDiskDevice` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '磁盘设备名',
                                   `systemDiskFsType` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '磁盘文件系统类型',
                                   `systemDiskBytesTotal` bigint DEFAULT NULL COMMENT '磁盘总量（单位：byte）',
                                   `systemDiskBytesFree` bigint DEFAULT NULL COMMENT '磁盘余量大小（单位：byte）',
                                   `systemDiskBytesUsed` bigint DEFAULT NULL COMMENT '磁盘用量大小（单位：byte）',
                                   `systemDiskUsedPercent` double DEFAULT NULL COMMENT '磁盘用量占比（单位：%）',
                                   `systemDiskInodesTotal` int DEFAULT NULL COMMENT '各磁盘inode总数量',
                                   `systemDiskInodesFree` int DEFAULT NULL COMMENT '各磁盘空闲inode数量',
                                   `systemDiskInodesUsed` int DEFAULT NULL COMMENT '各磁盘已用inode数量',
                                   `systemDiskInodesUsedPercent` double DEFAULT NULL COMMENT '各磁盘已用inode占比（单位：%）',
                                   `systemIOAvgQuSz` double DEFAULT NULL COMMENT '磁盘平均队列长度 当前值',
                                   `systemIOAvgQuSzMin` double DEFAULT NULL COMMENT '磁盘平均队列长度 最小值',
                                   `systemIOAvgQuSzMax` double DEFAULT NULL COMMENT '磁盘平均队列长度 最大值',
                                   `systemIOAvgQuSzMean` double DEFAULT NULL COMMENT '磁盘平均队列长度 均值',
                                   `systemIOAvgQuSzStd` double DEFAULT NULL COMMENT '磁盘平均队列长度 标准差',
                                   `systemIOAvgQuSz55Quantile` double DEFAULT NULL COMMENT '磁盘平均队列长度 55 分位数',
                                   `systemIOAvgQuSz75Quantile` double DEFAULT NULL COMMENT '磁盘平均队列长度 75 分位数',
                                   `systemIOAvgQuSz95Quantile` double DEFAULT NULL COMMENT '磁盘平均队列长度 95 分位数',
                                   `systemIOAvgQuSz99Quantile` double DEFAULT NULL COMMENT '磁盘平均队列长度 99 分位数',
                                   `systemIOAvgRqSz` double DEFAULT NULL COMMENT '磁盘平均请求大小（单位：扇区）当前值',
                                   `systemIOAvgRqSzMin` double DEFAULT NULL COMMENT '磁盘平均请求大小（单位：扇区）最小值',
                                   `systemIOAvgRqSzMax` double DEFAULT NULL COMMENT '磁盘平均请求大小（单位：扇区）最小值',
                                   `systemIOAvgRqSzMean` double DEFAULT NULL COMMENT '磁盘平均请求大小（单位：扇区）均值',
                                   `systemIOAvgRqSzStd` double DEFAULT NULL COMMENT '磁盘平均请求大小 标准差',
                                   `systemIOAvgRqSz55Quantile` double DEFAULT NULL COMMENT '磁盘平均请求大小（单位：扇区）55分位数',
                                   `systemIOAvgRqSz75Quantile` double DEFAULT NULL COMMENT '磁盘平均请求大小（单位：扇区）75分位数',
                                   `systemIOAvgRqSz95Quantile` double DEFAULT NULL COMMENT '磁盘平均请求大小（单位：扇区）95分位数',
                                   `systemIOAvgRqSz99Quantile` double DEFAULT NULL COMMENT '磁盘平均请求大小（单位：扇区）99分位数',
                                   `systemIOAwait` bigint DEFAULT NULL COMMENT '磁盘每次IO请求平均处理时间（单位：ms）当前值',
                                   `systemIOAwaitMin` bigint DEFAULT NULL COMMENT '磁盘每次IO请求平均处理时间（单位：ms）最小值',
                                   `systemIOAwaitMax` bigint DEFAULT NULL COMMENT '磁盘每次IO请求平均处理时间（单位：ms）最大值',
                                   `systemIOAwaitMean` double DEFAULT NULL COMMENT '磁盘每次IO请求平均处理时间（单位：ms）均值',
                                   `systemIOAwaitStd` double DEFAULT NULL COMMENT '磁盘每次IO请求平均处理时间 标准差',
                                   `systemIOAwait55Quantile` bigint DEFAULT NULL COMMENT '磁盘每次IO请求平均处理时间（单位：ms）55分位数',
                                   `systemIOAwait75Quantile` bigint DEFAULT NULL COMMENT '磁盘每次IO请求平均处理时间（单位：ms）75分位数',
                                   `systemIOAwait95Quantile` bigint DEFAULT NULL COMMENT '磁盘每次IO请求平均处理时间（单位：ms）95分位数',
                                   `systemIOAwait99Quantile` bigint DEFAULT NULL COMMENT '磁盘每次IO请求平均处理时间（单位：ms）99分位数',
                                   `systemIORAwait` bigint DEFAULT NULL COMMENT '磁盘读请求平均耗时(单位：ms) 当前值',
                                   `systemIORAwaitMin` bigint DEFAULT NULL COMMENT '磁盘读请求平均耗时(单位：ms) 最小值',
                                   `systemIORAwaitMax` bigint DEFAULT NULL COMMENT '磁盘读请求平均耗时(单位：ms) 最大值',
                                   `systemIORAwaitMean` double DEFAULT NULL COMMENT '磁盘读请求平均耗时(单位：ms) 均值',
                                   `systemIORAwaitStd` double DEFAULT NULL COMMENT '磁盘读请求平均耗时 标准差',
                                   `systemIORAwait55Quantile` bigint DEFAULT NULL COMMENT '磁盘读请求平均耗时(单位：ms) 55分位数',
                                   `systemIORAwait75Quantile` bigint DEFAULT NULL COMMENT '磁盘读请求平均耗时(单位：ms) 75分位数',
                                   `systemIORAwait95Quantile` bigint DEFAULT NULL COMMENT '磁盘读请求平均耗时(单位：ms) 95分位数',
                                   `systemIORAwait99Quantile` bigint DEFAULT NULL COMMENT '磁盘读请求平均耗时(单位：ms) 99分位数',
                                   `systemIOReadRequest` bigint DEFAULT NULL COMMENT '磁盘每秒读请求数量 当前值',
                                   `systemIOReadRequestMin` bigint DEFAULT NULL COMMENT '磁盘每秒读请求数量 最小值',
                                   `systemIOReadRequestMax` bigint DEFAULT NULL COMMENT '磁盘每秒读请求数量 最大值',
                                   `systemIOReadRequestMean` double DEFAULT NULL COMMENT '磁盘每秒读请求数量 均值',
                                   `systemIOReadRequestStd` double DEFAULT NULL COMMENT '磁盘每秒读请求数量 标准差',
                                   `systemIOReadRequest55Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读请求数量 55分位数',
                                   `systemIOReadRequest75Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读请求数量 75分位数',
                                   `systemIOReadRequest95Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读请求数量 95分位数',
                                   `systemIOReadRequest99Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读请求数量 99分位数',
                                   `systemIOReadBytes` bigint DEFAULT NULL COMMENT '磁盘每秒读取字节数 当前值',
                                   `systemIOReadBytesMin` bigint DEFAULT NULL COMMENT '磁盘每秒读取字节数 最小值',
                                   `systemIOReadBytesMax` bigint DEFAULT NULL COMMENT '磁盘每秒读取字节数 最大值',
                                   `systemIOReadBytesMean` double DEFAULT NULL COMMENT '磁盘每秒读取字节数 均值',
                                   `systemIOReadBytesStd` double DEFAULT NULL COMMENT '磁盘每秒读取字节数 标准差',
                                   `systemIOReadBytes55Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读取字节数 55分位数',
                                   `systemIOReadBytes75Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读取字节数 75分位数',
                                   `systemIOReadBytes95Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读取字节数 95分位数',
                                   `systemIOReadBytes99Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读取字节数 99分位数',
                                   `systemIORRQMS` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的读请求数 当前值',
                                   `systemIORRQMSMin` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的读请求数 最小值',
                                   `systemIORRQMSMax` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的读请求数 最大值',
                                   `systemIORRQMSMean` double DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的读请求数 均值',
                                   `systemIORRQMSStd` double DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的读请求数 标准差',
                                   `systemIORRQMS55Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的读请求数 55分位数',
                                   `systemIORRQMS75Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的读请求数 75分位数',
                                   `systemIORRQMS95Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的读请求数 95分位数',
                                   `systemIORRQMS99Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的读请求数 99分位数',
                                   `systemIOSVCTM` bigint DEFAULT NULL COMMENT '磁盘每次IO平均服务时间（单位：ms） 当前值',
                                   `systemIOSVCTMMin` bigint DEFAULT NULL COMMENT '磁盘每次IO平均服务时间（单位：ms） 最小值',
                                   `systemIOSVCTMMax` bigint DEFAULT NULL COMMENT '磁盘每次IO平均服务时间（单位：ms） 最大值',
                                   `systemIOSVCTMMean` double DEFAULT NULL COMMENT '磁盘每次IO平均服务时间（单位：ms） 均值',
                                   `systemIOSVCTMStd` double DEFAULT NULL COMMENT '磁盘每次IO平均服务时间（单位：ms） 标准差',
                                   `systemIOSVCTM55Quantile` bigint DEFAULT NULL COMMENT '磁盘每次IO平均服务时间（单位：ms） 55分位数',
                                   `systemIOSVCTM75Quantile` bigint DEFAULT NULL COMMENT '磁盘每次IO平均服务时间（单位：ms） 75分位数',
                                   `systemIOSVCTM95Quantile` bigint DEFAULT NULL COMMENT '磁盘每次IO平均服务时间（单位：ms） 95分位数',
                                   `systemIOSVCTM99Quantile` bigint DEFAULT NULL COMMENT '磁盘每次IO平均服务时间（单位：ms） 99分位数',
                                   `systemIOUtil` double DEFAULT NULL COMMENT '磁盘I/O请求的时间百分比（单位：%） 当前值',
                                   `systemIOUtilMin` double DEFAULT NULL COMMENT '磁盘I/O请求的时间百分比（单位：%） 最小值',
                                   `systemIOUtilMax` double DEFAULT NULL COMMENT '磁盘I/O请求的时间百分比（单位：%） 最大值',
                                   `systemIOUtilMean` double DEFAULT NULL COMMENT '磁盘I/O请求的时间百分比（单位：%） 均值',
                                   `systemIOUtilStd` double DEFAULT NULL COMMENT '磁盘I/O请求的时间百分比（单位：%） 标准差',
                                   `systemIOUtil55Quantile` double DEFAULT NULL COMMENT '磁盘I/O请求的时间百分比（单位：%） 55分位数',
                                   `systemIOUtil75Quantile` double DEFAULT NULL COMMENT '磁盘I/O请求的时间百分比（单位：%） 75分位数',
                                   `systemIOUtil95Quantile` double DEFAULT NULL COMMENT '磁盘I/O请求的时间百分比（单位：%） 95分位数',
                                   `systemIOUtil99Quantile` double DEFAULT NULL COMMENT '磁盘I/O请求的时间百分比（单位：%） 99分位数',
                                   `systemIOWAwait` bigint DEFAULT NULL COMMENT '磁盘写请求平均耗时（单位：ms）当前值',
                                   `systemIOWAwaitMin` bigint DEFAULT NULL COMMENT '磁盘写请求平均耗时（单位：ms）最小值',
                                   `systemIOWAwaitMax` bigint DEFAULT NULL COMMENT '磁盘写请求平均耗时（单位：ms）最大值',
                                   `systemIOWAwaitMean` double DEFAULT NULL COMMENT '磁盘写请求平均耗时（单位：ms）均值',
                                   `systemIOWAwaitStd` double DEFAULT NULL COMMENT '磁盘写请求平均耗时 标准差',
                                   `systemIOWAwait55Quantile` bigint DEFAULT NULL COMMENT '磁盘写请求平均耗时（单位：ms）55分位数',
                                   `systemIOWAwait75Quantile` bigint DEFAULT NULL COMMENT '磁盘写请求平均耗时（单位：ms）75分位数',
                                   `systemIOWAwait95Quantile` bigint DEFAULT NULL COMMENT '磁盘写请求平均耗时（单位：ms）95分位数',
                                   `systemIOWAwait99Quantile` bigint DEFAULT NULL COMMENT '磁盘写请求平均耗时（单位：ms）99分位数',
                                   `systemIOWriteRequest` bigint DEFAULT NULL COMMENT '磁盘每秒写请求数量 当前值',
                                   `systemIOWriteRequestMin` bigint DEFAULT NULL COMMENT '磁盘每秒写请求数量 最小值',
                                   `systemIOWriteRequestMax` bigint DEFAULT NULL COMMENT '磁盘每秒写请求数量 最大值',
                                   `systemIOWriteRequestMean` double DEFAULT NULL COMMENT '磁盘每秒写请求数量 均值',
                                   `systemIOWriteRequestStd` double DEFAULT NULL COMMENT '磁盘每秒写请求数量 标准差',
                                   `systemIOWriteRequest55Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒写请求数量 55分位数',
                                   `systemIOWriteRequest75Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒写请求数量 75分位数',
                                   `systemIOWriteRequest95Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒写请求数量 95分位数',
                                   `systemIOWriteRequest99Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒写请求数量 99分位数',
                                   `systemIOWriteBytes` bigint DEFAULT NULL COMMENT '磁盘每秒写字节数 当前值',
                                   `systemIOWriteBytesMin` bigint DEFAULT NULL COMMENT '磁盘每秒写字节数 最小值',
                                   `systemIOWriteBytesMax` bigint DEFAULT NULL COMMENT '磁盘每秒写字节数 最大值',
                                   `systemIOWriteBytesMean` double DEFAULT NULL COMMENT '磁盘每秒写字节数 均值',
                                   `systemIOWriteBytesStd` double DEFAULT NULL COMMENT '磁盘每秒写字节数 标准差',
                                   `systemIOWriteBytes55Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒写字节数 55分位数',
                                   `systemIOWriteBytes75Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒写字节数 75分位数',
                                   `systemIOWriteBytes95Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒写字节数 95分位数',
                                   `systemIOWriteBytes99Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒写字节数 99分位数',
                                   `systemIOReadWriteBytes` bigint DEFAULT NULL COMMENT '磁盘每秒读、写字节数 当前值',
                                   `systemIOReadWriteBytesMin` bigint DEFAULT NULL COMMENT '磁盘每秒读、写字节数 最小值',
                                   `systemIOReadWriteBytesMax` bigint DEFAULT NULL COMMENT '磁盘每秒读、写字节数 最大值',
                                   `systemIOReadWriteBytesMean` double DEFAULT NULL COMMENT '磁盘每秒读、写字节数 均值',
                                   `systemIOReadWriteBytesStd` double DEFAULT NULL COMMENT '磁盘每秒读、写字节数 标准差',
                                   `systemIOReadWriteBytes55Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读、写字节数 55分位数',
                                   `systemIOReadWriteBytes75Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读、写字节数 75分位数',
                                   `systemIOReadWriteBytes95Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读、写字节数 95分位数',
                                   `systemIOReadWriteBytes99Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒读、写字节数 99分位数',
                                   `systemIOWRQMS` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的写请求数 当前值',
                                   `systemIOWRQMSMin` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的写请求数 最小值',
                                   `systemIOWRQMSMax` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的写请求数 最大值',
                                   `systemIOWRQMSMean` double DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的写请求数 均值',
                                   `systemIOWRQMSStd` double DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的写请求数 标准差',
                                   `systemIOWRQMS55Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的写请求数 55分位数',
                                   `systemIOWRQMS75Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的写请求数 75分位数',
                                   `systemIOWRQMS95Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的写请求数 95分位数',
                                   `systemIOWRQMS99Quantile` bigint DEFAULT NULL COMMENT '磁盘每秒合并到设备队列的写请求数 99分位数',
                                   `systemDiskReadTime` bigint DEFAULT NULL COMMENT '磁盘读操作耗时(单位：ms) 当前值',
                                   `systemDiskReadTimeMin` bigint DEFAULT NULL COMMENT '磁盘读操作耗时(单位：ms) 最小值',
                                   `systemDiskReadTimeMax` bigint DEFAULT NULL COMMENT '磁盘读操作耗时(单位：ms) 最大值',
                                   `systemDiskReadTimeMean` double DEFAULT NULL COMMENT '磁盘读操作耗时(单位：ms) 均值',
                                   `systemDiskReadTimeStd` double DEFAULT NULL COMMENT '磁盘读操作耗时 标准差',
                                   `systemDiskReadTime55Quantile` bigint DEFAULT NULL COMMENT '磁盘读操作耗时(单位：ms) 55分位数',
                                   `systemDiskReadTime75Quantile` bigint DEFAULT NULL COMMENT '磁盘读操作耗时(单位：ms) 75分位数',
                                   `systemDiskReadTime95Quantile` bigint DEFAULT NULL COMMENT '磁盘读操作耗时(单位：ms) 95分位数',
                                   `systemDiskReadTime99Quantile` bigint DEFAULT NULL COMMENT '磁盘读操作耗时(单位：ms) 99分位数',
                                   `systemDiskReadTimePercent` double DEFAULT NULL COMMENT '各磁盘读取磁盘时间百分比（单位：%）当前值',
                                   `systemDiskReadTimePercentMin` double DEFAULT NULL COMMENT '各磁盘读取磁盘时间百分比（单位：%）最小值',
                                   `systemDiskReadTimePercentMax` double DEFAULT NULL COMMENT '各磁盘读取磁盘时间百分比（单位：%）最大值',
                                   `systemDiskReadTimePercentMean` double DEFAULT NULL COMMENT '各磁盘读取磁盘时间百分比（单位：%）均值',
                                   `systemDiskReadTimePercentStd` double DEFAULT NULL COMMENT '各磁盘读取磁盘时间百分比 标准差',
                                   `systemDiskReadTimePercent55Quantile` double DEFAULT NULL COMMENT '各磁盘读取磁盘时间百分比（单位：%）55分位数',
                                   `systemDiskReadTimePercent75Quantile` double DEFAULT NULL COMMENT '各磁盘读取磁盘时间百分比（单位：%）75分位数',
                                   `systemDiskReadTimePercent95Quantile` double DEFAULT NULL COMMENT '各磁盘读取磁盘时间百分比（单位：%）95分位数',
                                   `systemDiskReadTimePercent99Quantile` double DEFAULT NULL COMMENT '各磁盘读取磁盘时间百分比（单位：%）99分位数',
                                   `systemDiskWriteTime` bigint DEFAULT NULL COMMENT '各磁盘写操作耗时（单位：ms）当前值',
                                   `systemDiskWriteTimeMin` bigint DEFAULT NULL COMMENT '各磁盘写操作耗时（单位：ms）最小值',
                                   `systemDiskWriteTimeMax` bigint DEFAULT NULL COMMENT '各磁盘写操作耗时（单位：ms）最大值',
                                   `systemDiskWriteTimeMean` double DEFAULT NULL COMMENT '各磁盘写操作耗时（单位：ms）均值',
                                   `systemDiskWriteTimeStd` double DEFAULT NULL COMMENT '各磁盘写操作耗时 标准差',
                                   `systemDiskWriteTime55Quantile` bigint DEFAULT NULL COMMENT '各磁盘写操作耗时（单位：ms）55分位数',
                                   `systemDiskWriteTime75Quantile` bigint DEFAULT NULL COMMENT '各磁盘写操作耗时（单位：ms）75分位数',
                                   `systemDiskWriteTime95Quantile` bigint DEFAULT NULL COMMENT '各磁盘写操作耗时（单位：ms）95分位数',
                                   `systemDiskWriteTime99Quantile` bigint DEFAULT NULL COMMENT '各磁盘写操作耗时（单位：ms）99分位数',
                                   `systemDiskWriteTimePercent` double DEFAULT NULL COMMENT '磁盘写入磁盘时间百分比（单位：%）当前值',
                                   `systemDiskWriteTimePercentMin` double DEFAULT NULL COMMENT '磁盘写入磁盘时间百分比（单位：%）最小值',
                                   `systemDiskWriteTimePercentMax` double DEFAULT NULL COMMENT '磁盘写入磁盘时间百分比（单位：%）最大值',
                                   `systemDiskWriteTimePercentMean` double DEFAULT NULL COMMENT '磁盘写入磁盘时间百分比（单位：%）均值',
                                   `systemDiskWriteTimePercentStd` double DEFAULT NULL COMMENT '磁盘写入磁盘时间百分比 标准差',
                                   `systemDiskWriteTimePercent55Quantile` double DEFAULT NULL COMMENT '磁盘写入磁盘时间百分比（单位：%）55分位数',
                                   `systemDiskWriteTimePercent75Quantile` double DEFAULT NULL COMMENT '磁盘写入磁盘时间百分比（单位：%）75分位数',
                                   `systemDiskWriteTimePercent95Quantile` double DEFAULT NULL COMMENT '磁盘写入磁盘时间百分比（单位：%）95分位数',
                                   `systemDiskWriteTimePercent99Quantile` double DEFAULT NULL COMMENT '磁盘写入磁盘时间百分比（单位：%）99分位数',
                                   `heartbeatTime` bigint DEFAULT '0' COMMENT '心跳时间',
                                   `heartbeatTimeMinute` bigint DEFAULT '0' COMMENT '心跳时间 精度：分钟',
                                   `heartbeatTimeHour` bigint DEFAULT '0' COMMENT '心跳时间 精度：小时',
                                   PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_metrics_log_collect_task
-- ----------------------------
DROP TABLE IF EXISTS `tb_metrics_log_collect_task`;
CREATE TABLE `tb_metrics_log_collect_task` (
                                               `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                                               `collectTaskId` bigint DEFAULT NULL COMMENT '采集任务id',
                                               `pathId` bigint DEFAULT NULL COMMENT '采集路径id',
                                               `agentHostName` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'agent所在主机对应主机名',
                                               `collectTaskHostName` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '采集任务对应的主机名',
                                               `agentHostIp` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'agent所在主机 ip',
                                               `businessTimestamp` bigint DEFAULT NULL COMMENT '采集业务时间 当前值',
                                               `maxBusinessTimestampDelay` bigint DEFAULT NULL COMMENT '数据业务时间最大延迟 （单位：秒），当前值',
                                               `limitTime` bigint DEFAULT NULL COMMENT '采样周期内限流时长 （单位：秒），当前值',
                                               `tooLargeTruncateNum` bigint DEFAULT NULL COMMENT '采样周期内数据过长导致的截断条数（单位：条），当前值',
                                               `tooLargeTruncateNumTotal` bigint DEFAULT NULL COMMENT 'agent启动以来数据过长导致的截断条数（单位：条），当前值',
                                               `collectPathIsExists` tinyint DEFAULT NULL COMMENT '采样周期内采样周期内采集路径是否存在，当前值',
                                               `disorderExists` tinyint DEFAULT NULL COMMENT '采样周期内待采集数据是否存在乱序打印，当前值',
                                               `sliceErrorExists` tinyint DEFAULT NULL COMMENT '采样周期内是否存在时间戳切片配置错误，当前值',
                                               `readBytes` bigint DEFAULT NULL COMMENT '采样周期内日志读取字节数，当前值',
                                               `readCount` bigint DEFAULT NULL COMMENT '采样周期内日志读取条数，当前值',
                                               `sendBytes` bigint DEFAULT NULL COMMENT '采样周期内日志发送字节数，当前值',
                                               `sendCount` bigint DEFAULT NULL COMMENT '采样周期内日志发送条数，当前值',
                                               `readTimePerEvent` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 读取耗时 (单位：纳秒) 当前值',
                                               `readTimePerEventMin` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 读取耗时 (单位：纳秒) 最小值',
                                               `readTimePerEventMax` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 读取耗时 (单位：纳秒) 最大值',
                                               `readTimePerEventMean` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 读取耗时 (单位：纳秒) 均值',
                                               `readTimePerEventStd` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 读取耗时 标准差',
                                               `readTimePerEvent55Quantile` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 读取耗时 (单位：纳秒) 55分位数',
                                               `readTimePerEvent75Quantile` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 读取耗时 (单位：纳秒) 75分位数',
                                               `readTimePerEvent95Quantile` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 读取耗时 (单位：纳秒) 95分位数',
                                               `readTimePerEvent99Quantile` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 读取耗时 (单位：纳秒) 99分位数',
                                               `sendTime` bigint DEFAULT NULL COMMENT '采样周期内日志发送耗时 （单位：微秒）当前值',
                                               `sendTimeMin` bigint DEFAULT NULL COMMENT '采样周期内日志发送耗时 （单位：微秒）最小值',
                                               `sendTimeMax` bigint DEFAULT NULL COMMENT '采样周期内日志发送耗时 （单位：微秒）最大值',
                                               `sendTimeMean` bigint DEFAULT NULL COMMENT '采样周期内日志发送耗时 （单位：微秒）均值',
                                               `sendTimeStd` bigint DEFAULT NULL COMMENT '采样周期内日志发送耗时 标准差',
                                               `sendTime55Quantile` bigint DEFAULT NULL COMMENT '采样周期内日志发送耗时 （单位：微秒）55分位数',
                                               `sendTime75Quantile` bigint DEFAULT NULL COMMENT '采样周期内日志发送耗时 （单位：微秒）75分位数',
                                               `sendTime95Quantile` bigint DEFAULT NULL COMMENT '采样周期内日志发送耗时 （单位：微秒）95分位数',
                                               `sendTime99Quantile` bigint DEFAULT NULL COMMENT '采样周期内日志发送耗时 （单位：微秒）99分位数',
                                               `flushTime` bigint DEFAULT NULL COMMENT '采样周期内 flush 耗时 当前值',
                                               `flushTimeMin` bigint DEFAULT NULL COMMENT '采样周期内 flush 耗时 最小值',
                                               `flushTimeMax` bigint DEFAULT NULL COMMENT '采样周期内 flush 耗时 最大值',
                                               `flushTimeMean` bigint DEFAULT NULL COMMENT '采样周期内 flush 耗时 均值',
                                               `flushTimeStd` bigint DEFAULT NULL COMMENT '采样周期内 flush 耗时 标准差',
                                               `flushTime55Quantile` bigint DEFAULT NULL COMMENT '采样周期内 flush 耗时 55分位数',
                                               `flushTime75Quantile` bigint DEFAULT NULL COMMENT '采样周期内 flush 耗时 75分位数',
                                               `flushTime95Quantile` bigint DEFAULT NULL COMMENT '采样周期内 flush 耗时 95分位数',
                                               `flushTime99Quantile` bigint DEFAULT NULL COMMENT '采样周期内 flush 耗时 99分位数',
                                               `processTimePerEvent` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 处理耗时（单位：纳秒） 当前值',
                                               `processTimePerEventMin` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 处理耗时（单位：纳秒） 最小值',
                                               `processTimePerEventMax` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 处理耗时（单位：纳秒） 最大值',
                                               `processTimePerEventMean` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 处理耗时（单位：纳秒） 均值',
                                               `processTimePerEventStd` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 处理耗时（单位：纳秒） 标准差',
                                               `processTimePerEvent55Quantile` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 处理耗时（单位：纳秒） 55分位数',
                                               `processTimePerEvent75Quantile` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 处理耗时（单位：纳秒） 75分位数',
                                               `processTimePerEvent95Quantile` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 处理耗时（单位：纳秒） 95分位数',
                                               `processTimePerEvent99Quantile` bigint DEFAULT NULL COMMENT '采样周期内单 logevent 处理耗时（单位：纳秒） 99分位数',
                                               `flushTimes` bigint DEFAULT NULL COMMENT '采样周期内 flush 次数 当前值',
                                               `flushFailedTimes` bigint DEFAULT NULL COMMENT '采样周期内 flush 失败次数 当前值',
                                               `filterEventsNum` bigint DEFAULT NULL COMMENT '采样周期内数据过滤条数 当前值',
                                               `channelBytesMax` bigint DEFAULT NULL COMMENT 'channel 最大容量 单位：bytes 当前值',
                                               `channelCountMax` bigint DEFAULT NULL COMMENT 'channel 最大容量 单位：条 当前值',
                                               `channelBytesSize` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：bytes 当前值',
                                               `channelBytesSizeMin` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：bytes 最小值',
                                               `channelBytesSizeMax` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：bytes 最大值',
                                               `channelBytesSizeMean` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：bytes 均值',
                                               `channelBytesSizeStd` bigint DEFAULT NULL COMMENT 'channel 实际大小 标准差',
                                               `channelBytesSize55Quantile` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：bytes 55分位数',
                                               `channelBytesSize75Quantile` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：bytes 75分位数',
                                               `channelBytesSize95Quantile` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：bytes 95分位数',
                                               `channelBytesSize99Quantile` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：bytes 99分位数',
                                               `channelCountSize` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：条 当前值',
                                               `channelCountSizeMin` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：条 最小值',
                                               `channelCountSizeMax` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：条 最大值',
                                               `channelCountSizeMean` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：条 均值',
                                               `channelCountSizeStd` bigint DEFAULT NULL COMMENT 'channel 实际大小 标准差',
                                               `channelCountSize55Quantile` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：条 55分位数',
                                               `channelCountSize75Quantile` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：条 75分位数',
                                               `channelCountSize95Quantile` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：条 95分位数',
                                               `channelCountSize99Quantile` bigint DEFAULT NULL COMMENT 'channel 实际大小 单位：条 99分位数',
                                               `channelUsedPercent` double(255,0) DEFAULT NULL COMMENT 'channel 使用率 = max(channelBytesSize/maxChannelBytes, channelCountSize/maxChannelCount)当前值',
  `channelUsedPercentMin` double(255,0) DEFAULT NULL COMMENT 'channel 使用率 = max(channelBytesSize/maxChannelBytes, channelCountSize/maxChannelCount)最小值',
  `channelUsedPercentMax` double(255,0) DEFAULT NULL COMMENT 'channel 使用率 = max(channelBytesSize/maxChannelBytes, channelCountSize/maxChannelCount)最大值',
  `channelUsedPercentMean` double(255,0) DEFAULT NULL COMMENT 'channel 使用率 = max(channelBytesSize/maxChannelBytes, channelCountSize/maxChannelCount)均值',
  `channelUsedPercentStd` double(255,0) DEFAULT NULL COMMENT 'channel 使用率 = max(channelBytesSize/maxChannelBytes, channelCountSize/maxChannelCount)标准差',
  `channelUsedPercent55Quantile` double(255,0) DEFAULT NULL COMMENT 'channel 使用率 = max(channelBytesSize/maxChannelBytes, channelCountSize/maxChannelCount)55分位数',
  `channelUsedPercent75Quantile` double(255,0) DEFAULT NULL COMMENT 'channel 使用率 = max(channelBytesSize/maxChannelBytes, channelCountSize/maxChannelCount)75分位数',
  `channelUsedPercent95Quantile` double(255,0) DEFAULT NULL COMMENT 'channel 使用率 = max(channelBytesSize/maxChannelBytes, channelCountSize/maxChannelCount)95分位数',
  `channelUsedPercent99Quantile` double(255,0) DEFAULT NULL COMMENT 'channel 使用率 = max(channelBytesSize/maxChannelBytes, channelCountSize/maxChannelCount)99分位数',
  `receiverClusterId` bigint DEFAULT NULL COMMENT '数据流接收端集群 id',
  `receiverClusterTopic` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '数据流接收端 topic',
  `collectFiles` varchar(4096) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '采集的文件信息',
  `relatedFiles` int DEFAULT '0' COMMENT '符合采集规则的待采集文件组文件数',
  `latestFile` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '待采集文件组最后一个待采集文件名',
  `masterFile` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '待采集文件组主文件名',
  `path` varchar(256) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT '' COMMENT '待采集文件组主文件路径',
  `collectTaskType` int DEFAULT NULL COMMENT '采集任务类型',
  `sinkNum` int DEFAULT '0' COMMENT '采集任务对应sink数',
  `collectTaskVersion` int DEFAULT NULL COMMENT '采集任务版本号',
  `dynamicLimiterThreshold` bigint DEFAULT NULL COMMENT '采集任务动态限流阈值 单位：byte',
  `heartbeatTime` bigint DEFAULT '0' COMMENT '心跳时间',
  `heartbeatTimeMinute` bigint DEFAULT '0' COMMENT '心跳时间 精度：分钟',
  `heartbeatTimeHour` bigint DEFAULT '0' COMMENT '心跳时间 精度：小时',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_metrics_net_card
-- ----------------------------
DROP TABLE IF EXISTS `tb_metrics_net_card`;
CREATE TABLE `tb_metrics_net_card` (
                                       `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                                       `hostName` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '主机名',
                                       `systemNetCardsBandMacAddress` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '网卡mac地址',
                                       `systemNetCardsBandDevice` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '网卡设备名',
                                       `systemNetCardsBandWidth` bigint DEFAULT NULL COMMENT '网卡最大带宽 单位：byte',
                                       `systemNetCardsReceiveBytesPs` bigint DEFAULT NULL COMMENT '网卡网络每秒下行流量 单位：byte 当前值',
                                       `systemNetCardsReceiveBytesPsMin` bigint DEFAULT NULL COMMENT '网卡网络每秒下行流量 单位：byte 最小值',
                                       `systemNetCardsReceiveBytesPsMax` bigint DEFAULT NULL COMMENT '网卡网络每秒下行流量 单位：byte 最大值',
                                       `systemNetCardsReceiveBytesPsMean` double DEFAULT NULL COMMENT '网卡网络每秒下行流量 单位：byte 均值',
                                       `systemNetCardsReceiveBytesPsStd` double DEFAULT NULL COMMENT '网卡网络每秒下行流量 标准差',
                                       `systemNetCardsReceiveBytesPs55Quantile` bigint DEFAULT NULL COMMENT '网卡网络每秒下行流量 单位：byte 最小值',
                                       `systemNetCardsReceiveBytesPs75Quantile` bigint DEFAULT NULL COMMENT '网卡网络每秒下行流量 单位：byte 最小值',
                                       `systemNetCardsReceiveBytesPs95Quantile` bigint DEFAULT NULL COMMENT '网卡网络每秒下行流量 单位：byte 最小值',
                                       `systemNetCardsReceiveBytesPs99Quantile` bigint DEFAULT NULL COMMENT '网卡网络每秒下行流量 单位：byte 最小值',
                                       `systemNetCardsSendBytesPs` bigint DEFAULT NULL COMMENT '网卡网络每秒上行流量 单位：byte 当前值',
                                       `systemNetCardsSendBytesPsMin` bigint DEFAULT NULL COMMENT '网卡网络每秒上行流量 单位：byte 最小值',
                                       `systemNetCardsSendBytesPsMax` bigint DEFAULT NULL COMMENT '网卡网络每秒上行流量 单位：byte 最大值',
                                       `systemNetCardsSendBytesPsMean` double DEFAULT NULL COMMENT '网卡网络每秒上行流量 单位：byte 均值',
                                       `systemNetCardsSendBytesPsStd` double DEFAULT NULL COMMENT '网卡网络每秒上行流量 标准差',
                                       `systemNetCardsSendBytesPs55Quantile` bigint DEFAULT NULL COMMENT '网卡网络每秒上行流量 单位：byte 最小值',
                                       `systemNetCardsSendBytesPs75Quantile` bigint DEFAULT NULL COMMENT '网卡网络每秒上行流量 单位：byte 最小值',
                                       `systemNetCardsSendBytesPs95Quantile` bigint DEFAULT NULL COMMENT '网卡网络每秒上行流量 单位：byte 最小值',
                                       `systemNetCardsSendBytesPs99Quantile` bigint DEFAULT NULL COMMENT '网卡网络每秒上行流量 单位：byte 最小值',
                                       `heartbeatTime` bigint DEFAULT '0' COMMENT '心跳时间',
                                       `heartbeatTimeMinute` bigint DEFAULT '0' COMMENT '心跳时间 精度：分钟',
                                       `heartbeatTimeHour` bigint DEFAULT '0' COMMENT '心跳时间 精度：小时',
                                       PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_metrics_process
-- ----------------------------
DROP TABLE IF EXISTS `tb_metrics_process`;
CREATE TABLE `tb_metrics_process` (
                                      `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                                      `hostName` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '主机名',
                                      `procStartupTime` bigint DEFAULT NULL COMMENT '当前进程启动时间 当前值',
                                      `procUptime` bigint DEFAULT NULL COMMENT '当前进程运行时间 当前值',
                                      `procPid` bigint DEFAULT NULL COMMENT '当前进程 pid 当前值',
                                      `procCpuUtil` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率采用全核方式计数，如进程使用一颗核，则返回100，如进程使用两颗核，则返回200 当前值',
                                      `procCpuUtilMin` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率采用全核方式计数，如进程使用一颗核，则返回100，如进程使用两颗核，则返回200 最小值',
                                      `procCpuUtilMax` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率采用全核方式计数，如进程使用一颗核，则返回100，如进程使用两颗核，则返回200 最大值',
                                      `procCpuUtilMean` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率采用全核方式计数，如进程使用一颗核，则返回100，如进程使用两颗核，则返回200 均值',
                                      `procCpuUtilStd` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率采用全核方式计数 标准差',
                                      `procCpuUtil55Quantile` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率采用全核方式计数，如进程使用一颗核，则返回100，如进程使用两颗核，则返回200 55分位数',
                                      `procCpuUtil75Quantile` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率采用全核方式计数，如进程使用一颗核，则返回100，如进程使用两颗核，则返回200 75分位数',
                                      `procCpuUtil95Quantile` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率采用全核方式计数，如进程使用一颗核，则返回100，如进程使用两颗核，则返回200 95分位数',
                                      `procCpuUtil99Quantile` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率采用全核方式计数，如进程使用一颗核，则返回100，如进程使用两颗核，则返回200 99分位数',
                                      `procCpuUtilTotalPercent` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率为总使用比率，如进程使用一颗核，系统共10核，则返回0.1 = 10% 当前值',
                                      `procCpuUtilTotalPercentMin` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率为总使用比率，如进程使用一颗核，系统共10核，则返回0.1 = 10% 最小值',
                                      `procCpuUtilTotalPercentMax` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率为总使用比率，如进程使用一颗核，系统共10核，则返回0.1 = 10% 最大值',
                                      `procCpuUtilTotalPercentMean` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率为总使用比率，如进程使用一颗核，系统共10核，则返回0.1 = 10% 均值',
                                      `procCpuUtilTotalPercentStd` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率为总使用比率 标准差',
                                      `procCpuUtilTotalPercent55Quantile` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率为总使用比率，如进程使用一颗核，系统共10核，则返回0.1 = 10% 55分位数',
                                      `procCpuUtilTotalPercent75Quantile` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率为总使用比率，如进程使用一颗核，系统共10核，则返回0.1 = 10% 75分位数',
                                      `procCpuUtilTotalPercent95Quantile` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率为总使用比率，如进程使用一颗核，系统共10核，则返回0.1 = 10% 95分位数',
                                      `procCpuUtilTotalPercent99Quantile` double DEFAULT NULL COMMENT '当前进程cpu使用率(单位：%) 使用率为总使用比率，如进程使用一颗核，系统共10核，则返回0.1 = 10% 99分位数',
                                      `procCpuSys` double DEFAULT NULL COMMENT '当前进程系统态cpu使用率(单位：%) 当前值',
                                      `procCpuSysMin` double DEFAULT NULL COMMENT '当前进程系统态cpu使用率(单位：%) 最小值',
                                      `procCpuSysMax` double DEFAULT NULL COMMENT '当前进程系统态cpu使用率(单位：%) 最大值',
                                      `procCpuSysMean` double DEFAULT NULL COMMENT '当前进程系统态cpu使用率(单位：%) 均值',
                                      `procCpuSysStd` double DEFAULT NULL COMMENT '当前进程系统态cpu使用率 标准差',
                                      `procCpuSys55Quantile` double DEFAULT NULL COMMENT '当前进程系统态cpu使用率(单位：%) 55分位数',
                                      `procCpuSys75Quantile` double DEFAULT NULL COMMENT '当前进程系统态cpu使用率(单位：%) 75分位数',
                                      `procCpuSys95Quantile` double DEFAULT NULL COMMENT '当前进程系统态cpu使用率(单位：%) 95分位数',
                                      `procCpuSys99Quantile` double DEFAULT NULL COMMENT '当前进程系统态cpu使用率(单位：%) 99分位数',
                                      `procCpuUser` double DEFAULT NULL COMMENT '当前进程用户态cpu使用率(单位：%) 当前值',
                                      `procCpuUserMin` double DEFAULT NULL COMMENT '当前进程用户态cpu使用率(单位：%) 最小值',
                                      `procCpuUserMax` double DEFAULT NULL COMMENT '当前进程用户态cpu使用率(单位：%) 最大值',
                                      `procCpuUserMean` double DEFAULT NULL COMMENT '当前进程用户态cpu使用率(单位：%) 均值',
                                      `procCpuUserStd` double DEFAULT NULL COMMENT '当前进程用户态cpu使用率 标准差',
                                      `procCpuUser55Quantile` double DEFAULT NULL COMMENT '当前进程用户态cpu使用率(单位：%) 55分位数',
                                      `procCpuUser75Quantile` double DEFAULT NULL COMMENT '当前进程用户态cpu使用率(单位：%) 75分位数',
                                      `procCpuUser95Quantile` double DEFAULT NULL COMMENT '当前进程用户态cpu使用率(单位：%) 95分位数',
                                      `procCpuUser99Quantile` double DEFAULT NULL COMMENT '当前进程用户态cpu使用率(单位：%) 99分位数',
                                      `procCpuSwitchesPS` bigint DEFAULT NULL COMMENT '当前进程cpu每秒上下文交换次数 当前值',
                                      `procCpuSwitchesPSMin` bigint DEFAULT NULL COMMENT '当前进程cpu每秒上下文交换次数 最小值',
                                      `procCpuSwitchesPSMax` bigint DEFAULT NULL COMMENT '当前进程cpu每秒上下文交换次数 最大值',
                                      `procCpuSwitchesPSMean` double DEFAULT NULL COMMENT '当前进程cpu每秒上下文交换次数 均值',
                                      `procCpuSwitchesPSStd` double DEFAULT NULL COMMENT '当前进程cpu每秒上下文交换次数 标准差',
                                      `procCpuSwitchesPS55Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒上下文交换次数 55分位数',
                                      `procCpuSwitchesPS75Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒上下文交换次数 75分位数',
                                      `procCpuSwitchesPS95Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒上下文交换次数 95分位数',
                                      `procCpuSwitchesPS99Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒上下文交换次数 99分位数',
                                      `procCpuVoluntarySwitchesPS` bigint DEFAULT NULL COMMENT '当前进程cpu每秒自愿上下文交换次数（自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、内存等系统资源不足时，就会发生自愿上下文切换 pidstat） 当前值',
                                      `procCpuVoluntarySwitchesPSMin` bigint DEFAULT NULL COMMENT '当前进程cpu每秒自愿上下文交换次数（自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、内存等系统资源不足时，就会发生自愿上下文切换 pidstat） 最小值',
                                      `procCpuVoluntarySwitchesPSMax` bigint DEFAULT NULL COMMENT '当前进程cpu每秒自愿上下文交换次数（自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、内存等系统资源不足时，就会发生自愿上下文切换 pidstat） 最大值',
                                      `procCpuVoluntarySwitchesPSMean` double DEFAULT NULL COMMENT '当前进程cpu每秒自愿上下文交换次数（自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、内存等系统资源不足时，就会发生自愿上下文切换 pidstat） 均值',
                                      `procCpuVoluntarySwitchesPSStd` double DEFAULT NULL COMMENT '当前进程cpu每秒自愿上下文交换次数（自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、内存等系统资源不足时，就会发生自愿上下文切换 pidstat）标准差',
                                      `procCpuVoluntarySwitchesPS55Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒自愿上下文交换次数（自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、内存等系统资源不足时，就会发生自愿上下文切换 pidstat）55分位数',
                                      `procCpuVoluntarySwitchesPS75Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒自愿上下文交换次数（自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、内存等系统资源不足时，就会发生自愿上下文切换 pidstat）75分位数',
                                      `procCpuVoluntarySwitchesPS95Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒自愿上下文交换次数（自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、内存等系统资源不足时，就会发生自愿上下文切换 pidstat）95分位数',
                                      `procCpuVoluntarySwitchesPS99Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒自愿上下文交换次数（自愿上下文切换，是指进程无法获取所需资源，导致的上下文切换。比如说， I/O、内存等系统资源不足时，就会发生自愿上下文切换 pidstat）99分位数',
                                      `procCpuNonVoluntarySwitchesPS` bigint DEFAULT NULL COMMENT '当前进程cpu每秒非自愿上下文交换次数（非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换 pidstat）当前值',
                                      `procCpuNonVoluntarySwitchesPSMin` bigint DEFAULT NULL COMMENT '当前进程cpu每秒非自愿上下文交换次数（非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换 pidstat）最小值',
                                      `procCpuNonVoluntarySwitchesPSMax` bigint DEFAULT NULL COMMENT '当前进程cpu每秒非自愿上下文交换次数（非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换 pidstat）最大值',
                                      `procCpuNonVoluntarySwitchesPSMean` double DEFAULT NULL COMMENT '当前进程cpu每秒非自愿上下文交换次数（非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换 pidstat）均值',
                                      `procCpuNonVoluntarySwitchesPSStd` double DEFAULT NULL COMMENT '当前进程cpu每秒非自愿上下文交换次数（非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换 pidstat）标准差',
                                      `procCpuNonVoluntarySwitchesPS55Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒非自愿上下文交换次数（非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换 pidstat）55分位数',
                                      `procCpuNonVoluntarySwitchesPS75Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒非自愿上下文交换次数（非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换 pidstat）75分位数',
                                      `procCpuNonVoluntarySwitchesPS95Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒非自愿上下文交换次数（非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换 pidstat）95分位数',
                                      `procCpuNonVoluntarySwitchesPS99Quantile` bigint DEFAULT NULL COMMENT '当前进程cpu每秒非自愿上下文交换次数（非自愿上下文切换，则是指进程由于时间片已到等原因，被系统强制调度，进而发生的上下文切换。比如说，大量进程都在争抢 CPU 时，就容易发生非自愿上下文切换 pidstat）99分位数',
                                      `procMemUsed` bigint DEFAULT NULL COMMENT '当前进程内存使用量（单位：byte）当前值',
                                      `procMemUtil` double DEFAULT NULL COMMENT '当前进程内存使用率(单位：%) 当前值',
                                      `procMemData` bigint DEFAULT NULL COMMENT '当前进程data内存大小 当前值',
                                      `procMemDirty` bigint DEFAULT NULL COMMENT '当前进程dirty内存大小 当前值',
                                      `procMemLib` bigint DEFAULT NULL COMMENT '当前进程lib内存大小 当前值',
                                      `procMemRss` bigint DEFAULT NULL COMMENT '当前进程常驻内存大小 当前值',
                                      `procMemShared` bigint DEFAULT NULL COMMENT '当前进程共享内存大小 当前值',
                                      `procMemSwap` bigint DEFAULT NULL COMMENT '当前进程交换空间大小 当前值',
                                      `procMemText` bigint DEFAULT NULL COMMENT '当前进程Text内存大小 当前值',
                                      `procMemVms` bigint DEFAULT NULL COMMENT '当前进程虚拟内存大小 当前值',
                                      `jvmProcHeapMemoryUsed` bigint DEFAULT NULL COMMENT 'jvm进程堆内存使用量（单位：byte）当前值',
                                      `jvmProcNonHeapMemoryUsed` bigint DEFAULT NULL COMMENT 'jvm进程堆外内存使用量（单位：byte）当前值',
                                      `jvmProcHeapSizeXmx` bigint DEFAULT NULL COMMENT 'jvm进程最大可用堆内存，对应 jvm Xmx（单位：byte）当前值',
                                      `jvmProcMemUsedPeak` bigint DEFAULT NULL COMMENT 'jvm进程启动以来内存使用量峰值（单位：byte）当前值',
                                      `jvmProcHeapMemUsedPercent` double DEFAULT NULL COMMENT 'jvm堆内存使用率 单位：% 当前值',
                                      `procIOReadRate` double DEFAULT NULL COMMENT '当前进程io读取频率（单位：hz）当前值',
                                      `procIOReadRateMin` double DEFAULT NULL COMMENT '当前进程io读取频率（单位：hz）最小值',
                                      `procIOReadRateMax` double DEFAULT NULL COMMENT '当前进程io读取频率（单位：hz）最大值',
                                      `procIOReadRateMean` double DEFAULT NULL COMMENT '当前进程io读取频率（单位：hz）均值',
                                      `procIOReadRateStd` double DEFAULT NULL COMMENT '当前进程io读取频率 标准差',
                                      `procIOReadRate55Quantile` double DEFAULT NULL COMMENT '当前进程io读取频率（单位：hz）55分位数',
                                      `procIOReadRate75Quantile` double DEFAULT NULL COMMENT '当前进程io读取频率（单位：hz）75分位数',
                                      `procIOReadRate95Quantile` double DEFAULT NULL COMMENT '当前进程io读取频率（单位：hz）95分位数',
                                      `procIOReadRate99Quantile` double DEFAULT NULL COMMENT '当前进程io读取频率（单位：hz）99分位数',
                                      `procIOReadBytesRate` bigint DEFAULT NULL COMMENT '当前进程io读取速率（单位：bytes/s）当前值',
                                      `procIOReadBytesRateMin` bigint DEFAULT NULL COMMENT '当前进程io读取速率（单位：bytes/s）最小值',
                                      `procIOReadBytesRateMax` bigint DEFAULT NULL COMMENT '当前进程io读取速率（单位：bytes/s）最大值',
                                      `procIOReadBytesRateMean` double DEFAULT NULL COMMENT '当前进程io读取速率（单位：bytes/s）均值',
                                      `procIOReadBytesRateStd` double DEFAULT NULL COMMENT '当前进程io读取速率 标准差',
                                      `procIOReadBytesRate55Quantile` bigint DEFAULT NULL COMMENT '当前进程io读取速率（单位：bytes/s）55分位数',
                                      `procIOReadBytesRate75Quantile` bigint DEFAULT NULL COMMENT '当前进程io读取速率（单位：bytes/s）75分位数',
                                      `procIOReadBytesRate95Quantile` bigint DEFAULT NULL COMMENT '当前进程io读取速率（单位：bytes/s）95分位数',
                                      `procIOReadBytesRate99Quantile` bigint DEFAULT NULL COMMENT '当前进程io读取速率（单位：bytes/s）99分位数',
                                      `procIOWriteRate` double DEFAULT NULL COMMENT '当前进程io写入频率（单位：hz）当前值',
                                      `procIOWriteRateMin` double DEFAULT NULL COMMENT '当前进程io写入频率（单位：hz）最小值',
                                      `procIOWriteRateMax` double DEFAULT NULL COMMENT '当前进程io写入频率（单位：hz）最大值',
                                      `procIOWriteRateMean` double DEFAULT NULL COMMENT '当前进程io写入频率（单位：hz）均值',
                                      `procIOWriteRateStd` double DEFAULT NULL COMMENT '当前进程io写入频率 标准差',
                                      `procIOWriteRate55Quantile` double DEFAULT NULL COMMENT '当前进程io写入频率（单位：hz）55分位数',
                                      `procIOWriteRate75Quantile` double DEFAULT NULL COMMENT '当前进程io写入频率（单位：hz）75分位数',
                                      `procIOWriteRate95Quantile` double DEFAULT NULL COMMENT '当前进程io写入频率（单位：hz）95分位数',
                                      `procIOWriteRate99Quantile` double DEFAULT NULL COMMENT '当前进程io写入频率（单位：hz）99分位数',
                                      `procIOWriteBytesRate` bigint DEFAULT NULL COMMENT '当前进程io写入速率（单位：bytes/s）当前值',
                                      `procIOWriteBytesRateMin` bigint DEFAULT NULL COMMENT '当前进程io写入速率（单位：bytes/s）最小值',
                                      `procIOWriteBytesRateMax` bigint DEFAULT NULL COMMENT '当前进程io写入速率（单位：bytes/s）最大值',
                                      `procIOWriteBytesRateMean` double DEFAULT NULL COMMENT '当前进程io写入速率（单位：bytes/s）均值',
                                      `procIOWriteBytesRateStd` double DEFAULT NULL COMMENT '当前进程io写入速率 标准差',
                                      `procIOWriteBytesRate55Quantile` bigint DEFAULT NULL COMMENT '当前进程io写入速率（单位：bytes/s）55分位数',
                                      `procIOWriteBytesRate75Quantile` bigint DEFAULT NULL COMMENT '当前进程io写入速率（单位：bytes/s）75分位数',
                                      `procIOWriteBytesRate95Quantile` bigint DEFAULT NULL COMMENT '当前进程io写入速率（单位：bytes/s）95分位数',
                                      `procIOWriteBytesRate99Quantile` bigint DEFAULT NULL COMMENT '当前进程io写入速率（单位：bytes/s）99分位数',
                                      `procIOReadWriteRate` double DEFAULT NULL COMMENT '当前进程io读、写频率（单位：hz）当前值',
                                      `procIOReadWriteRateMin` double DEFAULT NULL COMMENT '当前进程io读、写频率（单位：hz）最小值',
                                      `procIOReadWriteRateMax` double DEFAULT NULL COMMENT '当前进程io读、写频率（单位：hz）最大值',
                                      `procIOReadWriteRateMean` double DEFAULT NULL COMMENT '当前进程io读、写频率（单位：hz）均值',
                                      `procIOReadWriteRateStd` double DEFAULT NULL COMMENT '当前进程io读、写频率 标准差',
                                      `procIOReadWriteRate55Quantile` double DEFAULT NULL COMMENT '当前进程io读、写频率（单位：hz）55分位数',
                                      `procIOReadWriteRate75Quantile` double DEFAULT NULL COMMENT '当前进程io读、写频率（单位：hz）75分位数',
                                      `procIOReadWriteRate95Quantile` double DEFAULT NULL COMMENT '当前进程io读、写频率（单位：hz）95分位数',
                                      `procIOReadWriteRate99Quantile` double DEFAULT NULL COMMENT '当前进程io读、写频率（单位：hz）99分位数',
                                      `procIOReadWriteBytesRate` bigint DEFAULT NULL COMMENT '当前进程io读、写速率（单位：bytes/s）当前值',
                                      `procIOReadWriteBytesRateMin` bigint DEFAULT NULL COMMENT '当前进程io读、写速率（单位：bytes/s）最小值',
                                      `procIOReadWriteBytesRateMax` bigint DEFAULT NULL COMMENT '当前进程io读、写速率（单位：bytes/s）最大值',
                                      `procIOReadWriteBytesRateMean` double DEFAULT NULL COMMENT '当前进程io读、写速率（单位：bytes/s）均值',
                                      `procIOReadWriteBytesRateStd` double DEFAULT NULL COMMENT '当前进程io读、写速率 标准差',
                                      `procIOReadWriteBytesRate55Quantile` bigint DEFAULT NULL COMMENT '当前进程io读、写速率（单位：bytes/s）55分位数',
                                      `procIOReadWriteBytesRate75Quantile` bigint DEFAULT NULL COMMENT '当前进程io读、写速率（单位：bytes/s）75分位数',
                                      `procIOReadWriteBytesRate95Quantile` bigint DEFAULT NULL COMMENT '当前进程io读、写速率（单位：bytes/s）95分位数',
                                      `procIOReadWriteBytesRate99Quantile` bigint DEFAULT NULL COMMENT '当前进程io读、写速率（单位：bytes/s）99分位数',
                                      `procIOAwaitTimePercent` double DEFAULT NULL COMMENT '当前进程io读写等待时间占总时间百分比（单位：%） 对应 iotop IO当前值',
                                      `procIOAwaitTimePercentMin` double DEFAULT NULL COMMENT '当前进程io读写等待时间占总时间百分比（单位：%） 对应 iotop IO最小值',
                                      `procIOAwaitTimePercentMax` double DEFAULT NULL COMMENT '当前进程io读写等待时间占总时间百分比（单位：%） 对应 iotop IO最大值',
                                      `procIOAwaitTimePercentMean` double DEFAULT NULL COMMENT '当前进程io读写等待时间占总时间百分比（单位：%） 对应 iotop IO均值',
                                      `procIOAwaitTimePercentStd` double DEFAULT NULL COMMENT '当前进程io读写等待时间占总时间百分比 标准差',
                                      `procIOAwaitTimePercent55Quantile` double DEFAULT NULL COMMENT '当前进程io读写等待时间占总时间百分比（单位：%） 对应 iotop IO 55分位数',
                                      `procIOAwaitTimePercent75Quantile` double DEFAULT NULL COMMENT '当前进程io读写等待时间占总时间百分比（单位：%） 对应 iotop IO 75分位数',
                                      `procIOAwaitTimePercent95Quantile` double DEFAULT NULL COMMENT '当前进程io读写等待时间占总时间百分比（单位：%） 对应 iotop IO 95分位数',
                                      `procIOAwaitTimePercent99Quantile` double DEFAULT NULL COMMENT '当前进程io读写等待时间占总时间百分比（单位：%） 对应 iotop IO 99分位数',
                                      `jvmProcYoungGcCount` bigint DEFAULT NULL COMMENT '采样周期内 young gc 次数',
                                      `jvmProcFullGcCount` bigint DEFAULT NULL COMMENT '采样周期内 full gc 次数',
                                      `jvmProcYoungGcTime` bigint DEFAULT NULL COMMENT '采样周期内 young gc 耗时 单位：ms',
                                      `jvmProcFullGcTime` bigint DEFAULT NULL COMMENT '采样周期内 full gc 耗时 单位：ms',
                                      `jvmProcThreadNum` int DEFAULT NULL COMMENT '当前进程的线程数 当前值',
                                      `jvmProcThreadNumPeak` int DEFAULT NULL COMMENT '当前jvm进程启动以来线程数峰值 当前值',
                                      `procOpenFdCount` int DEFAULT NULL COMMENT '当前进程打开fd数量 当前值',
                                      `procPortListen` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '当前进程监听端口列表 json 格式 当前值',
                                      `procNetworkReceiveBytesPs` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 当前值',
                                      `procNetworkReceiveBytesPsMin` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 最小值',
                                      `procNetworkReceiveBytesPsMax` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 最大值',
                                      `procNetworkReceiveBytesPsMean` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 均值',
                                      `procNetworkReceiveBytesPsStd` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 标准差',
                                      `procNetworkReceiveBytesPs55Quantile` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 55分位数',
                                      `procNetworkReceiveBytesPs75Quantile` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 75分位数',
                                      `procNetworkReceiveBytesPs95Quantile` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 95分位数',
                                      `procNetworkReceiveBytesPs99Quantile` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 99分位数',
                                      `procNetworkSendBytesPs` bigint DEFAULT NULL COMMENT '当前进程网络每秒下行流量 当前值',
                                      `procNetworkSendBytesPsMin` bigint DEFAULT NULL COMMENT '当前进程网络每秒上行流量 最小值',
                                      `procNetworkSendBytesPsMax` bigint DEFAULT NULL COMMENT '当前进程网络每秒上行流量 最大值',
                                      `procNetworkSendBytesPsMean` bigint DEFAULT NULL COMMENT '当前进程网络每秒上行流量 均值',
                                      `procNetworkSendBytesPsStd` bigint DEFAULT NULL COMMENT '当前进程网络每秒上行流量 标准差',
                                      `procNetworkSendBytesPs55Quantile` bigint DEFAULT NULL COMMENT '当前进程网络每秒上行流量 55分位数',
                                      `procNetworkSendBytesPs75Quantile` bigint DEFAULT NULL COMMENT '当前进程网络每秒上行流量 75分位数',
                                      `procNetworkSendBytesPs95Quantile` bigint DEFAULT NULL COMMENT '当前进程网络每秒上行流量 95分位数',
                                      `procNetworkSendBytesPs99Quantile` bigint DEFAULT NULL COMMENT '当前进程网络每秒上行流量 99分位数',
                                      `procNetworkConnRate` bigint DEFAULT NULL COMMENT '当前进程网络连接频率(单位：hz) 当前值',
                                      `procNetworkConnRateMin` bigint DEFAULT NULL COMMENT '当前进程网络连接频率(单位：hz) 最小值',
                                      `procNetworkConnRateMax` bigint DEFAULT NULL COMMENT '当前进程网络连接频率(单位：hz) 最大值',
                                      `procNetworkConnRateMean` bigint DEFAULT NULL COMMENT '当前进程网络连接频率 均值',
                                      `procNetworkConnRateStd` bigint DEFAULT NULL COMMENT '当前进程网络连接频率(单位：hz) 标准差',
                                      `procNetworkConnRate55Quantile` bigint DEFAULT NULL COMMENT '当前进程网络连接频率(单位：hz) 55分位数',
                                      `procNetworkConnRate75Quantile` bigint DEFAULT NULL COMMENT '当前进程网络连接频率(单位：hz) 75分位数',
                                      `procNetworkConnRate95Quantile` bigint DEFAULT NULL COMMENT '当前进程网络连接频率(单位：hz) 95分位数',
                                      `procNetworkConnRate99Quantile` bigint DEFAULT NULL COMMENT '当前进程网络连接频率(单位：hz) 99分位数',
                                      `procNetworkTcpConnectionNum` int DEFAULT NULL COMMENT '当前进程tcp连接数 当前值',
                                      `procNetworkTcpListeningNum` int DEFAULT NULL COMMENT '当前进程处于 Listening 状态的 tcp 链接数 当前值',
                                      `procNetworkTcpTimeWaitNum` int DEFAULT NULL COMMENT '当前进程处于 time wait 状态 tcp 连接数 当前值',
                                      `procNetworkTcpCloseWaitNum` int DEFAULT NULL COMMENT '当前进程处于 close wait 状态 tcp 连接数 当前值',
                                      `procNetworkTcpEstablishedNum` int DEFAULT NULL COMMENT '当前进程处于 ESTABLISHED 状态的 tcp 链接数 当前值',
                                      `procNetworkTcpSynSentNum` int DEFAULT NULL COMMENT '当前进程处于 SYN_SENT 状态的 tcp 链接数 当前值',
                                      `procNetworkTcpSynRecvNum` int DEFAULT NULL COMMENT '当前进程处于 SYN_RECV 状态的 tcp 链接数 当前值',
                                      `procNetworkTcpFinWait1Num` int DEFAULT NULL COMMENT '当前进程处于 FIN_WAIT1 状态的 tcp 链接数 当前值',
                                      `procNetworkTcpFinWait2Num` int DEFAULT NULL COMMENT '当前进程处于 FIN_WAIT2 状态的 tcp 链接数 当前值',
                                      `procNetworkTcpClosedNum` int DEFAULT NULL COMMENT '当前进程处于 closed 状态 tcp 连接数 当前值',
                                      `procNetworkTcpClosingNum` int DEFAULT NULL COMMENT '当前进程处于 closing 状态 tcp 连接数 当前值',
                                      `procNetworkTcpLastAckNum` int DEFAULT NULL COMMENT '当前进程处于 last ack 状态 tcp 连接数 当前值',
                                      `procNetworkTcpNoneNum` int DEFAULT NULL COMMENT '当前进程处于 none 状态 tcp 连接数 当前值',
                                      `heartbeatTime` bigint DEFAULT '0' COMMENT '心跳时间',
                                      `heartbeatTimeMinute` bigint DEFAULT '0' COMMENT '心跳时间 精度：分钟',
                                      `heartbeatTimeHour` bigint DEFAULT '0' COMMENT '心跳时间 精度：小时',
                                      PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_metrics_system
-- ----------------------------
DROP TABLE IF EXISTS `tb_metrics_system`;
CREATE TABLE `tb_metrics_system` (
                                     `id` bigint NOT NULL AUTO_INCREMENT COMMENT '主键',
                                     `osType` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '操作系统类型',
                                     `osVersion` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '操作系统版本',
                                     `osKernelVersion` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '操作系统内核版本',
                                     `hostName` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT '主机名',
                                     `ips` varchar(255) CHARACTER SET utf8 COLLATE utf8_bin DEFAULT NULL COMMENT 'ip地址列表 json 格式',
                                     `systemNtpOffset` bigint DEFAULT NULL COMMENT '源时钟与本地时钟的时间差（毫秒）',
                                     `systemStartupTime` bigint DEFAULT NULL COMMENT '系统启动时间',
                                     `systemUptime` bigint DEFAULT NULL COMMENT '系统运行时间',
                                     `processesBlocked` int DEFAULT NULL COMMENT '不可中断的睡眠状态下的进程数',
                                     `processesSleeping` int DEFAULT NULL COMMENT '可中断的睡眠状态下的进程数',
                                     `processesZombies` int DEFAULT NULL COMMENT '僵尸态进程数',
                                     `processesStopped` int DEFAULT NULL COMMENT '暂停状态进程数',
                                     `processesRunning` int DEFAULT NULL COMMENT '运行中的进程数',
                                     `processesIdle` int DEFAULT NULL COMMENT '挂起的空闲进程数',
                                     `processesWait` int DEFAULT NULL COMMENT '等待中的进程数',
                                     `processesDead` int DEFAULT NULL COMMENT '回收中的进程数',
                                     `processesPaging` int DEFAULT NULL COMMENT '分页进程数',
                                     `processesUnknown` int DEFAULT NULL COMMENT '未知状态进程数',
                                     `processesTotal` int DEFAULT NULL COMMENT '总进程数',
                                     `processesTotalThreads` int DEFAULT NULL COMMENT '总线程数',
                                     `cpuCores` int DEFAULT NULL COMMENT 'cpu核数',
                                     `systemCpuUtil` double DEFAULT NULL COMMENT '系统总体CPU使用率 单位：% 当前值，使用率采用全核方式计数，如系统使用一颗核，则返回100，如使用两颗核，则返回200',
                                     `systemCpuUtilMin` double DEFAULT NULL COMMENT '系统总体CPU使用率 单位：% 最小值，使用率采用全核方式计数，如系统使用一颗核，则返回100，如使用两颗核，则返回200',
                                     `systemCpuUtilMax` double DEFAULT NULL COMMENT '系统总体CPU使用率 单位：% 最大值，使用率采用全核方式计数，如系统使用一颗核，则返回100，如使用两颗核，则返回200',
                                     `systemCpuUtilMean` double DEFAULT NULL COMMENT '系统总体CPU使用率 单位：% 均值，使用率采用全核方式计数，如系统使用一颗核，则返回100，如使用两颗核，则返回200',
                                     `systemCpuUtilStd` double DEFAULT NULL COMMENT '系统总体CPU使用率 单位：% 标准差',
                                     `systemCpuUtil55Quantile` double DEFAULT NULL COMMENT '系统总体CPU使用率 单位：% 55分位数，使用率采用全核方式计数，如系统使用一颗核，则返回100，如使用两颗核，则返回200',
                                     `systemCpuUtil75Quantile` double DEFAULT NULL COMMENT '系统总体CPU使用率 单位：% 75分位数，使用率采用全核方式计数，如系统使用一颗核，则返回100，如使用两颗核，则返回200',
                                     `systemCpuUtil95Quantile` double DEFAULT NULL COMMENT '系统总体CPU使用率 单位：% 95分位数，使用率采用全核方式计数，如系统使用一颗核，则返回100，如使用两颗核，则返回200',
                                     `systemCpuUtil99Quantile` double DEFAULT NULL COMMENT '系统总体CPU使用率 单位：% 99分位数，使用率采用全核方式计数，如系统使用一颗核，则返回100，如使用两颗核，则返回200',
                                     `systemCpuUtilTotalPercent` double DEFAULT NULL COMMENT '系统总体CPU使用率 总体百分比 单位：% 当前值',
                                     `systemCpuUtilTotalPercentMin` double DEFAULT NULL COMMENT '系统总体CPU使用率 总体百分比 单位：% 最小值',
                                     `systemCpuUtilTotalPercentMax` double DEFAULT NULL COMMENT '系统总体CPU使用率 总体百分比 单位：% 最大值',
                                     `systemCpuUtilTotalPercentMean` double DEFAULT NULL COMMENT '系统总体CPU使用率 总体百分比 单位：% 均值',
                                     `systemCpuUtilTotalPercentStd` double DEFAULT NULL COMMENT '系统总体CPU使用率 总体百分比 标准差',
                                     `systemCpuUtilTotalPercent55Quantile` double DEFAULT NULL COMMENT '系统总体CPU使用率 总体百分比 单位：% 55分位数',
                                     `systemCpuUtilTotalPercent75Quantile` double DEFAULT NULL COMMENT '系统总体CPU使用率 总体百分比 单位：% 75分位数',
                                     `systemCpuUtilTotalPercent95Quantile` double DEFAULT NULL COMMENT '系统总体CPU使用率 总体百分比 单位：% 95分位数',
                                     `systemCpuUtilTotalPercent99Quantile` double DEFAULT NULL COMMENT '系统总体CPU使用率 总体百分比 单位：% 99分位数',
                                     `systemCpuSystem` double DEFAULT NULL COMMENT '内核态CPU时间占比 单位：% 当前值',
                                     `systemCpuSystemMin` double DEFAULT NULL COMMENT '内核态CPU时间占比 单位：% 最小值',
                                     `systemCpuSystemMax` double DEFAULT NULL COMMENT '内核态CPU时间占比 单位：% 最大值',
                                     `systemCpuSystemMean` double DEFAULT NULL COMMENT '内核态CPU时间占比 单位：% 均值',
                                     `systemCpuSystemStd` double DEFAULT NULL COMMENT '内核态CPU时间占比 标准差',
                                     `systemCpuSystem55Quantile` double DEFAULT NULL COMMENT '内核态CPU时间占比 单位：% 55分位数',
                                     `systemCpuSystem75Quantile` double DEFAULT NULL COMMENT '内核态CPU时间占比 单位：% 75分位数',
                                     `systemCpuSystem95Quantile` double DEFAULT NULL COMMENT '内核态CPU时间占比 单位：% 95分位数',
                                     `systemCpuSystem99Quantile` double DEFAULT NULL COMMENT '内核态CPU时间占比 单位：% 99分位数',
                                     `systemCpuUser` double DEFAULT NULL COMMENT '用户态CPU时间占比 单位：% 当前值',
                                     `systemCpuUserMin` double DEFAULT NULL COMMENT '用户态CPU时间占比 单位：% 最小值',
                                     `systemCpuUserMax` double DEFAULT NULL COMMENT '用户态CPU时间占比 单位：% 最大值',
                                     `systemCpuUserMean` double DEFAULT NULL COMMENT '用户态CPU时间占比 单位：% 均值',
                                     `systemCpuUserStd` double DEFAULT NULL COMMENT '用户态CPU时间占比 标准差',
                                     `systemCpuUser55Quantile` double DEFAULT NULL COMMENT '用户态CPU时间占比 单位：% 55分位数',
                                     `systemCpuUser75Quantile` double DEFAULT NULL COMMENT '用户态CPU时间占比 单位：% 75分位数',
                                     `systemCpuUser95Quantile` double DEFAULT NULL COMMENT '用户态CPU时间占比 单位：% 95分位数',
                                     `systemCpuUser99Quantile` double DEFAULT NULL COMMENT '用户态CPU时间占比 单位：% 99分位数',
                                     `systemCpuIdle` double DEFAULT NULL COMMENT '总体cpu空闲率 单位：% 当前值',
                                     `systemCpuIdleMin` double DEFAULT NULL COMMENT '总体cpu空闲率 单位：% 最小值',
                                     `systemCpuIdleMax` double DEFAULT NULL COMMENT '总体cpu空闲率 单位：% 最大值',
                                     `systemCpuIdleMean` double DEFAULT NULL COMMENT '总体cpu空闲率 单位：% 均值',
                                     `systemCpuIdleStd` double DEFAULT NULL COMMENT '总体cpu空闲率 标准差',
                                     `systemCpuIdle55Quantile` double DEFAULT NULL COMMENT '总体cpu空闲率 单位：% 55分位数',
                                     `systemCpuIdle75Quantile` double DEFAULT NULL COMMENT '总体cpu空闲率 单位：% 75分位数',
                                     `systemCpuIdle95Quantile` double DEFAULT NULL COMMENT '总体cpu空闲率 单位：% 95分位数',
                                     `systemCpuIdle99Quantile` double DEFAULT NULL COMMENT '总体cpu空闲率 单位：% 99分位数',
                                     `systemCpuSwitches` bigint DEFAULT NULL COMMENT '每秒cpu上下文交换次数 当前值',
                                     `systemCpuSwitchesMin` bigint DEFAULT NULL COMMENT '每秒cpu上下文交换次数 最小值',
                                     `systemCpuSwitchesMax` bigint DEFAULT NULL COMMENT '每秒cpu上下文交换次数 最大值',
                                     `systemCpuSwitchesMean` double DEFAULT NULL COMMENT '每秒cpu上下文交换次数 均值',
                                     `systemCpuSwitchesStd` double DEFAULT NULL COMMENT '总体cpu空闲率 标准差',
                                     `systemCpuSwitches55Quantile` bigint DEFAULT NULL COMMENT '每秒cpu上下文交换次数 55分位数',
                                     `systemCpuSwitches75Quantile` bigint DEFAULT NULL COMMENT '每秒cpu上下文交换次数 75分位数',
                                     `systemCpuSwitches95Quantile` bigint DEFAULT NULL COMMENT '每秒cpu上下文交换次数 95分位数',
                                     `systemCpuSwitches99Quantile` bigint DEFAULT NULL COMMENT '每秒cpu上下文交换次数 99分位数',
                                     `systemCpuUsageIrq` double DEFAULT NULL COMMENT 'CPU处理硬中断的时间占比 单位：% 当前值',
                                     `systemCpuUsageIrqMin` double DEFAULT NULL COMMENT 'CPU处理硬中断的时间占比 单位：% 最小值',
                                     `systemCpuUsageIrqMax` double DEFAULT NULL COMMENT 'CPU处理硬中断的时间占比 单位：% 最大值',
                                     `systemCpuUsageIrqMean` double DEFAULT NULL COMMENT 'CPU处理硬中断的时间占比 单位：% 均值',
                                     `systemCpuUsageIrqStd` double DEFAULT NULL COMMENT 'CPU处理硬中断的时间占比 标准差',
                                     `systemCpuUsageIrq55Quantile` double DEFAULT NULL COMMENT 'CPU处理硬中断的时间占比 单位：% 55分位数',
                                     `systemCpuUsageIrq75Quantile` double DEFAULT NULL COMMENT 'CPU处理硬中断的时间占比 单位：% 75分位数',
                                     `systemCpuUsageIrq95Quantile` double DEFAULT NULL COMMENT 'CPU处理硬中断的时间占比 单位：% 95分位数',
                                     `systemCpuUsageIrq99Quantile` double DEFAULT NULL COMMENT 'CPU处理硬中断的时间占比 单位：% 99分位数',
                                     `systemCpuUsageSoftIrq` double DEFAULT NULL COMMENT 'CPU处理软中断的时间占比 单位：% 当前值',
                                     `systemCpuUsageSoftIrqMin` double DEFAULT NULL COMMENT 'CPU处理软中断的时间占比 单位：% 最小值',
                                     `systemCpuUsageSoftIrqMax` double DEFAULT NULL COMMENT 'CPU处理软中断的时间占比 单位：% 最大值',
                                     `systemCpuUsageSoftIrqMean` double DEFAULT NULL COMMENT 'CPU处理软中断的时间占比 单位：% 均值',
                                     `systemCpuUsageSoftIrqStd` double DEFAULT NULL COMMENT 'CPU处理软中断的时间占比 标准差',
                                     `systemCpuUsageSoftIrq55Quantile` double DEFAULT NULL COMMENT 'CPU处理软中断的时间占比 单位：% 55分位数',
                                     `systemCpuUsageSoftIrq75Quantile` double DEFAULT NULL COMMENT 'CPU处理软中断的时间占比 单位：% 75分位数',
                                     `systemCpuUsageSoftIrq95Quantile` double DEFAULT NULL COMMENT 'CPU处理软中断的时间占比 单位：% 95分位数',
                                     `systemCpuUsageSoftIrq99Quantile` double DEFAULT NULL COMMENT 'CPU处理软中断的时间占比 单位：% 99分位数',
                                     `systemLoad1` double DEFAULT NULL COMMENT '系统近1分钟平均负载 当前值',
                                     `systemLoad1Min` double DEFAULT NULL COMMENT '系统近1分钟平均负载 最小值',
                                     `systemLoad1Max` double DEFAULT NULL COMMENT '系统近1分钟平均负载 最大值',
                                     `systemLoad1Mean` double DEFAULT NULL COMMENT '系统近1分钟平均负载 均值',
                                     `systemLoad1Std` double DEFAULT NULL COMMENT '系统近1分钟平均负载 标准差',
                                     `systemLoad155Quantile` double DEFAULT NULL COMMENT '系统近1分钟平均负载 55分位数',
                                     `systemLoad175Quantile` double DEFAULT NULL COMMENT '系统近1分钟平均负载 75分位数',
                                     `systemLoad195Quantile` double DEFAULT NULL COMMENT '系统近1分钟平均负载 95分位数',
                                     `systemLoad199Quantile` double DEFAULT NULL COMMENT '系统近1分钟平均负载 99分位数',
                                     `systemLoad5` double DEFAULT NULL COMMENT '系统近5分钟平均负载 当前值',
                                     `systemLoad5Min` double DEFAULT NULL COMMENT '系统近5分钟平均负载 最小值',
                                     `systemLoad5Max` double DEFAULT NULL COMMENT '系统近5分钟平均负载 最大值',
                                     `systemLoad5Mean` double DEFAULT NULL COMMENT '系统近5分钟平均负载 均值',
                                     `systemLoad5Std` double DEFAULT NULL COMMENT '系统近5分钟平均负载 标准差',
                                     `systemLoad555Quantile` double DEFAULT NULL COMMENT '系统近5分钟平均负载 55分位数',
                                     `systemLoad575Quantile` double DEFAULT NULL COMMENT '系统近5分钟平均负载 75分位数',
                                     `systemLoad595Quantile` double DEFAULT NULL COMMENT '系统近5分钟平均负载 95分位数',
                                     `systemLoad599Quantile` double DEFAULT NULL COMMENT '系统近5分钟平均负载 99分位数',
                                     `systemLoad15` double DEFAULT NULL COMMENT '系统近15分钟平均负载 当前值',
                                     `systemLoad15Min` double DEFAULT NULL COMMENT '系统近15分钟平均负载 最小值',
                                     `systemLoad15Max` double DEFAULT NULL COMMENT '系统近15分钟平均负载 最大值',
                                     `systemLoad15Mean` double DEFAULT NULL COMMENT '系统近15分钟平均负载 均值',
                                     `systemLoad15Std` double DEFAULT NULL COMMENT '系统近15分钟平均负载 标准差',
                                     `systemLoad1555Quantile` double DEFAULT NULL COMMENT '系统近15分钟平均负载 55分位数',
                                     `systemLoad1575Quantile` double DEFAULT NULL COMMENT '系统近15分钟平均负载 75分位数',
                                     `systemLoad1595Quantile` double DEFAULT NULL COMMENT '系统近15分钟平均负载 95分位数',
                                     `systemLoad1599Quantile` double DEFAULT NULL COMMENT '系统近15分钟平均负载 99分位数',
                                     `systemCpuIOWait` double DEFAULT NULL COMMENT '系统等待I/O的CPU时间占比 单位：% 当前值',
                                     `systemCpuIOWaitMin` double DEFAULT NULL COMMENT '系统等待I/O的CPU时间占比 单位：% 最小值',
                                     `systemCpuIOWaitMax` double DEFAULT NULL COMMENT '系统等待I/O的CPU时间占比 单位：% 最大值',
                                     `systemCpuIOWaitMean` double DEFAULT NULL COMMENT '系统等待I/O的CPU时间占比 单位：% 均值',
                                     `systemCpuIOWaitStd` double DEFAULT NULL COMMENT '系统等待I/O的CPU时间占比 标准差',
                                     `systemCpuIOWait55Quantile` double DEFAULT NULL COMMENT '系统等待I/O的CPU时间占比 单位：% 55分位数',
                                     `systemCpuIOWait75Quantile` double DEFAULT NULL COMMENT '系统等待I/O的CPU时间占比 单位：% 75分位数',
                                     `systemCpuIOWait95Quantile` double DEFAULT NULL COMMENT '系统等待I/O的CPU时间占比 单位：% 95分位数',
                                     `systemCpuIOWait99Quantile` double DEFAULT NULL COMMENT '系统等待I/O的CPU时间占比 单位：% 99分位数',
                                     `systemCpuGuest` double DEFAULT NULL COMMENT '虚拟处理器CPU时间占比 单位：% 当前值',
                                     `systemCpuGuestMin` double DEFAULT NULL COMMENT '虚拟处理器CPU时间占比 单位：% 最小值',
                                     `systemCpuGuestMax` double DEFAULT NULL COMMENT '虚拟处理器CPU时间占比 单位：% 最大值',
                                     `systemCpuGuestMean` double DEFAULT NULL COMMENT '虚拟处理器CPU时间占比 单位：% 均值',
                                     `systemCpuGuestStd` double DEFAULT NULL COMMENT '虚拟处理器CPU时间占比 标准差',
                                     `systemCpuGuest55Quantile` double DEFAULT NULL COMMENT '虚拟处理器CPU时间占比 单位：% 55分位数',
                                     `systemCpuGuest75Quantile` double DEFAULT NULL COMMENT '虚拟处理器CPU时间占比 单位：% 75分位数',
                                     `systemCpuGuest95Quantile` double DEFAULT NULL COMMENT '虚拟处理器CPU时间占比 单位：% 95分位数',
                                     `systemCpuGuest99Quantile` double DEFAULT NULL COMMENT '虚拟处理器CPU时间占比 单位：% 99分位数',
                                     `systemCpuSteal` double DEFAULT NULL COMMENT '虚拟CPU的竞争等待时间占比 单位：% 当前值',
                                     `systemCpuStealMin` double DEFAULT NULL COMMENT '虚拟CPU的竞争等待时间占比 单位：% 最小值',
                                     `systemCpuStealMax` double DEFAULT NULL COMMENT '虚拟CPU的竞争等待时间占比 单位：% 最大值',
                                     `systemCpuStealMean` double DEFAULT NULL COMMENT '虚拟CPU的竞争等待时间占比 单位：% 均值',
                                     `systemCpuStealStd` double DEFAULT NULL COMMENT '虚拟CPU的竞争等待时间占比 标准差',
                                     `systemCpuSteal55Quantile` double DEFAULT NULL COMMENT '虚拟CPU的竞争等待时间占比 单位：% 55分位数',
                                     `systemCpuSteal75Quantile` double DEFAULT NULL COMMENT '虚拟CPU的竞争等待时间占比 单位：% 75分位数',
                                     `systemCpuSteal95Quantile` double DEFAULT NULL COMMENT '虚拟CPU的竞争等待时间占比 单位：% 95分位数',
                                     `systemCpuSteal99Quantile` double DEFAULT NULL COMMENT '虚拟CPU的竞争等待时间占比 单位：% 99分位数',
                                     `systemMemCommitLimit` bigint DEFAULT NULL COMMENT '系统当前可分配的内存总量 单位：byte 当前值',
                                     `systemMemCommittedAs` bigint DEFAULT NULL COMMENT '系统已分配的包括进程未使用的内存量 单位：byte 当前值',
                                     `systemMemCommitted` bigint DEFAULT NULL COMMENT '返回在磁盘分页文件上保留的物理内存量 单位：byte 当前值',
                                     `systemMemNonPaged` bigint DEFAULT NULL COMMENT '不能写入磁盘的物理内存量 单位：byte 当前值',
                                     `systemMemPaged` bigint DEFAULT NULL COMMENT '没被使用是可以写入磁盘的物理内存量 单位：byte 当前值',
                                     `systemMemShared` bigint DEFAULT NULL COMMENT '用作共享内存的物理RAM量 单位：byte 当前值',
                                     `systemMemSlab` bigint DEFAULT NULL COMMENT '内核用来缓存数据结构供自己使用的内存量 单位：byte 当前值',
                                     `systemMemTotal` bigint DEFAULT NULL COMMENT '系统物理内存总量 单位：byte 当前值',
                                     `systemMemFree` bigint DEFAULT NULL COMMENT '系统空闲内存大小 单位：byte 当前值',
                                     `systemMemUsed` bigint DEFAULT NULL COMMENT '系统已用内存大小 单位：byte 当前值',
                                     `systemMemBuffered` bigint DEFAULT NULL COMMENT '块设备占用的缓存页，包括直接读写块设备、文件系统元数据、superblock（超级块中的数据其实就是文件卷的控制信息部分，也可以说它是卷资源表，有关文件卷的大部分信息都保存在这里。例如：硬盘分区中每个block的大小、硬盘分区上一共有多少个block group、以及每个block group中有多少个inode）所使用的缓存页 单位：byte 当前值',
                                     `systemMemCached` bigint DEFAULT NULL COMMENT '普通文件所占用的缓存页 单位：byte 当前值',
                                     `systemMemFreePercent` double DEFAULT NULL COMMENT '系统内存空闲率 单位：% 当前值',
                                     `systemMemUsedPercent` double DEFAULT NULL COMMENT '系统内存使用率 单位：% 当前值',
                                     `systemSwapCached` bigint DEFAULT NULL COMMENT '系统用作缓存的交换空间 单位：byte 当前值',
                                     `systemSwapFree` bigint DEFAULT NULL COMMENT '系统空闲swap大小 单位：byte 当前值',
                                     `systemSwapFreePercent` double DEFAULT NULL COMMENT '系统空闲swap占比 单位：% 当前值',
                                     `systemSwapTotal` bigint DEFAULT NULL COMMENT '系统swap总大小 单位：byte 当前值',
                                     `systemSwapUsed` bigint DEFAULT NULL COMMENT '系统已用swap大小 单位：byte 当前值',
                                     `systemSwapUsedPercent` double DEFAULT NULL COMMENT '系统已用swap占比 单位：% 当前值',
                                     `systemDisks` int DEFAULT NULL COMMENT '磁盘数',
                                     `systemFilesMax` int DEFAULT NULL COMMENT '系统可以打开的最大文件句柄数',
                                     `systemFilesAllocated` int DEFAULT NULL COMMENT '系统已分配文件句柄数',
                                     `systemFilesLeft` int DEFAULT NULL COMMENT '系统未分配文件句柄数',
                                     `systemFilesUsedPercent` double DEFAULT NULL COMMENT '系统使用文件句柄占已分配百分比（单位：%）',
                                     `systemFilesUsed` int DEFAULT NULL COMMENT '系统使用的已分配文件句柄数',
                                     `systemFilesNotUsed` int DEFAULT NULL COMMENT '系统未使用的已分配文件句柄数',
                                     `systemNetCards` int DEFAULT NULL COMMENT '网卡数',
                                     `systemNetworkReceiveBytesPs` bigint DEFAULT NULL COMMENT '系统网络每秒下行流量 单位：byte 当前值',
                                     `systemNetworkReceiveBytesPsMin` bigint DEFAULT NULL COMMENT '系统网络每秒下行流量 单位：byte 最小值',
                                     `systemNetworkReceiveBytesPsMax` bigint DEFAULT NULL COMMENT '系统网络每秒下行流量 单位：byte 最大值',
                                     `systemNetworkReceiveBytesPsMean` double DEFAULT NULL COMMENT '系统网络每秒下行流量 单位：byte 均值',
                                     `systemNetworkReceiveBytesPsStd` double DEFAULT NULL COMMENT '系统网络每秒下行流量 标准差',
                                     `systemNetworkReceiveBytesPs55Quantile` bigint DEFAULT NULL COMMENT '系统网络每秒下行流量 单位：byte 55分位数',
                                     `systemNetworkReceiveBytesPs75Quantile` bigint DEFAULT NULL COMMENT '系统网络每秒下行流量 单位：byte 75分位数',
                                     `systemNetworkReceiveBytesPs95Quantile` bigint DEFAULT NULL COMMENT '系统网络每秒下行流量 单位：byte 95分位数',
                                     `systemNetworkReceiveBytesPs99Quantile` bigint DEFAULT NULL COMMENT '系统网络每秒下行流量 单位：byte 99分位数',
                                     `systemNetworkSendBytesPs` bigint DEFAULT NULL COMMENT '系统网络每秒上行流量 单位：byte 当前值',
                                     `systemNetworkSendBytesPsMin` bigint DEFAULT NULL COMMENT '系统网络每秒上行流量 单位：byte 最小值',
                                     `systemNetworkSendBytesPsMax` bigint DEFAULT NULL COMMENT '系统网络每秒上行流量 单位：byte 最大值',
                                     `systemNetworkSendBytesPsMean` double DEFAULT NULL COMMENT '系统网络每秒上行流量 单位：byte 均值',
                                     `systemNetworkSendBytesPsStd` double DEFAULT NULL COMMENT '系统网络每秒上行流量 标准差',
                                     `systemNetworkSendBytesPs55Quantile` bigint DEFAULT NULL COMMENT '系统网络每秒上行流量 单位：byte 55分位数',
                                     `systemNetworkSendBytesPs75Quantile` bigint DEFAULT NULL COMMENT '系统网络每秒上行流量 单位：byte 75分位数',
                                     `systemNetworkSendBytesPs95Quantile` bigint DEFAULT NULL COMMENT '系统网络每秒上行流量 单位：byte 95分位数',
                                     `systemNetworkSendBytesPs99Quantile` bigint DEFAULT NULL COMMENT '系统网络每秒上行流量 单位：byte 99分位数',
                                     `systemNetworkTcpConnectionNum` int DEFAULT NULL COMMENT '系统tcp连接数 当前值',
                                     `systemNetworkTcpListeningNum` int DEFAULT NULL COMMENT '系统 Listening 状态的 tcp 链接数 当前值',
                                     `systemNetworkTcpEstablishedNum` int DEFAULT NULL COMMENT '系统 ESTABLISHED 状态的 tcp 链接数 当前值',
                                     `systemNetworkTcpSynSentNum` int DEFAULT NULL COMMENT '系统 SYN_SENT 状态的 tcp 链接数 当前值',
                                     `systemNetworkTcpSynRecvNum` int DEFAULT NULL COMMENT '系统 SYN_RECV 状态的 tcp 链接数 当前值',
                                     `systemNetworkTcpFinWait1Num` int DEFAULT NULL COMMENT '系统 FIN_WAIT1 状态的 tcp 链接数 当前值',
                                     `systemNetworkTcpFinWait2Num` int DEFAULT NULL COMMENT '系统 FIN_WAIT2 状态的 tcp 链接数 当前值',
                                     `systemNetworkTcpTimeWaitNum` int DEFAULT NULL COMMENT '系统处于 time wait 状态 tcp 连接数 当前值',
                                     `systemNetworkTcpClosedNum` int DEFAULT NULL COMMENT '系统处于 closed 状态 tcp 连接数 当前值',
                                     `systemNetworkTcpCloseWaitNum` int DEFAULT NULL COMMENT '系统处于 close wait 状态 tcp 连接数 当前值',
                                     `systemNetworkTcpClosingNum` int DEFAULT NULL COMMENT '系统处于 closing 状态 tcp 连接数 当前值',
                                     `systemNetworkTcpLastAckNum` int DEFAULT NULL COMMENT '系统处于 last ack 状态 tcp 连接数 当前值',
                                     `systemNetworkTcpNoneNum` int DEFAULT NULL COMMENT '系统处于 none 状态 tcp 连接数 当前值',
                                     `systemNetworkTcpActiveOpens` bigint DEFAULT NULL COMMENT '采样周期内 Tcp 主动连接次数',
                                     `systemNetworkTcpPassiveOpens` bigint DEFAULT NULL COMMENT '采样周期内 Tcp 被动连接次数',
                                     `systemNetworkTcpAttemptFails` bigint DEFAULT NULL COMMENT '采样周期内 Tcp 连接失败次数',
                                     `systemNetworkTcpEstabResets` bigint DEFAULT NULL COMMENT '采样周期内 Tcp 连接异常断开次数',
                                     `systemNetworkTcpRetransSegs` bigint DEFAULT NULL COMMENT '采样周期内 Tcp 重传的报文段总个数',
                                     `systemNetworkTcpExtListenOverflows` bigint DEFAULT NULL COMMENT '采样周期内 Tcp 监听队列溢出次数',
                                     `systemNetworkUdpInDatagrams` bigint DEFAULT NULL COMMENT '采样周期内 UDP 入包量',
                                     `systemNetworkUdpOutDatagrams` bigint DEFAULT NULL COMMENT '采样周期内 UDP 出包量',
                                     `systemNetworkUdpInErrors` bigint DEFAULT NULL COMMENT '采样周期内 UDP 入包错误数',
                                     `systemNetworkUdpNoPorts` bigint DEFAULT NULL COMMENT '采样周期内 UDP 端口不可达个数',
                                     `systemNetworkUdpSendBufferErrors` bigint DEFAULT NULL COMMENT '采样周期内 UDP 发送缓冲区满次数',
                                     `heartbeatTime` bigint DEFAULT '0' COMMENT '心跳时间',
                                     `heartbeatTimeMinute` bigint DEFAULT '0' COMMENT '心跳时间 精度：分钟',
                                     `heartbeatTimeHour` bigint DEFAULT '0' COMMENT '心跳时间 精度：小时',
                                     PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8_bin;

-- ----------------------------
-- Table structure for tb_service
-- ----------------------------
DROP TABLE IF EXISTS `tb_service`;
CREATE TABLE `tb_service` (
                              `id` bigint NOT NULL AUTO_INCREMENT COMMENT '自增id',
                              `service_name` varchar(255) NOT NULL DEFAULT '' COMMENT '服务名',
                              `operator` varchar(64) NOT NULL DEFAULT '' COMMENT '操作人',
                              `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                              `modify_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '修改时间',
                              `extenal_service_id` bigint DEFAULT '0' COMMENT '外部系统服务id，如：夜莺服务节点 id',
                              PRIMARY KEY (`id`),
                              UNIQUE KEY `uniq_service_name` (`service_name`) COMMENT '服务名唯一索引'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='服务表：表示一个服务';

-- ----------------------------
-- Table structure for tb_service_host
-- ----------------------------
DROP TABLE IF EXISTS `tb_service_host`;
CREATE TABLE `tb_service_host` (
                                   `id` bigint NOT NULL AUTO_INCREMENT COMMENT '	\n自增id',
                                   `service_id` bigint NOT NULL COMMENT '表 tb_service主键 id',
                                   `host_id` bigint NOT NULL COMMENT '表 tb_host主键 id',
                                   PRIMARY KEY (`id`),
                                   KEY `idx_host_id` (`host_id`),
                                   KEY `idx_service_id` (`service_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COMMENT='服务 & 主机关联关系表：表示服务 & 主机的关联关系，Service : Host多对多关联关系';

-- ----------------------------
-- Table structure for tb_service_project
-- ----------------------------
DROP TABLE IF EXISTS `tb_service_project`;
CREATE TABLE `tb_service_project` (
                                      `id` bigint NOT NULL AUTO_INCREMENT,
                                      `service_id` bigint NOT NULL COMMENT '对应表 tb_service id',
                                      `project_id` bigint NOT NULL COMMENT '项目id',
                                      PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

SET FOREIGN_KEY_CHECKS = 1;

insert into tb_agent_version (file_name, file_md5, file_type, description, operator, version)
values ('agent-new.tgz',	'',	0,	'',	'System', '1.0.0');
