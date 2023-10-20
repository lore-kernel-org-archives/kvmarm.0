Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C1F01DA38
	for <kvmarm@lists.linux.dev>; Fri, 20 Oct 2023 15:07:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 6317D143D;
	Fri, 20 Oct 2023 08:08:09 -0700 (PDT)
Received: from [10.1.30.154] (XHFQ2J9959.cambridge.arm.com [10.1.30.154])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 170F93F762;
	Fri, 20 Oct 2023 08:07:26 -0700 (PDT)
Message-ID: <b25d383a-f4bc-4d09-84d2-aa6e1e8aa748@arm.com>
Date: Fri, 20 Oct 2023 16:07:26 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 07/12] KVM: arm64: Prepare TCR_EL2.PS in
 cpu_prepare_hyp_mode()
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
 <20231009185008.3803879-8-ryan.roberts@arm.com>
 <86a5sdmyyp.wl-maz@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <86a5sdmyyp.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/10/2023 10:21, Marc Zyngier wrote:
> On Mon, 09 Oct 2023 19:50:03 +0100,
> Ryan Roberts <ryan.roberts@arm.com> wrote:
>>
>> With the addition of LPA2 support in the hypervisor, the PA size
>> supported by the HW must be capped with a runtime decision, rather than
>> simply using a compile-time decision based on PA_BITS. For example, on a
>> system that advertises 52 bit PA but does not support FEAT_LPA2, A 4KB
>> or 16KB kernel compiled with LPA2 support must still limit the PA size
>> to 48 bits.
>>
>> Therefore, move the insertion of the PS field into TCR_EL2 out of
>> __kvm_hyp_init assembly code and instead do it in cpu_prepare_hyp_mode()
>> where the rest of TCR_EL2 is prepared. This allows us to figure out PS
>> with kvm_get_parange(), which has the appropriate logic to ensure the
>> above requirement. (and the PS field of VTCR_EL2 is already populated
>> this way).
>>
>> Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>> ---
>>  arch/arm64/kvm/arm.c               | 3 +++
>>  arch/arm64/kvm/hyp/nvhe/hyp-init.S | 4 ----
>>  2 files changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 73cc67c2a8a7..0bb8918475d2 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -1726,6 +1726,7 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
>>  {
>>  	struct kvm_nvhe_init_params *params = per_cpu_ptr_nvhe_sym(kvm_init_params, cpu);
>>  	unsigned long tcr;
>> +	u64 mmfr0 = read_sanitised_ftr_reg(SYS_ID_AA64MMFR0_EL1);
> 
> nit: move this one up by a line (yes, I'm being difficult).

ACK.

> 
>>  
>>  	/*
>>  	 * Calculate the raw per-cpu offset without a translation from the
>> @@ -1747,6 +1748,8 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
>>  	}
>>  	tcr &= ~TCR_T0SZ_MASK;
>>  	tcr |= TCR_T0SZ(hyp_va_bits);
>> +	tcr &= ~TCR_EL2_PS_MASK;
>> +	tcr |= FIELD_PREP(TCR_EL2_PS_MASK, kvm_get_parange(mmfr0));
>>  	if (system_supports_lpa2())
>>  		tcr |= TCR_EL2_DS;
>>  	params->tcr_el2 = tcr;
>> diff --git a/arch/arm64/kvm/hyp/nvhe/hyp-init.S b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> index 1cc06e6797bd..f62a7d360285 100644
>> --- a/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> +++ b/arch/arm64/kvm/hyp/nvhe/hyp-init.S
>> @@ -122,11 +122,7 @@ alternative_if ARM64_HAS_CNP
>>  alternative_else_nop_endif
>>  	msr	ttbr0_el2, x2
>>  
>> -	/*
>> -	 * Set the PS bits in TCR_EL2.
>> -	 */
>>  	ldr	x0, [x0, #NVHE_INIT_TCR_EL2]
>> -	tcr_compute_pa_size x0, #TCR_EL2_PS_SHIFT, x1, x2
>>  	msr	tcr_el2, x0
>>  
>>  	isb
> 
> Ah, this is where this was hiding. This should be folded into the
> previous patch for consistency (this is otherwise non bisectable).

ACK.

> 
> Thanks,
> 
> 	M.
> 

