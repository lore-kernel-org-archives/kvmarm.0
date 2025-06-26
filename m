Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59A0E273D65
	for <kvmarm@lists.linux.dev>; Thu, 26 Jun 2025 11:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750937990; cv=none; b=YNuwpLBgwykmAkqF/+RKdA0d2Ptgzc0Kj+hGpfFT2E2ntONfSgbCCABJcVuWPeyKm7YtwKaPJ+vm4izO5eqOU9XQ8VPP+wIMMv2CxyKdPfNlgxo/UPIfFfEk1Uuu4c4lAkaDg5MHU1TKrMk9eoS1IhQFEkkwP+Sf/puPO201keM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750937990; c=relaxed/simple;
	bh=Poy1nnAOHo0cXy/0wBVRI/5Q/n7pNkJI7q/7YkOADp8=;
	h=CC:Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=lExMWZ1TbUU/3jWmQTQAKc9EqAvnzEe6VUs0RVRPssX6uDi6//FfVIuRq50vrBwydt8ILWM9bBVfdxlRcdKM6GRT9KQqqdZ0q4trpzY7TYIX2OaKBDiVIGwNSSwGXBG0WN4v1rqQNsI6P1EKN9rDBxRRPx3aSHe2pq1vUNHTxjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4bSc7j1trPzdbk3;
	Thu, 26 Jun 2025 19:35:45 +0800 (CST)
Received: from dggemv706-chm.china.huawei.com (unknown [10.3.19.33])
	by mail.maildlp.com (Postfix) with ESMTPS id 8703D180450;
	Thu, 26 Jun 2025 19:39:43 +0800 (CST)
Received: from kwepemq200018.china.huawei.com (7.202.195.108) by
 dggemv706-chm.china.huawei.com (10.3.19.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Jun 2025 19:39:43 +0800
Received: from [10.67.121.177] (10.67.121.177) by
 kwepemq200018.china.huawei.com (7.202.195.108) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 26 Jun 2025 19:39:42 +0800
CC: <yangyicong@hisilicon.com>, <catalin.marinas@arm.com>, <will@kernel.org>,
	<corbet@lwn.net>, <linux-arm-kernel@lists.infradead.org>,
	<kvmarm@lists.linux.dev>, <linux-kselftest@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <joey.gouly@arm.com>, <suzuki.poulose@arm.com>,
	<yuzenghui@huawei.com>, <shuah@kernel.org>, <jonathan.cameron@huawei.com>,
	<shameerali.kolothum.thodi@huawei.com>, <linuxarm@huawei.com>,
	<prime.zeng@hisilicon.com>, <xuwei5@huawei.com>, <tangchengchang@huawei.com>,
	<wangzhou1@hisilicon.com>
Subject: Re: [PATCH v3 3/7] KVM: arm64: Handle DABT caused by LS64*
 instructions on unsupported memory
To: Marc Zyngier <maz@kernel.org>, <oliver.upton@linux.dev>
References: <20250626080906.64230-1-yangyicong@huawei.com>
 <20250626080906.64230-4-yangyicong@huawei.com> <86zfduc2ca.wl-maz@kernel.org>
From: Yicong Yang <yangyicong@huawei.com>
Message-ID: <44993060-7eb1-400c-9887-3d438aeb8ee9@huawei.com>
Date: Thu, 26 Jun 2025 19:39:41 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <86zfduc2ca.wl-maz@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 kwepemq200018.china.huawei.com (7.202.195.108)

On 2025/6/26 16:51, Marc Zyngier wrote:
> On Thu, 26 Jun 2025 09:09:02 +0100,
> Yicong Yang <yangyicong@huawei.com> wrote:
>>
>> From: Yicong Yang <yangyicong@hisilicon.com>
>>
>> If FEAT_LS64WB not supported, FEAT_LS64* instructions only support
>> to access Device/Uncacheable memory, otherwise a data abort for
>> unsupported Exclusive or atomic access (0x35) is generated per spec.
>> It's implementation defined whether the target exception level is
>> routed and is possible to implemented as route to EL2 on a VHE VM
>> according to DDI0487K.a Section C3.2.12.2 Single-copy atomic 64-byte
>> load/store.
> 
> Nit: in DDI0487L.b (the latest as I write), this is in C3.2.6.
> 

will update the reference.

>>
>> If it's implemented as generate the DABT to the final enabled stage
>> (stage-2), since no valid ISV indicated in the ESR, it's better for
>> the userspace to decide how to handle it. Reuse the
>> NISV_IO_ABORT_TO_USER path with exit reason KVM_EXIT_ARM_LDST64B.
>>
>> Signed-off-by: Yicong Yang <yangyicong@hisilicon.com>
>> ---
>>  arch/arm64/include/asm/esr.h |  8 ++++++++
>>  arch/arm64/kvm/mmu.c         | 21 ++++++++++++++++++++-
>>  2 files changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/esr.h b/arch/arm64/include/asm/esr.h
>> index e1deed824464..63cd17f830da 100644
>> --- a/arch/arm64/include/asm/esr.h
>> +++ b/arch/arm64/include/asm/esr.h
>> @@ -124,6 +124,7 @@
>>  #define ESR_ELx_FSC_SEA_TTW(n)	(0x14 + (n))
>>  #define ESR_ELx_FSC_SECC	(0x18)
>>  #define ESR_ELx_FSC_SECC_TTW(n)	(0x1c + (n))
>> +#define ESR_ELx_FSC_EXCL_ATOMIC	(0x35)
>>  #define ESR_ELx_FSC_ADDRSZ	(0x00)
>>  
>>  /*
>> @@ -488,6 +489,13 @@ static inline bool esr_fsc_is_access_flag_fault(unsigned long esr)
>>  	       (esr == ESR_ELx_FSC_ACCESS_L(0));
>>  }
>>  
>> +static inline bool esr_fsc_is_excl_atomic_fault(unsigned long esr)
>> +{
>> +	esr = esr & ESR_ELx_FSC;
>> +
>> +	return esr == ESR_ELx_FSC_EXCL_ATOMIC;
>> +}
>> +
>>  static inline bool esr_fsc_is_addr_sz_fault(unsigned long esr)
>>  {
>>  	esr &= ESR_ELx_FSC;
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 2942ec92c5a4..5f05d1c4b5a2 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -1665,6 +1665,24 @@ static int user_mem_abort(struct kvm_vcpu *vcpu, phys_addr_t fault_ipa,
>>  	if (exec_fault && device)
>>  		return -ENOEXEC;
>>  
>> +	/*
>> +	 * Target address is normal memory on the Host. We come here
>> +	 * because:
>> +	 * 1) Guest map it as device memory and perform LS64 operations
>> +	 * 2) VMM report it as device memory mistakenly
>> +	 * Hand it to the userspace.
>> +	 */
>> +	if (esr_fsc_is_excl_atomic_fault(kvm_vcpu_get_esr(vcpu))) {
>> +		struct kvm_run *run = vcpu->run;
>> +
>> +		run->exit_reason = KVM_EXIT_ARM_LDST64B;
>> +		run->arm_nisv.esr_iss = kvm_vcpu_dabt_iss_nisv_sanitized(vcpu);
>> +		run->arm_nisv.fault_ipa = fault_ipa |
>> +			(kvm_vcpu_get_hfar(vcpu) & (vma_pagesize - 1));
>> +
>> +		return -EAGAIN;
>> +	}
> 
> I'm not sure that's the right thing to do.
> 
> If:
> 
> - the guest was told it doesn't have LS64WB,
> 
> - it was told that some range is memory,
> 
> - it uses that range as device,
> 
> - thanks to FWB the resulting memory type is "Normal-Cacheable"
> 
> - which results in an Unsupported Atomic exception
> 
> why would we involve the VMM at all? The VMM clearly said it didn't
> want to be involved in this (we have a memslot).
> 

ok I thought we should make VMM do the decision in all the cases(both
here and emulated MMIO) based on the last discussion[*], I may
misunderstand it. If this is the case...

> I think we should simply inject the corresponding S1 fault back into
> the guest.
> 

let's simply inject a corresponding DABT back here and only make the VMM
handle the emulated MMIO case. will update if no further comment.

thanks.

[*] https://lore.kernel.org/linux-arm-kernel/Z_NkHWStDJLo0cmY@linux.dev/
