From: Sudeep Holla <sudeep.holla@arm.com>
Subject: Re: [PATCH v2 1/3] arm64: cacheinfo: add support for alternative
 format of CCSIDR_EL1
Date: Mon, 30 Jan 2017 16:57:35 +0000
Message-ID: <568a27c1-f910-46e8-7283-2040e28df380@arm.com>
References: <1485793527-18028-1-git-send-email-sudeep.holla@arm.com>
 <ad552a58-4acd-f2ab-7d40-124b40c6c014@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kvmarm-bounces@lists.cs.columbia.edu>
Received: from localhost (localhost [127.0.0.1])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 51D0540194
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 11:57:27 -0500 (EST)
Received: from mm01.cs.columbia.edu ([127.0.0.1])
 by localhost (mm01.cs.columbia.edu [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id AqP3Zjth8s7L for <kvmarm@lists.cs.columbia.edu>;
 Mon, 30 Jan 2017 11:57:26 -0500 (EST)
Received: from foss.arm.com (foss.arm.com [217.140.101.70])
 by mm01.cs.columbia.edu (Postfix) with ESMTP id 5212240190
 for <kvmarm@lists.cs.columbia.edu>; Mon, 30 Jan 2017 11:57:25 -0500 (EST)
In-Reply-To: <ad552a58-4acd-f2ab-7d40-124b40c6c014@arm.com>
List-Unsubscribe: <https://lists.cs.columbia.edu/mailman/options/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=unsubscribe>
List-Archive: <https://lists.cs.columbia.edu/pipermail/kvmarm>
List-Post: <mailto:kvmarm@lists.cs.columbia.edu>
List-Help: <mailto:kvmarm-request@lists.cs.columbia.edu?subject=help>
List-Subscribe: <https://lists.cs.columbia.edu/mailman/listinfo/kvmarm>,
 <mailto:kvmarm-request@lists.cs.columbia.edu?subject=subscribe>
Errors-To: kvmarm-bounces@lists.cs.columbia.edu
Sender: kvmarm-bounces@lists.cs.columbia.edu
To: Suzuki K Poulose <Suzuki.Poulose@arm.com>, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org
Cc: Marc Zyngier <marc.zyngier@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Sudeep Holla <sudeep.holla@arm.com>
List-Id: kvmarm@lists.cs.columbia.edu



On 30/01/17 16:47, Suzuki K Poulose wrote:
> On 30/01/17 16:25, Sudeep Holla wrote:
>> The number of sets described for each cache level in the CCSIDR is
>> limited to 32K and the associativity is limited to 1024 ways.
>>
>> As part of the ARM8.3 extensions, an alternative format for the
>> CCSIDR_EL1 is introduced for AArch64, and for AArch32, a new CCSIDR2
>> register is introduced to hold the upper 32 bits of this information,
>> and the CCSIDR register format is changed. An identification registers
>> are also added to identify the presence for this functionality.
>>
>> This patch adds support for the alternative format of CCSIDR_EL1.

[...]

>>  void __init setup_cpu_features(void);
>>
>>  void update_cpu_capabilities(const struct arm64_cpu_capabilities *caps,
>> @@ -224,6 +229,10 @@ static inline bool system_uses_ttbr0_pan(void)
>>          !cpus_have_cap(ARM64_HAS_PAN);
>>  }
>>
>> +static inline bool cpu_supports_ccsidr_64b_format(void)
>> +{
>> +    return
>> id_aa64mmfr2_ccsidr_64b_format(read_system_reg(SYS_ID_AA64MMFR2_EL1));
> 
> read_system_reg() gives you the system wide safe value for the register,
> which could
> be different from that of the current CPU. You have to use
> read_sysreg_s(), to read
> a register on the CPU (which aren't yet recognized by GAS).
> 
> Sorry, the names are a bit confusing, which can easily cause such
> issues. May be we should rename some of them.
> 

Thanks, fixed locally, will post as part of next version.

>> +}
>>  #endif /* __ASSEMBLY__ */
>>
>>  #endif
>> diff --git a/arch/arm64/include/asm/sysreg.h
>> b/arch/arm64/include/asm/sysreg.h
>> index 98ae03f8eedd..c72dfe8807ca 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -183,6 +183,7 @@
>>  #define ID_AA64MMFR1_VMIDBITS_16    2
>>
>>  /* id_aa64mmfr2 */
>> +#define ID_AA64MMFR2_CCIDX_SHIFT    20
>>  #define ID_AA64MMFR2_LVA_SHIFT        16
>>  #define ID_AA64MMFR2_IESB_SHIFT        12
>>  #define ID_AA64MMFR2_LSM_SHIFT        8
>> diff --git a/arch/arm64/kernel/cacheinfo.c
>> b/arch/arm64/kernel/cacheinfo.c
>> index 3f2250fc391b..888b38f1709f 100644
>> --- a/arch/arm64/kernel/cacheinfo.c
>> +++ b/arch/arm64/kernel/cacheinfo.c
>> @@ -43,6 +43,13 @@ static inline enum cache_type get_cache_type(int
>> level)
>>      return CLIDR_CTYPE(clidr, level);
>>  }
>>
>> +int icache_get_numsets(void)
> 
> Could this be static ? I could not see it used anywhere else outside
> this file.

Used in arch/arm64/kernel/cpuinfo.c

-- 
Regards,
Sudeep
