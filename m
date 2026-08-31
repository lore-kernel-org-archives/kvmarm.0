Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C0634FF41;
	Mon, 31 Aug 2026 09:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788169054; cv=none; b=n3GLlBUiA7ob8+k7dYpWn1EcGn2I0oLACK+zZr6kbTx3HZu27ndGBIVwIAzmMtOn4BGngZH+B6wLXVS0onEJJgPhPJ/PW7n73eTK5OS9uLtGgo6ExSczjmyfuFUloSA/0naVNudJ8+evATVm2DcP8JBakazupA2t3GOUhAjgr7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788169054; c=relaxed/simple;
	bh=iK6xfi84WmdzkiINZsc/AcFowbeVUr0PYoVNHiRZVZc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=PSgx1AndoJflpVJ6KdgJL7lX+2Z0GBK8phRFQ/irSIX9P2PqEsc2jmU9axon5dw7jDp05C42TfNsNRFdHsqiP1T3HhWDcUGG6PEFKEuAzdIbvsT9DeCuLhQgWRi4rwqlC0catNcnkmCkrmyz6XgoGWoud4uKYSCcwmzlIsNQRTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=T9OXODxV; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="T9OXODxV"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=fxyHUPDqedlVwnPeXPKRGHtoFJm4kHYf1rIkAIu3MBM=;
	b=T9OXODxVF6+EY1qmsgL6L2p1IoaD1/XHSKcAlfsVOZ0TxpvZZimqfUnsmHPTHgnE2TODureA2
	aBJdZHm4Gl1G4F1VhIghoy0+mb8SiPRpX8Lv2ILgyRd/2YbyrRqQSAC33CYLo5bJzg2zJ2hg55h
	g3uRi2geIOas7pzSdLIAO2I=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4hYNsg6psTz1prlh;
	Mon, 31 Aug 2026 17:26:31 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 7952B4057D;
	Mon, 31 Aug 2026 17:37:22 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 31 Aug 2026 17:37:21 +0800
Message-ID: <67dcf2d1-48e6-4aac-b516-1bb78b537c3f@huawei.com>
Date: Mon, 31 Aug 2026 17:37:21 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] KVM: arm64: Add HDBSS per-vCPU buffer management
To: <sashiko-reviews@lists.linux.dev>
CC: Oliver Upton <oupton@kernel.org>, Marc Zyngier <maz@kernel.org>,
	<kvmarm@lists.linux.dev>, <kvm@vger.kernel.org>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-5-zhengtian10@huawei.com>
 <20260709111538.0AEDD1F000E9@smtp.kernel.org>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <20260709111538.0AEDD1F000E9@smtp.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 kwepemr100010.china.huawei.com (7.202.195.125)



On 7/9/2026 7:15 PM, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 6 potential issue(s) to consider:
> - [High] Broken error handling in `kvm_arch_vcpu_create` leads to success masking and hypervisor memory leaks.
> - [High] The hardware producer index `SYS_HDBSSPROD_EL2` is lost during vCPU context switch.
> - [High] `__load_hdbss()` risks a fatal UNDEFINED exception on hardware lacking HDBSS.
> - [High] Misinterpretation of the `order` parameter causes memory waste or buffer undersizing on non-4KB page granules.
> - [Medium] Missing context synchronization event (ISB) after control-plane system register write.
> - [Low] Memory leak when an allocation resolves to physical address 0.
> --
> 
> --- Patch [4]: [PATCH v4 4/6] KVM: arm64: Add HDBSS per-vCPU buffer management ---
> commit 1967caa637e339cacc49eecff93c9e0e02ecad9e
> Author: eillon <yezhenyu2@huawei.com>
> 
> KVM: arm64: Add HDBSS per-vCPU buffer management
> 
> This commit introduces the infrastructure for HDBSS (Hardware Dirty Bit State
> Structure) per-vCPU buffer management, including allocation, freeing, and
> loading of HDBSS registers during vCPU load.
> 
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -565,6 +566,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   	err = kvm_share_hyp(vcpu, vcpu + 1);
>>   	if (err)
>>   		kvm_vgic_vcpu_destroy(vcpu);
>>   
>> +	if (vcpu->kvm->arch.enable_hdbss) {
>> +		err = kvm_arm_vcpu_alloc_hdbss(vcpu, vcpu->kvm->arch.hdbss_order);
> 
> [Severity: High]
> Does this code mask kvm_share_hyp() failures? If kvm_share_hyp() fails, the
> code falls through. If HDBSS is enabled and allocation succeeds, err is
> overwritten to 0.
> 
> Additionally, if kvm_share_hyp() succeeds but kvm_arm_vcpu_alloc_hdbss() fails,
> is the hypervisor mapping leaked since kvm_unshare_hyp() isn't called before
> returning?
> 
>> +		if (err)
>> +			kvm_vgic_vcpu_destroy(vcpu);
>> +	}
>> +
>>   	return err;
>>   }
> 
>> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
>> --- /dev/null
>> +++ b/arch/arm64/kvm/dirty_bit.c
> [ ... ]
>> +int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order)
>> +{
>> +	struct page *hdbss_pg = NULL;
>> +
>> +	if (vcpu->arch.hdbss.hdbssbr_el2 || !system_supports_hdbss())
>> +		return 0;
>> +
>> +	if (order > HDBSS_MAX_ORDER)
>> +		return -EINVAL;
>> +
>> +	hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT, order);
>> +	if (!hdbss_pg)
>> +		return -ENOMEM;
>> +
>> +	vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
>> +		.base_phys = page_to_phys(hdbss_pg),
>> +		.hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg), order),
> 

Addressed in v5, The error path now returns immediately on
kvm_share_hyp() failure, and HDBSS allocation failure calls
kvm_unshare_hyp():

```
err = kvm_share_hyp(vcpu, vcpu + 1);
if (err) {
         kvm_vgic_vcpu_destroy(vcpu);
         return err;
}

err = kvm_arm_vcpu_alloc_hdbss(vcpu);
if (err) {
         kvm_unshare_hyp(vcpu, vcpu + 1);
         kvm_vgic_vcpu_destroy(vcpu);
         return err;
}
```

> [Severity: High]
> Is the order parameter interpreted differently depending on the page granule
> size? The order parameter is used both for alloc_pages() (which scales by
> PAGE_SIZE) and HDBSSBR_EL2() (which expects an absolute hardware size).
> 
> On 64KB pages, supplying order=9 for a 2MB buffer would allocate 32MB from the
> buddy allocator, while order=5 would configure the hardware for 128KB.
> 
>> +		.hdbssprod_el2 = 0,
>> +	};
>> +
>> +	return 0;
>> +}
>> +
>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
>> +{
>> +	struct page *hdbss_pg;
>> +
>> +	if (!vcpu->arch.hdbss.hdbssbr_el2) {
>> +		return;
>> +	}
> 

Fixed in v5. The order parameter is removed. Buffer size is tracked in
bytes, with separate conversions for the buddy allocator (get_order) and
hardware SZ encoding (ilog2(size) - 12).

> [Severity: Low]
> Could this leak the buffer if the buddy allocator returns physical address 0
> and order is 0? The resulting HDBSSBR_EL2 value would be 0, causing this
> early return to intercept a valid allocation.
> 
>> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
>> --- a/arch/arm64/kvm/hyp/vhe/switch.c
>> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> [ ... ]
>> @@ -213,6 +214,19 @@ static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
>>   	local_irq_restore(flags);
>>   }
>>   
>> +static void __load_hdbss(struct kvm_vcpu *vcpu)
>> +{
>> +	struct kvm *kvm = vcpu->kvm;
>> +
>> +	if (!kvm->arch.enable_hdbss)
>> +		return;
>> +
>> +	write_sysreg_s(vcpu->arch.hdbss.hdbssbr_el2, SYS_HDBSSBR_EL2);
> 

Addressed in v5. vcpu_hdbss_state now stores a struct page * instead of
a physical address, and the allocation check uses the page pointer. This
eliminates the PA == 0 special case entirely.

> [Severity: High]
> Will __load_hdbss() trigger a fatal UNDEFINED exception on hardware without
> HDBSS? The function relies solely on kvm->arch.enable_hdbss. If it is enabled
> but the hardware lacks support, accessing SYS_HDBSSBR_EL2 could panic the
> hypervisor.
> 
>> +	write_sysreg_s(vcpu->arch.hdbss.hdbssprod_el2, SYS_HDBSSPROD_EL2);
> 

v5 already handles this. vcpu_hdbss_enabled() checks hw_mmu->vtcr &
VTCR_EL2_HDBSS, and that bit only gets set through
kvm_arm_enable_hdbss_global(), which is guarded by
system_supports_hdbss(). So __load_hdbss() doesn't need to check again.
Hardware support is already guaranteed at that point.

> [Severity: Medium]
> Is an isb() required immediately after writing to SYS_HDBSSBR_EL2? ARM64
> subsystem rules state that every write to a control-plane system register must
> be followed by an isb() as the very next instruction.
> 
>> +
>> +	isb();
>> +}
>> +
>>   void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>>   {
>>   	host_data_ptr(host_ctxt)->__hyp_running_vcpu = vcpu;
>> @@ -220,6 +234,7 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
>>   	__vcpu_load_switch_sysregs(vcpu);
>>   	__vcpu_load_activate_traps(vcpu);
>>   	__load_stage2(vcpu->arch.hw_mmu);
>> +	__load_hdbss(vcpu);
>>   }
>>   
>>   void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
>>   {
>>   	__vcpu_put_deactivate_traps(vcpu);
>>   	__vcpu_put_switch_sysregs(vcpu);
>>   
>>   	host_data_ptr(host_ctxt)->__hyp_running_vcpu = NULL;
>>   }
> 

Not required. The architecture only requires an ISB to make the effects
visible, and it's fine to batch multiple system register writes with one
trailing ISB. __load_hdbss() follows the same pattern as
__load_stage2(), which writes VTCR_EL2 and VTTBR_EL2 back-to-back with a
single ISB. So the existing isb() in __load_hdbss() is sufficient.

> [Severity: High]
> Are the hardware producer index updates lost during context switch?
> 
> The producer index is loaded in kvm_vcpu_load_vhe(), but it doesn't appear KVM
> reads and saves it back to vcpu->arch.hdbss.hdbssprod_el2 during
> kvm_vcpu_put_vhe(). Would this rewind the hardware index on the next load?
> 

Addressed in v5, kvm_vcpu_put_vhe() now saves HDBSSPROD_EL2 into vcpu-
 >arch.hdbss.hdbssprod_el2, and __load_hdbss() restores it on the next
load, so the producer index survives context switches and cross-CPU
migration.

Thanks!
Tian
