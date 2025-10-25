Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 464CD2D8393
	for <kvmarm@lists.linux.dev>; Sat, 25 Oct 2025 10:11:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761387103; cv=none; b=sIlgswNzLvyFgin4ICd1w0FFyBv6pMcGO6/2GiAVhhLPAqHQTA6ggZYJ6+Mbr5TOrHKFIUdpQhQ3mHxZUy6GXOqj41YxNfjkoNEY0P1Tg4369ZwfPHeOCoG5YSYZplkDAJMLzIdfwzisBGSFoOb4U+7PBdvED5L0xrXwcz7eLd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761387103; c=relaxed/simple;
	bh=f0cu9V1ayg+/pEze82TR61EZ1WWDaAQoo6qo3iOfBjI=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=FMuN25/GLSNU6UKvONuJUjvjrPIeW6NSMSZi+RJumIVDNOPqsNn/9iP1zsOSntdo8HKow9hfW2QwJlx7LMDvGmuRMrSxDWmAilI7nso+GnwEYoO4zYXn2AMIdXtd/0y7Q2pPBKQcAslmeogkQuAJe4STDpikvjQ7KbnRYDB64s0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com; spf=pass smtp.mailfrom=hisilicon.com; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hisilicon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hisilicon.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4ctwWh4BY3z1T4Fg;
	Sat, 25 Oct 2025 18:10:40 +0800 (CST)
Received: from dggemv712-chm.china.huawei.com (unknown [10.1.198.32])
	by mail.maildlp.com (Postfix) with ESMTPS id ECC6B180488;
	Sat, 25 Oct 2025 18:11:38 +0800 (CST)
Received: from kwepemq200004.china.huawei.com (7.202.195.237) by
 dggemv712-chm.china.huawei.com (10.1.198.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:11:38 +0800
Received: from [10.67.121.115] (10.67.121.115) by
 kwepemq200004.china.huawei.com (7.202.195.237) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 25 Oct 2025 18:11:38 +0800
Message-ID: <ba558cbf-86df-67a8-e873-bc90d27cbf0b@hisilicon.com>
Date: Sat, 25 Oct 2025 18:11:37 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v6 3/7] KVM: arm64: Handle DABT caused by LS64*
 instructions on unsupported memory
Content-Language: en-US
To: Oliver Upton <oliver.upton@linux.dev>
CC: <catalin.marinas@arm.com>, <will@kernel.org>, <maz@kernel.org>,
	<joey.gouly@arm.com>, <suzuki.poulose@arm.com>, <yuzenghui@huawei.com>,
	<linux-arm-kernel@lists.infradead.org>, <kvmarm@lists.linux.dev>,
	<yangyccccc@gmail.com>, <prime.zeng@hisilicon.com>, <xuwei5@huawei.com>,
	"Zhou Wang" <wangzhou1@hisilicon.com>
References: <20251024090819.4097819-1-wangzhou1@hisilicon.com>
 <20251024090819.4097819-4-wangzhou1@hisilicon.com>
 <aPvZWY57ppqqWm50@linux.dev>
From: Zhou Wang <wangzhou1@hisilicon.com>
In-Reply-To: <aPvZWY57ppqqWm50@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemq200004.china.huawei.com (7.202.195.237)

On 2025/10/25 3:54, Oliver Upton wrote:
> Hi Zhou,
> 
> On Fri, Oct 24, 2025 at 05:08:15PM +0800, Zhou Wang wrote:
>> +/**
>> + * kvm_inject_dabt_excl_atomic - inject a data abort for unsupported exclusive
>> + *				 or atomic access
>> + * @vcpu: The VCPU to receive the data abort
>> + * @addr: The address to report in the DFAR
>> + *
>> + * It is assumed that this code is called from the VCPU thread and that the
>> + * VCPU therefore is not currently executing guest code.
>> + */
>> +void kvm_inject_dabt_excl_atomic(struct kvm_vcpu *vcpu, u64 addr)
>> +{
>> +	u64 esr;
>> +
>> +	/* Reuse the general DABT injection routine and modify the DFSC */
>> +	kvm_inject_sea(vcpu, false, addr);
> 
> This potentially injects a nested SEA which I'm not sure you want. There
> still is an interaction with nested, from DDI0487L.a B2.2.6:
> 
>   For the EL1&0 translation regime, if the atomic instruction is not
>   supported because of the memory type that is defined in the first
>   stage of translation, or the second stage of translation is not
>   enabled, then this exception is a first stage abort and is taken to
>   EL1. Otherwise, the exception is a second stage abort and is taken to EL2.
> 
> We don't need to worry about the S1 memory type since hardware will
> handle that for us. But we do need to consider whether the guest
> hypervisor enabled stage-2 translation or not and route accordingly.
> 
> int kvm_inject_nested_excl_atomic(struct kvm_vcpu *vcpu, u64 addr)
> {
> 	u64 esr = FIELD_PREP(ESR_ELx_EC_MASK, ESR_ELx_EC_DABT_LOW) |
> 		  FIELD_PREP(ESR_ELx_FSC, ESR_ELx_FSC_EXCL_ATOMIC) |
> 		  ESR_ELx_IL;
> 
> 	vcpu_write_sys_reg(vcpu, addr, FAR_EL2);
> 	return kvm_inject_nested_sync(vcpu, esr);
> }
> 
> int kvm_inject_excl_atomic(struct kvm_vcpu *vcpu, u64 addr)
> {
> 	if (is_nested_ctxt(vcpu) && (vcpu_read_sys_reg(vcpu, HCR_EL2) & HCR_VM))
> 		return kvm_inject_nested_excl_atomic(vcpu, addr);
> 
> 	__kvm_inject_sea(vcpu, false, addr);
> 	esr = vcpu_read_sys_reg(vcpu, exception_esr_elx(vcpu));
> 	esr &= ~ESR_ELx_FSC;
> 	esr |= ESR_ELx_FSC_EXCL_ATOMIC;
> 	vcpu_write_sys_reg(vcpu, esr, exception_esr_elx(vcpu));
> 	return 1;
> }

Hi Oliver,

Thanks for pointing this, will modify exception injection with
above code.

Best,
Zhou

> 
> Thanks,
> Oliver
> .
