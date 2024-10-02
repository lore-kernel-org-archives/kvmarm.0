Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481E71A265E;
	Wed,  2 Oct 2024 23:36:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727912210; cv=none; b=baEmI6fDS8UVP4971Abwa/Ea+xi9oG6zTKBCoupscemUP2/JpMufXGgkn2dD01qb6eq0jmYryYyQX/TG1o5jMMvoiTdwryBtoDAT3FL16bmAQtMIAVv+w59TTMo/Ap07eeVM4AkUU6vEblFn8jlPPdc9C2zE084elx+YqLbl7zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727912210; c=relaxed/simple;
	bh=WAFNWrzv3d57lnqN7sr21FKtFiGFWCrfNQXNH1vBjr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=u9D7oa0UaXNBoaS4RP333VJCi3W7eJYQYReW+QSuVvOqNxhruorsv+z/vQ70a1Pv2gDNYAyFc+n7G992wWyQKQ1QKwsQ15/v9rStgdQI4nsKEkJWcaFcm2peUwZORV3821QcXKQ94qFliV3zD3azXD8fxerYq3FFpwjHFNe5Gn4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=hignvB//; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="hignvB//"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727912208; x=1759448208;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=WAFNWrzv3d57lnqN7sr21FKtFiGFWCrfNQXNH1vBjr8=;
  b=hignvB//xjfBefROy8r1uPvLqRaM7jX7a3tADVeHWkMm8jE5eRfEZUNb
   e2lkdtzcA7xYiU4rjwMkyY/jnG7NUG2tM0M8M1eJ7p7KrhgG/RxFFVERh
   uX+XNrgRp94T121l4PkBcJf57da/cyhMuZtcaDBml2QIQBzqk7+7ZiNLR
   6EjZ3iUnMI3ycfxp0Qws72j8NQTnimbOrjGalN1j0sWCzy3GDTWupnSDb
   UP5LElXGVIwepbtJrl8LD9uHvGA5oxfa/8m3EJrlUFoyYFSxWHLxdjXc8
   Zp7qXwvfv2wdohGx5JZZC8H1Wxbk74DhaZ+d6CwiiMWFfgTliqzkuHZXA
   w==;
X-CSE-ConnectionGUID: mxyHKSsBTRKW8ndYIQBmGQ==
X-CSE-MsgGUID: 1oLjTXmvRjWF1GPvUG9olw==
X-IronPort-AV: E=McAfee;i="6700,10204,11213"; a="26604268"
X-IronPort-AV: E=Sophos;i="6.11,173,1725346800"; 
   d="scan'208";a="26604268"
Received: from orviesa006.jf.intel.com ([10.64.159.146])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Oct 2024 16:36:47 -0700
X-CSE-ConnectionGUID: B8bc3lGsTr+neROrDn6JUQ==
X-CSE-MsgGUID: o1tk/ZOKQrGbP3dCXeJM+w==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,173,1725346800"; 
   d="scan'208";a="74409957"
Received: from lkp-server01.sh.intel.com (HELO 53e96f405c61) ([10.239.97.150])
  by orviesa006.jf.intel.com with ESMTP; 02 Oct 2024 16:36:43 -0700
Received: from kbuild by 53e96f405c61 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1sw8td-000Uh1-0r;
	Wed, 02 Oct 2024 23:36:41 +0000
Date: Thu, 3 Oct 2024 07:36:12 +0800
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
	Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev
Subject: Re: [PATCH 3/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
Message-ID: <202410030700.kZSan6G6-lkp@intel.com>
References: <20241001043602.1116991-4-anshuman.khandual@arm.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241001043602.1116991-4-anshuman.khandual@arm.com>

Hi Anshuman,

kernel test robot noticed the following build errors:

[auto build test ERROR on arm64/for-next/core]
[also build test ERROR on kvmarm/next soc/for-next arm/for-next arm/fixes linus/master v6.12-rc1 next-20241002]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Anshuman-Khandual/arm64-cpufeature-Add-field-details-for-ID_AA64DFR1_EL1-register/20241001-123752
base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
patch link:    https://lore.kernel.org/r/20241001043602.1116991-4-anshuman.khandual%40arm.com
patch subject: [PATCH 3/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
config: arm64-randconfig-004-20241003 (https://download.01.org/0day-ci/archive/20241003/202410030700.kZSan6G6-lkp@intel.com/config)
compiler: aarch64-linux-gcc (GCC) 14.1.0
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241003/202410030700.kZSan6G6-lkp@intel.com/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202410030700.kZSan6G6-lkp@intel.com/

All errors (new ones prefixed by >>):

   arch/arm64/kernel/hw_breakpoint.c: In function 'set_bank_index':
>> arch/arm64/kernel/hw_breakpoint.c:113:30: error: 'MDSELR_EL1_BANK_BANK_0' undeclared (first use in this function)
     113 |                 mdsel_bank = MDSELR_EL1_BANK_BANK_0;
         |                              ^~~~~~~~~~~~~~~~~~~~~~
   arch/arm64/kernel/hw_breakpoint.c:113:30: note: each undeclared identifier is reported only once for each function it appears in
>> arch/arm64/kernel/hw_breakpoint.c:116:30: error: 'MDSELR_EL1_BANK_BANK_1' undeclared (first use in this function)
     116 |                 mdsel_bank = MDSELR_EL1_BANK_BANK_1;
         |                              ^~~~~~~~~~~~~~~~~~~~~~
>> arch/arm64/kernel/hw_breakpoint.c:119:30: error: 'MDSELR_EL1_BANK_BANK_2' undeclared (first use in this function)
     119 |                 mdsel_bank = MDSELR_EL1_BANK_BANK_2;
         |                              ^~~~~~~~~~~~~~~~~~~~~~
>> arch/arm64/kernel/hw_breakpoint.c:122:30: error: 'MDSELR_EL1_BANK_BANK_3' undeclared (first use in this function)
     122 |                 mdsel_bank = MDSELR_EL1_BANK_BANK_3;
         |                              ^~~~~~~~~~~~~~~~~~~~~~
   In file included from arch/arm64/include/asm/cputype.h:226,
                    from arch/arm64/include/asm/cache.h:43,
                    from include/linux/cache.h:6,
                    from include/linux/time.h:5,
                    from include/linux/compat.h:10,
                    from arch/arm64/kernel/hw_breakpoint.c:12:
>> arch/arm64/kernel/hw_breakpoint.c:128:38: error: 'MDSELR_EL1_BANK_SHIFT' undeclared (first use in this function); did you mean 'CSSELR_EL1_InD_SHIFT'?
     128 |         write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
         |                                      ^~~~~~~~~~~~~~~~~~~~~
   arch/arm64/include/asm/sysreg.h:1168:27: note: in definition of macro 'write_sysreg_s'
    1168 |         u64 __val = (u64)(v);                                           \
         |                           ^
>> arch/arm64/kernel/hw_breakpoint.c:128:61: error: 'SYS_MDSELR_EL1' undeclared (first use in this function); did you mean 'SYS_MDSCR_EL1'?
     128 |         write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
         |                                                             ^~~~~~~~~~~~~~
   arch/arm64/include/asm/sysreg.h:1169:46: note: in definition of macro 'write_sysreg_s'
    1169 |         u32 __maybe_unused __check_r = (u32)(r);                        \
         |                                              ^


vim +/MDSELR_EL1_BANK_BANK_0 +113 arch/arm64/kernel/hw_breakpoint.c

    59	
    60	#define READ_WB_REG_CASE(OFF, N, REG, VAL)	\
    61		case (OFF + N):				\
    62			AARCH64_DBG_READ(N, REG, VAL);	\
    63			break
    64	
    65	#define WRITE_WB_REG_CASE(OFF, N, REG, VAL)	\
    66		case (OFF + N):				\
    67			AARCH64_DBG_WRITE(N, REG, VAL);	\
    68			break
    69	
    70	#define GEN_READ_WB_REG_CASES(OFF, REG, VAL)	\
    71		READ_WB_REG_CASE(OFF,  0, REG, VAL);	\
    72		READ_WB_REG_CASE(OFF,  1, REG, VAL);	\
    73		READ_WB_REG_CASE(OFF,  2, REG, VAL);	\
    74		READ_WB_REG_CASE(OFF,  3, REG, VAL);	\
    75		READ_WB_REG_CASE(OFF,  4, REG, VAL);	\
    76		READ_WB_REG_CASE(OFF,  5, REG, VAL);	\
    77		READ_WB_REG_CASE(OFF,  6, REG, VAL);	\
    78		READ_WB_REG_CASE(OFF,  7, REG, VAL);	\
    79		READ_WB_REG_CASE(OFF,  8, REG, VAL);	\
    80		READ_WB_REG_CASE(OFF,  9, REG, VAL);	\
    81		READ_WB_REG_CASE(OFF, 10, REG, VAL);	\
    82		READ_WB_REG_CASE(OFF, 11, REG, VAL);	\
    83		READ_WB_REG_CASE(OFF, 12, REG, VAL);	\
    84		READ_WB_REG_CASE(OFF, 13, REG, VAL);	\
    85		READ_WB_REG_CASE(OFF, 14, REG, VAL);	\
    86		READ_WB_REG_CASE(OFF, 15, REG, VAL)
    87	
    88	#define GEN_WRITE_WB_REG_CASES(OFF, REG, VAL)	\
    89		WRITE_WB_REG_CASE(OFF,  0, REG, VAL);	\
    90		WRITE_WB_REG_CASE(OFF,  1, REG, VAL);	\
    91		WRITE_WB_REG_CASE(OFF,  2, REG, VAL);	\
    92		WRITE_WB_REG_CASE(OFF,  3, REG, VAL);	\
    93		WRITE_WB_REG_CASE(OFF,  4, REG, VAL);	\
    94		WRITE_WB_REG_CASE(OFF,  5, REG, VAL);	\
    95		WRITE_WB_REG_CASE(OFF,  6, REG, VAL);	\
    96		WRITE_WB_REG_CASE(OFF,  7, REG, VAL);	\
    97		WRITE_WB_REG_CASE(OFF,  8, REG, VAL);	\
    98		WRITE_WB_REG_CASE(OFF,  9, REG, VAL);	\
    99		WRITE_WB_REG_CASE(OFF, 10, REG, VAL);	\
   100		WRITE_WB_REG_CASE(OFF, 11, REG, VAL);	\
   101		WRITE_WB_REG_CASE(OFF, 12, REG, VAL);	\
   102		WRITE_WB_REG_CASE(OFF, 13, REG, VAL);	\
   103		WRITE_WB_REG_CASE(OFF, 14, REG, VAL);	\
   104		WRITE_WB_REG_CASE(OFF, 15, REG, VAL)
   105	
   106	static int set_bank_index(int n)
   107	{
   108		int mdsel_bank;
   109		int bank = n / 16, index = n % 16;
   110	
   111		switch (bank) {
   112		case 0:
 > 113			mdsel_bank = MDSELR_EL1_BANK_BANK_0;
   114			break;
   115		case 1:
 > 116			mdsel_bank = MDSELR_EL1_BANK_BANK_1;
   117			break;
   118		case 2:
 > 119			mdsel_bank = MDSELR_EL1_BANK_BANK_2;
   120			break;
   121		case 3:
 > 122			mdsel_bank = MDSELR_EL1_BANK_BANK_3;
   123			break;
   124		default:
   125			pr_warn("Unknown register bank %d\n", bank);
   126		}
   127		preempt_disable();
 > 128		write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
   129		isb();
   130		return index;
   131	}
   132	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
