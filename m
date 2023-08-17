Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F5E803;
	Thu, 17 Aug 2023 05:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1692248664; x=1723784664;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=eGAo3CKDuFdSelabgpUj3MV0KM14lEa4HJoAlNa67+w=;
  b=ZkPPeJZu5A3e5LlSGW8Tr3Y2NxswKtJadDXBRzH7fuqfVtfJ16x+Bm6/
   5wD9Dde60XGcFspKMIsGUuE/9rNyJDdzwnJf5c4X/E+fzxkT1W192ZOBM
   9NZXH5zIC9OBmZDWvHWdvTY0WxaZOp4x/JeHUtQuNAWKpieBlRtT0sO+j
   uyKrHP2RJXTtXDVh0iONHq2PAWqOrYe7fiwuAYaQojRWNib08DgvkBFZy
   RZl3RZx+6iSlpsDdX2OABxNmNT/d6nC6HkU+ahGkDdxCWY24vjThMSovo
   cyg34PIk6mi506Bks0BobuKmk7eEzzQZgwH3sgJ4NKVErv+r2Xc9YAFBx
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="372712793"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="372712793"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Aug 2023 22:04:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10803"; a="763895792"
X-IronPort-AV: E=Sophos;i="6.01,179,1684825200"; 
   d="scan'208";a="763895792"
Received: from lkp-server02.sh.intel.com (HELO a9caf1a0cf30) ([10.239.97.151])
  by orsmga008.jf.intel.com with ESMTP; 16 Aug 2023 22:04:17 -0700
Received: from kbuild by a9caf1a0cf30 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qWVBB-0000o6-0C;
	Thu, 17 Aug 2023 05:04:17 +0000
Date: Thu, 17 Aug 2023 13:03:28 +0800
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
Subject: Re: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the
 guest on vCPU reset
Message-ID: <202308171212.KW8LnRRC-lkp@intel.com>
References: <20230817003029.3073210-3-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230817003029.3073210-3-rananta@google.com>

Hi Raghavendra,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 2ccdd1b13c591d306f0401d98dedc4bdcd02b421]

url:    https://github.com/intel-lab-lkp/linux/commits/Raghavendra-Rao-Ananta/KVM-arm64-PMU-Introduce-a-helper-to-set-the-guest-s-PMU/20230817-083353
base:   2ccdd1b13c591d306f0401d98dedc4bdcd02b421
patch link:    https://lore.kernel.org/r/20230817003029.3073210-3-rananta%40google.com
patch subject: [PATCH v5 02/12] KVM: arm64: PMU: Set the default PMU for the guest on vCPU reset
config: arm64-randconfig-r032-20230817 (https://download.01.org/0day-ci/archive/20230817/202308171212.KW8LnRRC-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce: (https://download.01.org/0day-ci/archive/20230817/202308171212.KW8LnRRC-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308171212.KW8LnRRC-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/arm64/kernel/asm-offsets.c:16:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/arm64/include/asm/kvm_host.h:37:
>> include/kvm/arm_pmu.h:176:62: warning: declaration of 'struct arm_pmu' will not be visible outside of this function [-Wvisibility]
     176 | static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
         |                                                              ^
   1 warning generated.
--
   In file included from arch/arm64/kernel/asm-offsets.c:16:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/arm64/include/asm/kvm_host.h:37:
>> include/kvm/arm_pmu.h:176:62: warning: declaration of 'struct arm_pmu' will not be visible outside of this function [-Wvisibility]
     176 | static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
         |                                                              ^
   1 warning generated.


vim +176 include/kvm/arm_pmu.h

   175	
 > 176	static inline int kvm_arm_set_vm_pmu(struct kvm *kvm, struct arm_pmu *arm_pmu)
   177	{
   178		return -ENODEV;
   179	}
   180	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
