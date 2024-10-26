Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927C51FC3;
	Sat, 26 Oct 2024 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729939382; cv=none; b=bhTd55DQpij03OMoMryWKtmTgPkL0fRArEpQg0OdQ1iVN3oYnOt5Wxrtm9mmDquHENmp6SxTOgwfloQqk3DWlICp1zpXxnfsQywISIfNPkC2gDm1ETLE+uUrQesZo/YLb35U5flkpnOZ99b/ltZwIoppGjE1kqU0/HSE04jw9+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729939382; c=relaxed/simple;
	bh=9gVwNcR3yel3JsSy5pGYF3kpnt/UQMXBg0o/oFDzLJc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KhWs0/Qo9BVyj7RyRajbg6PNunqRpIEUJqtdmTzf5E46Rh+AgUZ9L8YHkIp9EY27+vXUqnvexZLPq0atN5P+HCbnjjS2Anr7GBVM88Vh8Ku16gTxR+EI/al9nwfaeP6CBnroL2/kDiRy7l8LkH/iya3sgzgaAXVE0oED1sGGsUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=h1a3cyYI; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="h1a3cyYI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729939380; x=1761475380;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9gVwNcR3yel3JsSy5pGYF3kpnt/UQMXBg0o/oFDzLJc=;
  b=h1a3cyYI3XC0KafLz1fuyHTIK6dxGkWFfbDcrSlpG1WWoOzAbF2hjphA
   cuVSk+/RbiLKDMFV8erdhwMOi86vbyvszB0SrEWiSdpAhrtQHIGG8fotB
   pFuMWXsWcldBZ5eM8dZID4JD+EFzYzdGh6q42JDQ0d28euZ77y8c23F0u
   2nZ+Cmx71Pyhz28IduFn1wC1Gj6ddIW2eS/G2rHdf7wBjfr8U81MHmMx1
   ZFMjLBkn8MT/LVGTuxaxf1uezd4SMm7vhS3amw0oft3nhSIpB+vzcM/zG
   CfEEgPUJXSKC+HevkA9YzyaJ/GYa8ueN9Fxgqo9SMJb7X9677wOO1nLmA
   w==;
X-CSE-ConnectionGUID: bn9F08RaTByXPwMuldCJeQ==
X-CSE-MsgGUID: JkeDgYdCQfugXmdpvojxRg==
X-IronPort-AV: E=McAfee;i="6700,10204,11236"; a="29064884"
X-IronPort-AV: E=Sophos;i="6.11,234,1725346800"; 
   d="scan'208";a="29064884"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Oct 2024 03:43:00 -0700
X-CSE-ConnectionGUID: mMOIbCyXRwyZRGGBfDLOfw==
X-CSE-MsgGUID: S0CHul1SSlCWgangkFYJUg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,234,1725346800"; 
   d="scan'208";a="81079534"
Received: from lkp-server01.sh.intel.com (HELO a48cf1aa22e8) ([10.239.97.150])
  by orviesa010.jf.intel.com with ESMTP; 26 Oct 2024 03:42:57 -0700
Received: from kbuild by a48cf1aa22e8 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1t4eFz-000ZWs-0K;
	Sat, 26 Oct 2024 10:42:55 +0000
Date: Sat, 26 Oct 2024 18:42:05 +0800
From: kernel test robot <lkp@intel.com>
To: Oliver Upton <oliver.upton@linux.dev>, kvmarm@lists.linux.dev
Cc: oe-kbuild-all@lists.linux.dev, Marc Zyngier <maz@kernel.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Oliver Upton <oliver.upton@linux.dev>
Subject: Re: [PATCH v4 10/18] KVM: arm64: nv: Describe trap behaviour of
 MDCR_EL2.HPMN
Message-ID: <202410261839.enJ68VEv-lkp@intel.com>
References: <20241025182354.3364124-11-oliver.upton@linux.dev>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241025182354.3364124-11-oliver.upton@linux.dev>

Hi Oliver,

kernel test robot noticed the following build errors:

[auto build test ERROR on 8e929cb546ee42c9a61d24fae60605e9e3192354]

url:    https://github.com/intel-lab-lkp/linux/commits/Oliver-Upton/KVM-arm64-Extend-masking-facility-to-arbitrary-registers/20241026-023055
base:   8e929cb546ee42c9a61d24fae60605e9e3192354
patch link:    https://lore.kernel.org/r/20241025182354.3364124-11-oliver.upton%40linux.dev
patch subject: [PATCH v4 10/18] KVM: arm64: nv: Describe trap behaviour of MDCR_EL2.HPMN
config: arm64-randconfig-004-20241026 (https://download.01.org/0day-ci/archive/20241026/202410261839.enJ68VEv-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241026/202410261839.enJ68VEv-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410261839.enJ68VEv-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/kvm/emulate-nested.c: In function 'check_mdcr_hpmn':
>> arch/arm64/kvm/emulate-nested.c:532:13: error: too many arguments to function 'kvm_pmu_counter_is_hyp'
     532 |         if (kvm_pmu_counter_is_hyp(vcpu, idx))
         |             ^~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/arm64/include/asm/kvm_host.h:38,
                    from include/linux/kvm_host.h:45,
                    from arch/arm64/kvm/emulate-nested.c:8:
   include/kvm/arm_pmu.h:191:20: note: declared here
     191 | static inline bool kvm_pmu_counter_is_hyp(struct kvm_vcpu *vcpu)
         |                    ^~~~~~~~~~~~~~~~~~~~~~


vim +/kvm_pmu_counter_is_hyp +532 arch/arm64/kvm/emulate-nested.c

   509	
   510	static enum trap_behaviour check_mdcr_hpmn(struct kvm_vcpu *vcpu)
   511	{
   512		u32 sysreg = esr_sys64_to_sysreg(kvm_vcpu_get_esr(vcpu));
   513		unsigned int idx;
   514	
   515	
   516		switch (sysreg) {
   517		case SYS_PMEVTYPERn_EL0(0) ... SYS_PMEVTYPERn_EL0(30):
   518		case SYS_PMEVCNTRn_EL0(0) ... SYS_PMEVCNTRn_EL0(30):
   519			idx = (sys_reg_CRm(sysreg) & 0x3) << 3 | sys_reg_Op2(sysreg);
   520			break;
   521		case SYS_PMXEVTYPER_EL0:
   522		case SYS_PMXEVCNTR_EL0:
   523			idx = SYS_FIELD_GET(PMSELR_EL0, SEL,
   524					    __vcpu_sys_reg(vcpu, PMSELR_EL0));
   525			break;
   526		default:
   527			/* Someone used this trap helper for something else... */
   528			KVM_BUG_ON(1, vcpu->kvm);
   529			return BEHAVE_HANDLE_LOCALLY;
   530		}
   531	
 > 532		if (kvm_pmu_counter_is_hyp(vcpu, idx))
   533			return BEHAVE_FORWARD_RW | BEHAVE_IN_HOST_EL0;
   534	
   535		return BEHAVE_HANDLE_LOCALLY;
   536	}
   537	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
