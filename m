Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BE7023BCEE;
	Tue, 10 Feb 2026 04:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770699103; cv=none; b=Yzw9olddBk2rkkOZmv0xsJ3F03BKWSK8yEbKlM/nlsoF/s7XLBylKADfL7ylKTAJsvJG7O4o+ifsxbI791sZoJJdKSYxY1KehDRnFjBcyPH54U4IP6Vu+FuwwsObMOkSHY196cMKvdUoTSjGI6CA2A3/8JpIBOxcRY03gnk8YFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770699103; c=relaxed/simple;
	bh=sdVn/Ig/goNcDcWLdyb5V3vbF0uqZltYsRh8bFBXC38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cTbbkRnbUs3S5QQn7Gg0Fde5pvq8xhoUF8ZFAh5bwaSjIDBGp3NuBjQUNugCJdq1wG737mA4wao+ozOdLMOb2uX4UT2zJj/XRU1MkYoTqVZXFqiMMBHJ1av1fEquKv4ZwSSIig/BOLF1vbUKl3puPWjvWrwsc3Byb0C89V73jLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=T+mauGN7; arc=none smtp.client-ip=198.175.65.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="T+mauGN7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770699101; x=1802235101;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=sdVn/Ig/goNcDcWLdyb5V3vbF0uqZltYsRh8bFBXC38=;
  b=T+mauGN7erI4paW1yUcHfk/zc3gVzriHU8O+8sTRxoJmEVFAaY5YGo3f
   +cj3esNRlzpV+F0GopN5jP1zPDvFS5R8Ooe7Ohy1tMHNnjAL/0Rs43E/b
   Usf4eOFaER7+4VIuOsAXK18iBG6Ednh4JWZknz5aHi2TTdYhH4hHe8UYC
   7W1ZKZMLnj8BIIjOHlhGS4FNH7kGcyZ4iqkblq6GsiXd8KRRbK7V9wQnQ
   yassKh7WslQL/daoY59kFM7B0S7xlaYhrsCm/b5xTfxaujHWlERF43DpW
   58gebSrrqEmwKhQtJDXYxhqY2lERb0wQEprDmoD8mB2JMap4LQh7gR7+N
   w==;
X-CSE-ConnectionGUID: uDjaybuNQKapQTh94zSqJQ==
X-CSE-MsgGUID: ZzIkaQaORpqPNcyNsiTlkQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="75445239"
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="75445239"
Received: from orviesa003.jf.intel.com ([10.64.159.143])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 20:51:33 -0800
X-CSE-ConnectionGUID: z4MKFQY1QtCAzMNLgWuSKg==
X-CSE-MsgGUID: frORhow2SfqYp6Rr+sBB2w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,283,1763452800"; 
   d="scan'208";a="215972172"
Received: from lkp-server01.sh.intel.com (HELO 765f4a05e27f) ([10.239.97.150])
  by orviesa003.jf.intel.com with ESMTP; 09 Feb 2026 20:51:23 -0800
Received: from kbuild by 765f4a05e27f with local (Exim 4.98.2)
	(envelope-from <lkp@intel.com>)
	id 1vpfia-00000000oei-3BRb;
	Tue, 10 Feb 2026 04:51:20 +0000
Date: Tue, 10 Feb 2026 12:51:19 +0800
From: kernel test robot <lkp@intel.com>
To: Colton Lewis <coltonlewis@google.com>, kvm@vger.kernel.org
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Alexandru Elisei <alexandru.elisei@arm.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	Mingwei Zhang <mizhang@google.com>, Joey Gouly <joey.gouly@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Zenghui Yu <yuzenghui@huawei.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev,
	linux-perf-users@vger.kernel.org, linux-kselftest@vger.kernel.org,
	Colton Lewis <coltonlewis@google.com>
Subject: Re: [PATCH v6 14/19] perf: arm_pmuv3: Handle IRQs for Partitioned
 PMU guest counters
Message-ID: <202602101258.VRaEHc98-lkp@intel.com>
References: <20260209221414.2169465-15-coltonlewis@google.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260209221414.2169465-15-coltonlewis@google.com>

Hi Colton,

kernel test robot noticed the following build warnings:

[auto build test WARNING on 63804fed149a6750ffd28610c5c1c98cce6bd377]

url:    https://github.com/intel-lab-lkp/linux/commits/Colton-Lewis/arm64-cpufeature-Add-cpucap-for-HPMN0/20260210-064939
base:   63804fed149a6750ffd28610c5c1c98cce6bd377
patch link:    https://lore.kernel.org/r/20260209221414.2169465-15-coltonlewis%40google.com
patch subject: [PATCH v6 14/19] perf: arm_pmuv3: Handle IRQs for Partitioned PMU guest counters
config: arm64-randconfig-001-20260210 (https://download.01.org/0day-ci/archive/20260210/202602101258.VRaEHc98-lkp@intel.com/config)
compiler: clang version 22.0.0git (https://github.com/llvm/llvm-project 9b8addffa70cee5b2acc5454712d9cf78ce45710)
rustc: rustc 1.88.0 (6b00bc388 2025-06-23)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260210/202602101258.VRaEHc98-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202602101258.VRaEHc98-lkp@intel.com/

All warnings (new ones prefixed by >>):

   In file included from arch/arm64/kernel/asm-offsets.c:16:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/arm64/include/asm/kvm_host.h:38:
>> include/kvm/arm_pmu.h:310:52: warning: declaration of 'struct arm_pmu' will not be visible outside of this function [-Wvisibility]
     310 | static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr) {}
         |                                                    ^
   include/kvm/arm_pmu.h:281:12: warning: unused function 'kvm_vcpu_read_pmuserenr' [-Wunused-function]
     281 | static u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu)
         |            ^~~~~~~~~~~~~~~~~~~~~~~
   2 warnings generated.
--
   In file included from arch/arm64/kernel/asm-offsets.c:16:
   In file included from include/linux/kvm_host.h:45:
   In file included from arch/arm64/include/asm/kvm_host.h:38:
>> include/kvm/arm_pmu.h:310:52: warning: declaration of 'struct arm_pmu' will not be visible outside of this function [-Wvisibility]
   310 | static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr) {}
   |                                                    ^
   include/kvm/arm_pmu.h:281:12: warning: unused function 'kvm_vcpu_read_pmuserenr' [-Wunused-function]
   281 | static u64 kvm_vcpu_read_pmuserenr(struct kvm_vcpu *vcpu)
   |            ^~~~~~~~~~~~~~~~~~~~~~~
   2 warnings generated.
   warning: unused variable: `args`
   --> rust/kernel/kunit.rs:19:12
   |
   19 | pub fn err(args: fmt::Arguments<'_>) {
   |            ^^^^ help: if this is intentional, prefix it with an underscore: `_args`
   |
   = note: `#[warn(unused_variables)]` on by default


vim +310 include/kvm/arm_pmu.h

   307	
   308	static inline void kvm_pmu_host_counters_enable(void) {}
   309	static inline void kvm_pmu_host_counters_disable(void) {}
 > 310	static inline void kvm_pmu_handle_guest_irq(struct arm_pmu *pmu, u64 pmovsr) {}
   311	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
