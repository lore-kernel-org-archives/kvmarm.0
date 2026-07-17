Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97F2A1531C8
	for <kvmarm@lists.linux.dev>; Fri, 17 Jul 2026 04:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784261177; cv=none; b=Jo2j8mIP+uYX1yjpfGY87zl/LL0CifVC5uO7qvlERcHLZFMsfEsVtJQCk/89LPtUbpvjuAesB0KgHNcGWvr1yu6w+NaKfPJroysUmyw/GHFvT7n6X8wr+/JqIqFZQE4ykpPkUSGnxuu2a/iJmLlhfJiDAV17qQmz8mNhBZhcd+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784261177; c=relaxed/simple;
	bh=nBEonrF+KepR8VPx+cooFBF+qIMh4tLH/YyQrn1C9cE=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=qV5ia4pKOO4teZ4OL9K2gU/wD0fNQoulXWeKxllxnq8BsBANQqYkRVsgzcevRRUQ7/uONuLIV055rZTMPQU0v6VVQWVQAedLtTJ4nj2Qkm24MX3L0uVT7sTNETpH4aA9za+poe9XYcWbqb7DVR/Oj99CgQwmFwwAaYNtxxN1mlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=ZFWfUz82; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="ZFWfUz82"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=h8qdpjBLMSRPaA51VvOZtRTSGpJg8nE9iKCAu0rFY10=;
	b=ZFWfUz82OemF9gVHA3xyjClLTp5Rb4gzNFiLV/PFnphbO92X6aHXVQZW6iW8DiWzwOOcCUzCm
	lR5N1zBfHNWI6APuHsP9+RxTR1+yy0JN+my5psfsxUz2sqLgozpCDrn4V8ZboRlbvIt5Y1Yx8dW
	nR2O5j+btvN5Olk64s3YHPg=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4h1bgb2cRgznTVd;
	Fri, 17 Jul 2026 11:56:27 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id 8A83B40578;
	Fri, 17 Jul 2026 12:06:01 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Fri, 17 Jul 2026 12:06:00 +0800
Message-ID: <df932d54-6e03-4965-a505-ffc23355783e@huawei.com>
Date: Fri, 17 Jul 2026 12:06:01 +0800
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/6] KVM: arm64: Add HDBSS per-vCPU buffer management
To: Leonardo Bras <leo.bras@arm.com>
CC: <maz@kernel.org>, <oupton@kernel.org>, <catalin.marinas@arm.com>,
	<will@kernel.org>, <yuzenghui@huawei.com>, <wangzhou1@hisilicon.com>,
	<yangjinqian1@huawei.com>, <caijian11@h-partners.com>,
	<liuyonglong@huawei.com>, <yezhenyu2@huawei.com>, <yubihong@huawei.com>,
	<linuxarm@huawei.com>, <joey.gouly@arm.com>, <kvmarm@lists.linux.dev>,
	<kvm@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
	<linux-kernel@vger.kernel.org>, <seiden@linux.ibm.com>,
	<suzuki.poulose@arm.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com>
 <20260709104026.2612599-5-zhengtian10@huawei.com>
 <alTqqxEZLuYN-gY6@LeoBrasDK>
 <df479edc-cca0-4b54-aed0-4d8c6fd4ffc7@huawei.com>
 <alYTt-fG5rJ9D6Dm@LeoBrasDK>
 <f360c92e-878d-49b5-bcd4-e18240a3600a@huawei.com>
 <aleY9_kZnj_1Awfg@LeoBrasDK>
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <aleY9_kZnj_1Awfg@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 7/15/2026 10:28 PM, Leonardo Bras wrote:
> On Wed, Jul 15, 2026 at 05:16:51PM +0800, Tian Zheng wrote:
>> On 7/14/2026 6:47 PM, Leonardo Bras wrote:
>>> On Tue, Jul 14, 2026 at 03:15:03PM +0800, Tian Zheng wrote:
>>>> On 7/13/2026 9:39 PM, Leonardo Bras wrote:
>>>>> On Thu, Jul 09, 2026 at 06:40:24PM +0800, Tian Zheng wrote:
>>>>>> From: eillon <yezhenyu2@huawei.com>
>>>>>>
>>>>>> Add HDBSS (Hardware Dirty Bit State Structure) per-vCPU buffer
>>>>>> management including allocation, freeing, and loading of HDBSS
>>>>>> registers during vCPU load.
>>>>>>
>>>>>> This patch creates the foundational infrastructure:
>>>>>> - struct vcpu_hdbss_state and enable_hdbss/hdbss_order in kvm_arch
>>>>>> - kvm_dirty_bit.h header with alloc/free declarations
>>>>>> - dirty_bit.c with alloc/free helpers
>>>>>> - __load_hdbss() in VHE switch for register loading
>>>>>> - vCPU create/destroy hooks for buffer lifecycle
>>>>>> - sysreg definitions for HDBSS register manipulation
>>>>>> - Makefile update for dirty_bit.o
>>>>>>
>>>>>> Signed-off-by: Eillon <yezhenyu2@huawei.com>
>>>>>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>>>>>> ---
>>>>>>     arch/arm64/include/asm/kvm_dirty_bit.h | 16 ++++++++
>>>>>>     arch/arm64/include/asm/kvm_host.h      | 13 +++++++
>>>>>>     arch/arm64/include/asm/sysreg.h        | 11 ++++++
>>>>>>     arch/arm64/kvm/Makefile                |  1 +
>>>>>>     arch/arm64/kvm/arm.c                   |  7 ++++
>>>>>>     arch/arm64/kvm/dirty_bit.c             | 52 ++++++++++++++++++++++++++
>>>>>>     arch/arm64/kvm/hyp/vhe/switch.c        | 15 ++++++++
>>>>>>     arch/arm64/kvm/mmu.c                   |  1 +
>>>>>>     arch/arm64/kvm/reset.c                 |  4 ++
>>>>>>     9 files changed, 120 insertions(+)
>>>>>>     create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
>>>>>>     create mode 100644 arch/arm64/kvm/dirty_bit.c
>>>>>>
>>>>>> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
>>>>>> new file mode 100644
>>>>>> index 000000000000..84b12f0a10af
>>>>>> --- /dev/null
>>>>>> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
>>>>>> @@ -0,0 +1,16 @@
>>>>>> +/* SPDX-License-Identifier: GPL-2.0-only */
>>>>>> +/*
>>>>>> + * Copyright (C) 2026 ARM Ltd.
>>>>>> + * Author: Leonardo Bras <leo.bras@arm.com>
>>>>> You are adding the file, so the copyright note should be yours, then?
>>>> I originally thought your earlier patchset had already created this file, so
>>>> I
>>>>
>>>> kept your copyright and author info. I'll update it to mine in the next
>>>> version.
>>>>
>>>>
>>>> Thanks for pointing that out!
>>> :)
>>>
>>>>>> + */
>>>>>> +
>>>>>> +#ifndef __ARM64_KVM_DIRTY_BIT_H__
>>>>>> +#define __ARM64_KVM_DIRTY_BIT_H__
>>>>>> +
>>>>>> +#include <asm/kvm_pgtable.h>
>>>>>> +#include <asm/sysreg.h>
>>>>>> +
>>>>>> +int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
>>>>>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>>>>>> +
>>>>>> +#endif /* __ARM64_KVM_DIRTY_BIT_H__ */
>>>>>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>>>>>> index bae2c4f92ef5..c41ec6d9c45a 100644
>>>>>> --- a/arch/arm64/include/asm/kvm_host.h
>>>>>> +++ b/arch/arm64/include/asm/kvm_host.h
>>>>>> @@ -420,6 +420,10 @@ struct kvm_arch {
>>>>>>     	 */
>>>>>>     	struct kvm_protected_vm pkvm;
>>>>>>
>>>>>> +	/* HDBSS: per-VM dirty tracking state */
>>>>>> +	bool enable_hdbss;
>>>>> Is there not a way of checking hdbss without adding this new member on the
>>>>> struct? Would not checking the vcpu_hdbss_state from current vcpu should be
>>>>> enough?
>>>> HDBSS is a VM-wide property, so I currently use a VM-level flag
>>>> (kvm->arch.enable_hdbss)
>>>>
>>>> to track whether it's enabled. Paths like kvm_arch_commit_memory_region()
>>>> and VM teardown
>>>>
>>>> don't have a vCPU context to query, so per-vCPU state wouldn't work there.
>>>>
>>>>
>>>> But you're right, maybe we don't need a value to store it — we could remove
>>>> this flag and instead
>>>>
>>>> check the VTCR_EL2_HDBSS bit directly from kvm->arch.mmu.vtcr:
>>>>
>>>>
>>>> ```
>>>> static inline bool kvm_hdbss_enabled(const struct kvm *kvm)
>>>> {
>>>>       return kvm->arch.mmu.vtcr & VTCR_EL2_HDBSS;
>>>> }
>>>>
>>>> if (kvm_hdbss_enabled(kvm))
>>>>       ...
>>>> ```
>>> That looks better :)
>>>
>>>>>> +	unsigned int hdbss_order;
>>>>> Is that the order for hdbss buffer size?
>>>>> Haven't finished reading the series, but would that be bad if this was also
>>>>> in the per-vcpu state struct, instead?
>>>>>
>>>>> Also, here I suggest that we save a number, instead of the encoding for
>>>>> HDBSSBR_ELS_SZ, and convert it on hdbss setup. It could be either a
>>>>> shift, or size.
>>>>>
>>>>> Reason being that you used this to compare with HDBSS_MAX_ORDER at some
>>>>> point, and there is no guarantee that the encoding will always be in
>>>>> crescent form.
>>>>>
>>>>> Also, it's not clear where you set this value.
>>>> Yes, this is the HDBSS buffer order (2^order bytes per vCPU).
>>>>
>>>> I put it in kvm->arch *to make sure all vCPUs in a VM have the same order*.
>>>>
>>> Right, but do we need to retrieve this value at any context that is not
>>> per-vcpu later? If all allocations happen at the same time, and the vcpus
>>> can get the size of their arrays (even by the register itself), maybe there
>>> is no need to add this member in the kvm_arch structure.
>>>
>>>> I agree we should store a plain order number rather than the raw SZ
>>>> encoding.
>>>>
>>> I would recommend we always save the value in the way its most convenient
>>> to use. In this case, I only recall it to be used as bounds to read the
>>> HDBSS array, so it would be better if we save it as plain size.
>>>
>>>> The assignment should happen in kvm_arm_enable_hdbss_global(), which I
>>>> missed in v4 and will add in v5.
>>>>
>>> Okay
>>>
>>>>>> +
>>>>>>     #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>>>>>>     	/* Nested virtualization info */
>>>>>>     	struct dentry *debugfs_nv_dentry;
>>>>>> @@ -838,6 +842,12 @@ struct vcpu_reset_state {
>>>>>>     	bool		reset;
>>>>>>     };
>>>>>>
>>>>>> +struct vcpu_hdbss_state {
>>>>>> +	phys_addr_t base_phys;   /* for memory free */
>>>>>> +	u64 hdbssbr_el2;         /* load directly */
>>>>>> +	u64 hdbssprod_el2;       /* save directly */
>>>>>> +};
>>>>>> +
>>>>>>     struct vncr_tlb;
>>>>>>
>>>>>>     struct kvm_vcpu_arch {
>>>>>> @@ -945,6 +955,9 @@ struct kvm_vcpu_arch {
>>>>>>
>>>>>>     	/* Hyp-readable copy of kvm_vcpu::pid */
>>>>>>     	pid_t pid;
>>>>>> +
>>>>>> +	/* HDBSS registers info */
>>>>>> +	struct vcpu_hdbss_state hdbss;/
>>>>>>     };
>>>>>>
>>>>>>     /*
>>>>>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>>>>>> index 7aa08d59d494..1354a58c3316 100644
>>>>>> --- a/arch/arm64/include/asm/sysreg.h
>>>>>> +++ b/arch/arm64/include/asm/sysreg.h
>>>>>> @@ -1039,6 +1039,17 @@
>>>>>>
>>>>>>     #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
>>>>>>     					       GCS_CAP_VALID_TOKEN)
>>>>>> +
>>>>>> +/*
>>>>>> + * Definitions for the HDBSS feature
>>>>>> + */
>>>>>> +#define HDBSS_MAX_ORDER		HDBSSBR_EL2_SZ_2MB
>>>>>> +
>>>>> See above comment on using the encoding instead of an actual size/shift
>>>>> number.
>>>> You're right — I will fix this in the next version as follows:
>>>>
>>>> First, HDBSS_MAX_ORDER will be defined as a plain order number. In v4 I only
>>>> considered the 4KB page
>>> Maybe consider a plain size number, instead.
>>>
>>>> case and hard-coded it to 9. To make it work for any PAGE_SIZE configuration
>>>> (4KB, 16KB, or 64KB), I'll derive
>>>>
>>>> it from HDBSSBR_EL2_SZ_2MB:
>>>>
>>>> ```
>>>> #define HDBSS_MAX_ORDER    (12 + HDBSSBR_EL2_SZ_2MB - PAGE_SHIFT)
>>>> ```
>>>>
>>>> This evaluates to 9 on 4KB pages, and the correct value on 16KB/64KB pages
>>>> as well.
>>> Wait, I don't see what you are trying to achieve here with this.
>>> This order is related to the size of a HDBSS buffer, which is defined
>>> independently of the page size being used. In 2MB example, it does hold
>>> 256K HDBSS entries, disregarding on the page size, IIRC.
>>>
>>>
>>>> Second, I will add two conversion helpers in sysreg.h to bridge between
>>>> kernel semantics (alloc_pages order)
>>>>
>>>> and hardware encoding (HDBSSBR_EL2.SZ):
>>>>
>>>> ```
>>>> /* Convert alloc_pages order to HDBSSBR_EL2.SZ encoding */
>>>> #define hdbss_order_to_sz(order)  (PAGE_SHIFT + (order) - 12)
>>>> ```
>>> (would be *_to_shift() no?)
>>>
>>> In any case, see above.
>>>
>>>> These helpers work for any PAGE_SIZE configuration (4KB, 16KB, or 64KB)
>>>> because they use PAGE_SHIFT directly.
>>>>
>>>> Third, I will update the HDBSSBR_EL2 register construction in
>>>> kvm_arm_vcpu_alloc_hdbss()：
>>>>
>>>> ```
>>>> /* before */
>>>> .hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg), order),
>>>>
>>>> /* after */
>>>> .hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg),
>>>>                               hdbss_order_to_sz(order)),
>>>> ```
>>>>
>>> That would be the other way around, right? I mean, here you would want the
>>> order encoded in HDBSSBR_SZ from the page shift, not the other way around.
>>>
>>> In any case, see above.
>>>
>>>
>>>> And I will also update the __free_pages() call to use
>>>> vcpu->kvm->arch.hdbss_order directly, since that field
>>>>
>>>> stores the plain order number and avoids decoding the SZ encoding at free
>>>> time:
>>>>
>>>>
>>>> ```
>>>> /* before */
>>>> __free_pages(hdbss_pg,
>>>>        FIELD_GET(HDBSSBR_EL2_SZ_MASK,
>>>>                  vcpu->arch.hdbss.hdbssbr_el2));
>>>>
>>>> /* after */
>>>> __free_pages(hdbss_pg,
>>>>        vcpu->kvm->arch.hdbss_order);
>>>> ```
>>>>
>>> Ah, you use the 'order' to free the buffers as well, ok.
>>> But those are per-vcpu buffers as well, right?
>>>
>>> Again, the HDBSSBR_EL2.SZ AFAIK is not related to page size.
>>>
>>> Thanks!
>>> Leo
>>
>> Got it. I'll store the plain size (in bytes) instead of the order or SZ
>> encoding.
>>
>> One clarification though: I'd like to keep this as a VM-level field
>> (kvm->arch.hdbss_buffer_size) in case we may want to allow userspace to
>> configure the buffer size via ioctl in the future.
> Ah, I see... I agree with that ioctl, as I suggested something similar in
> https://lore.kernel.org/all/alYamq9BL5CTaAX7@LeoBrasDK
>
>> The field would be unsigned long hdbss_buffer_size (in bytes), with helpers
>> to convert to order or SZ encoding when needed:
>>    - get_order(size) → for alloc_pages()
>>    - ilog2(size) - 12 → for HDBSSBR_EL2.SZ
> nit: ilog2() will round _down_ the buffer size. Take that into account.
>
>> Does that work for you?
> I think it makes sense. Honestly not sure where is the best place to put
> the variable, though. Maybe some of the maintainers can give us some tip.
>
> You plan to make hdbss_buffer_size!=0 just when it's in use, right?
> If that's the case, we can use 'hdbss_buffer_size!=0' as is_hdbss_enabled()
>
> Thanks!
> Leo


Ok. or maybe we can store the number of entries directly, like PML does, 
to avoid

conversions. And yes, hdbss_buffer_size != 0 as is_hdbss_enabled() works 
for me.

For the variable location — open to maintainers' suggestions.


Thanks,

Tian

