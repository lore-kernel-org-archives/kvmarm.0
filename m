Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 789BE384CEB
	for <kvmarm@lists.linux.dev>; Wed, 15 Jul 2026 14:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125699; cv=none; b=Yosj62aRhiWU8n0GAnPllwHs+eJO/OTPdzR98y5lqewKyvqzTWISRWtAjcdPArFhQRq8XgowhMe5bu9Hlv2GxmheMbDl2sASRlb2aJ0fKL57DzrZJMlFscKmOwLbMBBhrFwmomEzjAGJ5iI+fRFF3vGo7rnPPN6C4tIjuKOvfkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125699; c=relaxed/simple;
	bh=EXWE9OScUCC5XOKTB5Of3FMFGhRkNqEV1+jqwKBC95s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Disposition; b=gIkNjuYS4MwwmBaNaP/gwoiHDO5XVFWfSchl74/ep4IeU/uRO7pL2BaW95mlRHwQKmCMup56uNZMPCMIfFXd3mZrWWrgqbWK+W10wiIMQ/Nl4uRV880P+4HgWMKMxFY4o6ChH/z/jk/eGDPVXYzsQVaXqjc8HNpfKkbDaK8BHks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b=r4Bsl8yH; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.b="r4Bsl8yH"
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id AAF5A1576;
	Wed, 15 Jul 2026 07:28:12 -0700 (PDT)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 584493F93E;
	Wed, 15 Jul 2026 07:28:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784125696; bh=EXWE9OScUCC5XOKTB5Of3FMFGhRkNqEV1+jqwKBC95s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r4Bsl8yHs5mD0aed6D4eq1hfGdugm8mZXD1mA4RjG45JhxUYUn6+R/g9ksXSau2nw
	 K9WXLB7k7tSQ8MKRMkQ6mFynNVkzt7crTjcMiZUB9V+itPsadbgE4F6XFDHfDK21c+
	 9btu3OdPqkCDFSVKNwXZEhZyzpFOR1wanjjUf6sM=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com
Subject: Re: [PATCH v4 4/6] KVM: arm64: Add HDBSS per-vCPU buffer management
Date: Wed, 15 Jul 2026 15:28:07 +0100
Message-ID: <aleY9_kZnj_1Awfg@LeoBrasDK>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <f360c92e-878d-49b5-bcd4-e18240a3600a@huawei.com>
References: <20260709104026.2612599-1-zhengtian10@huawei.com> <20260709104026.2612599-5-zhengtian10@huawei.com> <alTqqxEZLuYN-gY6@LeoBrasDK> <df479edc-cca0-4b54-aed0-4d8c6fd4ffc7@huawei.com> <alYTt-fG5rJ9D6Dm@LeoBrasDK> <f360c92e-878d-49b5-bcd4-e18240a3600a@huawei.com>
Precedence: bulk
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Wed, Jul 15, 2026 at 05:16:51PM +0800, Tian Zheng wrote:
> 
> On 7/14/2026 6:47 PM, Leonardo Bras wrote:
> > On Tue, Jul 14, 2026 at 03:15:03PM +0800, Tian Zheng wrote:
> > > On 7/13/2026 9:39 PM, Leonardo Bras wrote:
> > > > On Thu, Jul 09, 2026 at 06:40:24PM +0800, Tian Zheng wrote:
> > > > > From: eillon <yezhenyu2@huawei.com>
> > > > > 
> > > > > Add HDBSS (Hardware Dirty Bit State Structure) per-vCPU buffer
> > > > > management including allocation, freeing, and loading of HDBSS
> > > > > registers during vCPU load.
> > > > > 
> > > > > This patch creates the foundational infrastructure:
> > > > > - struct vcpu_hdbss_state and enable_hdbss/hdbss_order in kvm_arch
> > > > > - kvm_dirty_bit.h header with alloc/free declarations
> > > > > - dirty_bit.c with alloc/free helpers
> > > > > - __load_hdbss() in VHE switch for register loading
> > > > > - vCPU create/destroy hooks for buffer lifecycle
> > > > > - sysreg definitions for HDBSS register manipulation
> > > > > - Makefile update for dirty_bit.o
> > > > > 
> > > > > Signed-off-by: Eillon <yezhenyu2@huawei.com>
> > > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > > ---
> > > > >    arch/arm64/include/asm/kvm_dirty_bit.h | 16 ++++++++
> > > > >    arch/arm64/include/asm/kvm_host.h      | 13 +++++++
> > > > >    arch/arm64/include/asm/sysreg.h        | 11 ++++++
> > > > >    arch/arm64/kvm/Makefile                |  1 +
> > > > >    arch/arm64/kvm/arm.c                   |  7 ++++
> > > > >    arch/arm64/kvm/dirty_bit.c             | 52 ++++++++++++++++++++++++++
> > > > >    arch/arm64/kvm/hyp/vhe/switch.c        | 15 ++++++++
> > > > >    arch/arm64/kvm/mmu.c                   |  1 +
> > > > >    arch/arm64/kvm/reset.c                 |  4 ++
> > > > >    9 files changed, 120 insertions(+)
> > > > >    create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
> > > > >    create mode 100644 arch/arm64/kvm/dirty_bit.c
> > > > > 
> > > > > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > new file mode 100644
> > > > > index 000000000000..84b12f0a10af
> > > > > --- /dev/null
> > > > > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > @@ -0,0 +1,16 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > > > +/*
> > > > > + * Copyright (C) 2026 ARM Ltd.
> > > > > + * Author: Leonardo Bras <leo.bras@arm.com>
> > > > You are adding the file, so the copyright note should be yours, then?
> > > 
> > > I originally thought your earlier patchset had already created this file, so
> > > I
> > > 
> > > kept your copyright and author info. I'll update it to mine in the next
> > > version.
> > > 
> > > 
> > > Thanks for pointing that out!
> > :)
> > 
> > > 
> > > > > + */
> > > > > +
> > > > > +#ifndef __ARM64_KVM_DIRTY_BIT_H__
> > > > > +#define __ARM64_KVM_DIRTY_BIT_H__
> > > > > +
> > > > > +#include <asm/kvm_pgtable.h>
> > > > > +#include <asm/sysreg.h>
> > > > > +
> > > > > +int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu, unsigned int order);
> > > > > +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> > > > > +
> > > > > +#endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > index bae2c4f92ef5..c41ec6d9c45a 100644
> > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > @@ -420,6 +420,10 @@ struct kvm_arch {
> > > > >    	 */
> > > > >    	struct kvm_protected_vm pkvm;
> > > > > 
> > > > > +	/* HDBSS: per-VM dirty tracking state */
> > > > > +	bool enable_hdbss;
> > > > Is there not a way of checking hdbss without adding this new member on the
> > > > struct? Would not checking the vcpu_hdbss_state from current vcpu should be
> > > > enough?
> > > 
> > > HDBSS is a VM-wide property, so I currently use a VM-level flag
> > > (kvm->arch.enable_hdbss)
> > > 
> > > to track whether it's enabled. Paths like kvm_arch_commit_memory_region()
> > > and VM teardown
> > > 
> > > don't have a vCPU context to query, so per-vCPU state wouldn't work there.
> > > 
> > > 
> > > But you're right, maybe we don't need a value to store it — we could remove
> > > this flag and instead
> > > 
> > > check the VTCR_EL2_HDBSS bit directly from kvm->arch.mmu.vtcr:
> > > 
> > > 
> > > ```
> > > static inline bool kvm_hdbss_enabled(const struct kvm *kvm)
> > > {
> > >      return kvm->arch.mmu.vtcr & VTCR_EL2_HDBSS;
> > > }
> > > 
> > > if (kvm_hdbss_enabled(kvm))
> > >      ...
> > > ```
> > That looks better :)
> > 
> > > 
> > > > > +	unsigned int hdbss_order;
> > > > Is that the order for hdbss buffer size?
> > > > Haven't finished reading the series, but would that be bad if this was also
> > > > in the per-vcpu state struct, instead?
> > > > 
> > > > Also, here I suggest that we save a number, instead of the encoding for
> > > > HDBSSBR_ELS_SZ, and convert it on hdbss setup. It could be either a
> > > > shift, or size.
> > > > 
> > > > Reason being that you used this to compare with HDBSS_MAX_ORDER at some
> > > > point, and there is no guarantee that the encoding will always be in
> > > > crescent form.
> > > > 
> > > > Also, it's not clear where you set this value.
> > > 
> > > Yes, this is the HDBSS buffer order (2^order bytes per vCPU).
> > > 
> > > I put it in kvm->arch *to make sure all vCPUs in a VM have the same order*.
> > > 
> > Right, but do we need to retrieve this value at any context that is not
> > per-vcpu later? If all allocations happen at the same time, and the vcpus
> > can get the size of their arrays (even by the register itself), maybe there
> > is no need to add this member in the kvm_arch structure.
> > 
> > > 
> > > I agree we should store a plain order number rather than the raw SZ
> > > encoding.
> > > 
> > I would recommend we always save the value in the way its most convenient
> > to use. In this case, I only recall it to be used as bounds to read the
> > HDBSS array, so it would be better if we save it as plain size.
> > 
> > > The assignment should happen in kvm_arm_enable_hdbss_global(), which I
> > > missed in v4 and will add in v5.
> > > 
> > Okay
> > 
> > > > > +
> > > > >    #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> > > > >    	/* Nested virtualization info */
> > > > >    	struct dentry *debugfs_nv_dentry;
> > > > > @@ -838,6 +842,12 @@ struct vcpu_reset_state {
> > > > >    	bool		reset;
> > > > >    };
> > > > > 
> > > > > +struct vcpu_hdbss_state {
> > > > > +	phys_addr_t base_phys;   /* for memory free */
> > > > > +	u64 hdbssbr_el2;         /* load directly */
> > > > > +	u64 hdbssprod_el2;       /* save directly */
> > > > > +};
> > > > > +
> > > > >    struct vncr_tlb;
> > > > > 
> > > > >    struct kvm_vcpu_arch {
> > > > > @@ -945,6 +955,9 @@ struct kvm_vcpu_arch {
> > > > > 
> > > > >    	/* Hyp-readable copy of kvm_vcpu::pid */
> > > > >    	pid_t pid;
> > > > > +
> > > > > +	/* HDBSS registers info */
> > > > > +	struct vcpu_hdbss_state hdbss;/
> > > > >    };
> > > > > 
> > > > >    /*
> > > > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > > > index 7aa08d59d494..1354a58c3316 100644
> > > > > --- a/arch/arm64/include/asm/sysreg.h
> > > > > +++ b/arch/arm64/include/asm/sysreg.h
> > > > > @@ -1039,6 +1039,17 @@
> > > > > 
> > > > >    #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
> > > > >    					       GCS_CAP_VALID_TOKEN)
> > > > > +
> > > > > +/*
> > > > > + * Definitions for the HDBSS feature
> > > > > + */
> > > > > +#define HDBSS_MAX_ORDER		HDBSSBR_EL2_SZ_2MB
> > > > > +
> > > > See above comment on using the encoding instead of an actual size/shift
> > > > number.
> > > 
> > > You're right — I will fix this in the next version as follows:
> > > 
> > > First, HDBSS_MAX_ORDER will be defined as a plain order number. In v4 I only
> > > considered the 4KB page
> > Maybe consider a plain size number, instead.
> > 
> > > case and hard-coded it to 9. To make it work for any PAGE_SIZE configuration
> > > (4KB, 16KB, or 64KB), I'll derive
> > > 
> > > it from HDBSSBR_EL2_SZ_2MB:
> > > 
> > > ```
> > > #define HDBSS_MAX_ORDER    (12 + HDBSSBR_EL2_SZ_2MB - PAGE_SHIFT)
> > > ```
> > > 
> > > This evaluates to 9 on 4KB pages, and the correct value on 16KB/64KB pages
> > > as well.
> > Wait, I don't see what you are trying to achieve here with this.
> > This order is related to the size of a HDBSS buffer, which is defined
> > independently of the page size being used. In 2MB example, it does hold
> > 256K HDBSS entries, disregarding on the page size, IIRC.
> > 
> > 
> > > Second, I will add two conversion helpers in sysreg.h to bridge between
> > > kernel semantics (alloc_pages order)
> > > 
> > > and hardware encoding (HDBSSBR_EL2.SZ):
> > > 
> > > ```
> > > /* Convert alloc_pages order to HDBSSBR_EL2.SZ encoding */
> > > #define hdbss_order_to_sz(order)  (PAGE_SHIFT + (order) - 12)
> > > ```
> > (would be *_to_shift() no?)
> > 
> > In any case, see above.
> > 
> > > These helpers work for any PAGE_SIZE configuration (4KB, 16KB, or 64KB)
> > > because they use PAGE_SHIFT directly.
> > > 
> > > Third, I will update the HDBSSBR_EL2 register construction in
> > > kvm_arm_vcpu_alloc_hdbss()：
> > > 
> > > ```
> > > /* before */
> > > .hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg), order),
> > > 
> > > /* after */
> > > .hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg),
> > >                              hdbss_order_to_sz(order)),
> > > ```
> > > 
> > That would be the other way around, right? I mean, here you would want the
> > order encoded in HDBSSBR_SZ from the page shift, not the other way around.
> > 
> > In any case, see above.
> > 
> > 
> > > And I will also update the __free_pages() call to use
> > > vcpu->kvm->arch.hdbss_order directly, since that field
> > > 
> > > stores the plain order number and avoids decoding the SZ encoding at free
> > > time:
> > > 
> > > 
> > > ```
> > > /* before */
> > > __free_pages(hdbss_pg,
> > >       FIELD_GET(HDBSSBR_EL2_SZ_MASK,
> > >                 vcpu->arch.hdbss.hdbssbr_el2));
> > > 
> > > /* after */
> > > __free_pages(hdbss_pg,
> > >       vcpu->kvm->arch.hdbss_order);
> > > ```
> > > 
> > Ah, you use the 'order' to free the buffers as well, ok.
> > But those are per-vcpu buffers as well, right?
> > 
> > Again, the HDBSSBR_EL2.SZ AFAIK is not related to page size.
> > 
> > Thanks!
> > Leo
> 
> 
> Got it. I'll store the plain size (in bytes) instead of the order or SZ
> encoding.
> 
> One clarification though: I'd like to keep this as a VM-level field
> (kvm->arch.hdbss_buffer_size) in case we may want to allow userspace to
> configure the buffer size via ioctl in the future.

Ah, I see... I agree with that ioctl, as I suggested something similar in 
https://lore.kernel.org/all/alYamq9BL5CTaAX7@LeoBrasDK

> 
> The field would be unsigned long hdbss_buffer_size (in bytes), with helpers
> to convert to order or SZ encoding when needed:
>   - get_order(size) → for alloc_pages()
>   - ilog2(size) - 12 → for HDBSSBR_EL2.SZ

nit: ilog2() will round _down_ the buffer size. Take that into account.

> 
> Does that work for you?

I think it makes sense. Honestly not sure where is the best place to put 
the variable, though. Maybe some of the maintainers can give us some tip.

You plan to make hdbss_buffer_size!=0 just when it's in use, right?
If that's the case, we can use 'hdbss_buffer_size!=0' as is_hdbss_enabled()

Thanks!
Leo
