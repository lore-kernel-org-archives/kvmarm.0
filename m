Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.93])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49F92634;
	Thu, 10 Aug 2023 01:40:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691631659; x=1723167659;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3m4JFu59Pv1cZ4RPpIvRJu61Mts2YXt4oS7PC2gaRSg=;
  b=G6HEofTU6yS8+jc8YUm6F14XUQKSrWVZfhvxiNjVncW5BlEbP/eKrjm/
   vcK+IZz/Bxlsvwd1G3TfGM63urUdDpInWAtDTCpMbbFyioV1Mq7CSEVcO
   +XahSr6t8lFqikg9xRYFZrjFPkGtIP3Y1WOcxAukaCUbRbHbzwc3pCFXo
   0opAvdiPU+eo9I+XaqN5FK2cRKDl1YNYdtwXdRXIEP+PRAO9aHQXCd0Kk
   JrI+W4wW0sg6lDqX4auSBkqwAReAIwZ/FJtBT4c3EkYY2naqnuXHOLYzX
   u2Lw0T94+B/4NC8rWfGnfMLeONKIHgrFam/ejTK5B9SCmBZNpt9prNoiN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="368730068"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="368730068"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 18:40:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="735214618"
X-IronPort-AV: E=Sophos;i="6.01,160,1684825200"; 
   d="scan'208";a="735214618"
Received: from lkp-server01.sh.intel.com (HELO d1ccc7e87e8f) ([10.239.97.150])
  by fmsmga007.fm.intel.com with ESMTP; 09 Aug 2023 18:40:52 -0700
Received: from kbuild by d1ccc7e87e8f with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1qTufU-0006ai-01;
	Thu, 10 Aug 2023 01:40:52 +0000
Date: Thu, 10 Aug 2023 09:40:42 +0800
From: kernel test robot <lkp@intel.com>
To: Raghavendra Rao Ananta <rananta@google.com>,
	Oliver Upton <oliver.upton@linux.dev>,
	Marc Zyngier <maz@kernel.org>, James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>, Anup Patel <anup@brainfault.org>,
	Atish Patra <atishp@atishpatra.org>,
	Jing Zhang <jingzhangos@google.com>,
	Reiji Watanabe <reijiw@google.com>,
	Colton Lewis <coltonlewis@google.com>,
	Raghavendra Rao Anata <rananta@google.com>,
	David Matlack <dmatlack@google.com>, Fuad Tabba <tabba@google.com>,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-mips@vger.kernel.org, kvm-riscv@lists.infradead.org,
	linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
	kvm@vger.kernel.org, Gavin Shan <gshan@redhat.com>,
	Shaoqin Huang <shahuang@redhat.com>
Subject: Re: [PATCH v8 11/14] KVM: arm64: Implement
 kvm_arch_flush_remote_tlbs_range()
Message-ID: <202308100953.kGcDpe5z-lkp@intel.com>
References: <20230808231330.3855936-12-rananta@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230808231330.3855936-12-rananta@google.com>

Hi Raghavendra,

kernel test robot noticed the following build errors:

[auto build test ERROR on kvm/queue]
[also build test ERROR on kvmarm/next arm64/for-next/core linus/master v6.5-rc5 next-20230809]
[cannot apply to kvm/linux-next]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Raghavendra-Rao-Ananta/KVM-Rename-kvm_arch_flush_remote_tlb-to-kvm_arch_flush_remote_tlbs/20230809-071643
base:   https://git.kernel.org/pub/scm/virt/kvm/kvm.git queue
patch link:    https://lore.kernel.org/r/20230808231330.3855936-12-rananta%40google.com
patch subject: [PATCH v8 11/14] KVM: arm64: Implement kvm_arch_flush_remote_tlbs_range()
config: arm64-randconfig-r023-20230809 (https://download.01.org/0day-ci/archive/20230810/202308100953.kGcDpe5z-lkp@intel.com/config)
compiler: clang version 15.0.7 (https://github.com/llvm/llvm-project.git 8dfdcc7b7bf66834a761bd8de445840ef68e4d1a)
reproduce: (https://download.01.org/0day-ci/archive/20230810/202308100953.kGcDpe5z-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202308100953.kGcDpe5z-lkp@intel.com/

All errors (new ones prefixed by >>):

>> arch/arm64/kvm/mmu.c:179:5: error: use of undeclared identifier 'start_gfn'
                                   start_gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
                                   ^
   1 error generated.


vim +/start_gfn +179 arch/arm64/kvm/mmu.c

   174	
   175	int kvm_arch_flush_remote_tlbs_range(struct kvm *kvm,
   176					      gfn_t gfn, u64 nr_pages)
   177	{
   178		kvm_tlb_flush_vmid_range(&kvm->arch.mmu,
 > 179					start_gfn << PAGE_SHIFT, nr_pages << PAGE_SHIFT);
   180		return 0;
   181	}
   182	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
