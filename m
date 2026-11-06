Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793978503;
	b=Dg2ucZgTVneAIeRqILxCWcgweCN8UaHuDQeov5ujtrR4w0r1apajfZ8xYkwYsJYbsuqc
	 QVRp1A6LnH3UnO9HExUuL5XGdBBiRAsBdMRY20hKHqz02BDLwuq9a7UDwNct50QcBbelE
	 x4gxv6f+YhbpFxl1wlTh3JgDSUQydl358jC6Sqpy/5JqtI3wq60nxQfSWi/KTmRerFrAG
	 7wQ2pne8p9DZnMIPwZU5Fy/4nVqMgRcMwykaKG39BRsRZXb5mD6hHBuWX4KXtYcnsbL47
	 sZStaSVgq9dMDwvK45eBbmjYQgEn5k4rD0MUlQOb2OBaTOe+0KOZq3HNk2tswwJrRRg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793978503;
	h=DMARC-Filter:Received:Received:DKIM-Signature:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding;
	bh=QlAJRLst9AJbwfYrhiuAcYHXrk5kiqZZ598/4vkmUAs=;
	b=d6NN8fVMT7muTbPGjEN7IuD4+arWtHQNodPFw2b0RLGnxOdPNGYpoVskdrNdFWWmtHwP
	 XkInWSkmK3Fm2yT39R/1DcpNBLpsRUKGWlSdkk3DzGoAUkQ0J7fOSck2QDvPTglUOVVKf
	 yKm9aD+siIToxVmerCkUVScXA2UVKznEvkzXmJXZc8ev59bUNxZ/7wzd2sGpYxoTOOAV5
	 u0Q0/gZ7Ohz1MQq7DCb2hYSjP6Paj+kXdL9246Eqz6Z9PGJLkduQCsaXAijs9+nY85IsI
	 6ckUPMBCpFJ5yxTTfCLv2Suhrnn1zkA+CW/mq2QQmAglzH2OLHc9QJ2nhNbq4NIYNKA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=F0RruXBz;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9CE7606D803
	for <kvmarm@lists.linux.dev>; Fri,  6 Nov 2026 15:21:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E9CE7606D803
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=F0RruXBz
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 13A2014BF;
	Fri,  6 Nov 2026 07:21:39 -0800 (PST)
Received: from LeoBrasDK.cambridge.arm.com (LeoBrasDK.cambridge.arm.com [10.2.212.21])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6B4D43F628;
	Fri,  6 Nov 2026 07:21:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793978502; bh=Iwz4s79vORMlYnpLiY8KAQnEt0Hrm46DNVXQpjoy090=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0RruXBzTZJNsivcNgD/k0rJtVLF4dj6Mu+wOS+gR2L2sR1V6FmZyqLXF3ROdeNwk
	 vKRjBNJ57EXk8cfW1LFJa5ZkqXnxlBVANULfxXjatVoaU7QMH42OwVvjMzEP1mAdYN
	 arHGHUemcV/jmvh6lTbk7nxcbmjR06nPG0TrTw2s=
From: Leonardo Bras <leo.bras@arm.com>
To: Tian Zheng <zhengtian10@huawei.com>
Cc: Leonardo Bras <leo.bras@arm.com>,
	maz@kernel.org,
	oupton@kernel.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	corbet@lwn.net,
	pbonzini@redhat.com,
	yuzenghui@huawei.com,
	wangzhou1@hisilicon.com,
	yangjinqian1@huawei.com,
	caijian11@h-partners.com,
	liuyonglong@huawei.com,
	tangchengchang@huawei.com,
	yezhenyu2@huawei.com,
	yubihong@huawei.com,
	linuxarm@huawei.com,
	joey.gouly@arm.com,
	kvmarm@lists.linux.dev,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	seiden@linux.ibm.com,
	suzuki.poulose@arm.com,
	fuad.tabba@linux.dev,
	mark.rutland@arm.com,
	seanjc@google.com,
	rdunlap@infradead.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	skhan@linuxfoundation.org
Subject: Re: [PATCH v5 07/15] KVM: arm64: Add HDBSS per-vCPU buffer management
Date: Fri,  6 Nov 2026 15:21:30 +0000
Message-ID: <au3wekPW4sPUUVGm@LeoBrasDK>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <c80e143e-f899-4b86-94ad-f575c869d72b@huawei.com>
References: <20260929103655.85107-1-zhengtian10@huawei.com> <20260929103655.85107-8-zhengtian10@huawei.com> <at-bm_p_MHU3GmYn@LeoBrasDK> <6e2d5b81-1ae9-476e-897c-f6dc7079565c@huawei.com> <auSuAAmzoND1sy4c@LeoBrasDK> <c80e143e-f899-4b86-94ad-f575c869d72b@huawei.com>
X-Mailing-List: kvmarm@lists.linux.dev
List-Id: <kvmarm.lists.linux.dev>
List-Post: <mailto:kvmarm@lists.linux.dev>
List-Help: <mailto:kvmarm+help@lists.linux.dev>
List-Subscribe: <mailto:kvmarm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:kvmarm+unsubscribe@lists.linux.dev>
List-Owner: <mailto:kvmarm+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Fri, Nov 06, 2026 at 04:49:49PM +0800, Tian Zheng wrote:
> 
> 
> On 10/30/2026 10:47 PM, Leonardo Bras wrote:
> > On Fri, Oct 30, 2026 at 11:47:20AM +0800, Tian Zheng wrote:
> > > 
> > > 
> > > On 10/27/2026 2:27 AM, Leonardo Bras wrote:
> > > > On Tue, Sep 29, 2026 at 06:36:47PM +0800, Tian Zheng wrote:
> > > > > From: Eillon <yezhenyu2@huawei.com>
> > > > > 
> > > > > Each vCPU owns an HDBSS buffer, described by HDBSSBR_EL2 (base
> > > > > address and encoded size) and advanced by HDBSSPROD_EL2 as hardware
> > > > > appends entries. Tie the buffer lifetime to the vCPU: allocate at
> > > > > vCPU creation, free at destruction. The buffer is allocated zeroed,
> > > > > so a stale producer index can only ever observe invalid entries.
> > > > > 
> > > > > Registers are programmed whenever the vCPU owns a buffer, regardless
> > > > > of whether HDBSS is enabled. The feature can be turned on
> > > > > mid-KVM_RUN, and hardware dirty-state updates write to
> > > > > HDBSSBR_EL2.BADDR without any fault, so the registers must already
> > > > > be in place by then. HDBSSPROD_EL2 is preserved across context
> > > > > switches and vCPU migration.
> > > > > 
> > > > > Two details: the buddy order is kept separate from the HDBSSBR_EL2.SZ
> > > > > encoding, since the two only coincide on 4KB pages; and kvm_share_hyp()
> > > > > is unwound in kvm_arch_vcpu_create() when the HDBSS allocation fails.
> > > > 
> > > > Out of curiosity: why can't we allocate the buffers when dirty-tracking
> > > > starts? (and free them when it stops)
> > > > 
> > > > Since we have to request the vcpus to guest_exit, and enable
> > > > VTCR_EL2{HA,HD,HDBSS}, we could as well allocate the buffers and set the
> > > > HDBSSBR_EL2.BADDR. In case the buffer allocation fails, we could just not
> > > > enable HDBSS, maybe.
> > > > 
> > > > Buffer allocation could happen before the VCPU request, for every vcpu, or
> > > > during the vcpu request, so every vcpu allocates it's own buffer.
> > > > 
> > > > Am I missing something, or is it just to make things easier?
> > > > 
> > > 
> > > Hi loe,
> > > 
> > > Yes, allocating the buffers at vCPU creation does make things simpler.
> > > 
> > > I'd rather follow the x86 PML and dirty ring scheme: allocate at vCPU
> > > creation. This avoids partial enablement when an allocation fails mid-
> > > broadcast, the use-after-free window when freeing at logging stop, and
> > > naturally handles vCPU hotplug during logging.
> > 
> > Ah, I see.
> > Well, the problem of partial enablement is gone if the requester tries to
> > allocate all buffers for all vcpus, before requesting the vcpus to enable HDBSS.
> > If one of them fails, then just don't request the vcpus to enable :)
> > 
> > As for the use after free: you can free the buffer at the vcpu request to
> > disable the feature, making sure it's not using it when you free the
> > buffer.
> > 
> > I agree that allocating at the creation of a vcpu is easier, but this can
> > receive pushback as a VM will have to carry this buffers for it's whole
> > lifetime, even though it may never use it.
> > 
> > I suggest we try allocating at vcpu creation should only if dirty-tracking
> > is already happening, so we can enable the feature on the new vcpu.
> > 
> > I agree that x86 may have chosen to do that for a reason, but if we don't
> > know the reason, or if it's not compelling for us, maybe we can just try
> > doing something better.
> > 
> 
> Hi Leo,
> 
> Thanks for giving this suggestion. I think it's useful. x86's PML only
> occupies 4KB per vCPU, so its memory overhead is controllable. But ours
> can occupy up to 2MB, which is wasteful.
> 
> Therefore, we keep allocating the HDBSS buffer when creating a vCPU if
> HDBSS is enabled (this is for vCPU hotplug). For normal vCPUs, we keep
> allocating HDBSS buffers when enabling HDBSS, and destroy them when
> disabling HDBSS or destroying the vCPU.
> 
> I think it works and can save memory. What do you think about this?

Yeap, that's what I suggested :)

> 
> > > 
> > > > > 
> > > > > Signed-off-by: Eillon <yezhenyu2@huawei.com>
> > > > > Signed-off-by: Tian Zheng <zhengtian10@huawei.com>
> > > > > ---
> > > > >    arch/arm64/include/asm/kvm_dirty_bit.h | 28 +++++++++++++
> > > > >    arch/arm64/include/asm/kvm_host.h      | 13 ++++++
> > > > >    arch/arm64/include/asm/sysreg.h        |  9 +++++
> > > > >    arch/arm64/kvm/Makefile                |  1 +
> > > > >    arch/arm64/kvm/arm.c                   | 14 ++++++-
> > > > >    arch/arm64/kvm/dirty_bit.c             | 55 ++++++++++++++++++++++++++
> > > > >    arch/arm64/kvm/hyp/vhe/switch.c        | 17 ++++++++
> > > > >    arch/arm64/kvm/reset.c                 |  3 ++
> > > > >    8 files changed, 138 insertions(+), 2 deletions(-)
> > > > >    create mode 100644 arch/arm64/include/asm/kvm_dirty_bit.h
> > > > >    create mode 100644 arch/arm64/kvm/dirty_bit.c
> > > > > 
> > > > > diff --git a/arch/arm64/include/asm/kvm_dirty_bit.h b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > new file mode 100644
> > > > > index 000000000000..fe703f02626b
> > > > > --- /dev/null
> > > > > +++ b/arch/arm64/include/asm/kvm_dirty_bit.h
> > > > > @@ -0,0 +1,28 @@
> > > > > +/* SPDX-License-Identifier: GPL-2.0-only */
> > > > > +/*
> > > > > + * Per-vCPU buffer management for HDBSS-based dirty page tracking.
> > > > > + *
> > > > > + * Copyright (C) 2026 Huawei Technologies Co., Ltd
> > > > > + * Author: Tian Zheng <zhengtian10@huawei.com>
> > > > > + */
> > > > > +
> > > > > +#ifndef __ARM64_KVM_DIRTY_BIT_H__
> > > > > +#define __ARM64_KVM_DIRTY_BIT_H__
> > > > > +
> > > > > +#include <asm/kvm_pgtable.h>
> > > > > +#include <asm/sysreg.h>
> > > > > +#include <linux/sizes.h>
> > > > > +
> > > > > +#define KVM_ARM_HDBSS_DEFAULT_SIZE  PAGE_SIZE
> > > > > +#define KVM_ARM_HDBSS_MAX_SIZE      SZ_2M
> > > > > +
> > > > > +/* 0 means unconfigured, fall back to one page per vCPU. */
> > > > > +static inline u32 kvm_hdbss_buffer_size(struct kvm *kvm)
> > > > > +{
> > > > > +	return kvm->arch.hdbss_buffer_size ?: KVM_ARM_HDBSS_DEFAULT_SIZE;
> > > > > +}
> > > > 
> > > > Why not set arch.hdbss_buffer_size to KVM_ARM_HDBSS_DEFAULT_SIZE at start,
> > > > instead of testing it here like this?
> > > > 
> > > 
> > > The size is set by userspace via ioctl, and we don't allow it to
> > > be set twice:
> > > 
> > > ```
> > > if (kvm->created_vcpus) {
> > > 	r = -EINVAL;
> > > } else if (kvm->arch.hdbss_buffer_size) {
> > > 	r = -EBUSY;
> > > } else {
> > > 	kvm->arch.hdbss_buffer_size = size;
> > > }
> > > ```
> > > 
> > > If we pre-fill the default at VM creation, hdbss_buffer_size is
> > > always non-zero and the -EBUSY branch would reject every attempt
> > > to set a size. The same 0 sentinel also gates the dirty-ring
> > > enable (a configured size conflicts with the ring), so it has to
> > > mean "not configured".
> > > 
> > 
> > It looks like there is a reason for us not to set the size more than
> > once. I have not figured it yet, do you mind sharing?
> > 
> > I ask because effectively what we are having here is the same effect:
> > kvm_hdbss_buffer_size() may return two different values depending on the
> > IOCTL being ran or not. So for it's users does it look like the expected
> > value changed mid way.
> > 
> > What I am trying to understand: is it safe for us to change the perceived
> > value once? (default -> whatever the user sets) In which scenario is it
> > safe?
> > 
> > In that case, can't we just allow that change to happen in that scenario,
> > instead of having a proxy function to return the ring size?
> > 
> > 
> 
> The size affects the dirty-ring reservation: when the ring is enabled, it
> reserves entries for the HDBSS buffer. Once the ring is allocated with that
> reservation, changing the HDBSS size would make the two inconsistent, and
> matching them dynamically isn't practical.
> 

Right, if it's just that, let's allow the buffer size to be set as long as 
no buffer is allocated then. I mean, not allowed to change buffer size if 
dirty-tracking is on. 

> In practice a larger buffer doesn't provide much benefit either: the buffer
> is flushed on every VM exit, so it rarely fills up.

It depends very much on the workload running in the VM, some VMs can 
benefit of larger buffers. If the workload is having very intensive memory 
activity, having a 2MB buffer instead of a 4k buffer means taking up to 
512x less faults.

> Setting it once, before
> the ring is allocated, is the simplest correct option.

Before the buffer is allocated: fully agree.

My point is that it looks weird to have a "can only be set once" scenario.
I suggest we try the "only set the buffers are allocated, or in process of 
being allocated".

Which, in the scenario above discussed, could be anytime dirty-tracking is 
disabled.

On the other hand, if your strategy for dirty-ring is to have the number of 
buffer entries being reserved in kvm's dirty-ring array, then we have (for 
dirty-ring) to disable setting the size once we allocate the dirty-ring 
buffer, which happens when we create the first vcpu, IIRC.

> 
> > > > > +
> > > > > +int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu);
> > > > > +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu);
> > > > > +
> > > > > +#endif /* __ARM64_KVM_DIRTY_BIT_H__ */
> > > > > diff --git a/arch/arm64/include/asm/kvm_host.h b/arch/arm64/include/asm/kvm_host.h
> > > > > index 86a4d6e50934..c8fc29f3db75 100644
> > > > > --- a/arch/arm64/include/asm/kvm_host.h
> > > > > +++ b/arch/arm64/include/asm/kvm_host.h
> > > > > @@ -425,6 +425,9 @@ struct kvm_arch {
> > > > >    	 */
> > > > >    	struct kvm_protected_vm pkvm;
> > > > > 
> > > > > +	/* HDBSS: per-VM buffer size in bytes (0 = not configured, use default) */
> > > > > +	u32 hdbss_buffer_size;
> > > > > +
> > > > >    #ifdef CONFIG_PTDUMP_STAGE2_DEBUGFS
> > > > >    	/* Nested virtualization info */
> > > > >    	struct dentry *debugfs_nv_dentry;
> > > > > @@ -844,6 +847,13 @@ struct vcpu_reset_state {
> > > > >    	bool		reset;
> > > > >    };
> > > > > 
> > > > > +struct vcpu_hdbss_state {
> > > > > +	struct page *hdbss_pg;		/* HDBSS buffer */
> > > > > +	u64 hdbssbr_el2;		/* programmed into the CPU on load */
> > > > > +	u64 hdbssprod_el2;		/* producer index, saved on put */
> > > > > +	unsigned int buddy_order;	/* allocation order for __free_pages() */
> > > > > +};
> > > > > +
> > > > >    struct vncr_tlb;
> > > > > 
> > > > >    struct kvm_vcpu_arch {
> > > > > @@ -951,6 +961,9 @@ struct kvm_vcpu_arch {
> > > > > 
> > > > >    	/* Hyp-readable copy of kvm_vcpu::pid */
> > > > >    	pid_t pid;
> > > > > +
> > > > > +	/* HDBSS buffer state */
> > > > > +	struct vcpu_hdbss_state hdbss;
> > > > >    };
> > > > > 
> > > > >    /*
> > > > > diff --git a/arch/arm64/include/asm/sysreg.h b/arch/arm64/include/asm/sysreg.h
> > > > > index 7aa08d59d494..7c71560b57e4 100644
> > > > > --- a/arch/arm64/include/asm/sysreg.h
> > > > > +++ b/arch/arm64/include/asm/sysreg.h
> > > > > @@ -1039,6 +1039,15 @@
> > > > > 
> > > > >    #define GCS_CAP(x)	((((unsigned long)x) & GCS_CAP_ADDR_MASK) | \
> > > > >    					       GCS_CAP_VALID_TOKEN)
> > > > > +
> > > > > +/*
> > > > > + * Definitions for the HDBSS feature
> > > > > + */
> > > > > +#define HDBSSBR_EL2(baddr, sz)	(((baddr) & HDBSSBR_EL2_BADDR_MASK) | \
> > > > > +				 FIELD_PREP(HDBSSBR_EL2_SZ_MASK, sz))
> > > > > +
> > > > > +#define HDBSSPROD_IDX(prod)	FIELD_GET(HDBSSPROD_EL2_INDEX_MASK, prod)
> > > > > +
> > > > >    /*
> > > > >     * Definitions for GICv5 instructions
> > > > >     */
> > > > > diff --git a/arch/arm64/kvm/Makefile b/arch/arm64/kvm/Makefile
> > > > > index 59612d2f277c..ec2749af64fa 100644
> > > > > --- a/arch/arm64/kvm/Makefile
> > > > > +++ b/arch/arm64/kvm/Makefile
> > > > > @@ -18,6 +18,7 @@ kvm-y += arm.o mmu.o mmio.o psci.o hypercalls.o pvtime.o \
> > > > >    	 guest.o debug.o reset.o sys_regs.o stacktrace.o \
> > > > >    	 vgic-sys-reg-v3.o fpsimd.o pkvm.o \
> > > > >    	 arch_timer.o trng.o vmid.o emulate-nested.o nested.o at.o \
> > > > > +	 dirty_bit.o \
> > > > >    	 vgic/vgic.o vgic/vgic-init.o \
> > > > >    	 vgic/vgic-irqfd.o vgic/vgic-v2.o \
> > > > >    	 vgic/vgic-v3.o vgic/vgic-v4.o \
> > > > > diff --git a/arch/arm64/kvm/arm.c b/arch/arm64/kvm/arm.c
> > > > > index d9ad765943d9..5ea4ac26995e 100644
> > > > > --- a/arch/arm64/kvm/arm.c
> > > > > +++ b/arch/arm64/kvm/arm.c
> > > > > @@ -36,6 +36,7 @@
> > > > >    #include <asm/virt.h>
> > > > >    #include <asm/kvm_arm.h>
> > > > >    #include <asm/kvm_asm.h>
> > > > > +#include <asm/kvm_dirty_bit.h>
> > > > >    #include <asm/kvm_emulate.h>
> > > > >    #include <asm/kvm_hyp.h>
> > > > >    #include <asm/kvm_mmu.h>
> > > > > @@ -580,10 +581,19 @@ int kvm_arch_vcpu_create(struct kvm_vcpu *vcpu)
> > > > >    	}
> > > > > 
> > > > >    	err = kvm_share_hyp(vcpu, vcpu + 1);
> > > > > -	if (err)
> > > > > +	if (err) {
> > > > >    		kvm_vgic_vcpu_destroy(vcpu);
> > > > > +		return err;
> > > > > +	}
> > > > > 
> > > > > -	return err;
> > > > > +	err = kvm_arm_vcpu_alloc_hdbss(vcpu);
> > > > > +	if (err) {
> > > > > +		kvm_unshare_hyp(vcpu, vcpu + 1);
> > > > > +		kvm_vgic_vcpu_destroy(vcpu);
> > > > > +		return err;
> > > > > +	}
> > > > > +
> > > > > +	return 0;
> > > > >    }
> > > > > 
> > > > >    void kvm_arch_vcpu_postcreate(struct kvm_vcpu *vcpu)
> > > > > diff --git a/arch/arm64/kvm/dirty_bit.c b/arch/arm64/kvm/dirty_bit.c
> > > > > new file mode 100644
> > > > > index 000000000000..f9aeb9f34ad0
> > > > > --- /dev/null
> > > > > +++ b/arch/arm64/kvm/dirty_bit.c
> > > > > @@ -0,0 +1,55 @@
> > > > > +// SPDX-License-Identifier: GPL-2.0-only
> > > > > +/*
> > > > > + * Per-vCPU HDBSS buffer management.
> > > > > + *
> > > > > + * Copyright (C) 2026 Huawei Technologies Co., Ltd
> > > > > + * Author: Tian Zheng <zhengtian10@huawei.com>
> > > > > + */
> > > > > +
> > > > > +#include <asm/kvm_dirty_bit.h>
> > > > > +#include <asm/kvm_mmu.h>
> > > > > +#include <asm/sysreg.h>
> > > > > +#include <linux/gfp.h>
> > > > > +#include <linux/kconfig.h>
> > > > > +#include <linux/log2.h>
> > > > > +#include <linux/mm.h>
> > > > > +
> > > > > +int kvm_arm_vcpu_alloc_hdbss(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	struct page *hdbss_pg;
> > > > > +	u32 size;
> > > > > +	unsigned int buddy_order;
> > > > > +	u32 sz_encoded;
> > > > > +
> > > > > +	if (vcpu->arch.hdbss.hdbss_pg || !system_supports_hdbss())
> > > > > +		return 0;
> > > > > +
> > > > > +	size = kvm_hdbss_buffer_size(vcpu->kvm);
> > > > > +
> > > > > +	buddy_order = get_order(size);
> > > > > +	sz_encoded = ilog2(size) - 12;
> > > > > +
> > > > > +	hdbss_pg = alloc_pages(GFP_KERNEL_ACCOUNT | __GFP_ZERO, buddy_order);
> > > > > +	if (!hdbss_pg)
> > > > > +		return -ENOMEM;
> > > > > +
> > > > > +	vcpu->arch.hdbss = (struct vcpu_hdbss_state) {
> > > > > +		.hdbss_pg = hdbss_pg,
> > > > > +		.hdbssbr_el2 = HDBSSBR_EL2(page_to_phys(hdbss_pg), sz_encoded),
> > > > > +		.hdbssprod_el2 = 0,
> > > > > +		.buddy_order = buddy_order,
> > > > > +	};
> > > > > +
> > > > > +	return 0;
> > > > > +}
> > > > > +
> > > > > +void kvm_arm_vcpu_free_hdbss(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	if (!vcpu->arch.hdbss.hdbss_pg)
> > > > > +		return;
> > > > > +
> > > > > +	__free_pages(vcpu->arch.hdbss.hdbss_pg, vcpu->arch.hdbss.buddy_order);
> > > > > +
> > > > > +	vcpu->arch.hdbss.hdbss_pg = NULL;
> > > > > +	vcpu->arch.hdbss.hdbssbr_el2 = 0;
> > > > > +}
> > > > > diff --git a/arch/arm64/kvm/hyp/vhe/switch.c b/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > index 7875911c0506..922fc9260e11 100644
> > > > > --- a/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > +++ b/arch/arm64/kvm/hyp/vhe/switch.c
> > > > > @@ -19,6 +19,7 @@
> > > > >    #include <asm/cpufeature.h>
> > > > >    #include <asm/kprobes.h>
> > > > >    #include <asm/kvm_asm.h>
> > > > > +#include <asm/kvm_dirty_bit.h>
> > > > >    #include <asm/kvm_emulate.h>
> > > > >    #include <asm/kvm_hyp.h>
> > > > >    #include <asm/kvm_mmu.h>
> > > > > @@ -219,6 +220,17 @@ static void __vcpu_put_deactivate_traps(struct kvm_vcpu *vcpu)
> > > > >    	local_irq_restore(flags);
> > > > >    }
> > > > > 
> > > > > +static void __load_hdbss(struct kvm_vcpu *vcpu)
> > > > > +{
> > > > > +	if (!vcpu->arch.hdbss.hdbss_pg)
> > > > > +		return;
> > > > > +
> > > > > +	write_sysreg_s(vcpu->arch.hdbss.hdbssbr_el2, SYS_HDBSSBR_EL2);
> > > > > +	write_sysreg_s(vcpu->arch.hdbss.hdbssprod_el2, SYS_HDBSSPROD_EL2);
> > > > > +
> > > > > +	isb();
> > > > > +}
> > > > > +
> > > > >    void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
> > > > >    {
> > > > >    	host_data_ptr(host_ctxt)->__hyp_running_vcpu = vcpu;
> > > > > @@ -226,10 +238,15 @@ void kvm_vcpu_load_vhe(struct kvm_vcpu *vcpu)
> > > > >    	__vcpu_load_switch_sysregs(vcpu);
> > > > >    	__vcpu_load_activate_traps(vcpu);
> > > > >    	__load_stage2(vcpu->arch.hw_mmu);
> > > > > +	__load_hdbss(vcpu);
> > > > >    }
> > > > > 
> > > > >    void kvm_vcpu_put_vhe(struct kvm_vcpu *vcpu)
> > > > >    {
> > > > > +	/* Saved under the same ownership condition as __load_hdbss(). */
> > > > > +	if (vcpu->arch.hdbss.hdbss_pg)
> > > > > +		vcpu->arch.hdbss.hdbssprod_el2 = read_sysreg_s(SYS_HDBSSPROD_EL2);
> > > > 
> > > > Above suggestion would need you to reload HDBSSBR_EL2 as well.
> > > > 
> > > 
> > > Right, that reload is part of the ordering obligation above.
> > > 
> > > I think keeping the allocation at vCPU creation is simpler, but
> > > let me know what you think.
> > > 
> > 
> > I fully agree it's simpler, but we have to carry those per-cpu buffers
> > (that can go up to 2M each) for the whole life of the VM, which can be a
> > lot on a big VM.
> > 
> > That being said, I'm not against it. But I think we should resort to it
> > only if we have a compelling reason not to allocate/free on demand.
> > 
> > What do you think?
> > 
> > Thanks!
> > Leo
> 
> Yes, I agree. My answer is the same as the one below.
> 

Awesome, thanks for the discussion!
Leo
