Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6419E19465
	for <kvmarm@lists.linux.dev>; Mon, 13 Nov 2023 11:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EA8ECFEC;
	Mon, 13 Nov 2023 03:58:33 -0800 (PST)
Received: from [10.57.73.13] (unknown [10.57.73.13])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3DDB3F6C4;
	Mon, 13 Nov 2023 03:57:46 -0800 (PST)
Message-ID: <1d742c1f-2f2d-4d73-8530-b7e2b688287f@arm.com>
Date: Mon, 13 Nov 2023 11:57:45 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/12] KVM: arm64: Add ARM64_HAS_LPA2 CPU capability
Content-Language: en-GB
To: Marc Zyngier <maz@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, James Morse
 <james.morse@arm.com>, Zenghui Yu <yuzenghui@huawei.com>,
 Ard Biesheuvel <ardb@kernel.org>,
 Anshuman Khandual <anshuman.khandual@arm.com>,
 linux-arm-kernel@lists.infradead.org, kvmarm@lists.linux.dev
References: <20231009185008.3803879-1-ryan.roberts@arm.com>
 <20231009185008.3803879-5-ryan.roberts@arm.com>
 <86cyx9n1yp.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <86cyx9n1yp.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/10/2023 09:16, Marc Zyngier wrote:
> On Mon, 09 Oct 2023 19:50:00 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> Expose FEAT_LPA2 as a capability so that we can take advantage of
>> alternatives patching in both the kernel and hypervisor.
>>
>> Although FEAT_LPA2 presence is advertised separately for stage1 and
>> stage2, the expectation is that in practice both stages will either
>> support or not support it. Therefore, for the case where KVM is present,
>> we combine both into a single capability, allowing us to simplify the
>> implementation. For the case where KVM is not present, we only care
>> about stage1.
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  arch/arm64/include/asm/cpufeature.h |  5 ++++
>>  arch/arm64/kernel/cpufeature.c      | 46 +++++++++++++++++++++++++++++
>>  arch/arm64/tools/cpucaps            |  1 +
>>  3 files changed, 52 insertions(+)
>>
>> diff --git a/arch/arm64/include/asm/cpufeature.h b/arch/arm64/include/asm/cpufeature.h
>> index 5bba39376055..b1292ec88538 100644
>> --- a/arch/arm64/include/asm/cpufeature.h
>> +++ b/arch/arm64/include/asm/cpufeature.h
>> @@ -831,6 +831,11 @@ static inline bool system_supports_tlb_range(void)
>>  		cpus_have_const_cap(ARM64_HAS_TLB_RANGE);
>>  }
>>  
>> +static inline bool system_supports_lpa2(void)
>> +{
>> +	return cpus_have_const_cap(ARM64_HAS_LPA2);
> 
> cpus_have_const_cap() is going away. You may want to look at Mark's
> series to see how to replace this one.
> 
>> +}
>> +
>>  int do_emulate_mrs(struct pt_regs *regs, u32 sys_reg, u32 rt);
>>  bool try_emulate_mrs(struct pt_regs *regs, u32 isn);
>>  
>> diff --git a/arch/arm64/kernel/cpufeature.c b/arch/arm64/kernel/cpufeature.c
>> index 444a73c2e638..1ccb1fe0e310 100644
>> --- a/arch/arm64/kernel/cpufeature.c
>> +++ b/arch/arm64/kernel/cpufeature.c
>> @@ -1746,6 +1746,46 @@ static bool unmap_kernel_at_el0(const struct arm64_cpu_capabilities *entry,
>>  	return !meltdown_safe;
>>  }
>>  
>> +static inline bool has_lpa2_at_stage1(u64 mmfr0)
> 
> Why inline? It isn't like this has any performance implication...
> 
>> +{
>> +#if defined(CONFIG_ARM64_4K_PAGES) || defined(CONFIG_ARM64_16K_PAGES)
>> +	unsigned int tgran;
>> +
>> +	tgran = cpuid_feature_extract_unsigned_field(mmfr0,
>> +						ID_AA64MMFR0_EL1_TGRAN_SHIFT);
>> +	return tgran == ID_AA64MMFR0_EL1_TGRAN_LPA2;
>> +#else
>> +	return false;
>> +#endif
> 
> Writing this using IS_ENABLED() would be slightly more pleasing to my
> tired eyes... ;-)

Unfortunately this doesn't work because ID_AA64MMFR0_EL1_TGRAN_LPA2 is only
defined for 4K and 16K configs (there is no field ofr 64K). So proposing to do
it this way instead. Please shout if you have a better idea:

#if defined(CONFIG_ARM64_4K_PAGES) || defined(CONFIG_ARM64_16K_PAGES)
static bool has_lpa2_at_stage1(u64 mmfr0)
{
	unsigned int tgran;

	tgran = cpuid_feature_extract_unsigned_field(mmfr0,
					ID_AA64MMFR0_EL1_TGRAN_SHIFT);
	return tgran == ID_AA64MMFR0_EL1_TGRAN_LPA2;
}

static bool has_lpa2_at_stage2(u64 mmfr0)
{
	unsigned int tgran;

	tgran = cpuid_feature_extract_unsigned_field(mmfr0,
					ID_AA64MMFR0_EL1_TGRAN_2_SHIFT);
	return tgran == ID_AA64MMFR0_EL1_TGRAN_2_SUPPORTED_LPA2;
}

static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
{
	u64 mmfr0;

	mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
	return has_lpa2_at_stage1(mmfr0) && has_lpa2_at_stage2(mmfr0);
}
#else
static bool has_lpa2(const struct arm64_cpu_capabilities *entry, int scope)
{
	return false;
}
#endif

