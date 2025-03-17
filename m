Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E757B23BD13;
	Mon, 17 Mar 2025 13:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742216662; cv=none; b=a7xCP63YZXiBV2wp5C7vV/sHjcfwFt6vqJINiZ58GoCaT7IEoStC/em29EIDDiJ9SwjCbg5wYmDGsbA8pEEwJ+49vdM2qvBtmhI72u5WFE35dUxBdVRQB/xgk34lPeRVYgZmCVV89w2QQW79jJtaJ83idXfyyghXXezd/6OfWSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742216662; c=relaxed/simple;
	bh=avWQm9+Lsd7mcdmmO95x7pXu+JK1GASjUd85GeEepD8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yw1e+S1FqEWbbnknn1Kfoe98xrudawG3omfKWFyleM9Dfkm5Cv+90i0kaExexvUjMxZnjQA9eiwTRtbkcQE1bmbQMCdFAnu44B5nreuezl7jdAHDHizpsXH3EOtElVB7phmit89Cgs+CNIXg4KaF8tCsx5mPmHRyYIFtSDu3kFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=idFCwUGv; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="idFCwUGv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1742216662; x=1773752662;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=avWQm9+Lsd7mcdmmO95x7pXu+JK1GASjUd85GeEepD8=;
  b=idFCwUGv7eWfK0SAh2tTtVmpediCLdj0h3JY+uj0VMrQGshgorRiGjTG
   xfA7PVz2GU+dR2DgwVagJt88VLR90GkWWE0FwRQK7InaGSF5o7ITQS21n
   R2Nxg3usEu86+MYypoAhod8VUW8+slTlZYAF5S+LJq78FRrs41Vysv4zC
   +IFEcx5Y5HlfeRZiVd320BlKcyxCx09CFwWtWuXy33V8OTrrFE7/a4VOh
   oDVmqxXi/+5tRGkwUzISMsoE7IgOLHa06BxN00kQQF0uYfE0q1SgtlZLB
   lvA2D/QrYtZqvr26zafHA/2SWEiOkrBkRPv1BsBChOBA9tS/aKV8N0hok
   A==;
X-CSE-ConnectionGUID: dN+ZwMBIRNqUjAorDT1/CQ==
X-CSE-MsgGUID: QwnAESJoQ7urLHTLMQfnOQ==
X-IronPort-AV: E=McAfee;i="6700,10204,11376"; a="54305067"
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="54305067"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2025 06:04:21 -0700
X-CSE-ConnectionGUID: bbt9VKehS+WokJ9mNWpTwA==
X-CSE-MsgGUID: eOV9Vg5bQQCyL3Ssi9Q+IA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.14,254,1736841600"; 
   d="scan'208";a="127019800"
Received: from lkp-server02.sh.intel.com (HELO a4747d147074) ([10.239.97.151])
  by fmviesa004.fm.intel.com with ESMTP; 17 Mar 2025 06:04:08 -0700
Received: from kbuild by a4747d147074 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1tuA8P-000Ckv-1n;
	Mon, 17 Mar 2025 13:04:02 +0000
Date: Mon, 17 Mar 2025 21:02:47 +0800
From: kernel test robot <lkp@intel.com>
To: Akihiko Odaki <akihiko.odaki@daynix.com>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Andrew Jones <andrew.jones@linux.dev>
Cc: oe-kbuild-all@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	kvmarm@lists.linux.dev, linux-kernel@vger.kernel.org,
	devel@daynix.com, Akihiko Odaki <akihiko.odaki@daynix.com>
Subject: Re: [PATCH v5 3/5] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
Message-ID: <202503172023.fzyJ3TMB-lkp@intel.com>
References: <20250315-pmc-v5-3-ecee87dab216@daynix.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250315-pmc-v5-3-ecee87dab216@daynix.com>

Hi Akihiko,

kernel test robot noticed the following build errors:

[auto build test ERROR on 80e54e84911a923c40d7bee33a34c1b4be148d7a]

url:    https://github.com/intel-lab-lkp/linux/commits/Akihiko-Odaki/KVM-arm64-PMU-Set-raw-values-from-user-to-PM-C-I-NTEN-SET-CLR-PMOVS-SET-CLR/20250315-173731
base:   80e54e84911a923c40d7bee33a34c1b4be148d7a
patch link:    https://lore.kernel.org/r/20250315-pmc-v5-3-ecee87dab216%40daynix.com
patch subject: [PATCH v5 3/5] KVM: arm64: PMU: Fix SET_ONE_REG for vPMC regs
config: arm64-randconfig-r122-20250317 (https://download.01.org/0day-ci/archive/20250317/202503172023.fzyJ3TMB-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.2.0
reproduce: (https://download.01.org/0day-ci/archive/20250317/202503172023.fzyJ3TMB-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202503172023.fzyJ3TMB-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/kvm/sys_regs.c: In function 'set_pmu_evcntr':
>> arch/arm64/kvm/sys_regs.c:975:9: error: implicit declaration of function 'kvm_pmu_set_counter_value_user'; did you mean 'kvm_pmu_set_counter_value'? [-Wimplicit-function-declaration]
     975 |         kvm_pmu_set_counter_value_user(vcpu, idx, val);
         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
         |         kvm_pmu_set_counter_value


vim +975 arch/arm64/kvm/sys_regs.c

   962	
   963	static int set_pmu_evcntr(struct kvm_vcpu *vcpu, const struct sys_reg_desc *r,
   964				  u64 val)
   965	{
   966		u64 idx;
   967	
   968		if (r->CRn == 9 && r->CRm == 13 && r->Op2 == 0)
   969			/* PMCCNTR_EL0 */
   970			idx = ARMV8_PMU_CYCLE_IDX;
   971		else
   972			/* PMEVCNTRn_EL0 */
   973			idx = ((r->CRm & 3) << 3) | (r->Op2 & 7);
   974	
 > 975		kvm_pmu_set_counter_value_user(vcpu, idx, val);
   976		return 0;
   977	}
   978	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
