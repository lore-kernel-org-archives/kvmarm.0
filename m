Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B6AD820309;
	Thu,  3 Oct 2024 03:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727926848; cv=none; b=lfOtgp9ndybFYK+aR73Wg8OFSmXUdL8avdW3SWznPsuGHIGlf/OPjlVwBjmdU9dB95RKhrwIy+iGbBY28RAmNnVH/CdpNcK1VgtpZ7C4pE0+J9NDBQznEk6nz5qrMRNrL0M5srmY/qjPyefFIahqjuM15jRR9eWYOI4B4MUHwUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727926848; c=relaxed/simple;
	bh=ggf4pIh3/wTu8uu9dZOwqC1+gRnjRUQ0lepm5IfBHnc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qBj6XKM+ZgaGj/YLq64Tl84dgBQC6gX2zq6WLgSzm9h423qG6uNqAyN45KMU4NpK5M5HsxM5ilXQnpAGwRxjNh9r9nIkBSTk2y64A6DD1CVxZZucnfLdmDGnJ+HVUBuq75FImOhpe2mw2DsGyPspppEga8GWa7kDh+BkcitxqUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 60D71339;
	Wed,  2 Oct 2024 20:41:15 -0700 (PDT)
Received: from [10.163.37.202] (unknown [10.163.37.202])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A624C3F640;
	Wed,  2 Oct 2024 20:40:41 -0700 (PDT)
Message-ID: <eae3b6bd-b69a-41cb-8963-feb766f9d528@arm.com>
Date: Thu, 3 Oct 2024 09:10:40 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
To: kernel test robot <lkp@intel.com>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org
Cc: oe-kbuild-all@lists.linux.dev, Jonathan Corbet <corbet@lwn.net>,
 Marc Zyngier <maz@kernel.org>, Oliver Upton <oliver.upton@linux.dev>,
 James Morse <james.morse@arm.com>, Suzuki K Poulose
 <suzuki.poulose@arm.com>, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, Mark Brown <broonie@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, kvmarm@lists.linux.dev
References: <20241001043602.1116991-4-anshuman.khandual@arm.com>
 <202410030700.kZSan6G6-lkp@intel.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <202410030700.kZSan6G6-lkp@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/3/24 05:06, kernel test robot wrote:
> Hi Anshuman,
> 
> kernel test robot noticed the following build errors:
> 
> [auto build test ERROR on arm64/for-next/core]
> [also build test ERROR on kvmarm/next soc/for-next arm/for-next arm/fixes linus/master v6.12-rc1 next-20241002]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
> 
> url:    https://github.com/intel-lab-lkp/linux/commits/Anshuman-Khandual/arm64-cpufeature-Add-field-details-for-ID_AA64DFR1_EL1-register/20241001-123752
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-next/core
> patch link:    https://lore.kernel.org/r/20241001043602.1116991-4-anshuman.khandual%40arm.com
> patch subject: [PATCH 3/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
> config: arm64-randconfig-004-20241003 (https://download.01.org/0day-ci/archive/20241003/202410030700.kZSan6G6-lkp@intel.com/config)
> compiler: aarch64-linux-gcc (GCC) 14.1.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20241003/202410030700.kZSan6G6-lkp@intel.com/reproduce)
> 
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202410030700.kZSan6G6-lkp@intel.com/
> 
> All errors (new ones prefixed by >>):
> 
>    arch/arm64/kernel/hw_breakpoint.c: In function 'set_bank_index':
>>> arch/arm64/kernel/hw_breakpoint.c:113:30: error: 'MDSELR_EL1_BANK_BANK_0' undeclared (first use in this function)
>      113 |                 mdsel_bank = MDSELR_EL1_BANK_BANK_0;
>          |                              ^~~~~~~~~~~~~~~~~~~~~~
>    arch/arm64/kernel/hw_breakpoint.c:113:30: note: each undeclared identifier is reported only once for each function it appears in
>>> arch/arm64/kernel/hw_breakpoint.c:116:30: error: 'MDSELR_EL1_BANK_BANK_1' undeclared (first use in this function)
>      116 |                 mdsel_bank = MDSELR_EL1_BANK_BANK_1;
>          |                              ^~~~~~~~~~~~~~~~~~~~~~
>>> arch/arm64/kernel/hw_breakpoint.c:119:30: error: 'MDSELR_EL1_BANK_BANK_2' undeclared (first use in this function)
>      119 |                 mdsel_bank = MDSELR_EL1_BANK_BANK_2;
>          |                              ^~~~~~~~~~~~~~~~~~~~~~
>>> arch/arm64/kernel/hw_breakpoint.c:122:30: error: 'MDSELR_EL1_BANK_BANK_3' undeclared (first use in this function)
>      122 |                 mdsel_bank = MDSELR_EL1_BANK_BANK_3;
>          |                              ^~~~~~~~~~~~~~~~~~~~~~
>    In file included from arch/arm64/include/asm/cputype.h:226,
>                     from arch/arm64/include/asm/cache.h:43,
>                     from include/linux/cache.h:6,
>                     from include/linux/time.h:5,
>                     from include/linux/compat.h:10,
>                     from arch/arm64/kernel/hw_breakpoint.c:12:
>>> arch/arm64/kernel/hw_breakpoint.c:128:38: error: 'MDSELR_EL1_BANK_SHIFT' undeclared (first use in this function); did you mean 'CSSELR_EL1_InD_SHIFT'?
>      128 |         write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
>          |                                      ^~~~~~~~~~~~~~~~~~~~~
>    arch/arm64/include/asm/sysreg.h:1168:27: note: in definition of macro 'write_sysreg_s'
>     1168 |         u64 __val = (u64)(v);                                           \
>          |                           ^
>>> arch/arm64/kernel/hw_breakpoint.c:128:61: error: 'SYS_MDSELR_EL1' undeclared (first use in this function); did you mean 'SYS_MDSCR_EL1'?
>      128 |         write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
>          |                                                             ^~~~~~~~~~~~~~
>    arch/arm64/include/asm/sysreg.h:1169:46: note: in definition of macro 'write_sysreg_s'
>     1169 |         u32 __maybe_unused __check_r = (u32)(r);                        \
>          |                                              ^
> 
> 
> vim +/MDSELR_EL1_BANK_BANK_0 +113 arch/arm64/kernel/hw_breakpoint.c
> 
>     59	
>     60	#define READ_WB_REG_CASE(OFF, N, REG, VAL)	\
>     61		case (OFF + N):				\
>     62			AARCH64_DBG_READ(N, REG, VAL);	\
>     63			break
>     64	
>     65	#define WRITE_WB_REG_CASE(OFF, N, REG, VAL)	\
>     66		case (OFF + N):				\
>     67			AARCH64_DBG_WRITE(N, REG, VAL);	\
>     68			break
>     69	
>     70	#define GEN_READ_WB_REG_CASES(OFF, REG, VAL)	\
>     71		READ_WB_REG_CASE(OFF,  0, REG, VAL);	\
>     72		READ_WB_REG_CASE(OFF,  1, REG, VAL);	\
>     73		READ_WB_REG_CASE(OFF,  2, REG, VAL);	\
>     74		READ_WB_REG_CASE(OFF,  3, REG, VAL);	\
>     75		READ_WB_REG_CASE(OFF,  4, REG, VAL);	\
>     76		READ_WB_REG_CASE(OFF,  5, REG, VAL);	\
>     77		READ_WB_REG_CASE(OFF,  6, REG, VAL);	\
>     78		READ_WB_REG_CASE(OFF,  7, REG, VAL);	\
>     79		READ_WB_REG_CASE(OFF,  8, REG, VAL);	\
>     80		READ_WB_REG_CASE(OFF,  9, REG, VAL);	\
>     81		READ_WB_REG_CASE(OFF, 10, REG, VAL);	\
>     82		READ_WB_REG_CASE(OFF, 11, REG, VAL);	\
>     83		READ_WB_REG_CASE(OFF, 12, REG, VAL);	\
>     84		READ_WB_REG_CASE(OFF, 13, REG, VAL);	\
>     85		READ_WB_REG_CASE(OFF, 14, REG, VAL);	\
>     86		READ_WB_REG_CASE(OFF, 15, REG, VAL)
>     87	
>     88	#define GEN_WRITE_WB_REG_CASES(OFF, REG, VAL)	\
>     89		WRITE_WB_REG_CASE(OFF,  0, REG, VAL);	\
>     90		WRITE_WB_REG_CASE(OFF,  1, REG, VAL);	\
>     91		WRITE_WB_REG_CASE(OFF,  2, REG, VAL);	\
>     92		WRITE_WB_REG_CASE(OFF,  3, REG, VAL);	\
>     93		WRITE_WB_REG_CASE(OFF,  4, REG, VAL);	\
>     94		WRITE_WB_REG_CASE(OFF,  5, REG, VAL);	\
>     95		WRITE_WB_REG_CASE(OFF,  6, REG, VAL);	\
>     96		WRITE_WB_REG_CASE(OFF,  7, REG, VAL);	\
>     97		WRITE_WB_REG_CASE(OFF,  8, REG, VAL);	\
>     98		WRITE_WB_REG_CASE(OFF,  9, REG, VAL);	\
>     99		WRITE_WB_REG_CASE(OFF, 10, REG, VAL);	\
>    100		WRITE_WB_REG_CASE(OFF, 11, REG, VAL);	\
>    101		WRITE_WB_REG_CASE(OFF, 12, REG, VAL);	\
>    102		WRITE_WB_REG_CASE(OFF, 13, REG, VAL);	\
>    103		WRITE_WB_REG_CASE(OFF, 14, REG, VAL);	\
>    104		WRITE_WB_REG_CASE(OFF, 15, REG, VAL)
>    105	
>    106	static int set_bank_index(int n)
>    107	{
>    108		int mdsel_bank;
>    109		int bank = n / 16, index = n % 16;
>    110	
>    111		switch (bank) {
>    112		case 0:
>  > 113			mdsel_bank = MDSELR_EL1_BANK_BANK_0;
>    114			break;
>    115		case 1:
>  > 116			mdsel_bank = MDSELR_EL1_BANK_BANK_1;
>    117			break;
>    118		case 2:
>  > 119			mdsel_bank = MDSELR_EL1_BANK_BANK_2;
>    120			break;
>    121		case 3:
>  > 122			mdsel_bank = MDSELR_EL1_BANK_BANK_3;
>    123			break;
>    124		default:
>    125			pr_warn("Unknown register bank %d\n", bank);
>    126		}
>    127		preempt_disable();
>  > 128		write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
>    129		isb();
>    130		return index;
>    131	}
>    132	
> 

This build failure and also the other two on the series here are false positives
caused by non-availability of used register field definitions which are provided
via the dependent KVM FEAT_FGT2 FGU series.
