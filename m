Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3070620C46C;
	Mon,  7 Apr 2025 16:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744043724; cv=none; b=NZJ2Vy73Xgfg4TlkcHdRLOYqq5ciU8K5n1nac5/ONfM1csDc81Rrr3OKq9+oyyg79seiP3D0YoNNYNxECGvqPHojejSKTiNpj9Dl6e/k40du2nRMUGSYzLUBu8WGDPrpEsHcEAQOUd4bgjKw67ZMYHGX0ARPxPhc9F30i5HmHHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744043724; c=relaxed/simple;
	bh=LNnD2bDITRNhLIrHQbKqo/V3F9P9CZyDllsCX405OgA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D5V4gx0UFqgDnLTREyucdqNjRER1VzH37bHQFpDMdHurWO4qJSD/rO6+9TETh+lGk6t871Zx8ZGveqA4jNse1jx+yTv725ugIFHVfPzusM9Bs4uXB4BNRVwGc76LrWyFJf31PeekpEGTmUK/XrJsNo6p0FOBOTCucXIU4p/glMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A6174106F;
	Mon,  7 Apr 2025 09:35:23 -0700 (PDT)
Received: from [10.57.17.31] (unknown [10.57.17.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D9893F694;
	Mon,  7 Apr 2025 09:35:18 -0700 (PDT)
Message-ID: <adbca476-7d0f-473d-a2a2-0a29a497dbca@arm.com>
Date: Mon, 7 Apr 2025 17:35:16 +0100
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 35/45] arm64: RME: Propagate number of breakpoints and
 watchpoints to userspace
To: Gavin Shan <gshan@redhat.com>, kvm@vger.kernel.org, kvmarm@lists.linux.dev
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Marc Zyngier <maz@kernel.org>,
 Will Deacon <will@kernel.org>, James Morse <james.morse@arm.com>,
 Oliver Upton <oliver.upton@linux.dev>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Zenghui Yu
 <yuzenghui@huawei.com>, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, Joey Gouly <joey.gouly@arm.com>,
 Alexandru Elisei <alexandru.elisei@arm.com>,
 Christoffer Dall <christoffer.dall@arm.com>, Fuad Tabba <tabba@google.com>,
 linux-coco@lists.linux.dev,
 Ganapatrao Kulkarni <gankulkarni@os.amperecomputing.com>,
 Shanker Donthineni <sdonthineni@nvidia.com>, Alper Gun
 <alpergun@google.com>, "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>
References: <20250213161426.102987-1-steven.price@arm.com>
 <20250213161426.102987-36-steven.price@arm.com>
 <c8af8a7f-5ee4-460b-aec4-959f688db628@redhat.com>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <c8af8a7f-5ee4-460b-aec4-959f688db628@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 04/03/2025 23:45, Gavin Shan wrote:
> On 2/14/25 2:14 AM, Steven Price wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> The RMM describes the maximum number of BPs/WPs available to the guest
>> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
>> which is visible to userspace. A VMM needs this information in order to
>> set up realm parameters.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> ---
>>   arch/arm64/include/asm/kvm_rme.h |  2 ++
>>   arch/arm64/kvm/rme.c             | 22 ++++++++++++++++++++++
>>   arch/arm64/kvm/sys_regs.c        |  2 +-
>>   3 files changed, 25 insertions(+), 1 deletion(-)
>>
> 
> With the following one nitpick addressed:
> 
> Reviewed-by: Gavin Shan <gshan@redhat.com>
> 
>> diff --git a/arch/arm64/include/asm/kvm_rme.h b/arch/arm64/include/
>> asm/kvm_rme.h
>> index d684b30493f5..67ee38541a82 100644
>> --- a/arch/arm64/include/asm/kvm_rme.h
>> +++ b/arch/arm64/include/asm/kvm_rme.h
>> @@ -85,6 +85,8 @@ void kvm_init_rme(void);
>>   u32 kvm_realm_ipa_limit(void);
>>   u32 kvm_realm_vgic_nr_lr(void);
>>   +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
>> u64 val);
>> +
>>   bool kvm_rme_supports_sve(void);
>>     int kvm_realm_enable_cap(struct kvm *kvm, struct kvm_enable_cap
>> *cap);
>> diff --git a/arch/arm64/kvm/rme.c b/arch/arm64/kvm/rme.c
>> index f83f34358832..8c426f575728 100644
>> --- a/arch/arm64/kvm/rme.c
>> +++ b/arch/arm64/kvm/rme.c
>> @@ -87,6 +87,28 @@ u32 kvm_realm_vgic_nr_lr(void)
>>       return u64_get_bits(rmm_feat_reg0,
>> RMI_FEATURE_REGISTER_0_GICV3_NUM_LRS);
>>   }
>>   +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu,
>> u64 val)
>> +{
>> +    u32 bps = u64_get_bits(rmm_feat_reg0,
>> RMI_FEATURE_REGISTER_0_NUM_BPS);
>> +    u32 wps = u64_get_bits(rmm_feat_reg0,
>> RMI_FEATURE_REGISTER_0_NUM_WPS);
>> +    u32 ctx_cmps;
>> +
>> +    if (!kvm_is_realm(vcpu->kvm))
>> +        return val;
>> +
>> +    /* Ensure CTX_CMPs is still valid */
>> +    ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
>> +    ctx_cmps = min(bps, ctx_cmps);
>> +
>> +    val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
>> +         ID_AA64DFR0_EL1_CTX_CMPs);
>> +    val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
>> +           FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
>> +           FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
>> +
>> +    return val;
>> +}
>> +
> 
> The chunk of code can be squeezed to
> sys_reg.c::sanitise_id_aa64dfr0_el1() since
> sys_reg.c has been plumbed for realm, no reason to keep a separate
> helper in rme.c
> because it's only called by sys_reg.c::sanitise_id_aa64dfr0_el1()

The issue here is the rmm_feat_reg0 variable - it's currently static in
rme.c - so I can't just shift the code over. I could obviously provide
helpers to get the necessary information but this seemed cleaner.

Thanks,
Steve

>>   static int get_start_level(struct realm *realm)
>>   {
>>       return 4 - ((realm->ia_bits - 8) / (RMM_PAGE_SHIFT - 3));
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index ed881725eb64..5618eff33155 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -1820,7 +1820,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct
>> kvm_vcpu *vcpu, u64 val)
>>       /* Hide BRBE from guests */
>>       val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>>   -    return val;
>> +    return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
>>   }
>>     static int set_id_aa64dfr0_el1(struct kvm_vcpu *vcpu,
> 
> Thanks,
> Gavin
> 

