Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 213973DFC86
	for <kvmarm@lists.linux.dev>; Tue, 14 Jul 2026 07:15:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.222
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784013320; cv=none; b=qPikEAL2oSIWTEHJZX2HrNTDmdUNe91XDSrTq3Ff0LazajpjP7zSZU+0u2Et4FcIMdhncCyRa+dakNF2PPH2c+FRpFINSEVEQ5jQBW2IynfoWMZ3LfFVzv6QYHvsinDYVCSFg/Pt9NVGIRjJGEcOnerqbL9FkubQtoetrkTC6uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784013320; c=relaxed/simple;
	bh=bysRTkh+98+JgWARZLI7jWaWTQQTh8V0lCgxSGkqMxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=GMkNYInxydbZtp+7E7NVZDz43Loi2PqUQc6GKqZFUWa03049IB5YVUtR/StxXWqvYxhFT5C3A7ffGH3L4aenuja9kHA7GJOa9LgCD3nc2awRQLOS/Go8rXOcu+3ZZavpmc9USWieyWU0ezOJKF0cLpW/77WwumOscTk0JH5S4fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=rX9aTSn6; arc=none smtp.client-ip=113.46.200.222
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="rX9aTSn6"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=KTUYQDTdD+M4Xoy6cGEzhfvX+zyRy91IfTR/Ceif1dA=;
	b=rX9aTSn6RUOLx1H0XHk3dVM/Oy3jFPVa104y+EKwy3ZAsxmRcLn+GymaGEhl+kUAI/b0pdXui
	FIdhr/nCLGqnNzSCv3kiZRHQA7I5Q7K4uqPgpUe3RTQnahxr/cxILjJMKLLHlaJjRkeAzJrN6iG
	2i+soNhRvRfOkRiTkXniV4c=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4gzr1Q1T3gzLlTg;
	Tue, 14 Jul 2026 15:05:46 +0800 (CST)
Received: from kwepemr100010.china.huawei.com (unknown [7.202.195.125])
	by mail.maildlp.com (Postfix) with ESMTPS id D73A940588;
	Tue, 14 Jul 2026 15:15:03 +0800 (CST)
Received: from [10.67.120.103] (10.67.120.103) by
 kwepemr100010.china.huawei.com (7.202.195.125) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 14 Jul 2026 15:15:03 +0800
Message-ID: <df479edc-cca0-4b54-aed0-4d8c6fd4ffc7@huawei.com>
Date: Tue, 14 Jul 2026 15:15:03 +0800
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
From: Tian Zheng <zhengtian10@huawei.com>
In-Reply-To: <alTqqxEZLuYN-gY6@LeoBrasDK>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 kwepemr100010.china.huawei.com (7.202.195.125)


On 7/13/2026 9:39 PM, Leonardo Bras wrote:
> On Thu, Jul 09, 2026 at 06:40:24PM +0800, Tian Zheng wrote:
>> From: eillon <yezhenyu2@huawei.com>
>>
>> Add HDBSS (Hardware Dirty Bit State Structure) per-vCPU buffer
>> management including allocation, freeing, and loading of HDBSS
>> registers during vCPU load.
>>
>> This patch creates the foundational infrastructure:
>> - struct vcpu_hdbss_state and enable_hdbss/hdbss_order in kvm_arch
>> - kvm_dirty_bit.h header with alloc/free declarations
>> - dirty_bit.c with alloc/free helpers
>> - __load_hdbss() in VHE switch for register loading
>> - vCPU create/destroy hooks for buffer lifecycle
>> - sysreg definitions for HDBSS register manipulation
>> - Makefile update for dirty_bit.o
>>
>> Signed-off-by: Eillon <yezhenyu2@huawei.com>
>> Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
>> ---
>>   arch/arm64/include/asm/kvm_dirty_bit.h | 16 ++++++++
>>   arch/arm64/include/asm/kvm_host.h      | 13 +++++++
>>   arch/arm64/include/asm/sysreg.h        | 11 ++++++
>>   arch/arm64/kvm/Makefile                |  1 +
>>   arch/arm64/kvm/arm.c                   |  7 ++++
>>   arch/arm64/kvm/dirty_bit.c             | 52 ++++++++++++++++++++++++++
>>   arch/arm64/kvm/hyp/vhe/switch.c        | 15 ++++++++
>>   arch/arm64/kvm/mmu.c                   |  1 +
>>   arch/arm64/kvm/reset.c                 |  4 ++
>>   9 files changed, 120 insertions(+)
>>   create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
>>   create mode 100644 arch/arm64/kvm/dirty_bit.c
>>
>> diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
>> new file mode 100644
>> index 000000000000..84b12f0a10af
>> --- /dev/null
>> +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
>> @@ -0,0 +1,16 @@
>> +/* SPDX-License-Identifier: GPL-2.0-only */
>> +/*
>> + * Copyright (C) 2026 ARM Ltd.
>> + * Author: Leonardo Bras <leo.bras@arm.com>
> You are adding the file, so the copyright note should be yours, then?


I originally thought your earlier patchset had already created this 
file, so I

kept your copyright and author info. I'll update it to mine in the next 
version.


Thanks for pointing that out!


>
>> + */
>> +
>> +#ifndef __ARM64_KVM_DIRTY_BIT_H__
>> +#define __ARM64_KVM_DIRTY_BIT_H__
>> +
>> +#include <asm/kvm_pgtable.h>
>> +#include <asm/sysreg.h>
>> +
>> +int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
>> +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
>> +
>> +#endif /* __ARM64_KVM_DIRTY_BIT_H__ */
>> diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
>> index bae2c4f92ef5..c41ec6d9c45a 100644
>> --- a/arch/arm64/include/asm/kvm_host.h
>> +++ b/arch/arm64/include/asm/kvm_host.h
>> @@ -420,6 +420,10 @@ struct kvm_arch {
>>   	 */
>>   	struct kvm_protected_vm pkvm;
>>
>> +	/* HDBSS: per-VM dirty tracking state */
>> +	bool enable_hdbss;
> Is there not a way of checking hdbss without adding this new member on the
> struct? Would not checking the vcpu_hdbss_state from current vcpu should be
> enough?


HDBSS is a VM-wide property, so I currently use a VM-level flag 
(kvm->arch.enable_hdbss)

to track whether it's enabled. Paths like 
kvm_arch_commit_memory_region() and VM teardown

don't have a vCPU context to query, so per-vCPU state wouldn't work there.


But you're right, maybe we don't need a value to store it — we could 
remove this flag and instead

check the VTCR_EL2_HDBSS bit directly from kvm->arch.mmu.vtcr:


```
static inline bool kvm_hdbss_enabled(const struct kvm *kvm)
{
     return kvm->arch.mmu.vtcr & VTCR_EL2_HDBSS;
}

if (kvm_hdbss_enabled(kvm))
     ...
```


>
>> +	unsigned int hdbss_order;
> Is that the order for hdbss buffer size?
> Haven't finished reading the series, but would that be bad if this was also
> in the per-vcpu state struct, instead?
>
> Also, here I suggest that we save a number, instead of the encoding for
> HDBSSBR_ELS_SZ, and convert it on hdbss setup. It could be either a
> shift, or size.
>
> Reason being that you used this to compare with HDBSS_MAX_ORDER at some
> point, and there is no guarantee that the encoding will always be in
> crescent form.
>
> Also, it's not clear where you set this value.


Yes, this is the HDBSS buffer order (2^order bytes per vCPU).

I put it in kvm->arch *to make sure all vCPUs in a VM have the same order*.



I agree we should store a plain order number rather than the raw SZ 
encoding.


The assignment should happen in kvm_arm_enable_hdbss_global(), which I 
missed in v4 and will add in v5.


>   
>> +
>>   #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
>>   	/* Nested virtualization info */
>>   	struct dentry *debugfs_nv_dentry;
>> @@ -838,6 +842,12 @@ struct vcpu_reset_state {
>>   	bool		reset;
>>   };
>>
>> +struct vcpu_hdbss_state {
>> +	phys_addr_t base_phys;   /* for memory free */
>> +	u64 hdbssbr_el2;         /* load directly */
>> +	u64 hdbssprod_el2;       /* save directly */
>> +};
>> +
>>   struct vncr_tlb;
>>
>>   struct kvm_vcpu_arch {
>> @@ -945,6 +955,9 @@ struct kvm_vcpu_arch {
>>
>>   	/* Hyp-readable copy of kvm_vcpu::pid */
>>   	pid_t pid;
>> +
>> +	/* HDBSS registers info */
>> +	struct vcpu_hdbss_state hdbss;/
>>   };
>>
>>   /*
>> diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
>> index 7aa08d59d494..1354a58c3316 100644
>> --- a/arch/arm64/include/asm/sysreg.h
>> +++ b/arch/arm64/include/asm/sysreg.h
>> @@ -1039,6 +1039,17 @@
>>
>>   #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
>>   					       GCS_CAP_VALID_TOKEN)
>> +
>> +/*
>> + * Definitions for the HDBSS feature
>> + */
>> +#define HDBSS_MAX_ORDER		HDBSSBR_EL2_SZ_2MB
>> +
> See above comment on using the encoding instead of an actual size/shift
> number.


You're right — I will fix this in the next version as follows:

First, HDBSS_MAX_ORDER will be defined as a plain order number. In v4 I 
only considered the 4KB page

case and hard-coded it to 9. To make it work for any PAGE_SIZE 
configuration (4KB, 16KB, or 64KB), I'll derive

it from HDBSSBR_EL2_SZ_2MB:

```
#define HDBSS_MAX_ORDER    (12 + HDBSSBR_EL2_SZ_2MB - PAGE_SHIFT)
```

This evaluates to 9 on 4KB pages, and the correct value on 16KB/64KB 
pages as well.

Second, I will add two conversion helpers in sysreg.h to bridge between 
kernel semantics (alloc_pages order)

and hardware encoding (HDBSSBR_EL2.SZ):

```
/* Convert alloc_pages order to HDBSSBR_EL2.SZ encoding */
#define hdbss_order_to_sz(order)  (PAGE_SHIFT + (order) - 12)
```

These helpers work for any PAGE_SIZE configuration (4KB, 16KB, or 64KB) 
because they use PAGE_SHIFT directly.

Third, I will update the HDBSSBR_EL2 register construction in 
kvm_arm_vcpu_alloc_hdbss()：

```
/* before */
.hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg), order),

/* after */
.hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg),
                             hdbss_order_to_sz(order)),
```

And I will also update the __free_pages() call to use 
vcpu->kvm->arch.hdbss_order directly, since that field

stores the plain order number and avoids decoding the SZ encoding at 
free time:


```
/* before */
__free_pages(hdbss_pg,
      FIELD_GET(HDBSSBR_EL2_SZ_MASK,
                vcpu->arch.hdbss.hdbssbr_el2));

/* after */
__free_pages(hdbss_pg,
      vcpu->kvm->arch.hdbss_order);
```

>
>> +#define HDBSSBR_EL2(baddr, sz)	(((baddr) & HDBSSBR_EL2_BADDR_MASK) | \
>> +				 FIELD_PREP(HDBSSBR_EL2_SZ_MASK, sz))
>> +
>> +#define HDBSSPROD_IDX(prod)	FIELD_GET(HDBSSPROD_EL2_INDEX_MASK, prod)
>> +
>>   /*
>>    * Definitions for GICv5 instructions
>>    */
>> diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
>> index 59612d2f277c..ec2749af64fa 100644
>> --- a/arch/arm64/kvm/Makefile
>> +++ b/arch/arm64/kvm/Makefile
>> @@ -18,6 +18,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
>>   	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
>>   	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
>>   	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
>> +	 dirty_bit.o \
>>   	 vgic/vgic.o vgic/vgic-init.o \
>>   	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
>>   	 vgic/vgic-v3.o vgic/vgic-v4.o \
>> diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
>> index 50adfff75be8..bf6688245d83 100644
>> --- a/arch/arm64/kvm/arm.c
>> +++ b/arch/arm64/kvm/arm.c
>> @@ -38,6 +38,7 @@
>>   #include <asm/kvm_asm.h>
>>   #include <asm/kvm_emulate.h>
>>   #include <asm/kvm_hyp.h>
>> +#include <asm/kvm_dirty_bit.h>
>>   #include <asm/kvm_mmu.h>
>>   #include <asm/kvm_nested.h>
>>   #include <asm/kvm_pkvm.h>
>> @@ -565,6 +566,12 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
>>   	if (err)
>>   		kvm_vgic_vcpu_destroy(vcpu);
>>
>> +	if (vcpu->kvm->arch.enable_hdbss) {
>> +		err = kvm_arm_vcpu_alloc_hdbss(vcpu, vcpu->kvm->arch.hdbss_order);
>> +		if (err)
>> +			kvm_vgic_vcpu_destroy(vcpu);
>> +	}
>> +
>>   	return err;
>>   }
>>
>> diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
>> new file mode 100644
>> index 000000000000..6c7a6ef66b5a
>> --- /dev/null
>> +++ b/arch/arm64/kvm/dirty_bit.c
>> @@ -0,0 +1,52 @@
>> +// SPDX-License-Identifier: GPL-2.0-only
>> +/*
>> + * Copyright (C) 2026 ARM Ltd.
>> + * Author: Leonardo Bras <leo.bras@arm.com>
>> + */
>> +
>> +#include <asm/kvm_dirty_bit.h>
>> +#include <asm/kvm_mmu.h>
>> +#include <asm/sysreg.h>
>> +#include <linux/gfp.h>
>> +#include <linux/kconfig.h>
>> +#include <linux/mm.h>
>> +
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
>> +
>> +	hdbss_pg = phys_to_page(vcpu->arch.hdbss.base_phys);
>> +	if (hdbss_pg)
>> +		__free_pages(hdbss_pg,
>> +		     FIELD_GET(HDBSSBR_EL2_SZ_MASK,
>> +			       vcpu->arch.hdbss.hdbssbr_el2));
>> +
>> +	vcpu->arch.hdbss.hdbssbr_el2 = 0;
>> +}
>> diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
>> index bbe9cebd3d9d..fe72944bfd3d 100644
>> --- a/arch/arm64/kvm/hyp/vhe/switch.c
>> +++ b/arch/arm64/kvm/hyp/vhe/switch.c
>> @@ -22,6 +22,7 @@
>>   #include <asm/kvm_emulate.h>
>>   #include <asm/kvm_hyp.h>
>>   #include <asm/kvm_mmu.h>
>> +#include <asm/kvm_dirty_bit.h>
>>   #include <asm/fpsimd.h>
>>   #include <asm/debug-monitors.h>
>>   #include <asm/processor.h>
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
>> +	write_sysreg_s(vcpu->arch.hdbss.hdbssprod_el2, SYS_HDBSSPROD_EL2);
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
>> diff --git a/arch/arm64/kvm/mmu.c b/arch/arm64/kvm/mmu.c
>> index 346efed6e605..83251d95bf3f 100644
>> --- a/arch/arm64/kvm/mmu.c
>> +++ b/arch/arm64/kvm/mmu.c
>> @@ -16,6 +16,7 @@
>>   #include <asm/cacheflush.h>
>>   #include <asm/kvm_arm.h>
>>   #include <asm/kvm_mmu.h>
>> +#include <asm/kvm_dirty_bit.h>
>>   #include <asm/kvm_pgtable.h>
>>   #include <asm/kvm_pkvm.h>
>>   #include <asm/kvm_asm.h>
>> diff --git a/arch/arm64/kvm/reset.c b/arch/arm64/kvm/reset.c
>> index b963fd975aac..d8104bcbd9ff 100644
>> --- a/arch/arm64/kvm/reset.c
>> +++ b/arch/arm64/kvm/reset.c
>> @@ -27,6 +27,7 @@
>>   #include <asm/kvm_asm.h>
>>   #include <asm/kvm_emulate.h>
>>   #include <asm/kvm_mmu.h>
>> +#include <asm/kvm_dirty_bit.h>
>>   #include <asm/kvm_nested.h>
>>   #include <asm/virt.h>
>>
>> @@ -161,6 +162,9 @@ void kvm_arm_vcpu_destroy(struct kvm_vcpu *vcpu)
>>   	free_page((unsigned long)vcpu->arch.ctxt.vncr_array);
>>   	kfree(vcpu->arch.vncr_tlb);
>>   	kfree(vcpu->arch.ccsidr);
>> +
>> +	if (vcpu->kvm->arch.enable_hdbss)
>> +		kvm_arm_vcpu_free_hdbss(vcpu);
>>   }
>>
>>   static void kvm_vcpu_reset_sve(struct kvm_vcpu *vcpu)
>> --
>> 2.33.0
>>
