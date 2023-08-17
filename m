Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE0DA80C;
	Thu, 17 Aug 2023 06:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692254357; x=1723790357;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=rFRRVEEucSSTXNeQi/3oBg68H2cCmE1GCVvNVuJOHew=;
  b=aYDD5Ig9ScCFI5N3jpYRj7GBvttckgJ4rcBC5parqI8yZZVkhGbO6kNB
   L8z2TWYB23/pI2dtCQWl0ifKwuRqoD7JKvjuBeaVUh3JzxI7D12/t+NGb
   URMIAjjZswjHt2S3Tz7DfnW1eYkx3Qvjg5Z4S0N9KjH1q0Xgc36ZoHnsC
   4AjSt5lM5zY2cBRpoRgnxGosKYilvvc+ws5NRDdnY9vdEu0a6xzofXL4J
   zfkC3kDbW45jXe1Oc6FVe5podI1BVMMhJ+INbds4fI6Td5uKbGD2hRrnY
   +T8cld3ApB0npD78HcLg2H5kJ9b1tGR1zLrVTxiVv4YiOGKgAMMSNmizE
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="372727112"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="372727112"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 23:39:15 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="1065135113"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="1065135113"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by fmsmga005.fm.intel.com with ESMTP; 16 Aug 2023 23:39:10 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qWWez-0000rX-0i;
	Thu, 17 Aug 2023 06:39:09 +0000
Date: Thu, 17 Aug 2023 14:38:23 +0800
From: kernel test robot <lkp@intel.com>
To: Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Shaoqin Huang <shahuang@redhat.com>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH v5 05/12] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
Message-ID: <202308171444.Q5rfJubF-lkp@intel.com>
References: <20230817003029.3073210-6-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817003029.3073210-6-rananta@google.com>

Hi Raghavendra,

kernel test robot noticed the following build errors:

[auto build test ERROR on 2ccdd1b13c591d306f0401d98dedc4bdcd02b421]

url:    https://github.com/intel-lab-lkp/linux/commits/Raghavendra-Rao-Ananta/KVM-arm64-PMU-Introduce-a-helper-to-set-the-guest-s-PMU/20230817-083353
base:   2ccdd1b13c591d306f0401d98dedc4bdcd02b421
patch link:    https://lore.kernel.org/r/20230817003029.3073210-6-rananta%40google.com
patch subject: [PATCH v5 05/12] KVM: arm64: PMU: Simplify extracting PMCR_EL0.N
config: arm-randconfig-r046-20230817 (https://download.01.org/0day-ci/archive/20230817/202308171444.Q5rfJubF-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230817/202308171444.Q5rfJubF-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308171444.Q5rfJubF-lkp@intel.com/

All errors (new ones prefixed by >>):

         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:148:44: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     148 |         [C(DTLB)][C(OP_READ)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_L1D_TLB_RD,
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:133:44: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_L1D_TLB_RD'
     133 | #define ARMV8_IMPDEF_PERFCTR_L1D_TLB_RD                         0x004E
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:149:45: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     149 |         [C(DTLB)][C(OP_WRITE)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_L1D_TLB_WR,
         |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:134:44: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_L1D_TLB_WR'
     134 | #define ARMV8_IMPDEF_PERFCTR_L1D_TLB_WR                         0x004F
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:150:42: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     150 |         [C(DTLB)][C(OP_READ)][C(RESULT_MISS)]   = ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_RD,
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:131:50: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_RD'
     131 | #define ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_RD                  0x004C
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:151:43: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     151 |         [C(DTLB)][C(OP_WRITE)][C(RESULT_MISS)]  = ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_WR,
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:132:50: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_WR'
     132 | #define ARMV8_IMPDEF_PERFCTR_L1D_TLB_REFILL_WR                  0x004D
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:153:44: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     153 |         [C(NODE)][C(OP_READ)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD,
         |                                                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:148:46: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD'
     148 | #define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_RD                      0x0060
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
   drivers/perf/arm_pmuv3.c:154:45: warning: initializer overrides prior initialization of this subobject [-Winitializer-overrides]
     154 |         [C(NODE)][C(OP_WRITE)][C(RESULT_ACCESS)] = ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR,
         |                                                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmuv3.h:149:46: note: expanded from macro 'ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR'
     149 | #define ARMV8_IMPDEF_PERFCTR_BUS_ACCESS_WR                      0x0061
         |                                                                 ^~~~~~
   drivers/perf/arm_pmuv3.c:141:2: note: previous initialization is here
     141 |         PERF_CACHE_MAP_ALL_UNSUPPORTED,
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:45:31: note: expanded from macro 'PERF_CACHE_MAP_ALL_UNSUPPORTED'
      45 |                 [0 ... C(RESULT_MAX) - 1] = CACHE_OP_UNSUPPORTED,       \
         |                                             ^~~~~~~~~~~~~~~~~~~~
   include/linux/perf/arm_pmu.h:37:31: note: expanded from macro 'CACHE_OP_UNSUPPORTED'
      37 | #define CACHE_OP_UNSUPPORTED            0xFFFF
         |                                         ^~~~~~
>> drivers/perf/arm_pmuv3.c:1131:24: error: call to undeclared function 'FIELD_GET'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
    1131 |         cpu_pmu->num_events = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
         |                               ^
   55 warnings and 1 error generated.


vim +/FIELD_GET +1131 drivers/perf/arm_pmuv3.c

  1114	
  1115	static void __armv8pmu_probe_pmu(void *info)
  1116	{
  1117		struct armv8pmu_probe_info *probe = info;
  1118		struct arm_pmu *cpu_pmu = probe->pmu;
  1119		u64 pmceid_raw[2];
  1120		u32 pmceid[2];
  1121		int pmuver;
  1122	
  1123		pmuver = read_pmuver();
  1124		if (!pmuv3_implemented(pmuver))
  1125			return;
  1126	
  1127		cpu_pmu->pmuver = pmuver;
  1128		probe->present = true;
  1129	
  1130		/* Read the nb of CNTx counters supported from PMNC */
> 1131		cpu_pmu->num_events = FIELD_GET(ARMV8_PMU_PMCR_N, armv8pmu_pmcr_read());
  1132	
  1133		/* Add the CPU cycles counter */
  1134		cpu_pmu->num_events += 1;
  1135	
  1136		pmceid[0] = pmceid_raw[0] = read_pmceid0();
  1137		pmceid[1] = pmceid_raw[1] = read_pmceid1();
  1138	
  1139		bitmap_from_arr32(cpu_pmu->pmceid_bitmap,
  1140				     pmceid, ARMV8_PMUV3_MAX_COMMON_EVENTS);
  1141	
  1142		pmceid[0] = pmceid_raw[0] >> 32;
  1143		pmceid[1] = pmceid_raw[1] >> 32;
  1144	
  1145		bitmap_from_arr32(cpu_pmu->pmceid_ext_bitmap,
  1146				     pmceid, ARMV8_PMUV3_MAX_COMMON_EVENTS);
  1147	
  1148		/* store PMMIR register for sysfs */
  1149		if (is_pmuv3p4(pmuver) && (pmceid_raw[1] & BIT(31)))
  1150			cpu_pmu->reg_pmmir = read_pmmir();
  1151		else
  1152			cpu_pmu->reg_pmmir = 0;
  1153	}
  1154	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
