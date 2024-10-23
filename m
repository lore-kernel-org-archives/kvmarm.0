Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F18E73451
	for <kvmarm@lists.linux.dev>; Wed, 23 Oct 2024 07:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729668720; cv=none; b=nw0rpH83iSM/hO3+G1jyVcUY2IeupT4EQQqdjCIMBHHWwOMrfu7vVQsAryu7jMRrdFmOAtnDy2oaVTGit0pLYC+GdOyU384Ry4qK2e/sLg2hHEu2WOgFvNzJtQ2hUeecjCEFVtHYKdXZUGsPgCIxU3SvIlMBwBcJ3mqSmn8gB7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729668720; c=relaxed/simple;
	bh=ij33jlG/UBtM66nb4pZ/53gw8+Q/sbW+E5z2N5sIpx4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uas56Hd25q5WmEh3MdwGRX27u/mhLMfNfWbR56gs3Rl3GwE7LJglBCuSbHuMQ0pUKbp2khIHXyebJSU4BEO7xTeUOObiyKj3YtYoQQdTcrE5tpu7jSgExukADhg+bUcaDc9J6627LqAx+X8MfhWXMwP0F2Ivy1XK1fi9LhpSXKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 447E8339;
	Wed, 23 Oct 2024 00:32:26 -0700 (PDT)
Received: from [10.163.41.228] (unknown [10.163.41.228])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1483B3F528;
	Wed, 23 Oct 2024 00:31:52 -0700 (PDT)
Message-ID: <2310454a-99c6-4ff9-80f7-8707fbfaf5a6@arm.com>
Date: Wed, 23 Oct 2024 13:01:52 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/3] arm64/hw_breakpoint: Enable FEAT_Debugv8p9
To: Mark Rutland <mark.rutland@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 Jonathan Corbet <corbet@lwn.net>, Marc Zyngier <maz@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, James Morse <james.morse@arm.com>,
 Suzuki K Poulose <suzuki.poulose@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Brown <broonie@kernel.org>, kvmarm@lists.linux.dev
References: <20241001043602.1116991-1-anshuman.khandual@arm.com>
 <20241001043602.1116991-4-anshuman.khandual@arm.com>
 <ZxfGAHAn6I41ZLZV@J2N7QTR9R3>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <ZxfGAHAn6I41ZLZV@J2N7QTR9R3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/22/24 21:04, Mark Rutland wrote:
> On Tue, Oct 01, 2024 at 10:06:02AM +0530, Anshuman Khandual wrote:
>> Currently there can be maximum 16 breakpoints, and 16 watchpoints available
>> on a given platform - as detected from ID_AA64DFR0_EL1.[BRPs|WRPs] register
>> fields. But these breakpoint, and watchpoints can be extended further up to
>> 64 via a new arch feature FEAT_Debugv8p9.
>>
>> This first enables banked access for the breakpoint and watchpoint register
>> set via MDSELR_EL1, extended exceptions via MDSCR_EL1.EMBWE and determining
>> available breakpoints and watchpoints in the platform from ID_AA64DFR1_EL1,
>> when FEAT_Debugv8p9 is enabled.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/debug-monitors.h |  1 +
>>  arch/arm64/include/asm/hw_breakpoint.h  | 50 ++++++++++++++++++++-----
>>  arch/arm64/kernel/debug-monitors.c      | 16 ++++++--
>>  arch/arm64/kernel/hw_breakpoint.c       | 33 ++++++++++++++++
>>  4 files changed, 86 insertions(+), 14 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/debug-monitors.h b/arch/arm64/include/asm/debug-monitors.h
>> index 13d437bcbf58..a14097673ae0 100644
>> --- a/arch/arm64/include/asm/debug-monitors.h
>> +++ b/arch/arm64/include/asm/debug-monitors.h
>> @@ -20,6 +20,7 @@
>>  #define DBG_MDSCR_KDE		(1 << 13)
>>  #define DBG_MDSCR_MDE		(1 << 15)
>>  #define DBG_MDSCR_MASK		~(DBG_MDSCR_KDE | DBG_MDSCR_MDE)
>> +#define DBG_MDSCR_EMBWE		(1UL << 32)
>>  
>>  #define	DBG_ESR_EVT(x)		(((x) >> 27) & 0x7)
>>  
>> diff --git a/arch/arm64/include/asm/hw_breakpoint.h b/arch/arm64/include/asm/hw_breakpoint.h
>> index bd81cf17744a..362c4d4a64ac 100644
>> --- a/arch/arm64/include/asm/hw_breakpoint.h
>> +++ b/arch/arm64/include/asm/hw_breakpoint.h
>> @@ -79,8 +79,8 @@ static inline void decode_ctrl_reg(u32 reg,
>>   * Limits.
>>   * Changing these will require modifications to the register accessors.
>>   */
>> -#define ARM_MAX_BRP		16
>> -#define ARM_MAX_WRP		16
>> +#define ARM_MAX_BRP		64
>> +#define ARM_MAX_WRP		64
>>  
>>  /* Virtual debug register bases. */
>>  #define AARCH64_DBG_REG_BVR	0
>> @@ -94,13 +94,25 @@ static inline void decode_ctrl_reg(u32 reg,
>>  #define AARCH64_DBG_REG_NAME_WVR	wvr
>>  #define AARCH64_DBG_REG_NAME_WCR	wcr
>>  
>> +static inline bool is_debug_v8p9_enabled(void)
>> +{
>> +	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
>> +	int dver = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_DebugVer_SHIFT);
>> +
>> +	return dver == ID_AA64DFR0_EL1_DebugVer_V8P9;
>> +}
>> +
>>  /* Accessor macros for the debug registers. */
>>  #define AARCH64_DBG_READ(N, REG, VAL) do {\
>>  	VAL = read_sysreg(dbg##REG##N##_el1);\
>> +	if (is_debug_v8p9_enabled())	\
>> +		preempt_enable();	\
>>  } while (0)
>>  
>>  #define AARCH64_DBG_WRITE(N, REG, VAL) do {\
>>  	write_sysreg(VAL, dbg##REG##N##_el1);\
>> +	if (is_debug_v8p9_enabled())	\
>> +		preempt_enable();	\
>>  } while (0)
> 
> Without looking any further in this patch, this is clearly the wrong
> level of abstraction. Any disable/enable of preemption should be clearly
> balanced in a caller rather than half of that being hidden away in a
> low-level primitive.

Agreed, this was not the most optimal method from readability perspective
as well but could not come up with a better way without creating too much
code churn. But sure, will improve upon this (as you have suggested later).

> 
> Wherever this lives it needs a comment explaining what it is doing and
> why. I assume this is intended to protect the bank in sequences like:
> 
> 	MSR	MDSELR, <...>
> 	ISB
> 	MRS	<..._, BANKED_REGISTER

Correct, it is protecting the above sequence.

> 
> ... but is theat suffucient for mutual exclusion against
> exception handlers, or does that come from somewhere else?

Looking at all existing use cases for breakpoint/watchpoints, it should
be sufficient to protect against mutual exclusion. But thinking, do you
have a particular exception handler scenario in mind where this might
still be problematic ? Will keep looking into it.

> 
>>  struct task_struct;
>> @@ -138,19 +150,37 @@ static inline void ptrace_hw_copy_thread(struct task_struct *task)
>>  /* Determine number of BRP registers available. */
>>  static inline int get_num_brps(void)
>>  {
>> -	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
>> -	return 1 +
>> -		cpuid_feature_extract_unsigned_field(dfr0,
>> -						ID_AA64DFR0_EL1_BRPs_SHIFT);
>> +	u64 dfr0, dfr1;
>> +	int dver, brps;
>> +
>> +	dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
>> +	dver = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_DebugVer_SHIFT);
>> +	if (dver == ID_AA64DFR0_EL1_DebugVer_V8P9) {
>> +		dfr1 = read_sanitised_ftr_reg(SYS_ID_AA64DFR1_EL1);
>> +		brps = cpuid_feature_extract_unsigned_field_width(dfr1,
>> +								  ID_AA64DFR1_EL1_BRPs_SHIFT, 8);
>> +	} else {
>> +		brps = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_BRPs_SHIFT);
>> +	}
>> +	return 1 + brps;
>>  }
>>  
>>  /* Determine number of WRP registers available. */
>>  static inline int get_num_wrps(void)
>>  {
>> -	u64 dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
>> -	return 1 +
>> -		cpuid_feature_extract_unsigned_field(dfr0,
>> -						ID_AA64DFR0_EL1_WRPs_SHIFT);
>> +	u64 dfr0, dfr1;
>> +	int dver, wrps;
>> +
>> +	dfr0 = read_sanitised_ftr_reg(SYS_ID_AA64DFR0_EL1);
>> +	dver = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_DebugVer_SHIFT);
>> +	if (dver == ID_AA64DFR0_EL1_DebugVer_V8P9) {
>> +		dfr1 = read_sanitised_ftr_reg(SYS_ID_AA64DFR1_EL1);
>> +		wrps = cpuid_feature_extract_unsigned_field_width(dfr1,
>> +								  ID_AA64DFR1_EL1_WRPs_SHIFT, 8);
>> +	} else {
>> +		wrps = cpuid_feature_extract_unsigned_field(dfr0, ID_AA64DFR0_EL1_WRPs_SHIFT);
>> +	}
>> +	return 1 + wrps;
>>  }
>>  
>>  #ifdef CONFIG_CPU_PM
>> diff --git a/arch/arm64/kernel/debug-monitors.c b/arch/arm64/kernel/debug-monitors.c
>> index 024a7b245056..af643c935f2e 100644
>> --- a/arch/arm64/kernel/debug-monitors.c
>> +++ b/arch/arm64/kernel/debug-monitors.c
>> @@ -23,6 +23,7 @@
>>  #include <asm/debug-monitors.h>
>>  #include <asm/system_misc.h>
>>  #include <asm/traps.h>
>> +#include <asm/hw_breakpoint.h>
> 
> Nit: these are ordered alphabetically, please keep them that way.

Sure, will change.

> 
>>  
>>  /* Determine debug architecture. */
>>  u8 debug_monitors_arch(void)
>> @@ -34,7 +35,7 @@ u8 debug_monitors_arch(void)
>>  /*
>>   * MDSCR access routines.
>>   */
>> -static void mdscr_write(u32 mdscr)
>> +static void mdscr_write(u64 mdscr)
>>  {
>>  	unsigned long flags;
>>  	flags = local_daif_save();
>> @@ -43,7 +44,7 @@ static void mdscr_write(u32 mdscr)
>>  }
>>  NOKPROBE_SYMBOL(mdscr_write);
>>  
>> -static u32 mdscr_read(void)
>> +static u64 mdscr_read(void)
>>  {
>>  	return read_sysreg(mdscr_el1);
>>  }
>> @@ -76,10 +77,11 @@ early_param("nodebugmon", early_debug_disable);
>>   */
>>  static DEFINE_PER_CPU(int, mde_ref_count);
>>  static DEFINE_PER_CPU(int, kde_ref_count);
>> +static DEFINE_PER_CPU(int, embwe_ref_count);
> 
> We have refcounting for MDE and KDE because they enable debug exceptions
> to be taken (and e.g. require a hypervisor to do more work when they're
> enabled), but AFAICT that's not true for EMBWE.
Thought something similar would be required for EMBWE.

> 
> Do we need to refcount EMBWE?

TBH, not sure. Don't understand this component well enough. You are probably
right, this refcount mechanism for EMBWE might not be required here.

> 
>>  void enable_debug_monitors(enum dbg_active_el el)
>>  {
>> -	u32 mdscr, enable = 0;
>> +	u64 mdscr, enable = 0;
>>  
>>  	WARN_ON(preemptible());
>>  
>> @@ -90,6 +92,9 @@ void enable_debug_monitors(enum dbg_active_el el)
>>  	    this_cpu_inc_return(kde_ref_count) == 1)
>>  		enable |= DBG_MDSCR_KDE;
>>  
>> +	if (is_debug_v8p9_enabled() && this_cpu_inc_return(embwe_ref_count) == 1)
>> +		enable |= DBG_MDSCR_EMBWE;
> 
> ... which suggests that this could simplified to be:
> 
> 	if (is_debug_v8p9_enabled())
> 		enable != DBG_MDSCR_EMBWE;

Sure, will change.

> 
> ... and likewise below, unless I'm missing some reason why we must
> refcount this?

Okay, will drop the refcount mechanism completely and instead just
enable-disable DBG_MDSCR_EMBWE based on is_debug_v8p9_enabled()
feature test.

> 
>> diff --git a/arch/arm64/kernel/hw_breakpoint.c b/arch/arm64/kernel/hw_breakpoint.c
>> index 722ac45f9f7b..30156d732284 100644
>> --- a/arch/arm64/kernel/hw_breakpoint.c
>> +++ b/arch/arm64/kernel/hw_breakpoint.c
>> @@ -103,10 +103,40 @@ int hw_breakpoint_slots(int type)
>>  	WRITE_WB_REG_CASE(OFF, 14, REG, VAL);	\
>>  	WRITE_WB_REG_CASE(OFF, 15, REG, VAL)
>>  
>> +static int set_bank_index(int n)
>> +{
>> +	int mdsel_bank;
>> +	int bank = n / 16, index = n % 16;
>> +
>> +	switch (bank) {
>> +	case 0:
>> +		mdsel_bank = MDSELR_EL1_BANK_BANK_0;
>> +		break;
>> +	case 1:
>> +		mdsel_bank = MDSELR_EL1_BANK_BANK_1;
>> +		break;
>> +	case 2:
>> +		mdsel_bank = MDSELR_EL1_BANK_BANK_2;
>> +		break;
>> +	case 3:
>> +		mdsel_bank = MDSELR_EL1_BANK_BANK_3;
>> +		break;
> 
> Since this is a trivial mapping, do we actually need the switch?

MDSELR_EL1_BANK_BANK_<N> = N (0..3) So mdsel_bank could
directly be used without going through the 'bank' based
switch case above. Will drop them as suggested.

> 
>> +	default:
>> +		pr_warn("Unknown register bank %d\n", bank);
>> +	}
>> +	preempt_disable();
>> +	write_sysreg_s(mdsel_bank << MDSELR_EL1_BANK_SHIFT, SYS_MDSELR_EL1);
>> +	isb();
>> +	return index;
>> +}
>> +
>>  static u64 read_wb_reg(int reg, int n)
>>  {
>>  	u64 val = 0;
>>  
>> +	if (is_debug_v8p9_enabled())
>> +		n = set_bank_index(n);
>> +
>>  	switch (reg + n) {
>>  	GEN_READ_WB_REG_CASES(AARCH64_DBG_REG_BVR, AARCH64_DBG_REG_NAME_BVR, val);
>>  	GEN_READ_WB_REG_CASES(AARCH64_DBG_REG_BCR, AARCH64_DBG_REG_NAME_BCR, val);
> 
> As above, this would be better as something like:
> 
> 	// rename the existing read_wb_reg(), unchanged
> 	static u64 __read_wb_reg(int reg, int n);
> 
> 	static u64 read_wb_reg(int reg, int n)
> 	{
> 		u64 val;
> 
> 		if (!is_debug_v8p9_enabled())
> 			return __read_wb_reg(reg, n);
> 
> 		/*
> 		 * TODO: explain here
> 		 */
> 		preempt_disable();
> 		write_sysreg_s(...); // MDSELR
> 		isb();
> 		val = __read_wb_reg(reg, idx_within_bank);
> 		preempt_enable();
> 
> 		return val;
> 	}
> 
> ... or:
> 
> 	static u64 read_wb_reg(int reg, int n)
> 	{
> 		u64 val;
> 
> 		if (is_debug_v8p9_enabled()) {
> 			/*
> 			 * TODO: explain here
> 			 */
> 			preempt_disable();
> 			write_sysreg_s(...); // MDSELR
> 			isb();
> 			val = __read_wb_reg(reg, idx_within_bank);
> 			preempt_enable();
> 		} else {
> 			val = __read_wb_reg(reg, n);
> 		}
> 
> 		return val;
> 	}
> 
> ... which is more lines but *vastly* clearer. 
> 
> Likewise for the write case.

Agreed, they are indeed much clearer, will change as suggested and respin.

Thanks for your detailed review.
