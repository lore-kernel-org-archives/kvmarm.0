Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51567491;
	Sat, 18 Nov 2023 22:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="X0yyO0Dg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1700347264; x=1731883264;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jAQNNV1z7r334YDJaTsioBs4WcXpEA1NZbQjb4AZh6o=;
  b=X0yyO0Dgve22L4AbLei00gxqhVLjHCm+huY7WmdWl9bAMb42dxaXAUNs
   QdOcrEHNudRH75lLVjLLhEFQOpqwvGIx31M/rQYcbn6W4hej7er+C/fJL
   5tWmeWzu7mndPredpKRZ2hMtvD11FAWxBX8tiaPW7c1+v5q/v5FLjxvbv
   hMRx5uqOMek9+AJHIe/Z68rsi6bmxpRZ3Lc6tvSVYHdwrB6kyPGa5Zc4F
   CXcSnNb+oMGjni19IxJuAYyLSHzGb5H+TN5e59X4GRqKrt9iFSkrAgzdt
   ap5TXZctNT8ck5V5JGB6fgMK19fsOU5t7ZWVW2NNVj8CWCPvWxKrXnrKg
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10898"; a="391241710"
X-IronPort-AV: E=Sophos;i="6.04,209,1695711600"; 
   d="scan'208";a="391241710"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2023 14:41:03 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10898"; a="769531835"
X-IronPort-AV: E=Sophos;i="6.04,209,1695711600"; 
   d="scan'208";a="769531835"
Received: from lkp-server02.sh.intel.com (HELO b8de5498638e) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 18 Nov 2023 14:40:59 -0800
Received: from kbuild by b8de5498638e with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1r4Tzl-0004Ox-0H;
	Sat, 18 Nov 2023 22:40:57 +0000
Date: Sun, 19 Nov 2023 06:39:57 +0800
From: kernel test robot <lkp@intel.com>
To: Sebastian Ene <sebastianene@google.com>, will@kernel.org,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>, catalin.marinas@arm.com,
	mark.rutland@arm.com, akpm@linux-foundation.org, maz@kernel.org
Cc: oe-kbuild-all@lists.linux.dev, kvmarm@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	kernel-team@android.com, vdonnefort@google.com, qperret@google.com,
	smostafa@google.com, Sebastian Ene <sebastianene@google.com>
Subject: Re: [PATCH v3 07/10] arm64: ptdump: Parse the host stage-2
 page-tables from the snapshot
Message-ID: <202311190602.TfLBzLiV-lkp@intel.com>
References: <20231115171639.2852644-9-sebastianene@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231115171639.2852644-9-sebastianene@google.com>

Hi Sebastian,

kernel test robot noticed the following build warnings:

[auto build test WARNING on arm64/for-next/core]
[also build test WARNING on kvmarm/next linus/master v6.7-rc1 next-20231117]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Sebastian-Ene/KVM-arm64-Add-snap-shooting-the-host-stage-2-pagetables/20231116-012017
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20231115171639.2852644-9-sebastianene%40google.com
patch subject: [PATCH v3 07/10] arm64: ptdump: Parse the host stage-2 page-tables from the snapshot
config: arm64-randconfig-r071-20231119 (https://download.01.org/0day-ci/archive/20231119/202311190602.TfLBzLiV-lkp@intel.com/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20231119/202311190602.TfLBzLiV-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202311190602.TfLBzLiV-lkp@intel.com/

All warnings (new ones prefixed by >>):

>> arch/arm64/mm/ptdump.c:178:31: warning: unused variable 'stage2_pte_bits' [-Wunused-const-variable]
     178 | static const struct prot_bits stage2_pte_bits[] = {
         |                               ^
   1 warning generated.


vim +/stage2_pte_bits +178 arch/arm64/mm/ptdump.c

   177	
 > 178	static const struct prot_bits stage2_pte_bits[] = {
   179		{
   180			.mask	= PTE_VALID,
   181			.val	= PTE_VALID,
   182			.set	= " ",
   183			.clear	= "F",
   184		}, {
   185			.mask	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
   186			.val	= KVM_PTE_LEAF_ATTR_HI_S2_XN,
   187			.set	= "XN",
   188			.clear	= "  ",
   189		}, {
   190			.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
   191			.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_R,
   192			.set	= "R",
   193			.clear	= " ",
   194		}, {
   195			.mask	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
   196			.val	= KVM_PTE_LEAF_ATTR_LO_S2_S2AP_W,
   197			.set	= "W",
   198			.clear	= " ",
   199		}, {
   200			.mask	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
   201			.val	= KVM_PTE_LEAF_ATTR_LO_S2_AF,
   202			.set	= "AF",
   203			.clear	= "  ",
   204		}, {
   205			.mask	= PTE_NG,
   206			.val	= PTE_NG,
   207			.set	= "FnXS",
   208			.clear	= "  ",
   209		}, {
   210			.mask	= PTE_CONT,
   211			.val	= PTE_CONT,
   212			.set	= "CON",
   213			.clear	= "   ",
   214		}, {
   215			.mask	= PTE_TABLE_BIT,
   216			.val	= PTE_TABLE_BIT,
   217			.set	= "   ",
   218			.clear	= "BLK",
   219		}, {
   220			.mask	= KVM_PGTABLE_PROT_SW0,
   221			.val	= KVM_PGTABLE_PROT_SW0,
   222			.set	= "SW0", /* PKVM_PAGE_SHARED_OWNED */
   223		}, {
   224			.mask   = KVM_PGTABLE_PROT_SW1,
   225			.val	= KVM_PGTABLE_PROT_SW1,
   226			.set	= "SW1", /* PKVM_PAGE_SHARED_BORROWED */
   227		}, {
   228			.mask	= KVM_PGTABLE_PROT_SW2,
   229			.val	= KVM_PGTABLE_PROT_SW2,
   230			.set	= "SW2",
   231		}, {
   232			.mask   = KVM_PGTABLE_PROT_SW3,
   233			.val	= KVM_PGTABLE_PROT_SW3,
   234			.set	= "SW3",
   235		},
   236	};
   237	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
