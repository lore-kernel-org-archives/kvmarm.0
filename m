Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF2483CFF7C;
	Fri, 20 Mar 2026 16:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774025136; cv=none; b=khKvdpNFUzl2bhYc+VrktztvYCCUDX6t9Wlu+jcjlNkGYW8ayoft0HtgFB1LJlCS9QdBVgjhwfA6i/lfzkh/uZbWxm7ZGAnyJNUvYINVHKgg7QNiprXo7aXsVn1f5fapl/54Z4LyvXY700hddU0FngumWBlPyMkpGaKqwkG7bUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774025136; c=relaxed/simple;
	bh=bAHNVJiIobG+XKAk6kuFObG1ZgOsRGgq8KKQ1d9jUwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qECUdCaeXhqKo31KO7tWKQsT2NX2ZUEUDFUGqNl4/+NpSq1loVh8VqePaU9A/Rqj0YWK69DBbXJPXOUz3zTexJy4Xw2y+cF+NBxhLCmBGwnLEdTUQylyFRF8q3xWR8g0YdPzxPqMf6yZNCG3pDhI31CHAsKaMhYuRxvWuRHqqlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 475FF165C;
	Fri, 20 Mar 2026 09:45:28 -0700 (PDT)
Received: from [10.1.29.20] (e122027.cambridge.arm.com [10.1.29.20])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4D2FF3F7BD;
	Fri, 20 Mar 2026 09:45:30 -0700 (PDT)
Message-ID: <a30aeb78-1aef-4b56-b30c-0ed2ae05e74a@arm.com>
Date: Fri, 20 Mar 2026 16:45:28 +0000
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 39/48] arm64: RMI: Propagate number of breakpoints and
 watchpoints to userspace
To: Wei-Lin Chang <weilin.chang@arm.com>, kvm@vger.kernel.org,
 kvmarm@lists.linux.dev
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
 Gavin Shan <gshan@redhat.com>, Shanker Donthineni <sdonthineni@nvidia.com>,
 Alper Gun <alpergun@google.com>, "Aneesh Kumar K . V"
 <aneesh.kumar@kernel.org>, Emi Kisanuki <fj0570is@fujitsu.com>,
 Vishal Annapurve <vannapurve@google.com>
References: <20260318155413.793430-1-steven.price@arm.com>
 <20260318155413.793430-40-steven.price@arm.com>
 <yqg4omdkqvslldhxbdzctbgxirxomw6mparqvhuybwyzthhdy3@6glrgqmfydsj>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <yqg4omdkqvslldhxbdzctbgxirxomw6mparqvhuybwyzthhdy3@6glrgqmfydsj>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 19/03/2026 18:50, Wei-Lin Chang wrote:
> On Wed, Mar 18, 2026 at 03:54:03PM +0000, Steven Price wrote:
>> From: Jean-Philippe Brucker <jean-philippe@linaro.org>
>>
>> The RMM describes the maximum number of BPs/WPs available to the guest
>> in the Feature Register 0. Propagate those numbers into ID_AA64DFR0_EL1,
>> which is visible to userspace. A VMM needs this information in order to
>> set up realm parameters.
>>
>> Signed-off-by: Jean-Philippe Brucker <jean-philippe@linaro.org>
>> Signed-off-by: Steven Price <steven.price@arm.com>
>> Reviewed-by: Gavin Shan <gshan@redhat.com>
>> Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
>> Reviewed-by: Joey Gouly <joey.gouly@arm.com>
>> ---
>>  arch/arm64/include/asm/kvm_rmi.h |  2 ++
>>  arch/arm64/kvm/rmi.c             | 22 ++++++++++++++++++++++
>>  arch/arm64/kvm/sys_regs.c        |  2 +-
>>  3 files changed, 25 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/kvm_rmi.h b/arch/arm64/include/asm/kvm_rmi.h
>> index 17bb7e2a2aa0..8fb526764c30 100644
>> --- a/arch/arm64/include/asm/kvm_rmi.h
>> +++ b/arch/arm64/include/asm/kvm_rmi.h
>> @@ -87,6 +87,8 @@ struct realm_rec {
>>  void kvm_init_rmi(void);
>>  u32 kvm_realm_ipa_limit(void);
>>  
>> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val);
>> +
>>  bool kvm_rmi_supports_sve(void);
>>  bool kvm_rmi_supports_pmu(void);
>>  
>> diff --git a/arch/arm64/kvm/rmi.c b/arch/arm64/kvm/rmi.c
>> index 8dc090da6e5f..01519d934d3a 100644
>> --- a/arch/arm64/kvm/rmi.c
>> +++ b/arch/arm64/kvm/rmi.c
>> @@ -212,6 +212,28 @@ u32 kvm_realm_ipa_limit(void)
>>  	return u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_S2SZ);
>>  }
>>  
>> +u64 kvm_realm_reset_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>> +{
>> +	u32 bps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_BPS);
>> +	u32 wps = u64_get_bits(rmm_feat_reg0, RMI_FEATURE_REGISTER_0_NUM_WPS);
>> +	u32 ctx_cmps;
>> +
>> +	if (!kvm_is_realm(vcpu->kvm))
>> +		return val;
>> +
>> +	/* Ensure CTX_CMPs is still valid */
>> +	ctx_cmps = FIELD_GET(ID_AA64DFR0_EL1_CTX_CMPs, val);
>> +	ctx_cmps = min(bps, ctx_cmps);
>> +
>> +	val &= ~(ID_AA64DFR0_EL1_BRPs_MASK | ID_AA64DFR0_EL1_WRPs_MASK |
>> +		 ID_AA64DFR0_EL1_CTX_CMPs);
>> +	val |= FIELD_PREP(ID_AA64DFR0_EL1_BRPs_MASK, bps) |
>> +	       FIELD_PREP(ID_AA64DFR0_EL1_WRPs_MASK, wps) |
>> +	       FIELD_PREP(ID_AA64DFR0_EL1_CTX_CMPs, ctx_cmps);
>> +
>> +	return val;
>> +}
>> +
>>  static int get_start_level(struct realm *realm)
>>  {
>>  	return 4 - stage2_pgtable_levels(realm->ia_bits);
>> diff --git a/arch/arm64/kvm/sys_regs.c b/arch/arm64/kvm/sys_regs.c
>> index 46f5e2ab3e2c..83b5c36f43bf 100644
>> --- a/arch/arm64/kvm/sys_regs.c
>> +++ b/arch/arm64/kvm/sys_regs.c
>> @@ -2043,7 +2043,7 @@ static u64 sanitise_id_aa64dfr0_el1(const struct kvm_vcpu *vcpu, u64 val)
>>  	/* Hide BRBE from guests */
>>  	val &= ~ID_AA64DFR0_EL1_BRBE_MASK;
>>  
>> -	return val;
>> +	return kvm_realm_reset_id_aa64dfr0_el1(vcpu, val);
> 
> Hi,
> 
> Nit:
> In other places we condition on kvm_is_realm() to separate
> realm/non-realm paths but here everyone goes into kvm_realm_*, do you
> think it's more consistent to move the kvm_is_realm() check out of this
> function?

Yes I agree that would be more consistent.

Thanks,
Steve

> Thanks,
> Wei-Lin Chang
> 
>>  }
>>  
>>  /*
>> -- 
>> 2.43.0
>>

