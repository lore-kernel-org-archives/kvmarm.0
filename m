Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDC319E98B;
	Wed,  2 Oct 2024 23:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727911610; cv=none; b=LF5f4Y/Gwn/1pGCLn4D/YpfYbsuXyI1QMEO7LoDldjHLEL5qakUnGE+VuX/k+zXF8q8utAGWt6DP6Ohe8ctXDjV5SbQKLCTlYsB9Oi9djHTzTIU2ouAOKuAjg4Tj3O0yAvIZRQFOHjlgcQC5zWRWHYkV69HhjQ/k5uqGnKJge60=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727911610; c=relaxed/simple;
	bh=Bx1+aEjY4Mab84Om3l4Tfqvl2SfGkalmYR006mR1fPU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uaT9eooaPX/n9kkMI5Gds99mT3yWM4qx7D6/vKa6MOJS78FRCmqjSy3TIor4YHDYMDCb+u3hXLqD0xnNT9Vv2XL7sQJSUUZR/hIxKqMdiRqe7F+uq9HrSXeRwSRpLQmkAYST1bsohIqHt3QekPpbENx6//CHVcjlM7GztxEAtTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=MssdnEKl; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="MssdnEKl"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727911607; x=1759447607;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Bx1+aEjY4Mab84Om3l4Tfqvl2SfGkalmYR006mR1fPU=;
  b=MssdnEKlKvPoPDcA6BGuUcT4BHzfYkg9RtggaifAnfSF5iBH8lObMFfq
   JNaQBv+iAsGGv7tlSbnyTCFhgSCSRrbErbGm2hgKnzirBRrEuGpAOt73E
   Igmd78WGmqSVfn3+rZGXeHqCs6DS+CvFKJ4TPHNUkezBSV2NSuH+VtPO+
   y2/dNb6BvLG8WUcbO+ZMtFE5XOjjGeYF2LXJ9n+OO1MmeBPK3tuTVFuha
   QMSRj60tWzMcyUwoq25fbCMuoAhoqIZYmFZuMAzl0CslnpJCw2jI62b+o
   1D/49EuxvyquHhV/24QLf+jpWfTRqssNpX0SKlpkIrjf50VLSzon6/gmB
   Q==;
X-CSE-ConnectionGUID: 0m9RkqxeRIijwILZu9fS5A==
X-CSE-MsgGUID: HyF/lf3VRROaxlVRyfyT0Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11213"; a="29967238"
X-IronPort-AV: E=Sophos;i="6.11,173,1725346800"; 
   d="scan'208";a="29967238"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2024 16:26:46 -0700
X-CSE-ConnectionGUID: TnCG7wI0Rl+5kEDx2o7m/g==
X-CSE-MsgGUID: WsaM2iE9Sf+nVYEdT2P1gA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,173,1725346800"; 
   d="scan'208";a="74158158"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by fmviesa009.fm.intel.com with ESMTP; 02 Oct 2024 16:26:44 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sw8jx-000UgZ-00;
	Wed, 02 Oct 2024 23:26:41 +0000
Date: Thu, 3 Oct 2024 07:25:59 +0800
From: kernel test robot <lkp@intel.com>
To: Anshuman Khandual <anshuman.khandual@arm.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: oe-kbuild-all@lists.linux.dev,
	Anshuman Khandual <anshuman.khandual@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
	Oliver Upton <oliver.upton@linux.dev>,
	James Morse <james.morse@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev,
	linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/3] arm64/boot: Enable EL2 requirements for
 FEAT_Debugv8p9
Message-ID: <202410030737.Mxx9Cvge-lkp@intel.com>
References: <20241001043602.1116991-3-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001043602.1116991-3-anshuman.khandual@arm.com>

Hi Anshuman,

kernel test robot noticed the following build errors:

[auto build test ERROR on arm64/for-next/core]
[also build test ERROR on kvmarm/next soc/for-next arm/for-next arm/fixes linus/master v6.12-rc1 next-20241002]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anshuman-Khandual/arm64-cpufeature-Add-field-details-for-ID_AA64DFR1_EL1-register/20241001-123752
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20241001043602.1116991-3-anshuman.khandual%40arm.com
patch subject: [PATCH 2/3] arm64/boot: Enable EL2 requirements for FEAT_Debugv8p9
config: arm64-allnoconfig (https://download.01.org/0day-ci/archive/20241003/202410030737.Mxx9Cvge-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241003/202410030737.Mxx9Cvge-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410030737.Mxx9Cvge-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/kernel/head.S: Assembler messages:
>> arch/arm64/kernel/head.S:550: Error: non-constant expression in ".if" statement
   arch/arm64/kernel/head.S:237:  Info: macro invoked from here
   arch/arm64/kernel/head.S:269:   Info: macro invoked from here
   arch/arm64/kernel/head.S:317:    Info: macro invoked from here
   arch/arm64/kernel/head.S:553: Error: non-constant expression in ".if" statement
   arch/arm64/kernel/head.S:237:  Info: macro invoked from here
   arch/arm64/kernel/head.S:269:   Info: macro invoked from here
   arch/arm64/kernel/head.S:317:    Info: macro invoked from here
>> arch/arm64/kernel/head.S:1094: Error: constant expression required
   arch/arm64/kernel/head.S:238:  Info: macro invoked from here
   arch/arm64/kernel/head.S:269:   Info: macro invoked from here
   arch/arm64/kernel/head.S:317:    Info: macro invoked from here
>> arch/arm64/kernel/head.S:1094: Error: constant expression required
   arch/arm64/kernel/head.S:239:  Info: macro invoked from here
   arch/arm64/kernel/head.S:269:   Info: macro invoked from here
   arch/arm64/kernel/head.S:317:    Info: macro invoked from here
>> arch/arm64/kernel/head.S:317: Error: undefined symbol ID_AA64MMFR0_EL1_FGT_FGT2 used as an immediate value


vim +317 arch/arm64/kernel/head.S

034edabe6cf1d0d Laura Abbott    2014-11-21  246  
034edabe6cf1d0d Laura Abbott    2014-11-21  247  /*
034edabe6cf1d0d Laura Abbott    2014-11-21  248   * end early head section, begin head code that is also used for
034edabe6cf1d0d Laura Abbott    2014-11-21  249   * hotplug and needs to have the same protections as the text region
034edabe6cf1d0d Laura Abbott    2014-11-21  250   */
d54170812ef1c80 Mark Rutland    2023-02-20  251  	.section ".idmap.text","a"
f80fb3a3d50843a Ard Biesheuvel  2016-01-26  252  
9703d9d7f77ce12 Catalin Marinas 2012-03-05  253  /*
ecbb11ab3ebc027 Mark Rutland    2020-11-13  254   * Starting from EL2 or EL1, configure the CPU to execute at the highest
ecbb11ab3ebc027 Mark Rutland    2020-11-13  255   * reachable EL supported by the kernel in a chosen default state. If dropping
ecbb11ab3ebc027 Mark Rutland    2020-11-13  256   * from EL2 to EL1, configure EL2 before configuring EL1.
828e9834e9a5b7e Matthew Leach   2013-10-11  257   *
d87a8e65b510112 Mark Rutland    2020-11-13  258   * Since we cannot always rely on ERET synchronizing writes to sysregs (e.g. if
d87a8e65b510112 Mark Rutland    2020-11-13  259   * SCTLR_ELx.EOS is clear), we place an ISB prior to ERET.
828e9834e9a5b7e Matthew Leach   2013-10-11  260   *
b65e411d6cc2f12 Marc Zyngier    2022-06-30  261   * Returns either BOOT_CPU_MODE_EL1 or BOOT_CPU_MODE_EL2 in x0 if
b65e411d6cc2f12 Marc Zyngier    2022-06-30  262   * booted in EL1 or EL2 respectively, with the top 32 bits containing
b65e411d6cc2f12 Marc Zyngier    2022-06-30  263   * potential context flags. These flags are *not* stored in __boot_cpu_mode.
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  264   *
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  265   * x0: whether we are being called from the primary boot path with the MMU on
9703d9d7f77ce12 Catalin Marinas 2012-03-05  266   */
ecbb11ab3ebc027 Mark Rutland    2020-11-13  267  SYM_FUNC_START(init_kernel_el)
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  268  	mrs	x1, CurrentEL
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  269  	cmp	x1, #CurrentEL_EL2
d87a8e65b510112 Mark Rutland    2020-11-13  270  	b.eq	init_el2
d87a8e65b510112 Mark Rutland    2020-11-13  271  
d87a8e65b510112 Mark Rutland    2020-11-13  272  SYM_INNER_LABEL(init_el1, SYM_L_LOCAL)
31a32b49b80f79c Marc Zyngier    2021-04-08  273  	mov_q	x0, INIT_SCTLR_EL1_MMU_OFF
9d7c13e5dde3127 Ard Biesheuvel  2023-01-11  274  	pre_disable_mmu_workaround
31a32b49b80f79c Marc Zyngier    2021-04-08  275  	msr	sctlr_el1, x0
9cf71728931a407 Matthew Leach   2013-10-11  276  	isb
d87a8e65b510112 Mark Rutland    2020-11-13  277  	mov_q	x0, INIT_PSTATE_EL1
d87a8e65b510112 Mark Rutland    2020-11-13  278  	msr	spsr_el1, x0
d87a8e65b510112 Mark Rutland    2020-11-13  279  	msr	elr_el1, lr
d87a8e65b510112 Mark Rutland    2020-11-13  280  	mov	w0, #BOOT_CPU_MODE_EL1
d87a8e65b510112 Mark Rutland    2020-11-13  281  	eret
9703d9d7f77ce12 Catalin Marinas 2012-03-05  282  
d87a8e65b510112 Mark Rutland    2020-11-13  283  SYM_INNER_LABEL(init_el2, SYM_L_LOCAL)
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  284  	msr	elr_el2, lr
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  285  
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  286  	// clean all HYP code to the PoC if we booted at EL2 with the MMU on
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  287  	cbz	x0, 0f
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  288  	adrp	x0, __hyp_idmap_text_start
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  289  	adr_l	x1, __hyp_text_end
d54170812ef1c80 Mark Rutland    2023-02-20  290  	adr_l	x2, dcache_clean_poc
d54170812ef1c80 Mark Rutland    2023-02-20  291  	blr	x2
34e526cb7d46726 Ard Biesheuvel  2024-04-15  292  
34e526cb7d46726 Ard Biesheuvel  2024-04-15  293  	mov_q	x0, INIT_SCTLR_EL2_MMU_OFF
34e526cb7d46726 Ard Biesheuvel  2024-04-15  294  	pre_disable_mmu_workaround
34e526cb7d46726 Ard Biesheuvel  2024-04-15  295  	msr	sctlr_el2, x0
34e526cb7d46726 Ard Biesheuvel  2024-04-15  296  	isb
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  297  0:
78869f0f0552d03 David Brazdil   2020-12-02  298  	mov_q	x0, HCR_HOST_NVHE_FLAGS
b3320142f3db9b3 Marc Zyngier    2024-03-21  299  
b3320142f3db9b3 Marc Zyngier    2024-03-21  300  	/*
b3320142f3db9b3 Marc Zyngier    2024-03-21  301  	 * Compliant CPUs advertise their VHE-onlyness with
b3320142f3db9b3 Marc Zyngier    2024-03-21  302  	 * ID_AA64MMFR4_EL1.E2H0 < 0. HCR_EL2.E2H can be
b3320142f3db9b3 Marc Zyngier    2024-03-21  303  	 * RES1 in that case. Publish the E2H bit early so that
b3320142f3db9b3 Marc Zyngier    2024-03-21  304  	 * it can be picked up by the init_el2_state macro.
b3320142f3db9b3 Marc Zyngier    2024-03-21  305  	 *
b3320142f3db9b3 Marc Zyngier    2024-03-21  306  	 * Fruity CPUs seem to have HCR_EL2.E2H set to RAO/WI, but
b3320142f3db9b3 Marc Zyngier    2024-03-21  307  	 * don't advertise it (they predate this relaxation).
b3320142f3db9b3 Marc Zyngier    2024-03-21  308  	 */
b3320142f3db9b3 Marc Zyngier    2024-03-21  309  	mrs_s	x1, SYS_ID_AA64MMFR4_EL1
b3320142f3db9b3 Marc Zyngier    2024-03-21  310  	tbz	x1, #(ID_AA64MMFR4_EL1_E2H0_SHIFT + ID_AA64MMFR4_EL1_E2H0_WIDTH - 1), 1f
b3320142f3db9b3 Marc Zyngier    2024-03-21  311  
b3320142f3db9b3 Marc Zyngier    2024-03-21  312  	orr	x0, x0, #HCR_E2H
b3320142f3db9b3 Marc Zyngier    2024-03-21  313  1:
78869f0f0552d03 David Brazdil   2020-12-02  314  	msr	hcr_el2, x0
22043a3c082a584 Dave Martin     2017-10-31  315  	isb
78869f0f0552d03 David Brazdil   2020-12-02  316  
e2df464173f0b58 Marc Zyngier    2021-02-08 @317  	init_el2_state
22043a3c082a584 Dave Martin     2017-10-31  318  
712c6ff4dba4917 Marc Zyngier    2012-10-19  319  	/* Hypervisor stub */
78869f0f0552d03 David Brazdil   2020-12-02  320  	adr_l	x0, __hyp_stub_vectors
712c6ff4dba4917 Marc Zyngier    2012-10-19  321  	msr	vbar_el2, x0
d87a8e65b510112 Mark Rutland    2020-11-13  322  	isb
78869f0f0552d03 David Brazdil   2020-12-02  323  
ae4b7e38e9a9479 Marc Zyngier    2022-06-30  324  	mov_q	x1, INIT_SCTLR_EL1_MMU_OFF
ae4b7e38e9a9479 Marc Zyngier    2022-06-30  325  
31a32b49b80f79c Marc Zyngier    2021-04-08  326  	mrs	x0, hcr_el2
31a32b49b80f79c Marc Zyngier    2021-04-08  327  	and	x0, x0, #HCR_E2H
3944382fa6f22b5 Marc Zyngier    2024-01-22  328  	cbz	x0, 2f
b3320142f3db9b3 Marc Zyngier    2024-03-21  329  
ae4b7e38e9a9479 Marc Zyngier    2022-06-30  330  	/* Set a sane SCTLR_EL1, the VHE way */
ae4b7e38e9a9479 Marc Zyngier    2022-06-30  331  	msr_s	SYS_SCTLR_EL12, x1
ae4b7e38e9a9479 Marc Zyngier    2022-06-30  332  	mov	x2, #BOOT_CPU_FLAG_E2H
3944382fa6f22b5 Marc Zyngier    2024-01-22  333  	b	3f
31a32b49b80f79c Marc Zyngier    2021-04-08  334  
3944382fa6f22b5 Marc Zyngier    2024-01-22  335  2:
ae4b7e38e9a9479 Marc Zyngier    2022-06-30  336  	msr	sctlr_el1, x1
ae4b7e38e9a9479 Marc Zyngier    2022-06-30  337  	mov	x2, xzr
3944382fa6f22b5 Marc Zyngier    2024-01-22  338  3:
1700f89cb99aae1 Marc Zyngier    2023-06-14  339  	__init_el2_nvhe_prepare_eret
1700f89cb99aae1 Marc Zyngier    2023-06-14  340  
d87a8e65b510112 Mark Rutland    2020-11-13  341  	mov	w0, #BOOT_CPU_MODE_EL2
ae4b7e38e9a9479 Marc Zyngier    2022-06-30  342  	orr	x0, x0, x2
9703d9d7f77ce12 Catalin Marinas 2012-03-05  343  	eret
ecbb11ab3ebc027 Mark Rutland    2020-11-13  344  SYM_FUNC_END(init_kernel_el)
9703d9d7f77ce12 Catalin Marinas 2012-03-05  345  
9703d9d7f77ce12 Catalin Marinas 2012-03-05  346  	/*
9703d9d7f77ce12 Catalin Marinas 2012-03-05  347  	 * This provides a "holding pen" for platforms to hold all secondary
9703d9d7f77ce12 Catalin Marinas 2012-03-05  348  	 * cores are held until we're ready for them to initialise.
9703d9d7f77ce12 Catalin Marinas 2012-03-05  349  	 */
c63d9f82db94399 Mark Brown      2020-02-18  350  SYM_FUNC_START(secondary_holding_pen)
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  351  	mov	x0, xzr
ecbb11ab3ebc027 Mark Rutland    2020-11-13  352  	bl	init_kernel_el			// w0=cpu_boot_mode
005e12676af09a3 Ard Biesheuvel  2022-06-24  353  	mrs	x2, mpidr_el1
b03cc885328e3c0 Ard Biesheuvel  2016-04-18  354  	mov_q	x1, MPIDR_HWID_BITMASK
005e12676af09a3 Ard Biesheuvel  2022-06-24  355  	and	x2, x2, x1
b1c98297fe0c6e2 Ard Biesheuvel  2015-03-10  356  	adr_l	x3, secondary_holding_pen_release
9703d9d7f77ce12 Catalin Marinas 2012-03-05  357  pen:	ldr	x4, [x3]
005e12676af09a3 Ard Biesheuvel  2022-06-24  358  	cmp	x4, x2
9703d9d7f77ce12 Catalin Marinas 2012-03-05  359  	b.eq	secondary_startup
9703d9d7f77ce12 Catalin Marinas 2012-03-05  360  	wfe
9703d9d7f77ce12 Catalin Marinas 2012-03-05  361  	b	pen
c63d9f82db94399 Mark Brown      2020-02-18  362  SYM_FUNC_END(secondary_holding_pen)
652af8997993540 Mark Rutland    2013-10-24  363  
652af8997993540 Mark Rutland    2013-10-24  364  	/*
652af8997993540 Mark Rutland    2013-10-24  365  	 * Secondary entry point that jumps straight into the kernel. Only to
652af8997993540 Mark Rutland    2013-10-24  366  	 * be used where CPUs are brought online dynamically by the kernel.
652af8997993540 Mark Rutland    2013-10-24  367  	 */
c63d9f82db94399 Mark Brown      2020-02-18  368  SYM_FUNC_START(secondary_entry)
3dcf60bbfd284e5 Ard Biesheuvel  2023-01-11  369  	mov	x0, xzr
ecbb11ab3ebc027 Mark Rutland    2020-11-13  370  	bl	init_kernel_el			// w0=cpu_boot_mode
652af8997993540 Mark Rutland    2013-10-24  371  	b	secondary_startup
c63d9f82db94399 Mark Brown      2020-02-18  372  SYM_FUNC_END(secondary_entry)
9703d9d7f77ce12 Catalin Marinas 2012-03-05  373  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
