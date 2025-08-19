Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4471F265CC0
	for <kvmarm@lists.linux.dev>; Tue, 19 Aug 2025 06:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755586019; cv=none; b=qqq/DdlSNf78eyOMt/r3c7I4eWHP27OZ73UbIs9F9HMm8qWaBWBJ3fDWXk6HZx+iib5x4zhnO+LhFGAn3yC1KT65Pfa2xVg7na1XXmNtb8BcOBqiib+M8MuhMY6mwxhfC7YU0UK3c3181Ep9AT1LRD7RUTQaZMlucNNXMqvzuzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755586019; c=relaxed/simple;
	bh=3VjvM0UA0K8iBmYSTQrznqGE0MptvWh5Z31cwVqDuEs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EDNWs/H7jJgpLghz7OEIcTVzZRNivxGjDM8gLebyuPAfHatyUVl47XyL22Ne7hfKue0/gkfexAAXs2EDCalOKHzUXurl/3pLfXTWXcsf63RnR3saio/pPgZmwGlHlF7ao+bRlg52i5niCY7Egi/om9jZymspf+OsqyjnUvNn9BI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 61E4B152B;
	Mon, 18 Aug 2025 23:46:48 -0700 (PDT)
Received: from [10.164.146.16] (J09HK2D2RT.blr.arm.com [10.164.146.16])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B8693F63F;
	Mon, 18 Aug 2025 23:46:53 -0700 (PDT)
Message-ID: <b63b6344-ab7c-43d8-b418-e030344dfd7c@arm.com>
Date: Tue, 19 Aug 2025 12:16:50 +0530
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] arm64/sysreg: Replace TCR_EL1 field macros
To: Marc Zyngier <maz@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Oliver Upton <oliver.upton@linux.dev>, Mark Brown <broonie@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>, kvmarm@lists.linux.dev,
 linux-kernel@vger.kernel.org
References: <20250818045759.672408-1-anshuman.khandual@arm.com>
 <20250818045759.672408-3-anshuman.khandual@arm.com>
 <87jz30my30.wl-maz@kernel.org>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <87jz30my30.wl-maz@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 18/08/25 9:16 PM, Marc Zyngier wrote:
> On Mon, 18 Aug 2025 05:57:57 +0100,
> Anshuman Khandual <anshuman.khandual@arm.com> wrote:
>>
>> This just replaces all used TCR_EL1 field macros with tools sysreg variant
>> based fields and subsequently drops them from the header (pgtable-hwdef.h).
>> While here, also drop all the unused TCR_XXX macros from the header.
>>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Marc Zyngier <maz@kernel.org>
>> Cc: Mark Brown <broonie@kernel.org>
>> Cc: kvmarm@lists.linux.dev
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
>> ---
>>  arch/arm64/include/asm/assembler.h         |   6 +-
>>  arch/arm64/include/asm/cputype.h           |   2 +-
>>  arch/arm64/include/asm/kvm_arm.h           |  28 +++---
>>  arch/arm64/include/asm/kvm_nested.h        |   6 +-
>>  arch/arm64/include/asm/mmu_context.h       |   4 +-
>>  arch/arm64/include/asm/pgtable-hwdef.h     | 107 +++------------------
>>  arch/arm64/include/asm/pgtable-prot.h      |   2 +-
>>  arch/arm64/kernel/cpufeature.c             |   4 +-
>>  arch/arm64/kernel/pi/map_kernel.c          |   8 +-
>>  arch/arm64/kernel/vmcore_info.c            |   2 +-
>>  arch/arm64/kvm/arm.c                       |   6 +-
>>  arch/arm64/kvm/at.c                        |  48 ++++-----
>>  arch/arm64/kvm/hyp/include/hyp/switch.h    |   2 +-
>>  arch/arm64/kvm/hyp/include/hyp/sysreg-sr.h |   2 +-
>>  arch/arm64/kvm/hyp/nvhe/switch.c           |   2 +-
>>  arch/arm64/kvm/hyp/nvhe/tlb.c              |   2 +-
>>  arch/arm64/kvm/hyp/vhe/tlb.c               |   2 +-
>>  arch/arm64/kvm/nested.c                    |   8 +-
>>  arch/arm64/kvm/pauth.c                     |  12 +--
>>  arch/arm64/mm/proc.S                       |  29 +++---
>>  tools/arch/arm64/include/asm/cputype.h     |   2 +-
>>  21 files changed, 101 insertions(+), 183 deletions(-)
> 
> [...]
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 888f7c7abf54..b47d6d530e57 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -2000,10 +2000,10 @@ static void __init cpu_prepare_hyp_mode(int cpu, u32 hyp_va_bits)
>>  
>>  	tcr = read_sysreg(tcr_el1);
>>  	if (cpus_have_final_cap(ARM64_KVM_HVHE)) {
>> -		tcr &= ~(TCR_HD | TCR_HA | TCR_A1 | TCR_T0SZ_MASK);
>> -		tcr |= TCR_EPD1_MASK;
>> +		tcr &= ~(TCR_EL1_HD | TCR_EL1_HA | TCR_EL1_A1 | TCR_EL1_T0SZ_MASK);
>> +		tcr |= TCR_EL1_EPD1_MASK;
> 
> Except that none of that code is about EL1. At all.
> 
>>  	} else {
>> -		unsigned long ips = FIELD_GET(TCR_IPS_MASK, tcr);
>> +		unsigned long ips = FIELD_GET(TCR_EL1_IPS_MASK, tcr);
>>  
>>  		tcr &= TCR_EL2_MASK;
>>  		tcr |= TCR_EL2_RES1 | FIELD_PREP(TCR_EL2_PS_MASK, ips);
>> diff --git a/arch/arm64/kvm/at.c b/arch/arm64/kvm/at.c
>> index 0e5610533949..5f0f10ef38f0 100644
>> --- a/arch/arm64/kvm/at.c
>> +++ b/arch/arm64/kvm/at.c
>> @@ -134,8 +134,8 @@ static int setup_s1_walk(struct kvm_vcpu *vcpu, struct s1_walk_info *wi,
>>  	tbi = (wi->regime == TR_EL2 ?
>>  	       FIELD_GET(TCR_EL2_TBI, tcr) :
>>  	       (va55 ?
>> -		FIELD_GET(TCR_TBI1, tcr) :
>> -		FIELD_GET(TCR_TBI0, tcr)));
>> +		FIELD_GET(TCR_EL1_TBI1, tcr) :
>> +		FIELD_GET(TCR_EL1_TBI0, tcr)));
> 
> This is the reason number one why I dislike this patch.
> 
> Here, we deal with both the EL1&0 *and* the EL2&0 translation
> regimes. And I left the original definition *on purpose* so that
> nobody would read this code as being EL1-only. Now, you will glance
> over it with warm fuzzy feeling that you know what this is about --
> purely EL1. And that's what bugs are made of.
> 
> Of course, nothing changed functionally. But is it better? No.

Just wondering - will it be better to use TCR_EL1/TCR_EL2 definitions
conditionally for EL1&0 and EL2&0 translation regimes as applicable ?
Could there any other better method here ? Because the current situation
where there are some custom TCR macros, some tools sysreg generated macros,
and then those macros getting used in an adhoc manner in different places,
is not very consistent either.
